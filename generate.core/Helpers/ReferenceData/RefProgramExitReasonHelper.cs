using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefProgramExitReasonHelper
    {

        public static List<RefProgramExitReason> GetData()
        {
            /*
            select 'data.Add(new RefProgramExitReason() { 
            RefProgramExitReasonId = ' + convert(varchar(20), RefProgramExitReasonId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefProgramExitReason
            */

            var data = new List<RefProgramExitReason>();

            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 1, Code = "06262", Description = "Attempts to contact the parent and/or child were unsuccessful" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 2, Code = "02226", Description = "Completion of IFSP prior to reaching maximum age for Part C" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 3, Code = "01923", Description = "Died or is permanently incapacitated" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 4, Code = "01927", Description = "Discontinued schooling" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 5, Code = "02222", Description = "Discontinued schooling, not special education" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 6, Code = "02221", Description = "Discontinued schooling, special education only" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 7, Code = "02227", Description = "Eligible for IDEA, Part B" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 8, Code = "02224", Description = "Expulsion" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 9, Code = "02212", Description = "Graduated with a high school diploma" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 10, Code = "02231", Description = "Moved out of state" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 11, Code = "02216", Description = "No longer receiving special education" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 12, Code = "06261", Description = "Not eligible for Part B, exit with no referrals" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 13, Code = "73075", Description = "Moved within the US, not known to be continuing" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 14, Code = "02228", Description = "Not eligible for Part B, exit with referrals to other programs" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 15, Code = "02230", Description = "Part B eligibility not determined" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 16, Code = "02214", Description = "Program completion" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 17, Code = "02225", Description = "Program discontinued" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 18, Code = "02215", Description = "Reached maximum age" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 19, Code = "02213", Description = "Received certificate of completion, modified diploma, or finished IEP requirements" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 20, Code = "02217", Description = "Refused services" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 21, Code = "73076", Description = "Student data claimed in error/never attended" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 22, Code = "73078", Description = "Student moved to another country, may or may not be continuing" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 23, Code = "73079", Description = "Student with disabilities remaining in school to receive transitional services" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 24, Code = "02220", Description = "Suspended from school" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 25, Code = "02406", Description = "Transferred to another district or school, known not to be continuing in program/service" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 26, Code = "02218", Description = "Transferred to another district or school, known to be continuing in program/service" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 27, Code = "02219", Description = "Transferred to another district or school, not known to be continuing in program/service" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 28, Code = "73077", Description = "Transferred to a juvenile or adult correctional facility where educational services are not provided" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 29, Code = "02233", Description = "Unknown reason" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 30, Code = "02232", Description = "Withdrawal by a parent (or guardian)" });
            data.Add(new RefProgramExitReason() { RefProgramExitReasonId = 31, Code = "09999", Description = "Other" });

            return data;
        }
    }
}
