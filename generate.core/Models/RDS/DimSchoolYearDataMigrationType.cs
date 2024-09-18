using System;
using System.Collections.Generic;
using System.Text;
using generate.core.Models.App;

namespace generate.core.Models.RDS
{
    public class DimSchoolYearDataMigrationType
    {
        public int DimSchoolYearId { get; set; }
        public int DataMigrationTypeId { get; set; }
        public bool IsSelected { get; set; }
        public DimSchoolYear DimSchoolYear { get; set; }
        public DimDataMigrationTypes DimDataMigrationType { get; set; }
       
    }
}
