using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.UserInterface.Fixtures
{
    [CollectionDefinition("AcceptanceTestsCollection")]
    public class AcceptanceTestsCollection
    {
        // This class has no code, and is never created. Its purpose is simply
        // to be the place to apply [CollectionDefinition] and all the
        // ICollectionFixture<> interfaces.
    }
}
