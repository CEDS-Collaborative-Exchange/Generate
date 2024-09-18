using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class FinancialAccountProgram
    {
        public FinancialAccountProgram()
        {
            OrganizationFinancial = new HashSet<OrganizationFinancial>();
        }

        public int FinancialAccountProgramId { get; set; }
        public string Name { get; set; }
        public string ProgramNumber { get; set; }

        public virtual ICollection<OrganizationFinancial> OrganizationFinancial { get; set; }
    }
}
