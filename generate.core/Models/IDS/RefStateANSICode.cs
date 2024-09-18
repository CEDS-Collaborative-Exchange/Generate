using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class RefStateAnsicode
    {
        public RefStateAnsicode()
        {
            K12sea = new HashSet<K12sea>();
        }

        public int RefStateAnsicodeId { get; set; }
        public string Code { get; set; }
        public string StateName { get; set; }

        public virtual ICollection<K12sea> K12sea { get; set; }
    }
}
