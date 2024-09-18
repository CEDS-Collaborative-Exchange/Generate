using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Models.Staging
{
    public partial class AccessibleEducationMaterialAssignment
    {
        public int Id { get; set; }
        public int SchoolYear { get; set; }
        public DateTime CountDate { get; set; }
        public string IeuOrganizationIdentifierSea { get; set; }
        public string LeaIdentifierSea { get; set; }
        public string SchoolIdentifierSea { get; set; }
        public string K12StudentStudentIdentifierState { get; set; }
        public string ScedCourseCode { get; set; }
        public string CourseIdentifier { get; set; }
        public string CourseCodeSystemCode { get; set; }
        public string AccessibleEducationMaterialProviderOrganizationIdentifierSea { get; set; }
        public string AccessibleFormatIssuedIndicatorCode { get; set; }
        public string AccessibleFormatRequiredIndicatorCode { get; set; }
        public string AccessibleFormatTypeCode { get; set; }
        public DateTime? LearningResourceIssuedDate { get; set; }
        public DateTime? LearningResourceOrderedDate { get; set; }
        public DateTime? LearningResourceReceivedDate { get; set; }
        public string DataCollectionName { get; set; }

    }
}
