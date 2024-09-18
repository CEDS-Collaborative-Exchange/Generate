using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimCohortStatusHelper
    {
        public static List<DimCohortStatus> GetData()
        {


            var data = new List<DimCohortStatus>();

            /*
            select 'data.Add(new DimCohortStatus() { 
            DimCohortStatusId = ' + convert(varchar(20), DimCohortStatusId) + ',
            CohortStatusId = ' + convert(varchar(20), CohortStatusId) + ',
            CohortStatusEdFactsCode = "' + CohortStatusEdFactsCode + '"
			});'
            from rds.DimCohortStatuses
            */

            data.Add(new DimCohortStatus() { DimCohortStatusId = -1, CohortStatusId = -1, CohortStatusEdFactsCode = "MISSING" });
            data.Add(new DimCohortStatus() { DimCohortStatusId = 1, CohortStatusId = 1, CohortStatusEdFactsCode = "COHYES" });
            data.Add(new DimCohortStatus() { DimCohortStatusId = 2, CohortStatusId = 2, CohortStatusEdFactsCode = "COHNO" });
            data.Add(new DimCohortStatus() { DimCohortStatusId = 3, CohortStatusId = 3, CohortStatusEdFactsCode = "COHALTDPL" });
            data.Add(new DimCohortStatus() { DimCohortStatusId = 4, CohortStatusId = 4, CohortStatusEdFactsCode = "COHREM" });

            return data;

        }
    }
}
 