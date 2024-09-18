using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefProfessionalTechnicalCredentialTypeHelper
    {

        public static List<RefProfessionalTechnicalCredentialType> GetData()
        {
            /*
            select 'data.Add(new RefProfessionalTechnicalCredentialType() { 
            RefProfessionalTechnicalCredentialTypeId = ' + convert(varchar(20), RefProfessionalTechnicalCredentialTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefProfessionalTechnicalCredentialType
            */

            var data = new List<RefProfessionalTechnicalCredentialType>();

            data.Add(new RefProfessionalTechnicalCredentialType() { RefProfessionalTechnicalCredentialTypeId = 1, Code = "OccupationalLicense", Description = "Occupational License" });
            data.Add(new RefProfessionalTechnicalCredentialType() { RefProfessionalTechnicalCredentialTypeId = 2, Code = "IndustryCertification", Description = "Industry-recognized Certification" });
            data.Add(new RefProfessionalTechnicalCredentialType() { RefProfessionalTechnicalCredentialTypeId = 3, Code = "ApprenticeshipCertificate", Description = "Apprenticeship Certificate" });
            data.Add(new RefProfessionalTechnicalCredentialType() { RefProfessionalTechnicalCredentialTypeId = 4, Code = "EmployerCertification", Description = "Employer certification" });
            data.Add(new RefProfessionalTechnicalCredentialType() { RefProfessionalTechnicalCredentialTypeId = 5, Code = "PreEmploymentTraining", Description = "Pre-employment training certificate" });
            data.Add(new RefProfessionalTechnicalCredentialType() { RefProfessionalTechnicalCredentialTypeId = 6, Code = "OtherOccupational", Description = "Other recognized occupational skills credential" });

            return data;
        }
    }
}
