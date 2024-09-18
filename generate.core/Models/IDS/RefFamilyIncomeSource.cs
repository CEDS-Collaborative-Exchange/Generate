using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefFamilyIncomeSource
    {
        public RefFamilyIncomeSource()
        {
            PersonFamily = new HashSet<PersonFamily>();
        }

        public int RefFamilyIncomeSourceId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonFamily> PersonFamily { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
