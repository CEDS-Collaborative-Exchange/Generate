using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefPersonIdentificationSystemHelper
    {

        public static List<RefPersonIdentificationSystem> GetData()
        {
            /*
            select 'data.Add(new RefPersonIdentificationSystem() { 
            RefPersonIdentificationSystemId = ' + convert(varchar(20), RefPersonIdentificationSystemId) + ',
            RefPersonIdentifierTypeId = ' + convert(varchar(20), RefPersonIdentifierTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefPersonIdentificationSystem
            */

            var data = new List<RefPersonIdentificationSystem>();

            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 1, RefPersonIdentifierTypeId = 2, Code = "CanadianSIN", Description = "Canadian Social Insurance Number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 2, RefPersonIdentifierTypeId = 2, Code = "District", Description = "District-assigned number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 3, RefPersonIdentifierTypeId = 2, Code = "Family", Description = "Family unit number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 4, RefPersonIdentifierTypeId = 2, Code = "Federal", Description = "Federal identification number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 5, RefPersonIdentifierTypeId = 2, Code = "NationalMigrant", Description = "National migrant number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 6, RefPersonIdentifierTypeId = 2, Code = "School", Description = "School-assigned number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 7, RefPersonIdentifierTypeId = 2, Code = "SSN", Description = "Social Security Administration number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 8, RefPersonIdentifierTypeId = 2, Code = "State", Description = "State-assigned number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 9, RefPersonIdentifierTypeId = 2, Code = "StateMigrant", Description = "State migrant number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 10, RefPersonIdentifierTypeId = 2, Code = "Program", Description = "Program-assigned number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 11, RefPersonIdentifierTypeId = 3, Code = "SSN", Description = "Social Security Administration number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 12, RefPersonIdentifierTypeId = 3, Code = "USVisa", Description = "US government Visa number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 13, RefPersonIdentifierTypeId = 3, Code = "PIN", Description = "Personal identification number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 14, RefPersonIdentifierTypeId = 3, Code = "Federal", Description = "Federal identification number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 15, RefPersonIdentifierTypeId = 3, Code = "DriversLicense", Description = "Driver's license number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 16, RefPersonIdentifierTypeId = 3, Code = "Medicaid", Description = "Medicaid number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 17, RefPersonIdentifierTypeId = 3, Code = "HealthRecord", Description = "Health record number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 18, RefPersonIdentifierTypeId = 3, Code = "ProfessionalCertificate", Description = "Professional certificate or license number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 19, RefPersonIdentifierTypeId = 3, Code = "School", Description = "School-assigned number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 20, RefPersonIdentifierTypeId = 3, Code = "District", Description = "District-assigned number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 21, RefPersonIdentifierTypeId = 3, Code = "State", Description = "State-assigned number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 22, RefPersonIdentifierTypeId = 3, Code = "OtherFederal", Description = "Other federally assigned number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 23, RefPersonIdentifierTypeId = 3, Code = "SelectiveService", Description = "Selective Service Number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 24, RefPersonIdentifierTypeId = 3, Code = "CanadianSIN", Description = "Canadian Social Insurance Number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 25, RefPersonIdentifierTypeId = 3, Code = "Other", Description = "Other" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 26, RefPersonIdentifierTypeId = 4, Code = "CanadianSIN", Description = "Canadian Social Insurance Number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 27, RefPersonIdentifierTypeId = 4, Code = "District", Description = "District-assigned number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 28, RefPersonIdentifierTypeId = 4, Code = "Family", Description = "Family unit number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 29, RefPersonIdentifierTypeId = 4, Code = "Federal", Description = "Federal identification number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 30, RefPersonIdentifierTypeId = 4, Code = "NationalMigrant", Description = "National migrant number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 31, RefPersonIdentifierTypeId = 4, Code = "School", Description = "School-assigned number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 32, RefPersonIdentifierTypeId = 4, Code = "SSN", Description = "Social Security Administration number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 33, RefPersonIdentifierTypeId = 4, Code = "State", Description = "State-assigned number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 34, RefPersonIdentifierTypeId = 4, Code = "StateMigrant", Description = "State migrant number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 35, RefPersonIdentifierTypeId = 5, Code = "SSN", Description = "Social Security Administration number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 36, RefPersonIdentifierTypeId = 5, Code = "USVisa", Description = "US government Visa number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 37, RefPersonIdentifierTypeId = 5, Code = "PIN", Description = "Personal identification number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 38, RefPersonIdentifierTypeId = 5, Code = "Federal", Description = "Federal identification number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 39, RefPersonIdentifierTypeId = 5, Code = "DriversLicense", Description = "Driver's license number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 40, RefPersonIdentifierTypeId = 5, Code = "Medicaid", Description = "Medicaid number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 41, RefPersonIdentifierTypeId = 5, Code = "HealthRecord", Description = "Health record number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 42, RefPersonIdentifierTypeId = 5, Code = "ProfessionalCertificate", Description = "Professional certificate or license number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 43, RefPersonIdentifierTypeId = 5, Code = "School", Description = "School-assigned number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 44, RefPersonIdentifierTypeId = 5, Code = "District", Description = "District-assigned number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 45, RefPersonIdentifierTypeId = 5, Code = "State", Description = "State-assigned number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 46, RefPersonIdentifierTypeId = 5, Code = "Institution", Description = "Institution-assigned number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 47, RefPersonIdentifierTypeId = 5, Code = "OtherFederal", Description = "Other federally assigned number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 48, RefPersonIdentifierTypeId = 5, Code = "SelectiveService", Description = "Selective Service Number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 49, RefPersonIdentifierTypeId = 5, Code = "CanadianSIN", Description = "Canadian Social Insurance Number" });
            data.Add(new RefPersonIdentificationSystem() { RefPersonIdentificationSystemId = 50, RefPersonIdentifierTypeId = 5, Code = "Other", Description = "Other" });

            return data;
        }
    }
}
