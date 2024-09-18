using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace generate.core.Config
{
    public class AppSettings
    {
        public string Environment { get; set; }
        public string ADLoginDomain { get; set; }
        public string BackgroundUrl { get; set; }
        public string WebAppPath { get; set; }
        public string BackgroundAppPath { get; set; }
        //MER Changed to switch to embedded mode...value currently used is EMBEDDED, otherwise defaults "normal" userstore/manager
        public string UserStoreType { get; set; }
        

    }
}
