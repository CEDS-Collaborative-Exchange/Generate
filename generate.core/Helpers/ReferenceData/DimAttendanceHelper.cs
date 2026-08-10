using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimAttendanceHelper
    {
        public static List<DimAttendance> GetData()
        {


            var data = new List<DimAttendance>();

            /*
            select 'data.Add(new DimAttendance() { 
            DimAttendanceId = ' + convert(varchar(20), DimAttendanceId) + ',
            AbsenteeismId = ' + convert(varchar(20), AbsenteeismId) + ',
            AbsenteeismEdFactsCode = "' + AbsenteeismEdFactsCode + '"
			});'
            from rds.DimAttendance
            */

            //data.Add(new DimAttendance() { DimAttendanceId = -1, AbsenteeismId = -1, AbsenteeismEdFactsCode = "MISSING" });
            //data.Add(new DimAttendance() { DimAttendanceId = 1, AbsenteeismId = 1, AbsenteeismEdFactsCode = "CA" });
            //data.Add(new DimAttendance() { DimAttendanceId = 2, AbsenteeismId = 2, AbsenteeismEdFactsCode = "NCA" });

            return data;

        }
    }
}
 