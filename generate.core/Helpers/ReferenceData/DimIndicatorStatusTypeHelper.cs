using generate.core.Models.RDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class DimIndicatorStatusTypeHelper
    {

        public static List<DimIndicatorStatusType> GetData()
        {
            /*
            select 'data.Add(new DimIndicatorStatusType() { 
            DimIndicatorStatusTypeId = ' + convert(varchar(20), DimIndicatorStatusTypeId) + ',
            IndicatorStatusTypeId = ' + convert(varchar(20), IndicatorStatusTypeId) + ',
            IndicatorStatusTypeCode = "' + IndicatorStatusTypeCode + '",
            IndicatorStatusTypeDescription = "' + IndicatorStatusTypeDescription + '",
            IndicatorStatusTypeEdFactsCode = "' + IndicatorStatusTypeEdFactsCode + '"
            });'
            from Rds.DimIndicatorStatusTypes
            */

            var data = new List<DimIndicatorStatusType>();

            data.Add(new DimIndicatorStatusType() { DimIndicatorStatusTypeId = -1, IndicatorStatusTypeId = -1, IndicatorStatusTypeCode = "Missing", IndicatorStatusTypeDescription = "State Defined Status not set", IndicatorStatusTypeEdFactsCode = "Missing" });
            data.Add(new DimIndicatorStatusType() { DimIndicatorStatusTypeId = 5, IndicatorStatusTypeId = 1, IndicatorStatusTypeCode = "GraduationRateIndicatorStatus", IndicatorStatusTypeDescription = "Graduation Rate Indicator Status", IndicatorStatusTypeEdFactsCode = "GRADRSTAT" });
            data.Add(new DimIndicatorStatusType() { DimIndicatorStatusTypeId = 6, IndicatorStatusTypeId = 2, IndicatorStatusTypeCode = "AcademicAchievementIndicatorStatus", IndicatorStatusTypeDescription = "Academic Achievement Indicator Status", IndicatorStatusTypeEdFactsCode = "ACHIVSTAT" });
            data.Add(new DimIndicatorStatusType() { DimIndicatorStatusTypeId = 7, IndicatorStatusTypeId = 3, IndicatorStatusTypeCode = "OtherAcademicIndicatorStatus", IndicatorStatusTypeDescription = "Other Academic Indicator Status", IndicatorStatusTypeEdFactsCode = "OTHESTAT" });
            data.Add(new DimIndicatorStatusType() { DimIndicatorStatusTypeId = 8, IndicatorStatusTypeId = 4, IndicatorStatusTypeCode = "SchoolQualityOrStudentSuccessIndicatorStatus", IndicatorStatusTypeDescription = "School Quality or Student Success Indicator Status", IndicatorStatusTypeEdFactsCode = "QUALSTAT" });

            return data;
        }
    }
}
