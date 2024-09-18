using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefSpecialEducationExitReasonHelper
    {

        public static List<RefSpecialEducationExitReason> GetData()
        {
            /*
            select 'data.Add(new RefSpecialEducationExitReason() { 
            RefSpecialEducationExitReasonId = ' + convert(varchar(20), RefSpecialEducationExitReasonId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefSpecialEducationExitReason
            */

            var data = new List<RefSpecialEducationExitReason>();

            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 1, Code = "HighSchoolDiploma", Description = "Graduated with regular high school diploma" });
            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 2, Code = "ReceivedCertificate", Description = "Received a certificate" });
            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 3, Code = "ReachedMaximumAge", Description = "Reached maximum age" });
            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 4, Code = "Died", Description = "Died" });
            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 5, Code = "MovedAndContinuing", Description = "Moved, known to be continuing" });
            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 6, Code = "DroppedOut", Description = "Dropped out" });
            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 7, Code = "Transferred", Description = "Transferred to regular education" });
            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 8, Code = "PartCNoLongerEligible", Description = "No longer eligible for Part C prior to reaching age three." });
            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 9, Code = "PartBEligibleExitingPartC", Description = "Part B eligible, exiting Part C." });
            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 10, Code = "PartBEligibleContinuingPartC", Description = "Part B eligible, continuing in Part C." });
            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 11, Code = "NotPartBElgibleExitingPartCWithReferrrals", Description = "Not eligible for Part B, exit with referrals to other programs." });
            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 12, Code = "NotPartBElgibleExitingPartCWithoutReferrrals", Description = "Not eligible for Part B, exit with no referrals." });
            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 13, Code = "PartBEligibilityNotDeterminedExitingPartC", Description = "Part B eligibility not determined." });
            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 14, Code = "WithdrawalByParent", Description = "Withdrawal by parent (or guardian)." });
            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 15, Code = "MovedOutOfState", Description = "Moved out of State" });
            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 16, Code = "Unreachable", Description = "Attempts to contact the parent and/or child were unsuccessful." });
            data.Add(new RefSpecialEducationExitReason() { RefSpecialEducationExitReasonId = 17, Code = "AlternateDiploma", Description = "Graduated with an alternate diploma" });

            return data;
        }
    }
}
