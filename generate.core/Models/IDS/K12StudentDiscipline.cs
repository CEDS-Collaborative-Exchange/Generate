using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12studentDiscipline
    {
        public int K12studentDisciplineId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public int? RefDisciplineReasonId { get; set; }
        public int? RefDisciplinaryActionTakenId { get; set; }
        public DateTime? DisciplinaryActionStartDate { get; set; }
        public DateTime? DisciplinaryActionEndDate { get; set; }
        public decimal? DurationOfDisciplinaryAction { get; set; }
        public int? RefDisciplineLengthDifferenceReasonId { get; set; }
        public bool? FullYearExpulsion { get; set; }
        public bool? ShortenedExpulsion { get; set; }
        public bool? EducationalServicesAfterRemoval { get; set; }
        public int? RefIdeaInterimRemovalId { get; set; }
        public int? RefIdeaInterimRemovalReasonId { get; set; }
        public bool? RelatedToZeroTolerancePolicy { get; set; }
        public int? IncidentId { get; set; }
        public bool? IepplacementMeetingIndicator { get; set; }
        public int? RefDisciplineMethodFirearmsId { get; set; }
        public int? RefDisciplineMethodOfCwdId { get; set; }
        public int? RefIdeadisciplineMethodFirearmId { get; set; }

        public virtual Incident Incident { get; set; }
        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefDisciplinaryActionTaken RefDisciplinaryActionTaken { get; set; }
        public virtual RefDisciplineLengthDifferenceReason RefDisciplineLengthDifferenceReason { get; set; }
        public virtual RefDisciplineMethodFirearms RefDisciplineMethodFirearms { get; set; }
        public virtual RefDisciplineMethodOfCwd RefDisciplineMethodOfCwd { get; set; }
        public virtual RefDisciplineReason RefDisciplineReason { get; set; }
        public virtual RefIdeainterimRemoval RefIdeaInterimRemoval { get; set; }
        public virtual RefIdeainterimRemovalReason RefIdeaInterimRemovalReason { get; set; }
        public virtual RefIdeadisciplineMethodFirearm RefIdeadisciplineMethodFirearm { get; set; }
    }
}
