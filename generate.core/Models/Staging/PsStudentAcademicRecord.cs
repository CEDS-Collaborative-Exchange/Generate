using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class PsStudentAcademicRecord
    {
        public int Id { get; set; }
        public string InstitutionIpedsUnitId { get; set; }
        public string StudentIdentifierState { get; set; }
        public DateTime? DiplomaOrCredentialAwardDate { get; set; }
        public string AcademicTermDesignator { get; set; }
        public string ProfessionalOrTechnicalCredentialConferred { get; set; }
        public DateTime? EntryDate { get; set; }
        public DateTime? ExitDate { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
