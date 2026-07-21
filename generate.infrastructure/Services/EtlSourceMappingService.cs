using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
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
        // Minimum confidence for the top candidate to be stored as a suggestion (vs. left Unmapped)
        private const decimal SuggestionThreshold = 0.5m;
        // Minimum confidence for a candidate to be returned for review
        private const decimal CandidateThreshold = 0.2m;

        private readonly IAppRepository _appRepository;
        private readonly IRDSRepository _rdsRepository;
        private readonly ICedsAutoMapService _cedsAutoMapService;

        public EtlSourceMappingService(IAppRepository appRepository, IRDSRepository rdsRepository, ICedsAutoMapService cedsAutoMapService)
        {
            _appRepository = appRepository;
            _rdsRepository = rdsRepository;
            _cedsAutoMapService = cedsAutoMapService;
        }

        public List<EtlSourceElementMappingResultDto> UploadDataDictionary(EtlSourceMappingUploadDto upload)
        {
            var results = new List<EtlSourceElementMappingResultDto>();

            if (upload == null || upload.Elements == null || upload.Elements.Count == 0)
            {
                return results;
            }

            // One EtlMetadata load serves both the element catalog and every option set lookup below
            var metadata = LoadMetadata();
            var catalog = BuildCatalog(metadata);
            var metadataByGlobalId = metadata
                .Where(m => !string.IsNullOrWhiteSpace(m.CedsElementGlobalId))
                .GroupBy(m => m.CedsElementGlobalId.Trim(), StringComparer.OrdinalIgnoreCase)
                .ToDictionary(g => g.Key, g => g.ToList(), StringComparer.OrdinalIgnoreCase);

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

            foreach (var element in upload.Elements.Where(e => e != null && !string.IsNullOrWhiteSpace(e.SourceElementName)))
            {
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

                var candidates = _cedsAutoMapService.MatchElement(
                    mapping.SourceElementName, mapping.SourceElementDefinition, catalog, 5, CandidateThreshold);

                var topCandidate = candidates.FirstOrDefault();

                if (topCandidate != null && topCandidate.Confidence >= SuggestionThreshold)
                {
                    ApplyCedsElement(mapping, topCandidate);
                    mapping.MatchConfidence = topCandidate.Confidence;
                    mapping.MatchType = EtlMatchType.Suggested;
                    mapping.MappingStatus = EtlMappingStatus.Suggested;

                    metadataByGlobalId.TryGetValue(topCandidate.CedsElementGlobalId, out var elementMetadata);
                    SuggestOptionSetMappings(mapping, includeAccepted: true,
                        cedsOptionSetValues: BuildOptionSetValues(elementMetadata));
                }

                _appRepository.Create(mapping);

                results.Add(new EtlSourceElementMappingResultDto
                {
                    Mapping = mapping,
                    Candidates = candidates
                });
            }

            _appRepository.Save();

            return results;
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
                    FactTypeDescription = f.FactTypeDescription
                })
                .OrderBy(f => f.FactTypeCode, StringComparer.OrdinalIgnoreCase)
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

        public List<CedsElementCatalogDto> GetCedsElementCatalog()
        {
            return BuildCatalog(LoadMetadata());
        }

        public List<CedsOptionSetValueDto> GetCedsOptionSetValues(string cedsElementGlobalId)
        {
            return BuildOptionSetValues(FindMetadataByGlobalId(cedsElementGlobalId));
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
                mapping.MatchConfidence = null;
                mapping.MatchType = EtlMatchType.Manual;
            }
            else if (!string.IsNullOrWhiteSpace(update.CedsElementGlobalId))
            {
                bool elementChanged = !string.Equals(
                    (previousGlobalId ?? "").Trim(), update.CedsElementGlobalId.Trim(), StringComparison.OrdinalIgnoreCase);

                if (elementChanged)
                {
                    var elementMetadata = FindMetadataByGlobalId(update.CedsElementGlobalId);
                    var catalogEntry = BuildCatalog(elementMetadata).FirstOrDefault();

                    if (catalogEntry == null)
                    {
                        throw new ArgumentException(
                            $"CEDS element with Global ID '{update.CedsElementGlobalId}' was not found in App.EtlMetadata.");
                    }

                    ApplyCedsElement(mapping, catalogEntry);
                    mapping.MatchConfidence = null;
                    mapping.MatchType = EtlMatchType.Manual;

                    // Re-suggest option set value mappings against the new element's option set,
                    // preserving values a reviewer has already accepted.
                    SuggestOptionSetMappings(mapping, includeAccepted: false,
                        cedsOptionSetValues: BuildOptionSetValues(elementMetadata));
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

            mapping.ModifiedDate = DateTime.UtcNow;
            mapping.ModifiedBy = update.ModifiedBy;

            TouchMap(mapping.EtlMapId, update.ModifiedBy);

            _appRepository.Save();

            return mapping;
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

            return optionMapping;
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
