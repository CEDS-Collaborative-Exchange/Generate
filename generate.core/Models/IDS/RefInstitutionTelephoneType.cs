using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefInstitutionTelephoneType
    {
        public RefInstitutionTelephoneType()
        {
            OrganizationTelephone = new HashSet<OrganizationTelephone>();
        }

        public int RefInstitutionTelephoneTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<OrganizationTelephone> OrganizationTelephone { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
