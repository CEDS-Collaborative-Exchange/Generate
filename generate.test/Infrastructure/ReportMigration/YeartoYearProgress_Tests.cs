using generate.core.Config;
using generate.core.Helpers.ReferenceData;
using generate.core.Helpers.TestDataHelper;
using generate.core.Models.App;
using generate.core.Models.RDS;
using generate.infrastructure.Contexts;
using generate.test.Infrastructure.Fixtures;
using generate.infrastructure.Repositories.RDS;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Moq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;


namespace generate.test.Infrastructure.ReportMigration
{
    public class YeartoYearProgress_Tests : IClassFixture<ReportMigrationFixture>
    {
        //private readonly string reportTable = "FactStudentAssessmentReports";
        //private readonly string reportYear = "2018-19";
        //private readonly string reportCode = "yeartoyearprogress";

        private readonly ReportMigrationFixture fixture;

        public YeartoYearProgress_Tests(ReportMigrationFixture fixture)
        {
            this.fixture = fixture;
        }

        //#region SEA / All Tests

        ////Done - YeartoYearProgress_201819_SEA_All_Categories
        ////Done - YeartoYearProgress_201819_SEA_All_AssessmentSubject
        ////Done - YeartoYearProgress_201819_SEA_All_GradeLevel
        ////Done - YeartoYearProgress_201819_SEA_All_ProficiencyStatus
        ////Done - YeartoYearProgress_201819_SEA_All_Count

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_All_Categories()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "All";
        //    var totalIndicator = "N";
        //    var categoryList = "|ASSESSMENTSUBJECT||GRADELVLASS||PROFSTATUS|";

        //    this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_All_AssessmentSubject()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "All";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_AssessmentSubject_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_All_GradeLevel()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "All";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_GradeLevel_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_All_ProficiencyStatus()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "All";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_ProficiencyStatus_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_All_Count()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "All";

        //    // Arrange
        //    var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

        //    // Act
        //    repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

        //    // Assert
        //    var reports = this.fixture.rdsDbContext.FactStudentAssessmentReports
        //        .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
        //        .ToList();

        //    Assert.NotEmpty(reports);
                                            
        //}

        //#endregion

        //#region SEA / ecodis Tests

        ////Done - YeartoYearProgress_201819_SEA_ecodis_Categories
        ////Done - YeartoYearProgress_201819_SEA_ecodis_AssessmentSubject
        ////Done - YeartoYearProgress_201819_SEA_ecodis_GradeLevel
        ////Done - YeartoYearProgress_201819_SEA_ecodis_ProficiencyStatus
        ////Done - YeartoYearProgress_201819_SEA_ecodis_EconomicallyDisadvanted
        ////Done - YeartoYearProgress_201819_SEA_ecodis_Count

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_ecodis_Categories()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "ecodis";
        //    var totalIndicator = "N";
        //    var categoryList = "|ASSESSMENTSUBJECT||ECODIS||GRADELVLASS||PROFSTATUS|";

        //    this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_ecodis_AssessmentSubject()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "ecodis";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_AssessmentSubject_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_ecodis_GradeLevel()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "ecodis";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_GradeLevel_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_ecodis_ProficiencyStatus()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "ecodis";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_ProficiencyStatus_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_ecodis_EconomicallyDisadvanted()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "ecodis";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_EconomicallyDisadvanted_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_ecodis_Count()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "ecodis";

        //    // Arrange
        //    var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

        //    // Act
        //    repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

        //    // Assert
        //    var reports = this.fixture.rdsDbContext.FactStudentAssessmentReports
        //        .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
        //        .ToList();

        //    Assert.NotEmpty(reports);

        //}

        //#endregion

        //#region SEA / ideaindicator Tests

        ////Done - YeartoYearProgress_201819_SEA_ideaindicator_Categories
        ////Done - YeartoYearProgress_201819_SEA_ideaindicator_AssessmentSubject
        ////Done - YeartoYearProgress_201819_SEA_ideaindicator_GradeLevel
        ////Done - YeartoYearProgress_201819_SEA_ideaindicator_ProficiencyStatus
        ////Done - YeartoYearProgress_201819_SEA_ideaindicator_DisabilityStatus
        ////Done - YeartoYearProgress_201819_SEA_ideaindicator_Count

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_ideaindicator_Categories()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "ideaindicator";
        //    var totalIndicator = "N";
        //    var categoryList = "|ASSESSMENTSUBJECT||DISABSTATIDEA||GRADELVLASS||PROFSTATUS|";

