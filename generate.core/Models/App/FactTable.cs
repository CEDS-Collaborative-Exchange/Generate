using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class FactTable
    {
        public int FactTableId { get; set; }

        public string FactTableName { get; set; }
        public string FactTableIdName { get; set; }
        public string FactFieldName { get; set; }
        public string FactReportTableName { get; set; }
        public string FactReportTableIdName { get; set; }
        public string FactReportDtoName { get; set; }
        public string FactReportDtoIdName { get; set; }


        public List<FactTable_DimensionTable> FactTable_DimensionTables { get; set; }
        public List<GenerateReport> GenerateReports { get; set; }

    }
}
