using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefSessionTypeHelper
    {

        public static List<RefSessionType> GetData()
        {
            /*
            select 'data.Add(new RefSessionType() { 
            RefSessionTypeId = ' + convert(varchar(20), RefSessionTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefSessionType
            */

            var data = new List<RefSessionType>();

            data.Add(new RefSessionType() { RefSessionTypeId = 1, Code = "FullSchoolYear", Description = "Full School Year" });
            data.Add(new RefSessionType() { RefSessionTypeId = 2, Code = "Intersession", Description = "Intersession" });
            data.Add(new RefSessionType() { RefSessionTypeId = 3, Code = "LongSession", Description = "Long Session" });
            data.Add(new RefSessionType() { RefSessionTypeId = 4, Code = "MiniTerm", Description = "Mini Term" });
            data.Add(new RefSessionType() { RefSessionTypeId = 5, Code = "Quarter", Description = "Quarter" });
            data.Add(new RefSessionType() { RefSessionTypeId = 6, Code = "Quinmester", Description = "Quinmester" });
            data.Add(new RefSessionType() { RefSessionTypeId = 7, Code = "Semester", Description = "Semester" });
            data.Add(new RefSessionType() { RefSessionTypeId = 8, Code = "SummerTerm", Description = "Summer Term" });
            data.Add(new RefSessionType() { RefSessionTypeId = 9, Code = "Trimester", Description = "Trimester" });
            data.Add(new RefSessionType() { RefSessionTypeId = 10, Code = "TwelveMonth", Description = "Twelve Month" });
            data.Add(new RefSessionType() { RefSessionTypeId = 11, Code = "Other", Description = "Other" });

            return data;
        }
    }
}
