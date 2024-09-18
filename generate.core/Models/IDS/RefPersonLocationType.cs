using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefPersonLocationType
    {
        public RefPersonLocationType()
        {
            PersonAddress = new HashSet<PersonAddress>();
        }

        public int RefPersonLocationTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public int? RoleId { get; set; }
        public int? RefAddressTypeId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonAddress> PersonAddress { get; set; }
        public virtual RefAddressType RefAddressType { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
