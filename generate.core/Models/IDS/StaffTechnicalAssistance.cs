using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class StaffTechnicalAssistance
    {
        public int StaffTechnicalAssistanceId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public int? RefTechnicalAssistanceTypeId { get; set; }
        public int? RefTechnicalAssistanceDeliveryTypeId { get; set; }
        public bool? TechnicalAssistanceApprovedInd { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual RefTechnicalAssistanceDeliveryType RefTechnicalAssistanceDeliveryType { get; set; }
        public virtual RefTechnicalAssistanceType RefTechnicalAssistanceType { get; set; }
    }
}
