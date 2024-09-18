using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentResult
    {
        public AssessmentResult()
        {
            AchievementEvidence = new HashSet<AchievementEvidence>();
            AssessmentResultPerformanceLevel = new HashSet<AssessmentResult_PerformanceLevel>();
            AssessmentResultRubricCriterionResult = new HashSet<AssessmentResultRubricCriterionResult>();
        }

        public int AssessmentResultId { get; set; }
        public string ScoreValue { get; set; }
        public int? RefScoreMetricTypeId { get; set; }
        public bool? PreliminaryIndicator { get; set; }
        public int? RefAssessmentPretestOutcomeId { get; set; }
        public int? NumberOfResponses { get; set; }
        public string DiagnosticStatement { get; set; }
        public string DiagnosticStatementSource { get; set; }
        public string DescriptiveFeedback { get; set; }
        public string DescriptiveFeedbackSource { get; set; }
        public string InstructionalRecommendation { get; set; }
        public bool? IncludedInAypCalculation { get; set; }
        public DateTime? DateUpdated { get; set; }
        public DateTime? DateCreated { get; set; }
        public int AssessmentSubtestId { get; set; }
        public int AssessmentRegistrationId { get; set; }
        public int? RefEloutcomeMeasurementLevelId { get; set; }
        public int? RefOutcomeTimePointId { get; set; }
        public DateTime? AssessmentResultDescriptiveFeedbackDateTime { get; set; }
        public decimal? AssessmentResultScoreStandardError { get; set; }
        public int? RefAssessmentResultDataTypeId { get; set; }
        public int? RefAssessmentResultScoreTypeId { get; set; }

        public virtual ICollection<AchievementEvidence> AchievementEvidence { get; set; }
        public virtual ICollection<AssessmentResult_PerformanceLevel> AssessmentResultPerformanceLevel { get; set; }
        public virtual ICollection<AssessmentResultRubricCriterionResult> AssessmentResultRubricCriterionResult { get; set; }
        public virtual AssessmentRegistration AssessmentRegistration { get; set; }
        public virtual AssessmentSubtest AssessmentSubtest { get; set; }
        public virtual RefAssessmentPretestOutcome RefAssessmentPretestOutcome { get; set; }
        public virtual RefAssessmentResultDataType RefAssessmentResultDataType { get; set; }
        public virtual RefAssessmentResultScoreType RefAssessmentResultScoreType { get; set; }
        public virtual RefEloutcomeMeasurementLevel RefEloutcomeMeasurementLevel { get; set; }
        public virtual RefOutcomeTimePoint RefOutcomeTimePoint { get; set; }
        public virtual RefScoreMetricType RefScoreMetricType { get; set; }
    }
}
