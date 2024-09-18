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

            GenerateReport report = _appRepository.Find<GenerateReport>(r => r.GenerateReportType.ReportTypeCode == reportTypeCode
                && r.ReportCode == reportCode
                && r.GenerateReport_OrganizationLevels.Count(l => l.OrganizationLevel.LevelCode == reportLevel) == 1, 0, 1, r => r.FactTable)
                .FirstOrDefault();

            string factTableName = report.FactTable.FactTableName;
            string factFieldName = report.FactTable.FactFieldName;
            string factReportDtoIdName = report.FactTable.FactReportDtoIdName;
            int fileRecordNumber = 0;

            dynamic dynamicRows = new List<ExpandoObject>();
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


                if (report.ReportCode == "c130" || report.ReportCode == "c205")
                {
                    var query = _factOrganizationCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, null, false, false, false, true);
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

            if (report.ReportCode == "c193")
            {
                foreach (var dataRow in dataRows)
                {
                    for (int i = 1; i <= 2; i++)
                    {
                        ++fileRecordNumber;
                        var fileDataRow = new ExpandoObject();
                        fileSubmissioncolumns.ForEach(column =>
                        {
                            string field = column.ColumnName;

                            if (column.ReportField != null)
                            {
                                field = column.ReportField;
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

                            else if (column.ColumnName == "TableTypeAbbrv")
                            {
                                if (i == 1)
                                {
                                    DynamicClassObject.AddProperty(column.ColumnName, "PARINRES", fileDataRow);
                                }
                               else if(i==2)
                                {
                                    DynamicClassObject.AddProperty(column.ColumnName, "TITLEIPALL", fileDataRow);
                                }        
                            }

                            else
                            {

                                if (column.ColumnName == "FIPSStateCode")
                                {
                                    field = "StateANSICode";
                                }
                                else if (column.ColumnName == "StateAgencyName" || column.ColumnName == "LEAName" || column.ColumnName == "SchoolName")
                                {
                                    field = "OrganizationName";
                                }
                                else if (column.ColumnName == "StateLEAIDNumber")
                                {
                                    if (reportLevel == "sch")
                                    {
                                        field = "ParentOrganizationStateId";
                                    }
                                    else
                                    {
                                        field = "OrganizationStateId";
                                    }
                                }

                                else if (column.ColumnName == "Amount")
                                {
                                    if (i == 1)
                                    {
                                        field = "TitleiParentalInvolveRes";
                                    }
                                   else if(i==2)
                                       field = "TitleiPartaAllocations";
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
                                    DynamicClassObject.AddProperty(column.ColumnName, "", fileDataRow);

                                }

                            }
                        });
                        dynamicRows.Add(fileDataRow);
                    }
                }
            }
            else if (report.ReportCode == "c197" || report.ReportCode == "c198")
            {
                foreach (var dataRow in dataRows)
                {
                    ++fileRecordNumber;
                    var fileDataRow = new ExpandoObject();
                    fileSubmissioncolumns.ForEach(column =>
                    {
                        string field = column.ColumnName;

                        if (column.ReportField != null)
                        {
                            field = column.ReportField;
                        }

                        if (column.ColumnName.ToLower().StartsWith("filler"))
                        {
                            DynamicClassObject.AddProperty(column.ColumnName, "", fileDataRow);
                        }


                        else if (column.ColumnName == "Explanation")
                        {
                            DynamicClassObject.AddProperty(column.ColumnName, "", fileDataRow);

                        }
                        else if (column.ColumnName == "FileRecordNumber")
                        {
                            DynamicClassObject.AddProperty(column.ColumnName, fileRecordNumber.ToString(), fileDataRow);

                        }


                        else if (column.ColumnName == "StateAgencyNumber")
                        {
                            DynamicClassObject.AddProperty(column.ColumnName, "01", fileDataRow);

                        }

                        else
                        {

                            if (column.ColumnName == "FIPSStateCode")
                            {
                                field = "StateANSICode";
                            }
                            else if (column.ColumnName == "NCESLEAIDNumber")
                            {
                                field = "ParentOrganizationNcesId";
                            }

                            else if (column.ColumnName == "StateLEAIDNumber")
                            {
                                field = "ParentOrganizationStateId";
                            }

                            else if (column.ColumnName == "NCESSchoolNumber")
                            {

                                field = "OrganizationNcesId";

                            }

                            else if (column.ColumnName == "StateSchoolIDNumber")
                            {

                                field = "OrganizationStateId";

                            }
                            else if (column.ColumnName == "ManagementOrganizationEIN")
                            {
                                field = "CHARTERSCHOOLMANAGERORGANIZATION";
                            }
                            else if (column.ColumnName == "ManagementOrgEINUpdated")
                            {
                                field = "CHARTERSCHOOLUPDATEDMANAGERORGANIZATION";
                            }
                            else if (column.ColumnName == "CharterContractIDNumber")
                            {
                                field = "CharterSchoolContractIdNumber";
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
                                DynamicClassObject.AddProperty(column.ColumnName, "", fileDataRow);

                            }

                        }
                    });
                    dynamicRows.Add(fileDataRow);
                }
            }
            else if (report.ReportCode == "c190" || report.ReportCode == "c196")
            {
                foreach (var dataRow in dataRows)
                {
                    ++fileRecordNumber;
                    var fileDataRow = new ExpandoObject();
                    fileSubmissioncolumns.ForEach(column =>
                    {
                        string field = column.ColumnName;

                        if (column.ReportField != null)
                        {
                            field = column.ReportField;
                        }

                        if (column.ColumnName.ToLower().StartsWith("filler"))
                        {
                            DynamicClassObject.AddProperty(column.ColumnName, "", fileDataRow);
                        }


                        else if (column.ColumnName == "Explanation")
                        {
                            DynamicClassObject.AddProperty(column.ColumnName, "", fileDataRow);

                        }
                        else if (column.ColumnName == "FileRecordNumber")
                        {
                            DynamicClassObject.AddProperty(column.ColumnName, fileRecordNumber.ToString(), fileDataRow);

                        }


                        else if (column.ColumnName == "StateAgencyNumber")
                        {
                            DynamicClassObject.AddProperty(column.ColumnName, "01", fileDataRow);

                        }

                        else
                        {

                            if (column.ColumnName == "CharterAuthorizerName")
                            {
                                field = "OrganizationName";
                            }
                            else if (column.ColumnName == "CharterMngmtOrgName")
                            {
                                field = "OrganizationName";
                            }
                            else if (column.ColumnName == "CharterMngmtOrgType")
                            {
                                field = "ManagementOrganizationType";
                            }

                            else if (column.ColumnName == "CharterMngmtOrgEmpIdNum")
                            {
                                field = "OrganizationStateId";
                            }
                            else if (column.ColumnName == "CharterAuthorizerStateNumber")
                            {
                                field = "OrganizationStateId";
                            }
                            else if (column.ColumnName == "CharterAuthorizerType")
                            {
                                field = "CharterSchoolAuthorizerType";
                            }
                            else if (column.ColumnName == "FIPSStateCode")
                            {
                                field = "StateANSICode";
                            }
                            else if (column.ColumnName == "LocationAddress1")
                            {
                                field = "PhysicalAddressStreet";
                            }
                            else if (column.ColumnName == "LocationAddress2")
                            {
                                field = "PhysicalAddressApartmentRoomOrSuiteNumber";
                            }

                            else if (column.ColumnName == "LocationCity")
                            {
                                field = "PhysicalAddressCity";
                            }

                            else if (column.ColumnName == "LocationPostalStateCode")
                            {

                                field = "PhysicalAddressState";

                            }

                            else if (column.ColumnName == "LocationZipcode")
                            {

                                field = "PhysicalAddressPostalCode";

                            }
                            else if (column.ColumnName == "LocationZipcodePlus4")
                            {

                                field = "PhysicalAddressPostalCode2";

                            }
                            else if (column.ColumnName == "MailingAddress1")
                            {
                                field = "MailingAddressStreet";
                            }
                            else if (column.ColumnName == "MailingAddress2")
                            {
                                field = "MailingAddressApartmentRoomOrSuiteNumber";
                            }
                            else if (column.ColumnName == "MailingCity")
                            {
                                field = "MailingAddressCity";
                            }
                            else if (column.ColumnName == "MailingPostalStateCode")
                            {
                                field = "MailingAddressState";
                            }

                            else if (column.ColumnName == "MailingZipcode")
                            {
                                field = "MailingAddressPostalCode";
                            }
                            else if (column.ColumnName == "MailingZipcodePlus4")
                            {
                                field = "MailingAddressPostalCode2";
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
                                DynamicClassObject.AddProperty(column.ColumnName, "", fileDataRow);

                            }

                        }
                    });
                    dynamicRows.Add(fileDataRow);
                }
            }
            else if (report.ReportCode == "c205")
            {
                foreach (var dataRow in dataRows)
                {
                    ++fileRecordNumber;
                    var fileDataRow = new ExpandoObject();
                    fileSubmissioncolumns.ForEach(column =>
                    {
                        string field = column.ColumnName;

                        if (column.ReportField != null)
                        {
                            field = column.ReportField;
                        }

                        if (column.ColumnName.ToLower().StartsWith("filler"))
                        {
                            DynamicClassObject.AddProperty(column.ColumnName, "", fileDataRow);
                        }


                        else if (column.ColumnName == "Explanation")
                        {
                            DynamicClassObject.AddProperty(column.ColumnName, "", fileDataRow);

                        }
                        else if (column.ColumnName == "FileRecordNumber")
                        {
                            DynamicClassObject.AddProperty(column.ColumnName, fileRecordNumber.ToString(), fileDataRow);

                        }


                        else if (column.ColumnName == "StateAgencyNumber")
                        {
                            DynamicClassObject.AddProperty(column.ColumnName, "01", fileDataRow);

                        }
                        else
                        {

                            if (column.ColumnName == "FIPSStateCode")
                            {
                                field = "StateANSICode";
                            }
                            else if (column.ColumnName == "StateDefinedStatusName")
                            {
                                field = "STATEDEFINEDSTATUS";
                            }
                            else if (column.ColumnName=="Amount")
                            {
                                field = "PROGRESSACHIEVINGENGLISHLANGUAGE";
                            }
                            else if (column.ColumnName == "TableTypeAbbrv")
                            {
                                field = "TableTypeAbbrv";
                            }

                            else if (column.ColumnName == "StateLEAIDNumber")
                            {
                                field = "LeaStateIdentifier";

                            }
                            else if (column.ColumnName == "StateSchoolIDNumber")
                            {
                                field = "OrganizationStateId";
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
                                DynamicClassObject.AddProperty(column.ColumnName, "", fileDataRow);

                            }

                        }
                    });
                    dynamicRows.Add(fileDataRow);
                }
            }

            else if (report.ReportCode == "c131")
            {
                foreach (var dataRow in dataRows)
                {
                    ++fileRecordNumber;
                    var fileDataRow = new ExpandoObject();
                    fileSubmissioncolumns.ForEach(column =>
                    {
                        string field = column.ColumnName;

                        if (column.ReportField != null)
                        {
                            field = column.ReportField;
                        }

                        if (column.ColumnName.ToLower().StartsWith("filler"))
                        {
                            DynamicClassObject.AddProperty(column.ColumnName, "", fileDataRow);
                        }


                        else if (column.ColumnName == "Explanation")
                        {
                            DynamicClassObject.AddProperty(column.ColumnName, "", fileDataRow);

                        }
                        else if (column.ColumnName == "FileRecordNumber")
                        {
                            DynamicClassObject.AddProperty(column.ColumnName, fileRecordNumber.ToString(), fileDataRow);

                        }


                        else if (column.ColumnName == "StateAgencyNumber")
                        {
                            DynamicClassObject.AddProperty(column.ColumnName, "01", fileDataRow);

                        }
                        else
                        {

                            if (column.ColumnName == "FIPSStateCode")
                            {
                                field = "StateANSICode";
                            }
                            else if (column.ColumnName == "REAPAltFundInd")
                            {
                                field = "REAPAlternativeFundingStatus";
                            }


                            else if (column.ColumnName == "StateLEAIDNumber")
                            {
                               field = "OrganizationStateId";

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
                                DynamicClassObject.AddProperty(column.ColumnName, "", fileDataRow);

                            }

                        }
                    });
                    dynamicRows.Add(fileDataRow);
                }
            }


            else
            {

                foreach (var dataRow in dataRows)
                {
                    ++fileRecordNumber;
                    var fileDataRow = new ExpandoObject();
                    fileSubmissioncolumns.ForEach(column =>
                    {
                        string field = column.ColumnName;
                        if (column.ReportField != null)
                        {
                            field = column.ReportField;
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
                        else
                        {
                            if (column.ColumnName == "FIPSStateCode")
                            {
                                field = "StateANSICode";
                            }
                            else if (column.ColumnName == "PovertyQuart")
                            {
                                field = "STATEPOVERTYDESIGNATION";
                            }
                            else if (column.ColumnName == "StateAgencyName" || column.ColumnName == "LEAName" || column.ColumnName == "SchoolName")
                            {
                                field = "OrganizationName";
                            }
                            else if (column.ColumnName.ToLower().EndsWith("webaddress"))
                            {
                                field = "Website";
                            }
                            else if (column.ColumnName.ToLower().EndsWith("phonenumber"))
                            {
                                if (column.ColumnName == "CSSOPhoneNumber") { field = "CSSOTelephone"; }
                                else { field = "Telephone"; }
                            }
                            else if (column.ColumnName == "CSSOEMailAddress")
                            {
                                field = "CSSOEmail";
                            }
                            else if (column.ColumnName == "MailingAddress1") { field = "MailingAddressStreet"; }
                            else if (column.ColumnName == "MailingAddress2") { field = "MailingAddressApartmentRoomOrSuiteNumber"; }
                            else if (column.ColumnName == "MailingCity") { field = "MailingAddressCity"; }
                            else if (column.ColumnName == "MailingPostalStateCode") { field = "MailingAddressState"; }
                            else if (column.ColumnName == "MailingZipcode") { field = "MailingAddressPostalCode"; }
                            else if (column.ColumnName == "MailingZipcodePlus4") { field = "MailingAddressPostalCode2"; }
                            else if (column.ColumnName == "LocationAddress1") { field = "PhysicalAddressStreet"; }
                            else if (column.ColumnName == "LocationAddress2") { field = "PhysicalAddressApartmentRoomOrSuiteNumber"; }
                            else if (column.ColumnName == "LocationCity") { field = "PhysicalAddressCity"; }
                            else if (column.ColumnName == "LocationPostalStateCode") { field = "PhysicalAddressState"; }
                            else if (column.ColumnName == "LocationZipcode") { field = "PhysicalAddressPostalCode"; }
                            else if (column.ColumnName == "LocationZipcodePlus4") { field = "PhysicalAddressPostalCode2"; }
                            else if (column.ColumnName == "StateLEAIDNumber")
                            {
                                if (reportLevel == "sch")
                                {
                                    if (report.FactTable.FactTableName == "FactOrganizationCounts" || report.FactTable.FactTableName == "FactOrganizationStatusCounts"){
                                        field = "ParentOrganizationStateId";
                                    }
                                    else
                                    {
                                        field = "ParentOrganizationIdentifierSea";
                                    }
                                }
                                else
                                {
                                    if (report.FactTable.FactTableName == "FactOrganizationCounts" || report.FactTable.FactTableName == "FactOrganizationStatusCounts")
                                    {
                                        field = "OrganizationStateId";
                                    }
                                    else
                                    {
                                        field = "OrganizationIdentifierSea";
                                    }
                                }
                            }
                            else if (column.ColumnName == "NCESLEAIDNumber")
                            {
                                if (reportLevel == "sch")
                                {
                                    if (report.FactTable.FactTableName == "FactOrganizationCounts" || report.FactTable.FactTableName == "FactOrganizationStatusCounts")
                                    {
                                        field = "ParentOrganizationNcesId";
                                    }
                                    else
                                    {
                                        field = "ParentOrganizationIdentifierNces";
                                    }
                                }
                                else
                                {
                                    if (report.FactTable.FactTableName == "FactOrganizationCounts" || report.FactTable.FactTableName == "FactOrganizationStatusCounts")
                                    {
                                        field = "OrganizationNcesId";
                                    }
                                    else
                                    {
                                        field = "OrganizationIdentifierNces";
                                    }
                                }
                            }
                            else if (column.ColumnName == "NCESSchoolIDNumber") {
                                if (report.FactTable.FactTableName == "FactOrganizationCounts" || report.FactTable.FactTableName == "FactOrganizationStatusCounts")
                                {
                                    field = "OrganizationNcesId";
                                }
                                else
                                {
                                    field = "OrganizationIdentifierNces";
                                }
                            }
                            else if (column.ColumnName == "OutOfStateInd") { field = "OutOfStateIndicator"; }
                            else if (column.ColumnName == "SupervisoryUnion") { field = "SupervisoryUnionIdentificationNumber"; }
                            else if (column.ColumnName == "LEASysOpStatus" || column.ColumnName == "SchoolSysOpStatus") { field = "OperationalStatusId"; }
                            else if (column.ColumnName == "LEAOpStatus" || column.ColumnName == "SchoolOpStatus") { field = "UpdatedOperationalStatusId"; }
                            else if (column.ColumnName == "ChrtSchoolLEAStatusID") { field = "CharterLeaStatus"; }
                            else if (column.ColumnName == "CharterSchoolAuthorizerPrimary") { field = "CharterSchoolAuthorizerIdPrimary"; }
                            else if (column.ColumnName == "CharterSchoolAuthorizerAdditional") { field = "CharterSchoolAuthorizerIdSecondary"; }
                            else if (column.ColumnName == "PriorStateLEAID") { field = "PriorLeaStateIdentifier"; }
                            else if (column.ColumnName == "PriorStateSchoolID") { field = "PriorSchoolStateIdentifier"; }
                            else if (column.ColumnName == "StatusEffectiveDate") { field = "EffectiveDate"; }
                            else if (column.ColumnName == "StateSchoolIDNumber")
                            {
                                if (report.FactTable.FactTableName == "FactOrganizationCounts" || report.FactTable.FactTableName == "FactOrganizationStatusCounts")
                                {
                                    field = "OrganizationStateId";
                                }
                                else
                                {
                                    field = "OrganizationIdentifierSea";
                                }
                            }
                            else if (column.ColumnName == "Amount" || column.ColumnName == "MigrantStuEligibleRSY")
                            {
                                field = factFieldName;
                                if (reportCode == "c150") { field = "StudentRate"; }
                                if (reportCode == "c199" || reportCode == "c200" || reportCode == "c201" || reportCode == "c202" || reportCode == "c206") { field = "INDICATORSTATUS"; }
                                if (reportCode == "c035") { field = "FederalFundAllocated"; }
                            }

                            else if (column.ColumnName == "ImprovementStatus")
                            {
                                field = "IMPROVEMENTSTATUS";
                            }
                            else if (column.ColumnName == "PSEnrollActionID")
                            {
                                field = "POSTSECONDARYENROLLMENTSTATUS";
                            }


                            else if (column.ColumnName == "PrimeNightResidenceID")
                            {
                                field = "HOMELESSPRIMARYNIGHTTIMERESIDENCE";
                            }
                            else if (column.ColumnName == "HomelessStatusID" && reportCode == "c037")
                            {
                                field = "HOMELESSNESSSTATUS";
                            }
                            else if (column.ColumnName == "HomelessStatusID")
                            {
                                field = "HOMELESSUNACCOMPANIEDYOUTHSTATUS";
                            }
                            else if (column.ColumnName == "PersistDangerStatus")
                            {
                                field = "PERSISTENTLYDANGEROUSSTATUS";
                            }
                            else if (column.ColumnName == "FireArmIncResultID")
                            {
                                field = "DISCIPLINEMETHODFORFIREARMSINCIDENTS";
                            }
                            else if (column.ColumnName == "FireArmIncResultIDEAID")
                            {
                                field = "IDEADISCIPLINEMETHODFORFIREARMSINCIDENTS";
                            }
                            else if (column.ColumnName == "GradeLevelID")
                            {
                                field = "GRADELEVEL";
                            }
                            else if (column.ColumnName == "WeaponTypeID")
                            {
                                field = "FIREARMTYPE";
                            }

                            else if (column.ColumnName == "ProficiencyStatusID" || column.ColumnName == "EnglishProficiencyLevelID") { field = "PROFICIENCYSTATUS"; }

                            else if (column.ColumnName == "ImpFundAllocA") { field = "SCHOOLIMPROVEMENTFUNDS"; }
                            else if (column.ColumnName == "MVSubGStatusID") { field = "McKinneyVentoSubgrantRecipient"; }
                            else if (column.ColumnName == "GFSAReportStatus") { field = "GunFreeStatus"; }
                            else if (column.ColumnName == "CohortStatusID") { field = "COHORTSTATUS"; }
                            else if (column.ColumnName == "StateDefinedStatusName") { field = "STATEDEFINEDSTATUSCODE"; }
                            else if (column.ColumnName == "CFDAID") { field = "FederalProgramCode"; }
                            else if (column.ColumnName == "AllocationTypeID") { field = "FederalFundAllocationType"; }
                            else if (column.ColumnName == "IndicatorTypeID") { field = "STATEDEFINEDCUSTOMINDICATORCODE"; }
                            else if (column.ColumnName == "ComprehensiveTargetedSupportSchTypeID") { field = "ComprehensiveAndTargetedSupportCode"; }
                            else if (column.ColumnName == "ComprehensiveSupportIdentificationTypeID") { field = "ComprehensiveSupportCode"; }
                            else if (column.ColumnName == "TargetedSupportIdentificationTypeID") { field = "TargetedSupportCode"; }
                            else if (column.ColumnName == "AddlTrgtSupImprvmntID") { field = "AdditionalTargetedSupportandImprovementCode"; }
                            else if (column.ColumnName == "CompSupImprvmntID") { field = "ComprehensiveSupportImprovementCode"; }
                            else if (column.ColumnName == "TrgtSupImprvmntID") { field = "TargetedSupportImprovementCode"; }
                            else if (column.ColumnName == "SteAprptnMthdsID") { field = "AppropriationMethodCode"; }
                            else if (column.ColumnName == "LanguageInstrTypeID") { field = "TITLEIIILANGUAGEINSTRUCTION"; }
                            else if (column.ColumnName == "AgeGroupID") { field = "SPECIALEDUCATIONAGEGROUPTAUGHT"; }
                            else if (column.ColumnName == "DisabilityStatusID")
                            {
                                if (reportCode == "c118" || reportCode == "c144" || reportCode == "c141" || reportCode == "c175" || reportCode == "c178" || reportCode == "c179"
                                || reportCode == "c185" || reportCode == "c188" || reportCode == "c189" || reportCode == "c040")
                                {
                                    field = "IDEAINDICATOR";
                                }
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
                                DynamicClassObject.AddProperty(column.ColumnName, "", fileDataRow);
                            }

                        }
                    });

                    dynamicRows.Add(fileDataRow);

                }
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
