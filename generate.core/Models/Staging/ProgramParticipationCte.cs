using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class ProgramParticipationCte
    {
        public int ID { get; set; }
        public string RecordId { get; set; }
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
        public string DiplomaCredentialType { get; set; }
        public string DiplomaCredentialType_2 { get; set; }
        public DateTime? DiplomaCredentialAwardDate { get; set; }
        public bool? CteParticipant { get; set; }
        public bool? CteConcentrator { get; set; }
        public bool? CteCompleter { get; set; }
        public bool? SingleParentIndicator { get; set; }
        public DateTime? SingleParent_StatusStartDate { get; set; }
        public DateTime? SingleParent_StatusEndDate { get; set; }
        public bool? DisplacedHomeMakerIndicator { get; set; }
        public DateTime? DisplacedHomeMaker_StatusStartDate { get; set; }
        public DateTime? DisplacedHomeMaker_StatusEndDate { get; set; }
        public DateTime? AdvancedTrainingEnrollmentDate { get; set; }
        public string PlacementType { get; set; }
        public string TechnicalSkillsAssessmentType { get; set; }
        public bool? NonTraditionalGenderStatus { get; set; }
        public bool? CTENontraditionalCompletion { get; set; }
        public string DataCollectionName { get; set; }
        public string CteExitReason { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
