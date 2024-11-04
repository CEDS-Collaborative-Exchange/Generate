using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class OrganizationPhone
    {
        public int Id { get; set; }
        public string OrganizationIdentifier { get; set; }
        public string OrganizationType { get; set; }
        public string InstitutionTelephoneNumberType { get; set; }
        public string TelephoneNumber { get; set; }
        public bool? PrimaryTelephoneNumberIndicator { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
