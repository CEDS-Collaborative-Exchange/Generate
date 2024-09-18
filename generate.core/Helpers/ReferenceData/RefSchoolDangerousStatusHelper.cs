using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefSchoolDangerousStatusHelper
    {

        public static List<RefSchoolDangerousStatus> GetData()
        {
            /*
            select 'data.Add(new RefSchoolDangerousStatus() { 
            RefSchoolDangerousStatusId = ' + convert(varchar(20), RefSchoolDangerousStatusId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefSchoolDangerousStatus
            */

            var data = new List<RefSchoolDangerousStatus>();

            data.Add(new RefSchoolDangerousStatus() { RefSchoolDangerousStatusId = 1, Code = "YES", Description = "Persistently Dangerous" });
            data.Add(new RefSchoolDangerousStatus() { RefSchoolDangerousStatusId = 2, Code = "NO", Description = "Not Persistently Dangerous" });

            return data;
        }
    }
}
