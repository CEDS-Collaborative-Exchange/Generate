using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ProfessionalDevelopmentSession
    {
        public ProfessionalDevelopmentSession()
        {
            ProfessionalDevelopmentSessionInstructor = new HashSet<ProfessionalDevelopmentSessionInstructor>();
            StaffProfessionalDevelopmentActivity = new HashSet<StaffProfessionalDevelopmentActivity>();
        }

        public int ProfessionalDevelopmentSessionId { get; set; }
        public int ProfessionalDevelopmentActivityId { get; set; }
        public string SessionIdentifier { get; set; }
        public int? RefPddeliveryMethodId { get; set; }
        public int? Capacity { get; set; }
        public DateTime? StartDate { get; set; }
        public string StartTime { get; set; }
        public DateTime? EndDate { get; set; }
        public string EndTime { get; set; }
        public string LocationName { get; set; }
        public string EvaluationMethod { get; set; }
        public string EvaluationScore { get; set; }
        public DateTime? ExpirationDate { get; set; }
        public int? RefPdsessionStatusId { get; set; }
        public int? RefPdinstructionalDeliveryModeId { get; set; }
        public string SponsoringAgencyName { get; set; }
        public int? RefLanguageId { get; set; }
        public string FundingSource { get; set; }
        public string TrainingAndTechnicalAssistanceLevel { get; set; }
        public int? RefEltrainerCoreKnowledgeAreaId { get; set; }

        public virtual ICollection<ProfessionalDevelopmentSessionInstructor> ProfessionalDevelopmentSessionInstructor { get; set; }
        public virtual ICollection<StaffProfessionalDevelopmentActivity> StaffProfessionalDevelopmentActivity { get; set; }
        public virtual ProfessionalDevelopmentActivity ProfessionalDevelopmentActivity { get; set; }
        public virtual RefEltrainerCoreKnowledgeArea RefEltrainerCoreKnowledgeArea { get; set; }
        public virtual RefLanguage RefLanguage { get; set; }
        public virtual RefPdinstructionalDeliveryMode RefPdinstructionalDeliveryMode { get; set; }
        public virtual RefPdsessionStatus RefPdsessionStatus { get; set; }
    }
}
