using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefIncidentBehaviorHelper
    {

        public static List<RefIncidentBehavior> GetData()
        {
            /*
            select 'data.Add(new RefIncidentBehavior() { 
            RefIncidentBehaviorId = ' + convert(varchar(20), RefIncidentBehaviorId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefIncidentBehavior
            */

            var data = new List<RefIncidentBehavior>();

            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 1, Code = "04618", Description = "Alcohol" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 2, Code = "04625", Description = "Arson" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 3, Code = "04626", Description = "Attendance Policy Violation" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 4, Code = "04632", Description = "Battery" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 5, Code = "04633", Description = "Burglary/Breaking and Entering" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 6, Code = "04634", Description = "Disorderly Conduct" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 7, Code = "04635", Description = "Drugs Excluding Alcohol and Tobacco" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 8, Code = "04645", Description = "Fighting" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 9, Code = "13354", Description = "Harassment or bullying on the basis of disability" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 10, Code = "13355", Description = "Harassment or bullying on the basis of race, color, or national origin" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 11, Code = "13356", Description = "Harassment or bullying on the basis of sex" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 12, Code = "04646", Description = "Harassment, Nonsexual" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 13, Code = "04650", Description = "Harassment, Sexual" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 14, Code = "04651", Description = "Homicide" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 15, Code = "04652", Description = "Inappropriate Use of Medication" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 16, Code = "04659", Description = "Insubordination" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 17, Code = "04660", Description = "Kidnapping" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 18, Code = "04661", Description = "Obscene Behavior" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 19, Code = "04669", Description = "Physical Altercation, Minor" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 20, Code = "04670", Description = "Robbery" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 21, Code = "04671", Description = "School Threat" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 22, Code = "04677", Description = "Sexual Battery (sexual assault)" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 23, Code = "04678", Description = "Sexual Offenses, Other (lewd behavior, indecent exposure)" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 24, Code = "04682", Description = "Theft" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 25, Code = "04686", Description = "Threat/Intimidation" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 26, Code = "04692", Description = "Tobacco Possession or Use" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 27, Code = "04699", Description = "Trespassing" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 28, Code = "04700", Description = "Vandalism" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 29, Code = "04704", Description = "Violation of School Rules" });
            data.Add(new RefIncidentBehavior() { RefIncidentBehaviorId = 30, Code = "04705", Description = "Weapons Possession" });

            return data;
        }
    }
}
