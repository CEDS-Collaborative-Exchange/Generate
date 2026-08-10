using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefMepServiceTypeHelper
    {

        public static List<RefMepServiceType> GetData()
        {
            /*
            select 'data.Add(new RefMepServiceType() { 
            RefMepServiceTypeId = ' + convert(varchar(20), RefMepServiceTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefMepServiceType
            */

            var data = new List<RefMepServiceType>();

            data.Add(new RefMepServiceType() { RefMepServiceTypeId = 1, Code = "CounselingServices", Description = "Counseling Services" });
            data.Add(new RefMepServiceType() { RefMepServiceTypeId = 2, Code = "HighSchoolAccrual", Description = "High School Accrual" });
            data.Add(new RefMepServiceType() { RefMepServiceTypeId = 3, Code = "InstructionalServices", Description = "Instructional Services" });
            data.Add(new RefMepServiceType() { RefMepServiceTypeId = 4, Code = "MathematicsInstruction", Description = "Mathematics Instruction" });
            data.Add(new RefMepServiceType() { RefMepServiceTypeId = 5, Code = "ReadingInstruction", Description = "Reading Instruction" });
            data.Add(new RefMepServiceType() { RefMepServiceTypeId = 6, Code = "ReferralServices", Description = "Referral Services" });
            data.Add(new RefMepServiceType() { RefMepServiceTypeId = 7, Code = "SupportServices", Description = "Support Services" });

            return data;
        }
    }
}
