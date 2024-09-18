using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimAge
    {
        public int DimAgeId { get; set; }
        
        public string AgeCode { get; set; }
        public string AgeDescription { get; set; }
        public string AgeEdFactsCode { get; set; }
        public int AgeValue { get; set; }

        public List<FactK12StudentCount> FactStudentCounts { get; set; }
        public List<FactK12StudentDiscipline> FactStudentDisciplines { get; set; }

    }
}
