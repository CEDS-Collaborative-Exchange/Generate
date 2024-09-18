using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefSchoolTypeHelper
    {

        public static List<RefSchoolType> GetData()
        {
            /*
            select 'data.Add(new RefSchoolType() { 
            RefSchoolTypeId = ' + convert(varchar(20), RefSchoolTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefSchoolType
            */

            var data = new List<RefSchoolType>();

            data.Add(new RefSchoolType() { RefSchoolTypeId = 1, Code = "Regular", Description = "Regular School" });
            data.Add(new RefSchoolType() { RefSchoolTypeId = 2, Code = "Special", Description = "Special Education School" });
            data.Add(new RefSchoolType() { RefSchoolTypeId = 3, Code = "CareerAndTechnical", Description = "Career and Technical Education School" });
            data.Add(new RefSchoolType() { RefSchoolTypeId = 4, Code = "Alternative", Description = "Alternative Education School" });
            data.Add(new RefSchoolType() { RefSchoolTypeId = 5, Code = "Reportable", Description = "Reportable Program" });

            return data;
        }
    }
}
