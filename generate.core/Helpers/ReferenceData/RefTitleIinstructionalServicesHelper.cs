using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefTitleIinstructionalServicesHelper
    {

        public static List<RefTitleIinstructionalServices> GetData()
        {
            /*
            select 'data.Add(new RefTitleIinstructionalServices() { 
            RefTitleIinstructionalServicesId = ' + convert(varchar(20), RefTitleIinstructionalServicesId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefTitleIinstructionalServices
            */

            var data = new List<RefTitleIinstructionalServices>();

            data.Add(new RefTitleIinstructionalServices() { RefTitleIinstructionalServicesId = 1, Code = "ReadingLanguageArts", Description = "Reading/Language Arts" });
            data.Add(new RefTitleIinstructionalServices() { RefTitleIinstructionalServicesId = 2, Code = "Mathematics", Description = "Mathematics" });
            data.Add(new RefTitleIinstructionalServices() { RefTitleIinstructionalServicesId = 3, Code = "Science", Description = "Science" });
            data.Add(new RefTitleIinstructionalServices() { RefTitleIinstructionalServicesId = 4, Code = "SocialSciences", Description = "Social Sciences" });
            data.Add(new RefTitleIinstructionalServices() { RefTitleIinstructionalServicesId = 5, Code = "CareerAndTechnical", Description = "Career and Technical Education" });
            data.Add(new RefTitleIinstructionalServices() { RefTitleIinstructionalServicesId = 6, Code = "Other", Description = "Other" });

            return data;
        }
    }
}
