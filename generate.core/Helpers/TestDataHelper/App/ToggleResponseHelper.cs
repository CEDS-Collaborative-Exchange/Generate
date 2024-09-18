using generate.core.Models.App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.TestDataHelper.App
{
    public class ToggleResponseHelper
    {


        public static List<ToggleResponse> GetData()
        {
            /*

			select 'data.Add(new ToggleResponse() { 
            ToggleResponseId = ' + convert(varchar(20), ToggleResponseId) + ',
            ToggleQuestionId = ' + convert(varchar(20), ToggleQuestionId) + ',
            ResponseValue = "' + ResponseValue + '",
            ToggleQuestionOptionId = ' + case when ToggleQuestionOptionId is null then 'null' else convert(varchar(20), ToggleQuestionOptionId) end + '
            });'
            from App.ToggleResponses
            */

            var data = new List<ToggleResponse>();

            data.Add(new ToggleResponse() { ToggleResponseId = 1, ToggleQuestionId = 27, ResponseValue = "10/01/2019", ToggleQuestionOptionId = null });
            data.Add(new ToggleResponse() { ToggleResponseId = 2, ToggleQuestionId = 25, ResponseValue = "Entire state (students moving out of state)", ToggleQuestionOptionId = 112 });
            data.Add(new ToggleResponse() { ToggleResponseId = 3, ToggleQuestionId = 42, ResponseValue = "06/02/2019", ToggleQuestionOptionId = null });
            data.Add(new ToggleResponse() { ToggleResponseId = 4, ToggleQuestionId = 16, ResponseValue = "10/01/2019", ToggleQuestionOptionId = null });
            data.Add(new ToggleResponse() { ToggleResponseId = 5, ToggleQuestionId = 1, ResponseValue = "true", ToggleQuestionOptionId = null });
            data.Add(new ToggleResponse() { ToggleResponseId = 6, ToggleQuestionId = 47, ResponseValue = "02/06/2019", ToggleQuestionOptionId = null });
            data.Add(new ToggleResponse() { ToggleResponseId = 7, ToggleQuestionId = 15, ResponseValue = "07/06/2017", ToggleQuestionOptionId = null });
            data.Add(new ToggleResponse() { ToggleResponseId = 8, ToggleQuestionId = 46, ResponseValue = "08/21/2019", ToggleQuestionOptionId = null });
            data.Add(new ToggleResponse() { ToggleResponseId = 9, ToggleQuestionId = 48, ResponseValue = "08/01/2017", ToggleQuestionOptionId = null });
            data.Add(new ToggleResponse() { ToggleResponseId = 10, ToggleQuestionId = 49, ResponseValue = "08/14/2019", ToggleQuestionOptionId = null });
            data.Add(new ToggleResponse() { ToggleResponseId = 11, ToggleQuestionId = 50, ResponseValue = "08/02/2017", ToggleQuestionOptionId = null });
            data.Add(new ToggleResponse() { ToggleResponseId = 12, ToggleQuestionId = 51, ResponseValue = "08/14/2019", ToggleQuestionOptionId = null });
            data.Add(new ToggleResponse() { ToggleResponseId = 13, ToggleQuestionId = 52, ResponseValue = "08/02/2017", ToggleQuestionOptionId = null });
            data.Add(new ToggleResponse() { ToggleResponseId = 14, ToggleQuestionId = 53, ResponseValue = "09/12/2018", ToggleQuestionOptionId = null });
            data.Add(new ToggleResponse() { ToggleResponseId = 15, ToggleQuestionId = 54, ResponseValue = "08/03/2017", ToggleQuestionOptionId = null });
            data.Add(new ToggleResponse() { ToggleResponseId = 16, ToggleQuestionId = 55, ResponseValue = "07/24/2019", ToggleQuestionOptionId = null });
            data.Add(new ToggleResponse() { ToggleResponseId = 17, ToggleQuestionId = 40, ResponseValue = "Regular secondary school diploma", ToggleQuestionOptionId = 33 });
            data.Add(new ToggleResponse() { ToggleResponseId = 23, ToggleQuestionId = 26, ResponseValue = "Entire state (students moving out of state)", ToggleQuestionOptionId = 115 });
            data.Add(new ToggleResponse() { ToggleResponseId = 24, ToggleQuestionId = 30, ResponseValue = "Other Health Impairment", ToggleQuestionOptionId = 65 });
            data.Add(new ToggleResponse() { ToggleResponseId = 25, ToggleQuestionId = 30, ResponseValue = "Visual Impairment", ToggleQuestionOptionId = 66 });
            data.Add(new ToggleResponse() { ToggleResponseId = 26, ToggleQuestionId = 30, ResponseValue = "Traumatic Brain Injury", ToggleQuestionOptionId = 67 });
            data.Add(new ToggleResponse() { ToggleResponseId = 27, ToggleQuestionId = 30, ResponseValue = "Speech or Language Impairment", ToggleQuestionOptionId = 68 });
            data.Add(new ToggleResponse() { ToggleResponseId = 29, ToggleQuestionId = 30, ResponseValue = "Specific Learning Disability", ToggleQuestionOptionId = 69 });
            data.Add(new ToggleResponse() { ToggleResponseId = 37, ToggleQuestionId = 10, ResponseValue = "Regular diploma that indicates a student meets or exceeds the requirements of a regular diploma.", ToggleQuestionOptionId = 41 });
            data.Add(new ToggleResponse() { ToggleResponseId = 38, ToggleQuestionId = 40, ResponseValue = "Other state-recognized equivalent", ToggleQuestionOptionId = 32 });
            data.Add(new ToggleResponse() { ToggleResponseId = 39, ToggleQuestionId = 39, ResponseValue = "IDEA Disability", ToggleQuestionOptionId = 35 });
            data.Add(new ToggleResponse() { ToggleResponseId = 40, ToggleQuestionId = 30, ResponseValue = "Orthopedic Impairment", ToggleQuestionOptionId = 70 });
            data.Add(new ToggleResponse() { ToggleResponseId = 42, ToggleQuestionId = 30, ResponseValue = "Autism", ToggleQuestionOptionId = 77 });
            data.Add(new ToggleResponse() { ToggleResponseId = 43, ToggleQuestionId = 30, ResponseValue = "Multiple Disabilities", ToggleQuestionOptionId = 71 });
            data.Add(new ToggleResponse() { ToggleResponseId = 44, ToggleQuestionId = 30, ResponseValue = "Intellectual Disability", ToggleQuestionOptionId = 72 });
            data.Add(new ToggleResponse() { ToggleResponseId = 45, ToggleQuestionId = 30, ResponseValue = "Hearing Impairment", ToggleQuestionOptionId = 73 });
            data.Add(new ToggleResponse() { ToggleResponseId = 46, ToggleQuestionId = 30, ResponseValue = "Emotional Disturbance", ToggleQuestionOptionId = 74 });
            data.Add(new ToggleResponse() { ToggleResponseId = 47, ToggleQuestionId = 30, ResponseValue = "Deaf-Blindness", ToggleQuestionOptionId = 76 });

            return data;

        }
    }
}
