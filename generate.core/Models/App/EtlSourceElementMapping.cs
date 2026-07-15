using System;
using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace generate.core.Models.App
{
    /// <summary>
    /// The "left" (source / state data dictionary) side of the ETL Checklist (App.EtlSourceElementMapping).
    /// One row per element in the state's uploaded bespoke data dictionary, with its mapping to a CEDS
    /// element (related to App.EtlMetadata through CedsElementGlobalId).
    /// </summary>
    public class EtlSourceElementMapping
    {
        public int EtlSourceElementMappingId { get; set; }
        public int? EtlMapId { get; set; }

        // Source System & Element Details
        public string SourceCommonName { get; set; }
        public string SourceTechnicalName { get; set; }
        public string SourceDatabaseName { get; set; }
        public string SourceSchemaName { get; set; }
        public string SourceTableName { get; set; }
        public string SourceColumnName { get; set; }
        public string SourceElementName { get; set; }
        public string SourceElementDefinition { get; set; }
        public string SourceDataType { get; set; }
        public string SourceDataLength { get; set; }
        public string SourceDataSteward { get; set; }

        // Source to Generate Transformation
        public string SelectionCriteria { get; set; }
        public string TransformationRules { get; set; }
        public string Notes { get; set; }

        // CEDS element mapping
        public string CedsElementGlobalId { get; set; }
        public string CedsElementName { get; set; }
        public string CedsElementDefinition { get; set; }
        public string CedsDataModelId { get; set; }
        public string CedsPath { get; set; }
        public string ElementDefinitionResponseId { get; set; }

        // Automapping metadata
        public decimal? MatchConfidence { get; set; }
        public string MatchType { get; set; }
        public string MappingStatus { get; set; }

        // Audit
        public string UploadFileName { get; set; }
        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public string ModifiedBy { get; set; }

        public List<EtlSourceOptionSetMapping> EtlSourceOptionSetMappings { get; set; }

        // Back-reference excluded from serialization to avoid a JSON cycle
        [JsonIgnore]
        public EtlMap EtlMap { get; set; }
    }
}
