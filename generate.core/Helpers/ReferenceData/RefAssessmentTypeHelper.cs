using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefAssessmentTypeHelper
    {

        public static List<RefAssessmentType> GetData()
        {
            /*
            select 'data.Add(new RefAssessmentTypeHelper() { 
            RefAssessmentTypeId = ' + convert(varchar(20), RefAssessmentTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefAssessmentType
            */

            var data = new List<RefAssessmentType>();

            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 1, Code = "AchievementTest", Description = "Achievement test" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 2, Code = "AdvancedPlacementTest", Description = "Advanced placement test" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 3, Code = "AlternateAssessmentELL", Description = "Alternate assessment/ELL" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 4, Code = "AlternateAssessmentGradeLevelStandards", Description = "Alternate assessment/grade-level standards" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 5, Code = "AlternativeAssessmentModifiedStandards", Description = "Alternative assessment/modified standards" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 6, Code = "AptitudeTest", Description = "Aptitude Test" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 7, Code = "Benchmark", Description = "Benchmark" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 8, Code = "CognitiveAndPerceptualSkills", Description = "Cognitive and perceptual skills test" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 9, Code = "ComputerAdaptiveTest", Description = "Computer Adaptive Test" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 10, Code = "DevelopmentalObservation", Description = "Developmental observation" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 11, Code = "Diagnostic", Description = "Diagnostic" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 12, Code = "DirectAssessment", Description = "Direct Assessment" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 13, Code = "Formative", Description = "Formative" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 14, Code = "GrowthMeasure", Description = "Growth Measure" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 15, Code = "Interim", Description = "Interim" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 16, Code = "KindergartenReadiness", Description = "Kindergarten Readiness" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 17, Code = "LanguageProficiency", Description = "Language proficiency test" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 18, Code = "MentalAbility", Description = "Mental ability (intelligence) test" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 19, Code = "Observation", Description = "Observation" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 20, Code = "ParentReport", Description = "Parent Report" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 21, Code = "PerformanceAssessment", Description = "Performance assessment" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 22, Code = "PortfolioAssessment", Description = "Portfolio assessment" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 23, Code = "PrekindergartenReadiness", Description = "Prekindergarten Readiness" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 24, Code = "ReadingReadiness", Description = "Reading readiness test" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 25, Code = "Screening", Description = "Screening" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 26, Code = "TeacherReport", Description = "Teacher Report" });
            data.Add(new RefAssessmentType() { RefAssessmentTypeId = 27, Code = "Other", Description = "Other" });

            return data;
        }
    }
}
