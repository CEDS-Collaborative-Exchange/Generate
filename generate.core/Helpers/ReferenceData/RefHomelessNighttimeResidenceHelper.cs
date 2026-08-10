using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefHomelessNighttimeResidenceHelper
    {

        public static List<RefHomelessNighttimeResidence> GetData()
        {
            /*
            select 'data.Add(new RefHomelessNighttimeResidence() { 
            RefHomelessNighttimeResidenceId = ' + convert(varchar(20), RefHomelessNighttimeResidenceId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefHomelessNighttimeResidence
            */

            var data = new List<RefHomelessNighttimeResidence>();

            data.Add(new RefHomelessNighttimeResidence() { RefHomelessNighttimeResidenceId = 1, Code = "Shelters", Description = "Shelters" });
            data.Add(new RefHomelessNighttimeResidence() { RefHomelessNighttimeResidenceId = 2, Code = "DoubledUp", Description = "Doubled Up" });
            data.Add(new RefHomelessNighttimeResidence() { RefHomelessNighttimeResidenceId = 3, Code = "Unsheltered", Description = "Unsheltered" });
            data.Add(new RefHomelessNighttimeResidence() { RefHomelessNighttimeResidenceId = 4, Code = "HotelMotel", Description = "Hotels/Motels" });

            return data;
        }
    }
}
