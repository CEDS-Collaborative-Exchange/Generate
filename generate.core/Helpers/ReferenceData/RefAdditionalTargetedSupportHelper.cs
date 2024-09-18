using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefAdditionalTargetedSupportHelper
    {

        public static List<RefAdditionalTargetedSupport> GetData()
        {
            /*
            select 'data.Add(new RefAdditionalTargetedSupport() { 
            RefAdditionalTargetedSupportId = ' + convert(varchar(20), RefAdditionalTargetedSupportId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefAdditionalTargetedSupport
            */

            var data = new List<RefAdditionalTargetedSupport>();

            data.Add(new RefAdditionalTargetedSupport() { RefAdditionalTargetedSupportId = 1, Code = "ADDLTSI", Description = "Additional Targeted Support and Improvement" });
            data.Add(new RefAdditionalTargetedSupport() { RefAdditionalTargetedSupportId = 2, Code = "NOTADDLTSI", Description = "Not Additional Targeted Support and Improvement" });            

            return data;
        }
    }
}
