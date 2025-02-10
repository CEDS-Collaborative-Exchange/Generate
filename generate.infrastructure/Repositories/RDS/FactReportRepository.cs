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
            if (reportCode == "c045")
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
            var groupedFacts = facts
            .GroupBy(x => new
            {
                x.DimSchool.StateAbbreviationCode,
                x.DimSchool.StateAnsiCode,
                x.DimSchool.StateAbbreviationDescription,
                //OrganizationId = reportLevel == "sea" ? x.DimSchool.SeaOrganizationId : reportLevel == "lea" ? x.DimSchool.LeaOrganizationId : x.DimSchool.SchoolOrganizationId,
                OrganizationNcesId = reportLevel == "sea" ? x.DimSchool.StateAnsiCode : reportLevel == "lea" ? x.DimSchool.LeaIdentifierNces : x.DimSchool.SchoolIdentifierNces,
                OrganizationStateId = reportLevel == "sea" ? x.DimSchool.SeaIdentifierState : reportLevel == "lea" ? x.DimSchool.LeaIdentifierState : x.DimSchool.SchoolIdentifierState,
                OrganizationName = reportLevel == "sea" ? x.DimSchool.SeaName : reportLevel == "lea" ? x.DimSchool.LeaName : x.DimSchool.NameOfInstitution,
                ParentOrganizationStateId = reportLevel == "sea" ? null : reportLevel == "lea" ? x.DimSchool.SeaIdentifierState : x.DimSchool.LeaIdentifierState,
                AGE = categories.Contains("|AGE|") ? x.DimAge.AgeEdFactsCode : null,
                LEPSTATUS = categories.Contains("|LEPBOTH|") ? x.DimDemographic.EnglishLearnerStatusEdFactsCode : null,
                LANGUAGE = categories.Contains("|LANGHOME|") ? x.DimLanguage.Iso6392LanguageEdFactsCode : null,
                TITLEIIIPROGRAMPARTICIPATION = categories.Contains("|IMGRNTPROGPART|") ? x.DimProgramStatus.TitleiiiProgramParticipationEdFactsCode : null
            })
            .Select(x => new ReportEDFactsK12StudentCount()
            {
                ReportEDFactsK12StudentCountId = 0,
                ReportCode = reportCode,
                ReportLevel = reportLevel,
                ReportYear = reportYear,
                TableTypeAbbrv = tableTypeAbbrv,
                Categories = categories,
                CategorySetCode = categorySetCode,
                StateAbbreviationCode = x.Key.StateAbbreviationCode,
                StateANSICode = x.Key.StateAnsiCode,
                StateAbbreviationDescription = x.Key.StateAbbreviationDescription,
                //OrganizationId = x.Key.OrganizationId,
                OrganizationName = x.Key.OrganizationName,
                OrganizationIdentifierNces = x.Key.OrganizationNcesId,
                OrganizationIdentifierSea = x.Key.OrganizationStateId,
                ParentOrganizationIdentifierSea = x.Key.ParentOrganizationStateId,
                AGE = x.Key.AGE,
                ENGLISHLEARNERSTATUS = x.Key.LEPSTATUS,
                ISO6392LANGUAGECODE = x.Key.LANGUAGE,
                TITLEIIIIMMIGRANTPARTICIPATIONSTATUS = x.Key.TITLEIIIPROGRAMPARTICIPATION,
                TotalIndicator = (categorySetCode.StartsWith("CS")) ? "N" : "Y",
                StudentCount = x.Sum(y => y.StudentCount)
            }
            );

            return groupedFacts;
        }

        #endregion

        #region FactStudentDisciplineReport

        private IQueryable<FactK12StudentDiscipline> FilterFactStudentDiscipline(IQueryable<FactK12StudentDiscipline> facts, string reportCode, string categories, List<string> excludeFilters)
        {
            if (reportCode == "c005" || reportCode == "c007")
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
            if (reportCode == "c005" || reportCode == "c007")
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
            bool includeAGE = categories.Contains("|AGE|");
            bool includeDISABILITY = categories.Contains("|DISABCATIDEA|");
            bool includeLEPSTATUS = categories.Contains("|LEPBOTH|");
            bool includeREMOVALTYPE = categories.Contains("|REMOVALTYPE|");
            bool includeRACE = categories.Contains("|RACEETHNIC|");
            bool includeSEX = categories.Contains("|SEX|");
            bool includeTITLEIIIPROGRAMPARTICIPATION = categories.Contains("|IMGRNTPROGPART|");

            string totalIndicator = categorySetCode.StartsWith("CS") ? "N" : "Y";

            if (reportLevel == "sea" || reportLevel == "lea")
            {
                facts = facts.Where(x => x.LeaId != -1);
            }

            if (reportLevel == "sch")
            {
                facts = facts.Where(x => x.K12SchoolId != -1);
            }

            var groupedFacts = facts
                .GroupBy(x => new
                {
                    K12StudentId = x.K12StudentId,
                    StateCode = x.DimLea.StateAbbreviationCode,
                    StateANSICode = x.DimLea.StateAnsiCode,
                    StateName = x.DimLea.StateAbbreviationDescription,
                    //OrganizationId = reportLevel == "sea" ? (int)x.DimLea.SeaOrganizationId : reportLevel == "lea" ? (int)x.DimLea.LeaOrganizationId : (int)x.DimSchool.SchoolOrganizationId,
                    OrganizationNcesId = reportLevel == "sea" ? x.DimLea.StateAnsiCode : reportLevel == "lea" ? (x.DimLea.LeaIdentifierNces != null ? x.DimLea.LeaIdentifierNces : "") : (x.DimSchool.SchoolIdentifierNces != null ? x.DimSchool.SchoolIdentifierNces : ""),
                    OrganizationStateId = reportLevel == "sea" ? x.DimLea.SeaIdentifierState : reportLevel == "lea" ? x.DimLea.LeaIdentifierState : x.DimSchool.SchoolIdentifierState,
                    OrganizationName = reportLevel == "sea" ? x.DimLea.SeaName : reportLevel == "lea" ? x.DimLea.LeaName : x.DimSchool.NameOfInstitution,
                    ParentOrganizationStateId = reportLevel == "sea" ? null : reportLevel == "lea" ? x.DimLea.SeaIdentifierState : x.DimSchool.LeaIdentifierState,
                    AGE = includeAGE ? x.DimAge.AgeEdFactsCode : null,
                    DISABILITY = includeDISABILITY ? x.DimIdeaStatus.PrimaryDisabilityTypeEdFactsCode : null,
                    LEPSTATUS = includeLEPSTATUS ? x.DimDemographic.EnglishLearnerStatusEdFactsCode : null,
                    REMOVALTYPE = includeREMOVALTYPE ? x.DimDiscipline.IdeaInterimRemovalEdFactsCode : null,
                    RACE = includeRACE ? x.DimRace.RaceCode : null,
                    SEX = includeSEX ? x.DimStudent.SexEdFactsCode : null,
                    TITLEIIIPROGRAMPARTICIPATION = includeTITLEIIIPROGRAMPARTICIPATION ? x.DimProgramStatus.TitleiiiProgramParticipationEdFactsCode : null
                })
                .Select(x => new
                {
                    DimStudentId = x.Key.K12StudentId,
                    StateCode = x.Key.StateCode,
                    StateANSICode = x.Key.StateANSICode,
                    StateName = x.Key.StateName,
                    //OrganizationId = x.Key.OrganizationId,
                    OrganizationName = x.Key.OrganizationName,
                    OrganizationNcesId = x.Key.OrganizationNcesId,
                    OrganizationStateId = x.Key.OrganizationStateId,
                    ParentOrganizationStateId = x.Key.ParentOrganizationStateId,
                    AGE = x.Key.AGE,
                    DISABILITY = x.Key.DISABILITY,
                    LEPSTATUS = x.Key.LEPSTATUS,
                    REMOVALTYPE = x.Key.REMOVALTYPE,
                    RACE = x.Key.RACE,
                    SEX = x.Key.SEX,
                    TITLEIIIPROGRAMPARTICIPATION = x.Key.TITLEIIIPROGRAMPARTICIPATION,
                })
                .GroupBy(x => new 
                {
                    StateCode = x.StateCode,
                    StateANSICode = x.StateANSICode,
                    StateName = x.StateName,
                    //OrganizationId = x.OrganizationId,
                    OrganizationName = x.OrganizationName,
                    OrganizationNcesId = x.OrganizationNcesId,
                    OrganizationStateId = x.OrganizationStateId,
                    ParentOrganizationStateId = x.ParentOrganizationStateId,
                    AGE = x.AGE,
                    DISABILITY = x.DISABILITY,
                    LEPSTATUS = x.LEPSTATUS,
                    REMOVALTYPE = x.REMOVALTYPE,
                    RACE = x.RACE,
                    SEX = x.SEX,
                    TITLEIIIPROGRAMPARTICIPATION = x.TITLEIIIPROGRAMPARTICIPATION
                }
                )
                .Select(x => new ReportEDFactsK12StudentDiscipline()
                {
                    ReportCode = reportCode,
                    ReportLevel = reportLevel,
                    ReportYear = reportYear,
                    TableTypeAbbrv = tableTypeAbbrv,
                    Categories = categories,
                    CategorySetCode = categorySetCode,
                    StateAbbreviationCode = x.Key.StateCode,
                    StateANSICode = x.Key.StateANSICode,
                    StateAbbreviationDescription = x.Key.StateName,
                    //OrganizationId = x.Key.OrganizationId,
                    OrganizationName = x.Key.OrganizationName,
                    OrganizationIdentifierNces = x.Key.OrganizationNcesId,
                    OrganizationIdentifierSea = x.Key.OrganizationStateId,
                    ParentOrganizationIdentifierSea = x.Key.ParentOrganizationStateId,
                    AGE = x.Key.AGE,
                    IDEADISABILITYTYPE = x.Key.DISABILITY,
                    ENGLISHLEARNERSTATUS = x.Key.LEPSTATUS,
                    IDEAINTERIMREMOVAL = x.Key.REMOVALTYPE,
                    RACE = x.Key.RACE,
                    SEX = x.Key.SEX,
                    TITLEIIIIMMIGRANTPARTICIPATIONSTATUS = x.Key.TITLEIIIPROGRAMPARTICIPATION,
                    TotalIndicator = totalIndicator,
                    DisciplineCount = x.Count()
                }
            );

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

            bool includeSubject = categories.Contains("|ASSESSMENTSUBJECT|");
            bool includeGradeLevel = categories.Contains("|GRADELVLASS|");
            bool includeEcoDis = categories.Contains("|ECODIS|");
            bool includeLepStatus = categories.Contains("|LEPBOTH|");
            bool includeMigrant = categories.Contains("|MIGRNTSTATUS|");
            bool includeRace = categories.Contains("|RACEETHNIC|");
            bool includeSEX = categories.Contains("|SEX|");
            bool includeTITLEI = categories.Contains("|TITLEISCHSTATUS|");
            bool includeIdea = categories.Contains("|DISABSTATIDEA|");
            bool includeProficiency = categories.Contains("|PROFSTATUS|");


            if (reportLevel == "sea" || reportLevel == "lea")
            {
                facts = facts.Where(x => x.LeaId != -1);
            }

            if (reportLevel == "sch")
            {
                facts = facts.Where(x => x.K12SchoolId != -1);
            }

            if (includeRace)
            {
                facts = facts.Where(x => x.DimRace.DimFactType.FactTypeCode == "submission");
            }


            var groupedFacts = facts
              .ToList()
              .Join(toggleAssessments,
              t1 => new { Grade = t1.DimGradeLevel.GradeLevelEdFactsCode, Subject = t1.DimAssessment.AssessmentSubjectEdFactsCode, AssessmentTypeCode = t1.DimAssessment.AssessmentTypeEdFactsCode },
              t2 => new { Grade = t2.Grade, Subject = t2.Subject, AssessmentTypeCode = t2.AssessmentTypeCode },
             (t1, t2) => new { t1, t2 })
            .ToList()
            .GroupBy(x => new
            {
                DimStudentId = x.t1.K12StudentId,
                StateCode = x.t1.DimLea.StateAbbreviationCode,
                StateANSICode = x.t1.DimLea.StateAnsiCode,
                StateName = x.t1.DimLea.StateAbbreviationDescription,
                //OrganizationId = reportLevel == "sea" ? (int)x.t1.DimLea.SeaOrganizationId : reportLevel == "lea" ? (int)x.t1.DimLea.LeaOrganizationId : (int)x.t1.DimSchool.SchoolOrganizationId,
                OrganizationNcesId = reportLevel == "sea" ? x.t1.DimLea.StateAnsiCode : reportLevel == "lea" ? (x.t1.DimLea.LeaIdentifierNces != null ? x.t1.DimLea.LeaIdentifierNces : "") : (x.t1.DimSchool.SchoolIdentifierNces != null ? x.t1.DimSchool.SchoolIdentifierNces : ""),
                OrganizationStateId = reportLevel == "sea" ? x.t1.DimLea.SeaIdentifierState : reportLevel == "lea" ? x.t1.DimLea.LeaIdentifierState : x.t1.DimSchool.SchoolIdentifierState,
                OrganizationName = reportLevel == "sea" ? x.t1.DimLea.SeaName : reportLevel == "lea" ? x.t1.DimLea.LeaName : x.t1.DimSchool.NameOfInstitution,
                ParentOrganizationStateId = reportLevel == "sea" ? null : reportLevel == "lea" ? x.t1.DimLea.SeaIdentifierState : x.t1.DimSchool.LeaIdentifierState,
                ASSESSMENTSUBJECT = includeSubject ? x.t1.DimAssessment.AssessmentSubjectEdFactsCode : null,
                GRADELEVEL = includeGradeLevel ? x.t1.DimGradeLevel.GradeLevelEdFactsCode : null,
                IDEAINDICATOR = includeIdea ? x.t1.DimIdeaStatus.IdeaIndicatorEdFactsCode : null,
                ECODISSTATUS = includeEcoDis ? x.t1.DimDemographic.EconomicDisadvantageStatusEdFactsCode : null,
                LEPSTATUS = includeLepStatus ? x.t1.DimDemographic.EnglishLearnerStatusEdFactsCode : null,
                MIGRANTSTATUS = includeMigrant ? x.t1.DimDemographic.MigrantStatusEdFactsCode : null,
                RACE = includeRace ? x.t1.DimRace.RaceCode : null,
                //SEX = includeSEX ? x.t1.DimDemographic.SexEdFactsCode : null,
                TITLE1SCHOOLSTATUS = includeTITLEI ? x.t1.DimTitle1Status.TitleISchoolStatusEdFactsCode : null,
                ProficiencyStatus = includeProficiency ? Convert.ToInt32(x.t1.DimAssessment.PerformanceLevelEdFactsCode.Last()) >= Convert.ToInt32(x.t2.ProficientOrAboveLevel) ? "PROFICIENT" : "BELOWPROFICIENT" : null

            })
            .Select(x => new
            {
                DimStudentId = x.Key.DimStudentId,
                StateCode = x.Key.StateCode,
                StateANSICode = x.Key.StateANSICode,
                StateName = x.Key.StateName,
                //OrganizationId = x.Key.OrganizationId,
                OrganizationName = x.Key.OrganizationName,
                OrganizationNcesId = x.Key.OrganizationNcesId,
                OrganizationStateId = x.Key.OrganizationStateId,
                ParentOrganizationStateId = x.Key.ParentOrganizationStateId,
                ASSESSMENTSUBJECT = x.Key.ASSESSMENTSUBJECT,
                GRADELEVEL = x.Key.GRADELEVEL,
                IDEAINDICATOR = x.Key.IDEAINDICATOR,
                ECODISSTATUS = x.Key.ECODISSTATUS,
                LEPSTATUS = x.Key.LEPSTATUS,
                MIGRANTSTATUS = x.Key.MIGRANTSTATUS,
                RACE = x.Key.RACE,
                //SEX = x.Key.SEX,
                TITLE1SCHOOLSTATUS = x.Key.TITLE1SCHOOLSTATUS,
                ProficiencyStatus = x.Key.ProficiencyStatus
            })
            .GroupBy(x => new
            {
                StateCode = x.StateCode,
                StateANSICode = x.StateANSICode,
                StateName = x.StateName,
                //OrganizationId = x.OrganizationId,
                OrganizationName = x.OrganizationName,
                OrganizationNcesId = x.OrganizationNcesId,
                OrganizationStateId = x.OrganizationStateId,
                ParentOrganizationStateId = x.ParentOrganizationStateId,
                ASSESSMENTSUBJECT = x.ASSESSMENTSUBJECT,
                GRADELEVEL = x.GRADELEVEL,
                IDEAINDICATOR = x.IDEAINDICATOR,
                ECODISSTATUS = x.ECODISSTATUS,
                LEPSTATUS = x.LEPSTATUS,
                MIGRANTSTATUS = x.MIGRANTSTATUS,
                RACE = x.RACE,
                //SEX = x.SEX,
                TITLE1SCHOOLSTATUS = x.TITLE1SCHOOLSTATUS,
                ProficiencyStatus = x.ProficiencyStatus
            }
            )
            .Select(x => new FactK12StudentAssessmentReport()
            {
                ReportCode = reportCode,
                ReportLevel = reportLevel,
                ReportYear = reportYear,
                TableTypeAbbrv = tableTypeAbbrv,
                Categories = categories,
                CategorySetCode = categorySetCode,
                StateCode = x.Key.StateCode,
                StateANSICode = x.Key.StateANSICode,
                StateName = x.Key.StateName,
                //OrganizationId = x.Key.OrganizationId,
                OrganizationName = x.Key.OrganizationName,
                OrganizationNcesId = x.Key.OrganizationNcesId,
                OrganizationStateId = x.Key.OrganizationStateId,
                ParentOrganizationStateId = x.Key.ParentOrganizationStateId,
                ASSESSMENTSUBJECT = x.Key.ASSESSMENTSUBJECT,
                GRADELEVEL = x.Key.GRADELEVEL,
                IDEAINDICATOR = x.Key.IDEAINDICATOR,
                ECODISSTATUS = x.Key.ECODISSTATUS,
                LEPSTATUS = x.Key.LEPSTATUS,
                MIGRANTSTATUS = x.Key.MIGRANTSTATUS,
                RACE = x.Key.RACE,
                //SEX = x.Key.SEX,
                TITLEISCHOOLSTATUS = x.Key.TITLE1SCHOOLSTATUS,
                PROFICIENCYSTATUS = x.Key.ProficiencyStatus,
                TotalIndicator = "N",
                AssessmentCount = x.Count()
            }
            ).AsQueryable();

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
