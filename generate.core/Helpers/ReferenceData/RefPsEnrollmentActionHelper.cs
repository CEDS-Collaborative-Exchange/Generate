using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefPsEnrollmentActionHelper
    {

        public static List<RefPsEnrollmentAction> GetData()
        {
            /*
            select 'data.Add(new RefPsEnrollmentAction() { 
            RefPsEnrollmentActionId = ' + convert(varchar(20), RefPsEnrollmentActionId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefPsEnrollmentAction
            */

            var data = new List<RefPsEnrollmentAction>();

            data.Add(new RefPsEnrollmentAction() { RefPsEnrollmentActionId = 1, Code = "NoInformation", Description = "No information" });
            data.Add(new RefPsEnrollmentAction() { RefPsEnrollmentActionId = 2, Code = "Enrolled", Description = "Enrolled" });
            data.Add(new RefPsEnrollmentAction() { RefPsEnrollmentActionId = 3, Code = "NotEnrolled", Description = "Not enrolled" });

            return data;
        }
    }
}
