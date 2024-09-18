using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationPersonRoleRelationship
    {
        public int OrganizationPersonRoleRelationshipId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public int OrganizationPersonRoleId_Parent { get; set; }
        public DateTime RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual OrganizationPersonRole ParentOrganizationPersonRole { get; set; }        
    }
}
