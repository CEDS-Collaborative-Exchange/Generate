using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class OrganizationFederalFunding
    {
        public int Id { get; set; }
        public string OrganizationIdentifier { get; set; }
        public string OrganizationType { get; set; }
        public string FederalProgramCode { get; set; }
        public decimal? FederalProgramsFundingAllocation { get; set; }
        public decimal? ParentalInvolvementReservationFunds { get; set; }
        public string REAPAlternativeFundingStatusCode { get; set; }
        public string FederalProgramFundingAllocationType { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        //public int? DataCollectionId { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
