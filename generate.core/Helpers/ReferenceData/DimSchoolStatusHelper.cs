using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimSchoolStatusHelper
    {
        public static List<DimK12SchoolStatus> GetData()
        {


            var data = new List<DimK12SchoolStatus>();

            //data.Add(new DimK12SchoolStatus() { DimSchoolStatusId = -1 });

            //for (int i = 420; i < 164229; i++)
            //{
            //    data.Add(new DimK12SchoolStatus() { DimSchoolStatusId = i });
            //}

            return data;

        }
    }
}
 