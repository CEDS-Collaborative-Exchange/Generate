using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefAssessmentTypeAdministeredToEnglishLearnersHelper
    {

        public static List<RefAssessmentTypeAdministeredToEnglishLearners> GetData()
        {
            /*
            select 'data.Add(new RefAssessmentTypeAdministeredToEnglishLearners() { 
            RefAssessmentTypeAdministeredToEnglishLearnersId = ' + convert(varchar(20), RefAssessmentTypeAdministeredToEnglishLearnersId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefAssessmentTypeAdministeredToEnglishLearners
            */

            var data = new List<RefAssessmentTypeAdministeredToEnglishLearners>();

            data.Add(new RefAssessmentTypeAdministeredToEnglishLearners() { RefAssessmentTypeAdministeredToEnglishLearnersId = 1, Code = "REGELPASMNT", Description = "Regular English language proficiency (ELP) assessment" });
            data.Add(new RefAssessmentTypeAdministeredToEnglishLearners() { RefAssessmentTypeAdministeredToEnglishLearnersId = 2, Code = "ALTELPASMNTALT", Description = "Alternate English language proficiency (ELP) based on alternate ELP achievement standards" });
            
            return data;
        }
    }
}
