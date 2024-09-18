using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonRelationship
    {
        public int PersonRelationshipId { get; set; }
        public int PersonId { get; set; }
        public int RelatedPersonId { get; set; }
        public int? RefPersonRelationshipId { get; set; }
        public bool? CustodialRelationshipIndicator { get; set; }
        public bool? EmergencyContactInd { get; set; }
        public int? ContactPriorityNumber { get; set; }
        public string ContactRestrictions { get; set; }
        public bool? LivesWithIndicator { get; set; }
        public bool? PrimaryContactIndicator { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefPersonRelationship RefPersonRelationship { get; set; }
        public virtual Person RelatedPerson { get; set; }
    }
}
