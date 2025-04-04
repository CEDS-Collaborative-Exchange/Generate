﻿using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentNeedUserSpokenPreferenceType
    {
        public RefAssessmentNeedUserSpokenPreferenceType()
        {
            AssessmentNeedApipContent = new HashSet<AssessmentNeedApipContent>();
        }

        public int RefAssessmentNeedUserSpokenPreferenceTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentNeedApipContent> AssessmentNeedApipContent { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
