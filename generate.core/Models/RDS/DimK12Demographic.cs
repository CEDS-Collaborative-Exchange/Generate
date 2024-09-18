using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimK12Demographic
    {
        public int DimK12DemographicId { get; set; }


        public int? EnglishLearnerStatusId { get; set; }
        public string EnglishLearnerStatusCode { get; set; }
        public string EnglishLearnerStatusDescription { get; set; }
        public string EnglishLearnerStatusEdFactsCode { get; set; }


        public int? MigrantStatusId { get; set; }
        public string MigrantStatusCode { get; set; }
        public string MigrantStatusDescription { get; set; }
        public string MigrantStatusEdFactsCode { get; set; }

        public int? EconomicDisadvantageStatusId { get; set; }
        public string EconomicDisadvantageStatusCode { get; set; }
        public string EconomicDisadvantageStatusDescription { get; set; }
        public string EconomicDisadvantageStatusEdFactsCode { get; set; }

        public int? HomelessnessStatusId { get; set; }
        public string HomelessnessStatusCode { get; set; }
        public string HomelessnessStatusDescription { get; set; }
        public string HomelessnessStatusEdFactsCode { get; set; }

        public int? MilitaryConnectedStudentIndicatorId { get; set; }
        public string MilitaryConnectedStudentIndicatorCode { get; set; }
        public string MilitaryConnectedStudentIndicatorDescription { get; set; }
        public string MilitaryConnectedStudentIndicatorEdFactsCode { get; set; }

        public int? HomelessUnaccompaniedYouthStatusId { get; set; }
        public string HomelessUnaccompaniedYouthStatusCode { get; set; }
        public string HomelessUnaccompaniedYouthStatusDescription { get; set; }
        public string HomelessUnaccompaniedYouthStatusEdFactsCode { get; set; }

        public int? HomelessPrimaryNighttimeResidenceId { get; set; }
        public string HomelessPrimaryNighttimeResidenceCode { get; set; }
        public string HomelessPrimaryNighttimeResidenceDescription { get; set; }
        public string HomelessPrimaryNighttimeResidenceEdFactsCode { get; set; }


        public List<FactK12StudentCount> FactK12StudentCounts { get; set; }
        public List<FactK12StudentDiscipline> FactK12StudentDisciplines { get; set; }
        public List<FactK12StudentAssessment> FactK12StudentAssessments { get; set; }
		public List<FactOrganizationStatusCount> FactOrganizationStatusCount { get; set; }
		public List<FactOrganizationStatusCount> FactOrganizationStatusCount1 { get; set; }
        public List<FactK12StudentAttendance> FactK12StudentAttendance { get; set; }
    }
}
