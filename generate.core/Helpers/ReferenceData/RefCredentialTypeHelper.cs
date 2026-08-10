using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefCredentialTypeHelper
    {

        public static List<RefCredentialType> GetData()
        {
            /*
            select 'data.Add(new RefCredentialType() { 
            RefCredentialTypeId = ' + convert(varchar(20), RefCredentialTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefCredentialType
            */

            var data = new List<RefCredentialType>();

            data.Add(new RefCredentialType()
            {
                RefCredentialTypeId = 1,
                Code = "Certification",
                Description = "Certification"
            });
            data.Add(new RefCredentialType()
            {
                RefCredentialTypeId = 2,
                Code = "Endorsement",
                Description = "Endorsement"
            });
            data.Add(new RefCredentialType()
            {
                RefCredentialTypeId = 3,
                Code = "Licensure",
                Description = "Licensure"
            });
            data.Add(new RefCredentialType()
            {
                RefCredentialTypeId = 4,
                Code = "Other",
                Description = "Other"
            });
            data.Add(new RefCredentialType()
            {
                RefCredentialTypeId = 5,
                Code = "Registration",
                Description = "Registration"
            });

            return data;
        }
    }
}
