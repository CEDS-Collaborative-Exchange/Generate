using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefOrganizationIndicatorHelper
    {

        public static List<RefOrganizationIndicator> GetData()
        {
            /*
            select 'data.Add(new RefOrganizationIndicator() { 
            RefOrganizationIndicatorId = ' + convert(varchar(20), RefOrganizationIndicatorId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefOrganizationIndicator
            */

            var data = new List<RefOrganizationIndicator>();

            data.Add(new RefOrganizationIndicator() { RefOrganizationIndicatorId = 1, Code = "AP Course Self Selection", Description = "Advanced Placement Course Self Selection" });
            //data.Add(new RefOrganizationIndicator() { RefOrganizationIndicatorId = 2, Code = "AP Course Self Selection", Description = "Advanced Placement Course Self Selection" });
            data.Add(new RefOrganizationIndicator() { RefOrganizationIndicatorId = 3, Code = "SharedTime", Description = "Shared Time" });
            data.Add(new RefOrganizationIndicator() { RefOrganizationIndicatorId = 4, Code = "AbilityGrouping", Description = "Ability Grouping" });
            //data.Add(new RefOrganizationIndicator() { RefOrganizationIndicatorId = 5, Code = "AbilityGrouping", Description = "Ability Grouping" });
            data.Add(new RefOrganizationIndicator() { RefOrganizationIndicatorId = 6, Code = "Virtual", Description = "Virtual" });

            return data;
        }
    }
}
