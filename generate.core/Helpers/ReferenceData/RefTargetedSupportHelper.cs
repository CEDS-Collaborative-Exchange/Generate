using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefTargetedSupportHelper
    {

        public static List<RefTargetedSupport> GetData()
        {
            /*
            select 'data.Add(new RefTargetedSupport() { 
            RefTargetedSupportId = ' + convert(varchar(20), RefTargetedSupportId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefTargetedSupport
            */

            var data = new List<RefTargetedSupport>();

            data.Add(new RefTargetedSupport() { RefTargetedSupportId = 1, Code = "TSIUNDER", Description = "Consistently underperforming subgroups school" });
            data.Add(new RefTargetedSupport() { RefTargetedSupportId = 2, Code = "TSIOTHER", Description = "Additional targeted support and improvement school" });

            return data;
        }
    }
}
