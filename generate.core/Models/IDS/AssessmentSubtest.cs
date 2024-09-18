using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentSubtest
    {
        public AssessmentSubtest()
        {
            AssessmentPerformanceLevel = new HashSet<AssessmentPerformanceLevel>();
            AssessmentResult = new HashSet<AssessmentResult>();
            AssessmentSubtestAssessmentItem = new HashSet<AssessmentSubtestAssessmentItem>();
            AssessmentSubtestEldevelopmentalDomain = new HashSet<AssessmentSubtestEldevelopmentalDomain>();
            AssessmentSubtestLearningStandardItem = new HashSet<AssessmentSubtestLearningStandardItem>();
            AssessmentSubtestLevelsForWhichDesigned = new HashSet<AssessmentSubtestLevelsForWhichDesigned>();
            InverseChildOfAssessmentSubtest = new HashSet<AssessmentSubtest>();
        }

        public int AssessmentSubtestId { get; set; }
        public string Identifier { get; set; }
        public int? RefAssessmentSubtestIdentifierTypeId { get; set; }
        public string Title { get; set; }
        public string Version { get; set; }
        public DateTime? PublishedDate { get; set; }
        public string Abbreviation { get; set; }
        public int? RefScoreMetricTypeId { get; set; }
        public string MinimumValue { get; set; }
        public string MaximumValue { get; set; }
        public string OptimalValue { get; set; }
        public int? Tier { get; set; }
        public string ContainerOnly { get; set; }
        public int? RefAssessmentPurposeId { get; set; }
        public string Description { get; set; }
        public string Rules { get; set; }
        public int? RefContentStandardTypeId { get; set; }
        public int? RefAcademicSubjectId { get; set; }
        public int? ChildOf_AssessmentSubtestId { get; set; }
        public int? AssessmentFormId { get; set; }

        public virtual ICollection<AssessmentPerformanceLevel> AssessmentPerformanceLevel { get; set; }
        public virtual ICollection<AssessmentResult> AssessmentResult { get; set; }
        public virtual ICollection<AssessmentSubtestAssessmentItem> AssessmentSubtestAssessmentItem { get; set; }
        public virtual ICollection<AssessmentSubtestEldevelopmentalDomain> AssessmentSubtestEldevelopmentalDomain { get; set; }
        public virtual ICollection<AssessmentSubtestLearningStandardItem> AssessmentSubtestLearningStandardItem { get; set; }
        public virtual ICollection<AssessmentSubtestLevelsForWhichDesigned> AssessmentSubtestLevelsForWhichDesigned { get; set; }
        public virtual AssessmentForm AssessmentForm { get; set; }
        public virtual AssessmentSubtest ChildOfAssessmentSubtest { get; set; }
        public virtual ICollection<AssessmentSubtest> InverseChildOfAssessmentSubtest { get; set; }
        public virtual RefAcademicSubject RefAcademicSubject { get; set; }
        public virtual RefAssessmentPurpose RefAssessmentPurpose { get; set; }
        public virtual RefAssessmentSubtestIdentifierType RefAssessmentSubtestIdentifierType { get; set; }
        public virtual RefContentStandardType RefContentStandardType { get; set; }
        public virtual RefScoreMetricType RefScoreMetricType { get; set; }
    }
}
