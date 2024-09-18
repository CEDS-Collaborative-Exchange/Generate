using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefOperationalStatusTypeHelper
    {

        public static List<RefOperationalStatusType> GetData()
        {
            /*
            select 'data.Add(new RefOperationalStatusType() { 
            RefOperationalStatusTypeId = ' + convert(varchar(20), RefOperationalStatusTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefOperationalStatusType
            */

            var data = new List<RefOperationalStatusType>();

            data.Add(new RefOperationalStatusType() { RefOperationalStatusTypeId = 1, Code = "000174", Description = "Local Education Agency Operational Status" });
            data.Add(new RefOperationalStatusType() { RefOperationalStatusTypeId = 2, Code = "000533", Description = "School Operational Status" });
            data.Add(new RefOperationalStatusType() { RefOperationalStatusTypeId = 3, Code = "001418", Description = "Organization Operational Status" });

            return data;
        }
    }
}
