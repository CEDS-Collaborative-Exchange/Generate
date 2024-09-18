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

    public class FS005_Tests : IClassFixture<ReportMigrationFixture>
    {
        //private readonly string reportTable = "FactStudentDisciplineReports";
        //private readonly string reportYear = "2018-19";
        //private readonly string reportCode = "c005";

        private readonly ReportMigrationFixture fixture;

        public FS005_Tests(ReportMigrationFixture fixture)
        {
            this.fixture = fixture;
        }

    //    #region Core Tests

        //Done - FS005_201718_ToggleDisability
        //Done - FS005_201718_AgeRange
        //Done - FS005_201718_NoPPPS

   //     [Fact]
   //     public void FS005_201718_Core_ToggleDisability()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSA";
   //         var totalIndicator = "N";

   //         var emapsQuestionAbbrv = "CHDCTDISCAT";
   //         var toggleResponseValue = "Deaf-Blindness";
   //         var optionCode = "DB";

   //         this.fixture.Core_Toggle_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, emapsQuestionAbbrv, toggleResponseValue, optionCode);

   //     }

   //     [Fact]
   //     public void FS005_201718_Core_AgeRange()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "ST1";
   //         var totalIndicator = "Y";


   //         // Arrange
   //         var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

   //         // Act (without filter)
   //         repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, new List<string>() { "age" }, null);

   //         // Assert
   //         var reports = this.fixture.rdsDbContext.FactStudentDisciplineReports
   //             .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
   //             .ToList();

   //         Assert.NotEmpty(reports);

   //         /*
   //         -- SQL used to verify

   //          select
   //         s.SeaOrganizationId,
   //         i.RemovalTypeEdFactsCode,
  	//		'Assert.Equal(' + convert(varchar(20), COUNT(distinct st.StateStudentIdentifier)) + ', reports.Single(x => x.OrganizationId == ' + convert(varchar(20), s.SeaOrganizationId) + ' && x.REMOVALTYPE == "' + i.RemovalTypeEdFactsCode + '" && x.TotalIndicator == totalIndicator).DisciplineCount);' as code,
   //         COUNT(distinct st.StateStudentIdentifier) as cnt
   //         from rds.FactStudentDisciplines f
   //         inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
   //         and d.SubmissionYear = '2018-19'
   //         inner join rds.DimAges a on f.DimAgeId = a.DimAgeId 
   //         --and a.AgeValue >= 3 and a.AgeValue <= 21
   //         inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
   //         and s.DimSchoolId <> -1
   //         inner join rds.DimDisciplines i on f.DimDisciplineId = i.DimDisciplineId
   //         inner join rds.DimIdeaStatuses t on f.DimIdeaStatusId = t.DimIdeaStatusId
   //         inner join rds.DimStudents st on f.DimStudentId = st.DimStudentId
   //         and i.RemovalTypeEdFactsCode <> 'MISSING'
			//and t.EducEnvEdFactsCode != 'PPPS'
   //         and t.DisabilityId <> -1
			//inner join rds.FactOrganizationCounts fo on f.DimLeaId = fo.DimLeaId
			//and fo.DimSchoolId = -1
			//and fo.DimCountDateId = d.DimDateId
			//and s.SchoolOperationalStatus not in ('Closed','Inactive','Future')
   //         group by s.SeaOrganizationId, i.RemovalTypeEdFactsCode

   //         */

   //         Assert.Equal(437, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(450, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //     }
        
   //     [Fact]
   //     public void FS005_201718_Core_NoPPPS()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "ST1";
   //         var totalIndicator = "Y";


   //         // Arrange
   //         var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

   //         // Act (without filter)
   //         repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, new List<string>() { "ppps" }, null);

   //         // Assert
   //         var reports = this.fixture.rdsDbContext.FactStudentDisciplineReports
   //             .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
   //             .ToList();

   //         Assert.NotEmpty(reports);

   //         /*
   //         -- SQL used to verify

   //         select
   //         s.SeaOrganizationId,
   //         i.RemovalTypeEdFactsCode,
  	//		'Assert.Equal(' + convert(varchar(20), COUNT(distinct st.StateStudentIdentifier)) + ', reports.Single(x => x.OrganizationId == ' + convert(varchar(20), s.SeaOrganizationId) + ' && x.REMOVALTYPE == "' + i.RemovalTypeEdFactsCode + '" && x.TotalIndicator == totalIndicator).DisciplineCount);' as code,
   //         COUNT(distinct st.StateStudentIdentifier) as cnt
   //         from rds.FactStudentDisciplines f
   //         inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
   //         and d.SubmissionYear = '2018-19'
   //         inner join rds.DimAges a on f.DimAgeId = a.DimAgeId 
   //         and a.AgeValue >= 3 and a.AgeValue <= 21
   //         inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
   //         and s.DimSchoolId <> -1
   //         inner join rds.DimDisciplines i on f.DimDisciplineId = i.DimDisciplineId
   //         inner join rds.DimIdeaStatuses t on f.DimIdeaStatusId = t.DimIdeaStatusId
   //         inner join rds.DimStudents st on f.DimStudentId = st.DimStudentId
   //         and i.RemovalTypeEdFactsCode <> 'MISSING'
			//--and t.EducEnvEdFactsCode != 'PPPS'
   //         and t.DisabilityId <> -1
			//inner join rds.FactOrganizationCounts fo on f.DimLeaId = fo.DimLeaId
			//and fo.DimSchoolId = -1
			//and fo.DimCountDateId = d.DimDateId
			//and s.SchoolOperationalStatus not in ('Closed','Inactive','Future')
   //         group by s.SeaOrganizationId, i.RemovalTypeEdFactsCode

   //         */

   //         Assert.Equal(78, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(71, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //     }

   //     [Fact]
   //     public void FS005_201718_Core_Disability()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "ST1";
   //         var totalIndicator = "Y";


   //         // Arrange
   //         var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

   //         // Act (without filter)
   //         repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, new List<string>() { "disability" }, null);

   //         // Assert
   //         var reports = this.fixture.rdsDbContext.FactStudentDisciplineReports
   //             .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
   //             .ToList();

   //         Assert.NotEmpty(reports);

   //         /*
   //         -- SQL used to verify

   //         select
   //         s.SeaOrganizationId,
   //         i.RemovalTypeEdFactsCode,
  	//		'Assert.Equal(' + convert(varchar(20), COUNT(distinct st.StateStudentIdentifier)) + ', reports.Single(x => x.OrganizationId == ' + convert(varchar(20), s.SeaOrganizationId) + ' && x.REMOVALTYPE == "' + i.RemovalTypeEdFactsCode + '" && x.TotalIndicator == totalIndicator).DisciplineCount);' as code,
   //         COUNT(distinct st.StateStudentIdentifier) as cnt
   //         from rds.FactStudentDisciplines f
   //         inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
   //         and d.SubmissionYear = '2018-19'
   //         inner join rds.DimAges a on f.DimAgeId = a.DimAgeId 
   //         and a.AgeValue >= 3 and a.AgeValue <= 21
   //         inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
   //         and s.DimSchoolId <> -1
   //         inner join rds.DimDisciplines i on f.DimDisciplineId = i.DimDisciplineId
   //         inner join rds.DimIdeaStatuses t on f.DimIdeaStatusId = t.DimIdeaStatusId
   //         inner join rds.DimStudents st on f.DimStudentId = st.DimStudentId
   //         and i.RemovalTypeEdFactsCode <> 'MISSING'
			//and t.EducEnvEdFactsCode != 'PPPS'
   //         --and t.DisabilityId <> -1
			//inner join rds.FactOrganizationCounts fo on f.DimLeaId = fo.DimLeaId
			//and fo.DimSchoolId = -1
			//and fo.DimCountDateId = d.DimDateId
			//and s.SchoolOperationalStatus not in ('Closed','Inactive','Future')
   //         group by s.SeaOrganizationId, i.RemovalTypeEdFactsCode


   //         */

   //         Assert.Equal(75, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(70, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);

   //     }

   //     #endregion

   //     #region LEA Core Tests

   //     //Done - FS005_201718_LEA_OperationalStatus
   //     //TODO - FS005_201718_LEA_IEP
   //     //Done - FS005_201718_LEA_NoCounts
               
   //     [Fact]
   //     public void FS005_201718_Core_LEA_OperationalStatus()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "ST1";
   //         var totalIndicator = "Y";


   //         // Arrange
   //         var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

   //         // Act (without filter)
   //         repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, new List<string>() { "lea_operationalstatus" }, null);

   //         // Assert
   //         var reports = this.fixture.rdsDbContext.FactStudentDisciplineReports
   //             .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
   //             .ToList();

   //         Assert.NotEmpty(reports);

   //         /*
   //         -- SQL used to verify

   //         select
   //         s.LeaOrganizationId,
			//i.RemovalTypeEdFactsCode,
			//'Assert.Equal(' + convert(varchar(20), COUNT(distinct st.StateStudentIdentifier)) + ', reports.Single(x => x.OrganizationId == ' + convert(varchar(20), s.LeaOrganizationId) + ' && x.REMOVALTYPE == "' + i.RemovalTypeEdFactsCode + '" && x.TotalIndicator == totalIndicator).DisciplineCount);' as code,
   //         COUNT(distinct st.StateStudentIdentifier) as cnt
   //         from rds.FactStudentDisciplines f
   //         inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
   //         and d.SubmissionYear = '2018-19'
   //         inner join rds.DimAges a on f.DimAgeId = a.DimAgeId 
   //         and a.AgeValue >= 3 and a.AgeValue <= 21
   //         inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
   //         and s.DimSchoolId <> -1
   //         inner join rds.DimDisciplines i on f.DimDisciplineId = i.DimDisciplineId
   //         inner join rds.DimIdeaStatuses t on f.DimIdeaStatusId = t.DimIdeaStatusId
			//inner join rds.DimDemographics r on f.DimDemographicId = r.DimDemographicId
   //         inner join rds.DimStudents st on f.DimStudentId = st.DimStudentId
   //         and i.RemovalTypeEdFactsCode <> 'MISSING'
   //         and t.DisabilityEdFactsCode <> 'MISSING'
   //         and t.DisabilityId <> -1
			//and t.EducEnvEdFactsCode != 'PPPS'
			//--inner join rds.FactOrganizationCounts fo on f.DimLeaId = fo.DimLeaId
			//--and fo.DimSchoolId = -1
			//--and fo.DimCountDateId = d.DimDateId
			//--inner join rds.DimDirectoryStatuses ds on fo.DimDirectoryStatusId = ds.DimDirectoryStatusId
			//--and ds.OperationalStatusEdFactsCode <> 'Closed'
			//--and ds.OperationalStatusEdFactsCode <> 'Inactive'
			//--and ds.OperationalStatusEdFactsCode <> 'Future'
   //         group by s.LeaOrganizationId, i.RemovalTypeEdFactsCode

   //         */

   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 1207 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(4, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 5140 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(5, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(5, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(33, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(44, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 1207 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(6, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(30, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(47, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);

   //     }

   //     [Fact]
   //     public void FS005_201718_Core_LEA_NoCounts()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "ST1";
   //         var totalIndicator = "Y";


   //         // Arrange
   //         var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

   //         // Act (without filter)
   //         repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, new List<string>() { "lea_operationalstatus" }, null);

   //         // Assert
   //         var reports = this.fixture.rdsDbContext.FactStudentDisciplineReports
   //             .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
   //             .ToList();

   //         Assert.NotEmpty(reports);

   //         Assert.Empty(reports.Where(x => x.DisciplineCount == 0));

   //     }

   //     #endregion

   //     #region SEA / CSA Tests

   //     //Done - FS005_201718_SEA_CSA_Categories
   //     //Done - FS005_201718_SEA_CSA_InterimRemoval
   //     //Done - FS005_201718_SEA_CSA_Disability
   //     //Done - FS005_201718_SEA_CSA_InterimRemoval_Missing
   //     //Done - FS005_201718_SEA_CSA_Disability_Missing
   //     //Done - FS005_201718_SEA_CSA_TotalIndicator
   //     //Done - FS005_201718_SEA_CSA_Count

   //     [Fact]
   //     public void FS005_201718_SEA_CSA_Categories()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSA";
   //         var totalIndicator = "N";
   //         var categoryList = "|DISABCATIDEA||REMOVALTYPE|";

   //         this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSA_InterimRemoval()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSA";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_InterimRemoval_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }
        
   //     [Fact]
   //     public void FS005_201718_SEA_CSA_Disability()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSA";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_Disability_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSA_InterimRemoval_Missing()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSA";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_InterimRemoval_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSA_Disability_Missing()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSA";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_Disability_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSA_TotalIndicator()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSA";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_TotalIndicator_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSA_Count()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSA";
   //         var totalIndicator = "N";

   //         // Arrange
   //         var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

   //         // Act
   //         repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

   //         // Assert
   //         var reports = this.fixture.rdsDbContext.FactStudentDisciplineReports
   //             .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
   //             .ToList();

   //         Assert.NotEmpty(reports);


   //         /*
   //         -- SQL used to verify

   //         select
   //         s.SeaOrganizationId,
  	//		'Assert.Equal(' + convert(varchar(20), COUNT(distinct st.StateStudentIdentifier)) + ', reports.Single(x => x.OrganizationId == ' + convert(varchar(20), s.SeaOrganizationId) + ' && x.REMOVALTYPE == "' + i.RemovalTypeEdFactsCode + '" && x.DISABILITY == "' + DisabilityEdFactsCode + '" && x.TotalIndicator == totalIndicator).DisciplineCount);' as code,
   //         i.RemovalTypeEdFactsCode, t.DisabilityEdFactsCode,
   //         COUNT(distinct st.StateStudentIdentifier) as cnt
   //         from rds.FactStudentDisciplines f
   //         inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
   //         and d.SubmissionYear = '2018-19'
   //         inner join rds.DimAges a on f.DimAgeId = a.DimAgeId 
   //         and a.AgeValue >= 3 and a.AgeValue <= 21
   //         inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
   //         and s.DimSchoolId <> -1
   //         inner join rds.DimDisciplines i on f.DimDisciplineId = i.DimDisciplineId
   //         inner join rds.DimIdeaStatuses t on f.DimIdeaStatusId = t.DimIdeaStatusId
   //         inner join rds.DimStudents st on f.DimStudentId = st.DimStudentId
   //         and i.RemovalTypeEdFactsCode <> 'MISSING'
			//and t.DisabilityEdFactsCode <> 'MISSING'
			//and t.EducEnvEdFactsCode != 'PPPS'
   //         and t.DisabilityId <> -1
			//inner join rds.FactOrganizationCounts fo on f.DimLeaId = fo.DimLeaId
			//and fo.DimSchoolId = -1
			//and fo.DimCountDateId = d.DimDateId
			//inner join rds.DimDirectoryStatuses ds on fo.DimDirectoryStatusId = ds.DimDirectoryStatusId
			//and ds.OperationalStatusEdFactsCode <> 'Closed'
			//and ds.OperationalStatusEdFactsCode <> 'Inactive'
			//and ds.OperationalStatusEdFactsCode <> 'Future'
   //         group by s.SeaOrganizationId, i.RemovalTypeEdFactsCode, t.DisabilityEdFactsCode


   //         */

   //         //Assert.Equal(5, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "AUT" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(9, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "DB" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(7, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "DD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(7, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "EMN" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(5, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "HI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(6, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "MD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(11, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "MR" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(8, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "OHI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(8, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "OI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(5, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "SLD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(11, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "SLI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(9, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "TBI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(8, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "VI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(8, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "AUT" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(6, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "DB" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(11, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "DD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(8, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "EMN" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "HI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(7, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "MD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(11, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "MR" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "OHI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(6, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "OI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(11, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "SLD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(7, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "SLI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(9, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "TBI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(7, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "VI" && x.TotalIndicator == totalIndicator).DisciplineCount);

   //     }


   //     #endregion

   //     #region SEA / CSB Tests

   //     //Done - FS005_201718_SEA_CSB_Categories
   //     //Done - FS005_201718_SEA_CSB_InterimRemoval
   //     //Done - FS005_201718_SEA_CSB_RacialEthnic
   //     //Done - FS005_201718_SEA_CSB_InterimRemoval_Missing
   //     //Done - FS005_201718_SEA_CSB_RacialEthnic_Missing
   //     //Done - FS005_201718_SEA_CSB_TotalIndicator
   //     //Done - FS005_201718_SEA_CSB_Count

   //     [Fact]
   //     public void FS005_201718_SEA_CSB_Categories()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSB";
   //         var totalIndicator = "N";
   //         var categoryList = "|RACEETHNIC||REMOVALTYPE|";

   //         this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSB_InterimRemoval()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSB";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_InterimRemoval_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSB_RacialEthnic()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSB";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_RacialEthnic_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSB_InterimRemoval_Missing()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSB";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_InterimRemoval_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSB_RacialEthnic_Missing()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSB";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_RacialEthnic_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSB_TotalIndicator()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSB";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_TotalIndicator_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSB_Count()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSB";
   //         var totalIndicator = "N";

   //         // Arrange
   //         var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

   //         // Act
   //         repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

   //         // Assert
   //         var reports = this.fixture.rdsDbContext.FactStudentDisciplineReports
   //             .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
   //             .ToList();

   //         Assert.NotEmpty(reports);


   //         /*
   //         -- SQL used to verify

   //         select
   //         s.SeaOrganizationId,
  	//		'Assert.Equal(' + convert(varchar(20), COUNT(distinct st.StateStudentIdentifier)) + ', reports.Single(x => x.OrganizationId == ' + convert(varchar(20), s.SeaOrganizationId) + ' && x.REMOVALTYPE == "' + i.RemovalTypeEdFactsCode + '" && x.RACE == "' + RaceCode + '" && x.TotalIndicator == totalIndicator).DisciplineCount);' as code,
   //         i.RemovalTypeEdFactsCode, r.RaceCode,
   //         COUNT(distinct st.StateStudentIdentifier) as cnt
   //         from rds.FactStudentDisciplines f
   //         inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
   //         and d.SubmissionYear = '2017-18'
   //         inner join rds.DimAges a on f.DimAgeId = a.DimAgeId 
   //         and a.AgeValue >= 3 and a.AgeValue <= 21
   //         inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
   //         and s.DimSchoolId <> -1
   //         inner join rds.DimDisciplines i on f.DimDisciplineId = i.DimDisciplineId
   //         inner join rds.DimIdeaStatuses t on f.DimIdeaStatusId = t.DimIdeaStatusId
			//inner join rds.DimRaces r on f.DimRaceId = r.DimRaceId
   //         inner join rds.DimStudents st on f.DimStudentId = st.DimStudentId
   //         and i.RemovalTypeEdFactsCode <> 'MISSING'
			//and r.RaceCode <> 'MISSING'
			//and t.EducEnvEdFactsCode != 'PPPS'
   //         and t.DisabilityId <> -1
			//inner join rds.FactOrganizationCounts fo on f.DimLeaId = fo.DimLeaId
			//and fo.DimSchoolId = -1
			//and fo.DimCountDateId = d.DimDateId
			//inner join rds.DimDirectoryStatuses ds on fo.DimDirectoryStatusId = ds.DimDirectoryStatusId
			//and ds.OperationalStatusEdFactsCode <> 'Closed'
			//and ds.OperationalStatusEdFactsCode <> 'Inactive'
			//and ds.OperationalStatusEdFactsCode <> 'Future'
   //         group by s.SeaOrganizationId, i.RemovalTypeEdFactsCode, r.RaceCode

   //         */

   //         Assert.Equal(3, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.RACE == "AM7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(1, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.RACE == "AS7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(4, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.RACE == "BL7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(8, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.RACE == "HI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(3, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.RACE == "MU7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(3, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.RACE == "PI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(2, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.RACE == "WH7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(2, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.RACE == "AM7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(5, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.RACE == "AS7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(4, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.RACE == "BL7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(3, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.RACE == "HI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(4, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.RACE == "MU7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(5, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.RACE == "PI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(1, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.RACE == "WH7" && x.TotalIndicator == totalIndicator).DisciplineCount);

   //     }

   //     #endregion

   //     #region SEA / CSC Tests

   //     //Done - FS005_201718_SEA_CSC_Categories
   //     //Done - FS005_201718_SEA_CSC_InterimRemoval
   //     //Done - FS005_201718_SEA_CSC_Sex
   //     //Done - FS005_201718_SEA_CSC_InterimRemoval_Missing
   //     //Done - FS005_201718_SEA_CSC_Sex_Missing
   //     //Done - FS005_201718_SEA_CSC_TotalIndicator
   //     //Done - FS005_201718_SEA_CSC_Count

   //     [Fact]
   //     public void FS005_201718_SEA_CSC_Categories()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSC";
   //         var totalIndicator = "N";
   //         var categoryList = "|REMOVALTYPE||SEX|";

   //         this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSC_InterimRemoval()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSC";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_InterimRemoval_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSC_Sex()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSC";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_Sex_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSC_InterimRemoval_Missing()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSC";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_InterimRemoval_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSC_Sex_Missing()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSC";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_Sex_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSC_TotalIndicator()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSC";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_TotalIndicator_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSC_Count()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSC";
   //         var totalIndicator = "N";

   //         // Arrange
   //         var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

   //         // Act
   //         repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

   //         // Assert
   //         var reports = this.fixture.rdsDbContext.FactStudentDisciplineReports
   //             .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
   //             .ToList();

   //         Assert.NotEmpty(reports);


   //         /*
   //         -- SQL used to verify

   //         select
   //         s.SeaOrganizationId,
  	//		'Assert.Equal(' + convert(varchar(20), COUNT(distinct st.StateStudentIdentifier)) + ', reports.Single(x => x.OrganizationId == ' + convert(varchar(20), s.SeaOrganizationId) + ' && x.REMOVALTYPE == "' + i.RemovalTypeEdFactsCode + '" && x.SEX == "' + r.SexEdFactsCode + '" && x.TotalIndicator == totalIndicator).DisciplineCount);' as code,
   //         i.RemovalTypeEdFactsCode, r.SexEdFactsCode,
   //         COUNT(distinct st.StateStudentIdentifier) as cnt
   //         from rds.FactStudentDisciplines f
   //         inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
   //         and d.SubmissionYear = '2017-18'
   //         inner join rds.DimAges a on f.DimAgeId = a.DimAgeId 
   //         and a.AgeValue >= 3 and a.AgeValue <= 21
   //         inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
   //         and s.DimSchoolId <> -1
   //         inner join rds.DimDisciplines i on f.DimDisciplineId = i.DimDisciplineId
   //         inner join rds.DimIdeaStatuses t on f.DimIdeaStatusId = t.DimIdeaStatusId
			//inner join rds.DimDemographics r on f.DimDemographicId = r.DimDemographicId
   //         inner join rds.DimStudents st on f.DimStudentId = st.DimStudentId
   //         and i.RemovalTypeEdFactsCode <> 'MISSING'
   //         and r.SexEdFactsCode <> 'MISSING'
			//and t.EducEnvEdFactsCode != 'PPPS'
   //         and t.DisabilityId <> -1
			//inner join rds.FactOrganizationCounts fo on f.DimLeaId = fo.DimLeaId
			//and fo.DimSchoolId = -1
			//and fo.DimCountDateId = d.DimDateId
			//inner join rds.DimDirectoryStatuses ds on fo.DimDirectoryStatusId = ds.DimDirectoryStatusId
			//and ds.OperationalStatusEdFactsCode <> 'Closed'
			//and ds.OperationalStatusEdFactsCode <> 'Inactive'
			//and ds.OperationalStatusEdFactsCode <> 'Future'
   //         group by s.SeaOrganizationId, i.RemovalTypeEdFactsCode, r.SexEdFactsCode


   //         */

   //         Assert.Equal(3, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.SEX == "F" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(9, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.SEX == "M" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(6, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.SEX == "F" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(6, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.SEX == "M" && x.TotalIndicator == totalIndicator).DisciplineCount);

   //     }

   //     #endregion

   //     #region SEA / CSD Tests

   //     //Done - FS005_201718_SEA_CSD_Categories
   //     //Done - FS005_201718_SEA_CSD_InterimRemoval
   //     //Done - FS005_201718_SEA_CSD_EnglishLearner
   //     //Done - FS005_201718_SEA_CSD_InterimRemoval_Missing
   //     //Done - FS005_201718_SEA_CSD_EnglishLearner_Missing
   //     //Done - FS005_201718_SEA_CSD_TotalIndicator
   //     //Done - FS005_201718_SEA_CSD_Count

   //     [Fact]
   //     public void FS005_201718_SEA_CSD_Categories()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSD";
   //         var totalIndicator = "N";
   //         var categoryList = "|LEPBOTH||REMOVALTYPE|";

   //         this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSD_InterimRemoval()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSD";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_InterimRemoval_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSD_EnglishLearner()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSD";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_EnglishLearner_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSD_InterimRemoval_Missing()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSD";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_InterimRemoval_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSD_EnglishLearner_Missing()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSD";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_EnglishLearner_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSD_TotalIndicator()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSD";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_TotalIndicator_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_CSD_Count()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "CSD";
   //         var totalIndicator = "N";

   //         // Arrange
   //         var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

   //         // Act
   //         repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

   //         // Assert
   //         var reports = this.fixture.rdsDbContext.FactStudentDisciplineReports
   //             .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
   //             .ToList();

   //         Assert.NotEmpty(reports);


   //         /*
   //         -- SQL used to verify
            

   //         select
   //         s.SeaOrganizationId,
  	//		'Assert.Equal(' + convert(varchar(20), COUNT(distinct st.StateStudentIdentifier)) + ', reports.Single(x => x.OrganizationId == ' + convert(varchar(20), s.SeaOrganizationId) + ' && x.REMOVALTYPE == "' + i.RemovalTypeEdFactsCode + '" && x.LEPSTATUS == "' + r.LepStatusEdFactsCode + '" && x.TotalIndicator == totalIndicator).DisciplineCount);' as code,
   //         i.RemovalTypeEdFactsCode, r.LepStatusEdFactsCode,
   //         COUNT(distinct st.StateStudentIdentifier) as cnt
   //         from rds.FactStudentDisciplines f
   //         inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
   //         and d.SubmissionYear = '2017-18'
   //         inner join rds.DimAges a on f.DimAgeId = a.DimAgeId 
   //         and a.AgeValue >= 3 and a.AgeValue <= 21
   //         inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
   //         and s.DimSchoolId <> -1
   //         inner join rds.DimDisciplines i on f.DimDisciplineId = i.DimDisciplineId
   //         inner join rds.DimIdeaStatuses t on f.DimIdeaStatusId = t.DimIdeaStatusId
			//inner join rds.DimDemographics r on f.DimDemographicId = r.DimDemographicId
   //         inner join rds.DimStudents st on f.DimStudentId = st.DimStudentId
   //         and i.RemovalTypeEdFactsCode <> 'MISSING'
   //         and r.LepStatusEdFactsCode <> 'MISSING'
   //         and r.LepStatusEdFactsCode <> 'LEPP'
   //         and t.EducEnvEdFactsCode != 'PPPS'
   //         and t.DisabilityId <> -1
			//inner join rds.FactOrganizationCounts fo on f.DimLeaId = fo.DimLeaId
			//and fo.DimSchoolId = -1
			//and fo.DimCountDateId = d.DimDateId
			//inner join rds.DimDirectoryStatuses ds on fo.DimDirectoryStatusId = ds.DimDirectoryStatusId
			//and ds.OperationalStatusEdFactsCode <> 'Closed'
			//and ds.OperationalStatusEdFactsCode <> 'Inactive'
			//and ds.OperationalStatusEdFactsCode <> 'Future'
   //         group by s.SeaOrganizationId, i.RemovalTypeEdFactsCode, r.LepStatusEdFactsCode


   //         */

   //         Assert.Equal(7, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.LEPSTATUS == "LEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(9, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.LEPSTATUS == "NLEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(6, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.LEPSTATUS == "LEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(8, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.LEPSTATUS == "NLEP" && x.TotalIndicator == totalIndicator).DisciplineCount);

   //     }

   //     #endregion
        
   //     #region SEA / ST1 Tests

   //     //Done - FS005_201718_SEA_ST1_Categories
   //     //Done - FS005_201718_SEA_ST1_InterimRemoval
   //     //Done - FS005_201718_SEA_ST1_InterimRemoval_Missing
   //     //Done - FS005_201718_SEA_ST1_TotalIndicator
   //     //Done - FS005_201718_SEA_ST1_Count

   //     [Fact]
   //     public void FS005_201718_SEA_ST1_Categories()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "ST1";
   //         var totalIndicator = "Y";
   //         var categoryList = "|REMOVALTYPE|";

   //         this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_ST1_InterimRemoval()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "ST1";
   //         var totalIndicator = "Y";

   //         this.fixture.CategorySet_InterimRemoval_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_ST1_InterimRemoval_Missing()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "ST1";
   //         var totalIndicator = "Y";

   //         this.fixture.CategorySet_InterimRemoval_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }
        
   //     [Fact]
   //     public void FS005_201718_SEA_ST1_TotalIndicator()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "ST1";
   //         var totalIndicator = "Y";

   //         this.fixture.CategorySet_TotalIndicator_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_SEA_ST1_Count()
   //     {
   //         var reportLevel = "sea";
   //         var categorySetCode = "ST1";
   //         var totalIndicator = "Y";


   //         // Arrange
   //         var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

   //         // Act
   //         repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

   //         // Assert
   //         var reports = this.fixture.rdsDbContext.FactStudentDisciplineReports
   //             .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
   //             .ToList();

   //         Assert.NotEmpty(reports);

   //         /*
   //         -- SQL used to verify

   //         select
   //         s.SeaOrganizationId,
   //         i.RemovalTypeEdFactsCode,
  	//		'Assert.Equal(' + convert(varchar(20), COUNT(distinct st.StateStudentIdentifier)) + ', reports.Single(x => x.OrganizationId == ' + convert(varchar(20), s.SeaOrganizationId) + ' && x.REMOVALTYPE == "' + i.RemovalTypeEdFactsCode + '" && x.TotalIndicator == totalIndicator).DisciplineCount);' as code,
   //         COUNT(distinct st.StateStudentIdentifier) as cnt
   //         from rds.FactStudentDisciplines f
   //         inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
   //         and d.SubmissionYear = '2017-18'
   //         inner join rds.DimAges a on f.DimAgeId = a.DimAgeId 
   //         and a.AgeValue >= 3 and a.AgeValue <= 21
   //         inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
   //         and s.DimSchoolId <> -1
   //         inner join rds.DimDisciplines i on f.DimDisciplineId = i.DimDisciplineId
   //         inner join rds.DimIdeaStatuses t on f.DimIdeaStatusId = t.DimIdeaStatusId
   //         inner join rds.DimStudents st on f.DimStudentId = st.DimStudentId
   //         and i.RemovalTypeEdFactsCode <> 'MISSING'
			//and t.EducEnvEdFactsCode != 'PPPS'            
   //         and t.DisabilityId <> -1
			//inner join rds.FactOrganizationCounts fo on f.DimLeaId = fo.DimLeaId
			//and fo.DimSchoolId = -1
			//and fo.DimCountDateId = d.DimDateId
			//inner join rds.DimDirectoryStatuses ds on fo.DimDirectoryStatusId = ds.DimDirectoryStatusId
			//and ds.OperationalStatusEdFactsCode <> 'Closed'
			//and ds.OperationalStatusEdFactsCode <> 'Inactive'
			//and ds.OperationalStatusEdFactsCode <> 'Future'
   //         group by s.SeaOrganizationId, i.RemovalTypeEdFactsCode

   //         */

   //         Assert.Equal(24, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         Assert.Equal(24, reports.Single(x => x.OrganizationId == 48 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //     }

   //     #endregion

   //     #region LEA / CSA Tests

   //     //Done - FS005_201718_LEA_CSA_Categories
   //     //Done - FS005_201718_LEA_CSA_InterimRemoval
   //     //Done - FS005_201718_LEA_CSA_Disability
   //     //Done - FS005_201718_LEA_CSA_InterimRemoval_Missing
   //     //Done - FS005_201718_LEA_CSA_Disability_Missing
   //     //Done - FS005_201718_LEA_CSA_TotalIndicator
   //     //Done - FS005_201718_LEA_CSA_Count

   //     [Fact]
   //     public void FS005_201718_LEA_CSA_Categories()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSA";
   //         var totalIndicator = "N";
   //         var categoryList = "|DISABCATIDEA||REMOVALTYPE|";

   //         this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

   //     }
        
   //     [Fact]
   //     public void FS005_201718_LEA_CSA_InterimRemoval()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSA";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_InterimRemoval_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSA_Disability()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSA";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_Disability_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);
   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSA_InterimRemoval_Missing()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSA";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_InterimRemoval_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSA_Disability_Missing()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSA";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_Disability_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSA_TotalIndicator()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSA";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_TotalIndicator_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSA_Count()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSA";
   //         var totalIndicator = "N";

   //         // Arrange
   //         var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

   //         // Act
   //         repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

   //         // Assert
   //         var reports = this.fixture.rdsDbContext.FactStudentDisciplineReports
   //             .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
   //             .ToList();

   //         Assert.NotEmpty(reports);


   //         /*
   //         -- SQL used to verify

   //         select
   //         s.LeaOrganizationId,
			//i.RemovalTypeEdFactsCode, t.DisabilityEdFactsCode,
			//'Assert.Equal(' + convert(varchar(20), COUNT(distinct st.StateStudentIdentifier)) + ', reports.Single(x => x.OrganizationId == ' + convert(varchar(20), s.LeaOrganizationId) + ' && x.REMOVALTYPE == "' + i.RemovalTypeEdFactsCode + '" && x.DISABILITY == "' + DisabilityEdFactsCode + '" && x.TotalIndicator == totalIndicator).DisciplineCount);' as code,
   //         COUNT(distinct st.StateStudentIdentifier) as cnt
   //         from rds.FactStudentDisciplines f
   //         inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
   //         and d.SubmissionYear = '2017-18'
   //         inner join rds.DimAges a on f.DimAgeId = a.DimAgeId 
   //         and a.AgeValue >= 3 and a.AgeValue <= 21
   //         inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
   //         and s.DimSchoolId <> -1
   //         inner join rds.DimDisciplines i on f.DimDisciplineId = i.DimDisciplineId
   //         inner join rds.DimIdeaStatuses t on f.DimIdeaStatusId = t.DimIdeaStatusId
   //         inner join rds.DimStudents st on f.DimStudentId = st.DimStudentId
   //         and i.RemovalTypeEdFactsCode <> 'MISSING'
   //         and t.DisabilityEdFactsCode <> 'MISSING'
   //         and t.DisabilityId <> -1
			//and t.EducEnvEdFactsCode != 'PPPS'
			//inner join rds.FactOrganizationCounts fo on f.DimLeaId = fo.DimLeaId
			//and fo.DimSchoolId = -1
			//and fo.DimCountDateId = d.DimDateId
			//inner join rds.DimDirectoryStatuses ds on fo.DimDirectoryStatusId = ds.DimDirectoryStatusId
			//and ds.OperationalStatusEdFactsCode <> 'Closed'
			//and ds.OperationalStatusEdFactsCode <> 'Inactive'
			//and ds.OperationalStatusEdFactsCode <> 'Future'
   //         group by s.LeaOrganizationId, i.RemovalTypeEdFactsCode, t.DisabilityEdFactsCode

   //         */

   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 1207 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "AUT" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 1207 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "DD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 1207 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "AUT" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 1207 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "DB" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "EMN" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "HI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "OI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "AUT" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "SLD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "AUT" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "EMN" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "HI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "MR" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "SLI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "AUT" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "DD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "MD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "SLI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5140 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "DD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5140 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "VI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "HI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "MD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "OHI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "TBI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "DB" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "DB" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "DD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "MD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "MR" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "VI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "DD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "EMN" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "TBI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "DB" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "DD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "EMN" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "HI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "MD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "MR" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "OHI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(4, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "OI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "SLD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(5, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "SLI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "TBI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(4, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "VI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "AUT" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "DD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "EMN" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "MD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "MR" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "OHI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "OI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(4, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "SLD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "SLI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(6, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "TBI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(4, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "VI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "AUT" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(5, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "DB" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "DD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(4, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "EMN" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "HI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "MD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(6, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "MR" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(4, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "OHI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "OI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "SLD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(5, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "SLI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(5, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "TBI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.DISABILITY == "VI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "AUT" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(4, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "DB" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(6, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "DD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(4, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "EMN" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "HI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(4, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "MD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(10, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "MR" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "OHI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "OI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(6, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "SLD" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "SLI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "TBI" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.DISABILITY == "VI" && x.TotalIndicator == totalIndicator).DisciplineCount);

   //     }

   //     #endregion

   //     #region LEA / CSB Tests

   //     //Done - FS005_201718_LEA_CSB_Categories
   //     //Done - FS005_201718_LEA_CSB_InterimRemoval
   //     //Done - FS005_201718_LEA_CSB_RacialEthnic
   //     //Done - FS005_201718_LEA_CSB_InterimRemoval_Missing
   //     //Done - FS005_201718_LEA_CSB_RacialEthnic_Missing
   //     //Done - FS005_201718_LEA_CSB_TotalIndicator
   //     //Done - FS005_201718_LEA_CSB_Count

   //     [Fact]
   //     public void FS005_201718_LEA_CSB_Categories()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSB";
   //         var totalIndicator = "N";
   //         var categoryList = "|RACEETHNIC||REMOVALTYPE|";

   //         this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSB_InterimRemoval()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSB";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_InterimRemoval_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSB_RacialEthnic()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSB";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_RacialEthnic_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);
   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSB_InterimRemoval_Missing()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSB";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_InterimRemoval_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSB_RacialEthnic_Missing()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSB";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_RacialEthnic_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSB_TotalIndicator()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSB";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_TotalIndicator_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSB_Count()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSB";
   //         var totalIndicator = "N";

   //         // Arrange
   //         var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

   //         // Act
   //         repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

   //         // Assert
   //         var reports = this.fixture.rdsDbContext.FactStudentDisciplineReports
   //             .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
   //             .ToList();

   //         Assert.NotEmpty(reports);


   //         /*
   //         -- SQL used to verify


   //         select
   //         s.LeaOrganizationId,
			//i.RemovalTypeEdFactsCode, r.RaceCode,
			//'Assert.Equal(' + convert(varchar(20), COUNT(distinct st.StateStudentIdentifier)) + ', reports.Single(x => x.OrganizationId == ' + convert(varchar(20), s.LeaOrganizationId) + ' && x.REMOVALTYPE == "' + i.RemovalTypeEdFactsCode + '" && x.RACE == "' + r.RaceCode + '" && x.TotalIndicator == totalIndicator).DisciplineCount);' as code,
   //         COUNT(distinct st.StateStudentIdentifier) as cnt
   //         from rds.FactStudentDisciplines f
   //         inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
   //         and d.SubmissionYear = '2017-18'
   //         inner join rds.DimAges a on f.DimAgeId = a.DimAgeId 
   //         and a.AgeValue >= 3 and a.AgeValue <= 21
   //         inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
   //         and s.DimSchoolId <> -1
   //         inner join rds.DimDisciplines i on f.DimDisciplineId = i.DimDisciplineId
   //         inner join rds.DimIdeaStatuses t on f.DimIdeaStatusId = t.DimIdeaStatusId
			//inner join rds.DimRaces r on f.DimRaceId = r.DimRaceId
   //         inner join rds.DimStudents st on f.DimStudentId = st.DimStudentId
   //         and i.RemovalTypeEdFactsCode <> 'MISSING'
   //         and r.RaceCode <> 'MISSING'
   //         and t.DisabilityEdFactsCode <> 'MISSING'
   //         and t.DisabilityId <> -1
			//and t.EducEnvEdFactsCode != 'PPPS'
			//inner join rds.FactOrganizationCounts fo on f.DimLeaId = fo.DimLeaId
			//and fo.DimSchoolId = -1
			//and fo.DimCountDateId = d.DimDateId
			//inner join rds.DimDirectoryStatuses ds on fo.DimDirectoryStatusId = ds.DimDirectoryStatusId
			//and ds.OperationalStatusEdFactsCode <> 'Closed'
			//and ds.OperationalStatusEdFactsCode <> 'Inactive'
			//and ds.OperationalStatusEdFactsCode <> 'Future'
   //         group by s.LeaOrganizationId, i.RemovalTypeEdFactsCode, r.RaceCode

   //         */

   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 1207 && x.REMOVALTYPE == "REMDW" && x.RACE == "PI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 1207 && x.REMOVALTYPE == "REMHO" && x.RACE == "PI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMDW" && x.RACE == "AM7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMDW" && x.RACE == "BL7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMDW" && x.RACE == "MU7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMHO" && x.RACE == "AS7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMHO" && x.RACE == "PI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMHO" && x.RACE == "WH7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMDW" && x.RACE == "AM7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMDW" && x.RACE == "AS7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMDW" && x.RACE == "BL7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMHO" && x.RACE == "AM7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMHO" && x.RACE == "BL7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMHO" && x.RACE == "MU7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMHO" && x.RACE == "PI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 5140 && x.REMOVALTYPE == "REMDW" && x.RACE == "HI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMDW" && x.RACE == "AM7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMDW" && x.RACE == "BL7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMDW" && x.RACE == "WH7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMHO" && x.RACE == "HI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMDW" && x.RACE == "AS7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMDW" && x.RACE == "BL7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMDW" && x.RACE == "HI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMDW" && x.RACE == "MU7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMDW" && x.RACE == "PI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMHO" && x.RACE == "HI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMHO" && x.RACE == "PI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMHO" && x.RACE == "WH7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(4, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.RACE == "AM7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.RACE == "AS7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(10, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.RACE == "BL7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(7, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.RACE == "HI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.RACE == "MU7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.RACE == "PI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(5, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.RACE == "WH7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(6, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.RACE == "AM7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.RACE == "AS7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(4, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.RACE == "BL7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.RACE == "HI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(10, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.RACE == "MU7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.RACE == "PI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(4, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.RACE == "WH7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(7, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.RACE == "AM7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(6, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.RACE == "AS7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(7, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.RACE == "BL7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(10, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.RACE == "HI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.RACE == "MU7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(6, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.RACE == "PI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(5, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.RACE == "WH7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(11, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.RACE == "AM7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(7, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.RACE == "AS7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(8, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.RACE == "BL7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(6, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.RACE == "HI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(5, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.RACE == "MU7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(5, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.RACE == "PI7" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(6, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.RACE == "WH7" && x.TotalIndicator == totalIndicator).DisciplineCount);

   //     }

   //     #endregion

   //     #region LEA / CSC Tests

   //     //Done - FS005_201718_LEA_CSC_Categories
   //     //Done - FS005_201718_LEA_CSC_InterimRemoval
   //     //Done - FS005_201718_LEA_CSC_Sex
   //     //Done - FS005_201718_LEA_CSC_InterimRemoval_Missing
   //     //Done - FS005_201718_LEA_CSC_Sex_Missing
   //     //Done - FS005_201718_LEA_CSC_TotalIndicator
   //     //Done - FS005_201718_LEA_CSC_Count

   //     [Fact]
   //     public void FS005_201718_LEA_CSC_Categories()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSC";
   //         var totalIndicator = "N";
   //         var categoryList = "|REMOVALTYPE||SEX|";

   //         this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSC_InterimRemoval()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSC";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_InterimRemoval_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSC_Sex()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSC";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_Sex_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);
   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSC_InterimRemoval_Missing()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSC";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_InterimRemoval_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSC_Sex_Missing()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSC";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_Sex_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSC_TotalIndicator()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSC";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_TotalIndicator_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSC_Count()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSC";
   //         var totalIndicator = "N";

   //         // Arrange
   //         var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

   //         // Act
   //         repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

   //         // Assert
   //         var reports = this.fixture.rdsDbContext.FactStudentDisciplineReports
   //             .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
   //             .ToList();

   //         Assert.NotEmpty(reports);


   //         /*
   //         -- SQL used to verify

            
   //         select
   //         s.LeaOrganizationId,
			//i.RemovalTypeEdFactsCode, r.SexEdFactsCode,
			//'Assert.Equal(' + convert(varchar(20), COUNT(distinct st.StateStudentIdentifier)) + ', reports.Single(x => x.OrganizationId == ' + convert(varchar(20), s.LeaOrganizationId) + ' && x.REMOVALTYPE == "' + i.RemovalTypeEdFactsCode + '" && x.SEX == "' + r.SexEdFactsCode + '" && x.TotalIndicator == totalIndicator).DisciplineCount);' as code,
   //         COUNT(distinct st.StateStudentIdentifier) as cnt
   //         from rds.FactStudentDisciplines f
   //         inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
   //         and d.SubmissionYear = '2017-18'
   //         inner join rds.DimAges a on f.DimAgeId = a.DimAgeId 
   //         and a.AgeValue >= 3 and a.AgeValue <= 21
   //         inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
   //         and s.DimSchoolId <> -1
   //         inner join rds.DimDisciplines i on f.DimDisciplineId = i.DimDisciplineId
   //         inner join rds.DimIdeaStatuses t on f.DimIdeaStatusId = t.DimIdeaStatusId
			//inner join rds.DimDemographics r on f.DimDemographicId = r.DimDemographicId
   //         inner join rds.DimStudents st on f.DimStudentId = st.DimStudentId
   //         and i.RemovalTypeEdFactsCode <> 'MISSING'
   //         and t.DisabilityEdFactsCode <> 'MISSING'
			//and r.SexEdFactsCode <> 'MISSING'
   //         and t.DisabilityId <> -1
			//and t.EducEnvEdFactsCode != 'PPPS'
			//inner join rds.FactOrganizationCounts fo on f.DimLeaId = fo.DimLeaId
			//and fo.DimSchoolId = -1
			//and fo.DimCountDateId = d.DimDateId
			//inner join rds.DimDirectoryStatuses ds on fo.DimDirectoryStatusId = ds.DimDirectoryStatusId
			//and ds.OperationalStatusEdFactsCode <> 'Closed'
			//and ds.OperationalStatusEdFactsCode <> 'Inactive'
			//and ds.OperationalStatusEdFactsCode <> 'Future'
   //         group by s.LeaOrganizationId, i.RemovalTypeEdFactsCode, r.SexEdFactsCode

   //         */

   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 1207 && x.REMOVALTYPE == "REMHO" && x.SEX == "M" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMDW" && x.SEX == "F" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMDW" && x.SEX == "M" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMDW" && x.SEX == "F" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMDW" && x.SEX == "M" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMHO" && x.SEX == "M" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5140 && x.REMOVALTYPE == "REMDW" && x.SEX == "F" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMDW" && x.SEX == "M" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMHO" && x.SEX == "M" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMDW" && x.SEX == "F" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMDW" && x.SEX == "M" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMHO" && x.SEX == "F" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMHO" && x.SEX == "M" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(11, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.SEX == "F" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(12, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.SEX == "M" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(10, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.SEX == "F" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(12, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.SEX == "M" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(11, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.SEX == "F" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(12, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.SEX == "M" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(11, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.SEX == "F" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(8, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.SEX == "M" && x.TotalIndicator == totalIndicator).DisciplineCount);

   //     }

   //     #endregion

   //     #region LEA / CSD Tests

   //     //FS005_201718_LEA_CSD_Categories
   //     //FS005_201718_LEA_CSD_InterimRemoval
   //     //FS005_201718_LEA_CSD_EnglishLearner
   //     //FS005_201718_LEA_CSD_InterimRemoval_Missing
   //     //FS005_201718_LEA_CSD_EnglishLearner_Missing
   //     //FS005_201718_LEA_CSD_TotalIndicator
   //     //FS005_201718_LEA_CSD_Count

   //     [Fact]
   //     public void FS005_201718_LEA_CSD_Categories()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSD";
   //         var totalIndicator = "N";
   //         var categoryList = "|LEPBOTH||REMOVALTYPE|";

   //         this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSD_InterimRemoval()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSD";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_InterimRemoval_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSD_EnglishLearner()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSD";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_EnglishLearner_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);
   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSD_InterimRemoval_Missing()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSD";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_InterimRemoval_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSD_EnglishLearner_Missing()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSD";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_EnglishLearner_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSD_TotalIndicator()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSD";
   //         var totalIndicator = "N";

   //         this.fixture.CategorySet_TotalIndicator_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_CSD_Count()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "CSD";
   //         var totalIndicator = "N";

   //         // Arrange
   //         var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

   //         // Act
   //         repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

   //         // Assert
   //         var reports = this.fixture.rdsDbContext.FactStudentDisciplineReports
   //             .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
   //             .ToList();

   //         Assert.NotEmpty(reports);


   //         /*
   //         -- SQL used to verify

            

   //         select
   //         s.LeaOrganizationId,
			//i.RemovalTypeEdFactsCode, r.LepStatusEdFactsCode,
			//'Assert.Equal(' + convert(varchar(20), COUNT(distinct st.StateStudentIdentifier)) + ', reports.Single(x => x.OrganizationId == ' + convert(varchar(20), s.LeaOrganizationId) + ' && x.REMOVALTYPE == "' + i.RemovalTypeEdFactsCode + '" && x.LEPSTATUS == "' + r.LepStatusEdFactsCode + '" && x.TotalIndicator == totalIndicator).DisciplineCount);' as code,
   //         COUNT(distinct st.StateStudentIdentifier) as cnt
   //         from rds.FactStudentDisciplines f
   //         inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
   //         and d.SubmissionYear = '2017-18'
   //         inner join rds.DimAges a on f.DimAgeId = a.DimAgeId 
   //         and a.AgeValue >= 3 and a.AgeValue <= 21
   //         inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
   //         and s.DimSchoolId <> -1
   //         inner join rds.DimDisciplines i on f.DimDisciplineId = i.DimDisciplineId
   //         inner join rds.DimIdeaStatuses t on f.DimIdeaStatusId = t.DimIdeaStatusId
			//inner join rds.DimDemographics r on f.DimDemographicId = r.DimDemographicId
   //         inner join rds.DimStudents st on f.DimStudentId = st.DimStudentId
   //         and i.RemovalTypeEdFactsCode <> 'MISSING'
   //         and t.DisabilityEdFactsCode <> 'MISSING'
			//and r.LepStatusEdFactsCode <> 'MISSING'
   //         and t.DisabilityId <> -1
			//and t.EducEnvEdFactsCode != 'PPPS'
			//and r.LepStatusEdFactsCode <> 'LEPP'
			//inner join rds.FactOrganizationCounts fo on f.DimLeaId = fo.DimLeaId
			//and fo.DimSchoolId = -1
			//and fo.DimCountDateId = d.DimDateId
			//inner join rds.DimDirectoryStatuses ds on fo.DimDirectoryStatusId = ds.DimDirectoryStatusId
			//and ds.OperationalStatusEdFactsCode <> 'Closed'
			//and ds.OperationalStatusEdFactsCode <> 'Inactive'
			//and ds.OperationalStatusEdFactsCode <> 'Future'
   //         group by s.LeaOrganizationId, i.RemovalTypeEdFactsCode, r.LepStatusEdFactsCode

   //         */

   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 1207 && x.REMOVALTYPE == "REMDW" && x.LEPSTATUS == "NLEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 1207 && x.REMOVALTYPE == "REMHO" && x.LEPSTATUS == "NLEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMHO" && x.LEPSTATUS == "LEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMHO" && x.LEPSTATUS == "NLEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(4, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMDW" && x.LEPSTATUS == "LEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMDW" && x.LEPSTATUS == "NLEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMHO" && x.LEPSTATUS == "LEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMHO" && x.LEPSTATUS == "NLEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5140 && x.REMOVALTYPE == "REMDW" && x.LEPSTATUS == "LEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMDW" && x.LEPSTATUS == "LEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMDW" && x.LEPSTATUS == "NLEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMDW" && x.LEPSTATUS == "NLEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMHO" && x.LEPSTATUS == "LEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMHO" && x.LEPSTATUS == "NLEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(12, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.LEPSTATUS == "LEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(14, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.LEPSTATUS == "NLEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(9, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.LEPSTATUS == "LEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(8, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.LEPSTATUS == "NLEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(8, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.LEPSTATUS == "LEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(11, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.LEPSTATUS == "NLEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(12, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.LEPSTATUS == "LEP" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(20, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.LEPSTATUS == "NLEP" && x.TotalIndicator == totalIndicator).DisciplineCount);

   //     }

   //     #endregion

   //     #region LEA / ST1 Tests

   //     //Done - FS005_201718_LEA_ST1_Categories
   //     //Done - FS005_201718_LEA_ST1_InterimRemoval
   //     //Done - FS005_201718_LEA_ST1_InterimRemoval_Missing
   //     //Done - FS005_201718_LEA_ST1_Count
   //     //Done - FS005_201718_LEA_ST1_TotalIndicator

   //     [Fact]
   //     public void FS005_201718_LEA_ST1_Categories()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "ST1";
   //         var totalIndicator = "Y";
   //         var categoryList = "|REMOVALTYPE|";

   //         this.fixture.CategorySet_Categories_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator, categoryList);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_ST1_InterimRemoval()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "ST1";
   //         var totalIndicator = "Y";

   //         this.fixture.CategorySet_InterimRemoval_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }


   //     [Fact]
   //     public void FS005_201718_LEA_ST1_InterimRemoval_Missing()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "ST1";
   //         var totalIndicator = "Y";

   //         this.fixture.CategorySet_InterimRemoval_Missing_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }


   //     [Fact]
   //     public void FS005_201718_LEA_ST1_TotalIndicator()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "ST1";
   //         var totalIndicator = "Y";

   //         this.fixture.CategorySet_TotalIndicator_Should(this.reportTable, this.reportCode, this.reportYear, reportLevel, categorySetCode, totalIndicator);

   //     }

   //     [Fact]
   //     public void FS005_201718_LEA_ST1_Count()
   //     {
   //         var reportLevel = "lea";
   //         var categorySetCode = "ST1";
   //         var totalIndicator = "Y";

   //         // Arrange
   //         var repository = new FactReportRepository(this.fixture.appDbContext, this.fixture.rdsDbContext);

   //         // Act
   //         repository.ExecuteReportMigrationByYearLevelAndCategorySet(this.reportCode, this.reportYear, reportLevel, categorySetCode, null, null);

   //         // Assert
   //         var reports = this.fixture.rdsDbContext.FactStudentDisciplineReports
   //             .Where(x => x.ReportCode == this.reportCode && x.ReportYear == this.reportYear && x.ReportLevel == reportLevel && x.CategorySetCode == categorySetCode && x.TotalIndicator == totalIndicator)
   //             .ToList();

   //         Assert.NotEmpty(reports);


   //         /*
   //         -- SQL used to verify


   //         select
   //         s.LeaOrganizationId,
			//i.RemovalTypeEdFactsCode,
			//'Assert.Equal(' + convert(varchar(20), COUNT(distinct st.StateStudentIdentifier)) + ', reports.Single(x => x.OrganizationId == ' + convert(varchar(20), s.LeaOrganizationId) + ' && x.REMOVALTYPE == "' + i.RemovalTypeEdFactsCode + '" && x.TotalIndicator == totalIndicator).DisciplineCount);' as code,
   //         COUNT(distinct st.StateStudentIdentifier) as cnt
   //         from rds.FactStudentDisciplines f
   //         inner join rds.DimDates d on f.DimCountDateId = d.DimDateId
   //         and d.SubmissionYear = '2017-18'
   //         inner join rds.DimAges a on f.DimAgeId = a.DimAgeId 
   //         and a.AgeValue >= 3 and a.AgeValue <= 21
   //         inner join rds.DimSchools s on f.DimSchoolId = s.DimSchoolId
   //         and s.DimSchoolId <> -1
   //         inner join rds.DimDisciplines i on f.DimDisciplineId = i.DimDisciplineId
   //         inner join rds.DimIdeaStatuses t on f.DimIdeaStatusId = t.DimIdeaStatusId
			//inner join rds.DimDemographics r on f.DimDemographicId = r.DimDemographicId
   //         inner join rds.DimStudents st on f.DimStudentId = st.DimStudentId
   //         and i.RemovalTypeEdFactsCode <> 'MISSING'
   //         and t.DisabilityEdFactsCode <> 'MISSING'
   //         and t.DisabilityId <> -1
			//and t.EducEnvEdFactsCode != 'PPPS'
			//inner join rds.FactOrganizationCounts fo on f.DimLeaId = fo.DimLeaId
			//and fo.DimSchoolId = -1
			//and fo.DimCountDateId = d.DimDateId
			//inner join rds.DimDirectoryStatuses ds on fo.DimDirectoryStatusId = ds.DimDirectoryStatusId
			//and ds.OperationalStatusEdFactsCode <> 'Closed'
			//and ds.OperationalStatusEdFactsCode <> 'Inactive'
			//and ds.OperationalStatusEdFactsCode <> 'Future'
   //         group by s.LeaOrganizationId, i.RemovalTypeEdFactsCode

   //         */

   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 1207 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(4, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 5140 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(5, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(5, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(33, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(44, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMDW" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(2, reports.Single(x => x.OrganizationId == 1207 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 4211 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(6, reports.Single(x => x.OrganizationId == 5121 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(1, reports.Single(x => x.OrganizationId == 5339 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(3, reports.Single(x => x.OrganizationId == 5472 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(30, reports.Single(x => x.OrganizationId == 6022 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);
   //         //Assert.Equal(47, reports.Single(x => x.OrganizationId == 8338 && x.REMOVALTYPE == "REMHO" && x.TotalIndicator == totalIndicator).DisciplineCount);

   //     }

   //     #endregion

    }
}
