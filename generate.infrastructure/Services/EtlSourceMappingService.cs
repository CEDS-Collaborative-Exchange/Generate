using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using generate.core.Dtos.App;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Interfaces.Services;
using generate.core.Models.App;
using generate.core.Models.RDS;

namespace generate.infrastructure.Services
{
    /// <summary>
    /// ETL Checklist source mapping workflow (CIID-9033, epic CIID-9029): upload of a state's bespoke
    /// data dictionary, CEDS automapping via ICedsAutoMapService, review decisions, and export of the
    /// completed checklist joined to the Generate destination metadata in App.EtlMetadata.
    /// </summary>
    public class EtlSourceMappingService : IEtlSourceMappingService
    {
        // Default minimum confidence for a direct element match to be suggested; below this the
        // automapper falls back to option-set-value matching. Configurable via
        // CedsAutoMap:ElementMatchThreshold (CIID-9057).
        private const decimal DefaultElementMatchThreshold = 0.60m;
        // Minimum confidence for a candidate to be returned for review
        private const decimal CandidateThreshold = 0.2m;

        private readonly IAppRepository _appRepository;
        private readonly IRDSRepository _rdsRepository;
        private readonly ICedsAutoMapService _cedsAutoMapService;
        private readonly ICedsStagingCatalogProvider _catalogProvider;
        private readonly CedsEmbeddingModelProvider _embeddingModel;
        private readonly decimal _elementMatchThreshold;
        private readonly string _connectionString;

        // During an automap pass, the Staging tables the map's file spec requires. When set (non-empty),
        // NarrowStagingCandidates drops candidate columns in any OTHER table so a source element only maps
        // to tables the file spec actually loads. Null/empty = no file spec resolved → no filtering.
        private HashSet<string> _requiredStagingTables;
        private readonly int _referenceDataSchoolYear;

        public EtlSourceMappingService(
            IAppRepository appRepository,
            IRDSRepository rdsRepository,
            ICedsAutoMapService cedsAutoMapService,
            ICedsStagingCatalogProvider catalogProvider = null,
            Microsoft.Extensions.Configuration.IConfiguration configuration = null,
            CedsEmbeddingModelProvider embeddingModel = null)
        {
            _appRepository = appRepository;
            _rdsRepository = rdsRepository;
            _cedsAutoMapService = cedsAutoMapService;
            _catalogProvider = catalogProvider;
            _embeddingModel = embeddingModel;
            _connectionString = configuration?["Data:AppDbContextConnection"];

            _elementMatchThreshold = DefaultElementMatchThreshold;
            string configured = configuration?["CedsAutoMap:ElementMatchThreshold"];
            if (!string.IsNullOrWhiteSpace(configured) &&
                decimal.TryParse(configured, NumberStyles.Any, CultureInfo.InvariantCulture, out var threshold) &&
                threshold > 0m && threshold <= 1m)
            {
                _elementMatchThreshold = threshold;
            }

            // Reference-data mappings are keyed by school year (staging-to-fact copies forward if
            // a later year is missing). Configurable via CedsAutoMap:ReferenceDataSchoolYear.
            _referenceDataSchoolYear = int.TryParse(configuration?["CedsAutoMap:ReferenceDataSchoolYear"], out var yr) && yr > 1900
                ? yr
                : 2026;
        }

        /// <summary>True when the ontology + Staging catalog is available (else legacy EtlMetadata).</summary>
        private bool UseOntologyCatalog => _catalogProvider != null && _catalogProvider.IsAvailable;

        public List<EtlSourceElementMappingResultDto> UploadDataDictionary(EtlSourceMappingUploadDto upload)
        {
            var results = new List<EtlSourceElementMappingResultDto>();

            if (upload == null || upload.Elements == null || upload.Elements.Count == 0)
            {
                return results;
            }

            // CEDS element catalog: ontology ∩ Staging when available, else legacy EtlMetadata
            var catalog = GetCedsElementCatalog();
            var fallbackCatalog = UseOntologyCatalog
                ? _catalogProvider.GetOptionValueFallbackCatalog()
                : new List<CedsElementCatalogDto>();

            EtlMap etlMap = null;

            if (upload.EtlMapId.HasValue)
            {
                // Append the upload to an existing map
                etlMap = _appRepository
                    .Find<EtlMap>(m => m.EtlMapId == upload.EtlMapId.Value, 0, 0)
                    .FirstOrDefault();

                if (etlMap != null)
                {
                    etlMap.UploadFileName = upload.UploadFileName ?? etlMap.UploadFileName;
                    etlMap.ModifiedDate = DateTime.UtcNow;
                    etlMap.ModifiedBy = upload.UploadedBy;
                }
            }

            if (etlMap == null)
            {
                etlMap = new EtlMap
                {
                    MapName = !string.IsNullOrWhiteSpace(upload.MapName)
                        ? upload.MapName.Trim()
                        : (!string.IsNullOrWhiteSpace(upload.UploadFileName) ? upload.UploadFileName : "Data Dictionary Map"),
                    UploadFileName = upload.UploadFileName,
                    CreatedDate = DateTime.UtcNow,
                    CreatedBy = upload.UploadedBy
                };

                _appRepository.Create(etlMap);
            }

            // Idempotent re-upload: skip elements already in the map so re-uploading the same document
            // doesn't duplicate mappings. Identity = source element name + source table + source column
            // (normalized), which uniquely identifies a source data-dictionary element.
            var existingKeys = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            if (upload.EtlMapId.HasValue)
            {
                foreach (var m in _appRepository.FindReadOnly<EtlSourceElementMapping>(m => m.EtlMapId == upload.EtlMapId.Value, 0, 0))
                {
                    existingKeys.Add(ElementKey(m.SourceElementName, m.SourceTableName, m.SourceColumnName));
                }
            }

            // Restrict automap Staging targets to the tables this map's file spec actually loads.
            _requiredStagingTables = etlMap.EtlMapId > 0 ? GetRequiredStagingTables(etlMap.EtlMapId) : null;

            foreach (var element in upload.Elements.Where(e => e != null && !string.IsNullOrWhiteSpace(e.SourceElementName)))
            {
                // Skip elements already present (from a prior upload of the same document, or repeated in this file).
                if (!existingKeys.Add(ElementKey(element.SourceElementName, element.SourceTableName, element.SourceColumnName)))
                {
                    continue;
                }

                var mapping = new EtlSourceElementMapping
                {
                    EtlMap = etlMap,
                    SourceCommonName = element.SourceCommonName,
                    SourceTechnicalName = element.SourceTechnicalName,
                    SourceDatabaseName = element.SourceDatabaseName,
                    SourceSchemaName = element.SourceSchemaName,
                    SourceTableName = element.SourceTableName,
                    SourceColumnName = element.SourceColumnName,
                    SourceElementName = element.SourceElementName,
                    SourceElementDefinition = element.SourceElementDefinition,
                    SourceDataType = element.SourceDataType,
                    SourceDataLength = element.SourceDataLength,
                    SourceDataSteward = element.SourceDataSteward,
                    SelectionCriteria = element.SelectionCriteria,
                    TransformationRules = element.TransformationRules,
                    Notes = element.Notes,
                    MappingStatus = EtlMappingStatus.Unmapped,
                    UploadFileName = upload.UploadFileName,
                    CreatedDate = DateTime.UtcNow,
                    CreatedBy = upload.UploadedBy,
                    EtlSourceOptionSetMappings = (element.OptionSetValues ?? new List<EtlSourceOptionSetValueUploadDto>())
                        .Where(v => v != null && (!string.IsNullOrWhiteSpace(v.SourceOptionSetCode) || !string.IsNullOrWhiteSpace(v.SourceOptionSetDescription)))
                        .Select(v => new EtlSourceOptionSetMapping
                        {
                            SourceOptionSetCode = v.SourceOptionSetCode,
                            SourceOptionSetDescription = v.SourceOptionSetDescription,
                            MappingStatus = EtlMappingStatus.Unmapped,
                            CreatedDate = DateTime.UtcNow
                        })
                        .ToList()
                };

                var candidates = AutomapElement(mapping, catalog, fallbackCatalog);

                _appRepository.Create(mapping);

                results.Add(new EtlSourceElementMappingResultDto
                {
                    Mapping = mapping,
                    Candidates = candidates
                });
            }

            _requiredStagingTables = null; // clear per-pass filter
            _appRepository.Save();

            return results;
        }

