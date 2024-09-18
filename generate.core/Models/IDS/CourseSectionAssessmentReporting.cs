using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class CourseSectionAssessmentReporting
    {
        public int CourseSectionAssessmentReportingId { get; set; }
        public int? OrganizationId { get; set; }
        public int? RefCourseSectionAssessmentReportingMethodId { get; set; }

        public virtual CourseSection Organization { get; set; }
        public virtual RefCourseSectionAssessmentReportingMethod RefCourseSectionAssessmentReportingMethod { get; set; }
    }
}
