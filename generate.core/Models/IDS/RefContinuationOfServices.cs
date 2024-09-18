using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefContinuationOfServices
    {
        public RefContinuationOfServices()
        {
            ProgramParticipationMigrant = new HashSet<ProgramParticipationMigrant>();
        }

        public int RefContinuationOfServicesReasonId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<ProgramParticipationMigrant> ProgramParticipationMigrant { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
