using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefStateAnsiCodeHelper
    {

        public static List<RefStateAnsicode> GetData()
        {
            /*
            select 'data.Add(new RefStateAnsicode() { 
            Code = "' + Code + '",
            StateName = "' + StateName + '"
            });'
            from dbo.RefStateAnsicode
            */

            var data = new List<RefStateAnsicode>();

            data.Add(new RefStateAnsicode() { Code = "01", StateName = "Alabama" });
            data.Add(new RefStateAnsicode() { Code = "02", StateName = "Alaska" });
            data.Add(new RefStateAnsicode() { Code = "04", StateName = "Arizona" });
            data.Add(new RefStateAnsicode() { Code = "05", StateName = "Arkansas" });
            data.Add(new RefStateAnsicode() { Code = "06", StateName = "California" });
            data.Add(new RefStateAnsicode() { Code = "08", StateName = "Colorado" });
            data.Add(new RefStateAnsicode() { Code = "09", StateName = "Connecticut" });
            data.Add(new RefStateAnsicode() { Code = "10", StateName = "Delaware" });
            data.Add(new RefStateAnsicode() { Code = "11", StateName = "District of Columbia" });
            data.Add(new RefStateAnsicode() { Code = "12", StateName = "Florida" });
            data.Add(new RefStateAnsicode() { Code = "13", StateName = "Georgia" });
            data.Add(new RefStateAnsicode() { Code = "15", StateName = "Hawaii" });
            data.Add(new RefStateAnsicode() { Code = "16", StateName = "Idaho" });
            data.Add(new RefStateAnsicode() { Code = "17", StateName = "Illinois" });
            data.Add(new RefStateAnsicode() { Code = "18", StateName = "Indiana" });
            data.Add(new RefStateAnsicode() { Code = "19", StateName = "Iowa" });
            data.Add(new RefStateAnsicode() { Code = "20", StateName = "Kansas " });
            data.Add(new RefStateAnsicode() { Code = "21", StateName = "Kentucky" });
            data.Add(new RefStateAnsicode() { Code = "22", StateName = "Louisiana" });
            data.Add(new RefStateAnsicode() { Code = "23", StateName = "Maine" });
            data.Add(new RefStateAnsicode() { Code = "24", StateName = "Maryland" });
            data.Add(new RefStateAnsicode() { Code = "25", StateName = "Massachusetts" });
            data.Add(new RefStateAnsicode() { Code = "26", StateName = "Michigan" });
            data.Add(new RefStateAnsicode() { Code = "27", StateName = "Minnesota" });
            data.Add(new RefStateAnsicode() { Code = "28", StateName = "Mississippi" });
            data.Add(new RefStateAnsicode() { Code = "29", StateName = "Missouri" });
            data.Add(new RefStateAnsicode() { Code = "30", StateName = "Montana" });
            data.Add(new RefStateAnsicode() { Code = "31", StateName = "Nebraska" });
            data.Add(new RefStateAnsicode() { Code = "32", StateName = "Nevada" });
            data.Add(new RefStateAnsicode() { Code = "33", StateName = "New Hampshire" });
            data.Add(new RefStateAnsicode() { Code = "34", StateName = "New Jersey" });
            data.Add(new RefStateAnsicode() { Code = "35", StateName = "New Mexico" });
            data.Add(new RefStateAnsicode() { Code = "36", StateName = "New York" });
            data.Add(new RefStateAnsicode() { Code = "37", StateName = "North Carolina" });
            data.Add(new RefStateAnsicode() { Code = "38", StateName = "North Dakota" });
            data.Add(new RefStateAnsicode() { Code = "39", StateName = "Ohio" });
            data.Add(new RefStateAnsicode() { Code = "40", StateName = "Oklahoma" });
            data.Add(new RefStateAnsicode() { Code = "41", StateName = "Oregon" });
            data.Add(new RefStateAnsicode() { Code = "42", StateName = "Pennsylvania" });
            data.Add(new RefStateAnsicode() { Code = "44", StateName = "Rhode Island" });
            data.Add(new RefStateAnsicode() { Code = "45", StateName = "South Carolina" });
            data.Add(new RefStateAnsicode() { Code = "46", StateName = "South Dakota" });
            data.Add(new RefStateAnsicode() { Code = "47", StateName = "Tennessee" });
            data.Add(new RefStateAnsicode() { Code = "48", StateName = "Texas" });
            data.Add(new RefStateAnsicode() { Code = "49", StateName = "Utah" });
            data.Add(new RefStateAnsicode() { Code = "50", StateName = "Vermont" });
            data.Add(new RefStateAnsicode() { Code = "51", StateName = "Virginia" });
            data.Add(new RefStateAnsicode() { Code = "53", StateName = "Washington" });
            data.Add(new RefStateAnsicode() { Code = "54", StateName = "West Virginia" });
            data.Add(new RefStateAnsicode() { Code = "55", StateName = "Wisconsin" });
            data.Add(new RefStateAnsicode() { Code = "56", StateName = "Wyoming" });
            data.Add(new RefStateAnsicode() { Code = "60", StateName = "American Samoa" });
            data.Add(new RefStateAnsicode() { Code = "64", StateName = "Federated States of Micronesia" });
            data.Add(new RefStateAnsicode() { Code = "66", StateName = "Guam" });
            data.Add(new RefStateAnsicode() { Code = "68", StateName = "Marshall Islands" });
            data.Add(new RefStateAnsicode() { Code = "69", StateName = "Northern Mariana Islands" });
            data.Add(new RefStateAnsicode() { Code = "70", StateName = "Palau " });
            data.Add(new RefStateAnsicode() { Code = "72", StateName = "Puerto Rico" });
            data.Add(new RefStateAnsicode() { Code = "78", StateName = "Virgin Islands of the U.S." });

            return data;
        }
    }
}
