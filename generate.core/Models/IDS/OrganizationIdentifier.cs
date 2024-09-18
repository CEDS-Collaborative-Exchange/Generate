using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationIdentifier
    {
        public int OrganizationIdentifierId { get; set; }
        public string Identifier { get; set; }
        public int? RefOrganizationIdentificationSystemId { get; set; }
        public int OrganizationId { get; set; }
        public int? RefOrganizationIdentifierTypeId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefOrganizationIdentificationSystem RefOrganizationIdentificationSystem { get; set; }
        public virtual RefOrganizationIdentifierType RefOrganizationIdentifierType { get; set; }
    }
}
