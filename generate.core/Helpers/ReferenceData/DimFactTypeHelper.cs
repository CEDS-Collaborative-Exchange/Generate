using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimFactTypeHelper
    {
        public static List<DimFactType> GetData()
        {


            var data = new List<DimFactType>();

            /*
            select 'data.Add(new DimFactType() { 
            DimFactTypeId = ' + convert(varchar(20), DimFactTypeId) + ',
            FactTypeCode = "' + FactTypeCode + '",
            FactTypeDescription = "' + FactTypeDescription + '"
            });'
            from rds.DimFactTypes
            */

            data.Add(new DimFactType() { DimFactTypeId = -1, FactTypeCode = "NA", FactTypeDescription = "Not Applicable" });
            data.Add(new DimFactType() { DimFactTypeId = 1, FactTypeCode = "datapopulation", FactTypeDescription = "Data Population Summary" });
            data.Add(new DimFactType() { DimFactTypeId = 2, FactTypeCode = "submission", FactTypeDescription = "Submission Reports" });
            data.Add(new DimFactType() { DimFactTypeId = 3, FactTypeCode = "childcount", FactTypeDescription = "Child Count" });
            data.Add(new DimFactType() { DimFactTypeId = 4, FactTypeCode = "specedexit", FactTypeDescription = "Exit from Special Education" });
            data.Add(new DimFactType() { DimFactTypeId = 5, FactTypeCode = "cte", FactTypeDescription = "Career and Technical Education" });

            return data;

        }
    }
}
 