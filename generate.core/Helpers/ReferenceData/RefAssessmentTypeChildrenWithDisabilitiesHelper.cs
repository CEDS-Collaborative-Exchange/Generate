using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefAssessmentTypeChildrenWithDisabilitiesHelper
    {

        public static List<RefAssessmentTypeChildrenWithDisabilities> GetData()
        {
            /*
            select 'data.Add(new RefAssessmentTypeChildrenWithDisabilities() { 
            RefAssessmentTypeChildrenWithDisabilitiesId = ' + convert(varchar(20), RefAssessmentTypeChildrenWithDisabilitiesId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefAssessmentTypeChildrenWithDisabilities
            */

            var data = new List<RefAssessmentTypeChildrenWithDisabilities>();

            data.Add(new RefAssessmentTypeChildrenWithDisabilities()
            {
                RefAssessmentTypeChildrenWithDisabilitiesId = 1,
                Code = "REGASSWOACC",
                Description = "Regular assessments based on grade-level achievement standards without accommodations"
            });
            data.Add(new RefAssessmentTypeChildrenWithDisabilities()
            {
                RefAssessmentTypeChildrenWithDisabilitiesId = 2,
                Code = "REGASSWACC",
                Description = "Regular assessments based on grade-level achievement standards with accommodations"
            });
            data.Add(new RefAssessmentTypeChildrenWithDisabilities()
            {
                RefAssessmentTypeChildrenWithDisabilitiesId = 3,
                Code = "ALTASSGRADELVL",
                Description = "Alternate assessments based on grade-level achievement standards"
            });
            data.Add(new RefAssessmentTypeChildrenWithDisabilities()
            {
                RefAssessmentTypeChildrenWithDisabilitiesId = 4,
                Code = "ALTASSMODACH",
                Description = "Alternate assessments based on modified achievement standards"
            });
            data.Add(new RefAssessmentTypeChildrenWithDisabilities()
            {
                RefAssessmentTypeChildrenWithDisabilitiesId = 5,
                Code = "ALTASSALTACH",
                Description = "Alternate assessments based on alternate achievement standards"
            });
            data.Add(new RefAssessmentTypeChildrenWithDisabilities()
            {
                RefAssessmentTypeChildrenWithDisabilitiesId = 6,
                Code = "AgeLevelWithoutAccommodations",
                Description = "Assessment based on  age level standards without accommodations"
            });
            data.Add(new RefAssessmentTypeChildrenWithDisabilities()
            {
                RefAssessmentTypeChildrenWithDisabilitiesId = 7,
                Code = "AgeLevelWithAccommodations",
                Description = "Assessment based on  age level standards with accommodations"
            });
            data.Add(new RefAssessmentTypeChildrenWithDisabilities()
            {
                RefAssessmentTypeChildrenWithDisabilitiesId = 8,
                Code = "BelowAgeLevelWithoutAccommodations",
                Description = "Assessment based on standards below age level without accommodations"
            });
            data.Add(new RefAssessmentTypeChildrenWithDisabilities()
            {
                RefAssessmentTypeChildrenWithDisabilitiesId = 9,
                Code = "BelowAgeLevelWithAccommodations",
                Description = "Assessment based on standards below age level with accommodations"
            });
            return data;
        }
    }
}
