using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefTargetedSupportImprovementHelper
    {

        public static List<RefTargetedSupportImprovement> GetData()
        {
            /*
            select 'data.Add(new RefTargetedSupportImprovement() { 
            RefTargetedSupportImprovementId = ' + convert(varchar(20), RefTargetedSupportImprovementId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefTargetedSupportImprovement
            */

            var data = new List<RefTargetedSupportImprovement>();
            
            data.Add(new RefTargetedSupportImprovement() { RefTargetedSupportImprovementId = 1, Code = "TSI", Description = "Targeted Support and Improvement" });
            data.Add(new RefTargetedSupportImprovement() { RefTargetedSupportImprovementId = 2, Code = "TSIEXIT", Description = "TSI - Exit Status" });
            data.Add(new RefTargetedSupportImprovement() { RefTargetedSupportImprovementId = 3, Code = "NOTTSI", Description = "Not TSI" });            

            return data;
        }
    }
}
