using generate.core.Examples.App;
using generate.core.Models.App;
using generate.shared.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace generate.test.Core.Examples.App
{
    public class GenerateReportExampleShould
    {


        /// <summary>
        /// Verify properties
        /// </summary>
        /// <param name="expected"></param>
        /// <param name="actual"></param>
        private void Verify(GenerateReport expected, GenerateReport actual)
        {
            Assert.NotNull(actual);

            Assert.Equal(expected.GenerateReportId, actual.GenerateReportId);

            Assert.Equal(expected.ReportName, actual.ReportName);
            Assert.Equal(expected.ReportCode, actual.ReportCode);
            Assert.Equal(expected.ReportShortName, actual.ReportShortName);
            Assert.Equal(expected.ReportSequence, actual.ReportSequence);

        }


        [Fact]
        public void GetExample()
        {
            var actual = GenerateReportExample.GetExample();
            var expected = new GenerateReport()
            {
                GenerateReportId = 1,
                ReportName = "Test Report",
                ReportCode = "TEST",
                ReportShortName = "Test",
                ReportSequence = 1
            };

            Verify(expected, actual);
        }


        [Fact]
        public void GetExampleWithId()
        {
            var actual = GenerateReportExample.GetExample(3);
            var expected = new GenerateReport()
            {
                GenerateReportId = 3,
                ReportName = "Test Report",
                ReportCode = "TEST",
                ReportShortName = "Test",
                ReportSequence = 1
            };

            Verify(expected, actual);
        }

        [Fact]
        public void GetUpdatedExample()
        {
            var actual = GenerateReportExample.GetExample();
            var updatedActual = GenerateReportExample.GetUpdatedExample(actual);
            var expected = new GenerateReport()
            {
                GenerateReportId = 1,
                ReportName = "Updated",
                ReportCode = "TEST",
                ReportShortName = "Test",
                ReportSequence = 1
            };

            Verify(expected, updatedActual);
        }


    }
}
