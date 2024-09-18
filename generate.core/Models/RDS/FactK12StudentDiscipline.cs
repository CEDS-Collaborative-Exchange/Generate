using System;

namespace generate.core.Models.RDS
{
    public class FactK12StudentDiscipline
    {
        public int FactK12StudentDisciplineId { get; set; }

        // Facts
        public int DisciplineCount { get; set; }
        public decimal DisciplineDuration { get; set; }

        public DateTime DisciplinaryActionStartDate { get; set; }

        // Dimensions (defining fact granularity)

        public int FactTypeId { get; set; }
        public int CountDateId { get; set; }
        public int K12StudentId { get; set; }
        public int DisciplineId { get; set; }

        // ensions (reporting)
        public int LeaId { get; set; }
        public int K12SchoolId { get; set; }
        public int K12DemographicId { get; set; }
        public int IdeaStatusId { get; set; }
        public int AgeId { get; set; }
        public int ProgramStatusId { get; set; }
        public int GradeLevelId { get; set; }
        public int FirearmsId { get; set; }
        public int FirearmsDisciplineId { get; set; }
        public int RaceId { get; set; }
        public int CteStatusId { get; set; }
        // Dimension Properties
        public DimFactType DimFactType { get; set; }
        public DimDate DimCountDate { get; set; }
        public DimK12Student DimStudent { get; set; }
        public DimDiscipline DimDiscipline { get; set; }
        public DimLea DimLea { get; set; }
        public DimK12School DimSchool { get; set; }
        public DimK12Demographic DimDemographic { get; set; }
        public DimIdeaStatus DimIdeaStatus { get; set; }
        public DimAge DimAge { get; set; }
        public DimProgramStatus DimProgramStatus { get; set; }
        public DimGradeLevel DimGradeLevel { get; set; }
        public DimFirearms DimFirearms { get; set; }
        public DimFirearmDiscipline DimFirearmsDiscipline { get; set; }
        public DimRace DimRace {get; set;}
        public DimCteStatus DimCteStatus { get; set; }
    }
}
