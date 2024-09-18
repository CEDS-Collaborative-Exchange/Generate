using generate.core.Models.App;
using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimDate
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

        public List<FactK12StudentCount> StudentCountFacts { get; set; }
        public List<FactK12StudentDiscipline> FactStudentDisciplines { get; set; }
        public List<FactK12StudentAssessment> FactStudentAssessments { get; set; }
        public List<FactK12StaffCount> FactPersonnelCounts { get; set; }

        public List<FactOrganizationCount> FactOrganizationCounts { get; set; }

		public List<FactOrganizationStatusCount> FactOrganizationStatusCount { get; set; }
        public List<FactK12StudentAttendance> FactK12StudentAttendance { get; set; }


    }
}
