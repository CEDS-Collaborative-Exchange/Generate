using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Models.App;
using generate.core.Models.RDS;
using generate.infrastructure.Contexts;
using generate.shared.Utilities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace generate.infrastructure.Repositories.RDS
{
    public class FactReportRepository : IFactReportRepository
    {

        private readonly AppDbContext _appDbContext;
        private readonly RDSDbContext _rdsDbContext;

        public FactReportRepository(AppDbContext appDbContext, RDSDbContext rdsDbContext)
        {
            _appDbContext = appDbContext ?? throw new ArgumentNullException(nameof(appDbContext));
            _rdsDbContext = rdsDbContext ?? throw new ArgumentNullException(nameof(rdsDbContext));
        }

        #region Helper Methods

        public void LogDataMigrationHistory(string dataMigrationTypeCode, string dataMigrationHistoryMessage, bool logToDatabase = true)
        {

            Console.WriteLine(DateTime.Now + " - " + dataMigrationTypeCode + " - " + dataMigrationHistoryMessage);

            if (logToDatabase)
            {
                DataMigrationType dataMigrationType = _appDbContext.DataMigrationTypes.Where(s => s.DataMigrationTypeCode == dataMigrationTypeCode).FirstOrDefault();
                if (dataMigrationType != null)
                {
                    DataMigrationHistory historyRecord = new DataMigrationHistory()
                    {
                        DataMigrationHistoryDate = DateTime.UtcNow,
                        DataMigrationTypeId = dataMigrationType.DataMigrationTypeId,
                        DataMigrationHistoryMessage = dataMigrationHistoryMessage
                    };

                    _appDbContext.DataMigrationHistories.Add(historyRecord);

                    _appDbContext.SaveChanges();
                }
            }

        }

        #endregion

        #region FactStudentCountReport

        private IQueryable<FactK12StudentCount> FilterFactStudentCount(IQueryable<FactK12StudentCount> facts, string reportCode, List<string> excludeFilters)
        {
            if (reportCode == "045")
            {
                if (excludeFilters == null || !excludeFilters.Contains("age"))
                {
                    facts = facts.Where(x => x.DimAge.AgeValue >= 3 && x.DimAge.AgeValue <= 21);
                }
            }

            return facts;
        }

        private IQueryable<ReportEDFactsK12StudentCount> AggregateFactStudentCount(IQueryable<FactK12StudentCount> facts, string reportCode, string reportLevel, string reportYear, string categorySetCode, string categories, string tableTypeAbbrv)
        {
            // Define grouping key parts based on report level
            var isSEA = reportLevel == "sea";
            var isLEA = reportLevel == "lea";

            // Precompute fields for readability
            Func<dynamic, string> getOrgNcesId = x => isSEA ? x.DimSchool.StateAnsiCode :
                                                       isLEA ? x.DimSchool.LeaIdentifierNces :
                                                               x.DimSchool.SchoolIdentifierNces;

            Func<dynamic, string> getOrgStateId = x => isSEA ? x.DimSchool.SeaIdentifierState :
                                                            isLEA ? x.DimSchool.LeaIdentifierState :
                                                                    x.DimSchool.SchoolIdentifierState;

            Func<dynamic, string> getOrgName = x => isSEA ? x.DimSchool.SeaName :
                                                      isLEA ? x.DimSchool.LeaName :
                                                              x.DimSchool.NameOfInstitution;

            Func<dynamic, string?> getParentStateId = x => isSEA ? null :
                                                         isLEA ? x.DimSchool.SeaIdentifierState :
                                                                 x.DimSchool.LeaIdentifierState;

            var groupedFacts = facts
                .GroupBy(x => new
                {
                    x.DimSchool.StateAbbreviationCode,
                    x.DimSchool.StateAnsiCode,
                    x.DimSchool.StateAbbreviationDescription,
                    OrganizationNcesId = getOrgNcesId(x),
                    OrganizationStateId = getOrgStateId(x),
                    OrganizationName = getOrgName(x),
                    ParentOrganizationStateId = getParentStateId(x),
                    AGE = categories.Contains("|AGE|") ? x.DimAge.AgeEdFactsCode : null,
                    LEPSTATUS = categories.Contains("|LEPBOTH|") ? x.DimDemographic.EnglishLearnerStatusEdFactsCode : null,
                    LANGUAGE = categories.Contains("|LANGHOME|") ? x.DimLanguage.Iso6392LanguageEdFactsCode : null,
                    TITLEIIIPROGRAMPARTICIPATION = categories.Contains("|IMGRNTPROGPART|") ? x.DimProgramStatus.TitleiiiProgramParticipationEdFactsCode : null
                })
                .Select(g => new ReportEDFactsK12StudentCount
                {
                    ReportEDFactsK12StudentCountId = 0,
                    ReportCode = reportCode,
                    ReportLevel = reportLevel,
                    ReportYear = reportYear,
                    TableTypeAbbrv = tableTypeAbbrv,
                    Categories = categories,
                    CategorySetCode = categorySetCode,
                    StateAbbreviationCode = g.Key.StateAbbreviationCode,
                    StateANSICode = g.Key.StateAnsiCode,
                    StateAbbreviationDescription = g.Key.StateAbbreviationDescription,
                    OrganizationName = g.Key.OrganizationName,
                    OrganizationIdentifierNces = g.Key.OrganizationNcesId,
                    OrganizationIdentifierSea = g.Key.OrganizationStateId,
                    ParentOrganizationIdentifierSea = g.Key.ParentOrganizationStateId,
                    AGE = g.Key.AGE,
                    ENGLISHLEARNERSTATUS = g.Key.LEPSTATUS,
                    ISO6392LANGUAGECODE = g.Key.LANGUAGE,
                    TITLEIIIIMMIGRANTPARTICIPATIONSTATUS = g.Key.TITLEIIIPROGRAMPARTICIPATION,
                    TotalIndicator = categorySetCode.StartsWith("CS") ? "N" : "Y",
                    StudentCount = g.Sum(y => y.StudentCount)
                });

            return groupedFacts;

        }

        #endregion

        #region FactStudentDisciplineReport

        private IQueryable<FactK12StudentDiscipline> FilterFactStudentDiscipline(IQueryable<FactK12StudentDiscipline> facts, string reportCode, string categories, List<string> excludeFilters)
        {
            if (reportCode == "005" || reportCode == "007")
            {
                if (excludeFilters == null || !excludeFilters.Contains("disability"))
                {
                    // Report children with disabilities (IDEA) as defined in the EDFacts Workbook
                    facts = facts.Where(x => x.DimIdeaStatus.PrimaryDisabilityTypeId != -1);
                }

                if (excludeFilters == null || !excludeFilters.Contains("age"))
                {
                    // who were ages 3 through 21 as of the child count date 
                    facts = facts.Where(x => x.DimAge.AgeValue >= 3 && x.DimAge.AgeValue <= 21);
                }

                if (excludeFilters == null || !excludeFilters.Contains("ppps"))
                {
                    // Exclude parentally-placed private school students from this file.
                    facts = facts.Where(x => x.DimIdeaStatus.IdeaEducationalEnvironmentEdFactsCode != "PPPS");
                }

                //if (excludeFilters == null || !excludeFilters.Contains("lea_operationalstatus"))
                //{
                //    // Education units not reported - Closed, inactive, or future LEAs

                //    facts = from f in facts
                //            join f2 in _rdsDbContext.FactOrganizationCounts
                //            on new { f.DimLeaId, f.DimCountDateId } equals new { f2.DimLeaId, f2.DimCountDateId }
                //            where f2.di.OperationalStatusEdFactsCode != "Closed" &&
                //            f2.DimDirectoryStatus.OperationalStatusEdFactsCode != "Inactive" &&
                //            f2.DimDirectoryStatus.OperationalStatusEdFactsCode != "Future" &&
                //            f2.DimSchoolId == -1 &&
                //            f2.DimLeaId != -1
                //            select f;
                //}

                if (categories.Contains("LEPBOTH"))
                {                    
                    // Remove invalid LEPBOTH codes (should be handled by RDS migration)
                    // TODO: Would be better to only allow the valid options in that dimension
                    facts = facts.Where(x => x.DimDemographic.EnglishLearnerStatusEdFactsCode != "LEPP");
                }

                // TODO: Leave out LEAs that do not have counts to report

            }

            return facts;
        }


        private IQueryable<FactK12StudentDiscipline> ToggleFactStudentDiscipline(IQueryable<FactK12StudentDiscipline> facts, string reportCode, IEnumerable<string> toggleDisabilityCodes, List<string> excludeToggles)
        {
            if (reportCode == "005" || reportCode == "007")
            {
                if (excludeToggles == null || !excludeToggles.Contains("CHDCTDISCAT"))
                {
                    // Toggle by CHDCTDISCAT toggle response value (if exists)
                    if (toggleDisabilityCodes.Any())
                    {
                        facts = facts.Where(x => toggleDisabilityCodes.Contains(x.DimIdeaStatus.PrimaryDisabilityTypeEdFactsCode));
                    }
                }
            }

            return facts;
        }

        private IQueryable<ReportEDFactsK12StudentDiscipline> AggregateFactStudentDiscipline(IQueryable<FactK12StudentDiscipline> facts, string reportCode, string reportLevel, string reportYear, string categorySetCode, string categories, string tableTypeAbbrv)
        {
            // Category flags
            bool includeAGE = categories.Contains("|AGE|");
            bool includeDISABILITY = categories.Contains("|DISABCATIDEA|");
            bool includeLEPSTATUS = categories.Contains("|LEPBOTH|");
            bool includeREMOVALTYPE = categories.Contains("|REMOVALTYPE|");
            bool includeRACE = categories.Contains("|RACEETHNIC|");
            bool includeSEX = categories.Contains("|SEX|");
            bool includeTITLEIIIPROGRAMPARTICIPATION = categories.Contains("|IMGRNTPROGPART|");

            string totalIndicator = categorySetCode.StartsWith("CS") ? "N" : "Y";

            // Apply filtering by report level
            if (reportLevel == "sea" || reportLevel == "lea")
                facts = facts.Where(x => x.LeaId != -1);

            if (reportLevel == "sch")
                facts = facts.Where(x => x.K12SchoolId != -1);

            // Predefine grouping field selectors
            Func<dynamic, string> getOrgNcesId = x =>
                reportLevel == "sea" ? x.DimLea.StateAnsiCode :
                reportLevel == "lea" ? (x.DimLea.LeaIdentifierNces ?? "") :
                                       (x.DimSchool.SchoolIdentifierNces ?? "");

            Func<dynamic, string> getOrgStateId = x =>
                reportLevel == "sea" ? x.DimLea.SeaIdentifierState :
                reportLevel == "lea" ? x.DimLea.LeaIdentifierState :
                                       x.DimSchool.SchoolIdentifierState;

            Func<dynamic, string> getOrgName = x =>
                reportLevel == "sea" ? x.DimLea.SeaName :
                reportLevel == "lea" ? x.DimLea.LeaName :
                                       x.DimSchool.NameOfInstitution;

            Func<dynamic, string?> getParentOrgStateId = x =>
                reportLevel == "sea" ? null :
                reportLevel == "lea" ? x.DimLea.SeaIdentifierState :
                                       x.DimSchool.LeaIdentifierState;

            var groupedFacts = facts
                .GroupBy(x => new
                {
                    x.K12StudentId,
                    x.DimLea.StateAbbreviationCode,
                    x.DimLea.StateAnsiCode,
                    x.DimLea.StateAbbreviationDescription,
                    OrganizationNcesId = getOrgNcesId(x),
                    OrganizationStateId = getOrgStateId(x),
                    OrganizationName = getOrgName(x),
                    ParentOrganizationStateId = getParentOrgStateId(x),
                    AGE = includeAGE ? x.DimAge.AgeEdFactsCode : null,
                    DISABILITY = includeDISABILITY ? x.DimIdeaStatus.PrimaryDisabilityTypeEdFactsCode : null,
                    LEPSTATUS = includeLEPSTATUS ? x.DimDemographic.EnglishLearnerStatusEdFactsCode : null,
                    REMOVALTYPE = includeREMOVALTYPE ? x.DimDiscipline.IdeaInterimRemovalEdFactsCode : null,
                    RACE = includeRACE ? x.DimRace.RaceCode : null,
                    SEX = includeSEX ? x.DimStudent.SexEdFactsCode : null,
                    TITLEIIIPROGRAMPARTICIPATION = includeTITLEIIIPROGRAMPARTICIPATION ? x.DimProgramStatus.TitleiiiProgramParticipationEdFactsCode : null
                })
                .Select(g => new
                {
                    g.Key.StateAbbreviationCode,
                    g.Key.StateAnsiCode,
                    g.Key.StateAbbreviationDescription,
                    g.Key.OrganizationName,
                    g.Key.OrganizationNcesId,
                    g.Key.OrganizationStateId,
                    g.Key.ParentOrganizationStateId,
                    g.Key.AGE,
                    g.Key.DISABILITY,
                    g.Key.LEPSTATUS,
                    g.Key.REMOVALTYPE,
                    g.Key.RACE,
                    g.Key.SEX,
                    g.Key.TITLEIIIPROGRAMPARTICIPATION
                })
                .GroupBy(x => new
                {
                    x.StateAbbreviationCode,
                    x.StateAnsiCode,
                    x.StateAbbreviationDescription,
                    x.OrganizationName,
                    x.OrganizationNcesId,
                    x.OrganizationStateId,
                    x.ParentOrganizationStateId,
                    x.AGE,
                    x.DISABILITY,
                    x.LEPSTATUS,
                    x.REMOVALTYPE,
                    x.RACE,
                    x.SEX,
                    x.TITLEIIIPROGRAMPARTICIPATION
                })
                .Select(g => new ReportEDFactsK12StudentDiscipline
                {
                    ReportCode = reportCode,
                    ReportLevel = reportLevel,
                    ReportYear = reportYear,
                    TableTypeAbbrv = tableTypeAbbrv,
                    Categories = categories,
                    CategorySetCode = categorySetCode,
                    StateAbbreviationCode = g.Key.StateAbbreviationCode,
                    StateANSICode = g.Key.StateAnsiCode,
                    StateAbbreviationDescription = g.Key.StateAbbreviationDescription,
                    OrganizationName = g.Key.OrganizationName,
                    OrganizationIdentifierNces = g.Key.OrganizationNcesId,
                    OrganizationIdentifierSea = g.Key.OrganizationStateId,
                    ParentOrganizationIdentifierSea = g.Key.ParentOrganizationStateId,
                    AGE = g.Key.AGE,
                    IDEADISABILITYTYPE = g.Key.DISABILITY,
                    ENGLISHLEARNERSTATUS = g.Key.LEPSTATUS,
                    IDEAINTERIMREMOVAL = g.Key.REMOVALTYPE,
                    RACE = g.Key.RACE,
                    SEX = g.Key.SEX,
                    TITLEIIIIMMIGRANTPARTICIPATIONSTATUS = g.Key.TITLEIIIPROGRAMPARTICIPATION,
                    TotalIndicator = totalIndicator,
                    DisciplineCount = g.Count()
                });

            return groupedFacts;

        }

        private IQueryable<ReportEDFactsK12StudentDiscipline> RemoveMissingFactStudentDisciplines(IQueryable<ReportEDFactsK12StudentDiscipline> reports)
        {

            // Remove MISSING (unless all categories are missing)

            if (reports.Any(x => x.AGE != null && x.AGE != "MISSING" && x.DisciplineCount > 0))
            {
                reports = reports.Where(x => x.AGE != "MISSING");
            }
            if (reports.Any(x => x.IDEADISABILITYTYPE != null && x.IDEADISABILITYTYPE != "MISSING" && x.DisciplineCount > 0))
            {
                reports = reports.Where(x => x.IDEADISABILITYTYPE != "MISSING");
            }
            if (reports.Any(x => x.ENGLISHLEARNERSTATUS != null && x.ENGLISHLEARNERSTATUS != "MISSING" && x.DisciplineCount > 0))
            {
                reports = reports.Where(x => x.ENGLISHLEARNERSTATUS != "MISSING");
            }
            if (reports.Any(x => x.IDEAINTERIMREMOVAL != null && x.IDEAINTERIMREMOVAL != "MISSING" && x.DisciplineCount > 0))
            {
                reports = reports.Where(x => x.IDEAINTERIMREMOVAL != "MISSING");
            }
            if (reports.Any(x => x.RACE != null && x.RACE != "MISSING" && x.DisciplineCount > 0))
            {
                reports = reports.Where(x => x.RACE != "MISSING");
            }
            if (reports.Any(x => x.SEX != null && x.SEX != "MISSING" && x.DisciplineCount > 0))
            {
                reports = reports.Where(x => x.SEX != "MISSING");
            }
            if (reports.Any(x => x.TITLEIIIIMMIGRANTPARTICIPATIONSTATUS != null && x.TITLEIIIIMMIGRANTPARTICIPATIONSTATUS != "MISSING" && x.DisciplineCount > 0))
            {
                reports = reports.Where(x => x.TITLEIIIIMMIGRANTPARTICIPATIONSTATUS != "MISSING");
            }

            return reports;
        }

        #endregion

        #region FactStudentAssessmentReport


        private IQueryable<FactK12StudentAssessmentReport> AggregateFactAssessmentCount(IQueryable<FactK12StudentAssessment> facts, List<ToggleAssessment> toggleAssessments, string reportCode, string reportLevel, string reportYear, string categorySetCode, string categories, string tableTypeAbbrv)
        {

            // Category flags
            bool includeSubject = categories.Contains("|ASSESSMENTSUBJECT|");
            bool includeGradeLevel = categories.Contains("|GRADELVLASS|");
            bool includeEcoDis = categories.Contains("|ECODIS|");
            bool includeLepStatus = categories.Contains("|LEPBOTH|");
            bool includeMigrant = categories.Contains("|MIGRNTSTATUS|");
            bool includeRace = categories.Contains("|RACEETHNIC|");
            bool includeSEX = categories.Contains("|SEX|"); // Currently unused
            bool includeTITLEI = categories.Contains("|TITLEISCHSTATUS|");
            bool includeIdea = categories.Contains("|DISABSTATIDEA|");
            bool includeProficiency = categories.Contains("|PROFSTATUS|");

            // Report-level filtering
            if (reportLevel == "sea" || reportLevel == "lea")
                facts = facts.Where(x => x.LeaId != -1);
            if (reportLevel == "sch")
                facts = facts.Where(x => x.K12SchoolId != -1);
            if (includeRace)
                facts = facts.Where(x => x.DimRace.DimFactType.FactTypeCode == "submission");

            // Precomputed selectors
            Func<dynamic, string> getOrgNcesId = x =>
                reportLevel == "sea" ? x.DimLea.StateAnsiCode :
                reportLevel == "lea" ? (x.DimLea.LeaIdentifierNces ?? "") :
                                       (x.DimSchool.SchoolIdentifierNces ?? "");

            Func<dynamic, string> getOrgStateId = x =>
                reportLevel == "sea" ? x.DimLea.SeaIdentifierState :
                reportLevel == "lea" ? x.DimLea.LeaIdentifierState :
                                       x.DimSchool.SchoolIdentifierState;

            Func<dynamic, string> getOrgName = x =>
                reportLevel == "sea" ? x.DimLea.SeaName :
                reportLevel == "lea" ? x.DimLea.LeaName :
                                       x.DimSchool.NameOfInstitution;

            Func<dynamic, string?> getParentStateId = x =>
                reportLevel == "sea" ? null :
                reportLevel == "lea" ? x.DimLea.SeaIdentifierState :
                                       x.DimSchool.LeaIdentifierState;

            var joinedFacts = facts
                .ToList()
                .Join(toggleAssessments,
                    t1 => new
                    {
                        Grade = t1.DimGradeLevel.GradeLevelEdFactsCode,
                        Subject = t1.DimAssessment.AssessmentSubjectEdFactsCode,
                        AssessmentTypeCode = t1.DimAssessment.AssessmentTypeEdFactsCode
                    },
                    t2 => new
                    {
                        t2.Grade,
                        t2.Subject,
                        t2.AssessmentTypeCode
                    },
                    (t1, t2) => new { t1, t2 }
                )
                .ToList();

            var groupedFacts = joinedFacts
                .GroupBy(x => new
                {
                    x.t1.K12StudentId,
                    StateCode = x.t1.DimLea.StateAbbreviationCode,
                    StateANSICode = x.t1.DimLea.StateAnsiCode,
                    StateName = x.t1.DimLea.StateAbbreviationDescription,
                    OrganizationNcesId = getOrgNcesId(x.t1),
                    OrganizationStateId = getOrgStateId(x.t1),
                    OrganizationName = getOrgName(x.t1),
                    ParentOrganizationStateId = getParentStateId(x.t1),
                    ASSESSMENTSUBJECT = includeSubject ? x.t1.DimAssessment.AssessmentSubjectEdFactsCode : null,
                    GRADELEVEL = includeGradeLevel ? x.t1.DimGradeLevel.GradeLevelEdFactsCode : null,
                    IDEAINDICATOR = includeIdea ? x.t1.DimIdeaStatus.IdeaIndicatorEdFactsCode : null,
                    ECODISSTATUS = includeEcoDis ? x.t1.DimDemographic.EconomicDisadvantageStatusEdFactsCode : null,
                    LEPSTATUS = includeLepStatus ? x.t1.DimDemographic.EnglishLearnerStatusEdFactsCode : null,
                    MIGRANTSTATUS = includeMigrant ? x.t1.DimDemographic.MigrantStatusEdFactsCode : null,
                    RACE = includeRace ? x.t1.DimRace.RaceCode : null,
                    TITLE1SCHOOLSTATUS = includeTITLEI ? x.t1.DimTitle1Status.TitleISchoolStatusEdFactsCode : null,
                    PROFICIENCYSTATUS = includeProficiency
                        ? (
                            int.TryParse(x.t1.DimAssessment.PerformanceLevelEdFactsCode?.LastOrDefault().ToString(), out var perf)
                            && int.TryParse(x.t2.ProficientOrAboveLevel, out var cutoff)
                                ? (perf >= cutoff ? "PROFICIENT" : "BELOWPROFICIENT")
                                : null
                        )
                        : null
                })
                .GroupBy(x => new
                {
                    x.Key.StateCode,
                    x.Key.StateANSICode,
                    x.Key.StateName,
                    x.Key.OrganizationName,
                    x.Key.OrganizationNcesId,
                    x.Key.OrganizationStateId,
                    x.Key.ParentOrganizationStateId,
                    x.Key.ASSESSMENTSUBJECT,
                    x.Key.GRADELEVEL,
                    x.Key.IDEAINDICATOR,
                    x.Key.ECODISSTATUS,
                    x.Key.LEPSTATUS,
                    x.Key.MIGRANTSTATUS,
                    x.Key.RACE,
                    x.Key.TITLE1SCHOOLSTATUS,
                    x.Key.PROFICIENCYSTATUS
                })
                .Select(g => new FactK12StudentAssessmentReport
                {
                    ReportCode = reportCode,
                    ReportLevel = reportLevel,
                    ReportYear = reportYear,
                    TableTypeAbbrv = tableTypeAbbrv,
                    Categories = categories,
                    CategorySetCode = categorySetCode,
                    StateCode = g.Key.StateCode,
                    StateANSICode = g.Key.StateANSICode,
                    StateName = g.Key.StateName,
                    OrganizationName = g.Key.OrganizationName,
                    OrganizationNcesId = g.Key.OrganizationNcesId,
                    OrganizationStateId = g.Key.OrganizationStateId,
                    ParentOrganizationStateId = g.Key.ParentOrganizationStateId,
                    ASSESSMENTSUBJECT = g.Key.ASSESSMENTSUBJECT,
                    GRADELEVEL = g.Key.GRADELEVEL,
                    IDEAINDICATOR = g.Key.IDEAINDICATOR,
                    ECODISSTATUS = g.Key.ECODISSTATUS,
                    LEPSTATUS = g.Key.LEPSTATUS,
                    MIGRANTSTATUS = g.Key.MIGRANTSTATUS,
                    RACE = g.Key.RACE,
                    TITLEISCHOOLSTATUS = g.Key.TITLE1SCHOOLSTATUS,
                    PROFICIENCYSTATUS = g.Key.PROFICIENCYSTATUS,
                    TotalIndicator = "N",
                    AssessmentCount = g.Count()
                })
                .AsQueryable();

            return groupedFacts;

        }

        #endregion

        #region Report Methods

        public void ExecuteReportMigrationByYearLevelAndCategorySet(string reportCode, string reportYear, string reportLevel, string categorySetCode, List<string> excludeFilters, List<string> excludeToggles)
        {
            // Determine fact report table
            GenerateReport generateReport = _appDbContext.GenerateReports.Single(x => x.ReportCode == reportCode);
            FactTable factTable = _appDbContext.FactTables.Single(x => x.FactTableId == generateReport.FactTableId);

            // Determine toggle responses

            var toggleResponses = _appDbContext.ToggleResponses.Where(x => x.ToggleQuestion.EmapsQuestionAbbrv == "CHDCTDISCAT").Select(x => x.ResponseValue);

            var toggleDisabilityCodes = new List<string>();

            foreach (var item in toggleResponses)
            {
                //TODO: Would be better to make Toggle Response values match EDFacts values (so that this is not hard-coded here)

                switch (item)
                {
                    case "Austim":
                        toggleDisabilityCodes.Add("AUT");
                        break;
                    case "Deaf-Blindness":
                        toggleDisabilityCodes.Add("DB");
                        break;
                    case "Developmental Delay":
                        toggleDisabilityCodes.Add("DD");
                        break;
                    case "Emotional Disturbance":
                        toggleDisabilityCodes.Add("EMN");
                        break;
                    case "Hearing Impairment":
                        toggleDisabilityCodes.Add("HI");
                        break;
                    case "Intellectual Disability":
                        toggleDisabilityCodes.Add("MR");
                        break;
                    case "Multiple Disabilities":
                        toggleDisabilityCodes.Add("MD");
                        break;
                    case "Orthopedic Impairment":
                        toggleDisabilityCodes.Add("OI");
                        break;
                    case "Specific Learning Disability":
                        toggleDisabilityCodes.Add("SLD");
                        break;
                    case "Speech or Language Impairment":
                        toggleDisabilityCodes.Add("SLI");
                        break;
                    case "Traumatic Brain Injury":
                        toggleDisabilityCodes.Add("TBI");
                        break;
                    case "Visual Impairment":
                        toggleDisabilityCodes.Add("VI");
                        break;
                    case "Other Health Impairment":
                        toggleDisabilityCodes.Add("OHI");
                        break;

                    default:
                        break;
                }

            }


            // Remove existing data

            LogDataMigrationHistory("report", "Report Started (" + reportCode + "/" + reportYear + "/" + reportLevel + "/" + categorySetCode + ")", true);

            if (factTable.FactReportTableName == "FactStudentCountReports")
            {
                IQueryable<ReportEDFactsK12StudentCount> existingData = _rdsDbContext.FactStudentCountReports
                .Where(
                    x => x.ReportCode == reportCode &&
                    x.ReportYear == reportYear &&
                    x.ReportLevel == reportLevel &&
                    x.CategorySetCode == categorySetCode
                );

                _rdsDbContext.RemoveRange(existingData);
            }
            else if (factTable.FactReportTableName == "FactStudentDisciplineReports")
            {
                IQueryable<ReportEDFactsK12StudentDiscipline> existingData = _rdsDbContext.FactStudentDisciplineReports
                .Where(
                    x => x.ReportCode == reportCode &&
                    x.ReportYear == reportYear &&
                    x.ReportLevel == reportLevel &&
                    x.CategorySetCode == categorySetCode
                );

                _rdsDbContext.RemoveRange(existingData);
            }
            else if (factTable.FactReportTableName == "FactStudentAssessmentReports")
            {
                IQueryable<FactK12StudentAssessmentReport> existingData = _rdsDbContext.FactStudentAssessmentReports
                .Where(
                    x => x.ReportCode == reportCode &&
                    x.ReportYear == reportYear &&
                    x.ReportLevel == reportLevel &&
                    x.CategorySetCode == categorySetCode
                );

                _rdsDbContext.RemoveRange(existingData);
            }


            _rdsDbContext.SaveChanges();
            
            // Get category set and categories

            CategorySet categorySet = _appDbContext.CategorySets
                .Include("TableType")
                .Include("CategorySet_Categories.Category")
                .Where(x =>
                    x.CategorySetCode == categorySetCode &&
                    x.GenerateReport.ReportCode == reportCode &&
                    x.SubmissionYear == reportYear &&
                    x.OrganizationLevel.LevelCode == reportLevel
                ).Single();

            StringBuilder categoriesSb = new StringBuilder();
            foreach (var item in categorySet.CategorySet_Categories)
            {
                categoriesSb.Append("|" + item.Category.CategoryCode + "|");
            }
            var categories = categoriesSb.ToString();
            var tableTypeAbbrv = "";

            if (categorySet.TableType != null) {
                tableTypeAbbrv = categorySet.TableType.TableTypeAbbrv;
            }

            // Get facts, aggregate, filter, save

            if (factTable.FactReportTableName == "FactStudentCountReports")
            {

                IQueryable<FactK12StudentCount> facts = _rdsDbContext.FactStudentCounts
                .Where(x =>
                    x.K12SchoolId != -1 &&
                    x.DimFactType.FactTypeCode == "submission" &&
                    x.DimCountDate.SubmissionYear == reportYear
                );

                facts = FilterFactStudentCount(facts, reportCode, excludeFilters);

                var results = AggregateFactStudentCount(facts, reportCode, reportLevel, reportYear, categorySetCode, categories, tableTypeAbbrv);

                if (results.Any())
                {
                    _rdsDbContext.AddRange(results);
                    _rdsDbContext.SaveChanges();
                }

            }
            else if (factTable.FactReportTableName == "FactStudentDisciplineReports")
            {

                IQueryable<FactK12StudentDiscipline> facts = _rdsDbContext.FactStudentDisciplines
                    .Where(x =>
                        x.DimFactType.FactTypeCode == "submission" &&
                        x.DimCountDate.SubmissionYear == reportYear
                    );


                facts = FilterFactStudentDiscipline(facts, reportCode, categories, excludeFilters);

                facts = ToggleFactStudentDiscipline(facts, reportCode, toggleDisabilityCodes, excludeToggles);

                var results = AggregateFactStudentDiscipline(facts, reportCode, reportLevel, reportYear, categorySetCode, categories, tableTypeAbbrv);

                results = RemoveMissingFactStudentDisciplines(results);

                if (results.Any())
                {
                    _rdsDbContext.AddRange(results);
                    _rdsDbContext.SaveChanges();
                }

            }
            else if (factTable.FactReportTableName == "FactStudentAssessmentReports")
            {

                IQueryable<FactK12StudentAssessment> facts = _rdsDbContext.FactStudentAssessments
                .Where(x =>
                     x.DimFactType.FactTypeCode == "submission" &&
                    x.DimCountDate.SubmissionYear == reportYear
                );

               

                var results = AggregateFactAssessmentCount(facts, _appDbContext.ToggleAssessments.ToList(), reportCode, reportLevel, reportYear, categorySetCode, categories, tableTypeAbbrv);

                if (results.Any())
                {
                    _rdsDbContext.AddRange(results);
                    _rdsDbContext.SaveChanges();
                }

            }


            LogDataMigrationHistory("report", "Report Complete (" + reportCode + "/" + reportYear + "/" + reportLevel + "/" + categorySetCode + ")", true);

        }



        #endregion

    }
}
