using generate.core.Models.App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.TestDataHelper.App
{
    public static class ToggleQuestionHelper
    {

        public static List<ToggleQuestion> GetData()
        {
            /*
			select 'data.Add(new ToggleQuestion() { 
            ToggleQuestionId = ' + convert(varchar(20), ToggleQuestionId) + ',
            QuestionText = "' + replace(QuestionText, '"', '\"') + '",
            EmapsQuestionAbbrv = "' + EmapsQuestionAbbrv + '"
            });'
            from App.ToggleQuestions
            */

            var data = new List<ToggleQuestion>();

            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 1,
                QuestionText = "Does your state use the required reference period of July 1 to June 30 to report exiting data for IDEA?",
                EmapsQuestionAbbrv = "DEFEXREFPER"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 2,
                QuestionText = "Please indicate whether your state permits the placement of children with disabilities (IDEA) ages 3 through 5, at service provider location.",
                EmapsQuestionAbbrv = "ENVECSERPRV"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 3,
                QuestionText = "Please indicate all related service personnel categories that are employed or contracted to provide related services to children with disabilities (IDEA), ages 3 through 21, in your state.",
                EmapsQuestionAbbrv = "STAFFCAT"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 4,
                QuestionText = "Does your state  remove students with disabilities (IDEA) from their educational placement for disciplinary purposes for the remainder of the school year or longer?",
                EmapsQuestionAbbrv = "DISCPREM"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 5,
                QuestionText = "Are children with disabilities (IDEA) who were limited English proficient and who were in the U.S. less than 12 months prior to the reading/language arts state assessment allowed to take the English language proficient (ELP) assessment in lieu of the regular reading/language arts assessment in your state?",
                EmapsQuestionAbbrv = "ASSESLEP"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 6,
                QuestionText = "How is your state's special education 618 data related to students (i.e., child count, educational environments, discipline, exiting, & assessment) integrated into your state's Student Information System (i.e., state data system used for all student data)?",
                EmapsQuestionAbbrv = "STADMSSIS"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 7,
                QuestionText = "How is your state's special education 618 data related to students (i.e., child count, educational environments, discipline, exiting, & assessment) integrated into your state's longitudinal data system?",
                EmapsQuestionAbbrv = "STADMSLDS"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 8,
                QuestionText = "What is your state's definition of significant disproportionality?",
                EmapsQuestionAbbrv = "MOECEDEF"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 9,
                QuestionText = "Please indicate whether your state permits the placement of children with disabilities (IDEA) ages 3 through 5, at home.",
                EmapsQuestionAbbrv = "ENVECHM"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 10,
                QuestionText = "Which of the following does your state report on its Graduates/Completers file (FS040)?",
                EmapsQuestionAbbrv = "GRADRPT"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 11,
                QuestionText = "Do you currently report students in Grade 13?",
                EmapsQuestionAbbrv = "CCDGRADE13"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 12,
                QuestionText = "Do you currently report students in Adult Education?",
                EmapsQuestionAbbrv = "ADULTEDU"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 13,
                QuestionText = "Does your state allow for medical exemptions on the state English Learner proficiency test?",
                EmapsQuestionAbbrv = "ASSESSENGLEARNPROF"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 14,
                QuestionText = "Does your state allow for medical exemptions on the state Title III English Learner proficiency test?",
                EmapsQuestionAbbrv = "ASSESSENGLEARNPROFTTLEIII"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 15,
                QuestionText = "What is the start date of the perkins program year?",
                EmapsQuestionAbbrv = "CTEPERKPROGYRSTART"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 16,
                QuestionText = "What is the end date of the perkins program year?",
                EmapsQuestionAbbrv = "CTEPERKPROGYREND"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 17,
                QuestionText = "Does your state have displaced homemakers at the secondary level?",
                EmapsQuestionAbbrv = "CTEDISPLCDHMMKRATSECDLVL"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 18,
                QuestionText = "Does your state have ungraded students in its public schools?",
                EmapsQuestionAbbrv = "CCDUNGRADED"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 19,
                QuestionText = "Please indicate whether your state permits the placement of children with disabilities (IDEA) ages 3 through 5, in a residental facility.",
                EmapsQuestionAbbrv = "ENVECRESFAC"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 20,
                QuestionText = "Please indicate whether your state permits the placement of children with disabilities (IDEA) ages 3 through 5, in separate schools.",
                EmapsQuestionAbbrv = "ENVECSEPSCH"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 21,
                QuestionText = "Please indicate whether your state permits the placement of children with disabilities (IDEA) ages 3 through 5, in separate special education classes.",
                EmapsQuestionAbbrv = "ENVECSEPCL"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 22,
                QuestionText = "What is the maximum age at which a student with disabilities (IDEA) can receive special education services?",
                EmapsQuestionAbbrv = "DEFEXMAXAGE"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 23,
                QuestionText = "Can a student with disabilities (IDEA) exit an educational program by receiving a high school completion certificate, modified diploma, or similar document?         Note: This includes students with disabilities (IDEA) who received: (1) A high school diploma but did not meet the same standards for graduation as students without disabilities, and (2) An alternative degree that was not fully aligned with the state's academic standards.",
                EmapsQuestionAbbrv = "DEFEXCERTIF"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 24,
                QuestionText = "Is there a minimum age for graduation with a regular high school diploma in your state?",
                EmapsQuestionAbbrv = "DEFEXMINAGEIF"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 25,
                QuestionText = "When reporting counts under the \"Moved, Known to be Continuing\" reporting category in the IDEA Exiting data (i.e. total who moved out of the catchment area or otherwise transferred to another district and are KNOWN to be continuing in an educational program), what is your state's catchment area for LEA - Level Counts?",
                EmapsQuestionAbbrv = "DEFEXMOVCONLEA"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 26,
                QuestionText = "When reporting counts under the \"Moved, Known to be Continuing\" reporting category in the IDEA Exiting data (i.e. total who moved out of the catchment area or otherwise transferred to another district and are KNOWN to be continuing in an educational program), what is your state's catchment area for SEA - Level Counts?",
                EmapsQuestionAbbrv = "DEFEXMOVCONSEA"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 27,
                QuestionText = "What date between October 1 and December 1 is your state's IDEA child count date?",
                EmapsQuestionAbbrv = "CHDCTDTE"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 28,
                QuestionText = "Does your state report data for all state-operated programs (SOP's) related to children with disabilities (IDEA)?",
                EmapsQuestionAbbrv = "CHDCTRPTSOP"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 29,
                QuestionText = "SOP's are reported at which one of the following:",
                EmapsQuestionAbbrv = "CHDCTRPTFOR"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 30,
                QuestionText = "Please indicate all of the disability categories used by your state.",
                EmapsQuestionAbbrv = "CHDCTDISCAT"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 31,
                QuestionText = "What ages are included in your state's definition for developmental delay for children with disabilities (IDEA)?",
                EmapsQuestionAbbrv = "CHDCTAGEDD"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 32,
                QuestionText = "Please indicate whether your state permits placement of children with disabilities (IDEA), ages 6 through 21, in a regular class.",
                EmapsQuestionAbbrv = "ENVSAREGCL"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 33,
                QuestionText = "Please indicate whether your state permits placement of children with disabilities (IDEA), ages 6 through 21, in a separate school.",
                EmapsQuestionAbbrv = "ENVSASEPSCH"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 34,
                QuestionText = "Please indicate whether your state permits placement of children with disabilities (IDEA), ages 6 through 21, in a residential facility.",
                EmapsQuestionAbbrv = "ENVSARESFAC"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 35,
                QuestionText = "Please indicate whether your state permits placement of children with disabilities (IDEA), ages 6 through 21, in a homebound/hospital.",
                EmapsQuestionAbbrv = "ENVSAHMHOS"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 36,
                QuestionText = "Please indicate whether your state permits placement of children with disabilities (IDEA), ages 6 through 21, in a correctional facility.",
                EmapsQuestionAbbrv = "ENVSACORFAC"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 37,
                QuestionText = "Please indicate whether your state permits placement of children with disabilities (IDEA), ages 6 through 21, in parentally placed private school.",
                EmapsQuestionAbbrv = "ENVSAPRVSCH"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 38,
                QuestionText = "Please indicate whether your state permits the placement of children with disabilities (IDEA) ages 3 through 5, in regular early childhood programs.",
                EmapsQuestionAbbrv = "ENVECREGCL"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 39,
                QuestionText = "Does your state use CTE IDEA or ADA disability for Perkins reporting?",
                EmapsQuestionAbbrv = "CTEPERKDISAB"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 40,
                QuestionText = "Which of the following CTE diploma/credential types does your state use?",
                EmapsQuestionAbbrv = "CTEDIPLOMA"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 41,
                QuestionText = "If the reference period of July 1 to June 30 is not used, what is the start date of the reference period used?",
                EmapsQuestionAbbrv = "DEFEXREFDTESTART"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 42,
                QuestionText = "What is the end date of the reference period used?",
                EmapsQuestionAbbrv = "DEFEXREFDTEEND"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 43,
                QuestionText = "If yes, please provide the statuatory/regulatory/policy citation(s).",
                EmapsQuestionAbbrv = "DEFEXCERTNUM"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 44,
                QuestionText = "If yes, please provide the minimum age for graduation with a regular high school diploma.",
                EmapsQuestionAbbrv = "DEFEXMINAGENUM"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 45,
                QuestionText = "Please, provide the relevant statutory regulatory policy citation(s) that prohibit this practice.",
                EmapsQuestionAbbrv = "DISCPREGPOL"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 46,
                QuestionText = "What is the membership count date of the state?",
                EmapsQuestionAbbrv = "MEMBERDTE"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 47,
                QuestionText = "What is the english learner count date of the state?",
                EmapsQuestionAbbrv = "ELDTE"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 48,
                QuestionText = "What is the instructional period start date of the state?",
                EmapsQuestionAbbrv = "INSTSTARTDTE"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 49,
                QuestionText = "What is the instructional period end date of the state?",
                EmapsQuestionAbbrv = "INSTENDDTE"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 50,
                QuestionText = "What is the School Year start date defined by the state?",
                EmapsQuestionAbbrv = "STATESYSTARTDTE"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 51,
                QuestionText = "What is the School Year end date defined by the state?",
                EmapsQuestionAbbrv = "STATESYENDDTE"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 52,
                QuestionText = "What is the start date of time period for inclusion in the cohort of students from the previous academic year?",
                EmapsQuestionAbbrv = "PYINCTIMEPRDSTARTDTE"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 53,
                QuestionText = "What is the end date of time period for inclusion in the cohort of students from the previous academic year?",
                EmapsQuestionAbbrv = "PYINCTIMEPRDENDDTE"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 54,
                QuestionText = "What is the start date of enrollment in the IHE in the current academic	year?",
                EmapsQuestionAbbrv = "IHETIMEPRDSTARTDTE"
            });
            data.Add(new ToggleQuestion()
            {
                ToggleQuestionId = 55,
                QuestionText = "What is the end date of enrollment in the IHE in the current academic year?",
                EmapsQuestionAbbrv = "IHETIMEPRDENDDTE"
            });

            data.Add(new ToggleQuestion() 
            { 
                ToggleQuestionId = 56, 
                QuestionText = "What date should be used to fill the EFFECTIVE DATE field in FS029 - Directory?", 
                EmapsQuestionAbbrv = "EFFECTIVEDTE" 
            });

            return data;
        }
    }
}
