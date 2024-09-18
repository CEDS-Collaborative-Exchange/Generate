using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class Assessment
    {
        public int Id { get; set; }
        public string AssessmentIdentifier { get; set; }
        public string AssessmentTitle { get; set; }
        public string AssessmentShortName { get; set; }
        public string AssessmentAcademicSubject { get; set; }
        public string AssessmentPurpose { get; set; }
        public string AssessmentType { get; set; }
        public string AssessmentTypeAdministered { get; set; }
        public string AssessmentTypeAdministeredToEnglishLearners { get; set; }
        public string AssessmentFamilyTitle { get; set; }
        public string AssessmentFamilyShortName { get; set; }
        public DateTime? AssessmentAdministrationStartDate { get; set; }
        public DateTime? AssessmentAdministrationFinishDate { get; set; }
        public string AssessmentPerformanceLevelIdentifier { get; set; }
        public string AssessmentPerformanceLevelLabel { get; set; }
        public string DataCollectionName { get; set; }
        //public int? DataCollectionId { get; set; }
        //public int? AssessmentId { get; set; }
        //public int? AssessmentAdministrationId { get; set; }
        //public int? AssessmentSubtestId { get; set; }
        //public int? AssessmentFormId { get; set; }
        //public int? AssessmentPerformanceLevelId { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
