using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class AssessmentResult
    {
        public int Id { get; set; }
        public string StudentIdentifierState { get; set; }
        public string LeaIdentifierSeaAccountability { get; set; }
        public string LeaIdentifierSeaAttendance { get; set; }
        public string LeaIdentifierSeaFunding { get; set; }
        public string LeaIdentifierSeaGraduation { get; set; }
        public string LeaIdentifierSeaIndividualizedEducationProgram { get; set; }
        public string SchoolIdentifierSea { get; set; }
        public string AssessmentIdentifier { get; set; }
        public string AssessmentTitle { get; set; }
        public string AssessmentAcademicSubject { get; set; }
        public string AssessmentPurpose { get; set; }
        public string AssessmentType { get; set; }
        public string AssessmentTypeAdministered { get; set; }
        public string AssessmentTypeAdministeredToEnglishLearners { get; set; }
        public DateTime? AssessmentAdministrationStartDate { get; set; }
        public DateTime? AssessmentAdministrationFinishDate { get; set; }
        public bool? AssessmentRegistrationParticipationIndicator { get; set; }
        public string GradeLevelWhenAssessed { get; set; }
        public string ScoreValue { get; set; }
        public bool? StateFullAcademicYear { get; set; }
        public bool? LEAFullAcademicYear { get; set; }
        public bool? SchoolFullAcademicYear { get; set; }
        public string AssessmentRegistrationReasonNotCompleting { get; set; }
        public string AssessmentRegistrationReasonNotTested { get; set; }
        public string AssessmentPerformanceLevelIdentifier { get; set; }
        public string AssessmentPerformanceLevelLabel { get; set; }
        public string AssessmentScoreMetricType { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        //public int? DataCollectionId { get; set; }
        //public int? AssessmentRegistrationId { get; set; }
        //public int? AssessmentAdministrationId { get; set; }
        //public int? AssessmentId { get; set; }
        //public int? PersonId { get; set; }
        //public int? AssessmentFormId { get; set; }
        //public int? AssessmentSubtestId { get; set; }
        //public int? AssessmentPerformanceLevelId { get; set; }
        //public int? AssessmentResultId { get; set; }
        //public int? AssessmentResult_PerformanceLevelId { get; set; }
        //public int? OrganizationID_LEA { get; set; }
        //public int? OrganizationPersonRoleId_LEA { get; set; }
        //public int? OrganizationID_School { get; set; }
        //public int? OrganizationPersonRoleId_School { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
