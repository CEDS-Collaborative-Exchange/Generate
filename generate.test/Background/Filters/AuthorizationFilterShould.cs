using generate.background.Filters;
using Hangfire.Dashboard;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.Background.Filters
{
    public class AuthorizationFilterShould
    {
        [Fact]
        public void Authorize()
        {
            var filter = new AuthorizationFilter();

            var result = filter.Authorize(null);

            Assert.True(result);
        }
    }
}
