using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefSpecialEducationStaffCategoryHelper
    {

        public static List<RefSpecialEducationStaffCategory> GetData()
        {
            /*
            select 'data.Add(new RefSpecialEducationStaffCategory() { 
            RefSpecialEducationStaffCategoryId = ' + convert(varchar(20), RefSpecialEducationStaffCategoryId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefSpecialEducationStaffCategory
            */

            var data = new List<RefSpecialEducationStaffCategory>();

            data.Add(new RefSpecialEducationStaffCategory() { RefSpecialEducationStaffCategoryId = 1, Code = "PSYCH", Description = "Psychologists" });
            data.Add(new RefSpecialEducationStaffCategory() { RefSpecialEducationStaffCategoryId = 2, Code = "SOCIALWORK", Description = "Social Workers" });
            data.Add(new RefSpecialEducationStaffCategory() { RefSpecialEducationStaffCategoryId = 3, Code = "OCCTHERAP", Description = "Occupational Therapists" });
            data.Add(new RefSpecialEducationStaffCategory() { RefSpecialEducationStaffCategoryId = 4, Code = "AUDIO", Description = "Audiologists" });
            data.Add(new RefSpecialEducationStaffCategory() { RefSpecialEducationStaffCategoryId = 5, Code = "PEANDREC", Description = "Physical Education Teachers and Recreation and Therapeutic Recreation Specialists" });
            data.Add(new RefSpecialEducationStaffCategory() { RefSpecialEducationStaffCategoryId = 6, Code = "PHYSTHERAP", Description = "Physical Therapists" });
            data.Add(new RefSpecialEducationStaffCategory() { RefSpecialEducationStaffCategoryId = 7, Code = "SPEECHPATH", Description = "Speech-Language Pathologists" });
            data.Add(new RefSpecialEducationStaffCategory() { RefSpecialEducationStaffCategoryId = 8, Code = "INTERPRET", Description = "Interpreters" });
            data.Add(new RefSpecialEducationStaffCategory() { RefSpecialEducationStaffCategoryId = 9, Code = "COUNSELOR", Description = "Counselors and Rehabilitation Counselors" });
            data.Add(new RefSpecialEducationStaffCategory() { RefSpecialEducationStaffCategoryId = 10, Code = "ORIENTMOBIL", Description = "Orientation and Mobility Specialists" });
            data.Add(new RefSpecialEducationStaffCategory() { RefSpecialEducationStaffCategoryId = 11, Code = "MEDNURSE", Description = "Medical/Nursing Service Staff" });

            return data;
        }
    }
}
