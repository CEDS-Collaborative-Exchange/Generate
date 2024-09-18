using generate.core.Models.App;
using generate.core.Models.IDS;
using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public class FactK12StaffCount
    {
        public int FactK12StaffCountId { get; set; }

        // Facts
        public int StaffCount { get; set; }
        public decimal StaffFTE { get; set; }

        // Dimensions (defining fact granularity)

        public int FactTypeId { get; set; }
        public int CountDateId { get; set; }
        public int K12StaffId { get; set; }

        // Dimensions (reporting)
        public int K12SchoolId { get; set; }
        public int K12StaffStatusId { get; set; }
        public int K12StaffCategoryId { get; set; }

        public int TitleIIIStatusId { get; set; }


        // Dimension Properties
        public DimFactType DimFactType { get; set; }
        public DimDate DimCountDate { get; set; }
        public DimK12Staff DimPersonnel { get; set; }
        public DimK12School DimSchool { get; set; }
        public DimK12StaffStatus DimPersonnelStatus { get; set; }
        public DimK12StaffCategory DimPersonnelCategory { get; set; }
        public DimTitleIIIStatus DimTitleIIIStatus { get; set; }

    }
}
