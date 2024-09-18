using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimFirearmDiscipline
    {
        public int DimFirearmDisciplineId { get; set; }

        public string DisciplineMethodForFirearmsIncidentsCode { get; set; }
        public string DisciplineMethodForFirearmsIncidentsDescription { get; set; }
        public string DisciplineMethodForFirearmsIncidentsEdFactsCode { get; set; }

        public string IdeaDisciplineMethodForFirearmsIncidentsCode { get; set; }
        public string IdeaDisciplineMethodForFirearmsIncidentsDescription { get; set; }
        public string IdeaDisciplineMethodForFirearmsIncidentsEdFactsCode { get; set; }

        public List<FactK12StudentDiscipline> FactStudentDisciplines { get; set; }

    }
}
