using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimProgramStatusHelper
    {
        public static List<DimProgramStatus> GetData()
        {


            var data = new List<DimProgramStatus>();

            /*
            select 'data.Add(new DimProgramStatus() { 
            DimProgramStatusId = ' + convert(varchar(20), DimProgramStatusId) + ',
            FoodServiceEligibilityId = ' + convert(varchar(20), FoodServiceEligibilityId) + ',
            FoodServiceEligibilityEdFactsCode = "' + FoodServiceEligibilityEdFactsCode + '",
            FosterCareProgramId = ' + convert(varchar(20), FosterCareProgramId) + ',
            FosterCareProgramEdFactsCode = "' + FosterCareProgramEdFactsCode + '",
            ImmigrantTitleIIIProgramId = ' + convert(varchar(20), ImmigrantTitleIIIProgramId) + ',
            ImmigrantTitleIIIProgramEdFactsCode = "' + ImmigrantTitleIIIProgramEdFactsCode + '",
            Section504ProgramId = ' + convert(varchar(20), Section504ProgramId) + ',
            Section504ProgramEdFactsCode = "' + Section504ProgramEdFactsCode + '",
            TitleiiiProgramParticipationId = ' + convert(varchar(20), TitleiiiProgramParticipationId) + ',
            TitleiiiProgramParticipationEdFactsCode = "' + TitleiiiProgramParticipationEdFactsCode + '"
            });'
            from rds.DimProgramStatuses
            */

            return data;

        }
    }
}
