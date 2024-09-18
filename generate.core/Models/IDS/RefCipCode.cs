using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCipCode
    {
        public RefCipCode()
        {
            PsCourse = new HashSet<PsCourse>();
            PsProgram = new HashSet<PsProgram>();
            PsSection = new HashSet<PsSection>();
        }

        public int RefCipCodeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsCourse> PsCourse { get; set; }
        public virtual ICollection<PsProgram> PsProgram { get; set; }
        public virtual ICollection<PsSection> PsSection { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