        // Stable identity of a source data-dictionary element within a map: element name + source
        // table + source column, normalized (trim + case-insensitive). Used to de-duplicate re-uploads.
        private static string ElementKey(string elementName, string sourceTable, string sourceColumn)
        {
            string N(string s) => (s ?? string.Empty).Trim();
            return N(elementName) + "|" + N(sourceTable) + "|" + N(sourceColumn);
        }

        public List<EtlMapDto> GetMaps()
        {
            return _appRepository
                .GetAllReadOnly<EtlMap>(0, 0, m => m.EtlSourceElementMappings, m => m.EtlMapFileSpecs)
                .Select(ToMapDto)
                .OrderByDescending(m => m.ModifiedDate ?? m.CreatedDate)
                .ToList();
        }

        public EtlMapDto CreateMap(EtlMapSaveDto save)
        {
            if (save == null || string.IsNullOrWhiteSpace(save.MapName))
            {
                throw new ArgumentException("A map name is required.");
            }

            var etlMap = new EtlMap
            {
                MapName = save.MapName.Trim(),
                CreatedDate = DateTime.UtcNow,
                CreatedBy = save.ModifiedBy,
                EtlMapFileSpecs = BuildFileSpecs(save.FileSpecs)
            };

            _appRepository.Create(etlMap);
            _appRepository.Save();

            return ToMapDto(etlMap);
        }

        public EtlMapDto UpdateMap(int etlMapId, EtlMapSaveDto save)
        {
            if (save == null)
            {
                return null;
            }

            var etlMap = _appRepository
                .Find<EtlMap>(m => m.EtlMapId == etlMapId, 0, 0, m => m.EtlMapFileSpecs, m => m.EtlSourceElementMappings)
                .FirstOrDefault();

            if (etlMap == null)
            {
                return null;
            }

            if (!string.IsNullOrWhiteSpace(save.MapName))
            {
                etlMap.MapName = save.MapName.Trim();
            }

            if (save.FileSpecs != null)
            {
                // Replace the file spec associations
                if (etlMap.EtlMapFileSpecs != null && etlMap.EtlMapFileSpecs.Count > 0)
                {
                    _appRepository.DeleteRange(etlMap.EtlMapFileSpecs.ToList());
                }

                etlMap.EtlMapFileSpecs = BuildFileSpecs(save.FileSpecs);
            }

            etlMap.ModifiedDate = DateTime.UtcNow;
            etlMap.ModifiedBy = save.ModifiedBy;

            _appRepository.Save();

            return ToMapDto(etlMap);
        }

        public List<FactTypeDto> GetFactTypes()
        {
            return _rdsRepository
                .GetAllReadOnly<DimFactType>(0, 0)
                .Where(f => f.DimFactTypeId > 0 && !string.IsNullOrWhiteSpace(f.FactTypeCode))
                .Select(f => new FactTypeDto
                {
                    DimFactTypeId = f.DimFactTypeId,
                    FactTypeCode = f.FactTypeCode,
                    FactTypeDescription = f.FactTypeDescription,
                    FactTypeLabel = f.FactTypeLabel
                })
                .OrderBy(f => f.FactTypeLabel ?? f.FactTypeCode, StringComparer.OrdinalIgnoreCase)
                .ToList();
        }

        public List<string> GetFileSpecNumbers()
        {
            // EDFacts_File_Spec_Number values may hold a single spec or a comma-separated list
            return LoadMetadata()
                .Where(m => !string.IsNullOrWhiteSpace(m.EdFactsFileSpecNumber))
                .SelectMany(m => m.EdFactsFileSpecNumber.Split(','))
                .Select(s => s.Trim())
                .Where(s => s.Length > 0)
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .OrderBy(s => s, StringComparer.OrdinalIgnoreCase)
                .ToList();
        }

        private List<EtlMapFileSpec> BuildFileSpecs(List<EtlMapFileSpecDto> fileSpecs)
        {
            var result = new List<EtlMapFileSpec>();

            if (fileSpecs == null)
            {
                return result;
            }

            // Resolve denormalized fact type codes once when any are needed
            List<FactTypeDto> factTypes = null;

            foreach (var spec in fileSpecs.Where(s => s != null &&
                (!string.IsNullOrWhiteSpace(s.FileSpecNumber) || s.DimFactTypeId.HasValue)))
            {
                string factTypeCode = spec.FactTypeCode;

                if (spec.DimFactTypeId.HasValue && string.IsNullOrWhiteSpace(factTypeCode))
                {
                    factTypes = factTypes ?? GetFactTypes();
                    factTypeCode = factTypes.FirstOrDefault(f => f.DimFactTypeId == spec.DimFactTypeId.Value)?.FactTypeCode;
                }

                result.Add(new EtlMapFileSpec
                {
                    FileSpecNumber = string.IsNullOrWhiteSpace(spec.FileSpecNumber) ? null : spec.FileSpecNumber.Trim(),
                    DimFactTypeId = spec.DimFactTypeId,
                    FactTypeCode = factTypeCode,
                    CreatedDate = DateTime.UtcNow
                });
            }

            return result;
        }

        private static EtlMapDto ToMapDto(EtlMap m)
        {
            return new EtlMapDto
            {
                EtlMapId = m.EtlMapId,
                MapName = m.MapName,
                UploadFileName = m.UploadFileName,
                JoinInstructions = m.JoinInstructions,
                ProcessingNotes = m.ProcessingNotes,
                CreatedDate = m.CreatedDate,
                CreatedBy = m.CreatedBy,
                ModifiedDate = m.ModifiedDate,
                ModifiedBy = m.ModifiedBy,
                ElementCount = m.EtlSourceElementMappings?.Count ?? 0,
                MappedElementCount = m.EtlSourceElementMappings?.Count(e =>
                    e.MappingStatus == EtlMappingStatus.Accepted || e.MappingStatus == EtlMappingStatus.Suggested) ?? 0,
                FileSpecs = (m.EtlMapFileSpecs ?? new List<EtlMapFileSpec>())
                    .Select(s => new EtlMapFileSpecDto
                    {
                        FileSpecNumber = s.FileSpecNumber,
                        DimFactTypeId = s.DimFactTypeId,
                        FactTypeCode = s.FactTypeCode
                    })
                    .ToList()
            };
        }

        public List<EtlSourceElementMapping> GetAllMappings(int? etlMapId = null)
        {
            var mappings = etlMapId.HasValue
                ? _appRepository.FindReadOnly<EtlSourceElementMapping>(m => m.EtlMapId == etlMapId.Value, 0, 0, m => m.EtlSourceOptionSetMappings)
                : _appRepository.GetAllReadOnly<EtlSourceElementMapping>(0, 0, m => m.EtlSourceOptionSetMappings);

            return mappings
                .OrderBy(m => m.EtlSourceElementMappingId)
                .ToList();
        }

        public bool DeleteMap(int etlMapId)
        {
            var etlMap = _appRepository
                .Find<EtlMap>(m => m.EtlMapId == etlMapId, 0, 0)
                .FirstOrDefault();

            if (etlMap == null)
            {
                return false;
            }

            // Element and option set rows are removed by the ON DELETE CASCADE foreign keys.
            _appRepository.DeleteRange(new[] { etlMap });
            _appRepository.Save();
            return true;
        }

        public List<EtlMapSource> GetMapSources(int etlMapId)
        {
            return _appRepository
                .FindReadOnly<EtlMapSource>(s => s.EtlMapId == etlMapId, 0, 0)
                .OrderBy(s => s.EtlMapSourceId)
                .ToList();
        }

