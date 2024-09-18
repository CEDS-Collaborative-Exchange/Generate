using generate.core.Examples.RDS;
using generate.core.Models.RDS;
using generate.shared.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.Core.Examples.RDS
{
    public class DimAgeExampleShould
    {


        /// <summary>
        /// Verify properties
        /// </summary>
        /// <param name="expected"></param>
        /// <param name="actual"></param>
        private void Verify(DimAge expected, DimAge actual)
        {
            Assert.NotNull(actual);

            Assert.Equal(expected.DimAgeId, actual.DimAgeId);

            Assert.Equal(expected.AgeCode, actual.AgeCode);
            Assert.Equal(expected.AgeDescription, actual.AgeDescription);
            Assert.Equal(expected.AgeValue, actual.AgeValue);

        }


        [Fact]
        public void GetExample()
        {
            var actual = DimAgeExample.GetExample();
            var expected = new DimAge()
            {
                DimAgeId = 1,
                AgeCode = "AGE01",
                AgeDescription = "Age 1",
                AgeValue = 1
            };

            Verify(expected, actual);
        }


        [Fact]
        public void GetExampleWithId()
        {
            var actual = DimAgeExample.GetExample(3);
            var expected = new DimAge()
            {
                DimAgeId = 3,
                AgeCode = "AGE01",
                AgeDescription = "Age 1",
                AgeValue = 1
            };

            Verify(expected, actual);
        }

        [Fact]
        public void GetUpdatedExample()
        {
            var actual = DimAgeExample.GetExample();
            var updatedActual = DimAgeExample.GetUpdatedExample(actual);
            var expected = new DimAge()
            {
                DimAgeId = 1,
                AgeCode = "AGE01",
                AgeDescription = "Updated",
                AgeValue = 1
            };

            Verify(expected, updatedActual);
        }


    }
}
