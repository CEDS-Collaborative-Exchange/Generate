﻿using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAcademicRank
    {
        public RefAcademicRank()
        {
            PsStaffEmployment = new HashSet<PsStaffEmployment>();
        }

        public int RefAcademicRankId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsStaffEmployment> PsStaffEmployment { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
