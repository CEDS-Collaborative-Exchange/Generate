using generate.core.Examples.ODS;
using generate.core.Models.IDS;
using generate.shared.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.Core.Examples.ODS
{
    public class OrganizationDetailExampleShould
    {


        /// <summary>
        /// Verify properties
        /// </summary>
        /// <param name="expected"></param>
        /// <param name="actual"></param>
        private void Verify(OrganizationDetail expected, OrganizationDetail actual)
        {
            Assert.NotNull(actual);

            Assert.Equal(expected.OrganizationDetailId, actual.OrganizationDetailId);

            Assert.Equal(expected.Name, actual.Name);
            Assert.Equal(expected.ShortName, actual.ShortName);

        }


        [Fact]
        public void GetExample()
        {
            var actual = OrganizationDetailExample.GetExample();
            var expected = new OrganizationDetail()
            {
                OrganizationDetailId = 1,
                Name = "Test",
                ShortName = "TST"
            };

            Verify(expected, actual);
        }


        [Fact]
        public void GetExampleWithId()
        {
            var actual = OrganizationDetailExample.GetExample(3);
            var expected = new OrganizationDetail()
            {
                OrganizationDetailId = 3,
                Name = "Test",
                ShortName = "TST"
            };

            Verify(expected, actual);
        }

        [Fact]
        public void GetUpdatedExample()
        {
            var actual = OrganizationDetailExample.GetExample();
            var updatedActual = OrganizationDetailExample.GetUpdatedExample(actual);
            var expected = new OrganizationDetail()
            {
                OrganizationDetailId = 1,
                Name = "Updated",
                ShortName = "TST"
            };

            Verify(expected, updatedActual);
        }


    }
}
