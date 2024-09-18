using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusHelper
    {

        public static List<RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus> GetData()
        {
            /*
            select 'data.Add(new RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus() { 
            RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId = ' + convert(varchar(20), RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus
            */

            var data = new List<RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus>();

            data.Add(new RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus() { RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId = 1, Code = "STTDEF", Description = "State defined status" });
            data.Add(new RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus() { RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId = 2, Code = "TOOFEW", Description = "Too few students" });
            data.Add(new RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus() { RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId = 3, Code = "NOSTUDENTS", Description = "No students in the subgroup" });

            return data;
        }
    }
}
