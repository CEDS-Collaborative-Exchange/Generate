using System;
using System.Text.Json.Serialization;

namespace generate.core.Models.App
{
    /// <summary>
    /// Associates an ETL map with one EDFacts file spec (App.EtlMapFileSpec), identified either by
    /// spec number (e.g. FS002) or by Fact Type (rds.DimFactTypes). FactTypeCode is denormalized so
    /// the association survives RDS dimension reloads.
    /// </summary>
    public class EtlMapFileSpec
    {
        public int EtlMapFileSpecId { get; set; }
        public int EtlMapId { get; set; }
        public string FileSpecNumber { get; set; }
        public int? DimFactTypeId { get; set; }
        public string FactTypeCode { get; set; }
        public DateTime CreatedDate { get; set; }

        // Back-reference excluded from serialization to avoid a JSON cycle
        [JsonIgnore]
        public EtlMap EtlMap { get; set; }
    }
}
