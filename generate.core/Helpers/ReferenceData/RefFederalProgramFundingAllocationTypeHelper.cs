using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefFederalProgramFundingAllocationTypeHelper
    {

        public static List<RefFederalProgramFundingAllocationType> GetData()
        {
            /*
            select 'data.Add(new RefFederalProgramFundingAllocationType() { 
            RefFederalProgramFundingAllocationTypeId = ' + convert(varchar(20), RefFederalProgramFundingAllocationTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefFederalProgramFundingAllocationType
            */

            var data = new List<RefFederalProgramFundingAllocationType>();

            data.Add(new RefFederalProgramFundingAllocationType() { RefFederalProgramFundingAllocationTypeId = 1, Code = "RETAINED", Description = "Retained by SEA for program administration, etc." });
            data.Add(new RefFederalProgramFundingAllocationType() { RefFederalProgramFundingAllocationTypeId = 2, Code = "TRANSFER", Description = "Transferred to another state agency" });
            data.Add(new RefFederalProgramFundingAllocationType() { RefFederalProgramFundingAllocationTypeId = 3, Code = "DISTNONLEA", Description = "Distributed to entities other  than LEAs" });
            data.Add(new RefFederalProgramFundingAllocationType() { RefFederalProgramFundingAllocationTypeId = 4, Code = "UNALLOC", Description = "Unallocated or returned funds" });

            return data;
        }
    }
}
