using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationEmail
    {
        public int OrganizationEmailId { get; set; }
        public int OrganizationId { get; set; }
        public string ElectronicMailAddress { get; set; }
        public int? RefEmailTypeId { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefEmailType RefEmailType { get; set; }
    }
}
