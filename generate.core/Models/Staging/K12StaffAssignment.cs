using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class K12StaffAssignment
    {
        public int ID { get; set; }
        public string StaffMemberIdentifierState { get; set; }
        public string LeaIdentifierSea { get; set; }
        public string SchoolIdentifierSea { get; set; }
        public string FirstName { get; set; }
        public string LastOrSurname { get; set; }
        public string MiddleName { get; set; }
        public string BirthDate { get; set; }
        public string Sex { get; set; }
        public string PositionTitle { get; set; }
        public decimal? FullTimeEquivalency { get; set; }
        public string SpecialEducationStaffCategory { get; set; }
        public string K12StaffClassification { get; set; }
        public string TitleIProgramStaffCategory { get; set; }
        public string TeachingCredentialType { get; set; }
        public DateTime? CredentialIssuanceDate { get; set; }
        public DateTime? CredentialExpirationDate { get; set; }
        public string ParaprofessionalQualificationStatus { get; set; }
        public string SpecialEducationTeacherQualificationStatus { get; set; }
        public string SpecialEducationAgeGroupTaught { get; set; }
        public bool? HighlyQualifiedTeacherIndicator { get; set; }
        public DateTime? AssignmentStartDate { get; set; }
        public DateTime? AssignmentEndDate { get; set; }
        public string EdFactsTeacherInexperiencedStatus { get; set; }
        public string EDFactsTeacherOutOfFieldStatus { get; set; }
        public string EdFactsCertificationStatus { get; set; }
        public string ProgramTypeCode { get; set; }
        public string SchoolYear { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public string DataCollectionName { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
