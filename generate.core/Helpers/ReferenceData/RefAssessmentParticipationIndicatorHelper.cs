using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefAssessmentParticipationIndicatorHelper
    {

        public static List<RefAssessmentParticipationIndicator> GetData()
        {
            /*
            select 'data.Add(new RefAssessmentParticipationIndicator() { 
            RefAssessmentParticipationIndicatorId = ' + convert(varchar(20), RefAssessmentParticipationIndicatorId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefAssessmentParticipationIndicator
            */

            var data = new List<RefAssessmentParticipationIndicator>();

            data.Add(new RefAssessmentParticipationIndicator()
            {
                RefAssessmentParticipationIndicatorId = 1,
                Code = "Participated",
                Description = "Participated"
            });
            data.Add(new RefAssessmentParticipationIndicator()
            {
                RefAssessmentParticipationIndicatorId = 2,
                Code = "DidNotParticipate",
                Description = "Did Not Participate"
            });
            return data;
        }
    }
}
