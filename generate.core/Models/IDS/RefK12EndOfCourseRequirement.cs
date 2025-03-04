﻿using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefK12endOfCourseRequirement
    {
        public RefK12endOfCourseRequirement()
        {
            K12course = new HashSet<K12course>();
        }

        public int RefK12endOfCourseRequirementId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12course> K12course { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
