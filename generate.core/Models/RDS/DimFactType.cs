using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimFactType
    {
        public int DimFactTypeId { get; set; }

        public string FactTypeCode { get; set; }
        public string FactTypeDescription { get; set; }

        public List<FactK12StudentCount> FactStudentCounts { get; set; }
        public List<FactK12StudentDiscipline> FactStudentDisciplines { get; set; }
        public List<FactK12StudentAssessment> FactStudentAssessments { get; set; }
        public List<FactK12StaffCount> FactPersonnelCounts { get; set; }

        public List<FactOrganizationCount> FactOrganizationCounts { get; set; }

		public List<FactOrganizationStatusCount> FactOrganizationStatusCount { get; set; }
        public List<FactK12StudentAttendance> FactK12StudentAttendance { get; set; }
    }
}
