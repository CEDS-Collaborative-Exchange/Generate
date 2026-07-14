using System;

namespace generate.core.Models.App
{
    /// <summary>
    /// The "right" (CEDS / Generate destination) side of the ETL Checklist (App.EtlMetadata).
    /// Contains the complete CEDS vocabulary (terms, definitions, option set values) plus, for
    /// EDFacts file-spec rows, the Generate staging/RDS destination metadata.
    /// </summary>
    public class EtlMetadata
    {
        public int EtlMetadataId { get; set; }
        public int? PresentationSortOrder { get; set; }
        public int? CrossFileCombinationId { get; set; }
        public string EdFactsFileSpecNumber { get; set; }
        public string CedsPath { get; set; }
        public string CedsElementName { get; set; }
        public string CedsElementDefinition { get; set; }
        public string CedsDataType { get; set; }
        public string CedsDataLength { get; set; }
        public string CedsOptionSetCode { get; set; }
        public string CedsOptionSetDescription { get; set; }
        public string CedsElementGlobalId { get; set; }
        public string CedsElementDataModelId { get; set; }
        public string DestinationStagingTableName { get; set; }
        public string DestinationStagingColumnName { get; set; }
        public string DestinationStagingColumnDataType { get; set; }
        public string DestinationStagingColumnDataLength { get; set; }
        public string DestinationRdsDimensionTableName { get; set; }
        public string DestinationRdsDimensionColumnName { get; set; }
        public string DestinationRdsFactTableName { get; set; }
        public string DestinationRdsFactColumnName { get; set; }
        public string DestinationRdsReportTableName { get; set; }
        public string DestinationRdsReportColumnName { get; set; }
    }
}
