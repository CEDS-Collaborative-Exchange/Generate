using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefIdeainterimRemovalReasonHelper
    {

        public static List<RefIdeainterimRemovalReason> GetData()
        {
            /*
            select 'data.Add(new RefIdeainterimRemovalReason() { 
            RefIdeainterimRemovalReasonId = ' + convert(varchar(20), RefIdeainterimRemovalReasonId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefIdeainterimRemovalReason
            */

            var data = new List<RefIdeainterimRemovalReason>();

            data.Add(new RefIdeainterimRemovalReason() { RefIdeainterimRemovalReasonId = 1, Code = "Drugs", Description = "Drugs" });
            data.Add(new RefIdeainterimRemovalReason() { RefIdeainterimRemovalReasonId = 2, Code = "Weapons", Description = "Weapons" });
            data.Add(new RefIdeainterimRemovalReason() { RefIdeainterimRemovalReasonId = 3, Code = "SeriousBodilyInjury", Description = "Serious bodily injury" });

            return data;
        }
    }
}
