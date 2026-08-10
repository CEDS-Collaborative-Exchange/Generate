using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.App;

namespace generate.core.Helpers.ReferenceData
{
    public class GenerateReportHelper
    {
        public static List<GenerateReport> GetData()
        {

            /*
            select 'data.Add(new GenerateReport() { 
            GenerateReportId = ' + convert(varchar(20), GenerateReportId) + ',
            ReportCode = "' + isnull(ReportCode, '') + '",
            ReportName = "' + isnull(ReportName, '') + '",
			FactTableId = ' + case when FactTableId is null then 'null' else convert(varchar(20), FactTableId) end + ',
            });'
            from App.GenerateReports

            */

            var data = new List<GenerateReport>();



            data.Add(new GenerateReport() { GenerateReportId = 1, ReportCode = "studentsex", ReportName = "Student Count by Sex", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 2, ReportCode = "indicator4b", ReportName = "Indicator 4B: Suspension and Expulsion by Race/Ethnicity", FactTableId = 5, });
            data.Add(new GenerateReport() { GenerateReportId = 3, ReportCode = "indicator4a", ReportName = "Indicator 4A: Suspension/Expulsion", FactTableId = 5, });
            data.Add(new GenerateReport() { GenerateReportId = 4, ReportCode = "188", ReportName = "188: Assessment Participation in Reading/Language Arts", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 5, ReportCode = "185", ReportName = "185: Assessment Participation in Mathematics", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 6, ReportCode = "178", ReportName = "178: Academic Achievement in Reading (Language Arts)", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 7, ReportCode = "175", ReportName = "175: Academic Achievement in Mathematics", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 8, ReportCode = "144", ReportName = "144: Educational Services During Expulsion", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 9, ReportCode = "143", ReportName = "143: Children with Disabilities (IDEA) Total Disciplinary Removals", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 10, ReportCode = "112", ReportName = "112: Special Education Paraprofessionals", FactTableId = 4, });
            data.Add(new GenerateReport() { GenerateReportId = 11, ReportCode = "099", ReportName = "099: Special Education Related Services Personnel", FactTableId = 4, });
            data.Add(new GenerateReport() { GenerateReportId = 12, ReportCode = "089", ReportName = "089: Children with Disabilities (IDEA) Early Childhood", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 13, ReportCode = "indicator9", ReportName = "Indicator 9: Disproportionate Representation", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 14, ReportCode = "088", ReportName = "088: Children with Disabilities (IDEA) Disciplinary Removals", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 15, ReportCode = "009", ReportName = "009: Children with Disabilities (IDEA) Exiting Special Education", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 16, ReportCode = "007", ReportName = "007: Children with Disabilities (IDEA) Reasons for Unilateral Removal", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 17, ReportCode = "006", ReportName = "006: Children with Disabilities (IDEA) Suspensions/Expulsions", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 18, ReportCode = "005", ReportName = "005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 19, ReportCode = "002", ReportName = "002: Children with Disabilities (IDEA) School Age", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 20, ReportCode = "studentswdtitle1", ReportName = "Student Count by SWD in Title I Schools", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 21, ReportCode = "studentcount", ReportName = "Student Count Totals", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 22, ReportCode = "studentdiscipline", ReportName = "Student Count by Disciplinary Action", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 23, ReportCode = "studentdisability", ReportName = "Student Count by Primary Disability Type", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 24, ReportCode = "studentsubpopulation", ReportName = "Student Count by Subpopulation", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 25, ReportCode = "studentrace", ReportName = "Student Count by Race/Ethnicity", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 26, ReportCode = "070", ReportName = "070: Special Education Teachers (FTE)", FactTableId = 4, });
            data.Add(new GenerateReport() { GenerateReportId = 27, ReportCode = "indicator10", ReportName = "Indicator 10: Disproportionate Representation in Specific Disability Categories", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 31, ReportCode = "exitspecialeducation", ReportName = "Exit From Special Education", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 32, ReportCode = "cohortgraduationrate", ReportName = "Cohort Graduation Rate", FactTableId = 5, });
            data.Add(new GenerateReport() { GenerateReportId = 33, ReportCode = "studentfederalprogramsparticipation", ReportName = "Students Participating in Federal Programs", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 34, ReportCode = "studentmultifedprogsparticipation", ReportName = "Students Participating in Multiple Federal Programs", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 35, ReportCode = "disciplinaryremovals", ReportName = "Disciplinary Removals of Children with Disabilities (IDEA) Ages 3-21", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 36, ReportCode = "stateassessmentsperformance", ReportName = "Proficiency Level of Students by Grade", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 37, ReportCode = "edenvironmentdisabilitiesage3-5", ReportName = "Preschoolers with Disabilities in Each Educational Environment", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 38, ReportCode = "edenvironmentdisabilitiesage6-21", ReportName = "School Age Students with Disabilities in Each Educational Environment", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 39, ReportCode = "029", ReportName = "029: Directory", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 40, ReportCode = "032", ReportName = "032: Dropouts", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 41, ReportCode = "033", ReportName = "033: Free and Reduced Price Lunch", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 42, ReportCode = "036", ReportName = "036: Title I Part A TAS Services", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 43, ReportCode = "037", ReportName = "037: Title I Part A SWP/TAS Participation", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 44, ReportCode = "039", ReportName = "039: Grades Offered", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 45, ReportCode = "040", ReportName = "040: Graduates/Completers", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 46, ReportCode = "052", ReportName = "052: Membership", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 47, ReportCode = "054", ReportName = "054: MEP Students Served - 12 Month ", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 48, ReportCode = "059", ReportName = "059: Staff FTE", FactTableId = 4, });
            data.Add(new GenerateReport() { GenerateReportId = 49, ReportCode = "065", ReportName = "065: Federally Funded Staff", FactTableId = 4, });
            data.Add(new GenerateReport() { GenerateReportId = 50, ReportCode = "121", ReportName = "121: Migratory Students Eligible - 12 Months", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 51, ReportCode = "122", ReportName = "122: MEP Students Eligible and Served - Summer/Intersession", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 52, ReportCode = "129", ReportName = "129: CCD School", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 53, ReportCode = "134", ReportName = "134: Title I Part A Participation", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 54, ReportCode = "141", ReportName = "141: EL Enrolled", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 55, ReportCode = "145", ReportName = "145: MEP Services", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 56, ReportCode = "165", ReportName = "165: Migratory Data", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 57, ReportCode = "193", ReportName = "193: Title I Allocations", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 58, ReportCode = "045", ReportName = "045: Immigrant", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 59, ReportCode = "050", ReportName = "050: Title III English Language Proficiency Results", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 60, ReportCode = "067", ReportName = "067: Title III Teachers", FactTableId = 4, });
            data.Add(new GenerateReport() { GenerateReportId = 61, ReportCode = "086", ReportName = "086: Students Involved with Firearms", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 62, ReportCode = "103", ReportName = "103: Accountability", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 63, ReportCode = "113", ReportName = "113: N or D Academic Achievement - State Agency", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 64, ReportCode = "116", ReportName = "116: Title III Students Served", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 65, ReportCode = "118", ReportName = "118: Homeless Students Enrolled", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 66, ReportCode = "119", ReportName = "119: Neglected or Delinquent Participation (SEA)", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 67, ReportCode = "125", ReportName = "125: N or D Academic Achievement - LEA", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 68, ReportCode = "126", ReportName = "126: Title III Former EL Students", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 69, ReportCode = "127", ReportName = "127: N or D - Participation (LEA)", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 70, ReportCode = "131", ReportName = "131: LEA End of School Year Status", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 71, ReportCode = "132", ReportName = "132: Section 1003 Funds", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 72, ReportCode = "137", ReportName = "137: English Language Proficiency Test", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 73, ReportCode = "138", ReportName = "138: Title III English Language Proficiency Test", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 74, ReportCode = "139", ReportName = "139: English Language Proficiency Results", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 75, ReportCode = "150", ReportName = "150: Adjusted-Cohort Graduation Rate", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 76, ReportCode = "151", ReportName = "151: Cohorts for Adjusted-Cohort Graduation Rate", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 77, ReportCode = "160", ReportName = "160: High School Graduates Postsecondary Enrollment", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 78, ReportCode = "163", ReportName = "163: Discipline Data", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 79, ReportCode = "167", ReportName = "167: School Improvement Grants", FactTableId = null, });
            data.Add(new GenerateReport() { GenerateReportId = 80, ReportCode = "170", ReportName = "170: LEA Subgrant Status", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 81, ReportCode = "179", ReportName = "179: Academic Achievement in Science", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 82, ReportCode = "180", ReportName = "180: N or D In Program Outcomes", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 83, ReportCode = "181", ReportName = "181: N or D Exited Programs Outcomes", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 84, ReportCode = "189", ReportName = "189: Assessment Participation in Science", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 85, ReportCode = "192", ReportName = "192: MEP Students Priority for Services", FactTableId = null, });
            data.Add(new GenerateReport() { GenerateReportId = 86, ReportCode = "082", ReportName = "082: CTE Concentrators Exiting", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 87, ReportCode = "083", ReportName = "083: CTE Concentrators Graduates", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 88, ReportCode = "142", ReportName = "142: CTE Concentrators Academic Achievement", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 89, ReportCode = "154", ReportName = "154: CTE Concentrators in Graduation Rate", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 90, ReportCode = "155", ReportName = "155: CTE Participants in Programs for Non-Traditional", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 91, ReportCode = "156", ReportName = "156:  CTE Concentrators NonTraditional", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 92, ReportCode = "157", ReportName = "157: CTE Concentrators Technical Skills", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 93, ReportCode = "158", ReportName = "158: CTE Concentrators Placement", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 94, ReportCode = "169", ReportName = "169: CTE Type of Placement", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 95, ReportCode = "130", ReportName = "130: ESEA Status", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 96, ReportCode = "190", ReportName = "190: Charter Authorizer Directory", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 97, ReportCode = "196", ReportName = "196: Management Organizations Directory", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 98, ReportCode = "197", ReportName = "197: Crosswalk of Charter Schools to Management Organizations", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 99, ReportCode = "198", ReportName = "198: Charter Contracts", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 100, ReportCode = "194", ReportName = "194: Young Homeless Children Served (McKinney-Vento)", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 101, ReportCode = "195", ReportName = "195: Chronic Absenteeism", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 102, ReportCode = "199", ReportName = "199: Graduation Rate Indicator Status", FactTableId = 7, });
            data.Add(new GenerateReport() { GenerateReportId = 103, ReportCode = "200", ReportName = "200: Academic Achievement Indicator Status", FactTableId = 7, });
            data.Add(new GenerateReport() { GenerateReportId = 104, ReportCode = "201", ReportName = "201: Other Academic Indicator Status", FactTableId = 7, });
            data.Add(new GenerateReport() { GenerateReportId = 105, ReportCode = "202", ReportName = "202: School Quality or Student Success Indicator Status", FactTableId = 7, });
            data.Add(new GenerateReport() { GenerateReportId = 106, ReportCode = "203", ReportName = "203: Teachers", FactTableId = 4, });
            data.Add(new GenerateReport() { GenerateReportId = 107, ReportCode = "204", ReportName = "204: Title III English Learners", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 108, ReportCode = "205", ReportName = "205: Progress Achieving English Language Proficiency Indicator Status ", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 109, ReportCode = "206", ReportName = "206: School Support and Improvement", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 110, ReportCode = "yeartoyearchildcount", ReportName = "Year to Year Child Count Report", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 111, ReportCode = "yeartoyearenvironmentcount", ReportName = "Year to Year Change - Special Education Child Count Environments", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 112, ReportCode = "yeartoyearexitcount", ReportName = "Year to Year Student Exit Report", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 113, ReportCode = "studentssummary", ReportName = "LEA Students Summary Profile", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 114, ReportCode = "yeartoyearremovalcount", ReportName = "Year to Year Student Removal Report", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 115, ReportCode = "035", ReportName = "035: Federal Programs", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 116, ReportCode = "yeartoyearprogress", ReportName = "Year-to-Year Progress in Reading and Math", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 117, ReportCode = "yeartoyearattendance", ReportName = "Student Drop-out Attendance Patterns and Proficiency Levels in Math and Reading", FactTableId = 3, });

            return data;

        }
    }
}
 