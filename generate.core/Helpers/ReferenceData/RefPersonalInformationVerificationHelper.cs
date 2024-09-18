using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefPersonalInformationVerificationHelper
    {

        public static List<RefPersonalInformationVerification> GetData()
        {
            /*
            select 'data.Add(new RefPersonalInformationVerification() { 
            RefPersonalInformationVerificationId = ' + convert(varchar(20), RefPersonalInformationVerificationId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefPersonalInformationVerification
            */

            var data = new List<RefPersonalInformationVerification>();

            data.Add(new RefPersonalInformationVerification() { RefPersonalInformationVerificationId = 1, Code = "01003", Description = "Baptismal or church certificate" });
            data.Add(new RefPersonalInformationVerification() { RefPersonalInformationVerificationId = 2, Code = "01004", Description = "Birth certificate" });
            data.Add(new RefPersonalInformationVerification() { RefPersonalInformationVerificationId = 3, Code = "01012", Description = "Driver's license" });
            data.Add(new RefPersonalInformationVerification() { RefPersonalInformationVerificationId = 4, Code = "01005", Description = "Entry in family Bible" });
            data.Add(new RefPersonalInformationVerification() { RefPersonalInformationVerificationId = 5, Code = "01006", Description = "Hospital certificate" });
            data.Add(new RefPersonalInformationVerification() { RefPersonalInformationVerificationId = 6, Code = "01013", Description = "Immigration document/visa" });
            data.Add(new RefPersonalInformationVerification() { RefPersonalInformationVerificationId = 7, Code = "02382", Description = "Life insurance policy" });
            data.Add(new RefPersonalInformationVerification() { RefPersonalInformationVerificationId = 8, Code = "09999", Description = "Other" });
            data.Add(new RefPersonalInformationVerification() { RefPersonalInformationVerificationId = 9, Code = "03424", Description = "Other non-official document" });
            data.Add(new RefPersonalInformationVerification() { RefPersonalInformationVerificationId = 10, Code = "03423", Description = "Other official document" });
            data.Add(new RefPersonalInformationVerification() { RefPersonalInformationVerificationId = 11, Code = "01007", Description = "Parent's affidavit" });
            data.Add(new RefPersonalInformationVerification() { RefPersonalInformationVerificationId = 12, Code = "01008", Description = "Passport" });
            data.Add(new RefPersonalInformationVerification() { RefPersonalInformationVerificationId = 13, Code = "01009", Description = "Physician's certificate" });
            data.Add(new RefPersonalInformationVerification() { RefPersonalInformationVerificationId = 14, Code = "01010", Description = "Previously verified school records" });
            data.Add(new RefPersonalInformationVerification() { RefPersonalInformationVerificationId = 15, Code = "01011", Description = "State-issued ID" });

            return data;
        }
    }
}
