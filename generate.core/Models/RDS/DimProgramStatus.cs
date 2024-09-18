using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Models.RDS
{
    public partial class DimProgramStatus
    {
        public int DimProgramStatusId { get; set; }
        public int? Section504StatusId { get; set; }
        public string Section504StatusCode { get; set; }
        public string Section504StatusDescription { get; set; }
        public string Section504StatusEdFactsCode { get; set; }

        
        public int? EligibilityStatusForSchoolFoodServiceProgramId { get; set; }
        public string EligibilityStatusForSchoolFoodServiceProgramCode { get; set; }
        public string EligibilityStatusForSchoolFoodServiceProgramDescription { get; set; }
        public string EligibilityStatusForSchoolFoodServiceProgramEdFactsCode { get; set; }

        public int? TitleIIIImmigrantParticipationStatusId { get; set; }
        public string TitleIIIImmigrantParticipationStatusCode { get; set; }
        public string TitleIIIImmigrantParticipationStatusDescription { get; set; }
        public string TitleIIIImmigrantParticipationStatusEdFactsCode { get; set; }

        public int? FosterCareProgramId { get; set; }
        public string FosterCareProgramCode { get; set; }
        public string FosterCareProgramDescription { get; set; }
        public string FosterCareProgramEdFactsCode { get; set; }

        public int? TitleiiiProgramParticipationId { get; set; }
        public string TitleiiiProgramParticipationCode { get; set; }
        public string TitleiiiProgramParticipationDescription { get; set; }
        public string TitleiiiProgramParticipationEdFactsCode { get; set; }

        public int? HomelessServicedIndicatorId { get; set; }
        public string HomelessServicedIndicatorCode { get; set; }
        public string HomelessServicedIndicatorDescription { get; set; }
        public string HomelessServicedIndicatorEdFactsCode { get; set; }

        public List<FactK12StudentCount> FactStudentCounts { get; set; }
        public List<FactK12StudentAssessment> FactStudentAssessments { get; set; }
        public List<FactK12StudentDiscipline> FactStudentDisciplines { get; set; }

    }
}
