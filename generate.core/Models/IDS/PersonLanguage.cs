using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonLanguage
    {
        public int PersonLanguageId { get; set; }
        public int PersonId { get; set; }
        public int RefLanguageId { get; set; }
        public int RefLanguageUseTypeId { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefLanguage RefLanguage { get; set; }
        public virtual RefLanguageUseType RefLanguageUseType { get; set; }
    }
}
