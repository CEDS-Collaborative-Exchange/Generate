﻿using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefEmploymentSeparationType
    {
        public RefEmploymentSeparationType()
        {
            StaffEmployment = new HashSet<StaffEmployment>();
        }

        public int RefEmploymentSeparationTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<StaffEmployment> StaffEmployment { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}