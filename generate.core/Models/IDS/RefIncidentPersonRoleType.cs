using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefIncidentPersonRoleType
    {
        public RefIncidentPersonRoleType()
        {
            IncidentPerson = new HashSet<IncidentPerson>();
        }

        public int RefIncidentPersonRoleTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<IncidentPerson> IncidentPerson { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
