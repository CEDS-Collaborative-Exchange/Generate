using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class FinancialAidApplication
    {
        public int FinancialAidApplicationId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public int RefFinancialAidApplicationTypeId { get; set; }
        public string FinancialAidYearDesignator { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefFinancialAidApplicationType RefFinancialAidApplicationType { get; set; }
    }
}
