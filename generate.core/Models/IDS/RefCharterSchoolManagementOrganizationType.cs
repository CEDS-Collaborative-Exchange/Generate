using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCharterSchoolManagementOrganizationType
    {
        public RefCharterSchoolManagementOrganizationType()
        {
            K12CharterSchoolManagementOrganization = new HashSet<K12CharterSchoolManagementOrganization>();
        }

        public int RefCharterSchoolManagementOrganizationTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual Organization RefJurisdiction { get; set; }
        public virtual ICollection<K12CharterSchoolManagementOrganization> K12CharterSchoolManagementOrganization { get; set; }
    }
}
