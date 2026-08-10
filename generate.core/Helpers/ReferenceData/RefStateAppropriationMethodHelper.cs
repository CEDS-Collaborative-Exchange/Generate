using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefStateAppropriationMethodHelper
    {

        public static List<RefStateAppropriationMethod> GetData()
        {
            /*
          select 'data.Add(new RefStateAppropriationMethod() { 
           RefStateId = ' + convert(varchar(20), RefStateAppropriationMethodId) + ',
           Code = "' + Code + '",
           Description = "' + [Description] + '"
           });'
           from dbo.RefStateAppropriationMethod
           */

            var data = new List<RefStateAppropriationMethod>();

            data.Add(new RefStateAppropriationMethod()
            {
                RefStateAppropriationMethodId = 1,
                Code = "STEAPRDRCT",
                Description = "Direct from state"
            });
            data.Add(new RefStateAppropriationMethod()
            {
                RefStateAppropriationMethodId = 2,
                Code = "STEAPRTHRULEA",
                Description = "Through local school district"
            });
            data.Add(new RefStateAppropriationMethod()
            {
                RefStateAppropriationMethodId = 3,
                Code = "STEAPRALLOCLEA",
                Description = "Allocation by local school district"
            });

            return data;
        }
    }

}