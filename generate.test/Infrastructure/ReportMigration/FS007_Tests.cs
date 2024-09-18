using generate.test.Infrastructure.Fixtures;
using generate.infrastructure.Repositories.RDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.Infrastructure.ReportMigration
{
    public class FS007_Tests : IClassFixture<ReportMigrationFixture>
    {
        //private readonly string reportTable = "FactStudentDisciplineReports";
        //private readonly string reportYear = "2017-18";
        //private readonly string reportCode = "c007";

        private readonly ReportMigrationFixture fixture;

        public FS007_Tests(ReportMigrationFixture fixture)
        {
            this.fixture = fixture;
        }


    }
}
