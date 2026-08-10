using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefFirearmTypeHelper
    {

        public static List<RefFirearmType> GetData()
        {
            /*
            select 'data.Add(new RefFirearmType() { 
            RefFirearmTypeId = ' + convert(varchar(20), RefFirearmTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefFirearmType
            */

            var data = new List<RefFirearmType>();

            data.Add(new RefFirearmType() { RefFirearmTypeId = 1, Code = "Handguns", Description = "Handguns" });
            data.Add(new RefFirearmType() { RefFirearmTypeId = 2, Code = "RiflesShotguns", Description = "Rifles / Shotguns" });
            data.Add(new RefFirearmType() { RefFirearmTypeId = 3, Code = "Multiple", Description = "More than one type of weapon or firearm" });
            data.Add(new RefFirearmType() { RefFirearmTypeId = 4, Code = "Other", Description = "Other" });

            return data;
        }
    }
}
