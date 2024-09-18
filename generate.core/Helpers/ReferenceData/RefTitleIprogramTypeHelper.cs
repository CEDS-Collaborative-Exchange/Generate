using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefTitleIprogramTypeHelper
    {

        public static List<RefTitleIprogramType> GetData()
        {
            /*
            select 'data.Add(new RefTitleIprogramType() { 
            RefTitleIprogramTypeId = ' + convert(varchar(20), RefTitleIprogramTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefTitleIprogramType
            */

            var data = new List<RefTitleIprogramType>();

            data.Add(new RefTitleIprogramType() { RefTitleIprogramTypeId = 1, Code = "TargetedAssistanceProgram", Description = "Public Targeted Assistance Program" });
            data.Add(new RefTitleIprogramType() { RefTitleIprogramTypeId = 2, Code = "SchoolwideProgram", Description = "Public Schoolwide Program" });
            data.Add(new RefTitleIprogramType() { RefTitleIprogramTypeId = 3, Code = "PrivateSchoolStudents", Description = "Private School Students Participating" });
            data.Add(new RefTitleIprogramType() { RefTitleIprogramTypeId = 4, Code = "LocalNeglectedProgram", Description = "Local Neglected Program" });

            return data;
        }
    }
}
