using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefTimeForCompletionUnits
    {
        public RefTimeForCompletionUnits()
        {
            PsProgram = new HashSet<PsProgram>();
        }

        public int RefTimeForCompletionUnitsId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsProgram> PsProgram { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
