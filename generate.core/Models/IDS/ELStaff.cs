using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Elstaff
    {
        public int OrganizationPersonRoleId { get; set; }
        public int? RefChildDevelopmentAssociateTypeId { get; set; }

        public virtual ElstaffEducation ElstaffEducation { get; set; }
        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefChildDevelopmentAssociateType RefChildDevelopmentAssociateType { get; set; }
    }
}
