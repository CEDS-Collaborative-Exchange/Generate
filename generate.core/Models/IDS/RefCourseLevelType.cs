﻿using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCourseLevelType
    {
        public RefCourseLevelType()
        {
            PsSection = new HashSet<PsSection>();
        }

        public int RefCourseLevelTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsSection> PsSection { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
