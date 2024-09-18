using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class PsstudentProgram
    {
        public int PsstudentProgramId { get; set; }
        public int OrganizationPersonRoleId { get; set; }
        public int? RefCipUseId { get; set; }
        public int? PsProgramId { get; set; }
        public int? RefWorkbasedLearningOpportunityTypeId { get; set; }
        public int? RefTransferOutIndicatorId { get; set; }

        public virtual OrganizationPersonRole OrganizationPersonRole { get; set; }
        public virtual PsProgram PsProgram { get; set; }
        public virtual RefCipUse RefCipUse { get; set; }
        public virtual RefTransferOutIndicator RefTransferOutIndicator { get; set; }
        public virtual RefWorkbasedLearningOpportunityType RefWorkbasedLearningOpportunityType { get; set; }
    }
}
