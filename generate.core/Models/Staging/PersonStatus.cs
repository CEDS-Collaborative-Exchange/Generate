using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class PersonStatus
    {
        public int Id { get; set; }
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
        public DateTime? EnrollmentEntryDate { get; set; }
        public DateTime? EnrollmentExitDate { get; set; }
        public bool? HomelessnessStatus { get; set; }
        public DateTime? Homelessness_StatusStartDate { get; set; }
        public DateTime? Homelessness_StatusEndDate { get; set; }
        public string HomelessNightTimeResidence { get; set; }
        public DateTime? HomelessNightTimeResidence_StartDate { get; set; }
        public DateTime? HomelessNightTimeResidence_EndDate { get; set; }
        public bool? HomelessUnaccompaniedYouth { get; set; }
        public bool? HomelessServicedIndicator { get; set; }
        public bool? EconomicDisadvantageStatus { get; set; }
        public DateTime? EconomicDisadvantage_StatusStartDate { get; set; }
        public DateTime? EconomicDisadvantage_StatusEndDate { get; set; }
        public string EligibilityStatusForSchoolFoodServicePrograms { get; set; }
        public bool? NationalSchoolLunchProgramDirectCertificationIndicator { get; set; }
        public bool? MigrantStatus { get; set; }
        public DateTime? Migrant_StatusStartDate { get; set; }
        public DateTime? Migrant_StatusEndDate { get; set; }
        public string MilitaryConnectedStudentIndicator { get; set; }
        public DateTime? MilitaryConnected_StatusStartDate { get; set; }
        public DateTime? MilitaryConnected_StatusEndDate { get; set; }
        public string MilitaryActiveStudentIndicator { get; set; }
        public string MilitaryBranch { get; set; }
        public string MilitaryVeteranStudentIndicator { get; set; }
        public bool? ProgramType_FosterCare { get; set; }
        public DateTime? FosterCare_ProgramParticipationStartDate { get; set; }
        public DateTime? FosterCare_ProgramParticipationEndDate { get; set; }
        public bool? ProgramType_Section504 { get; set; }
        public DateTime? Section504_ProgramParticipationStartDate { get; set; }
        public DateTime? Section504_ProgramParticipationEndDate { get; set; }
        public bool? ProgramType_Immigrant { get; set; }
        public DateTime? Immigrant_ProgramParticipationStartDate { get; set; }
        public DateTime? Immigrant_ProgramParticipationEndDate { get; set; }
        public bool? EnglishLearnerStatus { get; set; }
        public DateTime? EnglishLearner_StatusStartDate { get; set; }
        public DateTime? EnglishLearner_StatusEndDate { get; set; }
        public string ISO_639_2_NativeLanguage { get; set; }
        public string ISO_639_2_HomeLanguage { get; set; }
        public string PerkinsEnglishLearnerStatus { get; set; }
        public DateTime? PerkinsEnglishLearnerStatus_StatusStartDate { get; set; }
        public DateTime? PerkinsEnglishLearnerStatus_StatusEndDate { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        public DateTime? RecordStartDatetime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }

    }
}
