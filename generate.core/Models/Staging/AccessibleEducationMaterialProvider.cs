using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Models.Staging
{
    public partial class AccessibleEducationMaterialProvider
    {
        public int Id { get; set; }
        public string AccessibleEducationMaterialProviderOrganizationIdentifierSea { get; set; }
        public string AccessibleEducationMaterialProviderName { get; set; }
        public string StateAbbreviationCode { get; set; }
        public string StateAbbreviationDescription { get; set; }
        public string StateANSICode { get; set; }
        public string MailingAddressStreetNumberAndName { get; set; }
        public string MailingAddressApartmentRoomOrSuiteNumber { get; set; }
        public string MailingAddressCity { get; set; }
        public string MailingAddressPostalCode { get; set; }
        public string MailingAddressStateAbbreviation { get; set; }
        public string MailingAddressCountyAnsiCodeCode { get; set; }
        public string PhysicalAddressStreetNumberAndName { get; set; }
        public string PhysicalAddressApartmentRoomOrSuiteNumber { get; set; }
        public string PhysicalAddressCity { get; set; }
        public string PhysicalAddressPostalCode { get; set; }
        public string PhysicalAddressStateAbbreviation { get; set; }
        public string PhysicalAddressCountyAnsiCodeCode { get; set; }
        public string TelephoneNumber { get; set; }
        public string WebSiteAddress { get; set; }
        public bool OutOfStateIndicator { get; set; }
        public DateTime RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
    }
}
