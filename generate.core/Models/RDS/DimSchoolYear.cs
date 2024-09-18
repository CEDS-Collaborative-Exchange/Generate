using generate.core.Models.App;
using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimSchoolYear
    {
        public int DimSchoolYearId { get; set; }
        public Int16 SchoolYear { get; set; }
        public DateTime SessionBeginDate { get; set; }
        public DateTime SessionEndDate { get; set; }
        public List<DimSchoolYearDataMigrationType> DimSchoolYearDataMigration { get; set; }
    }
}
