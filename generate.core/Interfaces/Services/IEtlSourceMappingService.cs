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
        /// Persists the uploaded data dictionary elements and option set values, runs CEDS
        /// automapping, and returns the created mappings with their top CEDS element candidates.
        /// </summary>
        List<EtlSourceElementMappingResultDto> UploadDataDictionary(EtlSourceMappingUploadDto upload);

        /// <summary>
        /// All persisted element mappings including their option set value mappings.
        /// </summary>
        List<EtlSourceElementMapping> GetAllMappings();

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
        /// Applies a review decision to an option set value mapping.
        /// </summary>
        EtlSourceOptionSetMapping UpdateOptionSetMapping(int etlSourceOptionSetMappingId, EtlSourceOptionSetMappingUpdateDto update);

        /// <summary>
        /// Removes all source mappings (fresh re-upload).
        /// </summary>
        void DeleteAllMappings();

        /// <summary>
        /// Exports the full ETL Checklist as CSV: source columns + mapped CEDS columns + Generate
        /// destination columns joined from App.EtlMetadata.
        /// </summary>
        string ExportChecklistCsv();
    }
}
