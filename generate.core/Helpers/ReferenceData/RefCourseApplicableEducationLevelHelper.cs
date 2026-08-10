using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefCourseApplicableEducationLevelHelper
    {

        public static List<RefCourseApplicableEducationLevel> GetData()
        {
            /*
            select 'data.Add(new RefCourseApplicableEducationLevel() { 
            RefCourseApplicableEducationLevelId = ' + convert(varchar(20), RefCourseApplicableEducationLevelId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefCourseApplicableEducationLevel
            */

            var data = new List<RefCourseApplicableEducationLevel>();

            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 1,
                Code = "IT",
                Description = "Infant/toddler"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 2,
                Code = "PR",
                Description = "Preschool"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 3,
                Code = "PK",
                Description = "Prekindergarten"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 4,
                Code = "TK",
                Description = "Transitional Kindergarten"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 5,
                Code = "KG",
                Description = "Kindergarten"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 6,
                Code = "01",
                Description = "First grade"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 7,
                Code = "02",
                Description = "Second grade"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 8,
                Code = "03",
                Description = "Third grade"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 9,
                Code = "04",
                Description = "Fourth grade"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 10,
                Code = "05",
                Description = "Fifth grade"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 11,
                Code = "06",
                Description = "Sixth grade"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 12,
                Code = "07",
                Description = "Seventh grade"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 13,
                Code = "08",
                Description = "Eighth grade"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 14,
                Code = "09",
                Description = "Ninth grade"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 15,
                Code = "10",
                Description = "Tenth grade"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 16,
                Code = "11",
                Description = "Eleventh grade"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 17,
                Code = "12",
                Description = "Twelfth grade"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 18,
                Code = "13",
                Description = "Grade 13"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 19,
                Code = "AS",
                Description = "Associate's degree"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 20,
                Code = "BA",
                Description = "Bachelor's degree"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 21,
                Code = "PB",
                Description = "Post-baccalaureate certificate"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 22,
                Code = "MD",
                Description = "Master's degree"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 23,
                Code = "PM",
                Description = "Post-master's certificate"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 24,
                Code = "DO",
                Description = "Doctoral degree"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 25,
                Code = "PD",
                Description = "Post-doctoral certificate"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 26,
                Code = "AE",
                Description = "Adult Education"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 27,
                Code = "PT",
                Description = "Professional or technical credential"
            });
            data.Add(new RefCourseApplicableEducationLevel()
            {
                RefCourseApplicableEducationLevelId = 28,
                Code = "OT",
                Description = "Other"
            });

            return data;
        }
    }
}
