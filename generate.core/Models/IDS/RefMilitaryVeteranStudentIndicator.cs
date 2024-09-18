using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefMilitaryVeteranStudentIndicator
    {
        public RefMilitaryVeteranStudentIndicator()
        {
            PersonMilitary = new HashSet<PersonMilitary>();
        }

        public int RefMilitaryVeteranStudentIndicatorId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonMilitary> PersonMilitary { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
