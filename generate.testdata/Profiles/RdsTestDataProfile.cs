using generate.testdata.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.testdata.Profiles
{
    public class RdsTestDataProfile : IRdsTestDataProfile
    {
        #region Global
        public List<string> FederalProgramCodes { get; set; }

        #endregion

        #region Numbers
        public int NumberOfParallelTasks { get; set; }

        public int BatchSize { get; set; }

        public int QuantityOfSeas { get; set; }
        public int OldestStartingYear { get; set; }
        public int MinimumAgeOfStudent { get; set; }
        public int MaximumAgeOfStudent { get; set; }

        public int MinimumAverageStudentsPerLea { get; set; }
        public int MaximumAverageStudentsPerLea { get; set; }
        public int MinimumSchoolsPerLeaRural { get; set; }
        public int MaximumSchoolsPerLeaRural { get; set; }
        public int MinimumSchoolsPerLeaUrban { get; set; }
        public int MaximumSchoolsPerLeaUrban { get; set; }


        public int MinimumStudentTeacherRatio { get; set; }
        public int MaximumStudentsTeacherRatio { get; set; }


        #endregion

        #region Demographics
        public List<DataDistribution<string>> SexDistribution { get; set; }
        public List<DataDistribution<bool>> HasCohortDistribution { get; set; }
        #endregion

        #region Leas
        public List<DataDistribution<string>> LeaGeographicDistribution { get; set; }
        public List<DataDistribution<bool>> IsSupervisoryUnionDistribution { get; set; }
        public List<DataDistribution<bool>> IsReportedFederallyDistribution { get; set; }
        public List<DataDistribution<bool>> LeaHasNcesIdDistribution { get; set; }

        #endregion

        #region Schools

        public List<DataDistribution<bool>> SchoolHasNcesIdDistribution { get; set; }

        #endregion

        #region Students 
        public List<DataDistribution<bool>> HasStudentCutOverStartDateDistribution { get; set; }
        public List<DataDistribution<bool>> IsCharterSchoolDistribution { get; set; }
        public List<DataDistribution<int>> DisciplineDistribution { get; set; }

        #endregion

        public RdsTestDataProfile()
        {
            // Set default values

            #region Global

            this.FederalProgramCodes = new List<string>
            {
                "84.010","84.002","84.011", "84.011","84.013", "84.027", "84.048", "84.173"
            };

            #endregion

            #region Numbers

            this.NumberOfParallelTasks = 4;
            this.BatchSize = 5000;

            this.QuantityOfSeas = 1;

            this.OldestStartingYear = 2015;

            this.MinimumAgeOfStudent = 0;
            this.MaximumAgeOfStudent = 25;

            this.MinimumAverageStudentsPerLea = 200;
            this.MaximumAverageStudentsPerLea = 300;

            this.MinimumSchoolsPerLeaRural = 2;
            this.MaximumSchoolsPerLeaRural = 6;

            this.MinimumSchoolsPerLeaUrban = 20;
            this.MaximumSchoolsPerLeaUrban = 75;

            this.MinimumStudentTeacherRatio = 15;
            this.MaximumStudentsTeacherRatio = 25;

            #endregion

            #region Demographics

            this.SexDistribution = new List<DataDistribution<string>>();
            this.SexDistribution.Add(new DataDistribution<string>() { Option = "Female", ExpectedDistribution = 40 });
            this.SexDistribution.Add(new DataDistribution<string>() { Option = "Male", ExpectedDistribution = 80 });
            this.SexDistribution.Add(new DataDistribution<string>() { Option = "NotSelected", ExpectedDistribution = 90 });
            this.SexDistribution.Add(new DataDistribution<string>() { Option = "Unknown", ExpectedDistribution = 100 });

            this.HasCohortDistribution = new List<DataDistribution<bool>>();
            this.HasCohortDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 30 });
            this.HasCohortDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            #endregion

            #region Leas

            this.LeaGeographicDistribution = new List<DataDistribution<string>>();
            this.LeaGeographicDistribution.Add(new DataDistribution<string>() { Option = "Rural", ExpectedDistribution = 85 });
            this.LeaGeographicDistribution.Add(new DataDistribution<string>() { Option = "Urban", ExpectedDistribution = 100 });

            this.IsSupervisoryUnionDistribution = new List<DataDistribution<bool>>();
            this.IsSupervisoryUnionDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 70 });
            this.IsSupervisoryUnionDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 100 });

            this.IsReportedFederallyDistribution = new List<DataDistribution<bool>>();
            this.IsReportedFederallyDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 90 });
            this.IsReportedFederallyDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.LeaHasNcesIdDistribution = new List<DataDistribution<bool>>();
            this.LeaHasNcesIdDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 90 });
            this.LeaHasNcesIdDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            #endregion

            #region Schools

            this.SchoolHasNcesIdDistribution = new List<DataDistribution<bool>>();
            this.SchoolHasNcesIdDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 90 });
            this.SchoolHasNcesIdDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            #endregion

            #region Students

            this.HasStudentCutOverStartDateDistribution = new List<DataDistribution<bool>>();
            this.HasStudentCutOverStartDateDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 30 });
            this.HasStudentCutOverStartDateDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });

            this.IsCharterSchoolDistribution = new List<DataDistribution<bool>>();
            this.IsCharterSchoolDistribution.Add(new DataDistribution<bool>() { Option = true, ExpectedDistribution = 40 });
            this.IsCharterSchoolDistribution.Add(new DataDistribution<bool>() { Option = false, ExpectedDistribution = 100 });


            this.DisciplineDistribution = new List<DataDistribution<int>>();
            this.DisciplineDistribution.Add(new DataDistribution<int>() { Option = 1, ExpectedDistribution = 80 });
            this.DisciplineDistribution.Add(new DataDistribution<int>() { Option = 2, ExpectedDistribution = 95 });
            this.DisciplineDistribution.Add(new DataDistribution<int>() { Option = 3, ExpectedDistribution = 100 });


            #endregion

        }

    }
}
