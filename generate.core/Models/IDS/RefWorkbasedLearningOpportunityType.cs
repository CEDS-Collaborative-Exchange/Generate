using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefWorkbasedLearningOpportunityType
    {
        public RefWorkbasedLearningOpportunityType()
        {
            K12course = new HashSet<K12course>();
            ProgramParticipationAe = new HashSet<ProgramParticipationAe>();
            ProgramParticipationCte = new HashSet<ProgramParticipationCte>();
            PsSection = new HashSet<PsSection>();
            PsstudentProgram = new HashSet<PsstudentProgram>();
        }

        public int RefWorkbasedLearningOpportunityTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12course> K12course { get; set; }
        public virtual ICollection<ProgramParticipationAe> ProgramParticipationAe { get; set; }
        public virtual ICollection<ProgramParticipationCte> ProgramParticipationCte { get; set; }
        public virtual ICollection<PsSection> PsSection { get; set; }
        public virtual ICollection<PsstudentProgram> PsstudentProgram { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
