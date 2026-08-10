using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefEmergencyOrProvisionalCredentialStatusHelper
    {

        public static List<RefEmergencyOrProvisionalCredentialStatus> GetData()
        {
            /*
            select 'data.Add(new RefEmergencyOrProvisionalCredentialStatus() { 
            RefEmergencyOrProvisionalCredentialStatusId = ' + convert(varchar(20), RefEmergencyOrProvisionalCredentialStatusId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefEmergencyOrProvisionalCredentialStatus
            */

            var data = new List<RefEmergencyOrProvisionalCredentialStatus>();

            data.Add(new RefEmergencyOrProvisionalCredentialStatus() { RefEmergencyOrProvisionalCredentialStatusId = 1, Code = "TCHWEMRPRVCRD", Description = "Emergency or Provisional" });
            data.Add(new RefEmergencyOrProvisionalCredentialStatus() { RefEmergencyOrProvisionalCredentialStatusId = 2, Code = "TCHWOEMRPRVCRD", Description = "No Emergency or Provisional" });

            return data;
        }
    }
}
