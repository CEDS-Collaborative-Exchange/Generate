using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class K12StudentCourseSection
    {
        public int Id { get; set; }
        public string StudentIdentifierState { get; set; }
        public string LeaIdentifierSeaAccountability { get; set; }
        public string LeaIdentifierSeaAttendance { get; set; }
        public string LeaIdentifierSeaFunding { get; set; }
        public string LeaIdentifierSeaGraduation { get; set; }
        public string LeaIdentifierSeaIndividualizedEducationProgram { get; set; }
        public string SchoolIdentifierSea { get; set; }
        public string CourseGradeLevel { get; set; }
        public string ScedCourseCode { get; set; }
        public string CourseIdentifier { get; set; }
        public string CourseCodeSystemCode { get; set; }
        public DateTime? CourseRecordStartDateTime { get; set; }
        public string CourseLevelCharacteristic { get; set; }
        public DateTime? EntryDate { get; set; }
        public DateTime? ExitDate { get; set; }
        public int? SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
