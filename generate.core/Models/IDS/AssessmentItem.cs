using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentItem
    {
        public AssessmentItem()
        {
            AssessmentFormSectionAssessmentItem = new HashSet<AssessmentFormSectionAssessmentItem>();
            AssessmentItemCharacteristic = new HashSet<AssessmentItemCharacteristic>();
            AssessmentItemPossibleResponse = new HashSet<AssessmentItemPossibleResponse>();
            AssessmentItemResponse = new HashSet<AssessmentItemResponse>();
            AssessmentSubtestAssessmentItem = new HashSet<AssessmentSubtestAssessmentItem>();
        }

        public int AssessmentItemId { get; set; }
        public string Identifier { get; set; }
        public string AssessmentItemBankIdentifier { get; set; }
        public string AssessmentItemBankName { get; set; }
        public int? RefAssessmentItemTypeId { get; set; }
        public string BodyText { get; set; }
        public string Stimulus { get; set; }
        public string Stem { get; set; }
        public bool? AdaptiveIndicator { get; set; }
        public string MaximumScore { get; set; }
        public string MinimumScore { get; set; }
        public string DistractorAnalysis { get; set; }
        public TimeSpan? AllottedTime { get; set; }
        public int? RefNaepMathComplexityLevelId { get; set; }
        public int? RefNaepAspectsOfReadingId { get; set; }
        public decimal? Difficulty { get; set; }
        public int? RefTextComplexitySystemId { get; set; }
        public string TextComplexityValue { get; set; }
        public bool? LinkingItemIndicator { get; set; }
        public bool? ReleaseStatus { get; set; }
        public int? RubricId { get; set; }
        public int? LearningResourceId { get; set; }
        public bool? AssessmentFormSectionItemFieldTestIndicator { get; set; }

        public virtual ICollection<AssessmentFormSectionAssessmentItem> AssessmentFormSectionAssessmentItem { get; set; }
        public virtual AssessmentItemApip AssessmentItemApip { get; set; }
        public virtual ICollection<AssessmentItemCharacteristic> AssessmentItemCharacteristic { get; set; }
        public virtual ICollection<AssessmentItemPossibleResponse> AssessmentItemPossibleResponse { get; set; }
        public virtual ICollection<AssessmentItemResponse> AssessmentItemResponse { get; set; }
        public virtual AssessmentItemResponseTheory AssessmentItemResponseTheory { get; set; }
        public virtual ICollection<AssessmentSubtestAssessmentItem> AssessmentSubtestAssessmentItem { get; set; }
        public virtual LearningResource LearningResource { get; set; }
        public virtual RefAssessmentItemType RefAssessmentItemType { get; set; }
        public virtual RefNaepAspectsOfReading RefNaepAspectsOfReading { get; set; }
        public virtual RefNaepMathComplexityLevel RefNaepMathComplexityLevel { get; set; }
        public virtual RefTextComplexitySystem RefTextComplexitySystem { get; set; }
        public virtual Rubric Rubric { get; set; }
    }
}