        public EtlMapSource SaveMapSource(EtlMapSource source)
        {
            if (source == null || source.EtlMapId <= 0)
            {
                return null;
            }

            // Prevent duplicate source datasets on a map: a source object may be registered only once per
            // map (case-insensitive, trimmed). On create, if it already exists, return the existing row
            // (idempotent — no duplicate). On rename, block a collision with a different existing source.
            string normObject = (source.SourceObject ?? string.Empty).Trim();
            if (normObject.Length > 0)
            {
                var duplicate = GetMapSources(source.EtlMapId)
                    .FirstOrDefault(s => s.EtlMapSourceId != source.EtlMapSourceId
                        && string.Equals((s.SourceObject ?? string.Empty).Trim(), normObject, StringComparison.OrdinalIgnoreCase));
                if (duplicate != null)
                {
                    // Already registered (or a rename would collide) — return the existing row, create nothing.
                    return duplicate;
                }
            }

            if (source.EtlMapSourceId > 0)
            {
                var existing = _appRepository
                    .Find<EtlMapSource>(s => s.EtlMapSourceId == source.EtlMapSourceId, 0, 0)
                    .FirstOrDefault();
                if (existing == null)
                {
                    return null;
                }
                bool objectChanged = !string.Equals((existing.SourceObject ?? "").Trim(), (source.SourceObject ?? "").Trim(),
                    StringComparison.OrdinalIgnoreCase);
                existing.SourceName = source.SourceName;
                existing.SourceConnection = source.SourceConnection;
                existing.SourceObject = source.SourceObject;
                existing.Notes = source.Notes;
                existing.ModifiedDate = DateTime.UtcNow;
                existing.ModifiedBy = source.ModifiedBy;
                TouchMap(existing.EtlMapId, source.ModifiedBy);
                _appRepository.Save();
                // Changing the source object re-initializes the automapper for the new object's columns.
                if (objectChanged) { AutomapSourceColumns(existing.EtlMapId, existing, source.ModifiedBy); }
                return existing;
            }

            source.CreatedDate = DateTime.UtcNow;
            _appRepository.Create(source);
            TouchMap(source.EtlMapId, source.CreatedBy);
            _appRepository.Save();
            // Adding a source initializes the automapper for its columns (element match + narrowed Staging
            // targets + option-set suggestions), same as upload — so the reviewer starts from an automapped set.
            AutomapSourceColumns(source.EtlMapId, source, source.CreatedBy);
            return source;
        }

        public bool DeleteMapSource(int etlMapSourceId)
        {
            var source = _appRepository
                .Find<EtlMapSource>(s => s.EtlMapSourceId == etlMapSourceId, 0, 0)
                .FirstOrDefault();
            if (source == null)
            {
                return false;
            }
            int mapId = source.EtlMapId;
            _appRepository.DeleteRange(new[] { source });
            TouchMap(mapId, null);
            _appRepository.Save();
            return true;
        }

        public List<EtlMapJoin> GetMapJoins(int etlMapId)
        {
            return _appRepository
                .FindReadOnly<EtlMapJoin>(j => j.EtlMapId == etlMapId, 0, 0)
                .OrderBy(j => j.LeftSourceObject).ThenBy(j => j.RightSourceObject).ThenBy(j => j.SortOrder).ThenBy(j => j.EtlMapJoinId)
                .ToList();
        }

        public EtlMapJoin SaveMapJoin(EtlMapJoin join)
        {
            if (join == null || join.EtlMapId <= 0)
            {
                return null;
            }
            if (string.IsNullOrWhiteSpace(join.JoinType))
            {
                join.JoinType = "LEFT";
            }

            if (join.EtlMapJoinId > 0)
            {
                var existing = _appRepository
                    .Find<EtlMapJoin>(j => j.EtlMapJoinId == join.EtlMapJoinId, 0, 0)
                    .FirstOrDefault();
                if (existing == null)
                {
                    return null;
                }
                existing.LeftSourceObject = join.LeftSourceObject;
                existing.LeftColumn = join.LeftColumn;
                existing.RightSourceObject = join.RightSourceObject;
                existing.RightColumn = join.RightColumn;
                existing.JoinType = join.JoinType;
                existing.SortOrder = join.SortOrder;
                existing.ModifiedDate = DateTime.UtcNow;
                existing.ModifiedBy = join.ModifiedBy;
                TouchMap(existing.EtlMapId, join.ModifiedBy);
                _appRepository.Save();
                return existing;
            }

            join.CreatedDate = DateTime.UtcNow;
            _appRepository.Create(join);
            TouchMap(join.EtlMapId, join.CreatedBy);
            _appRepository.Save();
            return join;
        }

        public bool DeleteMapJoin(int etlMapJoinId)
        {
            var join = _appRepository
                .Find<EtlMapJoin>(j => j.EtlMapJoinId == etlMapJoinId, 0, 0)
                .FirstOrDefault();
            if (join == null)
            {
                return false;
            }
            int mapId = join.EtlMapId;
            _appRepository.DeleteRange(new[] { join });
            TouchMap(mapId, null);
            _appRepository.Save();
            return true;
        }

        public EtlMapDto SaveMapGuidance(int etlMapId, EtlMapGuidanceDto guidance)
        {
            if (guidance == null)
            {
                return null;
            }
            var etlMap = _appRepository.Find<EtlMap>(m => m.EtlMapId == etlMapId, 0, 0).FirstOrDefault();
            if (etlMap == null)
            {
                return null;
            }
            etlMap.JoinInstructions = guidance.JoinInstructions;
            etlMap.ProcessingNotes = guidance.ProcessingNotes;
            etlMap.ModifiedDate = DateTime.UtcNow;
            etlMap.ModifiedBy = guidance.ModifiedBy;
            _appRepository.Save();
            return ToMapDto(etlMap);
        }

        // Each of a map's source objects (registered EtlMapSource rows, else derived from the element
        // mappings' SourceSchema.SourceTable) with its physical column list read from INFORMATION_SCHEMA —
        // the join builder needs real columns, including ones not mapped as elements.
        public List<EtlMapSourceSchemaDto> GetMapSourceSchema(int etlMapId)
        {
            // Distinct source objects: registered first, else derived from the mappings.
            var byObject = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase); // object -> friendly name
            foreach (var s in GetMapSources(etlMapId))
            {
                if (!string.IsNullOrWhiteSpace(s.SourceObject))
                {
                    byObject[s.SourceObject.Trim()] = string.IsNullOrWhiteSpace(s.SourceName) ? s.SourceObject.Trim() : s.SourceName;
                }
            }
            if (byObject.Count == 0)
            {
                foreach (var m in GetAllMappings(etlMapId))
                {
                    if (string.IsNullOrWhiteSpace(m.SourceTableName)) continue;
                    string schema = string.IsNullOrWhiteSpace(m.SourceSchemaName) ? "" : m.SourceSchemaName.Trim() + ".";
                    string obj = schema + m.SourceTableName.Trim();
                    if (!byObject.ContainsKey(obj)) byObject[obj] = obj;
                }
            }

            var result = new List<EtlMapSourceSchemaDto>();
            foreach (var kvp in byObject)
            {
                result.Add(new EtlMapSourceSchemaDto
                {
                    SourceObject = kvp.Key,
                    SourceName = kvp.Value,
                    Columns = GetObjectColumns(kvp.Key)
                });
            }
            return result;
        }

        // Run the CEDS automapper on ONE element mapping: best element match -> apply CEDS fields + narrowed
        // Staging targets + suggested option-set values; falls back to option-set-VALUE matching when there is
        // no confident element match. Returns the ranked candidates (for the upload review UI). Shared by the
        // upload flow AND the source-change flow so both automap identically.
        private List<CedsElementMatchDto> AutomapElement(EtlSourceElementMapping mapping,
            List<CedsElementCatalogDto> catalog, List<CedsElementCatalogDto> fallbackCatalog)
        {
            var candidates = _cedsAutoMapService.MatchElement(
                mapping.SourceElementName, mapping.SourceElementDefinition, catalog, 5, CandidateThreshold);

            var topCandidate = candidates.FirstOrDefault();

            if (topCandidate != null && topCandidate.Confidence >= _elementMatchThreshold)
            {
                // Confident direct element match
                ApplyCedsElement(mapping, topCandidate);
                mapping.StagingTableColumns = JoinStaging(
                    NarrowStagingCandidates(mapping.SourceElementName, mapping.SourceColumnName, topCandidate.StagingTableColumns));
                mapping.MatchConfidence = topCandidate.Confidence;
                mapping.MatchType = EtlMatchType.Suggested;
                mapping.MappingStatus = EtlMappingStatus.Suggested;

                SuggestOptionSetMappings(mapping, includeAccepted: true,
                    cedsOptionSetValues: GetCedsOptionSetValues(topCandidate.CedsElementGlobalId));
            }
            else if (fallbackCatalog.Count > 0)
            {
                // No confident element match: look for an option set VALUE that matches the source
                // definition, and if found map to that value's CEDS option set class.
                var valueMatch = _cedsAutoMapService
                    .MatchElement(mapping.SourceElementName, mapping.SourceElementDefinition, fallbackCatalog, 1, CandidateThreshold)
                    .FirstOrDefault();

                if (valueMatch != null && valueMatch.Confidence >= _elementMatchThreshold)
                {
                    var scheme = _catalogProvider.GetElementByGlobalId(valueMatch.CedsElementGlobalId);

                    if (scheme != null)
                    {
                        ApplyCedsElement(mapping, scheme);
                        mapping.StagingTableColumns = JoinStaging(
                            NarrowStagingCandidates(mapping.SourceElementName, mapping.SourceColumnName, scheme.StagingTableColumns));
                        mapping.MatchConfidence = valueMatch.Confidence;
                        mapping.MatchType = EtlMatchType.OptionSetValue;
                        mapping.MappingStatus = EtlMappingStatus.Suggested;

                        SuggestOptionSetMappings(mapping, includeAccepted: true,
                            cedsOptionSetValues: GetCedsOptionSetValues(scheme.CedsElementGlobalId));
                    }
                }
            }

            return candidates;
        }

