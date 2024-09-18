using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationFinancial
    {
        public int OrganizationFinancialId { get; set; }
        public int FinancialAccountId { get; set; }
        public int OrganizationCalendarSessionId { get; set; }
        public decimal? ActualValue { get; set; }
        public decimal? BudgetedValue { get; set; }
        public DateTime? Date { get; set; }
        public decimal? EncumberedValue { get; set; }
        public decimal? Value { get; set; }
        public DateTime? FiscalPeriodBeginDate { get; set; }
        public DateTime? FiscalPeriodEndDate { get; set; }
        public string FiscalYear { get; set; }
        public int? FinancialAccountProgramId { get; set; }

        public virtual FinancialAccount FinancialAccount { get; set; }
        public virtual FinancialAccountProgram FinancialAccountProgram { get; set; }
        public virtual OrganizationCalendarSession OrganizationCalendarSession { get; set; }
    }
}
