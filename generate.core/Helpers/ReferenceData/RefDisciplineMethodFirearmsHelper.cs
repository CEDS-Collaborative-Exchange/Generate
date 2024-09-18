using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefDisciplineMethodFirearmsHelper
    {

        public static List<RefDisciplineMethodFirearms> GetData()
        {
            /*
            select 'data.Add(new RefDisciplineMethodFirearms() { 
            RefDisciplineMethodFirearmsId = ' + convert(varchar(20), RefDisciplineMethodFirearmsId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefDisciplineMethodFirearms
            */

            var data = new List<RefDisciplineMethodFirearms>();

            data.Add(new RefDisciplineMethodFirearms()
            {
                RefDisciplineMethodFirearmsId = 1,
                Code = "EXPNOTMODNOALT",
                Description = "One year expulsion and no educational services"
            });
            data.Add(new RefDisciplineMethodFirearms()
            {
                RefDisciplineMethodFirearmsId = 2,
                Code = "EXPMODALT",
                Description = "Expulsion modified to less than one year with educational services"
            });
            data.Add(new RefDisciplineMethodFirearms()
            {
                RefDisciplineMethodFirearmsId = 3,
                Code = "EXPMODNOALT",
                Description = "Expulsion modified to less than one year without educational services"
            });
            data.Add(new RefDisciplineMethodFirearms()
            {
                RefDisciplineMethodFirearmsId = 4,
                Code = "EXPALT",
                Description = "One year expulsion and educational services"
            });
            data.Add(new RefDisciplineMethodFirearms()
            {
                RefDisciplineMethodFirearmsId = 5,
                Code = "REMOVEOTHER",
                Description = "Other reasons such as death, withdrawal, or incarceration"
            });
            data.Add(new RefDisciplineMethodFirearms()
            {
                RefDisciplineMethodFirearmsId = 6,
                Code = "OTHERDISACTION",
                Description = "Another type of disciplinary action"
            });
            data.Add(new RefDisciplineMethodFirearms()
            {
                RefDisciplineMethodFirearmsId = 7,
                Code = "NOACTION",
                Description = "No disciplinary action taken"
            });
            return data;
        }
    }
}
