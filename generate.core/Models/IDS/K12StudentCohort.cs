using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12studentCohort
    {
        public int OrganizationPersonRoleId { get; set; }
        public string CohortYear { get; set; }
        public string CohortGraduationYear { get; set; }
        public string GraduationRateSurveyCohortYear { get; set; }
        public bool? GraduationRateSurveyIndicator { get; set; }
        public string CohortDescription { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
    }
}
