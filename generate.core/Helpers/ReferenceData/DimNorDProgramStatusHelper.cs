using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimNorDProgramStatusHelper
    {
        public static List<DimNorDProgramStatus> GetData()
        {


            var data = new List<DimNorDProgramStatus>();

            /*
            select 'data.Add(new DimNorDProgramStatus() { 
            DimNorDProgramStatusId = ' + convert(varchar(20), DimNorDProgramStatusId) + ',
            LongTermStatusId = ' + convert(varchar(20), LongTermStatusId) + ',
            LongTermStatusEdFactsCode = "' + LongTermStatusEdFactsCode + '",
            NeglectedProgramTypeId = ' + convert(varchar(20), NeglectedProgramTypeId) + ',
            NeglectedProgramTypeEdFactsCode = "' + NeglectedProgramTypeEdFactsCode + '",
			AcademicOrVocationalOutcomeId = ' + convert(varchar(20), NeglectedProgramTypeId) + ',
            AcademicOrVocationalOutcomeEdFactsCode = "' + NeglectedProgramTypeEdFactsCode + '",
			AcademicOrVocationalExitOutcomeId = ' + convert(varchar(20), NeglectedProgramTypeId) + ',
            AcademicOrVocationalExitOutcomeEdFactsCode = "' + NeglectedProgramTypeEdFactsCode + '"
			});'
            from rds.DimNorDProgramStatuses

            */


            return data;

        }
    }
}
