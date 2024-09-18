using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElorganizationAvailability
    {
        public int OrganizationId { get; set; }
        public int? DaysAvailablePerWeek { get; set; }
        public int? HoursAvailablePerDay { get; set; }
        public int? YoungestAgeServed { get; set; }
        public int? OldestAgeServed { get; set; }
        public string AgeUnit { get; set; }
        public int? RefEnvironmentSettingId { get; set; }
        public int? NumberOfClassrooms { get; set; }
        public int? RefServiceOptionId { get; set; }
        public int? RefPopulationServedId { get; set; }
        public int? AnnualOperatingWeeks { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefEnvironmentSetting RefEnvironmentSetting { get; set; }
        public virtual RefPopulationServed RefPopulationServed { get; set; }
        public virtual RefServiceOption RefServiceOption { get; set; }
    }
}
