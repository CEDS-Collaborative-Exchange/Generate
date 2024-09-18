using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefNSLPStatusHelper
    {

        public static List<RefNSLPStatus> GetData()
        {
            /*
            select 'data.Add(new RefNSLPStatus() { 
            RefNSLPStatusId = ' + convert(varchar(20), RefNSLPStatusId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefNSLPStatus
            */

            var data = new List<RefNSLPStatus>();

            data.Add(new RefNSLPStatus() { RefNSLPStatusId = 1, Code = "NSLPWOPRO", Description = "Participating without using any Provision or the Community Eligibility Option" });
            data.Add(new RefNSLPStatus() { RefNSLPStatusId = 2, Code = "NSLPPRO1", Description = "Provision 1" });
            data.Add(new RefNSLPStatus() { RefNSLPStatusId = 3, Code = "NSLPPRO2", Description = "Provision 2" });
            data.Add(new RefNSLPStatus() { RefNSLPStatusId = 4, Code = "NSLPPRO3", Description = "Provision 3" });
            data.Add(new RefNSLPStatus() { RefNSLPStatusId = 5, Code = "NSLPCEO", Description = "Community Eligibility Option" });
            data.Add(new RefNSLPStatus() { RefNSLPStatusId = 6, Code = "NSLPNO", Description = "Not Participating" });

            return data;
        }
    }
}
