using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefLeaTypeHelper
    {

        public static List<RefLeaType> GetData()
        {
            /*
            select 'data.Add(new RefLeaType() { 
            RefLeaTypeId = ' + convert(varchar(20), RefLeaTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefLeaType
            */

            var data = new List<RefLeaType>();

            data.Add(new RefLeaType() { RefLeaTypeId = 1, Code = "RegularNotInSupervisoryUnion", Description = "Regular public school district that is NOT a component of a supervisory union" });
            data.Add(new RefLeaType() { RefLeaTypeId = 2, Code = "RegularInSupervisoryUnion", Description = "Regular public school district that is a component of a supervisory union" });
            data.Add(new RefLeaType() { RefLeaTypeId = 3, Code = "SupervisoryUnion", Description = " Supervisory Union" });
            data.Add(new RefLeaType() { RefLeaTypeId = 4, Code = "SpecializedPublicSchoolDistrict", Description = "Specialized Public School District" });
            data.Add(new RefLeaType() { RefLeaTypeId = 5, Code = "ServiceAgency", Description = "Service Agency" });
            data.Add(new RefLeaType() { RefLeaTypeId = 6, Code = "StateOperatedAgency", Description = "State Operated Agency" });
            data.Add(new RefLeaType() { RefLeaTypeId = 7, Code = "FederalOperatedAgency", Description = "Federal Operated Agency" });
            data.Add(new RefLeaType() { RefLeaTypeId = 8, Code = "Other", Description = "Other Local Education Agencies" });

            return data;
        }
    }
}
