using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefAmaoAttainmentStatusHelper
    {

        public static List<RefAmaoAttainmentStatus> GetData()
        {
            /*
            select 'data.Add(new RefAmaoAttainmentStatus() { 
            RefAmaoAttainmentStatusId = ' + convert(varchar(20), RefAmaoAttainmentStatusId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefAmaoAttainmentStatus
            */

            var data = new List<RefAmaoAttainmentStatus>();

            data.Add(new RefAmaoAttainmentStatus()
            {
                RefAmaoAttainmentStatusId = 1,
                Code = "Met",
                Description = "Met"
            });
            data.Add(new RefAmaoAttainmentStatus()
            {
                RefAmaoAttainmentStatusId = 2,
                Code = "DidNotMeet",
                Description = "Did not meet"
            });
            data.Add(new RefAmaoAttainmentStatus()
            {
                RefAmaoAttainmentStatusId = 3,
                Code = "NoTitleIII",
                Description = "No Title III"
            });
            data.Add(new RefAmaoAttainmentStatus()
            {
                RefAmaoAttainmentStatusId = 4,
                Code = "NA",
                Description = "Not applicable"
            });

            return data;
        }
    }
}
