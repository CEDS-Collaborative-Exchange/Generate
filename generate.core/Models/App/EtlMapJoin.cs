using System;
using System.Text.Json.Serialization;

namespace generate.core.Models.App
{
    /// <summary>
    /// One join condition between two source objects of an ETL map (App.EtlMapJoin, CIID-9061). A file
    /// spec that draws from several sources must tell the AI ETL Developer exactly how those tables relate
    /// — otherwise a small model invents join columns and the load fails on "Invalid column name". Each row
    /// is a single equality condition: LeftSourceObject.LeftColumn = RightSourceObject.RightColumn. A
    /// composite (multi-column) join is expressed as several rows for the same table pair, ordered by
    /// SortOrder. JoinType applies to the table pair (INNER / LEFT / RIGHT / FULL).
    /// </summary>
    public class EtlMapJoin
    {
        public int EtlMapJoinId { get; set; }
        public int EtlMapId { get; set; }

        /// <summary>Left source object (schema.table / view) — e.g. Source.MembershipExtract2026.</summary>
        public string LeftSourceObject { get; set; }

        /// <summary>Column on the left source in this equality condition.</summary>
        public string LeftColumn { get; set; }

        /// <summary>Right source object (schema.table / view) — e.g. Source.PersonStatusExtract2026.</summary>
        public string RightSourceObject { get; set; }

        /// <summary>Column on the right source in this equality condition.</summary>
        public string RightColumn { get; set; }

        /// <summary>Join type for this table pair: INNER, LEFT, RIGHT, FULL. Defaults to LEFT.</summary>
        public string JoinType { get; set; }

        /// <summary>Orders the conditions/rows for a table pair (0-based).</summary>
        public int SortOrder { get; set; }

        public DateTime CreatedDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public string ModifiedBy { get; set; }

        [JsonIgnore]
        public EtlMap EtlMap { get; set; }
    }
}
