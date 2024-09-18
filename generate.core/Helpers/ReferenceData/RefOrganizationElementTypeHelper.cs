using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefOrganizationElementTypeHelper
    {

        public static List<RefOrganizationElementType> GetData()
        {
            /*
            select 'data.Add(new RefOrganizationElementType() { 
            RefOrganizationElementTypeId = ' + convert(varchar(20), RefOrganizationElementTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefOrganizationElementType
            */

            var data = new List<RefOrganizationElementType>();

            data.Add(new RefOrganizationElementType() { RefOrganizationElementTypeId = 1, Code = "001078", Description = "Adult Education Provider Type" });
            data.Add(new RefOrganizationElementType() { RefOrganizationElementTypeId = 2, Code = "001156", Description = "Organization Type" });

            return data;
        }
    }
}
