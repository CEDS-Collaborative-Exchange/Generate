using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class Discipline
    {
        public int Id { get; set; }
        public Int16 SchoolYear { get; set; }
        public string StudentIdentifierState { get; set; }
        public string LeaIdentifierSeaAccountability { get; set; }
        public string LeaIdentifierSeaAttendance { get; set; }
        public string LeaIdentifierSeaFunding { get; set; }
        public string LeaIdentifierSeaGraduation { get; set; }
        public string LeaIdentifierSeaIndividualizedEducationProgram { get; set; }
        public string SchoolIdentifierSea { get; set; }
        public string DisciplineActionIdentifier { get; set; }
        public string IncidentIdentifier { get; set; }
        public DateTime? IncidentDate { get; set; }
        public TimeSpan? IncidentTime { get; set; }
        public string DisciplinaryActionTaken { get; set; }
        public string DisciplineReason { get; set; }
        public DateTime? DisciplinaryActionStartDate { get; set; }
        public DateTime? DisciplinaryActionEndDate { get; set; }
        public string IncidentInjuryType { get; set; }
        public string IncidentBehavior { get; set; }
        public string DurationOfDisciplinaryAction { get; set; }
        public string IdeaInterimRemoval { get; set; }
        public string IdeaInterimRemovalReason { get; set; }
        public bool? EducationalServicesAfterRemoval { get; set; }
        public string DisciplineMethodFirearm { get; set; }
        public string IDEADisciplineMethodFirearm { get; set; }
        public string DisciplineMethodOfCwd { get; set; }
        public string WeaponType { get; set; }
        public string FirearmType { get; set; }
        public string DataCollectionName { get; set; }
        //public int? PersonId { get; set; }
        //public int? OrganizationID_LEA { get; set; }
        //public int? OrganizationPersonRoleId_LEA { get; set; }
        //public int? OrganizationID_School { get; set; }
        //public int? OrganizationPersonRoleId_School { get; set; }
        //public int? IncidentId_LEA { get; set; }
        //public int? IncidentId_School { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
