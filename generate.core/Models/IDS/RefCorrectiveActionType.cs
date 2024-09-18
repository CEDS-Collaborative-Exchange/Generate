using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefCorrectiveActionType
    {
        public RefCorrectiveActionType()
        {
            K12schoolCorrectiveAction = new HashSet<K12schoolCorrectiveAction>();
        }

        public int RefCorrectiveActionId { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public string Definition { get; set; }
        public int? RefJurisdictionId { get; set; }
        public decimal? SortOrder { get; set; }

        public virtual ICollection<K12schoolCorrectiveAction> K12schoolCorrectiveAction { get; set; }
        public virtual Organization RefJurisdiction { get; set; }
    }
}
