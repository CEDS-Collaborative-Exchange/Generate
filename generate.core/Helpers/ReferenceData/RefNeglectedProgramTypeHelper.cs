using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefNeglectedProgramTypeHelper
    {

        public static List<RefNeglectedProgramType> GetData()
        {
            /*
            select 'data.Add(new RefNeglectedProgramType() { 
            RefNeglectedProgramTypeId = ' + convert(varchar(20), RefNeglectedProgramTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefNeglectedProgramType
            */

            var data = new List<RefNeglectedProgramType>();

            data.Add(new RefNeglectedProgramType() { RefNeglectedProgramTypeId = 1, Code = "CMNTYDAYPRG", Description = "Community Day Programs" });
            data.Add(new RefNeglectedProgramType() { RefNeglectedProgramTypeId = 2, Code = "GRPHOMES", Description = "Group Homes" });
            data.Add(new RefNeglectedProgramType() { RefNeglectedProgramTypeId = 3, Code = "RSDNTLTRTMTHOME", Description = "Residential Treatment Home" });
            data.Add(new RefNeglectedProgramType() { RefNeglectedProgramTypeId = 4, Code = "SHELTERS", Description = "Shelters" });
            data.Add(new RefNeglectedProgramType() { RefNeglectedProgramTypeId = 5, Code = "OTHER", Description = "Other Programs" });

            return data;
        }
    }
}
