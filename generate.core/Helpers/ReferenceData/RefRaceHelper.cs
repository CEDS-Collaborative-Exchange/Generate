using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefRaceHelper
    {

        public static List<RefRace> GetData()
        {
            /*
            select 'data.Add(new RefRace() { 
            RefRaceId = ' + convert(varchar(20), RefRaceId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefRace
            */

            var data = new List<RefRace>();

            data.Add(new RefRace() { RefRaceId = 1, Code = "AmericanIndianorAlaskaNative", Description = "American Indian or Alaska Native" });
            data.Add(new RefRace() { RefRaceId = 2, Code = "Asian", Description = "Asian" });
            data.Add(new RefRace() { RefRaceId = 3, Code = "BlackorAfricanAmerican", Description = "Black or African American" });
            data.Add(new RefRace() { RefRaceId = 4, Code = "NativeHawaiianorOtherPacificIslander", Description = "Native Hawaiian or Other Pacific Islander" });
            data.Add(new RefRace() { RefRaceId = 5, Code = "White", Description = "White" });
            data.Add(new RefRace() { RefRaceId = 6, Code = "TwoorMoreRaces", Description = "Two or More Races" });

            return data;
        }
    }
}
