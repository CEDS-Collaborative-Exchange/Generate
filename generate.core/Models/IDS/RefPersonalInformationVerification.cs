using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefPersonalInformationVerification
    {
        public RefPersonalInformationVerification()
        {
            PersonAddress = new HashSet<PersonAddress>();
            PersonDetail = new HashSet<PersonDetail>();
            PersonIdentifier = new HashSet<PersonIdentifier>();
        }

        public int RefPersonalInformationVerificationId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonAddress> PersonAddress { get; set; }
        public virtual ICollection<PersonDetail> PersonDetail { get; set; }
        public virtual ICollection<PersonIdentifier> PersonIdentifier { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
