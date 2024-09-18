using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefComprehensiveSupportImprovementHelper
    {

        public static List<RefComprehensiveSupportImprovement> GetData()
        {
            /*
            select 'data.Add(new RefComprehensiveSupportImprovement() { 
            RefComprehensiveSupportImprovementId = ' + convert(varchar(20), RefComprehensiveSupportImprovementId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefComprehensiveSupportImprovement
            */

            var data = new List<RefComprehensiveSupportImprovement>();

            data.Add(new RefComprehensiveSupportImprovement() { RefComprehensiveSupportImprovementId = 1, Code = "CSI", Description = "Comprehensive Support and Improvement" });
            data.Add(new RefComprehensiveSupportImprovement() { RefComprehensiveSupportImprovementId = 2, Code = "CSIEXIT", Description = "CSI - Exit Status" });
            data.Add(new RefComprehensiveSupportImprovement() { RefComprehensiveSupportImprovementId = 3, Code = "NOTCSI", Description = "Not CSI" });

            return data;
        }
    }
}
