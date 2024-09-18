using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefOutOfFieldStatusHelper
    {

        public static List<RefOutOfFieldStatus> GetData()
        {
            /*
            select 'data.Add(new RefOutOfFieldStatus() { 
            RefOutOfFieldStatusId = ' + convert(varchar(20), RefOutOfFieldStatusId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefOutOfFieldStatus
            */

            var data = new List<RefOutOfFieldStatus>();

            data.Add(new RefOutOfFieldStatus() { RefOutOfFieldStatusId = 1, Code = "TCHINFLD", Description = "Teaching in Field" });
            data.Add(new RefOutOfFieldStatus() { RefOutOfFieldStatusId = 2, Code = "TCHOUTFLD", Description = "Not Teaching in Field" });

            return data;
        }
    }
}
