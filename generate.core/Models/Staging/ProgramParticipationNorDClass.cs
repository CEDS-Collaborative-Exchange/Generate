using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class ProgramParticipationNorDClass
    {
        public int ID { get; set; }
        public string StudentIdentifierState { get; set; }
        public string LeaIdentifierSeaAccountability { get; set; }
        public string LeaIdentifierSeaAttendance { get; set; }
        public string LeaIdentifierSeaFunding { get; set; }
        public string LeaIdentifierSeaGraduation { get; set; }
        public string LeaIdentifierSeaIndividualizedEducationProgram { get; set; }
        public string SchoolIdentifierSea { get; set; }
        public Boolean ResponsibleSchoolTypeAccountability { get; set; }
        public Boolean ResponsibleSchoolTypeAttendance { get; set; }
        public Boolean ResponsibleSchoolTypeFunding { get; set; }
        public Boolean ResponsibleSchoolTypeGraduation { get; set; }
        public Boolean ResponsibleSchoolTypeIndividualizedEducationProgram { get; set; }
        public Boolean ResponsibleSchoolTypeTransportation { get; set; }
        public Boolean ResponsibleSchoolTypeIepServiceProvider { get; set; }
        public DateTime? ProgramParticipationBeginDate { get; set; }
        public DateTime? ProgramParticipationEndDate { get; set; }
        public string NeglectedOrDelinquentProgramType { get; set; }
        public string NeglectedOrDelinquentProgramEnrollmentSubpart { get; set; }
        public bool? NeglectedOrDelinquentStatus { get; set; }
        public string NeglectedProgramType { get; set; }
        public string DelinquentProgramType { get; set; }
        public string ProgressLevel_Reading { get; set; }
        public string ProgressLevel_Math { get; set; }
        public bool? NeglectedOrDelinquentAcademicOutcomeIndicator { get; set; }
        public bool? NeglectedOrDelinquentAcademicAchievementIndicator { get; set; }
        //public bool? NeglectedOrDelinquentLongTermStatus { get; set; }
        public string EdFactsAcademicOrCareerAndTechnicalOutcomeType { get; set; }
        public string EdFactsAcademicOrCareerAndTechnicalOutcomeExitType { get; set; }
        public DateTime? DiplomaCredentialAwardDate { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
