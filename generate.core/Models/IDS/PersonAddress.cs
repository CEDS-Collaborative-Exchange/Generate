using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonAddress
    {
        public int PersonAddressId { get; set; }
        public int PersonId { get; set; }
        public int RefPersonLocationTypeId { get; set; }
        public string StreetNumberAndName { get; set; }
        public string ApartmentRoomOrSuiteNumber { get; set; }
        public string City { get; set; }
        public int? RefStateId { get; set; }
        public string PostalCode { get; set; }
        public string AddressCountyName { get; set; }
        public int? RefCountyId { get; set; }
        public int? RefCountryId { get; set; }
        public string Latitude { get; set; }
        public string Longitude { get; set; }
        public int? RefPersonalInformationVerificationId { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefCountry RefCountry { get; set; }
        public virtual RefCounty RefCounty { get; set; }
        public virtual RefPersonLocationType RefPersonLocationType { get; set; }
        public virtual RefPersonalInformationVerification RefPersonalInformationVerification { get; set; }
        public virtual RefState RefState { get; set; }
    }
}
