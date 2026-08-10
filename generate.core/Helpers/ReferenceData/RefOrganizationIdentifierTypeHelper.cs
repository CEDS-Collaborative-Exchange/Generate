using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefOrganizationIdentifierTypeHelper
    {

        public static List<RefOrganizationIdentifierType> GetData()
        {
            /*
            select 'data.Add(new RefOrganizationIdentifierType() { 
            RefOrganizationIdentifierTypeId = ' + convert(varchar(20), RefOrganizationIdentifierTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefOrganizationIdentifierType
            */

            var data = new List<RefOrganizationIdentifierType>();

            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 1, Code = "000006", Description = "Activity Identifier" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 2, Code = "000055", Description = "Course Identifier" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 3, Code = "000056", Description = "Course Code System" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 4, Code = "000111", Description = "Federal School Code" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 5, Code = "000166", Description = "Institution IPEDS UnitID" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 6, Code = "000175", Description = "Local Education Agency Supervisory Union Identification Number" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 7, Code = "000203", Description = "Office of Postsecondary Education Identifier" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 8, Code = "000625", Description = "Program Identifier" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 9, Code = "000781", Description = "Adult Education Service Provider Identification System" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 10, Code = "000827", Description = "Organization Identification System" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 11, Code = "000978", Description = "Course Section Identifier" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 12, Code = "001072", Description = "Local Education Agency Identification System" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 13, Code = "001073", Description = "School Identification System" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 14, Code = "001078", Description = "Adult Education Provider Type" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 15, Code = "001156", Description = "Organization Type" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 16, Code = "001280", Description = "Agency Course Identifier" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 17, Code = "001315", Description = "Course Section Number" });
            data.Add(new RefOrganizationIdentifierType() { RefOrganizationIdentifierTypeId = 18, Code = "001491", Description = "State Agency Identification System" });

            return data;
        }
    }
}
