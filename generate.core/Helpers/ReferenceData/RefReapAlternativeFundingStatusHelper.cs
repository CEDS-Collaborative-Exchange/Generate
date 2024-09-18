using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefReapAlternativeFundingStatusHelper
    {

        public static List<RefReapAlternativeFundingStatus> GetData()
        {
            /*
            select 'data.Add(new RefReapAlternativeFundingStatus() { 
            RefReapAlternativeFundingStatusId = ' + convert(varchar(20), RefReapAlternativeFundingStatusId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefReapAlternativeFundingStatus
            */

            var data = new List<RefReapAlternativeFundingStatus>();

            data.Add(new RefReapAlternativeFundingStatus() { RefReapAlternativeFundingStatusId = 1, Code = "Yes", Description = "Yes" });
            data.Add(new RefReapAlternativeFundingStatus() { RefReapAlternativeFundingStatusId = 2, Code = "No", Description = "No" });
            data.Add(new RefReapAlternativeFundingStatus() { RefReapAlternativeFundingStatusId = 3, Code = "NA", Description = "Not applicable" });

            return data;
        }
    }
}
