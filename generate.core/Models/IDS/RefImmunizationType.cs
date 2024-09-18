using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefImmunizationType
    {
        public RefImmunizationType()
        {
            PersonImmunization = new HashSet<PersonImmunization>();
            RequiredImmunization = new HashSet<RequiredImmunization>();
        }

        public int RefImmunizationTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonImmunization> PersonImmunization { get; set; }
        public virtual ICollection<RequiredImmunization> RequiredImmunization { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
