using generate.core.Models.App;
using generate.core.Models.IDS;
using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public class FactK12StudentAttendance
    {
        public int FactK12StudentAttendanceId { get; set; }

        // Facts
        public decimal StudentAttendanceRate { get; set; }
      
        // Dimensions (defining fact granularity)
        public int FactTypeId { get; set; }
        public int CountDateId { get; set; }
        public int K12StudentId { get; set; }

        // ensions (reporting)
        public int LeaId { get; set; }
        public int K12SchoolId { get; set; }
        public int K12DemographicId { get; set; }
        public int AttendanceId { get; set; }
       
        public DimFactType DimFactType { get; set; }
        public DimDate DimCountDate { get; set; }
        public DimK12Student DimStudent { get; set; }
        public DimK12School DimSchool { get; set; }
        public DimK12Demographic DimDemographic { get; set; }
        public DimAttendance DimAttendance { get; set; }
        public DimLea DimLea { get; set; }
      

    }
}
