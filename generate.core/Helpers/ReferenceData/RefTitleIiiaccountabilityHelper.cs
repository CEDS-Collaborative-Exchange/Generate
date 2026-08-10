using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefTitleIiiaccountabilityHelper
    {

        public static List<RefTitleIiiaccountability> GetData()
        {
            /*
            select 'data.Add(new RefTitleIiiaccountability() { 
            RefTitleIiiaccountabilityId = ' + convert(varchar(20), RefTitleIiiaccountabilityId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefTitleIiiaccountability
            */

            var data = new List<RefTitleIiiaccountability>();

            data.Add(new RefTitleIiiaccountability() { RefTitleIiiaccountabilityId = 1, Code = "PROGRESS", Description = "Making progress" });
            data.Add(new RefTitleIiiaccountability() { RefTitleIiiaccountabilityId = 2, Code = "NOPROGRESS", Description = "Did not make progress" });
            data.Add(new RefTitleIiiaccountability() { RefTitleIiiaccountabilityId = 3, Code = "PROFICIENT", Description = "Attained proficiency" });

            return data;
        }
    }
}
