using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefEmailType
    {
        public RefEmailType()
        {
            OrganizationEmail = new HashSet<OrganizationEmail>();
            PersonEmailAddress = new HashSet<PersonEmailAddress>();
        }

        public int RefEmailTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<OrganizationEmail> OrganizationEmail { get; set; }
        public virtual ICollection<PersonEmailAddress> PersonEmailAddress { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
