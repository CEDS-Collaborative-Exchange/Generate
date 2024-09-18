using System;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public partial class DimK12Student
    {
        public int DimK12StudentId { get; set; }
        //public int? StudentPersonId { get; set; }
        public string StateStudentIdentifier { get; set; }

        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string Cohort { get; set; }

        public DateTime? BirthDate { get; set; }

        public int? SexId { get; set; }
        public string SexCode { get; set; }
        public string SexDescription { get; set; }
        public string SexEdFactsCode { get; set; }

        public List<FactK12StudentCount> FactK12StudentCounts { get; set; }
        public List<FactK12StudentDiscipline> FactK12StudentDisciplines { get; set; }
        public List<FactK12StudentAssessment> FactK12StudentAssessments { get; set; }
        public List<FactK12StudentAttendance> FactK12StudentAttendance { get; set; }

    }
}
