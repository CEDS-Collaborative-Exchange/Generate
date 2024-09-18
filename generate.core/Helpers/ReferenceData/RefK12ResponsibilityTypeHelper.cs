using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefK12responsibilityTypeHelper
    {

        public static List<RefK12responsibilityType> GetData()
        {
            /*
            select 'data.Add(new RefK12responsibilityType() { 
            RefK12responsibilityTypeId = ' + convert(varchar(20), RefK12responsibilityTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefK12responsibilityType
            */

            var data = new List<RefK12responsibilityType>();

            data.Add(new RefK12responsibilityType() { RefK12responsibilityTypeId = 1, Code = "Accountability", Description = "Accountability" });
            data.Add(new RefK12responsibilityType() { RefK12responsibilityTypeId = 2, Code = "Attendance", Description = "Attendance" });
            data.Add(new RefK12responsibilityType() { RefK12responsibilityTypeId = 3, Code = "Funding", Description = "Funding" });
            data.Add(new RefK12responsibilityType() { RefK12responsibilityTypeId = 4, Code = "Graduation", Description = "Graduation" });
            data.Add(new RefK12responsibilityType() { RefK12responsibilityTypeId = 5, Code = "IndividualizedEducationProgram", Description = "Individualized education program (IEP)" });
            data.Add(new RefK12responsibilityType() { RefK12responsibilityTypeId = 6, Code = "Transportation", Description = "Transportation" });

            return data;
        }
    }
}
