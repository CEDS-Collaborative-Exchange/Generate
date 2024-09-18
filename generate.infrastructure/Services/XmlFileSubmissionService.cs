using System;
using System.Linq;
using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using generate.core.Models.App;
using generate.core.Interfaces.Services;
using System.Linq.Expressions;
using generate.core.Models.IDS;
using System.Threading.Tasks;
using Microsoft.Extensions.PlatformAbstractions;
using generate.core.ViewModels.App;
using generate.core.Dtos.App;
using System.Text;
using System.Xml;
using System.IO;
using generate.shared.Utilities;
using System.Dynamic;
using generate.core.Interfaces.Repositories.App;

namespace generate.infrastructure.Services
{
    public class XmlFileSubmissionService : IXmlFileSubmissionService
    {
        private readonly IAppRepository _appRepository;


        public XmlFileSubmissionService(
            IAppRepository appRepository
            )
        {
            _appRepository = appRepository;
        }

        public string GetFileDescription(string reportTypeCode, string reportCode, string reportLevel, string reportYear)
        {

            GenerateReport report = _appRepository.Find<GenerateReport>(r => r.GenerateReportType.ReportTypeCode == reportTypeCode
             && r.ReportCode == reportCode
             && r.GenerateReport_OrganizationLevels.Count(l => l.OrganizationLevel.LevelCode == reportLevel) == 1, 0, 1)
             .FirstOrDefault();

            OrganizationLevel level = _appRepository.Find<OrganizationLevel>(f => f.LevelCode == reportLevel).FirstOrDefault();

            return _appRepository.Find<FileSubmission>(f => f.GenerateReportId == report.GenerateReportId
                                                                && f.OrganizationLevelId == level.OrganizationLevelId
                                                                && f.SubmissionYear == reportYear, 0, 1).FirstOrDefault().FileSubmissionDescription;

        }

        public FileSubmission GetFileSubmission(string reportTypeCode, string reportCode, string reportLevel, string reportYear)
        {
            List<FileSubmissionColumnDto> results = new List<FileSubmissionColumnDto>();

            GenerateReport report = _appRepository.Find<GenerateReport>(r => r.GenerateReportType.ReportTypeCode == reportTypeCode
              && r.ReportCode == reportCode
              && r.GenerateReport_OrganizationLevels.Count(l => l.OrganizationLevel.LevelCode == reportLevel) == 1, 0, 1)
              .FirstOrDefault();

            if (report == null)
            {
                return null;
            }

            OrganizationLevel level = _appRepository.Find<OrganizationLevel>(f => f.LevelCode == reportLevel).FirstOrDefault();

            FileSubmission fileRecord = _appRepository.Find<FileSubmission>(f => f.GenerateReportId == report.GenerateReportId
                                                                && f.OrganizationLevelId == level.OrganizationLevelId
                                                                && f.SubmissionYear == reportYear, 0, 1, s => s.FileSubmission_FileColumns).FirstOrDefault();

            return fileRecord;
        }

        public List<FileSubmissionColumnDto> GetFileSubmissionColumns(FileSubmission submission)
        {
            List<FileSubmissionColumnDto> results = new List<FileSubmissionColumnDto>();

            foreach (FileSubmission_FileColumn fileColumn in submission.FileSubmission_FileColumns.OrderBy(x => x.SequenceNumber))
            {

                FileColumn column = _appRepository.Find<FileColumn>(c => c.FileColumnId == fileColumn.FileColumnId, 0, 1).FirstOrDefault();

                if (column.XMLElementName.Length > 0)
                { 
                    FileSubmissionColumnDto columnDto = new FileSubmissionColumnDto()
                    {
                        FileColumnId = fileColumn.FileColumnId,
                        ColumnName = column.ColumnName,
                        ColumnLength = column.ColumnLength,
                        DataType = column.DataType,
                        DisplayName = column.DisplayName,
                        XMLElementName = column.XMLElementName,
                        SequenceNumber = fileColumn.SequenceNumber,
                        StartPosition = fileColumn.StartPosition,
                        EndPosition = fileColumn.EndPosition,
                        IsOptional = fileColumn.IsOptional

                    };

                    results.Add(columnDto);
                }
            }

            return results;
        }



