using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAllergyType
    {
        public RefAllergyType()
        {
            PersonAllergy = new HashSet<PersonAllergy>();
        }

        public int RefAllergyTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonAllergy> PersonAllergy { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
