using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class Migrant
    {
        public int Id { get; set; }
        public string StudentIdentifierState { get; set; }
        public string LeaIdentifierSeaAccountability { get; set; }
        public string LeaIdentifierSeaAttendance { get; set; }
        public string LeaIdentifierSeaFunding { get; set; }
        public string LeaIdentifierSeaGraduation { get; set; }
        public string LeaIdentifierSeaIndividualizedEducationProgram { get; set; }
        public string SchoolIdentifierSea { get; set; }
        public string MigrantStatus { get; set; }
        public string MigrantEducationProgramEnrollmentType { get; set; }
        public string MigrantEducationProgramServicesType { get; set; }
        public bool? MigrantEducationProgramContinuationOfServicesStatus { get; set; }
        public string ContinuationOfServicesReason { get; set; }
        public DateTime? MigrantStudentQualifyingArrivalDate { get; set; }
        public DateTime? LastQualifyingMoveDate { get; set; }
        public bool? MigrantPrioritizedForServices { get; set; }
        public DateTime? ProgramParticipationStartDate { get; set; }
        public DateTime? ProgramParticipationExitDate { get; set; }
        public string SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
