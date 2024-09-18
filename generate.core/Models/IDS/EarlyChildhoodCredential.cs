using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class EarlyChildhoodCredential
    {
        public int PersonCredentialId { get; set; }
        public int RefEarlyChildhoodCredentialId { get; set; }

        public virtual PersonCredential PersonCredential { get; set; }
        public virtual RefEarlyChildhoodCredential RefEarlyChildhoodCredential { get; set; }
    }
}
