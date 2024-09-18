using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public class DimDataMigrationTypes
    {
        public int DimDataMigrationTypeId { get; set; }
        public string DataMigrationTypeCode { get; set; }
        public string DataMigrationTypeName { get; set; }
        public List<DimSchoolYearDataMigrationType> DimSchoolYearDataMigration { get; set; }
    }
}
