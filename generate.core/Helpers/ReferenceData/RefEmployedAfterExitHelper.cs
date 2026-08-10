using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefEmployedAfterExitHelper
    {

        public static List<RefEmployedAfterExit> GetData()
        {
            /*
            select 'data.Add(new RefEmployedAfterExit() { 
            RefEmployedAfterExitId = ' + convert(varchar(20), RefEmployedAfterExitId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefEmployedAfterExit
            */

            var data = new List<RefEmployedAfterExit>();

            data.Add(new RefEmployedAfterExit() { RefEmployedAfterExitId = 1, Code = "Yes", Description = "Yes" });
            data.Add(new RefEmployedAfterExit() { RefEmployedAfterExitId = 2, Code = "Unknown", Description = "Unknown" });

            return data;
        }
    }
}
