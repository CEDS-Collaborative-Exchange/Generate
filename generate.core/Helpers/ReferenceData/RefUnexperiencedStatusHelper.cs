using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefUnexperiencedStatusHelper
    {

        public static List<RefUnexperiencedStatus> GetData()
        {
            /*
            select 'data.Add(new RefUnexperiencedStatus() { 
            RefUnexperiencedStatusId = ' + convert(varchar(20), RefUnexperiencedStatusId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefUnexperiencedStatus
            */

            var data = new List<RefUnexperiencedStatus>();

            data.Add(new RefUnexperiencedStatus() { RefUnexperiencedStatusId = 1, Code = "TCHEXPRNCD", Description = "Experienced teachers" });
            data.Add(new RefUnexperiencedStatus() { RefUnexperiencedStatusId = 2, Code = "TCHINEXPRNCD", Description = "Inexperienced teachers" });

            return data;
        }
    }
}
