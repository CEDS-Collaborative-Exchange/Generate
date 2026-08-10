using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace generate.core.Helpers.ReferenceData
{
    public static class RefVirtualSchoolStatusHelper
    {

        public static List<RefVirtualSchoolStatus> GetData()
        {
            /*
            select 'data.Add(new RefVirtualSchoolStatus() { 
            RefVirtualSchoolStatusId = ' + convert(varchar(20), RefVirtualSchoolStatusId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefVirtualSchoolStatus
            */

            var data = new List<RefVirtualSchoolStatus>();

            data.Add(new RefVirtualSchoolStatus()
            {
                RefVirtualSchoolStatusId = 1,
                Code = "FaceVirtual",
                Description = "Face Virtual"
            });
            data.Add(new RefVirtualSchoolStatus()
            {
                RefVirtualSchoolStatusId = 2,
                Code = "FullVirtual",
                Description = "Full Virtual"
            });
            data.Add(new RefVirtualSchoolStatus()
            {
                RefVirtualSchoolStatusId = 3,
                Code = "NotVirtual",
                Description = "Not Virtual"
            });
            data.Add(new RefVirtualSchoolStatus()
            {
                RefVirtualSchoolStatusId = 4,
                Code = "SupplementalVirtual",
                Description = "Supplemental Virtual"
            });

            return data;
        }
    }
}