        // When a source is added or its object changes, auto-generate element mappings for the source's
        // physical columns that aren't already mapped on this map, running the SAME automapper as upload
        // (element match + narrowed Staging targets + option-set suggestions). So changing the source
        // initializes the automapper instead of leaving the reviewer to hand-add every column.
        private void AutomapSourceColumns(int etlMapId, EtlMapSource source, string modifiedBy)
        {
            if (source == null || string.IsNullOrWhiteSpace(source.SourceObject)) return;
            var columns = GetObjectColumns(source.SourceObject);
            if (columns.Count == 0) return;

            // Don't duplicate columns already represented on this map (by source column name).
            var existing = new HashSet<string>(
                GetAllMappings(etlMapId).Select(m => (m.SourceColumnName ?? "").Trim()),
                StringComparer.OrdinalIgnoreCase);

            var catalog = GetCedsElementCatalog();
            var fallbackCatalog = UseOntologyCatalog
                ? _catalogProvider.GetOptionValueFallbackCatalog()
                : new List<CedsElementCatalogDto>();

            string obj = source.SourceObject.Trim();
            string schema = null, table = obj;
            int dot = obj.LastIndexOf('.');
            if (dot > 0) { schema = obj.Substring(0, dot); table = obj.Substring(dot + 1); }

            bool any = false;
            foreach (var col in columns)
            {
                if (string.IsNullOrWhiteSpace(col) || existing.Contains(col.Trim())) continue;

                var mapping = new EtlSourceElementMapping
                {
                    EtlMapId = etlMapId,
                    SourceSchemaName = schema,
                    SourceTableName = table,
                    SourceColumnName = col,
                    SourceElementName = col,   // live source: the physical column name is the element name
                    MappingStatus = EtlMappingStatus.Unmapped,
                    CreatedDate = DateTime.UtcNow,
                    CreatedBy = modifiedBy,
                    EtlSourceOptionSetMappings = new List<EtlSourceOptionSetMapping>()
                };

                AutomapElement(mapping, catalog, fallbackCatalog);
                _appRepository.Create(mapping);
                existing.Add(col.Trim());
                any = true;
            }

            if (any) { _appRepository.Save(); }
        }

        private static string TableOf(string tableColumn)
        {
            string s = (tableColumn ?? string.Empty).Trim();
            if (s.StartsWith("Staging.", StringComparison.OrdinalIgnoreCase)) s = s.Substring("Staging.".Length);
            int dot = s.IndexOf('.');
            return dot > 0 ? s.Substring(0, dot).Trim() : s;
        }

