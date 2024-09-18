using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefAssessmentReasonNotCompletingHelper
    {

        public static List<RefAssessmentReasonNotCompleting> GetData()
        {
            /*
            select 'data.Add(new RefAssessmentReasonNotCompleting() { 
            RefAssessmentReasonNotCompletingId = ' + convert(varchar(20), RefAssessmentReasonNotCompletingId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefAssessmentReasonNotCompleting
            */

            var data = new List<RefAssessmentReasonNotCompleting>();

            data.Add(new RefAssessmentReasonNotCompleting()
            {
                RefAssessmentReasonNotCompletingId = 1,
                Code = "ParentsOptOut",
                Description = "Parents opt out"
            });
            data.Add(new RefAssessmentReasonNotCompleting()
            {
                RefAssessmentReasonNotCompletingId = 2,
                Code = "Absent",
                Description = "Absent during"
            });
            data.Add(new RefAssessmentReasonNotCompleting()
            {
                RefAssessmentReasonNotCompletingId = 3,
                Code = "Other",
                Description = "Did not participate for other reason"
            });
            data.Add(new RefAssessmentReasonNotCompleting()
            {
                RefAssessmentReasonNotCompletingId = 4,
                Code = "OutOfLevelTest",
                Description = "Participated in an out of level test"
            });
            data.Add(new RefAssessmentReasonNotCompleting()
            {
                RefAssessmentReasonNotCompletingId = 5,
                Code = "NoValidScore",
                Description = "No valid score"
            });
            data.Add(new RefAssessmentReasonNotCompleting()
            {
                RefAssessmentReasonNotCompletingId = 6,
                Code = "Medical",
                Description = "Medical emergency"
            });
            data.Add(new RefAssessmentReasonNotCompleting()
            {
                RefAssessmentReasonNotCompletingId = 7,
                Code = "Moved",
                Description = "Moved"
            });
            data.Add(new RefAssessmentReasonNotCompleting()
            {
                RefAssessmentReasonNotCompletingId = 8,
                Code = "LeftProgram",
                Description = "Person left program - unable to locate"
            });
            return data;
        }
    }
}
