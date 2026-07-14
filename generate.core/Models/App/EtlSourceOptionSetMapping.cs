using System;
using System.Text.Json.Serialization;

namespace generate.core.Models.App
{
    /// <summary>
    /// One option set (enumeration) value of a source data dictionary element and its mapping to a
    /// CEDS option set value (App.EtlSourceOptionSetMapping).
    /// </summary>
    public class EtlSourceOptionSetMapping
    {
        public int EtlSourceOptionSetMappingId { get; set; }
        public int EtlSourceElementMappingId { get; set; }

        // Source option set value
        public string SourceOptionSetCode { get; set; }
        public string SourceOptionSetDescription { get; set; }

        // CEDS option set mapping
        public string CedsOptionSetCode { get; set; }
        public string CedsOptionSetDescription { get; set; }
        public string OptionSetResponseId { get; set; }

        // Automapping metadata
        public decimal? MatchConfidence { get; set; }
        public string MatchType { get; set; }
        public string MappingStatus { get; set; }

        // Audit
        public DateTime CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public string ModifiedBy { get; set; }

        // Back-reference excluded from serialization to avoid a JSON cycle
        [JsonIgnore]
        public EtlSourceElementMapping EtlSourceElementMapping { get; set; }
    }
}
