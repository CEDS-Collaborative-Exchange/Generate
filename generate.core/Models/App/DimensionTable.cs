using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.App
{
    public class DimensionTable
    {
        public int DimensionTableId { get; set; }
        public string DimensionTableName { get; set; }
        public bool IsReportingDimension { get; set; }

        public List<FactTable_DimensionTable> FactTable_DimensionTables { get; set; }
        public List<Dimension> Dimensions { get; set; }

    }
}
