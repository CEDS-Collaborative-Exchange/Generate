using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ProgramParticipationCte
    {
        public int PersonProgramParticipationId { get; set; }
        public bool? CteParticipant { get; set; }
        public bool? CteConcentrator { get; set; }
        public bool? CteCompleter { get; set; }
        public bool? SingleParentOrSinglePregnantWoman { get; set; } 
        public bool? DisplacedHomemakerIndicator { get; set; }
        public bool? CteNonTraditionalCompletion { get; set; }
        public int? RefNonTraditionalGenderStatusId { get; set; }
        public int? RefWorkbasedLearningOpportunityTypeId { get; set; }
        public DateTime? CareerPathwaysProgramParticipationExitDate { get; set; }
        public DateTime? CareerPathwaysProgramParticipationStartDate { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public int ProgramParticipationCteId { get; set; }

        public virtual PersonProgramParticipation PersonProgramParticipation { get; set; }
        public virtual RefNonTraditionalGenderStatus RefNonTraditionalGenderStatus { get; set; }
        public virtual RefWorkbasedLearningOpportunityType RefWorkbasedLearningOpportunityType { get; set; }
    }
}
