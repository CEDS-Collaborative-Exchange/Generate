﻿using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefLearningStandardItemTestabilityType
    {
        public RefLearningStandardItemTestabilityType()
        {
            LearningStandardItem = new HashSet<LearningStandardItem>();
        }

        public int RefLearningStandardItemTestabilityTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<LearningStandardItem> LearningStandardItem { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}