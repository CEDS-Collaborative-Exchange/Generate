using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentLanguage
    {
        public int AssessmentLanguageId { get; set; }
        public int AssessmentId { get; set; }
        public int RefLanguageId { get; set; }

        public virtual Assessment Assessment { get; set; }
        public virtual RefLanguage RefLanguage { get; set; }
    }
}
