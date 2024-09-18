using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefIndicatorStateDefinedStatusHelper
    {

        public static List<RefIndicatorStateDefinedStatus> GetData()
        {
            /*
            select 'data.Add(new RefIndicatorStateDefinedStatus() { 
            RefIndicatorStateDefinedStatusId = ' + convert(varchar(20), RefIndicatorStateDefinedStatusId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefIndicatorStateDefinedStatus
            */

            var data = new List<RefIndicatorStateDefinedStatus>();

            data.Add(new RefIndicatorStateDefinedStatus() { RefIndicatorStateDefinedStatusId = 1, Code = "STTDEF", Description = "State defined status" });
            data.Add(new RefIndicatorStateDefinedStatus() { RefIndicatorStateDefinedStatusId = 2, Code = "TOOFEW", Description = "Too few students" });
            data.Add(new RefIndicatorStateDefinedStatus() { RefIndicatorStateDefinedStatusId = 3, Code = "NOSTUDENTS", Description = "No students in the subgroup" });
            data.Add(new RefIndicatorStateDefinedStatus() { RefIndicatorStateDefinedStatusId = 4, Code = "MISSING", Description = "The status of the indicator for a specific school is not available at the time the file is prepared." });

            return data;
        }
    }
}
