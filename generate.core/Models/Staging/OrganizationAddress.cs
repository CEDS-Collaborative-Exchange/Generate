using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class OrganizationAddress
    {
        public int Id { get; set; }
        public string OrganizationIdentifier { get; set; }
        public string OrganizationType { get; set; }
        public string AddressTypeForOrganization { get; set; }
        public string AddressStreetNumberAndName { get; set; }
        public string AddressApartmentRoomOrSuiteNumber { get; set; }
        public string AddressCity { get; set; }
        public string AddressCountyAnsiCodeCode { get; set; }
        public string StateAbbreviation { get; set; }
        public string AddressPostalCode { get; set; }
        public string Latitude { get; set; }
        public string Longitude { get; set; }
        public string SchoolYear { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public string DataCollectionName { get; set; }
        //public int? RefStateId { get; set; }
        //public string OrganizationId { get; set; }
        //public string LocationId { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
