using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
        public static class RefDisciplineMethodOfCwdHelper
    {

        public static List<RefDisciplineMethodOfCwd> GetData()
        {
            /*
            select 'data.Add(new RefDisciplineMethodFirearms() { 
            RefDisciplineMethodFirearmsId = ' + convert(varchar(20), RefDisciplineMethodFirearmsId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefDisciplineMethodFirearms
            */

            var data = new List<RefDisciplineMethodOfCwd>();

            data.Add(new RefDisciplineMethodOfCwd()
            {
                RefDisciplineMethodOfCwdId = 1,
                Code = "OutOfSchool",
                Description = "Out of School Suspensions/Expulsions"
            });
            data.Add(new RefDisciplineMethodOfCwd()
            {
                RefDisciplineMethodOfCwdId = 2,
                Code = "InSchool",
                Description = "In School Suspensions"
            });
            return data;
        }
    }
}
