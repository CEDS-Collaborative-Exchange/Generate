using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefWfProgramParticipationHelper
    {

        public static List<RefWfProgramParticipation> GetData()
        {
            /*
            select 'data.Add(new RefWfProgramParticipation() { 
            RefWfProgramParticipationId = ' + convert(varchar(20), RefWfProgramParticipationId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefWfProgramParticipation
            */

            var data = new List<RefWfProgramParticipation>();

            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 1, Code = "01", Description = "Labor Exchange Services" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 2, Code = "02", Description = "Adult Workforce Investment Act Program" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 3, Code = "03", Description = "Dislocated Worker Workforce Investment Act Program" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 4, Code = "04", Description = "Youth Workforce Investment Act Program" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 5, Code = "05", Description = "Job Corps" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 6, Code = "06", Description = "Adult Education and Literacy" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 7, Code = "07", Description = "National Farmworker Jobs Program" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 8, Code = "08", Description = "Indian and Native American Programs" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 9, Code = "09", Description = "Veteran's Programs" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 10, Code = "10", Description = "Trade Adjustment Assistance Program" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 11, Code = "11", Description = "YouthBuild Program" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 12, Code = "12", Description = "Title V Older Worker Program" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 13, Code = "13", Description = "Registered Apprenticeship" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 14, Code = "14", Description = "Non-traditional Apprenticeship" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 15, Code = "15", Description = "Vocational Rehabilitation" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 16, Code = "16", Description = "Food Stamp Employment and Training Program" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 17, Code = "17", Description = "TANF Employment and Training Program" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 18, Code = "18", Description = "Other On-The-Job training Program" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 19, Code = "19", Description = "Other Workforce Related Employment and Training Program" });
            data.Add(new RefWfProgramParticipation() { RefWfProgramParticipationId = 20, Code = "99", Description = "No identified services" });

            return data;
        }
    }
}
