using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PersonDisability
    {
        public int PersonId { get; set; }
        public int? PrimaryDisabilityTypeId { get; set; }
        public bool? DisabilityStatus { get; set; }
        public int? RefAccommodationsNeededTypeId { get; set; }
        public int? RefDisabilityConditionTypeId { get; set; }
        public int? RefDisabilityDeterminationSourceTypeId { get; set; }
        public int? RefDisabilityConditionStatusCodeId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }
        public int PersonDisabilityId { get; set; }

        public virtual Person Person { get; set; }
        public virtual RefDisabilityType PrimaryDisabilityType { get; set; }
        public virtual RefAccommodationsNeededType RefAccommodationsNeededType { get; set; }
        public virtual RefDisabilityConditionStatusCode RefDisabilityConditionStatusCode { get; set; }
        public virtual RefDisabilityConditionType RefDisabilityConditionType { get; set; }
        public virtual RefDisabilityDeterminationSourceType RefDisabilityDeterminationSourceType { get; set; }
    }
}
