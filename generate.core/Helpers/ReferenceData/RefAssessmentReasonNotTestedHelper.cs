using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefAssessmentReasonNotTestedHelper
    {

        public static List<RefAssessmentReasonNotTested> GetData()
        {
            /*
            select 'data.Add(new RefAssessmentReasonNotTested() { 
            RefAssessmentReasonNotTestedId = ' + convert(varchar(20), RefAssessmentReasonNotTestedId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefAssessmentReasonNotTested
            */

            var data = new List<RefAssessmentReasonNotTested>();

            data.Add(new RefAssessmentReasonNotTested()
            {
                RefAssessmentReasonNotTestedId = 1,
                Code = "03451",
                Description = "Absent"
            });
            data.Add(new RefAssessmentReasonNotTested()
            {
                RefAssessmentReasonNotTestedId = 2,
                Code = "03455",
                Description = "Disruptive behavior"
            });
            data.Add(new RefAssessmentReasonNotTested()
            {
                RefAssessmentReasonNotTestedId = 3,
                Code = "03454",
                Description = "Medical waiver"
            });
            data.Add(new RefAssessmentReasonNotTested()
            {
                RefAssessmentReasonNotTestedId = 4,
                Code = "03456",
                Description = "Previously passed the exam"
            });
            data.Add(new RefAssessmentReasonNotTested()
            {
                RefAssessmentReasonNotTestedId = 5,
                Code = "03452",
                Description = "Refusal by parent"
            });
            data.Add(new RefAssessmentReasonNotTested()
            {
                RefAssessmentReasonNotTestedId = 6,
                Code = "03453",
                Description = "Refusal by student"
            });
            data.Add(new RefAssessmentReasonNotTested()
            {
                RefAssessmentReasonNotTestedId = 7,
                Code = "09999",
                Description = "Other"
            });
            return data;
        }
    }
}
