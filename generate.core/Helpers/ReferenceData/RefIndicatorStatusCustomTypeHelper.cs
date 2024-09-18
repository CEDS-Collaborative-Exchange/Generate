using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefIndicatorStatusCustomTypeHelper
    {

        public static List<RefIndicatorStatusCustomType> GetData()
        {
            /*
            select 'data.Add(new RefIndicatorStatusCustomType() { 
            RefIndicatorStatusCustomTypeId = ' + convert(varchar(20), RefIndicatorStatusCustomTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefIndicatorStatusCustomType
            */

            var data = new List<RefIndicatorStatusCustomType>();

            data.Add(new RefIndicatorStatusCustomType() { RefIndicatorStatusCustomTypeId = 1, Code = "IND01", Description = "Chronic Absenteeism" });
            data.Add(new RefIndicatorStatusCustomType() { RefIndicatorStatusCustomTypeId = 2, Code = "IND02", Description = "Access to advanced coursework" });

            return data;
        }
    }
}
