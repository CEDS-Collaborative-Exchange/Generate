using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefSpecialEducationAgeGroupTaughtHelper
    {

        public static List<RefSpecialEducationAgeGroupTaught> GetData()
        {
            /*
            select 'data.Add(new RefSpecialEducationAgeGroupTaught() { 
            RefSpecialEducationAgeGroupTaughtId = ' + convert(varchar(20), RefSpecialEducationAgeGroupTaughtId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefSpecialEducationAgeGroupTaught
            */

            var data = new List<RefSpecialEducationAgeGroupTaught>();

            data.Add(new RefSpecialEducationAgeGroupTaught() { RefSpecialEducationAgeGroupTaughtId = 1, Code = "3TO5", Description = "3 through 5" });
            data.Add(new RefSpecialEducationAgeGroupTaught() { RefSpecialEducationAgeGroupTaughtId = 2, Code = "6TO21", Description = "6 through 21" });

            return data;
        }
    }
}
