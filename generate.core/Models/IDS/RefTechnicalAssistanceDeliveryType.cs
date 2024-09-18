using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefTechnicalAssistanceDeliveryType
    {
        public RefTechnicalAssistanceDeliveryType()
        {
            OrganizationTechnicalAssistance = new HashSet<OrganizationTechnicalAssistance>();
            StaffTechnicalAssistance = new HashSet<StaffTechnicalAssistance>();
        }

        public int RefTechnicalAssistanceDeliveryTypeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<OrganizationTechnicalAssistance> OrganizationTechnicalAssistance { get; set; }
        public virtual ICollection<StaffTechnicalAssistance> StaffTechnicalAssistance { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
