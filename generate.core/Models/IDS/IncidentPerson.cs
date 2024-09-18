using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class IncidentPerson
    {
        public int IncidentId { get; set; }
        public int PersonId { get; set; }
        public string Identifier { get; set; }
        public int RefIncidentPersonRoleTypeId { get; set; }
        public int? RefIncidentPersonTypeId { get; set; }

        public virtual Incident Incident { get; set; }
        public virtual Person Person { get; set; }
        public virtual RefIncidentPersonRoleType RefIncidentPersonRoleType { get; set; }
        public virtual RefIncidentPersonType RefIncidentPersonType { get; set; }
    }
}
