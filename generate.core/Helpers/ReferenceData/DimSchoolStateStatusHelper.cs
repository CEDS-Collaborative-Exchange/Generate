using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.RDS;

namespace generate.core.Helpers.ReferenceData
{
    public class DimSchoolStateStatusHelper
    {
        public static List<DimK12SchoolStateStatus> GetData()
        {


            var data = new List<DimK12SchoolStateStatus>();

            //data.Add(new DimK12SchoolStateStatus()
            //{
            //    DimSchoolStateStatusId = -1,
            //    SchoolStateStatusId = -1,
            //    SchoolStateStatusCode = "MISSING",
            //    SchoolStateStatusDescription = "MISSING",
            //    SchoolStateStatusEdFactsCode = "MISSING"
            //});
            //data.Add(new DimK12SchoolStateStatus()
            //{
            //    DimSchoolStateStatusId = 1,
            //    SchoolStateStatusId = 1,
            //    SchoolStateStatusCode = "Blue",
            //    SchoolStateStatusDescription = "Blue",
            //    SchoolStateStatusEdFactsCode = "Blue"
            //});
            //data.Add(new DimK12SchoolStateStatus()
            //{
            //    DimSchoolStateStatusId = 2,
            //    SchoolStateStatusId = 2,
            //    SchoolStateStatusCode = "Green",
            //    SchoolStateStatusDescription = "Green",
            //    SchoolStateStatusEdFactsCode = "Green"
            //});
            //data.Add(new DimK12SchoolStateStatus()
            //{
            //    DimSchoolStateStatusId = 3,
            //    SchoolStateStatusId = 3,
            //    SchoolStateStatusCode = "Yellow",
            //    SchoolStateStatusDescription = "Yellow",
            //    SchoolStateStatusEdFactsCode = "Yellow"
            //});


            return data;

        }
    }
}
 