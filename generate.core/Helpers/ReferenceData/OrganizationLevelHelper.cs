using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.App;

namespace generate.core.Helpers.ReferenceData
{
    public static class OrganizationLevelHelper
    {
        public static List<OrganizationLevel> GetData()
        {
            var data = new List<OrganizationLevel>();
            data.Add(new OrganizationLevel()
            {
                OrganizationLevelId = 1,
                LevelCode = "sea",
                LevelName = "SEA"
            });
            data.Add(new OrganizationLevel()
            {
                OrganizationLevelId = 2,
                LevelCode = "lea",
                LevelName = "LEA"
            });
            data.Add(new OrganizationLevel()
            {
                OrganizationLevelId = 3,
                LevelCode = "sch",
                LevelName = "School"
            });

            return data;

        }
    }
}
 