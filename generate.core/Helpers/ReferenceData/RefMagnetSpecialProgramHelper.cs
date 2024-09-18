using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefMagnetSpecialProgramHelper
    {

        public static List<RefMagnetSpecialProgram> GetData()
        {
            /*
            select 'data.Add(new RefMagnetSpecialProgram() { 
            RefMagnetSpecialProgramId = ' + convert(varchar(20), RefMagnetSpecialProgramId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefMagnetSpecialProgram
            */

            var data = new List<RefMagnetSpecialProgram>();

            data.Add(new RefMagnetSpecialProgram() { RefMagnetSpecialProgramId = 1, Code = "All", Description = "All students participate" });
            data.Add(new RefMagnetSpecialProgram() { RefMagnetSpecialProgramId = 2, Code = "None", Description = "No students participate" });
            data.Add(new RefMagnetSpecialProgram() { RefMagnetSpecialProgramId = 3, Code = "Some", Description = "Some, but not all, students participate" });

            return data;
        }
    }
}
