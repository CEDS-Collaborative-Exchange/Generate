using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12studentActivity
    {
        public int OrganizationPersonRoleId { get; set; }
        public decimal? ActivityTimeInvolved { get; set; }
        public int? RefActivityTimeMeasurementTypeId { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefActivityTimeMeasurementType RefActivityTimeMeasurementType { get; set; }
    }
}
