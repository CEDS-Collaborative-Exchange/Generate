using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class FinancialAccount
    {
        public FinancialAccount()
        {
            OrganizationFinancial = new HashSet<OrganizationFinancial>();
        }

        public int FinancialAccountId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string AccountNumber { get; set; }
        public int? RefFinancialAccountCategoryId { get; set; }
        public int? RefFinancialAccountFundClassificationId { get; set; }
        public int? RefFinancialAccountProgramCodeId { get; set; }
        public int? RefFinancialAccountBalanceSheetCodeId { get; set; }
        public int? RefFinancialExpenditureFunctionCodeId { get; set; }
        public int? RefFinancialExpenditureObjectCodeId { get; set; }
        public string FinancialAccountNumber { get; set; }
        public decimal? FinancialExpenditureProjectReportingCode { get; set; }
        public int? RefFinancialExpenditureLevelOfInstructionCodeId { get; set; }
        public int? RefFinancialAccountRevenueCodeId { get; set; }
        public string FederalProgramCode { get; set; }

        public virtual ICollection<OrganizationFinancial> OrganizationFinancial { get; set; }
        public virtual RefFinancialAccountBalanceSheetCode RefFinancialAccountBalanceSheetCode { get; set; }
        public virtual RefFinancialAccountCategory RefFinancialAccountCategory { get; set; }
        public virtual RefFinancialAccountFundClassification RefFinancialAccountFundClassification { get; set; }
        public virtual RefFinancialAccountProgramCode RefFinancialAccountProgramCode { get; set; }
        public virtual RefFinancialAccountRevenueCode RefFinancialAccountRevenueCode { get; set; }
        public virtual RefFinancialExpenditureFunctionCode RefFinancialExpenditureFunctionCode { get; set; }
        public virtual RefFinancialExpenditureLevelOfInstructionCode RefFinancialExpenditureLevelOfInstructionCode { get; set; }
        public virtual RefFinancialExpenditureObjectCode RefFinancialExpenditureObjectCode { get; set; }
    }
}
