using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Dtos.App
{
    public class FileSubmissionColumnDto
    {
        public int FileColumnId { get; set; }
        public string ColumnName { get; set; }
        public string ReportField { get; set; }
        public int ColumnLength { get; set; }
        public string DataType { get; set; }
        public string DisplayName { get; set; }
        public string XMLElementName { get; set; }
        public int SequenceNumber { get; set; }
        public int StartPosition { get; set; }
        public int EndPosition { get; set; }
        public bool IsOptional { get; set; }
        public string ReportColumn { get; set; }
    }
}
