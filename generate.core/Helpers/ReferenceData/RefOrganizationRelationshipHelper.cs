using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefOrganizationRelationshipHelper
    {

        public static List<RefOrganizationRelationship> GetData()
        {
            /*
            select 'data.Add(new RefOrganizationRelationship() { 
            RefOrganizationRelationshipId = ' + convert(varchar(20), RefOrganizationRelationshipId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefOrganizationRelationship
            */

            var data = new List<RefOrganizationRelationship>();

            data.Add(new RefOrganizationRelationship() { RefOrganizationRelationshipId = 1, Code = "AuthorizingBody", Description = "Authorizing Body" });
            data.Add(new RefOrganizationRelationship() { RefOrganizationRelationshipId = 2, Code = "OperatingBody", Description = "Operating Body" });
            data.Add(new RefOrganizationRelationship() { RefOrganizationRelationshipId = 3, Code = "SecondaryAuthorizingBody", Description = "Secondary Authorizing Body" });

            return data;
        }
    }
}
