using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefGradeLevelTypeHelper
    {

        public static List<RefGradeLevelType> GetData()
        {
            /*
            select 'data.Add(new RefGradeLevelType() { 
            RefGradeLevelTypeId = ' + convert(varchar(20), RefGradeLevelTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefGradeLevelType
            */

            var data = new List<RefGradeLevelType>();

            data.Add(new RefGradeLevelType() { RefGradeLevelTypeId = 1, Code = "000100", Description = "Entry Grade Level" });
            data.Add(new RefGradeLevelType() { RefGradeLevelTypeId = 2, Code = "000125", Description = "Grade Level When Course Taken" });
            data.Add(new RefGradeLevelType() { RefGradeLevelTypeId = 3, Code = "000126", Description = "Grade Level When Assessed" });
            data.Add(new RefGradeLevelType() { RefGradeLevelTypeId = 4, Code = "000131", Description = "Grades Offered" });
            data.Add(new RefGradeLevelType() { RefGradeLevelTypeId = 5, Code = "000177", Description = "Assessment Level for Which Designed" });
            data.Add(new RefGradeLevelType() { RefGradeLevelTypeId = 6, Code = "001057", Description = "Assessment Registration Grade Level To Be Assessed" });
            data.Add(new RefGradeLevelType() { RefGradeLevelTypeId = 7, Code = "001210", Description = "Exit Grade Level" });

            return data;
        }
    }
}
