using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefEmploymentStatus
    {
        public RefEmploymentStatus()
        {
            ElstaffEmployment = new HashSet<ElstaffEmployment>();
            K12staffEmployment = new HashSet<K12staffEmployment>();
        }

        public int RefEmploymentStatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ElstaffEmployment> ElstaffEmployment { get; set; }
        public virtual ICollection<K12staffEmployment> K12staffEmployment { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
