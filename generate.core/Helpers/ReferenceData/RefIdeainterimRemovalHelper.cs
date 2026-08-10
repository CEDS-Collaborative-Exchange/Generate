using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefIdeainterimRemovalHelper
    {

        public static List<RefIdeainterimRemoval> GetData()
        {
            /*
            select 'data.Add(new RefIdeainterimRemoval() { 
            RefIdeainterimRemovalId = ' + convert(varchar(20), RefIdeainterimRemovalId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefIdeainterimRemoval
            */

            var data = new List<RefIdeainterimRemoval>();

            data.Add(new RefIdeainterimRemoval() { RefIdeainterimRemovalId = 1, Code = "REMDW", Description = "Removal for drugs, weapons, or serious bodily injury" });
            data.Add(new RefIdeainterimRemoval() { RefIdeainterimRemovalId = 2, Code = "REMHO", Description = "Removed based on a Hearing Officer finding" });

            return data;
        }
    }
}
