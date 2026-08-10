using generate.core.Models.RDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class DimIndicatorStatusHelper
    {

        public static List<DimIndicatorStatus> GetData()
        {
            /*
            select 'data.Add(new DimIndicatorStatus() { 
            DimIndicatorStatusId = ' + convert(varchar(20), DimIndicatorStatusId) + ',
            IndicatorStatusId = ' + convert(varchar(20), IndicatorStatusId) + ',
            IndicatorStatusCode = "' + IndicatorStatusCode + '",
            IndicatorStatusDescription = "' + IndicatorStatusDescription + '",
            IndicatorStatusEdFactsCode = "' + IndicatorStatusEdFactsCode + '"
            });'
            from Rds.DimIndicatorStatuses
            */

            var data = new List<DimIndicatorStatus>();

            data.Add(new DimIndicatorStatus() { DimIndicatorStatusId = -1, IndicatorStatusId = -1, IndicatorStatusCode = "MISSING", IndicatorStatusDescription = "The status of the indicator for a specific school is not available at the time the file is prepared.", IndicatorStatusEdFactsCode = "MISSING" });
            data.Add(new DimIndicatorStatus() { DimIndicatorStatusId = 1, IndicatorStatusId = 1, IndicatorStatusCode = "STTDEF", IndicatorStatusDescription = "A status defined by the state.  The state defined status is provided in a separate field in the file.", IndicatorStatusEdFactsCode = "STTDEF" });
            data.Add(new DimIndicatorStatus() { DimIndicatorStatusId = 2, IndicatorStatusId = 2, IndicatorStatusCode = "TOOFEW", IndicatorStatusDescription = "The number of students in the school or for a student subgroup was less than the minimum group size necessary required to reliably calculate the indicator.", IndicatorStatusEdFactsCode = "TOOFEW" });
            data.Add(new DimIndicatorStatus() { DimIndicatorStatusId = 3, IndicatorStatusId = 3, IndicatorStatusCode = "NOSTUDENTS", IndicatorStatusDescription = "There are no students in a student subgroup.  Alternatively, the row can be left out of the file.  If no students are in the school, the school should not be included in this file.", IndicatorStatusEdFactsCode = "NOSTUDENTS" });

            return data;
        }
    }
}
