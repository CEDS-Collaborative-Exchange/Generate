using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentItemResponse
    {
        public AssessmentItemResponse()
        {
            AssessmentItemRubricCriterionResult = new HashSet<AssessmentItemRubricCriterionResult>();
            LearnerAction = new HashSet<LearnerAction>();
        }

        public int AssessmentItemResponseId { get; set; }
        public string Value { get; set; }
        public string ScoreValue { get; set; }
        public int? RefAssessItemResponseStatusId { get; set; }
        public int? RefProficiencyStatusId { get; set; }
        public string AidSetUsed { get; set; }
        public string DescriptiveFeedback { get; set; }
        public bool? ScaffoldingItemFlag { get; set; }
        public int? HintCount { get; set; }
        public bool? HintIncludedAnswer { get; set; }
        public TimeSpan? Duration { get; set; }
        public TimeSpan? FirstAttemptDuration { get; set; }
        public TimeSpan? StartTime { get; set; }
        public DateTime? StartDate { get; set; }
        public string SecurityIssue { get; set; }
        public int AssessmentItemId { get; set; }
        public int AssessmentParticipantSessionId { get; set; }
        public string ResultXml { get; set; }
        public DateTime? AssessmentItemResponseDescriptiveFeedbackDate { get; set; }
        public int? RefAssessmentItemResponseScoreStatusId { get; set; }

        public virtual ICollection<AssessmentItemRubricCriterionResult> AssessmentItemRubricCriterionResult { get; set; }
        public virtual ICollection<LearnerAction> LearnerAction { get; set; }
        public virtual AssessmentItem AssessmentItem { get; set; }
        public virtual AssessmentParticipantSession AssessmentParticipantSession { get; set; }
        public virtual RefAssessmentItemResponseStatus RefAssessItemResponseStatus { get; set; }
        public virtual RefAssessmentItemResponseScoreStatus RefAssessmentItemResponseScoreStatus { get; set; }
        public virtual RefProficiencyStatus RefProficiencyStatus { get; set; }
    }
}
