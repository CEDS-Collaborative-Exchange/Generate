using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class K12ProgramEnrollment
    {
        public int Id { get; set; }
        public string OrganizationIdentifier { get; set; }
        public string OrganizationType { get; set; }
        public string StudentIdentifierState { get; set; }
        public string ProgramType { get; set; }
        public DateTime? EntryDate { get; set; }
        public DateTime? ExitDate { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        //public int? DataCollectionId { get; set; }
        //public int? OrganizationId { get; set; }
        //public int? PersonId { get; set; }
        //public int? ProgramOrganizationId { get; set; }
        //public string OrganizationPersonRoleId { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
