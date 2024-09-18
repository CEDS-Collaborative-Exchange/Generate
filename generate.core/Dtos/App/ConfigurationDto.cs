using generate.core.Models.App;
using generate.core.Models.RDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Dtos.App
{
    public class ConfigurationDto
    {
        public DimSchoolYearDataMigrationType[] dimSchoolYearDataMigrationTypes { get; set; }
        public DataMigrationTask[] dataMigrationTasks { get; set; }
    }
}
