using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Models.App
{
    public class FileColumn
    {
        public int FileColumnId { get; set; }
        public string ColumnName { get; set; }
        public string XMLElementName { get; set; }
        public string DisplayName { get; set; }
        public int ColumnLength { get; set; }
        public string DataType { get; set; }
        public int? DimensionId { get; set; }
        public Dimension Dimension { get; set; }
        public List<FileSubmission_FileColumn> FileSubmission_FileColumns { get; set; }

    }
}
