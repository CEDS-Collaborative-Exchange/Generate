using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12studentLiteracyAssessment
    {
        public int OrganizationPersonRoleId { get; set; }
        public int? RefLiteracyAssessmentId { get; set; }
        public bool? LiteracyPreTestStatus { get; set; }
        public bool? LiteracyPostTestStatus { get; set; }
        public bool? LiteracyGoalMetStatus { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefLiteracyAssessment RefLiteracyAssessment { get; set; }
    }
}
