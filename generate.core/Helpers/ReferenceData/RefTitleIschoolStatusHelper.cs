using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefTitleIschoolStatusHelper
    {

        public static List<RefTitleIschoolStatus> GetData()
        {
            /*
            select 'data.Add(new RefTitleIschoolStatus() { 
            RefTitle1SchoolStatusId = ' + convert(varchar(20), RefTitle1SchoolStatusId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefTitleIschoolStatus
            */

            var data = new List<RefTitleIschoolStatus>();

            data.Add(new RefTitleIschoolStatus() { RefTitle1SchoolStatusId = 1, Code = "TGELGBNOPROG", Description = "Title I Targeted Assistance Eligible School- No Program" });
            data.Add(new RefTitleIschoolStatus() { RefTitle1SchoolStatusId = 2, Code = "TGELGBTGPROG", Description = "Title I Targeted Assistance School" });
            data.Add(new RefTitleIschoolStatus() { RefTitle1SchoolStatusId = 3, Code = "SWELIGTGPROG", Description = "Title I, Schoolwide eligible-Title I Targeted Assistance Program" });
            data.Add(new RefTitleIschoolStatus() { RefTitle1SchoolStatusId = 4, Code = "SWELIGNOPROG", Description = "Title I Schoolwide Eligible School - No Program" });
            data.Add(new RefTitleIschoolStatus() { RefTitle1SchoolStatusId = 5, Code = "SWELIGSWPROG", Description = "Title I Schoolwide School" });
            data.Add(new RefTitleIschoolStatus() { RefTitle1SchoolStatusId = 6, Code = "NOTTITLE1ELIG", Description = "Not a Title I School" });

            return data;
        }
    }
}
