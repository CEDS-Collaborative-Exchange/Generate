using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefReconstitutedStatusHelper
    {

        public static List<RefReconstitutedStatus> GetData()
        {
            /*
            select 'data.Add(new RefReconstitutedStatus() { 
            RefReconstitutedStatusId = ' + convert(varchar(20), RefReconstitutedStatusid) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefReconstitutedStatus
            */

            var data = new List<RefReconstitutedStatus>();

            data.Add(new RefReconstitutedStatus() { RefReconstitutedStatusId = 1, Code = "Yes", Description = "Reconstituted school" });
            data.Add(new RefReconstitutedStatus() { RefReconstitutedStatusId = 2, Code = "No", Description = "Not a reconstituted school" });

            return data;
        }
    }
}
