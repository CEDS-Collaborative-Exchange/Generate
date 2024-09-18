using generate.core.Models.RDS;
using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.App
{
    public class ReportMigrationConfigurationDto
    {
        public DimSchoolYearDataMigrationType[] dimSchoolYearDataMigrationTypes { get; set; }
        public GenerateReport[] generateReportLists { get; set; }
        public string userName { get; set; }
    }
}
