using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class LearningStandardItem
    {
        public LearningStandardItem()
        {
            AssessmentSubtestLearningStandardItem = new HashSet<AssessmentSubtestLearningStandardItem>();
            CompetencyItemCompetencySet = new HashSet<CompetencyItemCompetencySet>();
            LearningStandardItemAssociation = new HashSet<LearningStandardItemAssociation>();
            LearningStandardItemEducationLevel = new HashSet<LearningStandardItemEducationLevel>();
            InverseChildOfLearningStandardItemNavigation = new HashSet<LearningStandardItem>();
        }

        public int LearningStandardItemId { get; set; }
        public string Identifier { get; set; }
        public string Code { get; set; }
        public string Url { get; set; }
        public string Type { get; set; }
        public string Statement { get; set; }
        public string Version { get; set; }
        public string TypicalAgeRange { get; set; }
        public int? RefLanguageId { get; set; }
        public string TextComplexitySystem { get; set; }
        public decimal? TextComplexityMinimumValue { get; set; }
        public decimal? TextComplexityMaximumValue { get; set; }
        public int? RefBloomsTaxonomyDomainId { get; set; }
        public int? RefMultipleIntelligenceTypeId { get; set; }
        public string ConceptTerm { get; set; }
        public string ConceptKeyword { get; set; }
        public string License { get; set; }
        public string Notes { get; set; }
        public string LearningStandardItemParentId { get; set; }
        public string LearningStandardItemParentCode { get; set; }
        public string LearningStandardItemParentUrl { get; set; }
        public int? ChildOfLearningStandardItem { get; set; }
        public int LearningStandardDocumentId { get; set; }
        public bool? CurrentVersionIndicator { get; set; }
        public string PreviousVersionIdentifier { get; set; }
        public DateTime? ValidStartDate { get; set; }
        public DateTime? ValidEndDate { get; set; }
        public string NodeName { get; set; }
        public int? RefLearningStandardItemNodeAccessibilityProfileId { get; set; }
        public int? RefLearningStandardItemTestabilityTypeId { get; set; }
        public string LearningStandardItemSequence { get; set; }

        public virtual ICollection<AssessmentSubtestLearningStandardItem> AssessmentSubtestLearningStandardItem { get; set; }
        public virtual ICollection<CompetencyItemCompetencySet> CompetencyItemCompetencySet { get; set; }
        public virtual ICollection<LearningStandardItemAssociation> LearningStandardItemAssociation { get; set; }
        public virtual ICollection<LearningStandardItemEducationLevel> LearningStandardItemEducationLevel { get; set; }
        public virtual LearningStandardItem ChildOfLearningStandardItemNavigation { get; set; }
        public virtual ICollection<LearningStandardItem> InverseChildOfLearningStandardItemNavigation { get; set; }
        public virtual LearningStandardDocument LearningStandardDocument { get; set; }
        public virtual RefBloomsTaxonomyDomain RefBloomsTaxonomyDomain { get; set; }
        public virtual RefLanguage RefLanguage { get; set; }
        public virtual RefLearningStandardItemNodeAccessibilityProfile RefLearningStandardItemNodeAccessibilityProfile { get; set; }
        public virtual RefLearningStandardItemTestabilityType RefLearningStandardItemTestabilityType { get; set; }
        public virtual RefMultipleIntelligenceType RefMultipleIntelligenceType { get; set; }
    }
}
