using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefPdinstructionalDeliveryMode
    {
        public RefPdinstructionalDeliveryMode()
        {
            ProfessionalDevelopmentSession = new HashSet<ProfessionalDevelopmentSession>();
        }

        public int RefPdinstructionalDeliveryModeId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ProfessionalDevelopmentSession> ProfessionalDevelopmentSession { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
