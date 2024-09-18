using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationDetail
    {
        public int OrganizationDetailId { get; set; }
        public int OrganizationId { get; set; }
        public string Name { get; set; }
        public int? RefOrganizationTypeId { get; set; }
        public string ShortName { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefOrganizationType RefOrganizationType { get; set; }
    }
}
