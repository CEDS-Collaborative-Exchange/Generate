using System;
using System.Collections.Generic;

namespace generate.core.Models.Staging
{
    public partial class K12SchoolComprehensiveSupportIdentificationType
    {
        public int Id { get; set; }
        public string SchoolYear { get; set; }
        public string LEAIdentifierSea { get; set; }
        public string SchoolIdentifierSea { get; set; }
        public string ComprehensiveSupport { get; set; }
        public string ComprehensiveSupportReasonApplicability { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public DateTime? RunDateTime { get; set; }
    }
}
