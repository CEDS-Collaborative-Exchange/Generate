using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCredentialType
    {
        public RefCredentialType()
        {
            PersonCredential = new HashSet<PersonCredential>();
        }

        public int RefCredentialTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonCredential> PersonCredential { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
