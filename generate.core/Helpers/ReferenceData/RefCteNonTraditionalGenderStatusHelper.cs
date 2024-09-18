using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefCteNonTraditionalGenderStatusHelper
    {

        public static List<RefCteNonTraditionalGenderStatus> GetData()
        {
            /*
            select 'data.Add(new RefCteNonTraditionalGenderStatus() { 
            RefCtenonTraditionalGenderStatusId = ' + convert(varchar(20), RefCteNonTraditionalGenderStatusId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefCteNonTraditionalGenderStatus
            */

            var data = new List<RefCteNonTraditionalGenderStatus>();

            data.Add(new RefCteNonTraditionalGenderStatus()
            {
                RefCtenonTraditionalGenderStatusId = 1,
                Code = "Underrepresented",
                Description = "Members of an underrepresented gender group"
            });
            data.Add(new RefCteNonTraditionalGenderStatus()
            {
                RefCtenonTraditionalGenderStatusId = 2,
                Code = "NotUnderrepresented",
                Description = "Not members of an underrepresented gender group"
            });
            return data;
        }
    }
}
