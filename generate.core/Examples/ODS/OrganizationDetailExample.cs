using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Examples.ODS
{
    public static class OrganizationDetailExample
    {
        public static OrganizationDetail GetExample(int? id = null)
        {
            if (!id.HasValue)
            {
                id = 1;
            }

            OrganizationDetail example = new OrganizationDetail()
            {
                OrganizationDetailId = (int)id,
                Name = "Test",
                ShortName = "TST"                
            };

            return example;
        }

        public static OrganizationDetail GetUpdatedExample(OrganizationDetail existing)
        {
            existing.Name = "Updated";

            return existing;
        }
    }
}
