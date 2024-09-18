using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class StaffProfessionalDevelopmentActivity
    {
        public StaffProfessionalDevelopmentActivity()
        {
            CoreKnowledgeArea = new HashSet<CoreKnowledgeArea>();
        }

        public int StaffProfessionalDevelopmentActivityId { get; set; }
        public int ProfessionalDevelopmentRequirementId { get; set; }
        public string ActivityTitle { get; set; }
        public string ActivityIdentifier { get; set; }
        public DateTime? ActivityStartDate { get; set; }
        public DateTime? ActivityCompletionDate { get; set; }
        public bool? ScholarshipStatus { get; set; }
        public int? RefProfessionalDevelopmentFinancialSupportId { get; set; }
        public decimal? NumberOfCreditsEarned { get; set; }
        public int? RefCourseCreditUnitId { get; set; }
        public int ProfessionalDevelopmentActivityId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public int ProfessionalDevelopmentSessionId { get; set; }

        public virtual ICollection<CoreKnowledgeArea> CoreKnowledgeArea { get; set; }
        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual ProfessionalDevelopmentActivity ProfessionalDevelopmentActivity { get; set; }
        public virtual ProfessionalDevelopmentRequirement ProfessionalDevelopmentRequirement { get; set; }
        public virtual ProfessionalDevelopmentSession ProfessionalDevelopmentSession { get; set; }
        public virtual RefCourseCreditUnit RefCourseCreditUnit { get; set; }
        public virtual RefProfessionalDevelopmentFinancialSupport RefProfessionalDevelopmentFinancialSupport { get; set; }
    }
}
