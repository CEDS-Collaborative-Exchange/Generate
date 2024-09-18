using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12staffEmployment
    {
        public int StaffEmploymentId { get; set; }
        public int? RefK12staffClassificationId { get; set; }
        public int? RefEmploymentStatusId { get; set; }
        public decimal? ContractDaysOfServicePerYear { get; set; }
        public decimal? StaffCompensationBaseSalary { get; set; }
        public decimal? StaffCompensationRetirementBenefits { get; set; }
        public decimal? StaffCompensationHealthBenefits { get; set; }
        public decimal? StaffCompensationOtherBenefits { get; set; }
        public decimal? StaffCompensationTotalBenefits { get; set; }
        public decimal? StaffCompensationTotalSalary { get; set; }
        public bool? MepPersonnelIndicator { get; set; }
        public bool? TitleItargetedAssistanceStaffFunded { get; set; }
        public bool? SalaryForTeachingAssignmentOnlyIndicator { get; set; }

        public virtual RefEmploymentStatus RefEmploymentStatus { get; set; }
        public virtual RefK12staffClassification RefK12staffClassification { get; set; }
        public virtual StaffEmployment StaffEmployment { get; set; }
    }
}
