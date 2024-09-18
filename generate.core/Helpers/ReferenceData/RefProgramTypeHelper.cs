using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefProgramTypeHelper
    {

        public static List<RefProgramType> GetData()
        {
            /*
            select 'data.Add(new RefProgramType() { 
            RefProgramTypeId = ' + convert(varchar(20), RefProgramTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefProgramType
            */

            var data = new List<RefProgramType>();

            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 1,
                Code = "73056",
                Description = "Adult Basic Education"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 2,
                Code = "73058",
                Description = "Adult English as a Second Language"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 3,
                Code = "73057",
                Description = "Adult Secondary Education"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 4,
                Code = "04961",
                Description = "Alternative Education"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 5,
                Code = "04932",
                Description = "Athletics"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 6,
                Code = "04923",
                Description = "Bilingual education program"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 7,
                Code = "04906",
                Description = "Career and Technical Education"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 8,
                Code = "04931",
                Description = "Cocurricular programs"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 9,
                Code = "04958",
                Description = "College preparatory"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 10,
                Code = "04945",
                Description = "Community service program"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 11,
                Code = "04944",
                Description = "Community/junior college education program"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 12,
                Code = "04922",
                Description = "Compensatory services for disadvantaged students"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 13,
                Code = "73059",
                Description = "Continuing Education"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 14,
                Code = "04956",
                Description = "Counseling services"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 15,
                Code = "14609",
                Description = "Early Head Start"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 16,
                Code = "04928",
                Description = "English as a second language (ESL) program"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 17,
                Code = "04919",
                Description = "Even Start"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 18,
                Code = "04955",
                Description = "Extended day/child care services"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 19,
                Code = "04930",
                Description = "Gifted and talented program"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 20,
                Code = "04918",
                Description = "Head start"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 21,
                Code = "04963",
                Description = "Health Services Program"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 22,
                Code = "04957",
                Description = "Immigrant education"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 23,
                Code = "04921",
                Description = "Indian education"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 24,
                Code = "04959",
                Description = "International Baccalaureate"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 25,
                Code = "04962",
                Description = "Library/Media Services Program"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 26,
                Code = "04960",
                Description = "Magnet/Special Program Emphasis"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 27,
                Code = "04920",
                Description = "Migrant education"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 28,
                Code = "04887",
                Description = "Regular education"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 29,
                Code = "04964",
                Description = "Remedial education"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 30,
                Code = "04967",
                Description = "Section 504 Placement"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 31,
                Code = "04966",
                Description = "Service learning"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 32,
                Code = "04888",
                Description = "Special Education Services"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 33,
                Code = "04954",
                Description = "Student retention/ Dropout Prevention"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 34,
                Code = "04953",
                Description = "Substance abuse education/prevention"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 35,
                Code = "73204",
                Description = "Targeted intervention program"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 36,
                Code = "04968",
                Description = "Teacher professional development / Mentoring"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 37,
                Code = "04917",
                Description = "Technical preparatory"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 38,
                Code = "73090",
                Description = "Work-based Learning Opportunities"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 39,
                Code = "09999",
                Description = "Other"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 40,
                Code = "75000",
                Description = "Foster Care"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 41,
                Code = "76000",
                Description = "Homeless program"
            });
            data.Add(new RefProgramType()
            {
                RefProgramTypeId = 42,
                Code = "77000",
                Description = "Title III program"
            });

            return data;
        }
    }
}
