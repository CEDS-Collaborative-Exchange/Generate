using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class Disability
    {
        public int ID { get; set; }
        public string StudentIdentifierState { get; set; }
        public string LeaIdentifierSeaAccountability { get; set; }
        public string LeaIdentifierSeaAttendance { get; set; }
        public string LeaIdentifierSeaFunding { get; set; }
        public string LeaIdentifierSeaGraduation { get; set; }
        public string LeaIdentifierSeaIndividualizedEducationProgram { get; set; }
        public string SchoolIdentifierSea { get; set; }
        public Boolean ResponsibleSchoolTypeAccountability { get; set; }
        public Boolean ResponsibleSchoolTypeAttendance { get; set; }
        public Boolean ResponsibleSchoolTypeFunding { get; set; }
        public Boolean ResponsibleSchoolTypeGraduation { get; set; }
        public Boolean ResponsibleSchoolTypeIndividualizedEducationProgram { get; set; }
        public Boolean ResponsibleSchoolTypeTransportation { get; set; }
        public Boolean ResponsibleSchoolTypeIepServiceProvider { get; set; }
        public string DisabilityStatus { get; set; }
        public DateTime? Disability_StatusStartDate { get; set; }
        public DateTime? Disability_StatusEndDate { get; set; }
        public string DisabilityConditionType { get; set; }
        public string DisabilityDeterminationSourceType { get; set; }
        public Boolean Section504Status { get; set; }
        public Int16 SchoolYear { get; set; }
        public string DataCollectionName { get; set; }
        public string RunDateTime { get; set; }
    }
}
