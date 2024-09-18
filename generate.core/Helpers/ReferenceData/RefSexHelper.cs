using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefSexHelper
    {

        public static List<RefSex> GetData()
        {
            /*
            select 'data.Add(new RefSex() { 
            RefSexId = ' + convert(varchar(20), RefSexId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefSex
            */

            var data = new List<RefSex>();

            data.Add(new RefSex() { RefSexId = 1, Code = "Male", Description = "Male" });
            data.Add(new RefSex() { RefSexId = 2, Code = "Female", Description = "Female" });
            data.Add(new RefSex() { RefSexId = 3, Code = "NotSelected", Description = "Not selected" });

            return data;
        }
    }
}
