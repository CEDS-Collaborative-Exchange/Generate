using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefCharterSchoolManagementOrganizationTypeHelper
    {

        public static List<RefCharterSchoolManagementOrganizationType> GetData()
        {
            /*
            select 'data.Add(new RefCharterSchoolManagementOrganizationType() { 
            RefCharterSchoolManagementOrganizationTypeId = ' + convert(varchar(20), RefCharterSchoolManagementOrganizationTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefCharterSchoolManagementOrganizationType
            */

            var data = new List<RefCharterSchoolManagementOrganizationType>();

            data.Add(new RefCharterSchoolManagementOrganizationType()
            {
                RefCharterSchoolManagementOrganizationTypeId = 1,
                Code = "CMO",
                Description = "Charter Management Organization"
            });
            data.Add(new RefCharterSchoolManagementOrganizationType()
            {
                RefCharterSchoolManagementOrganizationTypeId = 2,
                Code = "EMO",
                Description = "Education Management Organization"
            });
            data.Add(new RefCharterSchoolManagementOrganizationType()
            {
                RefCharterSchoolManagementOrganizationTypeId = 3,
                Code = "Other",
                Description = "Other Management Organization"
            });

            return data;
        }
    }
}
