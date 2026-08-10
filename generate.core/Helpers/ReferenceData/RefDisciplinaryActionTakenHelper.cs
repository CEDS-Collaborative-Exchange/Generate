using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefDisciplinaryActionTakenHelper
    {

        public static List<RefDisciplinaryActionTaken> GetData()
        {
            /*
            select 'data.Add(new RefDisciplinaryActionTaken() { 
            RefDisciplinaryActionTakenId = ' + convert(varchar(20), RefDisciplinaryActionTakenId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefDisciplinaryActionTaken
            */

            var data = new List<RefDisciplinaryActionTaken>();

            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 1, Code = "03071", Description = "Bus suspension" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 2, Code = "03072", Description = "Change of placement (long-term)" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 3, Code = "03073", Description = "Change of placement (reassignment), pending an expulsion hearing" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 4, Code = "03074", Description = "Change of placement (reassignment), resulting from an expulsion hearing" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 5, Code = "03075", Description = "Change of placement (reassignment), temporary" });
            data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 6, Code = "03076", Description = "Community service" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 7, Code = "03077", Description = "Conference with and warning to student" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 8, Code = "03078", Description = "Conference with and warning to student and parent/guardian" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 9, Code = "03079", Description = "Confiscation of contraband" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 10, Code = "03080", Description = "Conflict resolution or anger management services mandated" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 11, Code = "03081", Description = "Corporal punishment" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 12, Code = "03082", Description = "Counseling mandated" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 13, Code = "03083", Description = "Demerit" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 14, Code = "03084", Description = "Detention" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 15, Code = "03085", Description = "Expulsion recommendation" });
            data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 16, Code = "03086", Description = "Expulsion with services" });
            data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 17, Code = "03087", Description = "Expulsion without services" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 18, Code = "03088", Description = "Juvenile justice referral" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 19, Code = "03089", Description = "Law enforcement referral" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 20, Code = "03090", Description = "Letter of apology" });
            data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 21, Code = "03091", Description = "Loss of privileges" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 22, Code = "13357", Description = "Mechanical Restraint" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 23, Code = "03105", Description = "No action" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 24, Code = "09998", Description = "None" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 25, Code = "09999", Description = "Other" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 26, Code = "03092", Description = "Physical activity" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 27, Code = "13358", Description = "Physical Restraint" });
            data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 28, Code = "03158", Description = "Removal by a hearing officer" });
            data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 29, Code = "03093", Description = "Reprimand" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 30, Code = "03094", Description = "Restitution" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 31, Code = "03095", Description = "Saturday school" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 32, Code = "03096", Description = "School probation" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 33, Code = "13359", Description = "Seclusion" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 34, Code = "03097", Description = "Substance abuse counseling mandated" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 35, Code = "03098", Description = "Substance abuse treatment mandated" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 36, Code = "03099", Description = "Suspension after school" });
            data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 37, Code = "03100", Description = "Suspension, in-school" });
            data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 38, Code = "03154", Description = "Suspension, out of school, greater than 10 consecutive school days" });
            data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 39, Code = "03155", Description = "Suspension, out of school, separate days cumulating to more than 10 school days" });
            data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 40, Code = "03101", Description = "Suspension, out-of-school, with services" });
            data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 41, Code = "03102", Description = "Suspension, out-of-school, without services" });
            data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 42, Code = "03157", Description = "Unilateral removal - drug incident" });
            data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 43, Code = "03156", Description = "Unilateral removal - weapon incident" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 44, Code = "09997", Description = "Unknown" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 45, Code = "03103", Description = "Unsatisfactory behavior grade" });
            //data.Add(new RefDisciplinaryActionTaken() { RefDisciplinaryActionTakenId = 46, Code = "03104", Description = "Work detail" });


            return data;
        }
    }
}
