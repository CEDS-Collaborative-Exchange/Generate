using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimAssessmentStatusHelper
    {
        public static List<DimAssessmentStatus> GetData()
        {


            var data = new List<DimAssessmentStatus>();

            /*
            select 'data.Add(new DimAssessmentStatus() { 
            DimAssessmentStatusId = ' + convert(varchar(20), DimAssessmentStatusId) + ',
            AssessedFirstTimeId = ' + convert(varchar(20), AssessedFirstTimeId) + ',
            AssessedFirstTimeEdFactsCode = "' + AssessedFirstTimeEdFactsCode + '",
            AssessmentProgressLevelId = ' + convert(varchar(20), AssessmentProgressLevelId) + ',
            AssessmentProgressLevelEdFactsCode = "' + AssessmentProgressLevelEdFactsCode + '"
			});'
            from rds.DimAssessmentStatuses
            */

            data.Add(new DimAssessmentStatus() { DimAssessmentStatusId = -1, AssessedFirstTimeId = -1, AssessedFirstTimeEdFactsCode = "MISSING", AssessmentProgressLevelId = -1, AssessmentProgressLevelEdFactsCode = "MISSING" });
            data.Add(new DimAssessmentStatus() { DimAssessmentStatusId = 1, AssessedFirstTimeId = 1, AssessedFirstTimeEdFactsCode = "FIRSTASSESS", AssessmentProgressLevelId = -1, AssessmentProgressLevelEdFactsCode = "MISSING" });
            data.Add(new DimAssessmentStatus() { DimAssessmentStatusId = 2, AssessedFirstTimeId = -1, AssessedFirstTimeEdFactsCode = "MISSING", AssessmentProgressLevelId = 1, AssessmentProgressLevelEdFactsCode = "NEGGRADE" });
            data.Add(new DimAssessmentStatus() { DimAssessmentStatusId = 3, AssessedFirstTimeId = -1, AssessedFirstTimeEdFactsCode = "MISSING", AssessmentProgressLevelId = 2, AssessmentProgressLevelEdFactsCode = "NOCHANGE" });
            data.Add(new DimAssessmentStatus() { DimAssessmentStatusId = 4, AssessedFirstTimeId = -1, AssessedFirstTimeEdFactsCode = "MISSING", AssessmentProgressLevelId = 3, AssessmentProgressLevelEdFactsCode = "UPONEGRADE" });
            data.Add(new DimAssessmentStatus() { DimAssessmentStatusId = 5, AssessedFirstTimeId = -1, AssessedFirstTimeEdFactsCode = "MISSING", AssessmentProgressLevelId = 4, AssessmentProgressLevelEdFactsCode = "UPGTONE" });
            data.Add(new DimAssessmentStatus() { DimAssessmentStatusId = 6, AssessedFirstTimeId = 1, AssessedFirstTimeEdFactsCode = "FIRSTASSESS", AssessmentProgressLevelId = 1, AssessmentProgressLevelEdFactsCode = "NEGGRADE" });
            data.Add(new DimAssessmentStatus() { DimAssessmentStatusId = 7, AssessedFirstTimeId = 1, AssessedFirstTimeEdFactsCode = "FIRSTASSESS", AssessmentProgressLevelId = 2, AssessmentProgressLevelEdFactsCode = "NOCHANGE" });
            data.Add(new DimAssessmentStatus() { DimAssessmentStatusId = 8, AssessedFirstTimeId = 1, AssessedFirstTimeEdFactsCode = "FIRSTASSESS", AssessmentProgressLevelId = 3, AssessmentProgressLevelEdFactsCode = "UPONEGRADE" });
            data.Add(new DimAssessmentStatus() { DimAssessmentStatusId = 9, AssessedFirstTimeId = 1, AssessedFirstTimeEdFactsCode = "FIRSTASSESS", AssessmentProgressLevelId = 4, AssessmentProgressLevelEdFactsCode = "UPGTONE" });

            return data;

        }
    }
}
 