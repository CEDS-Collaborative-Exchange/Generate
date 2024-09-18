using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Models.RDS
{
    public partial class DimCharterSchoolAuthorizer
    {
        public int DimCharterSchoolAuthorizerId { get; set; }

        public string Name { get; set; }

        public string StateIdentifier { get; set; }
        public string State { get; set; }
        public string StateCode { get; set; }
        public string StateANSICode { get; set; }

        //public string OrganizationType { get; set; }
        public string CharterSchoolAuthorizerTypeCode { get; set; }
        public string CharterSchoolAuthorizerTypeDescription { get; set; }
        public string CharterSchoolAuthorizerTypeEdFactsCode { get; set; }
        public string Website { get; set; }
        public string Telephone { get; set; }

        public string MailingAddressStreet { get; set; }
        public string MailingAddressCity { get; set; }
        public string MailingAddressState { get; set; }
        public string MailingAddressPostalCode { get; set; }

        public string PhysicalAddressStreet { get; set; }
        public string PhysicalAddressCity { get; set; }
        public string PhysicalAddressState { get; set; }
        public string PhysicalAddressPostalCode { get; set; }
        public DateTime RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public string SchoolStateIdentifier { get; set; }
        public bool OutOfStateIndicator { get; set; }

        public List<FactOrganizationCount> FactOrganizationCounts_CharterAuthorizer { get; set; }
        public List<FactOrganizationCount> FactOrganizationCounts_SecondaryCharterAuthorizer { get; set; }

    }
}
