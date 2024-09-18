using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefPersonIdentificationSystem
    {
        public RefPersonIdentificationSystem()
        {
            PersonIdentifier = new HashSet<PersonIdentifier>();
        }

        public int RefPersonIdentificationSystemId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public int? RefPersonIdentifierTypeId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonIdentifier> PersonIdentifier { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
        public virtual RefPersonIdentifierType RefPersonIdentifierType { get; set; }
    }
}
