using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefTuitionUnit
    {
        public RefTuitionUnit()
        {
            PsPriceOfAttendance = new HashSet<PsPriceOfAttendance>();
        }

        public int RefTuitionUnitId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsPriceOfAttendance> PsPriceOfAttendance { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
