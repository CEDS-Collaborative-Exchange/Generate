using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAdmittedStudent
    {
        public RefAdmittedStudent()
        {
            PsStudentApplication = new HashSet<PsStudentApplication>();
        }

        public int RefAdmittedStudentId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsStudentApplication> PsStudentApplication { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
