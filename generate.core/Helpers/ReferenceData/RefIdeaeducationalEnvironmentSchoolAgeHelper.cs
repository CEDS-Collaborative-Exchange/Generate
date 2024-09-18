using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefIdeaeducationalEnvironmentSchoolAgeHelper
    {

        public static List<RefIdeaeducationalEnvironmentSchoolAge> GetData()
        {
            /*
            select 'data.Add(new RefIdeaeducationalEnvironmentSchoolAge() { 
            RefIdeaEducationalEnvironmentSchoolAge = ' + convert(varchar(20), RefIdeaEducationalEnvironmentSchoolAge) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefIdeaeducationalEnvironmentSchoolAge
            */

            var data = new List<RefIdeaeducationalEnvironmentSchoolAge>();

            data.Add(new RefIdeaeducationalEnvironmentSchoolAge() { RefIdeaEducationalEnvironmentSchoolAge = 1, Code = "RC80", Description = "Inside regular class 80% or more of the day" });
            data.Add(new RefIdeaeducationalEnvironmentSchoolAge() { RefIdeaEducationalEnvironmentSchoolAge = 2, Code = "RC79TO40", Description = "Inside regular class 40% through 79% of the day" });
            data.Add(new RefIdeaeducationalEnvironmentSchoolAge() { RefIdeaEducationalEnvironmentSchoolAge = 3, Code = "RC39", Description = "Inside regular class less than 40% of the day" });
            data.Add(new RefIdeaeducationalEnvironmentSchoolAge() { RefIdeaEducationalEnvironmentSchoolAge = 4, Code = "SS", Description = "Separate school" });
            data.Add(new RefIdeaeducationalEnvironmentSchoolAge() { RefIdeaEducationalEnvironmentSchoolAge = 5, Code = "RF", Description = "Residential facility" });
            data.Add(new RefIdeaeducationalEnvironmentSchoolAge() { RefIdeaEducationalEnvironmentSchoolAge = 6, Code = "HH", Description = "Homebound/hospital" });
            data.Add(new RefIdeaeducationalEnvironmentSchoolAge() { RefIdeaEducationalEnvironmentSchoolAge = 7, Code = "CF", Description = "Correctional facility" });
            data.Add(new RefIdeaeducationalEnvironmentSchoolAge() { RefIdeaEducationalEnvironmentSchoolAge = 8, Code = "PPPS", Description = "Parentally placed in private school" });

            return data;
        }
    }
}
