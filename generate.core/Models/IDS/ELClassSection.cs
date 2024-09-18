using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class ElclassSection
    {
        public ElclassSection()
        {
            ElclassSectionService = new HashSet<ElclassSectionService>();
            Elenrollment = new HashSet<Elenrollment>();
        }

        public int OrganizationId { get; set; }
        public int? RefServiceOptionId { get; set; }
        public decimal? HoursAvailablePerDay { get; set; }
        public int? DaysAvailablePerWeek { get; set; }
        public int? RefEnvironmentSettingId { get; set; }
        public int? ElprogramAnnualOperatingWeeks { get; set; }
        public bool? LanguageTranslationPolicy { get; set; }
        public int? GroupSize { get; set; }

        public virtual ICollection<ElclassSectionService> ElclassSectionService { get; set; }
        public virtual ICollection<Elenrollment> Elenrollment { get; set; }
        public virtual Organization Organization { get; set; }
        public virtual RefEnvironmentSetting RefEnvironmentSetting { get; set; }
        public virtual RefServiceOption RefServiceOption { get; set; }
    }
}
