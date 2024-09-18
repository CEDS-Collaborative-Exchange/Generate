using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefIdeaeducationalEnvironmentEc
    {
        public RefIdeaeducationalEnvironmentEc()
        {
            ProgramParticipationSpecialEducation = new HashSet<ProgramParticipationSpecialEducation>();
        }

        public int RefIdeaeducationalEnvironmentEcid { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ProgramParticipationSpecialEducation> ProgramParticipationSpecialEducation { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
