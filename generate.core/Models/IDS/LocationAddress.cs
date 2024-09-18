using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class LocationAddress
    {
        public int LocationId { get; set; }
        public string StreetNumberAndName { get; set; }
        public string ApartmentRoomOrSuiteNumber { get; set; }
        public string BuildingSiteNumber { get; set; }
        public string City { get; set; }
        public int? RefStateId { get; set; }
        public string PostalCode { get; set; }
        public string CountyName { get; set; }
        public int? RefCountyId { get; set; }
        public int? RefCountryId { get; set; }
        public string Latitude { get; set; }
        public string Longitude { get; set; }
        public int? RefErsruralUrbanContinuumCodeId { get; set; }

        public virtual Location Location { get; set; }
        public virtual RefCountry RefCountry { get; set; }
        public virtual RefCounty RefCounty { get; set; }
        public virtual RefErsruralUrbanContinuumCode RefErsruralUrbanContinuumCode { get; set; }
        public virtual RefState RefState { get; set; }
    }
}
