using System;
using System.Collections.Generic;

namespace generate.core.Models.IDS
{
    public partial class Application
    {
        public Application()
        {
            Authorization = new HashSet<Authorization>();
        }

        public int ApplicationId { get; set; }
        public string Name { get; set; }
        public string Uri { get; set; }

        public virtual ICollection<Authorization> Authorization { get; set; }
    }
}
