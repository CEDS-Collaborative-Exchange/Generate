using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefAssessmentItemCharacteristicType
    {
        public RefAssessmentItemCharacteristicType()
        {
            AssessmentItemCharacteristic = new HashSet<AssessmentItemCharacteristic>();
        }

        public int RefAssessmentItemCharacteristicTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<AssessmentItemCharacteristic> AssessmentItemCharacteristic { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
