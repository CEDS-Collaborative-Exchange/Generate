using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Config
{
    public class DataSettings
    {
        public string AppDbContextConnection { get; set; }
        public string ODSDbContextConnection { get; set; }
        public string StagingDbContextConnection { get; set; }
        public string RDSDbContextConnection { get; set; }

    }
}
