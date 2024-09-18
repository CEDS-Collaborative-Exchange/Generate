using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefAeCertificationTypeHelper
    {

        public static List<RefAeCertificationType> GetData()
        {
            /*
            select 'data.Add(new RefAeCertificationType() { 
            RefAeCertificationTypeId = ' + convert(varchar(20), RefAeCertificationTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefAeCertificationType
            */

            var data = new List<RefAeCertificationType>();


            data.Add(new RefAeCertificationType()
            {
                RefAeCertificationTypeId = 1,
                Code = "AdultEducationCertification",
                Description = "Adult Education Certification"
            });
            data.Add(new RefAeCertificationType()
            {
                RefAeCertificationTypeId = 2,
                Code = "K-12Certification",
                Description = "K-12 Certification"
            });
            data.Add(new RefAeCertificationType()
            {
                RefAeCertificationTypeId = 3,
                Code = "SpecialEducationCertification",
                Description = "Special Education Certification"
            });
            data.Add(new RefAeCertificationType()
            {
                RefAeCertificationTypeId = 4,
                Code = "TESOLCertification",
                Description = "Teachers of English to Speakers of Other Languages (TESOL) Certification"
            });
            data.Add(new RefAeCertificationType()
            {
                RefAeCertificationTypeId = 5,
                Code = "None",
                Description = "None"
            });

            return data;
        }
    }
}
