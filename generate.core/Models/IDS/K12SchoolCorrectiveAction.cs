using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12schoolCorrectiveAction
    {
        public int K12schoolCorrectiveActionId { get; set; }
        public int K12schoolId { get; set; }
        public int RefCorrectiveActionTypeId { get; set; }

        public virtual K12school K12school { get; set; }
        public virtual RefCorrectiveActionType RefCorrectiveActionType { get; set; }
    }
}