        // The distinct Staging tables the map's file spec(s) require, from app.vwStagingRelationships keyed
        // by the map's fact type code(s). Empty when the map has no file spec or the view yields nothing —
        // callers treat empty as "don't filter".
        private HashSet<string> GetRequiredStagingTables(int etlMapId)
        {
            var set = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            if (string.IsNullOrWhiteSpace(_connectionString)) return set;

            var factCodes = _appRepository
                .FindReadOnly<EtlMapFileSpec>(fs => fs.EtlMapId == etlMapId, 0, 0)
                .Select(fs => fs.FactTypeCode)
                .Where(c => !string.IsNullOrWhiteSpace(c))
                .Select(c => c.Trim())
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();
            if (factCodes.Count == 0) return set;

            try
            {
                using var conn = new Microsoft.Data.SqlClient.SqlConnection(_connectionString);
                conn.Open();
                using var cmd = conn.CreateCommand();
                var ins = new List<string>();
                for (int i = 0; i < factCodes.Count; i++)
                {
                    ins.Add("@f" + i);
                    cmd.Parameters.AddWithValue("@f" + i, factCodes[i]);
                }
                cmd.CommandText = "SELECT DISTINCT StagingTableName FROM app.vwStagingRelationships WHERE FactTypeCode IN (" + string.Join(",", ins) + ")";
                using var reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    if (!reader.IsDBNull(0)) set.Add(reader.GetString(0).Trim());
                }
            }
            catch { /* best effort — no filter on failure */ }
            return set;
        }

        // Physical columns of a schema.table object from INFORMATION_SCHEMA (empty if it can't be read).
        private List<string> GetObjectColumns(string sourceObject)
        {
            var cols = new List<string>();
            if (string.IsNullOrWhiteSpace(sourceObject) || string.IsNullOrWhiteSpace(_connectionString)) return cols;
            string obj = sourceObject.Trim().Replace("[", "").Replace("]", "");
            if (obj.IndexOf(' ') >= 0 || obj.IndexOf('(') >= 0) return cols; // a query, not a plain identifier
            string schema = null, table = obj;
            int dot = obj.LastIndexOf('.');
            if (dot > 0) { schema = obj.Substring(0, dot); table = obj.Substring(dot + 1); }
            try
            {
                using var conn = new Microsoft.Data.SqlClient.SqlConnection(_connectionString);
                conn.Open();
                using var cmd = conn.CreateCommand();
                cmd.CommandText = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=@t" +
                                  (schema != null ? " AND TABLE_SCHEMA=@s" : "") + " ORDER BY ORDINAL_POSITION";
                cmd.Parameters.AddWithValue("@t", table);
                if (schema != null) cmd.Parameters.AddWithValue("@s", schema);
                using var reader = cmd.ExecuteReader();
                while (reader.Read()) { if (!reader.IsDBNull(0)) cols.Add(reader.GetString(0)); }
            }
            catch { /* best effort */ }
            return cols;
        }

        public List<CedsElementCatalogDto> GetCedsElementCatalog()
        {
            // CEDS Ontology ∩ Staging when available (CIID-9057), else legacy EtlMetadata catalog
            return UseOntologyCatalog
                ? _catalogProvider.GetElementCatalog()
                : BuildCatalog(LoadMetadata());
        }

        public List<CedsOptionSetValueDto> GetCedsOptionSetValues(string cedsElementGlobalId)
        {
            return UseOntologyCatalog
                ? _catalogProvider.GetOptionSetValues(cedsElementGlobalId)
                : BuildOptionSetValues(FindMetadataByGlobalId(cedsElementGlobalId));
        }

        /// <summary>Joins the Staging Table.Column destinations for display/persistence.</summary>
        private static string JoinStaging(List<string> tableColumns)
        {
            return tableColumns == null || tableColumns.Count == 0 ? null : string.Join("; ", tableColumns);
        }

        private List<EtlMetadata> LoadMetadata()
        {
            return _appRepository.GetAllReadOnly<EtlMetadata>(0, 0).ToList();
        }

        /// <summary>
        /// EtlMetadata rows for one CEDS element. Global IDs are compared trimmed and
        /// case-insensitively because the seeded catalog data is not consistently formatted.
        /// </summary>
        private List<EtlMetadata> FindMetadataByGlobalId(string cedsElementGlobalId)
        {
            if (string.IsNullOrWhiteSpace(cedsElementGlobalId))
            {
                return new List<EtlMetadata>();
            }

            string globalId = cedsElementGlobalId.Trim();

            return _appRepository
                .FindReadOnly<EtlMetadata>(m => m.CedsElementGlobalId != null && m.CedsElementGlobalId.Trim() == globalId, 0, 0)
                .ToList();
        }

        private static List<CedsElementCatalogDto> BuildCatalog(IEnumerable<EtlMetadata> metadata)
        {
            return metadata
                .Where(m => !string.IsNullOrWhiteSpace(m.CedsElementGlobalId) && !string.IsNullOrWhiteSpace(m.CedsElementName))
                .GroupBy(m => m.CedsElementGlobalId.Trim(), StringComparer.OrdinalIgnoreCase)
                .Select(g => new CedsElementCatalogDto
                {
                    CedsElementGlobalId = g.Key,
                    CedsElementName = g.Select(m => m.CedsElementName).FirstOrDefault(n => !string.IsNullOrWhiteSpace(n)),
                    CedsElementDefinition = g.Select(m => m.CedsElementDefinition).FirstOrDefault(d => !string.IsNullOrWhiteSpace(d)),
                    CedsPath = g.Select(m => m.CedsPath).FirstOrDefault(p => !string.IsNullOrWhiteSpace(p)),
                    CedsDataModelId = g.Select(m => m.CedsElementDataModelId).FirstOrDefault(i => !string.IsNullOrWhiteSpace(i)),
                    HasOptionSet = g.Any(m => !string.IsNullOrWhiteSpace(m.CedsOptionSetCode) || !string.IsNullOrWhiteSpace(m.CedsOptionSetDescription))
                })
                .OrderBy(c => c.CedsElementName, StringComparer.OrdinalIgnoreCase)
                .ToList();
        }

        private static List<CedsOptionSetValueDto> BuildOptionSetValues(IEnumerable<EtlMetadata> elementMetadata)
        {
            if (elementMetadata == null)
            {
                return new List<CedsOptionSetValueDto>();
            }

            return elementMetadata
                .Where(m => !string.IsNullOrWhiteSpace(m.CedsOptionSetCode) || !string.IsNullOrWhiteSpace(m.CedsOptionSetDescription))
                .GroupBy(m => (m.CedsOptionSetCode ?? "") + "|" + (m.CedsOptionSetDescription ?? ""))
                .Select(g => new CedsOptionSetValueDto
                {
                    CedsOptionSetCode = g.First().CedsOptionSetCode,
                    CedsOptionSetDescription = g.First().CedsOptionSetDescription
                })
                .OrderBy(v => v.CedsOptionSetCode, StringComparer.OrdinalIgnoreCase)
                .ToList();
        }

        public List<CedsElementMatchDto> GetElementCandidates(int etlSourceElementMappingId, int topN = 5)
        {
            var mapping = _appRepository.GetById<EtlSourceElementMapping>(etlSourceElementMappingId);

            if (mapping == null)
            {
                return new List<CedsElementMatchDto>();
            }

            return _cedsAutoMapService.MatchElement(
                mapping.SourceElementName, mapping.SourceElementDefinition, GetCedsElementCatalog(), topN, CandidateThreshold);
        }

        public EtlSourceElementMapping UpdateElementMapping(int etlSourceElementMappingId, EtlSourceElementMappingUpdateDto update)
        {
            if (update == null)
            {
                return null;
            }

            var mapping = _appRepository
                .Find<EtlSourceElementMapping>(m => m.EtlSourceElementMappingId == etlSourceElementMappingId, 0, 0, m => m.EtlSourceOptionSetMappings)
                .FirstOrDefault();

            if (mapping == null)
            {
                return null;
            }

            string previousGlobalId = mapping.CedsElementGlobalId;

            if (!string.IsNullOrWhiteSpace(update.MappingStatus))
            {
                mapping.MappingStatus = update.MappingStatus;
            }

            if (mapping.MappingStatus == EtlMappingStatus.NotInCeds)
            {
                mapping.CedsElementGlobalId = null;
                mapping.CedsElementName = null;
                mapping.CedsElementDefinition = null;
                mapping.CedsDataModelId = null;
                mapping.CedsPath = null;
                mapping.StagingTableColumns = null;
                mapping.MatchConfidence = null;
                mapping.MatchType = EtlMatchType.Manual;
            }
            else if (!string.IsNullOrWhiteSpace(update.CedsElementGlobalId))
            {
                bool elementChanged = !string.Equals(
                    (previousGlobalId ?? "").Trim(), update.CedsElementGlobalId.Trim(), StringComparison.OrdinalIgnoreCase);

                if (elementChanged)
                {
                    var catalogEntry = UseOntologyCatalog
                        ? _catalogProvider.GetElementByGlobalId(update.CedsElementGlobalId)
                        : BuildCatalog(FindMetadataByGlobalId(update.CedsElementGlobalId)).FirstOrDefault();

                    if (catalogEntry == null)
                    {
                        throw new ArgumentException(
                            $"CEDS element with Global ID '{update.CedsElementGlobalId}' is not available in the CEDS catalog.");
                    }

                    ApplyCedsElement(mapping, catalogEntry);
                    _requiredStagingTables = GetRequiredStagingTables(mapping.EtlMapId.GetValueOrDefault());
                    mapping.StagingTableColumns = JoinStaging(
                        NarrowStagingCandidates(mapping.SourceElementName, mapping.SourceColumnName, catalogEntry.StagingTableColumns));
                    _requiredStagingTables = null;
                    mapping.MatchConfidence = null;
                    mapping.MatchType = EtlMatchType.Manual;

                    // Re-suggest option set value mappings against the new element's option set,
                    // preserving values a reviewer has already accepted.
                    SuggestOptionSetMappings(mapping, includeAccepted: false,
                        cedsOptionSetValues: GetCedsOptionSetValues(update.CedsElementGlobalId));
                }
            }

            if (update.ElementDefinitionResponseId != null)
            {
                mapping.ElementDefinitionResponseId = update.ElementDefinitionResponseId;
            }

            if (update.SelectionCriteria != null)
            {
                mapping.SelectionCriteria = update.SelectionCriteria;
            }

            if (update.TransformationRules != null)
            {
                mapping.TransformationRules = update.TransformationRules;
            }

            if (update.Notes != null)
            {
                mapping.Notes = update.Notes;
            }

            // Reviewer-curated Staging target columns win over the CEDS auto-derived list (applied AFTER the
            // element block above, so pruning a shared element's over-broad expansion persists with the map).
            // Null = not sent (leave as-is); an empty list clears the targets.
            if (update.StagingTableColumns != null)
            {
                mapping.StagingTableColumns = JoinStaging(update.StagingTableColumns);
            }

            mapping.ModifiedDate = DateTime.UtcNow;
            mapping.ModifiedBy = update.ModifiedBy;

            TouchMap(mapping.EtlMapId, update.ModifiedBy);

            _appRepository.Save();

            return mapping;
        }

        // Narrow a CEDS element's full staging-column expansion to the best match(es) for the source
        // element. Applied AUTOMATICALLY during automap (a shared CEDS element otherwise expands to EVERY
        // column in its class, e.g. StatusStartDate -> all PersonStatus *_StatusStartDate). Uses the
        // sentence-embedding model when available, else a lexical token score. <=1 candidate => unchanged.
        // The reviewer fine-tunes the result with the add/remove chips (see GetStagingCandidates).
        private List<string> NarrowStagingCandidates(string sourceElementName, string sourceColumnName, List<string> candidates)
        {
            var list = candidates ?? new List<string>();

            // File-spec filter: drop candidate columns whose table isn't required by this map's file spec.
            // Skipped when no file spec is resolved (empty set). If the element's CEDS columns are ALL in
            // non-required tables, the result is empty — correct: that element isn't part of this file spec.
            if (_requiredStagingTables != null && _requiredStagingTables.Count > 0)
            {
                list = list.Where(c => _requiredStagingTables.Contains(TableOf(c))).ToList();
            }

            if (list.Count <= 1)
            {
                return list;
            }
            string query = ((sourceElementName ?? "") + " " + (sourceColumnName ?? "")).Trim();
            return RankStagingCandidates(query, list);
        }

        // The candidate pool of Staging Table.Column targets the UI offers for a mapping.
        //  - With a CEDS element: every column that element expands to (add-back after a reviewer removes one).
        //  - Without a CEDS element (unmapped, or "Not in CEDS"): the map's file-spec-required Staging columns
        //    that have NO CEDS annotation — i.e. the Generate-specific columns (NewLEA, *IsReportedFederally,
        //    HomelessNightTimeResidence_StartDate, …) that can't be reached through CEDS but are valid targets.
        public List<string> GetStagingCandidates(int etlSourceElementMappingId)
        {
            var mapping = _appRepository
                .Find<EtlSourceElementMapping>(m => m.EtlSourceElementMappingId == etlSourceElementMappingId, 0, 0)
                .FirstOrDefault();
            if (mapping == null)
            {
                return new List<string>();
            }
            if (string.IsNullOrWhiteSpace(mapping.CedsElementGlobalId))
            {
                return GetNonCedsRequiredStagingColumns(mapping.EtlMapId.GetValueOrDefault());
            }
            if (!UseOntologyCatalog)
            {
                return new List<string>();
            }
            var entry = _catalogProvider.GetElementByGlobalId(mapping.CedsElementGlobalId);
            return entry?.StagingTableColumns ?? new List<string>();
        }

        // Non-CEDS Staging targets a map may still legitimately need: file-spec-required columns (from
        // app.vwStagingRelationships) that exist in the schema, aren't system columns, and have NO CEDS
        // extended property. These are the manual-mapping targets for "Not in CEDS" source elements.
        private List<string> GetNonCedsRequiredStagingColumns(int etlMapId)
        {
            var result = new List<string>();
            if (etlMapId <= 0 || string.IsNullOrWhiteSpace(_connectionString)) return result;

            var factCodes = _appRepository
                .FindReadOnly<EtlMapFileSpec>(fs => fs.EtlMapId == etlMapId, 0, 0)
                .Select(fs => fs.FactTypeCode)
                .Where(c => !string.IsNullOrWhiteSpace(c))
                .Select(c => c.Trim())
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToList();
            if (factCodes.Count == 0) return result;

            try
            {
                using var conn = new Microsoft.Data.SqlClient.SqlConnection(_connectionString);
                conn.Open();
                using var cmd = conn.CreateCommand();
                var ins = new List<string>();
                for (int i = 0; i < factCodes.Count; i++) { ins.Add("@f" + i); cmd.Parameters.AddWithValue("@f" + i, factCodes[i]); }
                cmd.CommandText =
                    "SELECT DISTINCT r.StagingTableName + '.' + r.StagingColumnName AS TC " +
                    "FROM app.vwStagingRelationships r " +
                    "WHERE r.FactTypeCode IN (" + string.Join(",", ins) + ") " +
                    "  AND r.StagingColumnName <> 'RunDateTime' " +
                    "  AND EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS c WHERE c.TABLE_SCHEMA='Staging' AND c.TABLE_NAME=r.StagingTableName AND c.COLUMN_NAME=r.StagingColumnName) " +
                    "  AND NOT EXISTS (SELECT 1 FROM App.vwEtlStagingCedsColumns a WHERE a.TableName=r.StagingTableName AND a.ColumnName=r.StagingColumnName) " +
                    "ORDER BY TC";
                using var reader = cmd.ExecuteReader();
                while (reader.Read()) { if (!reader.IsDBNull(0)) result.Add(reader.GetString(0)); }
            }
            catch { /* best effort */ }
            return result;
        }

        // Rank candidate "Table.Column" staging targets by similarity of the COLUMN name to the source
        // element, keeping the top match plus any within a small margin (so genuinely-multi-column elements
        // like identifiers keep their set, while a status-date element collapses to the one that matches).
        private List<string> RankStagingCandidates(string query, List<string> candidates)
        {
            bool useEmbed = _embeddingModel != null && _embeddingModel.IsAvailable;
            float[] q = useEmbed ? _embeddingModel.Embed(Humanize(query)) : null;

            var scored = new List<(string col, double score)>();
            foreach (var c in candidates)
            {
                string colName = c.IndexOf('.') >= 0 ? c.Substring(c.IndexOf('.') + 1) : c;
                double score = useEmbed
                    ? (double)CedsEmbeddingModelProvider.CosineSimilarity(q, _embeddingModel.Embed(Humanize(colName)))
                    : TokenSimilarity(query, colName);
                scored.Add((c, score));
            }

            double best = scored.Max(x => x.score);
            if (best <= 0) return candidates; // nothing scored — leave the set untouched
            double margin = useEmbed ? 0.03 : 0.10;
            var kept = scored.Where(x => x.score >= best - margin).Select(x => x.col).ToList();
            return kept.Count > 0 ? kept : new List<string> { scored.OrderByDescending(x => x.score).First().col };
        }

        // Jaccard overlap of normalized tokens (camelCase + underscores split, lowercased). Cheap lexical
        // fallback for staging-column ranking when the embedding model isn't installed.
        private static double TokenSimilarity(string a, string b)
        {
            var ta = Tokenize(a); var tb = Tokenize(b);
            if (ta.Count == 0 || tb.Count == 0) return 0;
            int inter = ta.Intersect(tb).Count();
            int union = ta.Union(tb).Count();
            return union == 0 ? 0 : (double)inter / union;
        }

        private static HashSet<string> Tokenize(string s)
        {
            if (string.IsNullOrWhiteSpace(s)) return new HashSet<string>();
            string spaced = Regex.Replace(s, "(?<=[a-z0-9])(?=[A-Z])", " ").Replace('_', ' ').Replace('.', ' ');
            return new HashSet<string>(
                spaced.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries).Select(t => t.ToLowerInvariant()),
                StringComparer.Ordinal);
        }

        private static string Humanize(string s)
        {
            if (string.IsNullOrWhiteSpace(s)) return s ?? "";
            return Regex.Replace(s, "(?<=[a-z0-9])(?=[A-Z])", " ").Replace('_', ' ').Trim();
        }

        public EtlSourceOptionSetMapping UpdateOptionSetMapping(int etlSourceOptionSetMappingId, EtlSourceOptionSetMappingUpdateDto update)
        {
            if (update == null)
            {
                return null;
            }

            var optionMapping = _appRepository
                .Find<EtlSourceOptionSetMapping>(m => m.EtlSourceOptionSetMappingId == etlSourceOptionSetMappingId, 0, 0)
                .FirstOrDefault();

            if (optionMapping == null)
            {
                return null;
            }

            if (!string.IsNullOrWhiteSpace(update.MappingStatus))
            {
                optionMapping.MappingStatus = update.MappingStatus;
            }

            if (optionMapping.MappingStatus == EtlMappingStatus.NotInCeds)
            {
                optionMapping.CedsOptionSetCode = null;
                optionMapping.CedsOptionSetDescription = null;
                optionMapping.MatchConfidence = null;
                optionMapping.MatchType = EtlMatchType.Manual;
            }
            else if (update.CedsOptionSetCode != null || update.CedsOptionSetDescription != null)
            {
                bool valueChanged = false;

                if (update.CedsOptionSetCode != null &&
                    !string.Equals(optionMapping.CedsOptionSetCode ?? "", update.CedsOptionSetCode, StringComparison.Ordinal))
                {
                    optionMapping.CedsOptionSetCode = update.CedsOptionSetCode;
                    valueChanged = true;
                }

                if (update.CedsOptionSetDescription != null &&
                    !string.Equals(optionMapping.CedsOptionSetDescription ?? "", update.CedsOptionSetDescription, StringComparison.Ordinal))
                {
                    optionMapping.CedsOptionSetDescription = update.CedsOptionSetDescription;
                    valueChanged = true;
                }

                if (valueChanged)
                {
                    optionMapping.MatchConfidence = null;
                    optionMapping.MatchType = EtlMatchType.Manual;
                }
            }

            if (update.OptionSetResponseId != null)
            {
                optionMapping.OptionSetResponseId = update.OptionSetResponseId;
            }

            optionMapping.ModifiedDate = DateTime.UtcNow;
            optionMapping.ModifiedBy = update.ModifiedBy;

            var parentElement = _appRepository
                .Find<EtlSourceElementMapping>(m => m.EtlSourceElementMappingId == optionMapping.EtlSourceElementMappingId, 0, 0)
                .FirstOrDefault();
            TouchMap(parentElement?.EtlMapId, update.ModifiedBy);

            _appRepository.Save();

            // Reflect the approved option-set-value mapping into Staging.SourceSystemReferenceData so
            // the staging-to-fact scripts translate the source code to the CEDS code (CIID-9061).
            SyncSourceSystemReferenceData(parentElement, optionMapping);

            return optionMapping;
        }

        /// <summary>
        /// Upserts (or removes) a Staging.SourceSystemReferenceData row for an option-set-value
        /// mapping: TableName = the CEDS reference table (dbo.Ref&lt;element&gt;), InputCode = the source
        /// code, OutputCode = the CEDS code, keyed by the configured school year. No-op when the CEDS
        /// element has no matching Ref table (e.g. bit/free-text elements).
        /// </summary>
        private void SyncSourceSystemReferenceData(EtlSourceElementMapping element, EtlSourceOptionSetMapping option)
        {
            if (string.IsNullOrWhiteSpace(_connectionString) || element == null || option == null)
            {
                return;
            }

            string inputCode = option.SourceOptionSetCode;
            if (string.IsNullOrWhiteSpace(inputCode))
            {
                return;
            }

            try
            {
                using var conn = new Microsoft.Data.SqlClient.SqlConnection(_connectionString);
                conn.Open();

                string refTable = ResolveRefTableName(conn, element.CedsElementName);
                if (refTable == null)
                {
                    return; // element's option set is not backed by a CEDS reference table
                }

                bool remove = option.MappingStatus == EtlMappingStatus.NotInCeds
                    || option.MappingStatus == EtlMappingStatus.Rejected
                    || string.IsNullOrWhiteSpace(option.CedsOptionSetCode);

                using var cmd = conn.CreateCommand();
                if (remove)
                {
                    cmd.CommandText =
                        "DELETE FROM Staging.SourceSystemReferenceData " +
                        "WHERE SchoolYear=@yr AND TableName=@tbl AND TableFilter IS NULL AND InputCode=@in";
                }
                else
                {
                    cmd.CommandText = @"
MERGE Staging.SourceSystemReferenceData AS t
USING (SELECT @yr AS SchoolYear, @tbl AS TableName, @in AS InputCode) AS s
    ON t.SchoolYear = s.SchoolYear AND t.TableName = s.TableName AND t.TableFilter IS NULL AND t.InputCode = s.InputCode
WHEN MATCHED THEN UPDATE SET OutputCode = @out
WHEN NOT MATCHED THEN INSERT (SchoolYear, TableName, TableFilter, InputCode, OutputCode)
    VALUES (@yr, @tbl, NULL, @in, @out);";
                    cmd.Parameters.AddWithValue("@out", (object)option.CedsOptionSetCode ?? System.DBNull.Value);
                }
                cmd.Parameters.AddWithValue("@yr", _referenceDataSchoolYear);
                cmd.Parameters.AddWithValue("@tbl", refTable);
                cmd.Parameters.AddWithValue("@in", inputCode);
                cmd.ExecuteNonQuery();
            }
            catch
            {
                // Reference-data sync is best-effort; a failure must not block the mapping update.
            }
        }

        /// <summary>
        /// Upserts all of a map's accepted option-set-value mappings into Staging.SourceSystemReferenceData
        /// for the given school year. Used by the AI ETL agent to auto-populate reference data before the
        /// Staging-to-RDS translation. Returns the number of rows written.
        /// </summary>
        public int SyncReferenceDataForMap(int etlMapId, int schoolYear)
        {
            if (string.IsNullOrWhiteSpace(_connectionString) || schoolYear <= 0)
            {
                return 0;
            }

            var elements = GetAllMappings(etlMapId);
            int written = 0;
            try
            {
                using var conn = new Microsoft.Data.SqlClient.SqlConnection(_connectionString);
                conn.Open();

                foreach (var element in elements)
                {
                    if (element.EtlSourceOptionSetMappings == null || element.EtlSourceOptionSetMappings.Count == 0)
                    {
                        continue;
                    }
                    string refTable = ResolveRefTableName(conn, element.CedsElementName);
                    if (refTable == null)
                    {
                        continue;
                    }

                    foreach (var option in element.EtlSourceOptionSetMappings)
                    {
                        if (string.IsNullOrWhiteSpace(option.SourceOptionSetCode) ||
                            string.IsNullOrWhiteSpace(option.CedsOptionSetCode) ||
                            option.MappingStatus == EtlMappingStatus.NotInCeds ||
                            option.MappingStatus == EtlMappingStatus.Rejected)
                        {
                            continue;
                        }

                        using var cmd = conn.CreateCommand();
                        cmd.CommandText = @"
MERGE Staging.SourceSystemReferenceData AS t
USING (SELECT @yr AS SchoolYear, @tbl AS TableName, @in AS InputCode) AS s
    ON t.SchoolYear = s.SchoolYear AND t.TableName = s.TableName AND t.TableFilter IS NULL AND t.InputCode = s.InputCode
WHEN MATCHED THEN UPDATE SET OutputCode = @out
WHEN NOT MATCHED THEN INSERT (SchoolYear, TableName, TableFilter, InputCode, OutputCode)
    VALUES (@yr, @tbl, NULL, @in, @out);";
                        cmd.Parameters.AddWithValue("@yr", schoolYear);
                        cmd.Parameters.AddWithValue("@tbl", refTable);
                        cmd.Parameters.AddWithValue("@in", option.SourceOptionSetCode);
                        cmd.Parameters.AddWithValue("@out", option.CedsOptionSetCode);
                        written += cmd.ExecuteNonQuery();
                    }
                }
            }
            catch
            {
                // best-effort; a failure must not block the run
            }
            return written;
        }

        /// <summary>
        /// Resolves the CEDS reference table (dbo.Ref&lt;name&gt;) for a CEDS element by trying the
        /// element label and known variants, returning the base table name (e.g. RefSex) if it exists.
        /// </summary>
        private static string ResolveRefTableName(Microsoft.Data.SqlClient.SqlConnection conn, string cedsElementName)
        {
            if (string.IsNullOrWhiteSpace(cedsElementName))
            {
                return null;
            }

            string core = new string(cedsElementName.Where(char.IsLetterOrDigit).ToArray());
            var candidates = new List<string> { "Ref" + core };
            // Common CEDS naming differences
            candidates.Add("Ref" + core.Replace("PrimaryDisabilityType", "IDEADisabilityType"));
            candidates.Add("Ref" + core.Replace("Type", ""));

            foreach (var candidate in candidates.Distinct())
            {
                using var cmd = conn.CreateCommand();
                cmd.CommandText = "SELECT name FROM sys.tables WHERE name = @n";
                cmd.Parameters.AddWithValue("@n", candidate);
                var found = cmd.ExecuteScalar() as string;
                if (found != null)
                {
                    return found;
                }
            }
            return null;
        }

        /// <summary>
        /// Stamps the parent map's last-update audit when any of its mappings change.
        /// </summary>
        private void TouchMap(int? etlMapId, string modifiedBy)
        {
            if (!etlMapId.HasValue)
            {
                return;
            }

            var etlMap = _appRepository
                .Find<EtlMap>(m => m.EtlMapId == etlMapId.Value, 0, 0)
                .FirstOrDefault();

            if (etlMap != null)
            {
                etlMap.ModifiedDate = DateTime.UtcNow;
                etlMap.ModifiedBy = modifiedBy;
            }
        }

        public void DeleteAllMappings()
        {
            // Child rows are removed by the ON DELETE CASCADE foreign keys; mappings without a map
            // (created before App.EtlMap existed) are deleted explicitly.
            var maps = _appRepository.GetAll<EtlMap>(0, 0).ToList();
            _appRepository.DeleteRange(maps);
            var orphanMappings = _appRepository.Find<EtlSourceElementMapping>(m => m.EtlMapId == null, 0, 0).ToList();
            _appRepository.DeleteRange(orphanMappings);
            _appRepository.Save();
        }

        public string ExportChecklistCsv(int? etlMapId = null)
        {
            var mappings = GetAllMappings(etlMapId);
            var metadata = _appRepository.GetAllReadOnly<EtlMetadata>(0, 0)
                .Where(m => !string.IsNullOrWhiteSpace(m.CedsElementGlobalId))
                .ToList();

            var metadataByGlobalId = metadata
                .GroupBy(m => m.CedsElementGlobalId.Trim(), StringComparer.OrdinalIgnoreCase)
                .ToDictionary(g => g.Key, g => g.ToList(), StringComparer.OrdinalIgnoreCase);

            var builder = new StringBuilder();

            builder.AppendLine(string.Join(",", new[]
            {
                "Source Common Name", "Source Technical Name", "Source Database Name", "Source Schema Name",
                "Source Table Name", "Source Column Name", "Source Element Name", "Source Element Definition",
                "Source Data Type", "Source Data Length", "Source Option Set Code", "Source Option Set Description",
                "Source Data Steward", "Selection Criteria", "Transformation Rules", "Notes",
                "Mapping Status", "Match Confidence", "Match Type",
                "CEDS Data Warehouse Staging Table.Column(s)",
                "EDFacts File Spec Number(s)", "CEDS Path", "CEDS Element Name", "CEDS Element Definition",
                "CEDS Data Type", "CEDS Data Length", "CEDS Option Set Code", "CEDS Option Set Description",
                "CEDS Element Global ID", "CEDS Element Data Model ID",
                "Element Definition Response ID", "Option Set Response ID",
                "Destination Staging Table Name", "Destination Staging Column Name",
                "Destination RDS Dimension Table Name", "Destination RDS Dimension Column Name",
                "Destination RDS Fact Table Name", "Destination RDS Fact Column Name",
                "Destination RDS Report Table Name", "Destination RDS Report Column Name"
            }));

            foreach (var mapping in mappings)
            {
                List<EtlMetadata> elementMetadata = null;

                if (!string.IsNullOrWhiteSpace(mapping.CedsElementGlobalId))
                {
                    metadataByGlobalId.TryGetValue(mapping.CedsElementGlobalId.Trim(), out elementMetadata);
                }

                var optionMappings = mapping.EtlSourceOptionSetMappings ?? new List<EtlSourceOptionSetMapping>();

                if (optionMappings.Count == 0)
                {
                    builder.AppendLine(BuildCsvRow(mapping, null, FindMetadataRow(elementMetadata, null)));
                }
                else
                {
                    foreach (var optionMapping in optionMappings.OrderBy(o => o.EtlSourceOptionSetMappingId))
                    {
                        builder.AppendLine(BuildCsvRow(mapping, optionMapping, FindMetadataRow(elementMetadata, optionMapping.CedsOptionSetCode)));
                    }
                }
            }

            return builder.ToString();
        }

        private static EtlMetadata FindMetadataRow(List<EtlMetadata> elementMetadata, string cedsOptionSetCode)
        {
            if (elementMetadata == null || elementMetadata.Count == 0)
            {
                return null;
            }

            if (!string.IsNullOrWhiteSpace(cedsOptionSetCode))
            {
                var optionRow = elementMetadata.FirstOrDefault(m =>
                    string.Equals((m.CedsOptionSetCode ?? "").Trim(), cedsOptionSetCode.Trim(), StringComparison.OrdinalIgnoreCase));

                if (optionRow != null)
                {
                    return optionRow;
                }
            }

            // Prefer a row that carries Generate destination metadata (an EDFacts file-spec row)
            return elementMetadata.FirstOrDefault(m => !string.IsNullOrWhiteSpace(m.DestinationStagingTableName))
                ?? elementMetadata.First();
        }

        private string BuildCsvRow(EtlSourceElementMapping mapping, EtlSourceOptionSetMapping optionMapping, EtlMetadata metadataRow)
        {
            return string.Join(",", new[]
            {
                CsvEscape(mapping.SourceCommonName),
                CsvEscape(mapping.SourceTechnicalName),
                CsvEscape(mapping.SourceDatabaseName),
                CsvEscape(mapping.SourceSchemaName),
                CsvEscape(mapping.SourceTableName),
                CsvEscape(mapping.SourceColumnName),
                CsvEscape(mapping.SourceElementName),
                CsvEscape(mapping.SourceElementDefinition),
                CsvEscape(mapping.SourceDataType),
                CsvEscape(mapping.SourceDataLength),
                CsvEscape(optionMapping?.SourceOptionSetCode),
                CsvEscape(optionMapping?.SourceOptionSetDescription),
                CsvEscape(mapping.SourceDataSteward),
                CsvEscape(mapping.SelectionCriteria),
                CsvEscape(mapping.TransformationRules),
                CsvEscape(mapping.Notes),
                CsvEscape(optionMapping != null ? optionMapping.MappingStatus : mapping.MappingStatus),
                CsvEscape((optionMapping != null ? optionMapping.MatchConfidence : mapping.MatchConfidence)?.ToString("0.####", CultureInfo.InvariantCulture)),
                CsvEscape(optionMapping != null ? optionMapping.MatchType : mapping.MatchType),
                CsvEscape(mapping.StagingTableColumns),
                CsvEscape(metadataRow?.EdFactsFileSpecNumber),
                CsvEscape(mapping.CedsPath ?? metadataRow?.CedsPath),
                CsvEscape(mapping.CedsElementName),
                CsvEscape(mapping.CedsElementDefinition),
                CsvEscape(metadataRow?.CedsDataType),
                CsvEscape(metadataRow?.CedsDataLength),
                CsvEscape(optionMapping?.CedsOptionSetCode),
                CsvEscape(optionMapping?.CedsOptionSetDescription),
                CsvEscape(mapping.CedsElementGlobalId),
                CsvEscape(mapping.CedsDataModelId ?? metadataRow?.CedsElementDataModelId),
                CsvEscape(mapping.ElementDefinitionResponseId),
                CsvEscape(optionMapping?.OptionSetResponseId),
                CsvEscape(metadataRow?.DestinationStagingTableName),
                CsvEscape(metadataRow?.DestinationStagingColumnName),
                CsvEscape(metadataRow?.DestinationRdsDimensionTableName),
                CsvEscape(metadataRow?.DestinationRdsDimensionColumnName),
                CsvEscape(metadataRow?.DestinationRdsFactTableName),
                CsvEscape(metadataRow?.DestinationRdsFactColumnName),
                CsvEscape(metadataRow?.DestinationRdsReportTableName),
                CsvEscape(metadataRow?.DestinationRdsReportColumnName)
            });
        }

        private static string CsvEscape(string value)
        {
            if (string.IsNullOrEmpty(value))
            {
                return string.Empty;
            }

            if (value.Contains(",") || value.Contains("\"") || value.Contains("\n") || value.Contains("\r"))
            {
                return "\"" + value.Replace("\"", "\"\"") + "\"";
            }

            return value;
        }

        private static void ApplyCedsElement(EtlSourceElementMapping mapping, CedsElementCatalogDto cedsElement)
        {
            mapping.CedsElementGlobalId = cedsElement.CedsElementGlobalId;
            mapping.CedsElementName = cedsElement.CedsElementName;
            mapping.CedsElementDefinition = cedsElement.CedsElementDefinition;
            mapping.CedsDataModelId = cedsElement.CedsDataModelId;
            mapping.CedsPath = cedsElement.CedsPath;
        }

        /// <summary>
        /// Runs option set value automapping for a mapped element. When <paramref name="includeAccepted"/>
        /// is false, option values a reviewer has already accepted are left untouched.
        /// </summary>
        private void SuggestOptionSetMappings(EtlSourceElementMapping mapping, bool includeAccepted, List<CedsOptionSetValueDto> cedsOptionSetValues = null)
        {
            if (mapping.EtlSourceOptionSetMappings == null || mapping.EtlSourceOptionSetMappings.Count == 0 ||
                string.IsNullOrWhiteSpace(mapping.CedsElementGlobalId))
            {
                return;
            }

            cedsOptionSetValues = cedsOptionSetValues ?? GetCedsOptionSetValues(mapping.CedsElementGlobalId);

            foreach (var optionMapping in mapping.EtlSourceOptionSetMappings)
            {
                if (!includeAccepted && optionMapping.MappingStatus == EtlMappingStatus.Accepted)
                {
                    continue;
                }

                var optionCandidates = _cedsAutoMapService.MatchOptionSetValue(
                    optionMapping.SourceOptionSetCode, optionMapping.SourceOptionSetDescription, cedsOptionSetValues, 1, CandidateThreshold);

                var topOptionCandidate = optionCandidates.FirstOrDefault();

                if (topOptionCandidate != null)
                {
                    optionMapping.CedsOptionSetCode = topOptionCandidate.CedsOptionSetCode;
                    optionMapping.CedsOptionSetDescription = topOptionCandidate.CedsOptionSetDescription;
                    optionMapping.MatchConfidence = topOptionCandidate.Confidence;
                    optionMapping.MatchType = topOptionCandidate.MatchType;
                    optionMapping.MappingStatus = EtlMappingStatus.Suggested;
                }
                else
                {
                    optionMapping.CedsOptionSetCode = null;
                    optionMapping.CedsOptionSetDescription = null;
                    optionMapping.MatchConfidence = null;
                    optionMapping.MatchType = null;
                    optionMapping.MappingStatus = EtlMappingStatus.Unmapped;
                }
            }
        }
    }
}
