using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class AssessmentFormSection
    {
        public AssessmentFormSection()
        {
            AssessmentFormAssessmentFormSection = new HashSet<AssessmentFormAssessmentFormSection>();
            AssessmentFormSectionAssessmentAsset = new HashSet<AssessmentFormSectionAssessmentAsset>();
            AssessmentFormSectionAssessmentItem = new HashSet<AssessmentFormSectionAssessmentItem>();
            AssessmentParticipantSession = new HashSet<AssessmentParticipantSession>();
            InverseChildOfFormSection = new HashSet<AssessmentFormSection>();
        }

        public int AssessmentFormSectionId { get; set; }
        public string Identifier { get; set; }
        public int? RefAssessmentFormSectionIdentificationSystemId { get; set; }
        public DateTime? PublishedDate { get; set; }
        public string Version { get; set; }
        public TimeSpan? SectionTimeLimit { get; set; }
        public bool? SectionSealed { get; set; }
        public bool? SectionReentry { get; set; }
        public string AssessmentItemBankIdentifier { get; set; }
        public string AssessmentItemBankName { get; set; }
        public int? ChildOfFormSectionId { get; set; }
        public int? LearningResourceId { get; set; }
        public string Guid { get; set; }

        public virtual ICollection<AssessmentFormAssessmentFormSection> AssessmentFormAssessmentFormSection { get; set; }
        public virtual ICollection<AssessmentFormSectionAssessmentAsset> AssessmentFormSectionAssessmentAsset { get; set; }
        public virtual ICollection<AssessmentFormSectionAssessmentItem> AssessmentFormSectionAssessmentItem { get; set; }
        public virtual ICollection<AssessmentParticipantSession> AssessmentParticipantSession { get; set; }
        public virtual AssessmentFormSection ChildOfFormSection { get; set; }
        public virtual ICollection<AssessmentFormSection> InverseChildOfFormSection { get; set; }
        public virtual LearningResource LearningResource { get; set; }
        public virtual RefAssessmentFormSectionIdentificationSystem RefAssessmentFormSectionIdentificationSystem { get; set; }
    }
}
