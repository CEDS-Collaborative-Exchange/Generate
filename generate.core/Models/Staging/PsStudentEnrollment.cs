using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class PsStudentEnrollment
    {
        public int Id { get; set; }
        public string StudentIdentifierState { get; set; }
        public string InstitutionIpedsUnitId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string MiddleName { get; set; }
        public DateTime? Birthdate { get; set; }
        public string Sex { get; set; }
        public bool? HispanicLatinoEthnicity { get; set; }
        public string PostsecondaryExitOrWithdrawalType { get; set; }
        public DateTime? EntryDateIntoPostsecondary { get; set; }
        public DateTime? EntryDate { get; set; }
        public DateTime? ExitDate { get; set; }
        public string AcademicTermDesignator { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        //public int? DataCollectionId { get; set; }
        //public int? OrganizationIdPsInstitution { get; set; }
        //public int? PersonId { get; set; }
        //public int? OrganizationPersonRoleId { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
