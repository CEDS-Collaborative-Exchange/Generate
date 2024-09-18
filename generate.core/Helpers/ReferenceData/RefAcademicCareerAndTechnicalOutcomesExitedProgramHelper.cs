using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace generate.core.Helpers.ReferenceData
{
    public static class RefAcademicCareerAndTechnicalOutcomesExitedProgramHelper
    {
        public static List<RefAcademicCareerAndTechnicalOutcomesExitedProgram> GetData()
        {
            /*
             select 'data.Add(new RefAcademicCareerAndTechnicalOutcomesExitedProgram() { 
            RefAcademicCareerAndTechnicalOutcomesExitedProgramId = ' + convert(varchar(20), RefAcademicCareerAndTechnicalOutcomesExitedProgramId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefAcademicCareerAndTechnicalOutcomesExitedProgram
            */

            var data = new List<RefAcademicCareerAndTechnicalOutcomesExitedProgram>();

            data.Add(new RefAcademicCareerAndTechnicalOutcomesExitedProgram()
            {
                RefAcademicCareerAndTechnicalOutcomesExitedProgramId = 1,
                Code = "ENROLLSCH",
                Description = "Enrolled in local district school"
            });
            data.Add(new RefAcademicCareerAndTechnicalOutcomesExitedProgram()
            {
                RefAcademicCareerAndTechnicalOutcomesExitedProgramId = 2,
                Code = "EARNCRE",
                Description = "Earned high school course credits"
            });
            data.Add(new RefAcademicCareerAndTechnicalOutcomesExitedProgram()
            {
                RefAcademicCareerAndTechnicalOutcomesExitedProgramId = 3,
                Code = "ENROLLGED",
                Description = "Enrolled in a GED program"
            });
            data.Add(new RefAcademicCareerAndTechnicalOutcomesExitedProgram()
            {
                RefAcademicCareerAndTechnicalOutcomesExitedProgramId = 4,
                Code = "EARNGED",
                Description = "Earned a GED"
            });
            data.Add(new RefAcademicCareerAndTechnicalOutcomesExitedProgram()
            {
                RefAcademicCareerAndTechnicalOutcomesExitedProgramId = 5,
                Code = "EARNDIPL",
                Description = "Obtained high school diploma"
            });
            data.Add(new RefAcademicCareerAndTechnicalOutcomesExitedProgram()
            {
                RefAcademicCareerAndTechnicalOutcomesExitedProgramId = 6,
                Code = "POSTSEC",
                Description = "Were accepted and/or enrolled into post-secondary education"
            });
            data.Add(new RefAcademicCareerAndTechnicalOutcomesExitedProgram()
            {
                RefAcademicCareerAndTechnicalOutcomesExitedProgramId = 7,
                Code = "ENROLLTRAIN",
                Description = "Enrolled in job training courses/programs"
            });
            data.Add(new RefAcademicCareerAndTechnicalOutcomesExitedProgram()
            {
                RefAcademicCareerAndTechnicalOutcomesExitedProgramId = 8,
                Code = "OBTAINEMP",
                Description = "Obtained employment"
            });

            return data;
        }
    }
}
