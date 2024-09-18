using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12course
    {
        public K12course()
        {
            K12studentGraduationPlan = new HashSet<K12studentGraduationPlan>();
        }

        public int OrganizationId { get; set; }
        public bool? HighSchoolCourseRequirement { get; set; }
        public int? RefAdditionalCreditTypeId { get; set; }
        public decimal? AvailableCarnegieUnitCredit { get; set; }
        public int? RefCourseGpaApplicabilityId { get; set; }
        public bool? CoreAcademicCourse { get; set; }
        public int? RefCurriculumFrameworkTypeId { get; set; }
        public bool? CourseAlignedWithStandards { get; set; }
        public int RefCreditTypeEarnedId { get; set; }
        public string FundingProgram { get; set; }
        public bool? FamilyConsumerSciencesCourseInd { get; set; }
        public string ScedcourseCode { get; set; }
        public string ScedgradeSpan { get; set; }
        public int? RefScedcourseLevelId { get; set; }
        public int? RefScedcourseSubjectAreaId { get; set; }
        public int? RefCareerClusterId { get; set; }
        public int? RefBlendedLearningModelTypeId { get; set; }
        public int? RefCourseInteractionModeId { get; set; }
        public int? RefK12endOfCourseRequirementId { get; set; }
        public int? RefWorkbasedLearningOpportunityTypeId { get; set; }
        public string CourseDepartmentName { get; set; }

        public virtual ICollection<K12studentGraduationPlan> K12studentGraduationPlan { get; set; }
        public virtual Course Organization { get; set; }
        public virtual RefAdditionalCreditType RefAdditionalCreditType { get; set; }
        public virtual RefBlendedLearningModelType RefBlendedLearningModelType { get; set; }
        public virtual RefCareerCluster RefCareerCluster { get; set; }
        public virtual RefCourseGpaApplicability RefCourseGpaApplicability { get; set; }
        public virtual RefCourseInteractionMode RefCourseInteractionMode { get; set; }
        public virtual RefCreditTypeEarned RefCreditTypeEarned { get; set; }
        public virtual RefCurriculumFrameworkType RefCurriculumFrameworkType { get; set; }
        public virtual RefK12endOfCourseRequirement RefK12endOfCourseRequirement { get; set; }
        public virtual RefScedcourseLevel RefScedcourseLevel { get; set; }
        public virtual RefScedcourseSubjectArea RefScedcourseSubjectArea { get; set; }
        public virtual RefWorkbasedLearningOpportunityType RefWorkbasedLearningOpportunityType { get; set; }
    }
}
