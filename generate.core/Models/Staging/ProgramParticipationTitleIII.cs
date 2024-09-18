using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class ProgramParticipationTitleIII
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
        public Boolean TitleIIIImmigrantParticipationStatus { get; set; }
        public string Proficiency_TitleIII { get; set; }
        public string TitleIIIAccountabilityProgressStatus { get; set; }
        public bool? EnglishLearnerParticipation { get; set; }
        public bool? TitleIIIImmigrantStatus { get; set; }
        public string TitleIIILanguageInstructionProgramType { get; set; }
        public DateTime? TitleIIIImmigrantStatus_StartDate { get; set; }
        public DateTime? TitleIIIImmigrantStatus_EndDate { get; set; }
        public string DataCollectionName { get; set; }
        //public int? PersonID { get; set; }
        //public int? OrganizationID_School { get; set; }
        //public int? OrganizationPersonRoleID_TitleIIIProgram { get; set; }
        //public int? OrganizationID_TitleIIIProgram { get; set; }
        //public int? PersonProgramParticipationId { get; set; }
        //public int? ImmigrationPersonStatusId { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
