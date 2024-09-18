using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Models.App
{
    public class GenerateReport_TableType
    {
        public int GenerateReportId { get; set; }
        public GenerateReport GenerateReport { get; set; }
        public int TableTypeId { get; set; }
        public TableType TableType { get; set; }
    }
}
