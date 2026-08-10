using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimIdeaStatusHelper
    {
        public static List<DimIdeaStatus> GetData()
        {


            var data = new List<DimIdeaStatus>();

            /*
            select 'data.Add(new DimIdeaStatus() { 
            DimIdeaStatusId = ' + convert(varchar(20), DimIdeaStatusId) + ',
            BasisOfExitId = ' + convert(varchar(20), BasisOfExitId) + ',
            BasisOfExitEdFactsCode = "' + BasisOfExitEdFactsCode + '",
            DisabilityId = ' + convert(varchar(20), DisabilityId) + ',
            DisabilityEdFactsCode = "' + DisabilityEdFactsCode + '",
            EducEnvId = ' + convert(varchar(20), EducEnvId) + ',
            EducEnvEdFactsCode = "' + EducEnvEdFactsCode + '",
			IDEAIndicatorId = ' + convert(varchar(20), IDEAIndicatorId) + ',
            IDEAIndicatorEdFactsCode = "' + IDEAIndicatorEdFactsCode + '"
			});'
            from rds.DimIdeaStatuses
            */

            return data;

        }
    }
}
