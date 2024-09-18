using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefDoctoralExamsRequiredCode
    {
        public RefDoctoralExamsRequiredCode()
        {
            PsStudentEnrollment = new HashSet<PsStudentEnrollment>();
        }

        public int RefDoctoralExamsRequiredCodeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsStudentEnrollment> PsStudentEnrollment { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
