using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimIdeaStatus
    {
        public int DimIdeaStatusId { get; set; }

        public int? PrimaryDisabilityTypeId { get; set; }
        public string PrimaryDisabilityTypeCode { get; set; }
        public string PrimaryDisabilityTypeDescription { get; set; }
        public string PrimaryDisabilityTypeEdFactsCode { get; set; }

        public int? IdeaEducationalEnvironmentId { get; set; }
        public string IdeaEducationalEnvironmentCode { get; set; }
        public string IdeaEducationalEnvironmentDescription { get; set; }
        public string IdeaEducationalEnvironmentEdFactsCode { get; set; }


        public int? SpecialEducationExitReasonId { get; set; }
        public string SpecialEducationExitReasonCode { get; set; }
        public string SpecialEducationExitReasonDescription { get; set; }
        public string SpecialEducationExitReasonEdFactsCode { get; set; }

        public int? IdeaIndicatorId { get; set; }
        public string IdeaIndicatorCode { get; set; }
        public string IdeaIndicatorDescription { get; set; }
        public string IdeaIndicatorEdFactsCode { get; set; }


        public List<FactK12StudentCount> FactStudentCounts { get; set; }
        public List<FactK12StudentDiscipline> FactStudentDisciplines { get; set; }
        public List<FactK12StudentAssessment> FactStudentAssessments { get; set; }
		public List<FactOrganizationStatusCount> FactOrganizationStatusCount { get; set; }
	}
}
