using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.core.Models.App;
using generate.core.Interfaces.Services;
using System.Linq.Expressions;
using System.Threading.Tasks;
using Microsoft.Extensions.PlatformAbstractions;
using generate.core.Dtos.App;
using generate.core.Models.RDS;
using System.Dynamic;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Interfaces.Repositories.App;

namespace generate.infrastructure.Services
{
    public class SppAprReportService : ISppAprReportService
    {
        private IAppRepository _appRepository;
        private IRDSRepository _dimFactTypeRepository;
        private IFactStudentCountRepository _factStudentCountRepository;
        private IFactCustomCountRepository _customReportRepository;


        private string reportType = "sppaprreport";

        public SppAprReportService(
            IAppRepository appRepository,
            IRDSRepository dimFactTypeRepository,
            IFactStudentCountRepository factStudentCountRepository,
            IFactStudentDisciplineRepository factStudentDisciplineRepository,
            IFactCustomCountRepository customReportRepository
            )
        {
            _appRepository = appRepository;
            _dimFactTypeRepository = dimFactTypeRepository;
            _factStudentCountRepository = factStudentCountRepository;
            _customReportRepository = customReportRepository;

        }


        public GenerateReportDataDto GetReportDto(string reportCode, string reportLevel, string reportYear, string categorySetCode, int reportSort = 1, int skip = 0, int take = 50)
        {

            GenerateReport report = _appRepository.Find<GenerateReport>(r => r.GenerateReportType.ReportTypeCode == reportType
                && r.ReportCode == reportCode
                && r.GenerateReport_OrganizationLevels.Count(l => l.OrganizationLevel.LevelCode == reportLevel) == 1, 0, 1, r => r.CategorySets)
                .FirstOrDefault();

            if (report == null)
            {
                return null;
            }

            int submissionFactTypeId = _dimFactTypeRepository.Find<DimFactType>(f => f.FactTypeCode == "submission").Select(f => f.DimFactTypeId).FirstOrDefault();


            // Data

            // Declare empty dto
            GenerateReportDataDto reportDto = new GenerateReportDataDto();
            reportDto.structure = new GenerateReportStructureDto();
            reportDto.data = new List<ExpandoObject>();
            reportDto.ReportTitle = report.ReportName;

            if (reportCode == "indicator9" || reportCode == "indicator10")
            {
                dynamic dataRows = new List<ExpandoObject>();

                var query = _factStudentCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode);
                dataRows = query.ToList();

                reportDto.dataCount = query.Select(q => q.OrganizationIdentifierSea).Distinct().Count();

                reportDto.data = dataRows;

            }
            else if (reportCode == "indicator4a" || reportCode == "indicator4b")
            {
                dynamic dataRows = new List<ExpandoObject>();

                var query = _customReportRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode);
                dataRows = query.ToList();

                reportDto.dataCount = query.Select(q => q.OrganizationStateId).Distinct().Count();

                reportDto.data = dataRows;

            }
            else
            {
                // Not implemented
                reportDto.dataCount = -1;
            }


            return reportDto;
        }


    }
}