        //    this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_ideaindicator_AssessmentSubject()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "ideaindicator";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_AssessmentSubject_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_ideaindicator_GradeLevel()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "ideaindicator";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_GradeLevel_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_ideaindicator_ProficiencyStatus()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "ideaindicator";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_ProficiencyStatus_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_ideaindicator_DisabilityStatus()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "ideaindicator";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_Ideaindicator_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_ideaindicator_Count()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "ideaindicator";

        //    // Arrange
        //    var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

        //    // Act
        //    repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

        //    // Assert
        //    var reports = this.fixture.rdsDbContext.FactStudentAssessmentReports
        //        .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
        //        .ToList();

        //    Assert.NotEmpty(reports);

        //}

        //#endregion

        //#region SEA / lepstatus Tests

        ////Done - YeartoYearProgress_201819_SEA_lepstatus_Categories
        ////Done - YeartoYearProgress_201819_SEA_lepstatus_AssessmentSubject
        ////Done - YeartoYearProgress_201819_SEA_lepstatus_GradeLevel
        ////Done - YeartoYearProgress_201819_SEA_lepstatus_ProficiencyStatus
        ////Done - YeartoYearProgress_201819_SEA_lepstatus_EnglishLearner
        ////Done - YeartoYearProgress_201819_SEA_lepstatus_Count

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_lepstatus_Categories()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "lepstatus";
        //    var totalIndicator = "N";
        //    var categoryList = "|ASSESSMENTSUBJECT||GRADELVLASS||LEPBOTH||PROFSTATUS|";

        //    this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_lepstatus_AssessmentSubject()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "lepstatus";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_AssessmentSubject_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_lepstatus_GradeLevel()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "lepstatus";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_GradeLevel_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_lepstatus_ProficiencyStatus()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "lepstatus";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_ProficiencyStatus_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_lepstatus_EnglishLearner()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "lepstatus";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_EnglishLearner_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_lepstatus_Count()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "lepstatus";

        //    // Arrange
        //    var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

        //    // Act
        //    repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

        //    // Assert
        //    var reports = this.fixture.rdsDbContext.FactStudentAssessmentReports
        //        .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
        //        .ToList();

        //    Assert.NotEmpty(reports);

        //}

        //#endregion

        //#region SEA / migrant Tests

        ////Done - YeartoYearProgress_201819_SEA_migrant_Categories
        ////Done - YeartoYearProgress_201819_SEA_migrant_AssessmentSubject
        ////Done - YeartoYearProgress_201819_SEA_migrant_GradeLevel
        ////Done - YeartoYearProgress_201819_SEA_migrant_ProficiencyStatus
        ////Done - YeartoYearProgress_201819_SEA_migrant_MigrantStatus
        ////Done - YeartoYearProgress_201819_SEA_migrant_Count

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_migrant_Categories()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "migrant";
        //    var totalIndicator = "N";
        //    var categoryList = "|ASSESSMENTSUBJECT||GRADELVLASS||MIGRNTSTATUS||PROFSTATUS|";

        //    this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_migrant_AssessmentSubject()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "migrant";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_AssessmentSubject_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_migrant_GradeLevel()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "migrant";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_GradeLevel_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_migrant_ProficiencyStatus()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "migrant";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_ProficiencyStatus_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_migrant_MigrantStatus()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "migrant";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_MigrantStatus_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_migrant_Count()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "migrant";

        //    // Arrange
        //    var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

        //    // Act
        //    repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

        //    // Assert
        //    var reports = this.fixture.rdsDbContext.FactStudentAssessmentReports
        //        .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
        //        .ToList();

        //    Assert.NotEmpty(reports);

        //}

        //#endregion

        //#region SEA / raceethnicity Tests

