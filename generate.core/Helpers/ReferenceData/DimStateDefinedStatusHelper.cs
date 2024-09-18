using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimStateDefinedStatusHelper
    {
        public static List<DimStateDefinedStatus> GetData()
        {


            var data = new List<DimStateDefinedStatus>();

            //data.Add(new DimStateDefinedStatus()
            //{
            //    DimStateDefinedStatusId = -1,
            //    StateDefinedStatusId = -1,
            //    StateDefinedStatusCode = "MISSING",
            //    StateDefinedStatusDescription = "MISSING"
            //});
            //data.Add(new DimStateDefinedStatus()
            //{
            //    DimStateDefinedStatusId = 1,
            //    StateDefinedStatusId = 1,
            //    StateDefinedStatusCode = "Blue",
            //    StateDefinedStatusDescription = "Blue"
            //});
            //data.Add(new DimStateDefinedStatus()
            //{
            //    DimStateDefinedStatusId = 2,
            //    StateDefinedStatusId = 2,
            //    StateDefinedStatusCode = "Green",
            //    StateDefinedStatusDescription = "Green"
            //});
            //data.Add(new DimStateDefinedStatus()
            //{
            //    DimStateDefinedStatusId = 3,
            //    StateDefinedStatusId = 3,
            //    StateDefinedStatusCode = "Yellow",
            //    StateDefinedStatusDescription = "Yellow"
            //});


            return data;

        }
    }
}
 