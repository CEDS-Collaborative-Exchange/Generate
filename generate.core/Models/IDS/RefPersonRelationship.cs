using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefPersonRelationship
    {
        public RefPersonRelationship()
        {
            PersonRelationship = new HashSet<PersonRelationship>();
        }

        public int RefPersonRelationshipId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonRelationship> PersonRelationship { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
