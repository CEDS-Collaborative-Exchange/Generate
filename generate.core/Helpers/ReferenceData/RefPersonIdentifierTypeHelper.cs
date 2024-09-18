using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefPersonIdentifierTypeHelper
    {

        public static List<RefPersonIdentifierType> GetData()
        {
            /*
            select 'data.Add(new RefPersonIdentifierType() { 
            RefPersonIdentifierTypeId = ' + convert(varchar(20), RefPersonIdentifierTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefPersonIdentifierType
            */

            var data = new List<RefPersonIdentifierType>();

            data.Add(new RefPersonIdentifierType() { RefPersonIdentifierTypeId = 1, Code = "000259", Description = "Social Security Number" });
            data.Add(new RefPersonIdentifierType() { RefPersonIdentifierTypeId = 2, Code = "000785", Description = "Child Identification System" });
            data.Add(new RefPersonIdentifierType() { RefPersonIdentifierTypeId = 3, Code = "001074", Description = "Staff Member Identification System" });
            data.Add(new RefPersonIdentifierType() { RefPersonIdentifierTypeId = 4, Code = "001075", Description = "Student Identification System" });
            data.Add(new RefPersonIdentifierType() { RefPersonIdentifierTypeId = 5, Code = "001571", Description = "Person Identification System" });

            return data;
        }
    }
}
