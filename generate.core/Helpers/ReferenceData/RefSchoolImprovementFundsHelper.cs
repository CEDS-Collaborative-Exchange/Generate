using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefSchoolImprovementFundsHelper
    {

        public static List<RefSchoolImprovementFunds> GetData()
        {
            /*
            select 'data.Add(new RefSchoolImprovementFunds() { 
            RefSchoolImprovementFundsId = ' + convert(varchar(20), RefSchoolImprovementFundsId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefSchoolImprovementFunds
            */

            var data = new List<RefSchoolImprovementFunds>();

            data.Add(new RefSchoolImprovementFunds() { RefSchoolImprovementFundsId = 1, Code = "Yes", Description = "Yes" });
            data.Add(new RefSchoolImprovementFunds() { RefSchoolImprovementFundsId = 2, Code = "No", Description = "No" });

            return data;
        }
    }
}
