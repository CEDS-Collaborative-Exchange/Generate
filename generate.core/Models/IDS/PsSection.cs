using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsSection
    {
        public int OrganizationId { get; set; }
        public string GradeValueQualifier { get; set; }
        public int? RefCipCodeId { get; set; }
        public int? RefCourseGpaApplicabilityId { get; set; }
        public int? RefCourseHonorsTypeId { get; set; }
        public int? RefCourseInstructionMethodId { get; set; }
        public int? RefCourseLevelTypeId { get; set; }
        public int? RefDevelopmentalEducationTypeId { get; set; }
        public int? RefWorkbasedLearningOpportunityTypeId { get; set; }

        public virtual PsSectionLocation PsSectionLocation { get; set; }
        public virtual CourseSection Organization { get; set; }
        public virtual RefCipCode RefCipCode { get; set; }
        public virtual RefCourseGpaApplicability RefCourseGpaApplicability { get; set; }
        public virtual RefCourseHonorsType RefCourseHonorsType { get; set; }
        public virtual RefCourseInstructionMethod RefCourseInstructionMethod { get; set; }
        public virtual RefCourseLevelType RefCourseLevelType { get; set; }
        public virtual RefDevelopmentalEducationType RefDevelopmentalEducationType { get; set; }
        public virtual RefWorkbasedLearningOpportunityType RefWorkbasedLearningOpportunityType { get; set; }
    }
}
