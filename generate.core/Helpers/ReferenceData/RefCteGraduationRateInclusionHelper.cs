using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefCteGraduationRateInclusionHelper
    {

        public static List<RefCteGraduationRateInclusion> GetData()
        {
            /*
            select 'data.Add(new RefCteGraduationRateInclusion() { 
            RefCteGraduationRateInclusionId = ' + convert(varchar(20), RefCteGraduationRateInclusionId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefCteGraduationRateInclusion
            */

            var data = new List<RefCteGraduationRateInclusion>();

            data.Add(new RefCteGraduationRateInclusion()
            {
                RefCteGraduationRateInclusionId = 1,
                Code = "IncludedAsGraduated",
                Description = "Included in computation as graduated  "
            });
            data.Add(new RefCteGraduationRateInclusion()
            {
                RefCteGraduationRateInclusionId = 2,
                Code = "NotIncludedAsGraduated",
                Description = "Included in computation as not graduated."
            });
            return data;
        }
    }
}
