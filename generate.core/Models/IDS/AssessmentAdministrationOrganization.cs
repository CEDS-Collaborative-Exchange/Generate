using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentAdministrationOrganization
    {
        public int AssessmentAdministration_OrganizationId { get; set; }
        public int AssessmentAdministrationId { get; set; }
        public int OrganizationId { get; set; }

        public virtual AssessmentAdministration AssessmentAdministration { get; set; }
        public virtual Organization Organization { get; set; }
    }
}
