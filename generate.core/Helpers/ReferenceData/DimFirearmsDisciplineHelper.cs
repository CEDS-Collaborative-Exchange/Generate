using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimFirearmsDisciplineHelper
    {
        public static List<DimFirearmDiscipline> GetData()
        {


            var data = new List<DimFirearmDiscipline>();

            /*
            select 'data.Add(new DimFirearmsDiscipline() { 
            DimFirearmsDisciplineId = ' + convert(varchar(20), DimFirearmsDisciplineId) + ',
            FirearmsDisciplineId = ' + convert(varchar(20), FirearmsDisciplineId) + ',
            FirearmsDisciplineEdFactsCode = "' + FirearmsDisciplineEdFactsCode + '",
            IDEAFirearmsDisciplineId = ' + convert(varchar(20), IDEAFirearmsDisciplineId) + ',
            IDEAFirearmsDisciplineEdFactsCode = "' + IDEAFirearmsDisciplineEdFactsCode + '"
			});'
            from rds.DimFirearmsDiscipline
            */

            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = -1, FirearmsDisciplineId = -1, FirearmsDisciplineEdFactsCode = "MISSING", IDEAFirearmsDisciplineId = -1, IDEAFirearmsDisciplineEdFactsCode = "MISSING" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 1, FirearmsDisciplineId = -1, FirearmsDisciplineEdFactsCode = "MISSING", IDEAFirearmsDisciplineId = 1, IDEAFirearmsDisciplineEdFactsCode = "EXPMOD" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 2, FirearmsDisciplineId = -1, FirearmsDisciplineEdFactsCode = "MISSING", IDEAFirearmsDisciplineId = 2, IDEAFirearmsDisciplineEdFactsCode = "EXPNOTMOD" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 3, FirearmsDisciplineId = -1, FirearmsDisciplineEdFactsCode = "MISSING", IDEAFirearmsDisciplineId = 3, IDEAFirearmsDisciplineEdFactsCode = "REMOVEOTHER" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 4, FirearmsDisciplineId = -1, FirearmsDisciplineEdFactsCode = "MISSING", IDEAFirearmsDisciplineId = 4, IDEAFirearmsDisciplineEdFactsCode = "OTHERDISACTION" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 5, FirearmsDisciplineId = -1, FirearmsDisciplineEdFactsCode = "MISSING", IDEAFirearmsDisciplineId = 5, IDEAFirearmsDisciplineEdFactsCode = "NOACTION" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 6, FirearmsDisciplineId = 1, FirearmsDisciplineEdFactsCode = "EXPNOTMODNOALT", IDEAFirearmsDisciplineId = -1, IDEAFirearmsDisciplineEdFactsCode = "MISSING" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 7, FirearmsDisciplineId = 1, FirearmsDisciplineEdFactsCode = "EXPNOTMODNOALT", IDEAFirearmsDisciplineId = 1, IDEAFirearmsDisciplineEdFactsCode = "EXPMOD" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 8, FirearmsDisciplineId = 1, FirearmsDisciplineEdFactsCode = "EXPNOTMODNOALT", IDEAFirearmsDisciplineId = 2, IDEAFirearmsDisciplineEdFactsCode = "EXPNOTMOD" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 9, FirearmsDisciplineId = 1, FirearmsDisciplineEdFactsCode = "EXPNOTMODNOALT", IDEAFirearmsDisciplineId = 3, IDEAFirearmsDisciplineEdFactsCode = "REMOVEOTHER" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 10, FirearmsDisciplineId = 1, FirearmsDisciplineEdFactsCode = "EXPNOTMODNOALT", IDEAFirearmsDisciplineId = 4, IDEAFirearmsDisciplineEdFactsCode = "OTHERDISACTION" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 11, FirearmsDisciplineId = 1, FirearmsDisciplineEdFactsCode = "EXPNOTMODNOALT", IDEAFirearmsDisciplineId = 5, IDEAFirearmsDisciplineEdFactsCode = "NOACTION" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 12, FirearmsDisciplineId = 2, FirearmsDisciplineEdFactsCode = "EXPALT", IDEAFirearmsDisciplineId = -1, IDEAFirearmsDisciplineEdFactsCode = "MISSING" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 13, FirearmsDisciplineId = 2, FirearmsDisciplineEdFactsCode = "EXPALT", IDEAFirearmsDisciplineId = 1, IDEAFirearmsDisciplineEdFactsCode = "EXPMOD" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 14, FirearmsDisciplineId = 2, FirearmsDisciplineEdFactsCode = "EXPALT", IDEAFirearmsDisciplineId = 2, IDEAFirearmsDisciplineEdFactsCode = "EXPNOTMOD" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 15, FirearmsDisciplineId = 2, FirearmsDisciplineEdFactsCode = "EXPALT", IDEAFirearmsDisciplineId = 3, IDEAFirearmsDisciplineEdFactsCode = "REMOVEOTHER" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 16, FirearmsDisciplineId = 2, FirearmsDisciplineEdFactsCode = "EXPALT", IDEAFirearmsDisciplineId = 4, IDEAFirearmsDisciplineEdFactsCode = "OTHERDISACTION" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 17, FirearmsDisciplineId = 2, FirearmsDisciplineEdFactsCode = "EXPALT", IDEAFirearmsDisciplineId = 5, IDEAFirearmsDisciplineEdFactsCode = "NOACTION" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 18, FirearmsDisciplineId = 3, FirearmsDisciplineEdFactsCode = "EXPMODNOALT", IDEAFirearmsDisciplineId = -1, IDEAFirearmsDisciplineEdFactsCode = "MISSING" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 19, FirearmsDisciplineId = 3, FirearmsDisciplineEdFactsCode = "EXPMODNOALT", IDEAFirearmsDisciplineId = 1, IDEAFirearmsDisciplineEdFactsCode = "EXPMOD" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 20, FirearmsDisciplineId = 3, FirearmsDisciplineEdFactsCode = "EXPMODNOALT", IDEAFirearmsDisciplineId = 2, IDEAFirearmsDisciplineEdFactsCode = "EXPNOTMOD" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 21, FirearmsDisciplineId = 3, FirearmsDisciplineEdFactsCode = "EXPMODNOALT", IDEAFirearmsDisciplineId = 3, IDEAFirearmsDisciplineEdFactsCode = "REMOVEOTHER" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 22, FirearmsDisciplineId = 3, FirearmsDisciplineEdFactsCode = "EXPMODNOALT", IDEAFirearmsDisciplineId = 4, IDEAFirearmsDisciplineEdFactsCode = "OTHERDISACTION" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 23, FirearmsDisciplineId = 3, FirearmsDisciplineEdFactsCode = "EXPMODNOALT", IDEAFirearmsDisciplineId = 5, IDEAFirearmsDisciplineEdFactsCode = "NOACTION" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 24, FirearmsDisciplineId = 4, FirearmsDisciplineEdFactsCode = "EXPMODALT", IDEAFirearmsDisciplineId = -1, IDEAFirearmsDisciplineEdFactsCode = "MISSING" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 25, FirearmsDisciplineId = 4, FirearmsDisciplineEdFactsCode = "EXPMODALT", IDEAFirearmsDisciplineId = 1, IDEAFirearmsDisciplineEdFactsCode = "EXPMOD" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 26, FirearmsDisciplineId = 4, FirearmsDisciplineEdFactsCode = "EXPMODALT", IDEAFirearmsDisciplineId = 2, IDEAFirearmsDisciplineEdFactsCode = "EXPNOTMOD" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 27, FirearmsDisciplineId = 4, FirearmsDisciplineEdFactsCode = "EXPMODALT", IDEAFirearmsDisciplineId = 3, IDEAFirearmsDisciplineEdFactsCode = "REMOVEOTHER" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 28, FirearmsDisciplineId = 4, FirearmsDisciplineEdFactsCode = "EXPMODALT", IDEAFirearmsDisciplineId = 4, IDEAFirearmsDisciplineEdFactsCode = "OTHERDISACTION" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 29, FirearmsDisciplineId = 4, FirearmsDisciplineEdFactsCode = "EXPMODALT", IDEAFirearmsDisciplineId = 5, IDEAFirearmsDisciplineEdFactsCode = "NOACTION" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 30, FirearmsDisciplineId = 5, FirearmsDisciplineEdFactsCode = "REMOVEOTHER", IDEAFirearmsDisciplineId = -1, IDEAFirearmsDisciplineEdFactsCode = "MISSING" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 31, FirearmsDisciplineId = 5, FirearmsDisciplineEdFactsCode = "REMOVEOTHER", IDEAFirearmsDisciplineId = 1, IDEAFirearmsDisciplineEdFactsCode = "EXPMOD" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 32, FirearmsDisciplineId = 5, FirearmsDisciplineEdFactsCode = "REMOVEOTHER", IDEAFirearmsDisciplineId = 2, IDEAFirearmsDisciplineEdFactsCode = "EXPNOTMOD" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 33, FirearmsDisciplineId = 5, FirearmsDisciplineEdFactsCode = "REMOVEOTHER", IDEAFirearmsDisciplineId = 3, IDEAFirearmsDisciplineEdFactsCode = "REMOVEOTHER" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 34, FirearmsDisciplineId = 5, FirearmsDisciplineEdFactsCode = "REMOVEOTHER", IDEAFirearmsDisciplineId = 4, IDEAFirearmsDisciplineEdFactsCode = "OTHERDISACTION" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 35, FirearmsDisciplineId = 5, FirearmsDisciplineEdFactsCode = "REMOVEOTHER", IDEAFirearmsDisciplineId = 5, IDEAFirearmsDisciplineEdFactsCode = "NOACTION" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 36, FirearmsDisciplineId = 6, FirearmsDisciplineEdFactsCode = "OTHERDISACTION", IDEAFirearmsDisciplineId = -1, IDEAFirearmsDisciplineEdFactsCode = "MISSING" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 37, FirearmsDisciplineId = 6, FirearmsDisciplineEdFactsCode = "OTHERDISACTION", IDEAFirearmsDisciplineId = 1, IDEAFirearmsDisciplineEdFactsCode = "EXPMOD" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 38, FirearmsDisciplineId = 6, FirearmsDisciplineEdFactsCode = "OTHERDISACTION", IDEAFirearmsDisciplineId = 2, IDEAFirearmsDisciplineEdFactsCode = "EXPNOTMOD" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 39, FirearmsDisciplineId = 6, FirearmsDisciplineEdFactsCode = "OTHERDISACTION", IDEAFirearmsDisciplineId = 3, IDEAFirearmsDisciplineEdFactsCode = "REMOVEOTHER" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 40, FirearmsDisciplineId = 6, FirearmsDisciplineEdFactsCode = "OTHERDISACTION", IDEAFirearmsDisciplineId = 4, IDEAFirearmsDisciplineEdFactsCode = "OTHERDISACTION" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 41, FirearmsDisciplineId = 6, FirearmsDisciplineEdFactsCode = "OTHERDISACTION", IDEAFirearmsDisciplineId = 5, IDEAFirearmsDisciplineEdFactsCode = "NOACTION" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 42, FirearmsDisciplineId = 7, FirearmsDisciplineEdFactsCode = "NOACTION", IDEAFirearmsDisciplineId = -1, IDEAFirearmsDisciplineEdFactsCode = "MISSING" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 43, FirearmsDisciplineId = 7, FirearmsDisciplineEdFactsCode = "NOACTION", IDEAFirearmsDisciplineId = 1, IDEAFirearmsDisciplineEdFactsCode = "EXPMOD" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 44, FirearmsDisciplineId = 7, FirearmsDisciplineEdFactsCode = "NOACTION", IDEAFirearmsDisciplineId = 2, IDEAFirearmsDisciplineEdFactsCode = "EXPNOTMOD" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 45, FirearmsDisciplineId = 7, FirearmsDisciplineEdFactsCode = "NOACTION", IDEAFirearmsDisciplineId = 3, IDEAFirearmsDisciplineEdFactsCode = "REMOVEOTHER" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 46, FirearmsDisciplineId = 7, FirearmsDisciplineEdFactsCode = "NOACTION", IDEAFirearmsDisciplineId = 4, IDEAFirearmsDisciplineEdFactsCode = "OTHERDISACTION" });
            //data.Add(new DimFirearmDiscipline() { DimFirearmsDisciplineId = 47, FirearmsDisciplineId = 7, FirearmsDisciplineEdFactsCode = "NOACTION", IDEAFirearmsDisciplineId = 5, IDEAFirearmsDisciplineEdFactsCode = "NOACTION" });

            return data;

        }
    }
}
 