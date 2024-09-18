using generate.core.Models.App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.TestDataHelper.App
{
    public static class ToggleQuestionOptionHelper
    {

        public static List<ToggleQuestionOption> GetData()
        {
            /*
			select 'data.Add(new ToggleQuestionOption() { 
            ToggleQuestionOptionId = ' + convert(varchar(20), ToggleQuestionOptionId) + ',
            ToggleQuestionId = ' + convert(varchar(20), ToggleQuestionId) + ',
            OptionText = "' + OptionText + '"
            });'
            from App.ToggleQuestionOptions
            */

            var data = new List<ToggleQuestionOption>();


            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 1, ToggleQuestionId = 22, OptionText = "None" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 2, ToggleQuestionId = 21, OptionText = "Permit for all age children" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 3, ToggleQuestionId = 38, OptionText = "Does not permit" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 4, ToggleQuestionId = 38, OptionText = "Permit depending on age of the child" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 5, ToggleQuestionId = 38, OptionText = "Permit for all age children" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 6, ToggleQuestionId = 37, OptionText = "Does not permit" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 7, ToggleQuestionId = 37, OptionText = "Permit depending on age of the child - age groups 12-17 and 18-21" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 8, ToggleQuestionId = 37, OptionText = "Permit depending on age of the child - age groups 6-11 and 18-21" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 9, ToggleQuestionId = 37, OptionText = "Permit depending on age of the child - age groups 6-11 and 12-17" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 10, ToggleQuestionId = 37, OptionText = "Permit for all age children" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 11, ToggleQuestionId = 36, OptionText = "Does not permit" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 12, ToggleQuestionId = 36, OptionText = "Permit depending on age of the child - age groups 12-17 and 18-21" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 13, ToggleQuestionId = 36, OptionText = "Permit depending on age of the child - age groups 6-11 and 18-21" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 14, ToggleQuestionId = 21, OptionText = "Permit depending on age of the child" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 15, ToggleQuestionId = 36, OptionText = "Permit depending on age of the child - age groups 6-11 and 12-17" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 16, ToggleQuestionId = 35, OptionText = "Does not permit" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 17, ToggleQuestionId = 35, OptionText = "Permit depending on age of the child" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 18, ToggleQuestionId = 35, OptionText = "Permit for all age children" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 19, ToggleQuestionId = 34, OptionText = "Does not permit" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 20, ToggleQuestionId = 34, OptionText = "Permit depending on age of the child" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 21, ToggleQuestionId = 34, OptionText = "Permit for all age children" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 22, ToggleQuestionId = 33, OptionText = "Does not permit" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 23, ToggleQuestionId = 33, OptionText = "Permit depending on age of the child" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 24, ToggleQuestionId = 33, OptionText = "Permit for all age children" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 25, ToggleQuestionId = 32, OptionText = "Does not permit" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 26, ToggleQuestionId = 32, OptionText = "Permit depending on age of the child" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 27, ToggleQuestionId = 32, OptionText = "Permit for all age children" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 28, ToggleQuestionId = 36, OptionText = "Permit for all age children" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 29, ToggleQuestionId = 21, OptionText = "Does not permit" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 30, ToggleQuestionId = 20, OptionText = "Permit for all age children" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 31, ToggleQuestionId = 20, OptionText = "Permit depending on age of the child" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 32, ToggleQuestionId = 40, OptionText = "Other state-recognized equivalent" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 33, ToggleQuestionId = 40, OptionText = "Regular secondary school diploma" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 34, ToggleQuestionId = 39, OptionText = "ADA Disability" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 35, ToggleQuestionId = 39, OptionText = "IDEA Disability" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 36, ToggleQuestionId = 11, OptionText = "No" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 37, ToggleQuestionId = 11, OptionText = "Yes" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 38, ToggleQuestionId = 18, OptionText = "No" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 39, ToggleQuestionId = 18, OptionText = "Yes" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 40, ToggleQuestionId = 10, OptionText = "Other high school completion credentials for meeting criteria other than the requirements for a regular diploma(i.e. certificate of completion, certificate of attendance)." });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 41, ToggleQuestionId = 10, OptionText = "Regular diploma that indicates a student meets or exceeds the requirements of a regular diploma." });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 42, ToggleQuestionId = 44, OptionText = "18 Years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 43, ToggleQuestionId = 44, OptionText = "17 Years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 44, ToggleQuestionId = 44, OptionText = "16 Years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 45, ToggleQuestionId = 44, OptionText = "15 Years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 46, ToggleQuestionId = 44, OptionText = "14 Years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 47, ToggleQuestionId = 2, OptionText = "Does not permit" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 48, ToggleQuestionId = 2, OptionText = "Permit depending on age of the child" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 49, ToggleQuestionId = 2, OptionText = "Permit for all age children" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 50, ToggleQuestionId = 9, OptionText = "Does not permit" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 51, ToggleQuestionId = 9, OptionText = "Permit depending on age of the child" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 52, ToggleQuestionId = 9, OptionText = "Permit for all age children" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 53, ToggleQuestionId = 19, OptionText = "Does not permit" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 54, ToggleQuestionId = 19, OptionText = "Permit depending on age of the child - ages 4 and 5" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 55, ToggleQuestionId = 19, OptionText = "Permit depending on age of the child - ages 3 and 5" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 56, ToggleQuestionId = 19, OptionText = "Permit depending on age of the child - ages 3 and 4" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 57, ToggleQuestionId = 19, OptionText = "Permit for all age children" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 58, ToggleQuestionId = 20, OptionText = "Does not permit" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 59, ToggleQuestionId = 28, OptionText = "No, NONE of the SOPs are reported" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 60, ToggleQuestionId = 28, OptionText = "Yes, SOME SOPs are reported at LEA level only" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 61, ToggleQuestionId = 28, OptionText = "Yes, SOME SOPs are reported at SEA level only" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 62, ToggleQuestionId = 28, OptionText = "Yes, SOME SOPs are reported at SEA and LEA levels" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 63, ToggleQuestionId = 3, OptionText = "Social Workers" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 64, ToggleQuestionId = 3, OptionText = "Psychologists" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 65, ToggleQuestionId = 30, OptionText = "Other Health Impairment" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 66, ToggleQuestionId = 30, OptionText = "Visual Impairment" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 67, ToggleQuestionId = 30, OptionText = "Traumatic Brain Injury" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 68, ToggleQuestionId = 30, OptionText = "Speech or Language Impairment" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 69, ToggleQuestionId = 30, OptionText = "Specific Learning Disability" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 70, ToggleQuestionId = 30, OptionText = "Orthopedic Impairment" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 71, ToggleQuestionId = 30, OptionText = "Multiple Disabilities" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 72, ToggleQuestionId = 30, OptionText = "Intellectual Disability" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 73, ToggleQuestionId = 30, OptionText = "Hearing Impairment" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 74, ToggleQuestionId = 30, OptionText = "Emotional Disturbance" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 75, ToggleQuestionId = 30, OptionText = "Developmental Delay" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 76, ToggleQuestionId = 30, OptionText = "Deaf-Blindness" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 77, ToggleQuestionId = 30, OptionText = "Autism" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 78, ToggleQuestionId = 29, OptionText = "LEA only" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 79, ToggleQuestionId = 29, OptionText = "SEA only" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 80, ToggleQuestionId = 29, OptionText = "SEA and LEA levels" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 81, ToggleQuestionId = 22, OptionText = "26 years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 82, ToggleQuestionId = 22, OptionText = "25 years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 83, ToggleQuestionId = 22, OptionText = "24 years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 84, ToggleQuestionId = 22, OptionText = "23 years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 85, ToggleQuestionId = 22, OptionText = "22 years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 86, ToggleQuestionId = 22, OptionText = "21 years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 87, ToggleQuestionId = 22, OptionText = "20 years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 88, ToggleQuestionId = 22, OptionText = "19 years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 89, ToggleQuestionId = 22, OptionText = "18 years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 90, ToggleQuestionId = 3, OptionText = "Occupational Therapists" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 91, ToggleQuestionId = 40, OptionText = "General Education Development (GED) credential" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 92, ToggleQuestionId = 3, OptionText = "Audiologists" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 93, ToggleQuestionId = 3, OptionText = "Physical Therapists" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 94, ToggleQuestionId = 28, OptionText = "Yes, ALL SOPs are reported at LEA level only" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 95, ToggleQuestionId = 28, OptionText = "Yes, ALL SOPs are reported at SEA level only" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 96, ToggleQuestionId = 28, OptionText = "Yes, ALL SOPs are reported at SEA and LEA levels" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 97, ToggleQuestionId = 7, OptionText = "Not at all" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 98, ToggleQuestionId = 7, OptionText = "Some data components" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 99, ToggleQuestionId = 7, OptionText = "All data components" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 100, ToggleQuestionId = 6, OptionText = "Not at all" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 101, ToggleQuestionId = 6, OptionText = "Some data components" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 102, ToggleQuestionId = 6, OptionText = "All data components" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 103, ToggleQuestionId = 31, OptionText = "9 Years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 104, ToggleQuestionId = 31, OptionText = "8 Years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 105, ToggleQuestionId = 31, OptionText = "7 Years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 106, ToggleQuestionId = 31, OptionText = "6 Years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 107, ToggleQuestionId = 31, OptionText = "5 Years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 108, ToggleQuestionId = 31, OptionText = "4 Years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 109, ToggleQuestionId = 31, OptionText = "3 Years" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 110, ToggleQuestionId = 25, OptionText = "Other (specify)" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 111, ToggleQuestionId = 25, OptionText = "Districtwide (students moving out of district)" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 112, ToggleQuestionId = 25, OptionText = "Entire state (students moving out of state)" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 113, ToggleQuestionId = 26, OptionText = "Other (specify)" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 114, ToggleQuestionId = 26, OptionText = "Districtwide (students moving out of district)" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 115, ToggleQuestionId = 26, OptionText = "Entire state (students moving out of state)" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 116, ToggleQuestionId = 3, OptionText = "Medical/Nursing Service Staff" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 117, ToggleQuestionId = 3, OptionText = "Orientation and Mobility Specialists" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 118, ToggleQuestionId = 3, OptionText = "Counselors and Rehabilitation Counselors" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 119, ToggleQuestionId = 3, OptionText = "Interpreters" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 120, ToggleQuestionId = 3, OptionText = "Speech-Language Pathologists" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 121, ToggleQuestionId = 3, OptionText = "Physical Education Teachers and Recreation and Therapeutic Recreation Specialists" });
            data.Add(new ToggleQuestionOption() { ToggleQuestionOptionId = 122, ToggleQuestionId = 40, OptionText = "Proficiency credential, certificate, or degree, in conjunction with a secondary school diploma" });

            return data;
        }
    }
}
