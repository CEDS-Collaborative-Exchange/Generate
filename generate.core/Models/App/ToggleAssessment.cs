using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace generate.core.Models.App
{
    public class ToggleAssessment
    {
        public int ToggleAssessmentId { get; set; }
        public string AssessmentTypeCode { get; set; }
        public string AssessmentType { get; set; }
        public string AssessmentName { get; set; }
        public string PerformanceLevels { get; set; }
        public string ProficientOrAboveLevel { get; set; }
        public string Grade { get; set; }
        public string EOG { get; set; }
        public string Subject { get; set; }

    }
}
