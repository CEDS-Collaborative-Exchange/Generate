using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class K12Enrollment
    {
        public int Id { get; set; }
        public string StudentIdentifierState { get; set; }
        public string LeaIdentifierSeaAccountability { get; set; }
        public string LeaIdentifierSeaAttendance { get; set; }
        public string LeaIdentifierSeaFunding { get; set; }
        public string LeaIdentifierSeaGraduation { get; set; }
        public string LeaIdentifierSeaIndividualizedEducationProgram { get; set; }
        public string LeaIdentifierSeaMembershipResident { get; set; }
        public string SchoolIdentifierSea { get; set; }
        public Boolean ResponsibleSchoolTypeAccountability { get; set; }
        public Boolean ResponsibleSchoolTypeAttendance { get; set; }
        public Boolean ResponsibleSchoolTypeFunding { get; set; }
        public Boolean ResponsibleSchoolTypeGraduation { get; set; }
        public Boolean ResponsibleSchoolTypeIndividualizedEducationProgram { get; set; }
        public Boolean ResponsibleSchoolTypeTransportation { get; set; }
        public Boolean ResponsibleSchoolTypeIepServiceProvider { get; set; }
        public string EducationOrganizationNetworkIdentifierSea { get; set; }

        public string FirstName { get; set; }
        public string LastOrSurname { get; set; }
        public string MiddleName { get; set; }
        public DateTime? Birthdate { get; set; }
        public string Sex { get; set; }
        public bool? HispanicLatinoEthnicity { get; set; }
        public DateTime? EnrollmentEntryDate { get; set; }
        public DateTime? EnrollmentExitDate { get; set; }
        public decimal? FullTimeEquivalency { get; set; }
        public string ExitOrWithdrawalType { get; set; }
        public string EnrollmentStatus { get; set; }
        public string EntryType { get; set; }
        public string GradeLevel { get; set; }
        public string CohortYear { get; set; }
        public string CohortGraduationYear { get; set; }
        public string CohortDescription { get; set; }
        public string ProjectedGraduationDate { get; set; }
        public string HighSchoolDiplomaType { get; set; }
        public decimal? NumberOfSchoolDays { get; set; }
        public decimal? NumberOfDaysAbsent { get; set; }
        public decimal? AttendanceRate { get; set; }
        public bool? PostSecondaryEnrollmentStatus { get; set; }
        public DateTime? DiplomaOrCredentialAwardDate { get; set; }
        public string FoodServiceEligibility { get; set; }
        public string ERSRuralUrbanContinuumCode {get; set;}
        public string RuralResidencyStatus { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
