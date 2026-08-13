using System;
using System.Text.Json.Serialization;

namespace generate.core.Models.App
{
    /// <summary>
    /// A source dataset registered to an ETL map (App.EtlMapSource, CIID-9061). A single file spec
    /// often draws from several source systems; each row is one source table/view/query the map's
    /// alignment mappings and generated ETL pull from. The AI ETL Developer joins these on the shared
    /// business keys (student id, LEA id, school id, school year) into the file spec's Staging tables.
    /// </summary>
    public class EtlMapSource
    {
        public int EtlMapSourceId { get; set; }
        public int EtlMapId { get; set; }

        /// <summary>Short alias for the source, e.g. "SIS_Enrollment", "SpEd", "Race".</summary>
        public string SourceName { get; set; }

        /// <summary>Server/database/schema or connection descriptor (informational).</summary>
        public string SourceConnection { get; set; }

        /// <summary>The source object the ETL reads from: schema.table, view, or a query.</summary>
        public string SourceObject { get; set; }

        /// <summary>Optional notes (join hints, filters, caveats) for this source.</summary>
        public string Notes { get; set; }

        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public string ModifiedBy { get; set; }

        [JsonIgnore]
        public EtlMap EtlMap { get; set; }
    }
}
