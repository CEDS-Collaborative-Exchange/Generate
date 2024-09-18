using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefPersonIdentifierType
    {
        public RefPersonIdentifierType()
        {
            RefPersonIdentificationSystem = new HashSet<RefPersonIdentificationSystem>();
        }

        public int RefPersonIdentifierTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<RefPersonIdentificationSystem> RefPersonIdentificationSystem { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
