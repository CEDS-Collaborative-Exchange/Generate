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

        private List<string> GetToggleDisabilityCodes()
        {
            var mapping = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase)
            {
                ["Austim"] = "AUT",
                ["Deaf-Blindness"] = "DB",
                ["Developmental Delay"] = "DD",
                ["Emotional Disturbance"] = "EMN",
                ["Hearing Impairment"] = "HI",
                ["Intellectual Disability"] = "MR",
                ["Multiple Disabilities"] = "MD",
                ["Orthopedic Impairment"] = "OI",
                ["Specific Learning Disability"] = "SLD",
                ["Speech or Language Impairment"] = "SLI",
                ["Traumatic Brain Injury"] = "TBI",
                ["Visual Impairment"] = "VI",
                ["Other Health Impairment"] = "OHI"
            };

            return _appDbContext.ToggleResponses
                .Where(x => x.ToggleQuestion.EmapsQuestionAbbrv == "CHDCTDISCAT")
                .Select(x => mapping.GetValueOrDefault(x.ResponseValue))
                .Where(val => val != null)
                .ToList();
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
                    OrganizationNcesId = GetOrgNcesId(x, reportLevel),
                    OrganizationStateId = GetOrgStateId(x, reportLevel),
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

        private string GetOrgStateId(dynamic x, string reportLevel)
        {
            var isSEA = reportLevel == "sea";
            var isLEA = reportLevel == "lea";

            if (isSEA)
                return x.DimSchool.SeaIdentifierState;

            if (isLEA)
                return x.DimSchool.LeaIdentifierState;

            return x.DimSchool.SchoolIdentifierState;
        }

        private string GetOrgNcesId(dynamic x, string reportLevel)
        {
            var isSEA = reportLevel == "sea";
            var isLEA = reportLevel == "lea";

            if (isSEA)
                return x.DimSchool.StateAnsiCode;

            if (isLEA)
                return x.DimSchool.LeaIdentifierNces;

            return x.DimSchool.SchoolIdentifierNces;
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

        public void ExecuteReportMigrationByYearLevelAndCategorySet(
                string reportCode, string reportYear, string reportLevel,
                string categorySetCode, List<string> excludeFilters, List<string> excludeToggles)
        {
            GenerateReport generateReport = _appDbContext.GenerateReports.Single(x => x.ReportCode == reportCode);
            FactTable factTable = _appDbContext.FactTables.Single(x => x.FactTableId == generateReport.FactTableId);

            var toggleDisabilityCodes = GetToggleDisabilityCodes();

            LogDataMigrationHistory("report", $"Report Started ({reportCode}/{reportYear}/{reportLevel}/{categorySetCode})", true);

            RemoveExistingData(factTable.FactTableName, reportCode, reportYear, reportLevel, categorySetCode);

            var (categories, tableTypeAbbrv) = GetCategoriesAndTableType(reportCode, reportYear, reportLevel, categorySetCode);

            ProcessFacts(factTable.FactTableName, reportCode, reportYear, reportLevel, categorySetCode, categories, tableTypeAbbrv, excludeFilters, excludeToggles, toggleDisabilityCodes);

            LogDataMigrationHistory("report", $"Report Complete ({reportCode}/{reportYear}/{reportLevel}/{categorySetCode})", true);
        }

        private void RemoveExistingData(string tableName, string reportCode, string reportYear, string reportLevel, string categorySetCode)
        {
            if (tableName == "FactStudentCountReports")
            {
                var existing = _rdsDbContext.FactStudentCountReports
                    .Where(x => x.ReportCode == reportCode &&
                                x.ReportYear == reportYear &&
                                x.ReportLevel == reportLevel &&
                                x.CategorySetCode == categorySetCode);
                _rdsDbContext.RemoveRange(existing);
            }
            else if (tableName == "FactStudentDisciplineReports")
            {
                var existing = _rdsDbContext.FactStudentDisciplineReports
                    .Where(x => x.ReportCode == reportCode &&
                                x.ReportYear == reportYear &&
                                x.ReportLevel == reportLevel &&
                                x.CategorySetCode == categorySetCode);
                _rdsDbContext.RemoveRange(existing);
            }
            else if (tableName == "FactStudentAssessmentReports")
            {
                var existing = _rdsDbContext.FactStudentAssessmentReports
                    .Where(x => x.ReportCode == reportCode &&
                                x.ReportYear == reportYear &&
                                x.ReportLevel == reportLevel &&
                                x.CategorySetCode == categorySetCode);
                _rdsDbContext.RemoveRange(existing);
            }

            _rdsDbContext.SaveChanges();
        }

        private (string categories, string tableTypeAbbrv) GetCategoriesAndTableType(
            string reportCode, string reportYear, string reportLevel, string categorySetCode)
        {
            var categorySet = _appDbContext.CategorySets
                .Include("TableType")
                .Include("CategorySet_Categories.Category")
                .Single(x =>
                    x.CategorySetCode == categorySetCode &&
                    x.GenerateReport.ReportCode == reportCode &&
                    x.SubmissionYear == reportYear &&
                    x.OrganizationLevel.LevelCode == reportLevel);

            var categories = string.Join("|", categorySet.CategorySet_Categories
                .Select(c => c.Category.CategoryCode)
                .Distinct()
                .Prepend("") // to match original "|value|" format
                .Append(""));

            var tableType = categorySet.TableType?.TableTypeAbbrv ?? "";

            return ($"|{categories}|", tableType);
        }

        private void ProcessFacts(string tableName, string reportCode, string reportYear, string reportLevel,
                          string categorySetCode, string categories, string tableTypeAbbrv,
                          List<string> excludeFilters, List<string> excludeToggles, List<string> toggleDisabilityCodes)
        {
            switch (tableName)
            {
                case "FactStudentCountReports":
                    var countFacts = FilterFactStudentCount(
                        _rdsDbContext.FactStudentCounts
                            .Where(x => x.K12SchoolId != -1 &&
                                        x.DimFactType.FactTypeCode == "submission" &&
                                        x.DimCountDate.SubmissionYear == reportYear),
                        reportCode, excludeFilters);

                    var countResults = AggregateFactStudentCount(countFacts, reportCode, reportLevel, reportYear, categorySetCode, categories, tableTypeAbbrv);
                    SaveResults(countResults);
                    break;

                case "FactStudentDisciplineReports":
                    var discFacts = _rdsDbContext.FactStudentDisciplines
                        .Where(x => x.DimFactType.FactTypeCode == "submission" &&
                                    x.DimCountDate.SubmissionYear == reportYear);

                    discFacts = FilterFactStudentDiscipline(discFacts, reportCode, categories, excludeFilters);
                    discFacts = ToggleFactStudentDiscipline(discFacts, reportCode, toggleDisabilityCodes, excludeToggles);
                    var discResults = RemoveMissingFactStudentDisciplines(
                        AggregateFactStudentDiscipline(discFacts, reportCode, reportLevel, reportYear, categorySetCode, categories, tableTypeAbbrv));
                    SaveResults(discResults);
                    break;

                case "FactStudentAssessmentReports":
                    var assessFacts = _rdsDbContext.FactStudentAssessments
                        .Where(x => x.DimFactType.FactTypeCode == "submission" &&
                                    x.DimCountDate.SubmissionYear == reportYear);

                    var assessResults = AggregateFactAssessmentCount(
                        assessFacts, _appDbContext.ToggleAssessments.ToList(), reportCode, reportLevel, reportYear, categorySetCode, categories, tableTypeAbbrv);
                    SaveResults(assessResults);
                    break;
            }
        }

        private void SaveResults<T>(IEnumerable<T> results)
        {
            if (results != null && results.Any())
            {
                _rdsDbContext.AddRange(results);
                _rdsDbContext.SaveChanges();
            }
        }

        #endregion

    }
}
