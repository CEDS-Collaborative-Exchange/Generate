﻿using generate.core.Helpers.TestDataHelper.App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.Core.Helpers.TestDataHelper.App
{
    public class ToggleQuestionOptionHelperShould
    {
        [Fact]
        public void GetData()
        {
            var data = ToggleQuestionOptionHelper.GetData();

            Assert.NotNull(data);
            Assert.NotEmpty(data);
        }

    }
}
