using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefClassroomPositionTypeHelper
    {

        public static List<RefClassroomPositionType> GetData()
        {
            /*
            select 'data.Add(new RefClassroomPositionType() { 
            RefClassroomPositionTypeId = ' + convert(varchar(20), RefClassroomPositionTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefClassroomPositionType
            */

            var data = new List<RefClassroomPositionType>();

            data.Add(new RefClassroomPositionType()
            {
                RefClassroomPositionTypeId = 1,
                Code = "03187",
                Description = "Administrative staff"
            });
            data.Add(new RefClassroomPositionType()
            {
                RefClassroomPositionTypeId = 2,
                Code = "73071",
                Description = "Co-teacher"
            });
            data.Add(new RefClassroomPositionType()
            {
                RefClassroomPositionTypeId = 3,
                Code = "04725",
                Description = "Counselor"
            });
            data.Add(new RefClassroomPositionType()
            {
                RefClassroomPositionTypeId = 4,
                Code = "73073",
                Description = "Course Proctor"
            });
            data.Add(new RefClassroomPositionType()
            {
                RefClassroomPositionTypeId = 5,
                Code = "05973",
                Description = "Instructor of record"
            });
            data.Add(new RefClassroomPositionType()
            {
                RefClassroomPositionTypeId = 6,
                Code = "01234",
                Description = "Intern"
            });
            data.Add(new RefClassroomPositionType()
            {
                RefClassroomPositionTypeId = 7,
                Code = "73072",
                Description = "Lead Team Teacher"
            });
            data.Add(new RefClassroomPositionType()
            {
                RefClassroomPositionTypeId = 8,
                Code = "00069",
                Description = "Non-instructional staff"
            });
            data.Add(new RefClassroomPositionType()
            {
                RefClassroomPositionTypeId = 9,
                Code = "09999",
                Description = "Other"
            });
            data.Add(new RefClassroomPositionType()
            {
                RefClassroomPositionTypeId = 10,
                Code = "00059",
                Description = "Paraprofessionals/teacher aides"
            });
            data.Add(new RefClassroomPositionType()
            {
                RefClassroomPositionTypeId = 11,
                Code = "05971",
                Description = "Primary instructor"
            });
            data.Add(new RefClassroomPositionType()
            {
                RefClassroomPositionTypeId = 12,
                Code = "04735",
                Description = "Resource teacher"
            });
            data.Add(new RefClassroomPositionType()
            {
                RefClassroomPositionTypeId = 13,
                Code = "05972",
                Description = "Secondary instructor"
            });
            data.Add(new RefClassroomPositionType()
            {
                RefClassroomPositionTypeId = 14,
                Code = "73074",
                Description = "Special Education Consultant"
            });
            data.Add(new RefClassroomPositionType()
            {
                RefClassroomPositionTypeId = 15,
                Code = "00080",
                Description = "Student teachers"
            });
            data.Add(new RefClassroomPositionType()
            {
                RefClassroomPositionTypeId = 16,
                Code = "01382",
                Description = "Volunteer/no contract"
            });

            return data;
        }
    }
}
