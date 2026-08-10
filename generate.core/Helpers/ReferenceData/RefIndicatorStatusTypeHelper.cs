using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefIndicatorStatusTypeHelper
    {

        public static List<RefIndicatorStatusType> GetData()
        {
            /*
            select 'data.Add(new RefIndicatorStatusType() { 
            RefIndicatorStatusTypeId = ' + convert(varchar(20), RefIndicatorStatusTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefIndicatorStatusType
            */

            var data = new List<RefIndicatorStatusType>();

            data.Add(new RefIndicatorStatusType() { RefIndicatorStatusTypeId = 1, Code = "GraduationRateIndicatorStatus", Description = "Graduation Rate Indicator Status" });
            data.Add(new RefIndicatorStatusType() { RefIndicatorStatusTypeId = 2, Code = "AcademicAchievementIndicatorStatus", Description = "Academic Achievement Indicator Status" });
            data.Add(new RefIndicatorStatusType() { RefIndicatorStatusTypeId = 3, Code = "OtherAcademicIndicatorStatus", Description = "Other Academic Indicator Status" });
            data.Add(new RefIndicatorStatusType() { RefIndicatorStatusTypeId = 4, Code = "SchoolQualityOrStudentSuccessIndicatorStatus", Description = "School Quality or Student Success Indicator Status" });

            return data;
        }
    }
}
