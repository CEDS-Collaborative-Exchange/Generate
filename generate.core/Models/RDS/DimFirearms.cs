using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimFirearms
    {
        public int DimFirearmsId { get; set; }

        public string FirearmTypeCode { get; set; }
        public string FirearmTypeDescription { get; set; }
        public string FirearmTypeEdFactsCode { get; set; }

        public List<FactK12StudentDiscipline> FactStudentDisciplines { get; set; }

    }
}
