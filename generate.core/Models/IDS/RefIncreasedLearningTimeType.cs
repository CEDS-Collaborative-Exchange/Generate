﻿using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefIncreasedLearningTimeType
    {
        public RefIncreasedLearningTimeType()
        {
            K12school = new HashSet<K12school>();
        }

        public int RefIncreasedLearningTimeTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12school> K12school { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}