using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefIndicatorStatusSubgroupTypeHelper
    {

        public static List<RefIndicatorStatusSubgroupType> GetData()
        {
            /*
            select 'data.Add(new RefIndicatorStatusSubgroupType() { 
            RefIndicatorStatusSubgroupTypeId = ' + convert(varchar(20), RefIndicatorStatusSubgroupTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefIndicatorStatusSubgroupType
            */

            var data = new List<RefIndicatorStatusSubgroupType>();

            data.Add(new RefIndicatorStatusSubgroupType() { RefIndicatorStatusSubgroupTypeId = 1, Code = "RaceEthnicity", Description = "Race Ethnicity" });
            data.Add(new RefIndicatorStatusSubgroupType() { RefIndicatorStatusSubgroupTypeId = 2, Code = "DisabilityStatus", Description = "Disability Status" });
            data.Add(new RefIndicatorStatusSubgroupType() { RefIndicatorStatusSubgroupTypeId = 3, Code = "EnglishLearnerStatus", Description = "English Learner Status" });
            data.Add(new RefIndicatorStatusSubgroupType() { RefIndicatorStatusSubgroupTypeId = 4, Code = "EconomicallyDisadvantagedStatus", Description = "Economically DisadvantagedStatus" });
            data.Add(new RefIndicatorStatusSubgroupType() { RefIndicatorStatusSubgroupTypeId = 5, Code = "AllStudents", Description = "All Students" });

            return data;
        }
    }
}
