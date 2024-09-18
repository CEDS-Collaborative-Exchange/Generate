using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefEmployedAfterExit
    {
        public RefEmployedAfterExit()
        {
            AeStudentEmployment = new HashSet<AeStudentEmployment>();
            K12studentEmployment = new HashSet<K12studentEmployment>();
            PsStudentEmployment = new HashSet<PsStudentEmployment>();
        }

        public int RefEmployedAfterExitId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AeStudentEmployment> AeStudentEmployment { get; set; }
        public virtual ICollection<K12studentEmployment> K12studentEmployment { get; set; }
        public virtual ICollection<PsStudentEmployment> PsStudentEmployment { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
