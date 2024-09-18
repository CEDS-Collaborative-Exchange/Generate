using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.App;

namespace generate.core.Helpers.ReferenceData
{
    public class TableTypeHelper
    {
        public static List<TableType> GetData()
        {

            /*
            select 'data.Add(new TableType() { 
            TableTypeId = ' + convert(varchar(20), TableTypeId) + ',
            TableTypeAbbrv = "' + TableTypeAbbrv + '",
            TableTypeName = "' + TableTypeName + '"
            });'
            from App.TableTypes
            */

            var data = new List<TableType>();

            data.Add(new TableType() { TableTypeId = 275, TableTypeAbbrv = "IDEADISAB", TableTypeName = "Children with Disabilities (IDEA) School Age Tables" });
            data.Add(new TableType() { TableTypeId = 276, TableTypeAbbrv = "CHDISDSPL", TableTypeName = "Children with Disabilities (IDEA) Removal Table" });
            data.Add(new TableType() { TableTypeId = 277, TableTypeAbbrv = "IDEASUSEXPL", TableTypeName = "Children with Disabilities (IDEA) Suspensions/Expulsions Table" });
            data.Add(new TableType() { TableTypeId = 278, TableTypeAbbrv = "IDEAREMOV", TableTypeName = "Children with Disabilities (IDEA) Reasons for Unilateral Removal Table" });
            data.Add(new TableType() { TableTypeId = 279, TableTypeAbbrv = "IDEAEXITSPED", TableTypeName = "Children with Disabilities (IDEA) Exiting Special Education Tables" });
            data.Add(new TableType() { TableTypeId = 280, TableTypeAbbrv = "DROPOUTCNT", TableTypeName = "Dropouts Table" });
            data.Add(new TableType() { TableTypeId = 281, TableTypeAbbrv = "DIRECTCERT", TableTypeName = "Direct Certification" });
            data.Add(new TableType() { TableTypeId = 282, TableTypeAbbrv = "LUNCHFREERED", TableTypeName = "Free and Reduced Price Lunch Table" });
            data.Add(new TableType() { TableTypeId = 283, TableTypeAbbrv = "TRGTASSPROGPART", TableTypeName = "Title I TAS Student Participation Table" });
            data.Add(new TableType() { TableTypeId = 284, TableTypeAbbrv = "TITLEIPART", TableTypeName = "Title I  Participation Tables" });
            data.Add(new TableType() { TableTypeId = 285, TableTypeAbbrv = "GRADCNT", TableTypeName = "Graduates/Completers Tables" });
            data.Add(new TableType() { TableTypeId = 286, TableTypeAbbrv = "IMMIGRNT", TableTypeName = "Immigrant Table" });
            data.Add(new TableType() { TableTypeId = 287, TableTypeAbbrv = "LEPENGPROFTST", TableTypeName = "Title III LEP English language proficiency results table" });
            data.Add(new TableType() { TableTypeId = 288, TableTypeAbbrv = "MEMBER", TableTypeName = "Student Membership Table" });
            data.Add(new TableType() { TableTypeId = 289, TableTypeAbbrv = "MIGRNTSERV", TableTypeName = "Migrant Students Served Tables" });
            data.Add(new TableType() { TableTypeId = 290, TableTypeAbbrv = "CLASSTEACHFTE", TableTypeName = "Classroom Teachers (FTE)" });
            data.Add(new TableType() { TableTypeId = 291, TableTypeAbbrv = "FTESTAFF", TableTypeName = "Staff FTE Tables" });
            data.Add(new TableType() { TableTypeId = 292, TableTypeAbbrv = "MEPERS", TableTypeName = "MEP Personnel (Headcount) Table" });
            data.Add(new TableType() { TableTypeId = 293, TableTypeAbbrv = "MEPFTE", TableTypeName = "MEP Personnel (FTE) Table" });
            data.Add(new TableType() { TableTypeId = 294, TableTypeAbbrv = "TITLEISTFTASFD", TableTypeName = "TAS Staff Funded by Title I Table" });
            data.Add(new TableType() { TableTypeId = 295, TableTypeAbbrv = "TEACHCERTLEP", TableTypeName = "Title III Teachers Table" });
            data.Add(new TableType() { TableTypeId = 296, TableTypeAbbrv = "TEACHLEPNCERT", TableTypeName = "Teachers in LEP Programs Not Certified or Endorsed" });
            data.Add(new TableType() { TableTypeId = 297, TableTypeAbbrv = "TEACHSPED", TableTypeName = "Special Education Teachers (FTE) Table" });
            data.Add(new TableType() { TableTypeId = 298, TableTypeAbbrv = "CHWDSBDSPACT", TableTypeName = "Children with Disabilities (IDEA) Disciplinary Removals Table" });
            data.Add(new TableType() { TableTypeId = 299, TableTypeAbbrv = "CHWDSBERLCHD", TableTypeName = "Children with Disabilities (IDEA) Early Childhood Tables" });
            data.Add(new TableType() { TableTypeId = 300, TableTypeAbbrv = "SPEDUPERSNL", TableTypeName = "Special Education Personnel Tables" });
            data.Add(new TableType() { TableTypeId = 301, TableTypeAbbrv = "SPEDPARAPROF", TableTypeName = "Special Education Paraprofessionals Tables" });
            data.Add(new TableType() { TableTypeId = 302, TableTypeAbbrv = "TTLIIILEPSTDSRV", TableTypeName = "Title III LEP Students Served" });
            data.Add(new TableType() { TableTypeId = 303, TableTypeAbbrv = "MEPSTUDELIG", TableTypeName = "MEP Students Eligible" });
            data.Add(new TableType() { TableTypeId = 304, TableTypeAbbrv = "MEPSTUDELIGSERV", TableTypeName = "MEP Students Eligible and Served" });
            data.Add(new TableType() { TableTypeId = 305, TableTypeAbbrv = "LEPFORSTU", TableTypeName = "Title III Former Students Tables" });
            data.Add(new TableType() { TableTypeId = 306, TableTypeAbbrv = "PARTTITLEI", TableTypeName = "Title I Participation Tables" });
            data.Add(new TableType() { TableTypeId = 307, TableTypeAbbrv = "LEPENGLANGTST", TableTypeName = "LEP English Language" });
            data.Add(new TableType() { TableTypeId = 308, TableTypeAbbrv = "TITLEIIILEPTST", TableTypeName = "Title III LEP English Language Testing File Specification" });
            data.Add(new TableType() { TableTypeId = 309, TableTypeAbbrv = "LEPSTUENGPROF", TableTypeName = "LEP - English Language Proficiency Results Table" });
            data.Add(new TableType() { TableTypeId = 310, TableTypeAbbrv = "LEPENROLLED", TableTypeName = "LEP Enrolled File Specifications" });
            data.Add(new TableType() { TableTypeId = 311, TableTypeAbbrv = "CWDTOTDISREM", TableTypeName = "Children with Disabilities (IDEA) Total Disciplinary Removals Table" });
            data.Add(new TableType() { TableTypeId = 312, TableTypeAbbrv = "EDUSERVICES", TableTypeName = "Educational Services Table" });
            data.Add(new TableType() { TableTypeId = 313, TableTypeAbbrv = "MEPSERVICES", TableTypeName = "MEP Services" });
            data.Add(new TableType() { TableTypeId = 314, TableTypeAbbrv = "MIGRNTELIG", TableTypeName = "Migrant Students Eligible Tables" });
            data.Add(new TableType() { TableTypeId = 315, TableTypeAbbrv = "STUDPERFM", TableTypeName = "Student Performance Table - Math" });
            data.Add(new TableType() { TableTypeId = 316, TableTypeAbbrv = "STUDPERFLANG", TableTypeName = "Student Performance Table - Language Arts" });
            data.Add(new TableType() { TableTypeId = 317, TableTypeAbbrv = "STUDPERFREAD", TableTypeName = "Student Performance Table - Reading " });
            data.Add(new TableType() { TableTypeId = 318, TableTypeAbbrv = "STUDPERFRLA", TableTypeName = "Student Performance Table - Reading/Language Arts" });
            data.Add(new TableType() { TableTypeId = 319, TableTypeAbbrv = "STUDPERFS", TableTypeName = "Student Performance Table - Science" });
            data.Add(new TableType() { TableTypeId = 320, TableTypeAbbrv = "STUDPERFTEST", TableTypeName = "Students Tested Tables" });
            data.Add(new TableType() { TableTypeId = 321, TableTypeAbbrv = "STUPARTMATH", TableTypeName = "Assessment participation in mathematics table" });
            data.Add(new TableType() { TableTypeId = 322, TableTypeAbbrv = "STUPARTRLA", TableTypeName = "Assessment participation in reading/language arts table" });
            data.Add(new TableType() { TableTypeId = 323, TableTypeAbbrv = "STUPARTSCI", TableTypeName = "STUPARTSCI" });
            data.Add(new TableType() { TableTypeId = 324, TableTypeAbbrv = "PARINRES", TableTypeName = "Parental involvement reservation" });
            data.Add(new TableType() { TableTypeId = 325, TableTypeAbbrv = "TITLEIPALL", TableTypeName = "Title I, Part A Allocation" });
            data.Add(new TableType() { TableTypeId = 326, TableTypeAbbrv = "VOCED ", TableTypeName = "Vocational Concentrators Tables" });
            data.Add(new TableType() { TableTypeId = 327, TableTypeAbbrv = "VOCEDGRAD", TableTypeName = "Vocational Concentrator Graduates Tables" });
            data.Add(new TableType() { TableTypeId = 328, TableTypeAbbrv = "CTECONACAD", TableTypeName = "Concentrators Academic Attainment Table" });
            data.Add(new TableType() { TableTypeId = 329, TableTypeAbbrv = "CTECONGR", TableTypeName = "CTE Concentrators in Graduation Rate Table" });
            data.Add(new TableType() { TableTypeId = 330, TableTypeAbbrv = "CTENTPAT", TableTypeName = "CTE Participants in Programs for Non-Traditional Table" });
            data.Add(new TableType() { TableTypeId = 331, TableTypeAbbrv = "CTECONPRGNT", TableTypeName = "CTE Concentrators in Programs for Non-Traditional Table" });
            data.Add(new TableType() { TableTypeId = 332, TableTypeAbbrv = "CTECONTS", TableTypeName = "CTE Concentrators Technical Skills Table" });
            data.Add(new TableType() { TableTypeId = 333, TableTypeAbbrv = "CTECONP", TableTypeName = "CTE Concentrators Placement Table" });
            data.Add(new TableType() { TableTypeId = 334, TableTypeAbbrv = "CTEPLACETYPE", TableTypeName = "CTE concentrators placement type table" });
            data.Add(new TableType() { TableTypeId = 335, TableTypeAbbrv = "T3ELEXIT", TableTypeName = "Title III English learners exited" });
            data.Add(new TableType() { TableTypeId = 336, TableTypeAbbrv = "T3ELNOTPROF", TableTypeName = "Title III English learners not proficient within five years" });
            data.Add(new TableType() { TableTypeId = 337, TableTypeAbbrv = "PROGENGLANSTATUS", TableTypeName = "Progress achieving English language proficiency indicator status" });
            data.Add(new TableType() { TableTypeId = 338, TableTypeAbbrv = "HOMLESENROLCNT", TableTypeName = "Homeless Students Enrolled - School Year Count" });
            data.Add(new TableType() { TableTypeId = 339, TableTypeAbbrv = "ECOCIRCUM ", TableTypeName = "Students Economic Circumstance" });
            data.Add(new TableType() { TableTypeId = 340, TableTypeAbbrv = "IMPFUNDALLOCA", TableTypeName = "School Improvement Funds Allocation - 1003(a)" });
            data.Add(new TableType() { TableTypeId = 341, TableTypeAbbrv = "IMPFUNDALLOCG", TableTypeName = "School Improvement Funds Allocation - 1003(g)" });
            data.Add(new TableType() { TableTypeId = 342, TableTypeAbbrv = "POVERTYPER", TableTypeName = "Poverty Percent" });
            data.Add(new TableType() { TableTypeId = 343, TableTypeAbbrv = "HSGRDPSENROLL", TableTypeName = "HS graduates postsecondary enrollment table" });
            data.Add(new TableType() { TableTypeId = 344, TableTypeAbbrv = "MEPPRIORITYSRV", TableTypeName = "MEP Students Priority For Services Table" });
            data.Add(new TableType() { TableTypeId = 345, TableTypeAbbrv = "HOMEMVENTOPKS", TableTypeName = "Young homeless children served (McKinney-Vento) table " });
            data.Add(new TableType() { TableTypeId = 346, TableTypeAbbrv = "CHRONABSENT", TableTypeName = "Chronic absenteeism table" });
            data.Add(new TableType() { TableTypeId = 347, TableTypeAbbrv = "GRADRATESTATUS", TableTypeName = "Graduation rate indicator status table" });
            data.Add(new TableType() { TableTypeId = 348, TableTypeAbbrv = "ACADACHSTATUS", TableTypeName = "Academic achievement indicator status table" });
            data.Add(new TableType() { TableTypeId = 349, TableTypeAbbrv = "OTHACADSTATUS", TableTypeName = "Other academic indicator status table" });
            data.Add(new TableType() { TableTypeId = 350, TableTypeAbbrv = "SCHQUALSTAT", TableTypeName = "School quality or student success indicator status table" });
            data.Add(new TableType() { TableTypeId = 351, TableTypeAbbrv = "TEACHER", TableTypeName = "Teachers table" });
            data.Add(new TableType() { TableTypeId = 352, TableTypeAbbrv = "NDACADOCOMESEA", TableTypeName = "Neglected or Delinquent Academic Outcomes (SEA)" });
            data.Add(new TableType() { TableTypeId = 353, TableTypeAbbrv = "NDPARTICSEA", TableTypeName = "Neglected or Delinquent Participation (SEA)" });
            data.Add(new TableType() { TableTypeId = 354, TableTypeAbbrv = "NDACADOCOMELEA", TableTypeName = "Neglected or Delinquent Academic Outcomes (LEA)" });
            data.Add(new TableType() { TableTypeId = 355, TableTypeAbbrv = "NDPARTICLEA", TableTypeName = "Neglected or Delinquent Participation (LEA)" });
            data.Add(new TableType() { TableTypeId = 356, TableTypeAbbrv = "GRADRT4YRADJ", TableTypeName = "Four-year adjusted-cohort graduation rate table" });
            data.Add(new TableType() { TableTypeId = 357, TableTypeAbbrv = "GRADRT5YRADJ", TableTypeName = "Five-year adjusted-cohort graduation rate table" });
            data.Add(new TableType() { TableTypeId = 358, TableTypeAbbrv = "GRADRT6YRADJ", TableTypeName = "Six-year adjusted-cohort graduation rate table" });
            data.Add(new TableType() { TableTypeId = 359, TableTypeAbbrv = "GRADCOHORT4YR", TableTypeName = "Cohorts for regulatory four-year adjusted-cohort graduation rate table" });
            data.Add(new TableType() { TableTypeId = 360, TableTypeAbbrv = "GRADCOHORT5YR", TableTypeName = "Cohorts for regulatory extended year adjusted-cohort graduation rate table" });
            data.Add(new TableType() { TableTypeId = 361, TableTypeAbbrv = "GRADCOHORT6YR", TableTypeName = "Cohorts for regulatory six-year adjusted-cohort graduation rate table" });
            data.Add(new TableType() { TableTypeId = 362, TableTypeAbbrv = "LEANDINPROG", TableTypeName = "N or D academic and vocational outcomes in programs table- LEA" });
            data.Add(new TableType() { TableTypeId = 363, TableTypeAbbrv = "SEANDINPROG", TableTypeName = "N or D academic and vocational outcomes in programs table- State Agency" });
            data.Add(new TableType() { TableTypeId = 364, TableTypeAbbrv = "LEANDEXIT", TableTypeName = "N or D academic and vocational outcomes exited programs - LEA" });
            data.Add(new TableType() { TableTypeId = 365, TableTypeAbbrv = "SEANDEXIT", TableTypeName = "N or D academic and vocational outcomes exited programs û state agency" });
            data.Add(new TableType() { TableTypeId = 366, TableTypeAbbrv = "CHLINVWFRARM", TableTypeName = "Students involved with firearms table" });
            data.Add(new TableType() { TableTypeId = 367, TableTypeAbbrv = "SCHOOLSUPIMPV", TableTypeName = "School Support and Improvement" });
            data.Add(new TableType() { TableTypeId = 368, TableTypeAbbrv = "TTLIIILIEPSTDSRV", TableTypeName = "Title III students served in English language instruction program table" });
            data.Add(new TableType() { TableTypeId = 369, TableTypeAbbrv = "NCLBEND", TableTypeName = "GFSA reporting status" });
            data.Add(new TableType() { TableTypeId = 370, TableTypeAbbrv = "GRADRT10YRADJ", TableTypeName = "Ten-year adjusted-cohort graduation rate table" });
            data.Add(new TableType() { TableTypeId = 371, TableTypeAbbrv = "GRADRT7YRADJ", TableTypeName = "Seven-year adjusted-cohort graduation rate table" });
            data.Add(new TableType() { TableTypeId = 372, TableTypeAbbrv = "GRADRT8YRADJ", TableTypeName = "Eight-year adjusted-cohort graduation rate table" });
            data.Add(new TableType() { TableTypeId = 373, TableTypeAbbrv = "GRADRT9YRADJ", TableTypeName = "Nine-year adjusted-cohort graduation rate table" });
            data.Add(new TableType() { TableTypeId = 374, TableTypeAbbrv = "GRADCOHORT10YR", TableTypeName = "Cohorts for regulatory ten-year adjusted-cohort graduation rate table" });
            data.Add(new TableType() { TableTypeId = 375, TableTypeAbbrv = "GRADCOHORT7YR", TableTypeName = "Cohorts for regulatory seven-year adjusted-cohort graduation rate table" });
            data.Add(new TableType() { TableTypeId = 376, TableTypeAbbrv = "GRADCOHORT8YR", TableTypeName = "Cohorts for regulatory eight-year adjusted-cohort graduation rate table" });
            data.Add(new TableType() { TableTypeId = 377, TableTypeAbbrv = "GRADCOHORT9YR", TableTypeName = "Cohorts for regulatory nine-year adjusted-cohort graduation rate table" });
            data.Add(new TableType() { TableTypeId = 378, TableTypeAbbrv = "CSIREASONS", TableTypeName = "Comprehensive support identification table" });
            data.Add(new TableType() { TableTypeId = 379, TableTypeAbbrv = "TSIREASONS", TableTypeName = "Targeted support identification table" });

            return data;

        }
    }
}
 