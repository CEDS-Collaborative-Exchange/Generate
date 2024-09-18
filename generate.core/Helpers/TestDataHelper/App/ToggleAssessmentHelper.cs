using generate.core.Models.App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.TestDataHelper.App
{
    public class ToggleAssessmentHelper
    {
        
        public static List<ToggleAssessment> GetData()
        {
            /*

			select 'data.Add(new ToggleAssessment() { 
            ToggleAssessmentId = ' + convert(varchar(20), ToggleAssessmentId) + ',
            AssessmentName = "' + AssessmentName + '",
            AssessmentType = "' + AssessmentType + '",
			AssessmentTypeCode = "' + AssessmentTypeCode + '",
			EOG = "' + EOG + '",
			Grade = "' + Grade + '",
			PerformanceLevels = "' + PerformanceLevels + '",
            ProficientOrAboveLevel = "' + ProficientOrAboveLevel + '",
			Subject = "' + [Subject] + '"
			});'
            from App.ToggleAssessments
            */

            var data = new List<ToggleAssessment>();

            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 1,
                AssessmentName = "t1",
                AssessmentType = "Regular assessments based on grade-level achievement standards with accommodations",
                AssessmentTypeCode = "REGASSWACC",
                EOG = "End of Grade",
                Grade = "03",
                PerformanceLevels = "5",
                ProficientOrAboveLevel = "4",
                Subject = "MATH"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 2,
                AssessmentName = "t2",
                AssessmentType = "Regular assessments based on grade-level achievement standards with accommodations",
                AssessmentTypeCode = "REGASSWACC",
                EOG = "End of Grade",
                Grade = "04",
                PerformanceLevels = "5",
                ProficientOrAboveLevel = "4",
                Subject = "RLA"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 3,
                AssessmentName = "t3",
                AssessmentType = "Regular assessments based on grade-level achievement standards without accommodations",
                AssessmentTypeCode = "REGASSWOACC",
                EOG = "End of Grade",
                Grade = "05",
                PerformanceLevels = "5",
                ProficientOrAboveLevel = "4",
                Subject = "SCIENCE"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 4,
                AssessmentName = "t4",
                AssessmentType = "Regular assessments based on grade-level achievement standards without accommodations",
                AssessmentTypeCode = "REGASSWOACC",
                EOG = "End of Grade",
                Grade = "06",
                PerformanceLevels = "4",
                ProficientOrAboveLevel = "2",
                Subject = "MATH"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 5,
                AssessmentName = "t6",
                AssessmentType = "Regular assessments based on grade-level achievement standards with accommodations",
                AssessmentTypeCode = "REGASSWACC",
                EOG = "End of Grade",
                Grade = "03",
                PerformanceLevels = "4",
                ProficientOrAboveLevel = "3",
                Subject = "SCIENCE"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 6,
                AssessmentName = "t5",
                AssessmentType = "Regular assessments based on grade-level achievement standards with accommodations",
                AssessmentTypeCode = "REGASSWACC",
                EOG = "End of Grade",
                Grade = "03",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "4",
                Subject = "CTE"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 7,
                AssessmentName = "t7",
                AssessmentType = "Alternate assessments based on grade-level achievement standards",
                AssessmentTypeCode = "ALTASSGRADELVL",
                EOG = "End of Grade",
                Grade = "09",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "4",
                Subject = "SCIENCE"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 8,
                AssessmentName = "t7",
                AssessmentType = "Alternate assessments based on alternate achievement standards",
                AssessmentTypeCode = "ALTASSALTACH",
                EOG = "End of Course",
                Grade = "06",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "4",
                Subject = "CTE"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 9,
                AssessmentName = "t7",
                AssessmentType = "Regular assessments based on grade-level achievement standards without accommodations",
                AssessmentTypeCode = "REGASSWOACC",
                EOG = "End of Course",
                Grade = "07",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "4",
                Subject = "MATH"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 10,
                AssessmentName = "t8",
                AssessmentType = "Regular assessments based on grade-level achievement standards with accommodations",
                AssessmentTypeCode = "REGASSWACC",
                EOG = "End of Grade",
                Grade = "04",
                PerformanceLevels = "5",
                ProficientOrAboveLevel = "3",
                Subject = "MATH"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 11,
                AssessmentName = "t9",
                AssessmentType = "Alternate assessments based on modified achievement standards",
                AssessmentTypeCode = "ALTASSMODACH",
                EOG = "End of Grade",
                Grade = "05",
                PerformanceLevels = "5",
                ProficientOrAboveLevel = "3",
                Subject = "MATH"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 12,
                AssessmentName = "t10",
                AssessmentType = "Alternate assessments based on modified achievement standards",
                AssessmentTypeCode = "ALTASSMODACH",
                EOG = "End of Grade",
                Grade = "07",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "4",
                Subject = "MATH"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 13,
                AssessmentName = "RegAssmtwithAcc",
                AssessmentType = "Regular assessments based on grade-level achievement standards without accommodations",
                AssessmentTypeCode = "REGASSWOACC",
                EOG = "End of Grade",
                Grade = "05",
                PerformanceLevels = "3",
                ProficientOrAboveLevel = "3",
                Subject = "MATH"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 20,
                AssessmentName = "dw2",
                AssessmentType = "Regular assessments based on grade-level achievement standards with accommodations",
                AssessmentTypeCode = "REGASSWACC",
                EOG = "End of Grade",
                Grade = "03",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "4",
                Subject = "RLA"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 21,
                AssessmentName = "sd2",
                AssessmentType = "Regular assessments based on grade-level achievement standards with accommodations",
                AssessmentTypeCode = "REGASSWACC",
                EOG = "End of Grade",
                Grade = "05",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "4",
                Subject = "RLA"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 22,
                AssessmentName = "s2",
                AssessmentType = "Regular assessments based on grade-level achievement standards with accommodations",
                AssessmentTypeCode = "REGASSWACC",
                EOG = "End of Course",
                Grade = "06",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "4",
                Subject = "RLA"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 23,
                AssessmentName = "s3",
                AssessmentType = "Regular assessments based on grade-level achievement standards with accommodations",
                AssessmentTypeCode = "REGASSWACC",
                EOG = "Select",
                Grade = "07",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "3",
                Subject = "RLA"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 24,
                AssessmentName = "d3",
                AssessmentType = "Regular assessments based on grade-level achievement standards with accommodations",
                AssessmentTypeCode = "REGASSWACC",
                EOG = "End of Course",
                Grade = "08",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "3",
                Subject = "RLA"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 25,
                AssessmentName = "lk2",
                AssessmentType = "Regular assessments based on grade-level achievement standards without accommodations",
                AssessmentTypeCode = "REGASSWOACC",
                EOG = "End of Grade",
                Grade = "09",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "4",
                Subject = "RLA"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 26,
                AssessmentName = "s4",
                AssessmentType = "Regular assessments based on grade-level achievement standards with accommodations",
                AssessmentTypeCode = "REGASSWACC",
                EOG = "End of Grade",
                Grade = "10",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "4",
                Subject = "RLA"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 27,
                AssessmentName = "w2",
                AssessmentType = "Regular assessments based on grade-level achievement standards with accommodations",
                AssessmentTypeCode = "REGASSWACC",
                EOG = "End of Grade",
                Grade = "11",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "4",
                Subject = "RLA"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 28,
                AssessmentName = "s1",
                AssessmentType = "Regular assessments based on grade-level achievement standards with accommodations",
                AssessmentTypeCode = "REGASSWACC",
                EOG = "End of Grade",
                Grade = "12",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "4",
                Subject = "RLA"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 29,
                AssessmentName = "d2",
                AssessmentType = "Regular assessments based on grade-level achievement standards with accommodations",
                AssessmentTypeCode = "REGASSWACC",
                EOG = "End of Grade",
                Grade = "08",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "3",
                Subject = "MATH"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 30,
                AssessmentName = "d2",
                AssessmentType = "Regular assessments based on grade-level achievement standards without accommodations",
                AssessmentTypeCode = "REGASSWOACC",
                EOG = "End of Grade",
                Grade = "09",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "4",
                Subject = "MATH"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 31,
                AssessmentName = "sa2",
                AssessmentType = "Alternate assessments based on grade-level achievement standards",
                AssessmentTypeCode = "ALTASSGRADELVL",
                EOG = "End of Grade",
                Grade = "10",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "4",
                Subject = "MATH"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 32,
                AssessmentName = "d2",
                AssessmentType = "Regular assessments based on grade-level achievement standards without accommodations",
                AssessmentTypeCode = "REGASSWOACC",
                EOG = "End of Grade",
                Grade = "12",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "4",
                Subject = "MATH"
            });
            data.Add(new ToggleAssessment()
            {
                ToggleAssessmentId = 33,
                AssessmentName = "s11",
                AssessmentType = "Alternate assessments based on modified achievement standards",
                AssessmentTypeCode = "ALTASSMODACH",
                EOG = "End of Grade",
                Grade = "11",
                PerformanceLevels = "6",
                ProficientOrAboveLevel = "3",
                Subject = "MATH"
            });


            return data;

        }
    }
}
