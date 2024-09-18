using generate.core.Models.RDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class DimGradeLevelHelper
    {

        public static List<DimGradeLevel> GetData()
        {
            /*
            select 'data.Add(new DimGradeLevel() { 
            DimGradeLevelId = ' + convert(varchar(20), DimGradeLevelId) + ',
            GradeLevelEdFactsCode = "' + GradeLevelEdFactsCode + '",
            GradeLevelDescription = "' + GradeLevelDescription + '"
            });'
            from Rds.DimGradeLevels
            */

            var data = new List<DimGradeLevel>();

            data.Add(new DimGradeLevel() { DimGradeLevelId = -1, GradeLevelEdFactsCode = "MISSING", GradeLevelDescription = "Missing" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 1, GradeLevelEdFactsCode = "PK", GradeLevelDescription = "Pre-Kindergarten" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 2, GradeLevelEdFactsCode = "KG", GradeLevelDescription = "Kindergarten" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 3, GradeLevelEdFactsCode = "01", GradeLevelDescription = "Grade 1" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 4, GradeLevelEdFactsCode = "02", GradeLevelDescription = "Grade 2" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 5, GradeLevelEdFactsCode = "03", GradeLevelDescription = "Grade 3" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 6, GradeLevelEdFactsCode = "04", GradeLevelDescription = "Grade 4" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 7, GradeLevelEdFactsCode = "05", GradeLevelDescription = "Grade 5" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 8, GradeLevelEdFactsCode = "06", GradeLevelDescription = "Grade 6" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 9, GradeLevelEdFactsCode = "07", GradeLevelDescription = "Grade 7" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 10, GradeLevelEdFactsCode = "08", GradeLevelDescription = "Grade 8" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 11, GradeLevelEdFactsCode = "09", GradeLevelDescription = "Grade 9" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 12, GradeLevelEdFactsCode = "10", GradeLevelDescription = "Grade 10" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 13, GradeLevelEdFactsCode = "11", GradeLevelDescription = "Grade 11" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 14, GradeLevelEdFactsCode = "12", GradeLevelDescription = "Grade 12" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 15, GradeLevelEdFactsCode = "HS", GradeLevelDescription = "Highschool" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 16, GradeLevelEdFactsCode = "UG", GradeLevelDescription = "Ungraded" });
            data.Add(new DimGradeLevel() { DimGradeLevelId = 17, GradeLevelEdFactsCode = "AE", GradeLevelDescription = "Adult Basic Education" });

            return data;
        }
    }
}
