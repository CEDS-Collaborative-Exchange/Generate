using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimK12StaffCategory
    {
        public int DimK12StaffCategoryId { get; set; }

        public string SpecialEducationSupportServicesCategoryCode { get; set; }
        public string SpecialEducationSupportServicesCategoryDescription { get; set; }
        public string SpecialEducationSupportServicesCategoryEdFactsCode { get; set; }

        public string K12StaffClassificationCode { get; set; }
        public string K12StaffClassificationDescription { get; set; }
        public string K12StaffClassificationEdFactsCode { get; set; }

        public string TitleIProgramStaffCategoryCode { get; set; }
        public string TitleIProgramStaffCategoryDescription { get; set; }
        public string TitleIProgramStaffCategoryEdFactsCode { get; set; }

        public List<FactK12StaffCount> FactK12StaffCounts { get; set; }

    }
}
