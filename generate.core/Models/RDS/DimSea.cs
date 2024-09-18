using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimSea
    {
        public int DimSeaId { get; set; }

       
        // SEA
        public int? SeaOrganizationId { get; set; }
        public string SeaName { get; set; }
        public string SeaIdentifierState { get; set; }
        

        // State
        public string StateAnsiCode { get; set; }
        public string StateAbbreviationDescription { get; set; }
        public string StateAbbreviationCode { get; set; }
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

        public List<FactOrganizationCount> FactOrganizationCounts { get; set; }

    }
}
