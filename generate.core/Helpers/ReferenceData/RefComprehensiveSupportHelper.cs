using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefComprehensiveSupportHelper
    {

        public static List<RefComprehensiveSupport> GetData()
        {
            /*
            select 'data.Add(new RefComprehensiveSupport() { 
            RefComprehensiveSupportId = ' + convert(varchar(20), RefComprehensiveSupportId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefComprehensiveSupport
            */

            var data = new List<RefComprehensiveSupport>();

            data.Add(new RefComprehensiveSupport() { RefComprehensiveSupportId = 1, Code = "CSILOWPERF", Description = "Lowest-performing school" });
            data.Add(new RefComprehensiveSupport() { RefComprehensiveSupportId = 2, Code = "CSILOWGR", Description = "Low graduation rate high school" });
            data.Add(new RefComprehensiveSupport() { RefComprehensiveSupportId = 3, Code = "CSIOTHER", Description = "Additional targeted support school not exiting such status" });

            return data;
        }
    }
}
