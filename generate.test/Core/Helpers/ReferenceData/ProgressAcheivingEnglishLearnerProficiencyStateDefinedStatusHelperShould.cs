using generate.core.Helpers.ReferenceData;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.Core.Helpers.ReferenceData
{
    public class ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatusHelperShould
    {
        [Fact]
        public void GetData()
        {
            var data = ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatusHelper.GetData();

            Assert.NotNull(data);
            Assert.NotEmpty(data);
        }

    }
}
