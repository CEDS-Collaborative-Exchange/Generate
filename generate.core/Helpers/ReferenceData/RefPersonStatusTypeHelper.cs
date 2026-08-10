using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefPersonStatusTypeHelper
    {

        public static List<RefPersonStatusType> GetData()
        {
            /*
            select 'data.Add(new RefPersonStatusType() { 
            RefPersonStatusTypeId = ' + convert(varchar(20), RefPersonStatusTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefPersonStatusType
            */

            var data = new List<RefPersonStatusType>();

            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 1, Code = "EconomicDisadvantage", Description = "Economic Disadvantage" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 2, Code = "HomelessUnaccompaniedYouth", Description = "Homeless Unaccompanied Youth" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 3, Code = "IDEA", Description = "IDEA" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 4, Code = "LEP", Description = "Limited English Proficiency" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 5, Code = "Migrant", Description = "Migrant" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 6, Code = "SchoolChoiceAppliedforTransfer", Description = "School Choice Applied for Transfer" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 7, Code = "SchoolChoiceEligibleforTransfer", Description = "School Choice Eligible for Transfer" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 8, Code = "SchoolChoiceTransfer", Description = "School Choice Transfer" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 9, Code = "TitleISchoolSupplementalServicesApplied", Description = "Title I School Supplemental Services Applied" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 10, Code = "TitleISchoolSupplementalServicesEligible", Description = "Title I School Supplemental Services Eligible" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 11, Code = "TitleISchoolSupplementalServicesReceived", Description = "Title I School Supplemental Services Received" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 12, Code = "TitleIIIImmigrant", Description = "Title III Immigrant" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 13, Code = "Truant", Description = "Truant" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 14, Code = "SingleParentOrSinglePregnantWoman", Description = "Single Parent Or Single Pregnant Woman" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 15, Code = "Perkins LEP", Description = "Perkins Limited English Proficiency" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 16, Code = "Low-income", Description = "Low-income" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 17, Code = "DislocatedWorker", Description = "Dislocated Worker" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 18, Code = "PublicAssistance", Description = "Public Assistance" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 19, Code = "RuralResidency", Description = "Rural Residency" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 20, Code = "ProfessionalAssociationMembership", Description = "Professional Association Membership" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 21, Code = "StateApprovedTrainer", Description = "State Approved Trainer" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 22, Code = "StateApprovedTechnicalAssistanceProvider", Description = "State Approved Technical Assistance Provider" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 23, Code = "ProgramHeathSafetyChecklistUse", Description = "Program Heath Safety Checklist Use" });
            data.Add(new RefPersonStatusType() { RefPersonStatusTypeId = 24, Code = "Homeless", Description = "Homeless" });

            return data;
        }
    }
}
