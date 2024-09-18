using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefOrganizationIdentifierType
    {
        public RefOrganizationIdentifierType()
        {
            OrganizationIdentifier = new HashSet<OrganizationIdentifier>();
            RefOrganizationIdentificationSystem = new HashSet<RefOrganizationIdentificationSystem>();
        }

        public int RefOrganizationIdentifierTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<OrganizationIdentifier> OrganizationIdentifier { get; set; }
        public virtual ICollection<RefOrganizationIdentificationSystem> RefOrganizationIdentificationSystem { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
