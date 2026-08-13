using System.Collections.Generic;
using generate.core.Dtos.App;
using generate.core.Models.App;

namespace generate.core.Interfaces.Services
{
    /// <summary>
    /// Orchestrates the ETL Checklist source mapping workflow: upload of a state's bespoke data
    /// dictionary, CEDS automapping, review (accept/reject/override), and checklist export.
    /// </summary>
    public interface IEtlSourceMappingService
    {
        /// <summary>
        /// Creates a named map for the upload, persists the data dictionary elements and option set
        /// values, runs CEDS automapping, and returns the created mappings with their top candidates.
        /// </summary>
        List<EtlSourceElementMappingResultDto> UploadDataDictionary(EtlSourceMappingUploadDto upload);

        /// <summary>
        /// All maps with audit information, element counts, and file spec associations, newest first.
        /// </summary>
        List<EtlMapDto> GetMaps();

        /// <summary>
        /// Creates a map (name + EDFacts file spec associations) without an upload.
        /// </summary>
        EtlMapDto CreateMap(EtlMapSaveDto save);

        /// <summary>
        /// Updates a map's name and replaces its EDFacts file spec associations.
        /// </summary>
        EtlMapDto UpdateMap(int etlMapId, EtlMapSaveDto save);

        /// <summary>
        /// Fact Types from rds.DimFactTypes (for the map file spec picker).
        /// </summary>
        List<FactTypeDto> GetFactTypes();

        /// <summary>
        /// Distinct EDFacts file spec numbers known to App.EtlMetadata (for the picker).
        /// </summary>
        List<string> GetFileSpecNumbers();

        /// <summary>
        /// Element mappings (with option set value mappings), optionally filtered to one map.
        /// </summary>
        List<EtlSourceElementMapping> GetAllMappings(int? etlMapId = null);

        /// <summary>
        /// Upserts all of a map's accepted option-set-value mappings into Staging.SourceSystemReferenceData
        /// for the given school year (source code -> CEDS code). Returns the number of rows written.
        /// </summary>
        int SyncReferenceDataForMap(int etlMapId, int schoolYear);

        /// <summary>
        /// Deletes one map and all of its element / option set value mappings.
        /// </summary>
        bool DeleteMap(int etlMapId);

        /// <summary>Source datasets registered to a map (a file spec may draw from several).</summary>
        List<EtlMapSource> GetMapSources(int etlMapId);

        /// <summary>Creates or updates a source dataset on a map (EtlMapSourceId = 0 to create).</summary>
        EtlMapSource SaveMapSource(EtlMapSource source);

        /// <summary>Removes a source dataset from a map.</summary>
        bool DeleteMapSource(int etlMapSourceId);

        /// <summary>Structured join conditions between a map's source objects.</summary>
        List<EtlMapJoin> GetMapJoins(int etlMapId);

        /// <summary>Creates or updates a join condition on a map (EtlMapJoinId = 0 to create).</summary>
        EtlMapJoin SaveMapJoin(EtlMapJoin join);

        /// <summary>Removes a join condition from a map.</summary>
        bool DeleteMapJoin(int etlMapJoinId);

        /// <summary>Saves a map's free-text AI guidance (join description + processing notes).</summary>
        EtlMapDto SaveMapGuidance(int etlMapId, EtlMapGuidanceDto guidance);

        /// <summary>Each of a map's source objects with its column list (for join-builder dropdowns).</summary>
        List<EtlMapSourceSchemaDto> GetMapSourceSchema(int etlMapId);

        /// <summary>
        /// Distinct CEDS elements available as mapping targets (from App.EtlMetadata).
        /// </summary>
        List<CedsElementCatalogDto> GetCedsElementCatalog();

        /// <summary>
        /// CEDS option set values for one CEDS element (from App.EtlMetadata).
        /// </summary>
        List<CedsOptionSetValueDto> GetCedsOptionSetValues(string cedsElementGlobalId);

        /// <summary>
        /// Top CEDS element candidates for an existing element mapping (used by the review UI).
        /// </summary>
        List<CedsElementMatchDto> GetElementCandidates(int etlSourceElementMappingId, int topN = 5);

        /// <summary>
        /// Applies a review decision to an element mapping. When the CEDS element changes, the CEDS
        /// fields are re-denormalized from App.EtlMetadata and non-accepted option set value mappings
        /// are re-suggested against the new element's option set.
        /// </summary>
        EtlSourceElementMapping UpdateElementMapping(int etlSourceElementMappingId, EtlSourceElementMappingUpdateDto update);

        /// <summary>
        /// The FULL set of Staging Table.Column targets the mapping's CEDS element expands to — the candidate
        /// pool the UI offers for add-back after a reviewer removes an auto-narrowed column. (Narrowing to
        /// the best match(es) happens automatically during automap; this exposes what can be re-added.)
        /// </summary>
        List<string> GetStagingCandidates(int etlSourceElementMappingId);

        /// <summary>
        /// Applies a review decision to an option set value mapping.
        /// </summary>
        EtlSourceOptionSetMapping UpdateOptionSetMapping(int etlSourceOptionSetMappingId, EtlSourceOptionSetMappingUpdateDto update);

        /// <summary>
        /// Removes all source mappings (fresh re-upload).
        /// </summary>
        void DeleteAllMappings();

        /// <summary>
        /// Exports the ETL Checklist as CSV (optionally for one map): source columns + mapped CEDS
        /// columns + Generate destination columns joined from App.EtlMetadata.
        /// </summary>
        string ExportChecklistCsv(int? etlMapId = null);
    }
}
