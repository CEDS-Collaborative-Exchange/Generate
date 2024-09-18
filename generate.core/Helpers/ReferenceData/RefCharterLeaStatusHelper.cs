using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefCharterLeaStatusHelper
    {

        public static List<RefCharterLeaStatus> GetData()
        {
            /*
             select 'data.Add(new RefCharterLeaStatus() { 
            RefCharterLeaStatusId = ' + convert(varchar(20), RefCharterLeaStatusId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefCharterLeaStatus
            */

            var data = new List<RefCharterLeaStatus>();

            data.Add(new RefCharterLeaStatus()
            {
                RefCharterLeaStatusId = 1,
                Code = "NA",
                Description = "Not applicable"
            });
            data.Add(new RefCharterLeaStatus()
            {
                RefCharterLeaStatusId = 2,
                Code = "NOTCHR",
                Description = "Not a charter district"
            });
            data.Add(new RefCharterLeaStatus()
            {
                RefCharterLeaStatusId = 3,
                Code = "CHRTNOTLEA",
                Description = "Not LEA for federal programs"
            });
            data.Add(new RefCharterLeaStatus()
            {
                RefCharterLeaStatusId = 4,
                Code = "CHRTIDEA",
                Description = "LEA for IDEA"
            });
            data.Add(new RefCharterLeaStatus()
            {
                RefCharterLeaStatusId = 5,
                Code = "CHRTESEA",
                Description = "LEA for ESEA and Perkins"
            });
            data.Add(new RefCharterLeaStatus()
            {
                RefCharterLeaStatusId = 6,
                Code = "CHRTIDEAESEA",
                Description = "LEA for federal programs"
            });

            return data;
        }
    }
}
