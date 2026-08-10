using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefIdeadisciplineMethodFirearmHelper
    {

        public static List<RefIdeadisciplineMethodFirearm> GetData()
        {
            /*
            select 'data.Add(new RefIdeadisciplineMethodFirearm() { 
            RefIdeadisciplineMethodFirearmId = ' + convert(varchar(20), RefIdeadisciplineMethodFirearmId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefIdeadisciplineMethodFirearm
            */

            var data = new List<RefIdeadisciplineMethodFirearm>();

            data.Add(new RefIdeadisciplineMethodFirearm() { RefIdeadisciplineMethodFirearmId = 1, Code = "EXPMOD", Description = "Expulsion modified to less than one year with educational services under IDEA" });
            data.Add(new RefIdeadisciplineMethodFirearm() { RefIdeadisciplineMethodFirearmId = 2, Code = "EXPNOTMOD", Description = "One year expulsion with educational services under IDEA" });
            data.Add(new RefIdeadisciplineMethodFirearm() { RefIdeadisciplineMethodFirearmId = 3, Code = "REMOVEOTHER", Description = "Other reasons such as death, withdrawal, or incarceration" });
            data.Add(new RefIdeadisciplineMethodFirearm() { RefIdeadisciplineMethodFirearmId = 4, Code = "OTHERDISACTION", Description = "Another type of disciplinary action" });
            data.Add(new RefIdeadisciplineMethodFirearm() { RefIdeadisciplineMethodFirearmId = 5, Code = "NOACTION", Description = "No disciplinary action taken" });

            return data;
        }
    }
}
