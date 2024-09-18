using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefFoodServiceEligibilityHelper
    {

        public static List<RefFoodServiceEligibility> GetData()
        {
            /*
            select 'data.Add(new RefFoodServiceEligibility() { 
            RefFoodServiceEligibilityId = ' + convert(varchar(20), RefFoodServiceEligibilityId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefFoodServiceEligibility
            */

            var data = new List<RefFoodServiceEligibility>();

            data.Add(new RefFoodServiceEligibility() { RefFoodServiceEligibilityId = 1, Code = "Free", Description = "Free" });
            data.Add(new RefFoodServiceEligibility() { RefFoodServiceEligibilityId = 2, Code = "FullPrice", Description = "Full price" });
            data.Add(new RefFoodServiceEligibility() { RefFoodServiceEligibilityId = 3, Code = "ReducedPrice", Description = "Reduced price" });
            data.Add(new RefFoodServiceEligibility() { RefFoodServiceEligibilityId = 4, Code = "Other", Description = "Other" });

            return data;
        }
    }
}
