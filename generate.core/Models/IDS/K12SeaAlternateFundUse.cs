using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class K12seaAlternateFundUse
    {
        public int K12SEAlternateFundUseId { get; set; }
        public int RefAlternateFundUsesId { get; set; }
        public int K12seaFederalFundsId { get; set; }
        public DateTime? RecordStartDateTime { get; set; }
        public DateTime? RecordEndDateTime { get; set; }

        public virtual K12seaFederalFunds K12seaFederalFunds { get; set; }
        public virtual RefAlternateFundUses RefAlternateFundUses { get; set; }
    }
}
