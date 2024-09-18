using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class PsStudentAcademicAward
    {
        public int Id { get; set; }
        public string InstitutionIpedsUnitId { get; set; }
        public string StudentIdentifierState { get; set; }
        public string ProfessionalOrTechnicalCredentialConferred { get; set; }
        public DateTime? AcademicAwardDate { get; set; }
        public string PescAwardLevelType { get; set; }
        public string AcademicAwardTitle { get; set; }
        public DateTime? EntryDate { get; set; }
        public DateTime? ExitDate { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        //public int? DataCollectionId { get; set; }
        //public int? OrganizationId { get; set; }
        //public int? PersonId { get; set; }
        //public int? OrganizationPersonRoleId { get; set; }
        //public int? PsStudentAcademicAwardId { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
