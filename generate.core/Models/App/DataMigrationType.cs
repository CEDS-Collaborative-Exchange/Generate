using generate.core.Models.RDS;
using System;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class DataMigrationType
    {
        public int DataMigrationTypeId { get; set; }
        public string DataMigrationTypeCode { get; set; }
        public string DataMigrationTypeName { get; set; }
        //public List<DimSchoolYearDataMigrationType> DimSchoolYearDataMigration { get; set; }
    }
}
