using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.Infrastructure.Fixtures
{
    [CollectionDefinition("ReportMigrationCollection")]
    public class ApiTestServerCollection : ICollectionFixture<ReportMigrationFixture>
    {
        // This class has no code, and is never created. Its purpose is simply
        // to be the place to apply [CollectionDefinition] and all the
        // ICollectionFixture<> interfaces.
    }
}
