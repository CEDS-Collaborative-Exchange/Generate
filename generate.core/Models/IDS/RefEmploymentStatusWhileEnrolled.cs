using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefEmploymentStatusWhileEnrolled
    {
        public RefEmploymentStatusWhileEnrolled()
        {
            PsStudentEmployment = new HashSet<PsStudentEmployment>();
        }

        public int RefEmploymentStatusWhileEnrolledId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsStudentEmployment> PsStudentEmployment { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
