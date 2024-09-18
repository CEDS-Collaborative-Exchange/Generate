using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCreditHoursAppliedOtherProgram
    {
        public RefCreditHoursAppliedOtherProgram()
        {
            PsStudentAcademicRecord = new HashSet<PsStudentAcademicRecord>();
        }

        public int RefCreditHoursAppliedOtherProgramId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsStudentAcademicRecord> PsStudentAcademicRecord { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
