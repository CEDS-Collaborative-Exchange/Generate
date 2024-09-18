using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefMepProjectTypeHelper
    {

        public static List<RefMepProjectType> GetData()
        {
            /*
            select 'data.Add(new RefMepProjectType() { 
            RefMepProjectTypeId = ' + convert(varchar(20), RefMepProjectTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefMepProjectType
            */

            var data = new List<RefMepProjectType>();

            data.Add(new RefMepProjectType() { RefMepProjectTypeId = 1, Code = "SchoolDay", Description = "Regular school year - school day only" });
            data.Add(new RefMepProjectType() { RefMepProjectTypeId = 2, Code = "ExtendedDay", Description = "Regular school year - school day/extended day" });
            data.Add(new RefMepProjectType() { RefMepProjectTypeId = 3, Code = "SummerIntersession", Description = "Summer/intersession only" });
            data.Add(new RefMepProjectType() { RefMepProjectTypeId = 4, Code = "YearRound", Description = "Year round" });

            return data;
        }
    }
}
