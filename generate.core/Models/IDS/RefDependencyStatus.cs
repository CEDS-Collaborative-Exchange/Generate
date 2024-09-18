using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefDependencyStatus
    {
        public RefDependencyStatus()
        {
            PsStudentDemographic = new HashSet<PsStudentDemographic>();
        }

        public int RefDependencyStatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsStudentDemographic> PsStudentDemographic { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
