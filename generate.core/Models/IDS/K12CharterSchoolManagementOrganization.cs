using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
   
    public partial class K12CharterSchoolManagementOrganization
    {

        public int K12CharterSchoolManagementOrganizationId { get; set; }
        public int OrganizationId { get; set; }
        public int? RefCharterSchoolManagementOrganizationTypeId { get; set; }
        public virtual Organization Organization { get; set; }
        public virtual RefCharterSchoolManagementOrganizationType RefCharterSchoolManagementOrganizationType { get; set; }
    }
}
