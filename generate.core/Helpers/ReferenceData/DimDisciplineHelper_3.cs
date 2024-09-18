using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimDisciplineHelper_3
    {
        // First Half of Data
        public static List<DimDiscipline> GetData()
        {


            var data = new List<DimDiscipline>();

            /*
            select 'data.Add(new DimDiscipline() { 
            DimDisciplineId = ' + convert(varchar(20), DimDisciplineId) + ',
            DisciplineActionEdFactsCode = "' + DisciplineActionEdFactsCode + '",
            DisciplineELStatusEdFactsCode = "' + DisciplineELStatusEdFactsCode + '",
            DisciplineMethodEdFactsCode = "' + DisciplineMethodEdFactsCode + '",
            EducationalServicesEdFactsCode = "' + EducationalServicesEdFactsCode + '",
            RemovalReasonEdFactsCode = "' + RemovalReasonEdFactsCode + '",
            RemovalTypeEdFactsCode = "' + RemovalTypeEdFactsCode + '"
			});'
            from rds.DimDisciplines
			where DimDisciplineId >= 10000
            */

            return data;

        }
    }
}
