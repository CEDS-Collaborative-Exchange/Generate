﻿using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCourseCreditLevelType
    {
        public RefCourseCreditLevelType()
        {
            PsCourse = new HashSet<PsCourse>();
        }

        public int RefCourseCreditLevelTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsCourse> PsCourse { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}