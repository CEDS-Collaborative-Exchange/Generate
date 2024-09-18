using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCourseInstructionSiteType
    {
        public RefCourseInstructionSiteType()
        {
            PsSectionLocation = new HashSet<PsSectionLocation>();
        }

        public int RefCourseInstructionSiteTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsSectionLocation> PsSectionLocation { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
