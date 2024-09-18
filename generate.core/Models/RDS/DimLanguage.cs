using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimLanguage
    {
        public int DimLanguageId { get; set; }

        public string Iso6392LanguageCode { get; set; }
        public string Iso6392LanguageDescription { get; set; }
        public string Iso6392LanguageEdFactsCode { get; set; }

        public List<FactK12StudentCount> FactK12StudentCounts { get; set; }

    }
}
