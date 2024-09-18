using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCourseHonorsType
    {
        public RefCourseHonorsType()
        {
            PsSection = new HashSet<PsSection>();
        }

        public int RefCourseHonorsTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsSection> PsSection { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
