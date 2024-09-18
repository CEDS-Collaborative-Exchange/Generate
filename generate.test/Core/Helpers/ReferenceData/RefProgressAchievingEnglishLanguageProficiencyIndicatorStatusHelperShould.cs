using generate.core.Helpers.ReferenceData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.Core.Helpers.ReferenceData
{
    public class RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusHelperShould
    {
        [Fact]
        public void GetData()
        {
            var data = RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusHelper.GetData();

            Assert.NotNull(data);
            Assert.NotEmpty(data);
        }

    }
}
