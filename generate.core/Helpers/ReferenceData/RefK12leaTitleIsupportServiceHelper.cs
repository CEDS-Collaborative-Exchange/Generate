using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefK12leaTitleIsupportServiceHelper
    {

        public static List<RefK12leaTitleIsupportService> GetData()
        {
            /*
            select 'data.Add(new RefK12leaTitleIsupportService() { 
            RefK12leatitleIsupportServiceId = ' + convert(varchar(20), RefK12leaTitleIsupportServiceId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefK12leaTitleIsupportService
            */

            var data = new List<RefK12leaTitleIsupportService>();

            data.Add(new RefK12leaTitleIsupportService() { RefK12leatitleIsupportServiceId = 1, Code = "HealthDentalEyeCare", Description = "Health, Dental and Eye Care" });
            data.Add(new RefK12leaTitleIsupportService() { RefK12leatitleIsupportServiceId = 2, Code = "GuidanceAdvocacy", Description = "Supporting Guidance/Advocacy" });
            data.Add(new RefK12leaTitleIsupportService() { RefK12leatitleIsupportServiceId = 3, Code = "Other", Description = "Other" });

            return data;
        }
    }
}
