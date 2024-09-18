using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentAssessmentAdministration
    {
        public int AssessmentAssessmentAdministrationId { get; set; }
        public int AssessmentId { get; set; }
        public int AssessmentAdministrationId { get; set; }

        public virtual AssessmentAdministration AssessmentAdministration { get; set; }
        public virtual Assessment Assessment { get; set; }
    }
}
