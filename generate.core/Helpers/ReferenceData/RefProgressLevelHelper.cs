using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefProgressLevelHelper
    {

        public static List<RefProgressLevel> GetData()
        {
            /*
            select 'data.Add(new RefProgressLevel() { 
            RefProgressLevelId = ' + convert(varchar(20), RefProgressLevelId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefProgressLevel
            */

            var data = new List<RefProgressLevel>();

            data.Add(new RefProgressLevel() { RefProgressLevelId = 1, Code = "NEGGRADE", Description = "Negative grade level change" });
            data.Add(new RefProgressLevel() { RefProgressLevelId = 2, Code = "NOCHANGE", Description = "No change" });
            data.Add(new RefProgressLevel() { RefProgressLevelId = 3, Code = "UPHALFGRADE", Description = "Improvement of up to one half grade level" });
            data.Add(new RefProgressLevel() { RefProgressLevelId = 4, Code = "UPONEGRADE", Description = "Improvement from one half grade level up to one full grade level" });
            data.Add(new RefProgressLevel() { RefProgressLevelId = 5, Code = "UPGTONE", Description = "Improvement of more than one full grade level" });

            return data;
        }
    }
}
