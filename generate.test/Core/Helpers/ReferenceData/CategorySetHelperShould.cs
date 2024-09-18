using generate.core.Helpers.ReferenceData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.Core.Helpers.ReferenceData
{
    public class CategorySetHelperShould
    {
        [Fact]
        public void GetData()
        {
            var data = CategorySetHelper.GetData();

            Assert.NotNull(data);
            Assert.NotEmpty(data);
        }

        [Fact]
        public void GetData_WithReport()
        {
            var data = CategorySetHelper.GetData(19);

            Assert.NotNull(data);
            Assert.NotEmpty(data);
        }

    }
}
