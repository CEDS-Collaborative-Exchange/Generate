using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class StaffEvaluation
    {
        public int StaffEvaluationId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public string System { get; set; }
        public string Scale { get; set; }
        public string ScoreOrRating { get; set; }
        public string Outcome { get; set; }
        public int? RefStaffPerformanceLevelId { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefStaffPerformanceLevel RefStaffPerformanceLevel { get; set; }
    }
}
