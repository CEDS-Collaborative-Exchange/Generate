using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefInstitutionTelephoneTypepHelper
    {

        public static List<RefInstitutionTelephoneType> GetData()
        {

            var data = new List<RefInstitutionTelephoneType>();

            data.Add(new RefInstitutionTelephoneType()
            {
                RefInstitutionTelephoneTypeId = 1,
                Code = "Main",
                Description = "Main phone number"
            });
            data.Add(new RefInstitutionTelephoneType()
            {
                RefInstitutionTelephoneTypeId = 2,
                Code = "Administrative",
                Description = "Administrative phone number"
            });
            data.Add(new RefInstitutionTelephoneType()
            {
                RefInstitutionTelephoneTypeId = 3,
                Code = "HealthClinic",
                Description = "Health clinic phone number"
            });
            data.Add(new RefInstitutionTelephoneType()
            {
                RefInstitutionTelephoneTypeId = 4,
                Code = "Attendance",
                Description = "Attendance line"
            });
            data.Add(new RefInstitutionTelephoneType()
            {
                RefInstitutionTelephoneTypeId = 5,
                Code = "Fax",
                Description = "Fax number"
            });
            data.Add(new RefInstitutionTelephoneType()
            {
                RefInstitutionTelephoneTypeId = 6,
                Code = "FoodServices",
                Description = "Cafeteria/Food Services"
            });
            data.Add(new RefInstitutionTelephoneType()
            {
                RefInstitutionTelephoneTypeId = 7,
                Code = "Other",
                Description = "Other"
            });

            return data;
        }
    }
}
