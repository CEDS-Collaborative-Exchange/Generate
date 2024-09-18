using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class MajorRacialEthnicGroupsHelper
    {

        public static List<string> GetData()
        {

            /*
            MA - Asian
            MAN - American Indian \ Alaska Native \ Native American
            MAP - Asian \ Pacific Islander
            MB - Black(not Hispanic) African American
            MF - Filipino
            MHL - Hispanic \ Latino
            MHN - Hispanic(not Puerto Rican)
            MM - Multicultural \ Multiethnic \ Multiracial \ other
            MNP - Native Hawaiian \ other Pacific Islander \ Pacific Islander
            MPR - Puerto Rican
            MW - White(not Hispanic) \ Caucasian
            MISSING
            */

            var data = new List<string>();

            data.Add("MA");
            data.Add("MAN");
            data.Add("MAP");
            data.Add("MB");
            data.Add("MF");
            data.Add("MHL");
            data.Add("MHN");
            data.Add("MM");
            data.Add("MNP");
            data.Add("MPR");
            data.Add("MW");

            return data;
        }
    }
}
