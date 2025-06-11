using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.infrastructure.Contexts;
using generate.core.Models.App;
using generate.core.Interfaces.Services;
using System.Linq.Expressions;
using generate.core.Models.IDS;
using System.Threading.Tasks;
using Microsoft.Extensions.PlatformAbstractions;
using generate.core.ViewModels.App;
using generate.core.Dtos.App;
using generate.shared.Utilities;
using System.Dynamic;
using System.Reflection;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Models.RDS;
using generate.core.Interfaces.Repositories.App;
using generate.core.Dtos.RDS;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.Data;
using generate.infrastructure.Utilities;

namespace generate.infrastructure.Services
{
    public class EdfactsFileService : IEdfactsFileService
    {
        private IFactStudentCountRepository _factStudentCountRepository;
        private IFactStudentDisciplineRepository _factStudentDisciplineRepository;
        private IFactStudentAssessmentRepository _factStudentAssessmentRepository;
        private IFactStaffCountRepository _factStaffCountRepository;
        private IFactOrganizationCountRepository _factOrganizationCountRepository;
        private IFactOrganizationStatusCountRepository _factOrganizationStatusCountRepository;

        private IAppRepository _appRepository;


        public EdfactsFileService(
                IFactStudentCountRepository factStudentCountRepository,
                IFactStudentDisciplineRepository factStudentDisciplineRepository,
                IAppRepository appRepository,
                IFactStudentAssessmentRepository factStudentAssessmentRepository,
                IFactStaffCountRepository factStaffCountRepository,
                IFactOrganizationCountRepository factOrganizationCountRepository,
                IFactOrganizationStatusCountRepository factOrganizationStatusCountRepository
            )
        {
            _factStudentCountRepository = factStudentCountRepository;
            _factStudentDisciplineRepository = factStudentDisciplineRepository;
            _appRepository = appRepository;
            _factStudentAssessmentRepository = factStudentAssessmentRepository;
            _factStaffCountRepository = factStaffCountRepository;
            _factOrganizationCountRepository = factOrganizationCountRepository;
            _factOrganizationStatusCountRepository = factOrganizationStatusCountRepository;
        }
        public List<ExpandoObject> GetStudentCountData(string reportCode, string reportTypeCode, string reportLevel, string reportYear, List<FileSubmissionColumnDto> fileSubmissioncolumns)
        {
            dynamic dynamicRows = new List<ExpandoObject>();

            GenerateReport report = _appRepository.Find<GenerateReport>(r => r.GenerateReportType.ReportTypeCode == reportTypeCode
                && r.ReportCode == reportCode
                && r.GenerateReport_OrganizationLevels.Count(l => l.OrganizationLevel.LevelCode == reportLevel) == 1, 0, 1, r => r.FactTable)
                .FirstOrDefault();
            
            string factTableName = "";
            string factFieldName = "";
            string factReportDtoIdName = "";

            if (report != null)
            {
                factTableName = report.FactTable.FactTableName;
                factFieldName = report.FactTable.FactFieldName;
                factReportDtoIdName = report.FactTable.FactReportDtoIdName;
            }

            dynamic dataRows = new List<ExpandoObject>();

            bool includeZeroCounts = false;
            if (reportLevel == "sea" || reportCode.ToLower() == "052" || reportCode.ToLower() == "032" || reportCode.ToLower() == "040" || reportCode.ToLower() == "033")
            {
                includeZeroCounts = true;
            }

            if (reportCode.ToLower() == "045")
            {
                includeZeroCounts = false;
            }


            if (factTableName == "FactK12StudentCounts")
            {
                var query = _factStudentCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, null, includeZeroCounts, false, true);
                dataRows = query.ToList();
            }
            else if (factTableName == "FactK12StudentDisciplines")
            {
                var query = _factStudentDisciplineRepository.Get_ReportData(reportCode, reportLevel, reportYear, null, includeZeroCounts, false, true);
                dataRows = query.ToList();
            }
            else if (factTableName == "FactK12StudentAssessments")
            {
                var query = _factStudentAssessmentRepository.Get_ReportData(reportCode, reportLevel, reportYear, null, includeZeroCounts, false, true);
                dataRows = query.ToList();
            }
            else if (factTableName == "FactK12StaffCounts")
            {
                var query = _factStaffCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, null, includeZeroCounts, false, true);
                dataRows = query.ToList();
            }
            else if (factTableName == "FactOrganizationStatusCounts")
            {
                var query = _factOrganizationStatusCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, null);
                dataRows = query.ToList();
            }
            else if (factTableName == "FactOrganizationCounts")
            {
                dataRows = GetOrganizationStudentCountData(reportCode, reportTypeCode, reportLevel, reportYear);
            }

            dynamicRows = GetSubmissionData(dataRows, fileSubmissioncolumns, factTableName, reportCode, reportLevel, factFieldName);
            return dynamicRows;
        }

        public List<ExpandoObject> GetOrganizationStudentCountData(string reportCode, string reportTypeCode, string reportLevel, string reportYear)
        {
            dynamic dataRows = new List<ExpandoObject>();

            GenerateReport report = _appRepository.Find<GenerateReport>(r => r.GenerateReportType.ReportTypeCode == reportTypeCode
                && r.ReportCode == reportCode
                && r.GenerateReport_OrganizationLevels.Count(l => l.OrganizationLevel.LevelCode == reportLevel) == 1, 0, 1, r => r.FactTable)
                .FirstOrDefault();

            if (report.ReportCode == "205")
            {
                var query = _factOrganizationCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, null, false, false, false, true);
                dataRows = query.ToList();
            }
            else if (report.ReportCode == "130")
            {
                var query = _factOrganizationCountRepository.Get_PersistentlyDangerousReportData(reportCode, reportLevel, reportYear, null, false, false, false, true);
                dataRows = query.ToList();
            }
            else if (report.ReportCode == "039")
            {
                var query = _factOrganizationCountRepository.Get_GradesOfferedReportData(reportCode, reportLevel, reportYear, null);
                dataRows = query.ToList();
            }
            else
            {
                var query = _factOrganizationCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, null);
                dataRows = query.ToList();
            }

            return dataRows;
        }

        public List<ExpandoObject> GetSubmissionData(dynamic dataRows, List<FileSubmissionColumnDto> fileSubmissioncolumns, string factTableName,string reportCode, string reportLevel, string factFieldName)
        {
            int fileRecordNumber = 0;
            dynamic dynamicRows = new List<ExpandoObject>();

            foreach (var dataRow in dataRows)
            {
                ++fileRecordNumber;
                var fileDataRow = new ExpandoObject();
                fileSubmissioncolumns.ForEach(column =>
                {
                    string field = column.ColumnName;
                    if (column.ReportColumn != null)
                    {
                        field = column.ReportColumn;
                    }

                    if (column.ColumnName.ToLower().StartsWith("filler"))
                    {
                        DynamicClassObject.AddProperty(column.ColumnName, "", fileDataRow);
                    }
                    else if (column.ColumnName == "StateAgencyNumber")
                    {
                        DynamicClassObject.AddProperty(column.ColumnName, "01", fileDataRow);
                    }
                    else if (column.ColumnName == "Explanation")
                    {
                        DynamicClassObject.AddProperty(column.ColumnName, "", fileDataRow);
                    }
                    else if (column.ColumnName == "FileRecordNumber")
                    {
                        DynamicClassObject.AddProperty(column.ColumnName, fileRecordNumber.ToString(), fileDataRow);
                    }
                    else if (column.ColumnName == "StateLEAIDNumber")
                    {
                        if(factTableName == "FactOrganizationCounts")
                        {
                            if (reportLevel == "lea") { field = "OrganizationStateId"; }
                            else if (reportLevel == "sch") { field = "ParentOrganizationStateId"; }
                        }
                        else
                        {
                            if (reportLevel == "lea") { field = "OrganizationIdentifierSea"; }
                            else if (reportLevel == "sch") { field = "ParentOrganizationIdentifierSea"; }
                        }
                        
                    }
                    else if (column.ColumnName == "NCESLEAIDNumber")
                    {
                        if (factTableName == "FactOrganizationCounts")
                        {
                            if (reportLevel == "lea") { field = "OrganizationNcesId"; }
                            else if (reportLevel == "sch") { field = "ParentOrganizationNcesId"; }
                        }
                        else
                        {
                            if (reportLevel == "lea") { field = "OrganizationIdentifierNces"; }
                            else if (reportLevel == "sch") { field = "ParentOrganizationIdentifierNces"; }
                        }

                    }
                    else if (column.ColumnName == "StateSchoolIDNumber")
                    {
                        if (factTableName == "FactOrganizationCounts")
                        {
                            field = "OrganizationStateId";
                        }
                        else
                        {
                            field = "OrganizationIdentifierSea";
                        }

                    }
                    else if (column.ColumnName == "Amount")
                    {
                        string reportCodes = "199,200,201,202,206";
                        field = factFieldName;
                        if (reportCode == "150") { field = "StudentRate"; }
                        else if (reportCode == "035") { field = "FederalFundAllocated"; }
                        else if (reportCodes.Contains(reportCode)) { field = "INDICATORSTATUS"; }
                        else if (reportCode == "205") { field = "PROGRESSACHIEVINGENGLISHLANGUAGE"; }

                    }
                    else if (column.ColumnName == "HomelessStatusID")
                    {
                        if (reportCode == "037") { field = "HOMELESSNESSSTATUS"; }
                        else { field = "HOMELESSUNACCOMPANIEDYOUTHSTATUS"; }
                    }

                    PropertyInfo prop = dataRow.GetType().GetProperty(field, BindingFlags.IgnoreCase | BindingFlags.Public | BindingFlags.Instance);
                    if (prop != null)
                    {
                        var val = prop.GetValue(dataRow, null);
                        if (val == null)
                        {
                            val = "";
                        }
                        DynamicClassObject.AddProperty(column.ColumnName, val, fileDataRow);
                    }

                });

                dynamicRows.Add(fileDataRow);

            }
            return dynamicRows;

        }

        public (IEnumerable<MembershipReportDto>, int) GetMembershipStudentCountData(string reportCode, string reportTypeCode, string reportLevel, string reportYear, List<FileSubmissionColumnDto> fileSubmissioncolumns, int startRecord, int numberOfRecords)
        {
            List<MembershipReportDto> dataRows = new List<MembershipReportDto>();

            bool includeZeroCounts = true;

            var query = _factStudentCountRepository.Get_MembershipReportData(reportCode, reportLevel, reportYear, null, includeZeroCounts, false, true, false, startRecord, numberOfRecords);
            dataRows = query.Item1.ToList();

            return (dataRows, query.Item2);
            
        }
    }
}
