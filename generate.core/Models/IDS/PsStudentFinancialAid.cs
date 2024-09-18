using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsStudentFinancialAid
    {
        public int OrganizationPersonRoleId { get; set; }
        public bool? FinancialAidApplicant { get; set; }
        public decimal? FinancialNeed { get; set; }
        public int? RefNeedDeterminationMethodId { get; set; }
        public bool? TitleIvparticipantAndRecipient { get; set; }
        public decimal? FinancialAidIncomeLevel { get; set; }
        public int? RefFinancialAidVeteransBenefitStatusId { get; set; }
        public int? RefFinancialAidVeteransBenefitTypeId { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefFinancialAidVeteransBenefitStatus RefFinancialAidVeteransBenefitStatus { get; set; }
        public virtual RefFinancialAidVeteransBenefitType RefFinancialAidVeteransBenefitType { get; set; }
        public virtual RefNeedDeterminationMethod RefNeedDeterminationMethod { get; set; }
    }
}
