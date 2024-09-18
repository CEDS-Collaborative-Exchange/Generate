using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefSchoolImprovementStatusHelper
    {

        public static List<RefSchoolImprovementStatus> GetData()
        {
            /*
            select 'data.Add(new RefSchoolImprovementStatus() { 
            RefSchoolImprovementStatusId = ' + convert(varchar(20), RefSchoolImprovementStatusId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefSchoolImprovementStatus
            */

            var data = new List<RefSchoolImprovementStatus>();

            data.Add(new RefSchoolImprovementStatus() { RefSchoolImprovementStatusId = 1, Code = "CorrectiveAction", Description = "Corrective action" });
            data.Add(new RefSchoolImprovementStatus() { RefSchoolImprovementStatusId = 2, Code = "Year1", Description = "Improvement status Year 1" });
            data.Add(new RefSchoolImprovementStatus() { RefSchoolImprovementStatusId = 3, Code = "Year2", Description = "Improvement status Year 2" });
            data.Add(new RefSchoolImprovementStatus() { RefSchoolImprovementStatusId = 4, Code = "Planning", Description = "Planning for restructuring" });
            data.Add(new RefSchoolImprovementStatus() { RefSchoolImprovementStatusId = 5, Code = "Restructuring", Description = "Restructuring" });
            data.Add(new RefSchoolImprovementStatus() { RefSchoolImprovementStatusId = 6, Code = "NA", Description = "Not applicable" });
            data.Add(new RefSchoolImprovementStatus() { RefSchoolImprovementStatusId = 7, Code = "FS", Description = "Focus School" });
            data.Add(new RefSchoolImprovementStatus() { RefSchoolImprovementStatusId = 8, Code = "PS", Description = "Priority School" });
            data.Add(new RefSchoolImprovementStatus() { RefSchoolImprovementStatusId = 9, Code = "NFPS", Description = "School that is neither Priority or Focus" });

            return data;
        }
    }
}
