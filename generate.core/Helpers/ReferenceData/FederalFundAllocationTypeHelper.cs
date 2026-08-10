using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class FederalFundAllocationTypeHelper
    {
        public static List<string> GetData()
        {

            var data = new List<string>();

            data.Add(null);
            data.Add("TRANSFER");
            data.Add("RETAINED");
            data.Add("DISTNONLEA");
            data.Add("UNALLOC");

            return data;

        }
    }
}
 