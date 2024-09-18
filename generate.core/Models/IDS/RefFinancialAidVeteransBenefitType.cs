using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefFinancialAidVeteransBenefitType
    {
        public RefFinancialAidVeteransBenefitType()
        {
            PsStudentFinancialAid = new HashSet<PsStudentFinancialAid>();
        }

        public int RefFinancialAidVeteransBenefitTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PsStudentFinancialAid> PsStudentFinancialAid { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
