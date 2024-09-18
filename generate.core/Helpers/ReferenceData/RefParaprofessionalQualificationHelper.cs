using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefParaprofessionalQualificationHelper
    {

        public static List<RefParaprofessionalQualification> GetData()
        {
            /*
            select 'data.Add(new RefParaprofessionalQualification() { 
            RefParaprofessionalQualificationId = ' + convert(varchar(20), RefParaprofessionalQualificationId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefParaprofessionalQualification
            */

            var data = new List<RefParaprofessionalQualification>();

            data.Add(new RefParaprofessionalQualification() { RefParaprofessionalQualificationId = 1, Code = "Qualified", Description = "Qualified" });
            data.Add(new RefParaprofessionalQualification() { RefParaprofessionalQualificationId = 2, Code = "NotQualified", Description = "Not Qualified" });

            return data;
        }
    }
}
