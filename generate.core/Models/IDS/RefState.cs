using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefState
    {
        public RefState()
        {
            LocationAddress = new HashSet<LocationAddress>();
            PersonAddress = new HashSet<PersonAddress>();
            PersonBirthplace = new HashSet<PersonBirthplace>();
            PersonCredential = new HashSet<PersonCredential>();
            PersonDetail = new HashSet<PersonDetail>();
            ProgramParticipationMigrant = new HashSet<ProgramParticipationMigrant>();
        }

        public int RefStateId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<LocationAddress> LocationAddress { get; set; }
        public virtual ICollection<PersonAddress> PersonAddress { get; set; }
        public virtual ICollection<PersonBirthplace> PersonBirthplace { get; set; }
        public virtual ICollection<PersonCredential> PersonCredential { get; set; }
        public virtual ICollection<PersonDetail> PersonDetail { get; set; }
        public virtual ICollection<ProgramParticipationMigrant> ProgramParticipationMigrant { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
