using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12studentAcademicRecord
    {
        public int OrganizationPersonRoleId { get; set; }
        public decimal? CreditsAttemptedCumulative { get; set; }
        public decimal? CreditsEarnedCumulative { get; set; }
        public decimal? GradePointsEarnedCumulative { get; set; }
        public decimal? GradePointAverageCumulative { get; set; }
        public int? RefGpaWeightedIndicatorId { get; set; }
        public DateTime? ProjectedGraduationDate { get; set; }
        public int? HighSchoolStudentClassRank { get; set; }
        public DateTime? ClassRankingDate { get; set; }
        public int? TotalNumberInClass { get; set; }
        public DateTime? DiplomaOrCredentialAwardDate { get; set; }
        public int? RefHighSchoolDiplomaTypeId { get; set; }
        public int? RefHighSchoolDiplomaDistinctionTypeId { get; set; }
        public int? RefTechnologyLiteracyStatusId { get; set; }
        public int? RefPsEnrollmentActionId { get; set; }
        public int? RefPreAndPostTestIndicatorId { get; set; }
        public int? RefProfessionalTechnicalCredentialTypeId { get; set; }
   
        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefGpaWeightedIndicator RefGpaWeightedIndicator { get; set; }
        public virtual RefHighSchoolDiplomaDistinctionType RefHighSchoolDiplomaDistinctionType { get; set; }
        public virtual RefHighSchoolDiplomaType RefHighSchoolDiplomaType { get; set; }
        public virtual RefPreAndPostTestIndicator RefPreAndPostTestIndicator { get; set; }
        public virtual RefProfessionalTechnicalCredentialType RefProfessionalTechnicalCredentialType { get; set; }
        public virtual RefPsEnrollmentAction RefPsEnrollmentAction { get; set; }
        public virtual RefTechnologyLiteracyStatus RefTechnologyLiteracyStatus { get; set; }
    }
}
