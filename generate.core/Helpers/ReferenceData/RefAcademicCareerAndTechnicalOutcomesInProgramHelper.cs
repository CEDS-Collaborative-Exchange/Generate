using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefAcademicCareerAndTechnicalOutcomesInProgramHelper
    {
        public static List<RefAcademicCareerAndTechnicalOutcomesInProgram> GetData()
        {
            /*
            select 'data.Add(new RefAcademicCareerAndTechnicalOutcomesInProgram() { 
            RefAcademicCareerAndTechnicalOutcomesInProgramId = ' + convert(varchar(20), RefAcademicCareerAndTechnicalOutcomesInProgramId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefAcademicCareerAndTechnicalOutcomesInProgram
            */

            var data = new List<RefAcademicCareerAndTechnicalOutcomesInProgram>();

            data.Add(new RefAcademicCareerAndTechnicalOutcomesInProgram()
            {
                RefAcademicCareerAndTechnicalOutcomesInProgramId = 1,
                Code = "EARNCRE",
                Description = "Earned high school course credits"
            });
            data.Add(new RefAcademicCareerAndTechnicalOutcomesInProgram()
            {
                RefAcademicCareerAndTechnicalOutcomesInProgramId = 2,
                Code = "ENROLLGED",
                Description = "Enrolled in a GED program"
            });
            data.Add(new RefAcademicCareerAndTechnicalOutcomesInProgram()
            {
                RefAcademicCareerAndTechnicalOutcomesInProgramId = 3,
                Code = "EARNGED",
                Description = "Earned a GED"
            });
            data.Add(new RefAcademicCareerAndTechnicalOutcomesInProgram()
            {
                RefAcademicCareerAndTechnicalOutcomesInProgramId = 4,
                Code = "EARNDIPL",
                Description = "Obtained high school diploma"
            });
            data.Add(new RefAcademicCareerAndTechnicalOutcomesInProgram()
            {
                RefAcademicCareerAndTechnicalOutcomesInProgramId = 5,
                Code = "POSTSEC",
                Description = "Were accepted and/or enrolled into post-secondary education"
            });
            data.Add(new RefAcademicCareerAndTechnicalOutcomesInProgram()
            {
                RefAcademicCareerAndTechnicalOutcomesInProgramId = 6,
                Code = "ENROLLTRAIN",
                Description = "Enrolled in job training courses/programs"
            });
            data.Add(new RefAcademicCareerAndTechnicalOutcomesInProgram()
            {
                RefAcademicCareerAndTechnicalOutcomesInProgramId = 7,
                Code = "OBTAINEMP",
                Description = "Obtained employment"
            });

            return data;
        }
    }
}
