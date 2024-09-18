using generate.core.Models.App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Examples.App
{
    public static class GenerateReportExample
    {
        public static GenerateReport GetExample(int? id = null)
        {
            if (!id.HasValue)
            {
                id = 1;
            }

            GenerateReport example = new GenerateReport()
            {
                GenerateReportId = (int)id,
                ReportName = "Test Report",
                ReportCode = "TEST",
                ReportShortName = "Test",
                ReportSequence = 1
            };

            return example;
        }

        public static GenerateReport GetUpdatedExample(GenerateReport existing)
        {
            existing.ReportName = "Updated";

            return existing;
        }
    }
}
