using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCountry
    {
        public RefCountry()
        {
            LocationAddress = new HashSet<LocationAddress>();
            PersonAddress = new HashSet<PersonAddress>();
            PersonBirthplace = new HashSet<PersonBirthplace>();
            ProgramParticipationMigrant = new HashSet<ProgramParticipationMigrant>();
        }

        public int RefCountryId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<LocationAddress> LocationAddress { get; set; }
        public virtual ICollection<PersonAddress> PersonAddress { get; set; }
        public virtual ICollection<PersonBirthplace> PersonBirthplace { get; set; }
        public virtual ICollection<ProgramParticipationMigrant> ProgramParticipationMigrant { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
