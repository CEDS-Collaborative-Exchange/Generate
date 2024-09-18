using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.testdata.Interfaces
{
    public interface IRdsTestDataProfile
    {

        #region Global
        List<string> FederalProgramCodes { get; set; }
        #endregion

        #region Numbers

        int NumberOfParallelTasks { get; set; }
        int BatchSize { get; set; }

        int QuantityOfSeas { get; set; }

        int OldestStartingYear { get; set; }

        int MinimumAgeOfStudent { get; set; }
        int MaximumAgeOfStudent { get; set; }


        int MinimumAverageStudentsPerLea { get; set; }
        int MaximumAverageStudentsPerLea { get; set; }


        int MinimumSchoolsPerLeaRural { get; set; }
        int MaximumSchoolsPerLeaRural { get; set; }
        int MinimumSchoolsPerLeaUrban { get; set; }
        int MaximumSchoolsPerLeaUrban { get; set; }

        int MinimumStudentTeacherRatio { get; set; }
        int MaximumStudentsTeacherRatio { get; set; }


        #endregion


        #region Demographics
        List<DataDistribution<string>> SexDistribution { get; set; }
        List<DataDistribution<bool>> HasCohortDistribution { get; set; }

        #endregion

        #region Leas
        List<DataDistribution<string>> LeaGeographicDistribution { get; set; }
        List<DataDistribution<bool>> IsSupervisoryUnionDistribution { get; set; }
        List<DataDistribution<bool>> IsReportedFederallyDistribution { get; set; }
        List<DataDistribution<bool>> LeaHasNcesIdDistribution { get; set; }

        #endregion

        #region Schools

        List<DataDistribution<bool>> SchoolHasNcesIdDistribution { get; set; }
        List<DataDistribution<bool>> IsCharterSchoolDistribution { get; set; }

        #endregion

        #region Students
        List<DataDistribution<bool>> HasStudentCutOverStartDateDistribution { get; set; }

        List<DataDistribution<int>> DisciplineDistribution { get; set; }
        #endregion
    }
}
