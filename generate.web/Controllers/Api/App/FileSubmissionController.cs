using generate.infrastructure.Contexts;
using generate.core.Models;
using generate.core.Models.App;
using generate.core.Models.RDS;
using generate.core.Dtos.App;
using generate.core.Interfaces.Services;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Dynamic;
using generate.shared.Utilities;
using generate.core.Interfaces.Repositories.App;
using System.Data;
using System;
using generate.core.Dtos.RDS;
using Hangfire.Storage;
using System.Text.Json;
using Microsoft.Extensions.Configuration;
using generate.core.Config;
using Microsoft.Extensions.Options;
using System.Configuration;

namespace generate.web.Controllers.Api.App
{
    [Route("api/app/filesubmissions")]
    [ApiController]
    public class FileSubmissionController : Controller
    {

        private IAppRepository _fileSubmissionRepository;
        private IFileSubmissionService _fileSubmissionService;
        private IEdfactsFileService _edfactsFileService;
        private readonly IOptions<AppSettings> _appSettings;
        private int _iterationSize;

        public FileSubmissionController(
            IAppRepository fileSubmissionRepository,
            IFileSubmissionService fileSubmissionService,
            IEdfactsFileService edfactsFileService,
            IOptions<AppSettings> appSettings,
            IConfiguration configuration)
        {
            _fileSubmissionRepository = fileSubmissionRepository;
            _fileSubmissionService = fileSubmissionService;
            _edfactsFileService = edfactsFileService;
            _appSettings = appSettings;

            _iterationSize = Convert.ToInt32(configuration.GetSection("appSettings").GetValue<string>("FileIterationSize"));
        }

        [HttpGet("")]
        public JsonResult Get()
        {
            IEnumerable<FileSubmission> results = _fileSubmissionRepository.GetAll<FileSubmission>(0, 0);

            return Json(results);

        }

        [HttpGet("{reportTypeCode}/{reportCode}/{reportLevel}/{reportYear}/{fileFormatType}/{fileName}")]
        public void Get(string reportTypeCode, string reportCode, string reportLevel, string reportYear, string fileFormatType, string fileName)
        {
            if (reportTypeCode == null || reportCode == null || reportLevel == null || reportYear == null || fileFormatType == null)
            {
                return;
            }
            else if (reportCode.ToLower() == "c052" && reportLevel.ToLower() == "sch")
            {
                

                FileSubmission submission = _fileSubmissionService.GetFileSubmission(reportTypeCode, reportCode, reportLevel, reportYear);
                List<FileSubmissionColumnDto> fileSubmissioncolumns = _fileSubmissionService.GetFileSubmissionColumns(submission);
                int startRecord = 1;
                int numberOfRecords = this._iterationSize;
                int tableCount = numberOfRecords;
                int fileRecordNUmber = 1;
                List<MembershipReportDto> dataTable = null;

                Response.ContentType = _fileSubmissionService.GetContentType(fileFormatType);
                Response.Headers.Add("Content-Disposition", $"attachment; filename=\"{fileName}\"");

                bool headerWritten = false;
                while (tableCount == numberOfRecords)
                {

                    var data = _edfactsFileService.GetMembershipStudentCountData(reportCode, reportTypeCode, reportLevel, reportYear, fileSubmissioncolumns, startRecord, numberOfRecords);
                    if (!headerWritten)
                    {
                        byte[] headerBytes = Encoding.UTF8.GetBytes(_fileSubmissionService.GetFileHeader(reportTypeCode, reportCode, reportLevel, reportYear, fileFormatType, fileName, data.Item2) + Environment.NewLine);
                        Response.Body.WriteAsync(headerBytes, 0, headerBytes.Length);
                        headerWritten = true;
                    }

                    dataTable = data.Item1.ToList();
                    List<string> rowData = new List<string>(); ;
                    byte[] rowBytes = null;


                    dataTable.ForEach(row =>
                            {

                                rowData.Add(fileRecordNUmber.ToString());
                                rowData.Add(row.StateANSICode);
                                rowData.Add("01");
                                rowData.Add(row.ParentOrganizationIdentifierSea);
                                rowData.Add(row.OrganizationIdentifierSea);
                                rowData.Add("MEMBER");
                                rowData.Add(row.GRADELEVEL);
                                rowData.Add(row.RACE);
                                rowData.Add(row.SEX);
                                rowData.Add(row.TotalIndicator);
                                rowData.Add("");
                                rowData.Add(row.StudentCount.ToString());

                                rowBytes = Encoding.UTF8.GetBytes(_fileSubmissionService.GetSubmissionRow(rowData, fileFormatType, fileSubmissioncolumns) + Environment.NewLine);
                                Response.Body.WriteAsync(rowBytes, 0, rowBytes.Length);
                                rowData.Clear();
                                rowBytes = null;
                                ++fileRecordNUmber;
                            });

                    tableCount = dataTable.Count;
                    startRecord = startRecord + numberOfRecords;
                    dataTable = null;
                    GC.Collect();
                }

                Response.Body.FlushAsync();
                Response.Body.Close();
            }
            else
            {
                FileSubmission submission = _fileSubmissionService.GetFileSubmission(reportTypeCode, reportCode, reportLevel, reportYear);
                List<FileSubmissionColumnDto> fileSubmissioncolumns = _fileSubmissionService.GetFileSubmissionColumns(submission);

                List<ExpandoObject> dataTable = _edfactsFileService.GetStudentCountData(reportCode, reportTypeCode, reportLevel, reportYear, fileSubmissioncolumns);

                Response.ContentType = _fileSubmissionService.GetContentType(fileFormatType);
                Response.Headers.Add("Content-Disposition", $"attachment; filename=\"{fileName}\"");

                byte[] headerBytes = Encoding.UTF8.GetBytes(_fileSubmissionService.GetFileHeader(reportTypeCode, reportCode, reportLevel, reportYear, fileFormatType, fileName, dataTable.Count) + Environment.NewLine);
                Response.Body.WriteAsync(headerBytes, 0, headerBytes.Length);

                dataTable.ForEach(row =>
                {
                    var rowData = new List<string>();
                    foreach (FileSubmissionColumnDto column in fileSubmissioncolumns)
                    {
                        rowData.Add(DynamicClassObject.GetProperty(column.ColumnName, row));
                    }
                    byte[] rowBytes = Encoding.UTF8.GetBytes(_fileSubmissionService.GetSubmissionRow(rowData, fileFormatType, fileSubmissioncolumns) + Environment.NewLine);
                    Response.Body.WriteAsync(rowBytes, 0, rowBytes.Length);
                });

                Response.Body.FlushAsync();
                Response.Body.Close();
            }

            return;
        }  

    }
}