        public string getXmlContent(string reportTypeCode, string reportCode, string reportLevel, string reportYear, string fileFormatType, string fileName, List<FileSubmissionColumnDto> columns, List<ExpandoObject> data)
        {

            int submissionYear = Convert.ToInt32(reportYear.Split('-')[0]);
            string reportingPeriod = submissionYear.ToString() + "-" + (submissionYear + 1).ToString();

            List<FileSubmissionColumnDto> xmlColumns = columns.Where(t => t.XMLElementName.Length > 0).ToList();

            MemoryStream memoryStream = new MemoryStream();
            XmlWriterSettings xmlWriterSettings = new XmlWriterSettings();
            xmlWriterSettings.Encoding = new UTF8Encoding(false);
            xmlWriterSettings.ConformanceLevel = ConformanceLevel.Document;
            xmlWriterSettings.Indent = true;

            using (XmlWriter xmlWriter = XmlWriter.Create(memoryStream, xmlWriterSettings))
            {
                xmlWriter.WriteStartDocument();
                xmlWriter.WriteStartElement("FILETRANSMISSION");
                xmlWriter.WriteAttributeString("FILELAYOUTTYPE", GetFileDescription(reportTypeCode, reportCode, reportLevel, reportYear));
                xmlWriter.WriteAttributeString("FILEID", fileName);
                xmlWriter.WriteAttributeString("SCHOOLYEAR", reportingPeriod);

                // Following code may be re-factored using more generic type in the future.
               
                if (reportLevel == "sch")
                {
                    var agencies = data.Select(a => new { FIPSStateCode = DynamicClassObject.GetProperty("FIPSStateCode", a), STATEAGENCYIDNUMBER = DynamicClassObject.GetProperty("StateAgencyNumber", a), STATELEAIDNUMBER = DynamicClassObject.GetProperty("STATELEAIDNUMBER", a), STATESCHOOLIDNUMBER = DynamicClassObject.GetProperty("STATESCHOOLIDNUMBER", a) }).Distinct().ToList();
                    agencies.ForEach(agency =>
                    {

                        xmlWriter.WriteStartElement("AGENCY");
                        xmlWriter.WriteAttributeString("FIPSSTATECODE", agency.FIPSStateCode);
                        xmlWriter.WriteAttributeString("STATEAGENCYIDNUMBER", agency.STATEAGENCYIDNUMBER);
                        xmlWriter.WriteAttributeString("STATELEAIDNUMBER", agency.STATELEAIDNUMBER);
                        xmlWriter.WriteAttributeString("STATESCHOOLIDNUMBER", agency.STATESCHOOLIDNUMBER);


                        data.ForEach(row =>
                        {
                            xmlWriter.WriteStartElement("TABLETYPE");
                            foreach (FileSubmissionColumnDto column in xmlColumns)
                            {
                                if (column.XMLElementName == "CATEGORY")
                                {
                                    string val = DynamicClassObject.GetProperty(column.ColumnName, row);
                                    if (val.Length > 0)
                                    {
                                        xmlWriter.WriteStartElement(column.XMLElementName);
                                        xmlWriter.WriteAttributeString("TYPE", column.ColumnName);
                                        xmlWriter.WriteAttributeString("VALUE", val);
                                        xmlWriter.WriteEndElement();
                                    }
                                }
                                if (column.XMLElementName == "AMOUNT" || column.XMLElementName == "EXPLANATION")
                                {
                                    xmlWriter.WriteStartElement(column.XMLElementName);
                                    xmlWriter.WriteValue(DynamicClassObject.GetProperty(column.ColumnName, row));
                                    xmlWriter.WriteEndElement();

                                }
                                if (column.XMLElementName == "TYPEABBRV")
                                {
                                    xmlWriter.WriteAttributeString(column.XMLElementName, DynamicClassObject.GetProperty(column.ColumnName, row));
                                    xmlColumns.ForEach(s =>
                                    {
                                        if (s.XMLElementName == "TOTALINDICATOR")
                                        {
                                            xmlWriter.WriteAttributeString(s.XMLElementName, DynamicClassObject.GetProperty(s.ColumnName, row));
                                        }
                                    });
                                }
                            }

                            xmlWriter.WriteEndElement();
                        });
                        xmlWriter.WriteEndElement();
                    });
                }
                else if (reportLevel == "lea")
                {
                    var agencies = data.Select(a => new { FIPSStateCode = DynamicClassObject.GetProperty("FIPSStateCode", a), STATEAGENCYIDNUMBER = DynamicClassObject.GetProperty("StateAgencyNumber", a), STATELEAIDNUMBER = DynamicClassObject.GetProperty("STATELEAIDNUMBER", a) }).Distinct().ToList();
                    agencies.ForEach(agency =>
                    {

                        xmlWriter.WriteStartElement("AGENCY");
                        xmlWriter.WriteAttributeString("FIPSSTATECODE", agency.FIPSStateCode);
                        xmlWriter.WriteAttributeString("STATEAGENCYIDNUMBER", agency.STATEAGENCYIDNUMBER);
                        xmlWriter.WriteAttributeString("STATELEAIDNUMBER", agency.STATELEAIDNUMBER);

                        data.ForEach(row =>
                        {
                            xmlWriter.WriteStartElement("TABLETYPE");
                            foreach (FileSubmissionColumnDto column in xmlColumns)
                            {
                                if (column.XMLElementName == "CATEGORY")
                                {
                                    string val = DynamicClassObject.GetProperty(column.ColumnName, row);
                                    if (val.Length > 0)
                                    {
                                        xmlWriter.WriteStartElement(column.XMLElementName);
                                        xmlWriter.WriteAttributeString("TYPE", column.ColumnName);
                                        xmlWriter.WriteAttributeString("VALUE", val);
                                        xmlWriter.WriteEndElement();
                                    }
                                }
                                if (column.XMLElementName == "AMOUNT" || column.XMLElementName == "EXPLANATION")
                                {
                                    xmlWriter.WriteStartElement(column.XMLElementName);
                                    xmlWriter.WriteValue(DynamicClassObject.GetProperty(column.ColumnName, row));
                                    xmlWriter.WriteEndElement();

                                }

                                if (column.XMLElementName == "REAPALTFUNDIND")
                                {
                                    xmlWriter.WriteStartElement(column.XMLElementName);
                                    xmlWriter.WriteValue(DynamicClassObject.GetProperty(column.ColumnName, row));
                                    xmlWriter.WriteEndElement();

                                }
                                if (column.XMLElementName == "TYPEABBRV")
                                {
                                    xmlWriter.WriteAttributeString(column.XMLElementName, DynamicClassObject.GetProperty(column.ColumnName, row));
                                    xmlColumns.ForEach(s =>
                                    {
                                        if (s.XMLElementName == "TOTALINDICATOR")
                                        {
                                            xmlWriter.WriteAttributeString(s.XMLElementName, DynamicClassObject.GetProperty(s.ColumnName, row));
                                        }
                                    });
                                }
                            }

                            xmlWriter.WriteEndElement();
                        });
                        xmlWriter.WriteEndElement();
                    });
                }
                else if (reportLevel == "sea")
                {
                    var agencies = data.Select(a => new { FIPSStateCode = DynamicClassObject.GetProperty("FIPSStateCode", a), STATEAGENCYIDNUMBER = DynamicClassObject.GetProperty("StateAgencyNumber", a) }).Distinct().ToList();
                    agencies.ForEach(agency =>
                    {

                        xmlWriter.WriteStartElement("AGENCY");
                        xmlWriter.WriteAttributeString("FIPSSTATECODE", agency.FIPSStateCode);
                        xmlWriter.WriteAttributeString("STATEAGENCYIDNUMBER", agency.STATEAGENCYIDNUMBER);

                        data.ForEach(row =>
                        {
                            xmlWriter.WriteStartElement("TABLETYPE");
                            foreach (FileSubmissionColumnDto column in xmlColumns)
                            {
                                if (column.XMLElementName == "CATEGORY")
                                {
                                    string val = DynamicClassObject.GetProperty(column.ColumnName, row);
                                    if (val.Length > 0)
                                    {
                                        xmlWriter.WriteStartElement(column.XMLElementName);
                                        xmlWriter.WriteAttributeString("TYPE", column.ColumnName);
                                        xmlWriter.WriteAttributeString("VALUE", val);
                                        xmlWriter.WriteEndElement();
                                    }
                                }
                                if (column.XMLElementName == "AMOUNT" || column.XMLElementName == "EXPLANATION")
                                {
                                    xmlWriter.WriteStartElement(column.XMLElementName);
                                    xmlWriter.WriteValue(DynamicClassObject.GetProperty(column.ColumnName, row));
                                    xmlWriter.WriteEndElement();

                                }
                                if (column.XMLElementName == "TYPEABBRV")
                                {
                                    xmlWriter.WriteAttributeString(column.XMLElementName, DynamicClassObject.GetProperty(column.ColumnName, row));
                                    xmlColumns.ForEach(s =>
                                    {
                                        if (s.XMLElementName == "TOTALINDICATOR")
                                        {
                                            xmlWriter.WriteAttributeString(s.XMLElementName, DynamicClassObject.GetProperty(s.ColumnName, row));
                                        }
                                    });
                                }
                            }

                            xmlWriter.WriteEndElement();
                        });
                        xmlWriter.WriteEndElement();
                    });
                }
                
                xmlWriter.WriteEndElement();
                xmlWriter.WriteEndDocument();

            }

            return Encoding.UTF8.GetString(memoryStream.ToArray());
        }
     
    }
}
