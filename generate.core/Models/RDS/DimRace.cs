using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimRace
    {
        public int DimRaceId { get; set; }

        public int? DimFactTypeId { get; set; }

        public int? RaceId { get; set; }
        public string RaceCode { get; set; }
        public string RaceDescription { get; set; }


        public DimFactType DimFactType { get; set; }
     	public List<FactOrganizationStatusCount> FactOrganizationStatusCount { get; set; }
        public List<FactK12StudentCount> FactStudentCounts { get; set; }
        public List<FactK12StudentDiscipline> FactStudentDisciplines { get; set; }
        public List<FactK12StudentAssessment> FactStudentAssessments { get; set; }
    }
}
