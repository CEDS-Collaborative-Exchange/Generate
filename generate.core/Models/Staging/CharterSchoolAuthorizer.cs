using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class CharterSchoolAuthorizer
    {
        public int Id { get; set; }
        public string CharterSchoolAuthorizingOrganizationOrganizationIdentifierSea  { get; set; }
        public string CharterSchoolAuthorizerType { get; set; }
        public string CharterSchoolAuthorizingOrganizationOrganizationName { get; set; }
        public string SchoolYear { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public string DataCollectionName { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
