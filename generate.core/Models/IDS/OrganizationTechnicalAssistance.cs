using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class OrganizationTechnicalAssistance
    {
        public int OrganizationTechnicalAssistanceId { get; set; }
        public int OrganizationId { get; set; }
        public int? RefTechnicalAssistanceTypeId { get; set; }
        public int? RefTechnicalAssistanceDeliveryTypeId { get; set; }
        public bool? TechnicalAssistanceApprovedInd { get; set; }

        public virtual Organization Organization { get; set; }
        public virtual RefTechnicalAssistanceDeliveryType RefTechnicalAssistanceDeliveryType { get; set; }
        public virtual RefTechnicalAssistanceType RefTechnicalAssistanceType { get; set; }
    }
}
