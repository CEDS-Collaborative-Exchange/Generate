using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefOrganizationIdentificationSystem
    {
        public RefOrganizationIdentificationSystem()
        {
            OrganizationIdentifier = new HashSet<OrganizationIdentifier>();
        }

        public int RefOrganizationIdentificationSystemId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public int? RefOrganizationIdentifierTypeId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<OrganizationIdentifier> OrganizationIdentifier { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
        public virtual RefOrganizationIdentifierType RefOrganizationIdentifierType { get; set; }
    }
}
