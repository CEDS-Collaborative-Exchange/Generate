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
        public DateTime? RunDateTime { get; set; }
    }
}
