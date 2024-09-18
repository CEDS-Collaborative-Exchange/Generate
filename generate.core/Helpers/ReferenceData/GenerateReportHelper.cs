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
            data.Add(new GenerateReport() { GenerateReportId = 4, ReportCode = "c188", ReportName = "C188: Assessment Participation in Reading/Language Arts", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 5, ReportCode = "c185", ReportName = "C185: Assessment Participation in Mathematics", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 6, ReportCode = "c178", ReportName = "C178: Academic Achievement in Reading (Language Arts)", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 7, ReportCode = "c175", ReportName = "C175: Academic Achievement in Mathematics", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 8, ReportCode = "c144", ReportName = "C144: Educational Services During Expulsion", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 9, ReportCode = "c143", ReportName = "C143: Children with Disabilities (IDEA) Total Disciplinary Removals", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 10, ReportCode = "c112", ReportName = "C112: Special Education Paraprofessionals", FactTableId = 4, });
            data.Add(new GenerateReport() { GenerateReportId = 11, ReportCode = "c099", ReportName = "C099: Special Education Related Services Personnel", FactTableId = 4, });
            data.Add(new GenerateReport() { GenerateReportId = 12, ReportCode = "c089", ReportName = "C089: Children with Disabilities (IDEA) Early Childhood", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 13, ReportCode = "indicator9", ReportName = "Indicator 9: Disproportionate Representation", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 14, ReportCode = "c088", ReportName = "C088: Children with Disabilities (IDEA) Disciplinary Removals", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 15, ReportCode = "c009", ReportName = "C009: Children with Disabilities (IDEA) Exiting Special Education", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 16, ReportCode = "c007", ReportName = "C007: Children with Disabilities (IDEA) Reasons for Unilateral Removal", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 17, ReportCode = "c006", ReportName = "C006: Children with Disabilities (IDEA) Suspensions/Expulsions", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 18, ReportCode = "c005", ReportName = "C005: Children with Disabilities (IDEA) Removal to Interim Alternative Educational Setting", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 19, ReportCode = "c002", ReportName = "C002: Children with Disabilities (IDEA) School Age", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 20, ReportCode = "studentswdtitle1", ReportName = "Student Count by SWD in Title I Schools", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 21, ReportCode = "studentcount", ReportName = "Student Count Totals", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 22, ReportCode = "studentdiscipline", ReportName = "Student Count by Disciplinary Action", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 23, ReportCode = "studentdisability", ReportName = "Student Count by Primary Disability Type", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 24, ReportCode = "studentsubpopulation", ReportName = "Student Count by Subpopulation", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 25, ReportCode = "studentrace", ReportName = "Student Count by Race/Ethnicity", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 26, ReportCode = "c070", ReportName = "C070: Special Education Teachers (FTE)", FactTableId = 4, });
            data.Add(new GenerateReport() { GenerateReportId = 27, ReportCode = "indicator10", ReportName = "Indicator 10: Disproportionate Representation in Specific Disability Categories", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 31, ReportCode = "exitspecialeducation", ReportName = "Exit From Special Education", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 32, ReportCode = "cohortgraduationrate", ReportName = "Cohort Graduation Rate", FactTableId = 5, });
            data.Add(new GenerateReport() { GenerateReportId = 33, ReportCode = "studentfederalprogramsparticipation", ReportName = "Students Participating in Federal Programs", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 34, ReportCode = "studentmultifedprogsparticipation", ReportName = "Students Participating in Multiple Federal Programs", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 35, ReportCode = "disciplinaryremovals", ReportName = "Disciplinary Removals of Children with Disabilities (IDEA) Ages 3-21", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 36, ReportCode = "stateassessmentsperformance", ReportName = "Proficiency Level of Students by Grade", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 37, ReportCode = "edenvironmentdisabilitiesage3-5", ReportName = "Preschoolers with Disabilities in Each Educational Environment", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 38, ReportCode = "edenvironmentdisabilitiesage6-21", ReportName = "School Age Students with Disabilities in Each Educational Environment", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 39, ReportCode = "c029", ReportName = "C029: Directory", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 40, ReportCode = "c032", ReportName = "C032: Dropouts", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 41, ReportCode = "c033", ReportName = "C033: Free and Reduced Price Lunch", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 42, ReportCode = "c036", ReportName = "C036: Title I Part A TAS Services", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 43, ReportCode = "c037", ReportName = "C037: Title I Part A SWP/TAS Participation", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 44, ReportCode = "c039", ReportName = "C039: Grades Offered", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 45, ReportCode = "c040", ReportName = "C040: Graduates/Completers", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 46, ReportCode = "c052", ReportName = "C052: Membership", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 47, ReportCode = "c054", ReportName = "C054: MEP Students Served - 12 Month ", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 48, ReportCode = "c059", ReportName = "C059: Staff FTE", FactTableId = 4, });
            data.Add(new GenerateReport() { GenerateReportId = 49, ReportCode = "c065", ReportName = "C065: Federally Funded Staff", FactTableId = 4, });
            data.Add(new GenerateReport() { GenerateReportId = 50, ReportCode = "c121", ReportName = "C121: Migratory Students Eligible - 12 Months", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 51, ReportCode = "c122", ReportName = "C122: MEP Students Eligible and Served - Summer/Intersession", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 52, ReportCode = "c129", ReportName = "C129: CCD School", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 53, ReportCode = "c134", ReportName = "C134: Title I Part A Participation", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 54, ReportCode = "c141", ReportName = "C141: EL Enrolled", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 55, ReportCode = "c145", ReportName = "C145: MEP Services", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 56, ReportCode = "c165", ReportName = "C165: Migratory Data", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 57, ReportCode = "c193", ReportName = "C193: Title I Allocations", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 58, ReportCode = "c045", ReportName = "C045: Immigrant", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 59, ReportCode = "c050", ReportName = "C050: Title III English Language Proficiency Results", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 60, ReportCode = "c067", ReportName = "C067: Title III Teachers", FactTableId = 4, });
            data.Add(new GenerateReport() { GenerateReportId = 61, ReportCode = "c086", ReportName = "C086: Students Involved with Firearms", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 62, ReportCode = "c103", ReportName = "C103: Accountability", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 63, ReportCode = "c113", ReportName = "C113: N or D Academic Achievement - State Agency", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 64, ReportCode = "c116", ReportName = "C116: Title III Students Served", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 65, ReportCode = "c118", ReportName = "C118: Homeless Students Enrolled", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 66, ReportCode = "c119", ReportName = "C119: Neglected or Delinquent Participation (SEA)", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 67, ReportCode = "c125", ReportName = "C125: N or D Academic Achievement - LEA", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 68, ReportCode = "c126", ReportName = "C126: Title III Former EL Students", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 69, ReportCode = "c127", ReportName = "C127: N or D - Participation (LEA)", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 70, ReportCode = "c131", ReportName = "C131: LEA End of School Year Status", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 71, ReportCode = "c132", ReportName = "C132: Section 1003 Funds", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 72, ReportCode = "c137", ReportName = "C137: English Language Proficiency Test", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 73, ReportCode = "c138", ReportName = "C138: Title III English Language Proficiency Test", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 74, ReportCode = "c139", ReportName = "C139: English Language Proficiency Results", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 75, ReportCode = "c150", ReportName = "C150: Adjusted-Cohort Graduation Rate", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 76, ReportCode = "c151", ReportName = "C151: Cohorts for Adjusted-Cohort Graduation Rate", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 77, ReportCode = "c160", ReportName = "C160: High School Graduates Postsecondary Enrollment", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 78, ReportCode = "c163", ReportName = "C163: Discipline Data", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 79, ReportCode = "c167", ReportName = "C167: School Improvement Grants", FactTableId = null, });
            data.Add(new GenerateReport() { GenerateReportId = 80, ReportCode = "c170", ReportName = "C170: LEA Subgrant Status", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 81, ReportCode = "c179", ReportName = "C179: Academic Achievement in Science", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 82, ReportCode = "c180", ReportName = "C180: N or D In Program Outcomes", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 83, ReportCode = "c181", ReportName = "C181: N or D Exited Programs Outcomes", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 84, ReportCode = "c189", ReportName = "C189: Assessment Participation in Science", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 85, ReportCode = "c192", ReportName = "C192: MEP Students Priority for Services", FactTableId = null, });
            data.Add(new GenerateReport() { GenerateReportId = 86, ReportCode = "c082", ReportName = "C082: CTE Concentrators Exiting", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 87, ReportCode = "c083", ReportName = "C083: CTE Concentrators Graduates", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 88, ReportCode = "c142", ReportName = "C142: CTE Concentrators Academic Achievement", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 89, ReportCode = "c154", ReportName = "C154: CTE Concentrators in Graduation Rate", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 90, ReportCode = "c155", ReportName = "C155: CTE Participants in Programs for Non-Traditional", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 91, ReportCode = "c156", ReportName = "C156:  CTE Concentrators NonTraditional", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 92, ReportCode = "c157", ReportName = "C157: CTE Concentrators Technical Skills", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 93, ReportCode = "c158", ReportName = "C158: CTE Concentrators Placement", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 94, ReportCode = "c169", ReportName = "C169: CTE Type of Placement", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 95, ReportCode = "c130", ReportName = "C130: ESEA Status", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 96, ReportCode = "c190", ReportName = "C190: Charter Authorizer Directory", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 97, ReportCode = "c196", ReportName = "C196: Management Organizations Directory", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 98, ReportCode = "c197", ReportName = "C197: Crosswalk of Charter Schools to Management Organizations", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 99, ReportCode = "c198", ReportName = "C198: Charter Contracts", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 100, ReportCode = "c194", ReportName = "C194: Young Homeless Children Served (McKinney-Vento)", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 101, ReportCode = "c195", ReportName = "C195: Chronic Absenteeism", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 102, ReportCode = "c199", ReportName = "C199: Graduation Rate Indicator Status", FactTableId = 7, });
            data.Add(new GenerateReport() { GenerateReportId = 103, ReportCode = "c200", ReportName = "C200: Academic Achievement Indicator Status", FactTableId = 7, });
            data.Add(new GenerateReport() { GenerateReportId = 104, ReportCode = "c201", ReportName = "C201: Other Academic Indicator Status", FactTableId = 7, });
            data.Add(new GenerateReport() { GenerateReportId = 105, ReportCode = "c202", ReportName = "C202: School Quality or Student Success Indicator Status", FactTableId = 7, });
            data.Add(new GenerateReport() { GenerateReportId = 106, ReportCode = "c203", ReportName = "C203: Teachers", FactTableId = 4, });
            data.Add(new GenerateReport() { GenerateReportId = 107, ReportCode = "c204", ReportName = "C204: Title III English Learners", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 108, ReportCode = "c205", ReportName = "C205: Progress Achieving English Language Proficiency Indicator Status ", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 109, ReportCode = "c206", ReportName = "C206: School Support and Improvement", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 110, ReportCode = "yeartoyearchildcount", ReportName = "Year to Year Child Count Report", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 111, ReportCode = "yeartoyearenvironmentcount", ReportName = "Year to Year Change - Special Education Child Count Environments", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 112, ReportCode = "yeartoyearexitcount", ReportName = "Year to Year Student Exit Report", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 113, ReportCode = "studentssummary", ReportName = "LEA Students Summary Profile", FactTableId = 1, });
            data.Add(new GenerateReport() { GenerateReportId = 114, ReportCode = "yeartoyearremovalcount", ReportName = "Year to Year Student Removal Report", FactTableId = 2, });
            data.Add(new GenerateReport() { GenerateReportId = 115, ReportCode = "c035", ReportName = "C035: Federal Programs", FactTableId = 6, });
            data.Add(new GenerateReport() { GenerateReportId = 116, ReportCode = "yeartoyearprogress", ReportName = "Year-to-Year Progress in Reading and Math", FactTableId = 3, });
            data.Add(new GenerateReport() { GenerateReportId = 117, ReportCode = "yeartoyearattendance", ReportName = "Student Drop-out Attendance Patterns and Proficiency Levels in Math and Reading", FactTableId = 3, });

            return data;

        }
    }
}
 