        ////Done - YeartoYearProgress_201819_SEA_raceethnicity_Categories
        ////Done - YeartoYearProgress_201819_SEA_raceethnicity_AssessmentSubject
        ////Done - YeartoYearProgress_201819_SEA_raceethnicity_GradeLevel
        ////Done - YeartoYearProgress_201819_SEA_raceethnicity_ProficiencyStatus
        ////Done - YeartoYearProgress_201819_SEA_raceethnicity_Race
        ////Done - YeartoYearProgress_201819_SEA_raceethnicity_Count

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_raceethnicity_Categories()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "raceethnicity";
        //    var totalIndicator = "N";
        //    var categoryList = "|ASSESSMENTSUBJECT||GRADELVLASS||PROFSTATUS||RACEETHNIC|";

        //    this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_raceethnicity_AssessmentSubject()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "raceethnicity";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_AssessmentSubject_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_raceethnicity_GradeLevel()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "raceethnicity";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_GradeLevel_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_raceethnicity_ProficiencyStatus()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "raceethnicity";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_ProficiencyStatus_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_raceethnicity_Race()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "raceethnicity";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_RacialEthnic_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_raceethnicity_Count()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "raceethnicity";

        //    // Arrange
        //    var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

        //    // Act
        //    repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

        //    // Assert
        //    var reports = this.fixture.rdsDbContext.FactStudentAssessmentReports
        //        .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
        //        .ToList();

        //    Assert.NotEmpty(reports);

        //}

        //#endregion
        
        //#region SEA / Sex Tests

        ////Done - YeartoYearProgress_201819_SEA_sex_Categories
        ////Done - YeartoYearProgress_201819_SEA_sex_AssessmentSubject
        ////Done - YeartoYearProgress_201819_SEA_sex_GradeLevel
        ////Done - YeartoYearProgress_201819_SEA_sex_ProficiencyStatus
        ////Done - YeartoYearProgress_201819_SEA_sex_Sex
        ////Done - YeartoYearProgress_201819_SEA_sex_Count

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_sex_Categories()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "sex";
        //    var totalIndicator = "N";
        //    var categoryList = "|ASSESSMENTSUBJECT||GRADELVLASS||PROFSTATUS||SEX|";

        //    this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_sex_AssessmentSubject()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "sex";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_AssessmentSubject_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_sex_GradeLevel()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "sex";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_GradeLevel_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_sex_ProficiencyStatus()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "sex";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_ProficiencyStatus_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_sex_Sex()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "sex";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_Sex_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_sex_Count()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "sex";

        //    // Arrange
        //    var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

        //    // Act
        //    repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

        //    // Assert
        //    var reports = this.fixture.rdsDbContext.FactStudentAssessmentReports
        //        .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
        //        .ToList();

        //    Assert.NotEmpty(reports);

        //}

        //#endregion

        //#region SEA / Title1 Tests

        ////Done - YeartoYearProgress_201819_SEA_title1_Categories
        ////Done - YeartoYearProgress_201819_SEA_title1_AssessmentSubject
        ////Done - YeartoYearProgress_201819_SEA_title1_GradeLevel
        ////Done - YeartoYearProgress_201819_SEA_title1_ProficiencyStatus
        ////Done - YeartoYearProgress_201819_SEA_title1_Title1Status
        ////Done - YeartoYearProgress_201819_SEA_title1_Count

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_title1_Categories()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "title1";
        //    var totalIndicator = "N";
        //    var categoryList = "|ASSESSMENTSUBJECT||GRADELVLASS||PROFSTATUS||TITLEISCHSTATUS|";

        //    this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_title1_AssessmentSubject()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "title1";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_AssessmentSubject_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_title1_GradeLevel()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "title1";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_GradeLevel_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_title1_ProficiencyStatus()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "title1";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_ProficiencyStatus_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_title1_Title1Status()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "title1";
        //    var totalIndicator = "N";

        //    this.fixture.CategorySet_Title1Status_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

        //}

        //[Fact]
        //public void YeartoYearProgress_201819_SEA_title1_Count()
        //{
        //    var reportLevel = "sea";
        //    var categorySetCode = "title1";

        //    // Arrange
        //    var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

        //    // Act
        //    repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

        //    // Assert
        //    var reports = this.fixture.rdsDbContext.FactStudentAssessmentReports
        //        .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode)
        //        .ToList();

        //    Assert.NotEmpty(reports);

        //}

        //#endregion
    }
}
