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
            if (reportLevel == "sea" || reportCode.ToLower() == "c052" || reportCode.ToLower() == "c032" || reportCode.ToLower() == "c040" || reportCode.ToLower() == "c033")
            {
                includeZeroCounts = true;
            }

            if (reportCode.ToLower() == "c045")
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
            else if (report.FactTable.FactTableName == "FactOrganizationCounts")
            {


                if (report.ReportCode == "c205")
                {
                    var query = _factOrganizationCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, null, false, false, false, true);
                    dataRows = query.ToList();
                }
                else if(report.ReportCode == "c130")
                {
                    var query = _factOrganizationCountRepository.Get_PersistentlyDangerousReportData(reportCode, reportLevel, reportYear, null, false, false, false, true);
                    dataRows = query.ToList();
                }
                else if(report.ReportCode == "c039")
                {
                    var query = _factOrganizationCountRepository.Get_GradesOfferedReportData(reportCode, reportLevel, reportYear, null);
                    dataRows = query.ToList();
                }
                else
                {
                    var query = _factOrganizationCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, null);
                    dataRows = query.ToList();
                }
            }

            dynamicRows = GetSubmissionData(dataRows, fileSubmissioncolumns);
            return dynamicRows;
        }

        public List<ExpandoObject> GetSubmissionData(List<ExpandoObject> dataRows, List<FileSubmissionColumnDto> fileSubmissioncolumns)
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

                    PropertyInfo prop = dataRow.GetType().GetProperty(field);
                    if (prop != null)
                    {
                        var val = prop.GetValue(dataRow, null);
                        if (val == null)
                        {
                            val = "";
                        }
                        DynamicClassObject.AddProperty(column.ColumnName, val, fileDataRow);
                    }
                    else
                    {
                        throw new Exception("File Submission Column not found for : " + column.ColumnName);
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
