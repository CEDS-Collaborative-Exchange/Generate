using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class K12SchoolTargetedSupportIdentificationType
    {
        public int Id { get; set; }
        public string SchoolYear { get; set; }
        public string LEAIdentifierState { get; set; }
        public string SchoolIdentifierState { get; set; }
        public string Subgroup { get; set; }
        public string ComprehensiveSupport { get; set; }
        public string ComprehensiveSupportReasonApplicability { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
