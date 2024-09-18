using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefIdeaeducationalEnvironmentEcHelper
    {

        public static List<RefIdeaeducationalEnvironmentEc> GetData()
        {
            /*
            select 'data.Add(new RefIdeaeducationalEnvironmentEc() { 
            RefIdeaeducationalEnvironmentEcid = ' + convert(varchar(20), RefIdeaeducationalEnvironmentEcId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefIdeaeducationalEnvironmentEc
            */

            var data = new List<RefIdeaeducationalEnvironmentEc>();

            data.Add(new RefIdeaeducationalEnvironmentEc() { RefIdeaeducationalEnvironmentEcid = 1, Code = "REC09YOTHLOC", Description = "Other location regular early childhood program (less than 10 hours)" });
            data.Add(new RefIdeaeducationalEnvironmentEc() { RefIdeaeducationalEnvironmentEcid = 2, Code = "REC10YOTHLOC", Description = "Other location regular early childhood program (at least 10 hours)" });
            data.Add(new RefIdeaeducationalEnvironmentEc() { RefIdeaeducationalEnvironmentEcid = 3, Code = "REC09YSVCS", Description = "Services regular early childhood program (less than 10 hours)" });
            data.Add(new RefIdeaeducationalEnvironmentEc() { RefIdeaeducationalEnvironmentEcid = 4, Code = "REC10YSVCS", Description = "Services regular early childhood program (at least10 hours)" });
            data.Add(new RefIdeaeducationalEnvironmentEc() { RefIdeaeducationalEnvironmentEcid = 5, Code = "SC", Description = "Separate special education class" });
            data.Add(new RefIdeaeducationalEnvironmentEc() { RefIdeaeducationalEnvironmentEcid = 6, Code = "SS", Description = "Separate school" });
            data.Add(new RefIdeaeducationalEnvironmentEc() { RefIdeaeducationalEnvironmentEcid = 7, Code = "RF", Description = "Residential Facility" });
            data.Add(new RefIdeaeducationalEnvironmentEc() { RefIdeaeducationalEnvironmentEcid = 8, Code = "H", Description = "Home" });
            data.Add(new RefIdeaeducationalEnvironmentEc() { RefIdeaeducationalEnvironmentEcid = 9, Code = "SPL", Description = "Service provider or other location not in any other category" });

            return data;
        }
    }
}
