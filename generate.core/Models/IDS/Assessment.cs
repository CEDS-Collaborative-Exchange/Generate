using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Assessment
    {
        public Assessment()
        {
            AssessmentAssessmentAdministration = new HashSet<AssessmentAssessmentAdministration>();
            AssessmentEldevelopmentalDomain = new HashSet<AssessmentEldevelopmentalDomain>();
            AssessmentForm = new HashSet<AssessmentForm>();
            AssessmentLanguage = new HashSet<AssessmentLanguage>();
            AssessmentLevelsForWhichDesigned = new HashSet<AssessmentLevelsForWhichDesigned>();
        }

        public int AssessmentId { get; set; }
        public string Identifier { get; set; }
        public int? IdentificationSystem { get; set; }
        public string Guid { get; set; }
        public string Title { get; set; }
        public string ShortName { get; set; }
        public int RefAcademicSubjectId { get; set; }
        public string Objective { get; set; }
        public string Provider { get; set; }
        public int? RefAssessmentPurposeId { get; set; }
        public int? RefAssessmentTypeId { get; set; }
        public int? RefAssessmentTypeChildrenWithDisabilitiesId { get; set; }
        public int? RefAssessmentTypeAdministeredToEnglishLearnersId { get; set; }
        public DateTime? AssessmentRevisionDate { get; set; }
        public string AssessmentFamilyTitle { get; set; }
        public string AssessmentFamilyShortName { get; set; }

        public virtual ICollection<AssessmentAssessmentAdministration> AssessmentAssessmentAdministration { get; set; }
        public virtual ICollection<AssessmentEldevelopmentalDomain> AssessmentEldevelopmentalDomain { get; set; }
        public virtual ICollection<AssessmentForm> AssessmentForm { get; set; }
        public virtual ICollection<AssessmentLanguage> AssessmentLanguage { get; set; }
        public virtual ICollection<AssessmentLevelsForWhichDesigned> AssessmentLevelsForWhichDesigned { get; set; }
        public virtual RefAcademicSubject RefAcademicSubject { get; set; }
        public virtual RefAssessmentPurpose RefAssessmentPurpose { get; set; }
        public virtual RefAssessmentTypeChildrenWithDisabilities RefAssessmentTypeChildrenWithDisabilities { get; set; }
        public virtual RefAssessmentTypeAdministeredToEnglishLearners RefAssessmentTypeAdministeredToEnglishLearners { get; set; }
        public virtual RefAssessmentType RefAssessmentType { get; set; }
    }
}
