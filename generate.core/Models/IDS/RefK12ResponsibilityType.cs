using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefK12responsibilityType
    {
        public RefK12responsibilityType()
        {
            K12organizationStudentResponsibility = new HashSet<K12organizationStudentResponsibility>();
        }

        public int RefK12responsibilityTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12organizationStudentResponsibility> K12organizationStudentResponsibility { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
