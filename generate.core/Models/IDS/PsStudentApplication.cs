using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsStudentApplication
    {
        public int OrganizationPersonRoleId { get; set; }
        public bool? PostsecondaryApplicant { get; set; }
        public decimal? GradePointAverageCumulative { get; set; }
        public int? RefGradePointAverageDomainId { get; set; }
        public int? RefGpaWeightedIndicatorId { get; set; }
        public decimal? HighSchoolPercentile { get; set; }
        public int? HighSchoolStudentClassRank { get; set; }
        public int? HighSchoolGraduatingClassSize { get; set; }
        public int? RefAdmittedStudentId { get; set; }
        public bool? WaitListedStudent { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefAdmittedStudent RefAdmittedStudent { get; set; }
        public virtual RefGpaWeightedIndicator RefGpaWeightedIndicator { get; set; }
        public virtual RefGradePointAverageDomain RefGradePointAverageDomain { get; set; }
    }
}
