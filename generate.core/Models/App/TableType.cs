using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Models.App
{
    public class TableType
    {
        public int TableTypeId { get; set; }
        public string TableTypeAbbrv { get; set; }
        public string TableTypeName { get; set; }
        public int EdFactsTableTypeId { get; set; }
        public List<GenerateReport_TableType> GenerateReport_TableTypes { get; set; }
    }
}