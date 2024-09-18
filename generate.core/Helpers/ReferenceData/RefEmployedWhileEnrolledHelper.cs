using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefEmployedWhileEnrolledHelper
    {

        public static List<RefEmployedWhileEnrolled> GetData()
        {
            /*
            select 'data.Add(new RefEmployedWhileEnrolled() { 
            RefEmployedWhileEnrolledId = ' + convert(varchar(20), RefEmployedWhileEnrolledId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefEmployedWhileEnrolled
            */

            var data = new List<RefEmployedWhileEnrolled>();

            data.Add(new RefEmployedWhileEnrolled() { RefEmployedWhileEnrolledId = 1, Code = "Yes", Description = "Yes" });
            data.Add(new RefEmployedWhileEnrolled() { RefEmployedWhileEnrolledId = 2, Code = "Unknown", Description = "Unknown" });

            return data;
        }
    }
}
