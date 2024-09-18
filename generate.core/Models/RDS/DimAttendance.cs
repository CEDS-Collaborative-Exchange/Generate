using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimAttendance
    {
        public int DimAttendanceId { get; set; }

        public string AbsenteeismCode { get; set; }
        public string AbsenteeismDescription { get; set; }
        public string AbsenteeismEdFactsCode { get; set; }

        public List<FactK12StudentCount> FactStudentCounts { get; set; }

    }
}
