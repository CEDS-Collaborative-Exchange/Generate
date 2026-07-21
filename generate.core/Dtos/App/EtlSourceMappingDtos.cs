using System.Collections.Generic;
using generate.core.Models.App;

namespace generate.core.Dtos.App
{
    /// <summary>
    /// Upload payload for a state's bespoke data dictionary (parsed client-side from CSV/XLSX).
    /// </summary>
    public class EtlSourceMappingUploadDto
    {
        /// <summary>When set, elements are appended to this existing map instead of creating one.</summary>
        public int? EtlMapId { get; set; }
        public string MapName { get; set; }
        public string UploadFileName { get; set; }
        public string UploadedBy { get; set; }
        public List<EtlSourceElementUploadDto> Elements { get; set; }
    }

    /// <summary>
    /// One EDFacts file spec association: by spec number (e.g. FS002) or by Fact Type.
    /// </summary>
    public class EtlMapFileSpecDto
    {
        public string FileSpecNumber { get; set; }
        public int? DimFactTypeId { get; set; }
        public string FactTypeCode { get; set; }
    }

    /// <summary>
    /// Create/edit payload for a map: name plus its EDFacts file spec associations.
    /// </summary>
    public class EtlMapSaveDto
    {
        public string MapName { get; set; }
        public List<EtlMapFileSpecDto> FileSpecs { get; set; }
        public string ModifiedBy { get; set; }
    }

    /// <summary>
    /// A Fact Type from rds.DimFactTypes (for the map file spec picker).
    /// </summary>
    public class FactTypeDto
    {
        public int DimFactTypeId { get; set; }
        public string FactTypeCode { get; set; }
        public string FactTypeDescription { get; set; }
    }

    /// <summary>
    /// A named ETL mapping set with audit and progress counts (for the maps list view).
    /// </summary>
    public class EtlMapDto
    {
        public int EtlMapId { get; set; }
        public string MapName { get; set; }
        public string UploadFileName { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public System.DateTime? ModifiedDate { get; set; }
        public string ModifiedBy { get; set; }
        public int ElementCount { get; set; }
        public int MappedElementCount { get; set; }
        public List<EtlMapFileSpecDto> FileSpecs { get; set; }
    }

    /// <summary>
    /// One source data dictionary element with its option set (enumeration) values.
    /// </summary>
    public class EtlSourceElementUploadDto
    {
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
        public string SelectionCriteria { get; set; }
        public string TransformationRules { get; set; }
        public string Notes { get; set; }
        public List<EtlSourceOptionSetValueUploadDto> OptionSetValues { get; set; }
    }

    /// <summary>
    /// One source option set (enumeration) value of an uploaded element.
    /// </summary>
    public class EtlSourceOptionSetValueUploadDto
    {
        public string SourceOptionSetCode { get; set; }
        public string SourceOptionSetDescription { get; set; }
    }

    /// <summary>
    /// A distinct CEDS element from the App.EtlMetadata catalog.
    /// </summary>
    public class CedsElementCatalogDto
    {
        public string CedsElementGlobalId { get; set; }
        public string CedsElementName { get; set; }
        public string CedsElementDefinition { get; set; }
        public string CedsPath { get; set; }
        public string CedsDataModelId { get; set; }
        public bool HasOptionSet { get; set; }
    }

    /// <summary>
    /// A CEDS element match candidate with automapping confidence (0-1).
    /// </summary>
    public class CedsElementMatchDto : CedsElementCatalogDto
    {
        public decimal Confidence { get; set; }
    }

    /// <summary>
    /// One CEDS option set value of a CEDS element from the App.EtlMetadata catalog.
    /// </summary>
    public class CedsOptionSetValueDto
    {
        public string CedsOptionSetCode { get; set; }
        public string CedsOptionSetDescription { get; set; }
    }

    /// <summary>
    /// A CEDS option set value match candidate with automapping confidence (0-1).
    /// </summary>
    public class CedsOptionSetMatchDto : CedsOptionSetValueDto
    {
        public decimal Confidence { get; set; }
        public string MatchType { get; set; }
    }

    /// <summary>
    /// Result of uploading and automapping one source element: the persisted mapping row plus the
    /// top CEDS element candidates for review.
    /// </summary>
    public class EtlSourceElementMappingResultDto
    {
        public EtlSourceElementMapping Mapping { get; set; }
        public List<CedsElementMatchDto> Candidates { get; set; }
    }

    /// <summary>
    /// Review update for an element mapping (accept / reject / not-in-CEDS / manual override).
    /// </summary>
    public class EtlSourceElementMappingUpdateDto
    {
        public string CedsElementGlobalId { get; set; }
        public string MappingStatus { get; set; }
        public string ElementDefinitionResponseId { get; set; }
        public string SelectionCriteria { get; set; }
        public string TransformationRules { get; set; }
        public string Notes { get; set; }
        public string ModifiedBy { get; set; }
    }

    /// <summary>
    /// Review update for an option set value mapping (accept / manual override).
    /// </summary>
    public class EtlSourceOptionSetMappingUpdateDto
    {
        public string CedsOptionSetCode { get; set; }
        public string CedsOptionSetDescription { get; set; }
        public string MappingStatus { get; set; }
        public string OptionSetResponseId { get; set; }
        public string ModifiedBy { get; set; }
    }
}
