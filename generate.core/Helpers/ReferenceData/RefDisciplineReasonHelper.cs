using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefDisciplineReasonHelper
    {

        public static List<RefDisciplineReason> GetData()
        {
            /*
            select 'data.Add(new RefDisciplineReason() { 
            RefDisciplineReasonId = ' + convert(varchar(20), RefDisciplineReasonId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefDisciplineReason
            */

            var data = new List<RefDisciplineReason>();

            data.Add(new RefDisciplineReason()
            {
                RefDisciplineReasonId = 1,
                Code = "DrugRelated",
                Description = "Illicit drug related"
            });
            data.Add(new RefDisciplineReason()
            {
                RefDisciplineReasonId = 2,
                Code = "AlcoholRelated",
                Description = "Alcohol related"
            });
            data.Add(new RefDisciplineReason()
            {
                RefDisciplineReasonId = 3,
                Code = "WeaponsPossession",
                Description = "Weapons possession"
            });
            data.Add(new RefDisciplineReason()
            {
                RefDisciplineReasonId = 4,
                Code = "WithPhysicalInjury",
                Description = "Violent Incident (with Physical Injury)"
            });
            data.Add(new RefDisciplineReason()
            {
                RefDisciplineReasonId = 5,
                Code = "WithoutPhysicalInjury",
                Description = "Violent Incident (without Physical Injury)"
            });
            data.Add(new RefDisciplineReason()
            {
                RefDisciplineReasonId = 6,
                Code = "Other",
                Description = "Other reasons for out of school suspensions related to drug use and violence"
            });
            return data;
        }
    }
}
