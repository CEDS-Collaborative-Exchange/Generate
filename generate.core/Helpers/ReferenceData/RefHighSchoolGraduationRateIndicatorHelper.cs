using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefHighSchoolGraduationRateIndicatorHelper
    {

        public static List<RefHighSchoolGraduationRateIndicator> GetData()
        {
            /*
            select 'data.Add(new RefHighSchoolGraduationRateIndicator() { 
            RefHsgraduationRateIndicatorId = ' + convert(varchar(20), RefHSGraduationRateIndicatorId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefHighSchoolGraduationRateIndicator
            */

            var data = new List<RefHighSchoolGraduationRateIndicator>();

            data.Add(new RefHighSchoolGraduationRateIndicator() { RefHsgraduationRateIndicatorId = 1, Code = "MetGoal", Description = "Met (Goal)" });
            data.Add(new RefHighSchoolGraduationRateIndicator() { RefHsgraduationRateIndicatorId = 2, Code = "MetTarget", Description = "Met (Target)" });
            data.Add(new RefHighSchoolGraduationRateIndicator() { RefHsgraduationRateIndicatorId = 3, Code = "DidNotMeet", Description = "Did Not Meet" });
            data.Add(new RefHighSchoolGraduationRateIndicator() { RefHsgraduationRateIndicatorId = 4, Code = "TooFewStudents", Description = "Too Few Students" });
            data.Add(new RefHighSchoolGraduationRateIndicator() { RefHsgraduationRateIndicatorId = 5, Code = "NoStudents", Description = "There are no students in a student subgroup. " });
            data.Add(new RefHighSchoolGraduationRateIndicator() { RefHsgraduationRateIndicatorId = 6, Code = "NA", Description = "Not applicable" });

            return data;
        }
    }
}
