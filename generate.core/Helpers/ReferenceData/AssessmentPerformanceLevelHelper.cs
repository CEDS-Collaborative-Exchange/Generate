using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class AssessmentPerformanceLevelHelper
    {

        public static List<AssessmentPerformanceLevel> GetData()
        {
            /*
            select 'data.Add(new AssessmentPerformanceLevelHelper() { 
            AssessmentPerformanceLevelHelperId = ' + convert(varchar(20), AssessmentPerformanceLevelHelperId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.AssessmentPerformanceLevelHelper
            */

            var data = new List<AssessmentPerformanceLevel>();

            data.Add(new AssessmentPerformanceLevel() { Label = "Level 1", Identifier = "L1" });
            data.Add(new AssessmentPerformanceLevel() { Label = "Level 2", Identifier = "L2" });
            data.Add(new AssessmentPerformanceLevel() { Label = "Level 3", Identifier = "L3" });
            data.Add(new AssessmentPerformanceLevel() { Label = "Level 4", Identifier = "L4" });
            data.Add(new AssessmentPerformanceLevel() { Label = "Level 5", Identifier = "L5" });
            data.Add(new AssessmentPerformanceLevel() { Label = "Level 6", Identifier = "L6" });

            return data;
        }
    }
}
