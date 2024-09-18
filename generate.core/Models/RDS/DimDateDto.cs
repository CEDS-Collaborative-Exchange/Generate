using System;
using System.Collections.Generic;
using System.Text;

namespace generate.core.Models.RDS
{
    public partial class DimDateDto
    {
        public int DimDateId { get; set; }
        public DateTime? DateValue { get; set; }
        public int? Year { get; set; }
        public int? Month { get; set; }
        public int? Day { get; set; }
        public string MonthName { get; set; }
        public string DayOfWeek { get; set; }
        public int? DayOfYear { get; set; }
        public string SubmissionYear { get; set; }
        public bool IsSelected { get; set; }
        public int DataMigrationTypeId { get; set; }
    }
}
