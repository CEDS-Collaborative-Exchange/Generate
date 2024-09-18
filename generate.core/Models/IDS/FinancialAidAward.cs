using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class FinancialAidAward
    {
        public int FinancialAidAwardId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public int? RefFinancialAidAwardTypeId { get; set; }
        public int? RefFinancialAidStatusId { get; set; }
        public decimal? FinancialAidAwardAmount { get; set; }
        public string FinancialAidYearDesignator { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefFinancialAidAwardType RefFinancialAidAwardType { get; set; }
        public virtual RefFinancialAidAwardStatus RefFinancialAidStatus { get; set; }
    }
}
