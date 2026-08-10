using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefScoreMetricTypeHelper
    {

        public static List<RefScoreMetricType> GetData()
        {
            /*
            select 'data.Add(new RefScoreMetricType() { 
            RefScoreMetricTypeId = ' + convert(varchar(20), RefScoreMetricTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefScoreMetricType
            */

            var data = new List<RefScoreMetricType>();

            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 1, Code = "00512", Description = "Achievement/proficiency level" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 2, Code = "00494", Description = "ACT score" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 3, Code = "00490", Description = "Age score" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 4, Code = "00491", Description = "C-scaled scores" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 5, Code = "00492", Description = "College Board examination scores" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 6, Code = "00493", Description = "Grade equivalent or grade-level indicator" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 7, Code = "03473", Description = "Graduation score" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 8, Code = "03474", Description = "Growth/value-added/indexing" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 9, Code = "03475", Description = "International Baccalaureate score" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 10, Code = "00144", Description = "Letter grade/mark" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 11, Code = "00513", Description = "Mastery level" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 12, Code = "00497", Description = "Normal curve equivalent" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 13, Code = "00498", Description = "Normalized standard score" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 14, Code = "00499", Description = "Number score" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 15, Code = "00500", Description = "Pass-fail" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 16, Code = "03476", Description = "Percentile" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 17, Code = "00502", Description = "Percentile rank" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 18, Code = "00503", Description = "Proficiency level" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 19, Code = "03477", Description = "Promotion score" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 20, Code = "00504", Description = "Ranking" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 21, Code = "00505", Description = "Ratio IQ's" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 22, Code = "03478", Description = "Raw score" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 23, Code = "03479", Description = "Scale score" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 24, Code = "00506", Description = "Standard age score" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 25, Code = "00508", Description = "Stanine score" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 26, Code = "00509", Description = "Sten score" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 27, Code = "00510", Description = "T-score" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 28, Code = "03480", Description = "Workplace readiness score" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 29, Code = "00511", Description = "Z-score" });
            data.Add(new RefScoreMetricType() { RefScoreMetricTypeId = 30, Code = "09999", Description = "Other" });

            return data;
        }
    }
}
