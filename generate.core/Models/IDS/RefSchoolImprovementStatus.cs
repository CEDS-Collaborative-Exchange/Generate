﻿using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefSchoolImprovementStatus
    {
        public RefSchoolImprovementStatus()
        {
            K12schoolImprovement = new HashSet<K12schoolImprovement>();
        }

        public int RefSchoolImprovementStatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12schoolImprovement> K12schoolImprovement { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}