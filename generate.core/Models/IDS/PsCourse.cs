using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsCourse
    {
        public int OrganizationId { get; set; }
        public int? RefCourseCreditBasisTypeId { get; set; }
        public int? RefCourseCreditLevelTypeId { get; set; }
        public string CourseNumber { get; set; }
        public string OriginalCourseIdentifier { get; set; }
        public string OverrideSchoolCourseNumber { get; set; }
        public int? RefNcescollegeCourseMapCodeId { get; set; }
        public int? NcaaeligibilityInd { get; set; }
        public int? RefCipCodeId { get; set; }

        public virtual Course Organization { get; set; }
        public virtual RefCipCode RefCipCode { get; set; }
        public virtual RefCourseCreditBasisType RefCourseCreditBasisType { get; set; }
        public virtual RefCourseCreditLevelType RefCourseCreditLevelType { get; set; }
        public virtual RefNcescollegeCourseMapCode RefNcescollegeCourseMapCode { get; set; }
    }
}
