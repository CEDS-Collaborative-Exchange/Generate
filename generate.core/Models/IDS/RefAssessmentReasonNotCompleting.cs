﻿using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentReasonNotCompleting
    {
        public RefAssessmentReasonNotCompleting()
        {
            AssessmentRegistration = new HashSet<AssessmentRegistration>();
        }

        public int RefAssessmentReasonNotCompletingId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentRegistration> AssessmentRegistration { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}