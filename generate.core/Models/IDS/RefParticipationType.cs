using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefParticipationType
    {
        public RefParticipationType()
        {
            PersonProgramParticipation = new HashSet<PersonProgramParticipation>();
        }

        public int RefParticipationTypeId { get; set; }
        public int? OrganizationId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<PersonProgramParticipation> PersonProgramParticipation { get; set; }
        public virtual Organization Organization { get; set; }
    }
}
