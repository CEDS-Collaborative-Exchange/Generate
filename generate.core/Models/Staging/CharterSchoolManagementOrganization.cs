using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class CharterSchoolManagementOrganization
    {
        public int Id { get; set; }
        public string CharterSchoolManagementOrganization_Identifier_EIN { get; set; }
        public string CharterSchoolManagementOrganization_Name { get; set; }
        public string CharterSchoolManagementOrganization_Type { get; set; }
        public string OrganizationIdentifier { get; set; }
        public string DataCollectionName { get; set; }
        //public int? DataCollectionId { get; set; }
        //public int? CharterSchoolManagementOrganizationId { get; set; }
        //public int? CharterSchoolId { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
