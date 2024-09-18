using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ProfessionalDevelopmentActivity
    {
        public ProfessionalDevelopmentActivity()
        {
            PdactivityEducationLevel = new HashSet<PdactivityEducationLevel>();
            ProfessionalDevelopmentSession = new HashSet<ProfessionalDevelopmentSession>();
            StaffProfessionalDevelopmentActivity = new HashSet<StaffProfessionalDevelopmentActivity>();
        }

        public int ProfessionalDevelopmentActivityId { get; set; }
        public int? CourseId { get; set; }
        public int ProfessionalDevelopmentRequirementId { get; set; }
        public string Title { get; set; }
        public string ActivityIdentifier { get; set; }
        public string Description { get; set; }
        public string Objective { get; set; }
        public string ActivityCode { get; set; }
        public string ApprovalCode { get; set; }
        public decimal? Cost { get; set; }
        public decimal? Credits { get; set; }
        public int? RefCourseCreditUnitId { get; set; }
        public bool? ScholarshipStatus { get; set; }
        public int? RefProfessionalDevelopmentFinancialSupportId { get; set; }
        public bool? PublishIndicator { get; set; }
        public int? RefPdaudienceTypeId { get; set; }
        public int? RefPdactivityApprovedPurposeId { get; set; }
        public int? RefPdactivityCreditTypeId { get; set; }
        public int? RefPdactivityLevelId { get; set; }
        public int? RefPdactivityTypeId { get; set; }
        public bool? ProfessionalDevelopmentActivityStateApprovedStatus { get; set; }

        public virtual ICollection<PdactivityEducationLevel> PdactivityEducationLevel { get; set; }
        public virtual ICollection<ProfessionalDevelopmentSession> ProfessionalDevelopmentSession { get; set; }
        public virtual ICollection<StaffProfessionalDevelopmentActivity> StaffProfessionalDevelopmentActivity { get; set; }
        public virtual Course Course { get; set; }
        public virtual ProfessionalDevelopmentRequirement ProfessionalDevelopmentRequirement { get; set; }
        public virtual RefCourseCreditUnit RefCourseCreditUnit { get; set; }
        public virtual RefPdactivityApprovedPurpose RefPdactivityApprovedPurpose { get; set; }
        public virtual RefPdactivityCreditType RefPdactivityCreditType { get; set; }
        public virtual RefPdactivityLevel RefPdactivityLevel { get; set; }
        public virtual RefPdactivityType RefPdactivityType { get; set; }
        public virtual RefPdaudienceType RefPdaudienceType { get; set; }
        public virtual RefProfessionalDevelopmentFinancialSupport RefProfessionalDevelopmentFinancialSupport { get; set; }
    }
}
