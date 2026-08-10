using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefOrganizationLocationTypeHelper
    {

        public static List<RefOrganizationLocationType> GetData()
        {
            /*
            select 'data.Add(new RefOrganizationLocationType() { 
            RefOrganizationLocationTypeId = ' + convert(varchar(20), RefOrganizationLocationTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefOrganizationLocationType
            */

            var data = new List<RefOrganizationLocationType>();

            data.Add(new RefOrganizationLocationType() { RefOrganizationLocationTypeId = 1, Code = "Mailing", Description = "Mailing" });
            data.Add(new RefOrganizationLocationType() { RefOrganizationLocationTypeId = 2, Code = "Physical", Description = "Physical" });
            data.Add(new RefOrganizationLocationType() { RefOrganizationLocationTypeId = 3, Code = "Shipping", Description = "Shipping" });

            return data;
        }
    }
}
