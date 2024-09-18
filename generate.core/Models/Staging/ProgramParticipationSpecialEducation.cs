using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class ProgramParticipationSpecialEducation
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
        public bool? IDEAIndicator { get; set; }
        public string SpecialEducationExitReason { get; set; }
        public string IDEAEducationalEnvironmentForEarlyChildhood { get; set; }
        public string IDEAEducationalEnvironmentForSchoolAge { get; set; }
        public decimal? SpecialEducationFTE { get; set; }
        public string DataCollectionName { get; set; }
        //public int? DataCollectionId { get; set; }
        //public int? PersonID { get; set; }
        //public int? OrganizationID_IEU { get; set; }
        //public int? OrganizationID_LEA { get; set; }
        //public int? OrganizationID_School { get; set; }
        //public int? LEAOrganizationID_Program{ get; set; }
        //public int? SchoolOrganizationID_Program { get; set; }
        //public int? LEAOrganizationPersonRoleId_Program { get; set; }
        //public int? SchoolOrganizationPersonRoleId_Program { get; set; }
        //public int? PersonProgramParticipationID_LEA { get; set; }
        //public int? PersonProgramParticipationID_School { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
