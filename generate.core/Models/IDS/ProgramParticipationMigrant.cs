using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ProgramParticipationMigrant
    {
        public int PersonProgramParticipationId { get; set; }
        public int? RefMepEnrollmentTypeId { get; set; }
        public int? RefMepProjectBasedId { get; set; }
        public int? RefMepServiceTypeId { get; set; }
        public DateTime? MepEligibilityExpirationDate { get; set; }
        public bool? ContinuationOfServicesStatus { get; set; }
        public int? RefContinuationOfServicesReasonId { get; set; }
        public string BirthdateVerification { get; set; }
        public bool? ImmunizationRecordFlag { get; set; }
        public DateTime? MigrantStudentQualifyingArrivalDate { get; set; }
        public DateTime? LastQualifyingMoveDate { get; set; }
        public string QualifyingMoveFromCity { get; set; }
        public int? RefQualifyingMoveFromStateId { get; set; }
        public int? RefQualifyingMoveFromCountryId { get; set; }
        public int? DesignatedGraduationSchoolId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public int ProgramParticipationMigrantId { get; set; }
        public bool? PrioritizedForServices { get; set; }

        public virtual Organization DesignatedGraduationSchool { get; set; }
        public virtual PersonProgramParticipation PersonProgramParticipation { get; set; }
        public virtual RefContinuationOfServices RefContinuationOfServicesReason { get; set; }
        public virtual RefMepEnrollmentType RefMepEnrollmentType { get; set; }
        public virtual RefMepProjectBased RefMepProjectBased { get; set; }
        public virtual RefMepServiceType RefMepServiceType { get; set; }
        public virtual RefCountry RefQualifyingMoveFromCountry { get; set; }
        public virtual RefState RefQualifyingMoveFromState { get; set; }
    }
}
