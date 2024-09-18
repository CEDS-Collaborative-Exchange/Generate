using generate.core.Models.App;
using generate.core.Models.IDS;
using System;
using System.Collections;
using System.Collections.Generic;

namespace generate.core.Models.RDS
{
    public class FactK12StudentCount
    {
        public int FactK12StudentCountId { get; set; }

        // Facts
        public int StudentCount { get; set; }
        public DateTime? StudentCutOverStartDate { get; set; }

        // Dimensions (defining fact granularity)
        public int FactTypeId { get; set; }
        public int CountDateId { get; set; }
        public int K12StudentId { get; set; }

        // Dimensions (reporting)
        public int LeaId { get; set; }
        public int K12SchoolId { get; set; }
        public int K12DemographicId { get; set; }
        public int IdeaStatusId { get; set; }
        public int AgeId { get; set; }
        public int GradeLevelId { get; set; }
        public int ProgramStatusId { get; set; }
        public int TitleIStatusId { get; set; }
        public int LanguageId { get; set; }
        public int MigrantId { get; set; }
        public int StudentStatusId { get; set; }
        public int TitleIIIStatusId { get; set; }
        public int AttendanceId { get; set; }
		public int CohortStatusId { get; set; }

        public int NorDProgramStatusId { get; set; }
        public int CteStatusId { get; set; }
        public int EnrollmentStatusId { get; set; }

        public int RaceId { get; set; }
      
        public DimFactType DimFactType { get; set; }
        public DimDate DimCountDate { get; set; }
        public DimK12Student DimStudent { get; set; }
        public DimK12School DimSchool { get; set; }
        public DimK12Demographic DimDemographic { get; set; }
        public DimIdeaStatus DimIdeaStatus { get; set; }
        public DimAge DimAge { get; set; }
        public DimGradeLevel DimGradeLevel { get; set; }
        public DimProgramStatus DimProgramStatus { get; set; }
        public DimTitleIStatus DimTitle1Status { get; set; }
        public DimAttendance DimAttendance { get; set; }

        public DimLanguage DimLanguage { get; set; }
        public DimMigrant DimMigrant { get; set; }
        public DimK12StudentStatus DimStudentStatus { get; set; }

        public DimTitleIIIStatus DimTitleIIIStatus { get; set; }
        public DimLea DimLea { get; set; }
		public DimCohortStatus DimCohortStatuses { get; set; }

        public DimNorDProgramStatus DimNorDProgramStatus { get; set; }
        public DimRace DimRace { get; set; }
    
        public DimCteStatus DimCteStatus { get; set; }
        public DimK12EnrollmentStatus DimEnrollmentStatus { get; set; }

    }
}
