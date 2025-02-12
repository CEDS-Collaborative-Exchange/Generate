﻿using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentItemResponseStatus
    {
        public RefAssessmentItemResponseStatus()
        {
            AssessmentItemResponse = new HashSet<AssessmentItemResponse>();
        }

        public int RefAssessmentItemResponseStatusId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentItemResponse> AssessmentItemResponse { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
