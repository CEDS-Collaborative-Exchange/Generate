using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefLanguageUseType
    {
        public RefLanguageUseType()
        {
            PersonLanguage = new HashSet<PersonLanguage>();
        }

        public int RefLanguageUseTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonLanguage> PersonLanguage { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
