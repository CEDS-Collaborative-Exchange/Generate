using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefComprehensiveAndTargetedSupportHelper
    {

        public static List<RefComprehensiveAndTargetedSupport> GetData()
        {
            /*
            select 'data.Add(new RefComprehensiveAndTargetedSupport() { 
            RefComprehensiveAndTargetedSupportId = ' + convert(varchar(20), RefComprehensiveAndTargetedSupportId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefComprehensiveAndTargetedSupport
            */

            var data = new List<RefComprehensiveAndTargetedSupport>();

            data.Add(new RefComprehensiveAndTargetedSupport() { RefComprehensiveAndTargetedSupportId = 1, Code = "CSI", Description = "Comprehensive Support and Improvement" });
            data.Add(new RefComprehensiveAndTargetedSupport() { RefComprehensiveAndTargetedSupportId = 2, Code = "TSI", Description = "Targeted Support and Improvement" });
            data.Add(new RefComprehensiveAndTargetedSupport() { RefComprehensiveAndTargetedSupportId = 3, Code = "CSIEXIT", Description = "CSI - Exit Status" });
            data.Add(new RefComprehensiveAndTargetedSupport() { RefComprehensiveAndTargetedSupportId = 4, Code = "TSIEXIT", Description = "TSI - Exit Status" });
            data.Add(new RefComprehensiveAndTargetedSupport() { RefComprehensiveAndTargetedSupportId = 5, Code = "NOTCSITSI", Description = "Not CSI or TSI" });
            data.Add(new RefComprehensiveAndTargetedSupport() { RefComprehensiveAndTargetedSupportId = 6, Code = "MISSING", Description = "MISSING" });

            return data;
        }
    }
}
