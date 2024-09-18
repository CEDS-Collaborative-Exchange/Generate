using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ProgramParticipationAe
    {
        public int PersonProgramParticipationId { get; set; }
        public int? RefAeInstructionalProgramTypeId { get; set; }
        public int? RefAePostsecondaryTransitionActionId { get; set; }
        public DateTime? PostsecondaryTransitionDate { get; set; }
        public int? RefAeSpecialProgramTypeId { get; set; }
        public int? RefAeFunctioningLevelAtIntakeId { get; set; }
        public int? RefAeFunctioningLevelAtPosttestId { get; set; }
        public int? RefGoalsForAttendingAdultEducationId { get; set; }
        public bool? DisplacedHomemakerIndicator { get; set; }
        public decimal? ProxyContactHours { get; set; }
        public decimal? InstructionalActivityHoursCompleted { get; set; }
        public int? RefCorrectionalEducationFacilityTypeId { get; set; }
        public int? RefWorkbasedLearningOpportunityTypeId { get; set; }
        public int ProgramParticipationAeid { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }

        public virtual PersonProgramParticipation PersonProgramParticipation { get; set; }
        public virtual RefAeFunctioningLevelAtIntake RefAeFunctioningLevelAtIntake { get; set; }
        public virtual RefAeFunctioningLevelAtPosttest RefAeFunctioningLevelAtPosttest { get; set; }
        public virtual RefAeInstructionalProgramType RefAeInstructionalProgramType { get; set; }
        public virtual RefAePostsecondaryTransitionAction RefAePostsecondaryTransitionAction { get; set; }
        public virtual RefAeSpecialProgramType RefAeSpecialProgramType { get; set; }
        public virtual RefCorrectionalEducationFacilityType RefCorrectionalEducationFacilityType { get; set; }
        public virtual RefGoalsForAttendingAdultEducation RefGoalsForAttendingAdultEducation { get; set; }
        public virtual RefWorkbasedLearningOpportunityType RefWorkbasedLearningOpportunityType { get; set; }
    }
}
