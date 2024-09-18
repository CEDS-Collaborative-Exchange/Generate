using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefSingleSexClassStatus
    {
        public RefSingleSexClassStatus()
        {
            CourseSection = new HashSet<CourseSection>();
        }

        public int RefSingleSexClassStatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<CourseSection> CourseSection { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
