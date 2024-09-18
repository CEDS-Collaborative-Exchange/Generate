using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimFirearmsHelper
    {
        public static List<DimFirearms> GetData()
        {


            var data = new List<DimFirearms>();

            /*
            select 'data.Add(new DimFirearms() { 
            DimFirearmsId = ' + convert(varchar(20), DimFirearmsId) + ',
            FirearmsId = ' + convert(varchar(20), FirearmsId) + ',
            FirearmsEdFactsCode = "' + FirearmsEdFactsCode + '"
			});'
            from rds.DimFirearms
            */

            //data.Add(new DimFirearms() { DimFirearmsId = -1, FirearmsId = -1, FirearmsEdFactsCode = "MISSING" });
            //data.Add(new DimFirearms() { DimFirearmsId = 1, FirearmsId = 1, FirearmsEdFactsCode = "HANDGUNS" });
            //data.Add(new DimFirearms() { DimFirearmsId = 2, FirearmsId = 2, FirearmsEdFactsCode = "RIFLESHOTGUN" });
            //data.Add(new DimFirearms() { DimFirearmsId = 3, FirearmsId = 3, FirearmsEdFactsCode = "OTHER" });
            //data.Add(new DimFirearms() { DimFirearmsId = 4, FirearmsId = 4, FirearmsEdFactsCode = "MULTIPLE" });

            return data;

        }
    }
}
 