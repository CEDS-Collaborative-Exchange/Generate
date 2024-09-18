using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefK12staffClassificationHelper
    {

        public static List<RefK12staffClassification> GetData()
        {
            /*
            select 'data.Add(new RefK12staffClassification() { 
            RefEducationStaffClassificationId = ' + convert(varchar(20), RefEducationStaffClassificationId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefK12staffClassification
            */

            var data = new List<RefK12staffClassification>();

            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 1, Code = "AdministrativeSupportStaff", Description = "Administrative Support Staff" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 2, Code = "Administrators", Description = "Administrators" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 3, Code = "AllOtherSupportStaff", Description = "All Other Support Staff " });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 4, Code = "BehavioralSpecialists", Description = "Behavioral Specialists" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 5, Code = "ELAssistantTeachers", Description = "Early Learning Assistant Teachers" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 6, Code = "ELTeachers", Description = "Early Learning Teachers" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 7, Code = "ElementaryTeachers", Description = "Elementary Teachers" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 8, Code = "FamilyServiceWorkers", Description = "Family Service Workers" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 9, Code = "HealthSpecialists", Description = "Health Specialists" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 10, Code = "HomeVisitors", Description = "Home Visitors" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 11, Code = "InstructionalCoordinators", Description = "Instructional Coordinators" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 12, Code = "KindergartenTeachers", Description = "Kindergarten Teachers" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 13, Code = "LibraryMediaSpecialists", Description = "Librarians/Media Specialists" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 14, Code = "LibraryMediaSupportStaff", Description = "Library/Media Support Staff" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 15, Code = "MentalHealthSpecialists", Description = "Mental Health Specialists" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 16, Code = "NutritionSpecialists", Description = "Nutrition Specialists" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 17, Code = "Paraprofessionals", Description = "Paraprofessionals" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 18, Code = "PartCEarlyInterventionists", Description = "Part C Early Interventionists" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 19, Code = "PartCServiceCoordinators", Description = "Part C Service Coordinators" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 20, Code = "SchoolCounselors", Description = "School Counselors" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 21, Code = "SecondaryTeachers", Description = "Secondary Teachers" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 22, Code = "SocialWorkers", Description = "Social Workers" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 23, Code = "SpecialEducationTeachers", Description = "Special Education Teachers" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 24, Code = "SpecialNeedsSpecialists", Description = "Special Needs Specialists" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 25, Code = "StudentSupportServicesStaff", Description = "Student Support Services Staff" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 26, Code = "UngradedTeachers", Description = "Ungraded Teachers" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 27, Code = "SchoolPsychologist", Description = "School Psychologist" });
            data.Add(new RefK12staffClassification() { RefEducationStaffClassificationId = 28, Code = "PrekindergartenTeachers", Description = "Pre-kindergarten Teachers" });

            return data;
        }
    }
}
