using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimCharterSchoolStatusHelper
    {
        public static List<DimCharterSchoolStatus> GetData()
        {


            var data = new List<DimCharterSchoolStatus>();

            /*
            select 'data.Add(new DimCharterSchoolStatus() { 
            DimCharterSchoolStatusId = ' + convert(varchar(20), DimCharterSchoolStatusId) + ',
            AppropriationMethodId = ' + convert(varchar(20), AppropriationMethodId) + ',
            AppropriationMethodEdFactsCode = "' + AppropriationMethodEdFactsCode + '"
			});'
            from rds.DimCharterSchoolStatus
            */


            data.Add(new DimCharterSchoolStatus() { DimCharterSchoolStatusId = -1, AppropriationMethodId = -1, AppropriationMethodEdFactsCode = "MISSING" });
            data.Add(new DimCharterSchoolStatus() { DimCharterSchoolStatusId = 1,  AppropriationMethodId = 1,  AppropriationMethodEdFactsCode = "STEAPRDRCT" });
            data.Add(new DimCharterSchoolStatus() { DimCharterSchoolStatusId = 2,  AppropriationMethodId = 2,  AppropriationMethodEdFactsCode = "STEAPRTHRULEA" });
            data.Add(new DimCharterSchoolStatus() { DimCharterSchoolStatusId = 3,  AppropriationMethodId = 3,  AppropriationMethodEdFactsCode = "STEAPRALLOCLEA" });
            
            return data;

        }
    }
}
 