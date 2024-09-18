using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElclassSectionService
    {
        public int ElclassSectionServiceId { get; set; }
        public int OrganizationId { get; set; }
        public int? YoungestAgeServed { get; set; }
        public int? OldestAgeServed { get; set; }
        public bool? ServesChildrenWithSpecialNeeds { get; set; }
        public int? RefElgroupSizeStandardMetId { get; set; }
        public string ElclassGroupCurriculumType { get; set; }
        public int? RefFrequencyOfServiceId { get; set; }

        public virtual ElclassSection Organization { get; set; }
        public virtual RefElgroupSizeStandardMet RefElgroupSizeStandardMet { get; set; }
        public virtual RefFrequencyOfService RefFrequencyOfService { get; set; }
    }
}
