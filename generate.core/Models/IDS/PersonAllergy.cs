using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonAllergy
    {
        public int PersonAllergyId { get; set; }
        public int PersonId { get; set; }
        public int RefAllergyTypeId { get; set; }
        public int? RefAllergySeverityId { get; set; }
        public string ReactionDescription { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefAllergySeverity RefAllergySeverity { get; set; }
        public virtual RefAllergyType RefAllergyType { get; set; }
    }
}
