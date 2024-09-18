using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefTitleIprogramStaffCategoryHelper
    {

        public static List<RefTitleIprogramStaffCategory> GetData()
        {
            /*
            select 'data.Add(new RefTitleIprogramStaffCategory() { 
            RefTitleIprogramStaffCategoryId = ' + convert(varchar(20), RefTitleIprogramStaffCategoryId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefTitleIprogramStaffCategory
            */

            var data = new List<RefTitleIprogramStaffCategory>();

            data.Add(new RefTitleIprogramStaffCategory() { RefTitleIprogramStaffCategoryId = 1, Code = "TitleITeacher", Description = "Title I Teachers" });
            data.Add(new RefTitleIprogramStaffCategory() { RefTitleIprogramStaffCategoryId = 2, Code = "TitleIParaprofessional", Description = "Title I Paraprofessionals " });
            data.Add(new RefTitleIprogramStaffCategory() { RefTitleIprogramStaffCategoryId = 3, Code = "TitleISupportStaff", Description = "Title I Clerical Support Staff" });
            data.Add(new RefTitleIprogramStaffCategory() { RefTitleIprogramStaffCategoryId = 4, Code = "TitleIAdministrator", Description = "Title I Administrators (non-clerical)" });
            data.Add(new RefTitleIprogramStaffCategory() { RefTitleIprogramStaffCategoryId = 5, Code = "TitleIOtherParaprofessional", Description = "Title I Other Paraprofessionals" });

            return data;
        }
    }
}
