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
using generate.core.Models.RDS;
using System.Dynamic;
using generate.core.Interfaces.Repositories.RDS;
using generate.core.Interfaces.Repositories.App;

namespace generate.infrastructure.Services
{
    public class DataPopulationSummaryService : IDataPopulationSummaryService
    {

        private IAppRepository _appRepository;
        private IRDSRepository _rdsRepository;

        private IFactStudentCountRepository _factStudentCountRepository;
        private IFactStudentDisciplineRepository _factStudentDisciplineRepository;

        private int childCountDateMonth = 10;
        private int childCountDateDay = 1;

        public DataPopulationSummaryService(
            IAppRepository appRepository,
            IRDSRepository rdsRepository,
            IFactStudentCountRepository factStudentCountRepository,
            IFactStudentDisciplineRepository factStudentDisciplineRepository
            )
        {
            _appRepository = appRepository;
            _rdsRepository = rdsRepository;

            _factStudentCountRepository = factStudentCountRepository;
            _factStudentDisciplineRepository = factStudentDisciplineRepository;

            ToggleResponse childCountDate = _appRepository.Find<ToggleResponse>(r => r.ToggleQuestion.EmapsQuestionAbbrv == "CHDCTDTE").FirstOrDefault();
            if (childCountDate != null)
            {
                if (childCountDate.ResponseValue.Contains("/"))
                {
                    string[] childCountDateArray = childCountDate.ResponseValue.Split('/');
                    if (childCountDateArray.Length == 2)
                    {
                        int.TryParse(childCountDateArray[0], out childCountDateMonth);
                        int.TryParse(childCountDateArray[1], out childCountDateDay);
                    }
                }

            }

        }

        public GenerateReportDataDto GetReportDto(string reportCode, string reportLevel, string reportYear, string categorySetCode, int reportSort = 1, int skip = 0, int take = 50)
        {
            GenerateReport report = _appRepository.Find<GenerateReport>(r => r.GenerateReportType.ReportTypeCode == "datapopulation"
                && r.ReportCode == reportCode
                && r.GenerateReport_OrganizationLevels.Count(l => l.OrganizationLevel.LevelCode == reportLevel) == 1, 0, 1, r => r.FactTable)
                .FirstOrDefault();

            if (report == null)
            {
                return null;
            }

            IEnumerable<ReportEDFactsK12StudentCount> queryStudentCountReportDto = null;
            IEnumerable<ReportEDFactsK12StudentDiscipline> queryStudentDisciplineReportDto = null;
            GenerateReportDataDto reportDto = new GenerateReportDataDto();
            reportDto.structure = new GenerateReportStructureDto();
            reportDto.data = new List<ExpandoObject>();

            reportDto.ReportTitle = report.ReportName;

            int dataPopulationFactTypeId = _rdsRepository.Find<DimFactType>(f => f.FactTypeCode == "datapopulation").Select(f => f.DimFactTypeId).FirstOrDefault();

            dynamic dataRows = new List<ExpandoObject>();

            if (report.FactTable.FactTableName == "FactK12StudentCounts") { 
                queryStudentCountReportDto = _factStudentCountRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode).OrderBy(s => s.OrganizationName);
                reportDto.dataCount = queryStudentCountReportDto.Select(q => q.OrganizationIdentifierSea).Distinct().Count();
            }
            else if (report.FactTable.FactTableName == "FactK12StudentDisciplines")
            {
                queryStudentDisciplineReportDto = _factStudentDisciplineRepository.Get_ReportData(reportCode, reportLevel, reportYear, categorySetCode).OrderBy(s => s.OrganizationName);
                reportDto.dataCount = queryStudentDisciplineReportDto.Select(q => q.OrganizationIdentifierSea).Distinct().Count();

            }


            // Headers
            if (reportLevel == "lea")
            {
                reportDto.structure.rowHeader = "LEAs";
            }
            else if (reportLevel == "sch")
            {
                reportDto.structure.rowHeader = "Schools";
            }


            if (reportCode == "studentsex")
            {
                Dictionary<string, string> columns = new Dictionary<string, string>();
                columns.Add("Female", "Female");
                columns.Add("Male", "Male");
                columns.Add("NotSelected", "Not Selected");
                columns.Add("Missing", "Missing");
                columns.Add("Total", "Total");

                reportDto.structure.columnHeaders = new List<string>();
                foreach (var item in columns)
                {
                    reportDto.structure.columnHeaders.Add(item.Value);
                }


                if (reportLevel == "lea")
                {
                    var queryDim = queryStudentCountReportDto
                        .GroupBy(c => new
                        {
                            c.StateAbbreviationCode,
                            c.StateAbbreviationDescription,
                            //c.OrganizationId,
                            c.OrganizationName
                        })
                        .Select(g => new
                        {
                            StateCode = g.Key.StateAbbreviationCode,
                            StateName = g.Key.StateAbbreviationDescription,
                            //OrganizationId = g.Key.OrganizationId,
                            OrganizationName = g.Key.OrganizationName,
                            Female = g.Where(c => c.SEX == "Female").Sum(c => (int?)c.StudentCount) ?? 0,
                            Male = g.Where(c => c.SEX == "Male").Sum(c => (int?)c.StudentCount) ?? 0,
                            NotSelected = g.Where(c => c.SEX == "NotSelected").Sum(c => (int?)c.StudentCount) ?? 0,
                            Missing = g.Where(c => c.SEX == "MISSING").Sum(c => (int?)c.StudentCount) ?? 0,
                            Total = g.Sum(c => c.StudentCount)
                        });


                    foreach (var queryItem in queryDim)
                    {
                        dynamic dataRow = new ExpandoObject();

                        dataRow.stateCode = queryItem.StateCode;
                        dataRow.stateName = queryItem.StateName;

                        //dataRow.rowId = queryItem.OrganizationId;
                        dataRow.rowKey = queryItem.OrganizationName;

                        dataRow.col_1 = queryItem.Female;
                        dataRow.col_2 = queryItem.Male;
                        dataRow.col_3 = queryItem.NotSelected;
                        dataRow.col_4 = queryItem.Missing;
                        dataRow.col_5 = queryItem.Total;

                        dataRows.Add(dataRow);

                    }

                    reportDto.data.AddRange(dataRows);

                }
                else if (reportLevel == "sch")
                {

                    var queryDim = queryStudentCountReportDto
                        .GroupBy(c => new
                        {
                            c.StateAbbreviationCode,
                            c.StateAbbreviationDescription,
                            //c.OrganizationId,
                            c.OrganizationName
                        })
                        .Select(g => new
                        {
                            StateCode = g.Key.StateAbbreviationCode,
                            StateName = g.Key.StateAbbreviationDescription,
                            //OrganizationId = g.Key.OrganizationId,
                            OrganizationName = g.Key.OrganizationName,
                            Female = g.Where(c => c.SEX == "Female").Sum(c => (int?)c.StudentCount) ?? 0,
                            Male = g.Where(c => c.SEX == "Male").Sum(c => (int?)c.StudentCount) ?? 0,
                            NotSelected = g.Where(c => c.SEX == "NotSelected").Sum(c => (int?)c.StudentCount) ?? 0,
                            Missing = g.Where(c => c.SEX == "MISSING").Sum(c => (int?)c.StudentCount) ?? 0,
                            Total = g.Sum(c => c.StudentCount)
                        });

                    foreach (var queryItem in queryDim)
                    {
                        dynamic dataRow = new ExpandoObject();

                        dataRow.stateCode = queryItem.StateCode;
                        dataRow.stateName = queryItem.StateName;

                        //dataRow.rowId = queryItem.OrganizationId;
                        dataRow.rowKey = queryItem.OrganizationName;

                        dataRow.col_1 = queryItem.Female;
                        dataRow.col_2 = queryItem.Male;
                        dataRow.col_3 = queryItem.NotSelected;
                        dataRow.col_4 = queryItem.Missing;
                        dataRow.col_5 = queryItem.Total;

                        dataRows.Add(dataRow);

                    }

                    reportDto.data.AddRange(dataRows);


                }




            }
            else if (reportCode == "studentrace")
            {


                Dictionary<string, string> columns = new Dictionary<string, string>();
                columns.Add("AM", "American Indian or Alaska Native");
                columns.Add("AS", "Asian");
                columns.Add("BL", "Black or African American");
                columns.Add("HI", "Hispanic");
                columns.Add("PI", "Native Hawaiian or Other Pacific Islander");
                columns.Add("WH", "White");
                columns.Add("MU", "Demographic Race Two or More Races");
                columns.Add("Missing", "Missing");
                columns.Add("Total", "Total");

                reportDto.structure.columnHeaders = new List<string>();
                foreach (var item in columns)
                {
                    reportDto.structure.columnHeaders.Add(item.Value);
                }



                if (reportLevel == "lea")
                {

                    var queryDim = queryStudentCountReportDto
                        .GroupBy(c => new
                        {
                            c.StateAbbreviationCode,
                            c.StateAbbreviationDescription,
                            //c.OrganizationId,
                            c.OrganizationName
                        })
                        .Select(g => new
                        {
                            StateCode = g.Key.StateAbbreviationCode,
                            StateName = g.Key.StateAbbreviationDescription,
                            //OrganizationId = g.Key.OrganizationId,
                            OrganizationName = g.Key.OrganizationName,
                            AM = g.Where(c => c.RACE == "AmericanIndianorAlaskaNative").Sum(c => (int?)c.StudentCount) ?? 0,
                            AS = g.Where(c => c.RACE == "Asian").Sum(c => (int?)c.StudentCount) ?? 0,
                            BL = g.Where(c => c.RACE == "BlackorAfricanAmerican").Sum(c => (int?)c.StudentCount) ?? 0,
                            HI = g.Where(c => c.RACE == "HI").Sum(c => (int?)c.StudentCount) ?? 0,
                            PI = g.Where(c => c.RACE == "NativeHawaiianorOtherPacificIslander").Sum(c => (int?)c.StudentCount) ?? 0,
                            WH = g.Where(c => c.RACE == "White").Sum(c => (int?)c.StudentCount) ?? 0,
                            MU = g.Where(c => c.RACE == "TwoorMoreRaces").Sum(c => (int?)c.StudentCount) ?? 0,
                            Missing = g.Where(c => c.RACE == "MISSING").Sum(c => (int?)c.StudentCount) ?? 0,
                            Total = g.Sum(c => c.StudentCount)
                        });

                    foreach (var queryItem in queryDim)
                    {
                        dynamic dataRow = new ExpandoObject();

                        dataRow.stateCode = queryItem.StateCode;
                        dataRow.stateName = queryItem.StateName;

                        //dataRow.rowId = queryItem.OrganizationId;
                        dataRow.rowKey = queryItem.OrganizationName;

                        dataRow.col_1 = queryItem.AM;
                        dataRow.col_2 = queryItem.AS;
                        dataRow.col_3 = queryItem.BL;
                        dataRow.col_4 = queryItem.HI;
                        dataRow.col_5 = queryItem.PI;
                        dataRow.col_6 = queryItem.WH;
                        dataRow.col_7 = queryItem.MU;
                        dataRow.col_8 = queryItem.Missing;
                        dataRow.col_9 = queryItem.Total;

                        dataRows.Add(dataRow);

                    }

                    reportDto.data.AddRange(dataRows);


                }
                else if (reportLevel == "sch")
                {

                    var queryDim = queryStudentCountReportDto
                        .GroupBy(c => new
                        {
                            c.StateAbbreviationCode,
                            c.StateAbbreviationDescription,
                            //c.OrganizationId,
                            c.OrganizationName
                        })
                        .Select(g => new
                        {

                            StateCode = g.Key.StateAbbreviationCode,
                            StateName = g.Key.StateAbbreviationDescription,
                            //OrganizationId = g.Key.OrganizationId,
                            OrganizationName = g.Key.OrganizationName,
                            AM = g.Where(c => c.RACE == "AmericanIndianorAlaskaNative").Sum(c => (int?)c.StudentCount) ?? 0,
                            AS = g.Where(c => c.RACE == "Asian").Sum(c => (int?)c.StudentCount) ?? 0,
                            BL = g.Where(c => c.RACE == "BlackorAfricanAmerican").Sum(c => (int?)c.StudentCount) ?? 0,
                            HI = g.Where(c => c.RACE == "HI").Sum(c => (int?)c.StudentCount) ?? 0,
                            PI = g.Where(c => c.RACE == "NativeHawaiianorOtherPacificIslander").Sum(c => (int?)c.StudentCount) ?? 0,
                            WH = g.Where(c => c.RACE == "White").Sum(c => (int?)c.StudentCount) ?? 0,
                            MU = g.Where(c => c.RACE == "TwoorMoreRaces").Sum(c => (int?)c.StudentCount) ?? 0,
                            Missing = g.Where(c => c.RACE == "MISSING").Sum(c => (int?)c.StudentCount) ?? 0,
                            Total = g.Sum(c => c.StudentCount)
                        });


                    foreach (var queryItem in queryDim)
                    {

                        dynamic dataRow = new ExpandoObject();

                        dataRow.stateCode = queryItem.StateCode;
                        dataRow.stateName = queryItem.StateName;

                        //dataRow.rowId = queryItem.OrganizationId;
                        dataRow.rowKey = queryItem.OrganizationName;

                        dataRow.col_1 = queryItem.AM;
                        dataRow.col_2 = queryItem.AS;
                        dataRow.col_3 = queryItem.BL;
                        dataRow.col_4 = queryItem.HI;
                        dataRow.col_5 = queryItem.PI;
                        dataRow.col_6 = queryItem.WH;
                        dataRow.col_7 = queryItem.MU;
                        dataRow.col_8 = queryItem.Missing;
                        dataRow.col_9 = queryItem.Total;


                        dataRows.Add(dataRow);

                    }

                    reportDto.data.AddRange(dataRows);


                }


            }
            else if (reportCode == "studentsubpopulation")
            {
                Dictionary<string, string> columns = new Dictionary<string, string>();
                columns.Add("ECODIS", "Economic Disadvantage Status");
                columns.Add("HOMELSSTATUS", "Homeless Status");
                if (Convert.ToInt32(reportYear.Substring(0, 4)) >= 2017)
                {
                    columns.Add("LEP", "English Learner Status");
                }
                else
                {
                    columns.Add("LEP", "Limited English Proficiency Status");
                }
                columns.Add("MIGRNTSTATUS", "Migrant Status");
                columns.Add("Total", "Total");

                reportDto.structure.columnHeaders = new List<string>();
                foreach (var item in columns)
                {
                    reportDto.structure.columnHeaders.Add(item.Value);
                }

                if (reportLevel == "lea")
                {


                    var queryDim = queryStudentCountReportDto
                        .GroupBy(c => new
                        {
                            c.StateAbbreviationCode,
                            c.StateAbbreviationDescription,
                            //c.OrganizationId,
                            c.OrganizationName
                        })
                        .Select(g => new
                        {
                            StateCode = g.Key.StateAbbreviationCode,
                            StateName = g.Key.StateAbbreviationDescription,
                           //OrganizationId = g.Key.OrganizationId,
                            OrganizationName = g.Key.OrganizationName,
                            ECODIS = g.Where(c => c.ECONOMICDISADVANTAGESTATUS == "EconomicDisadvantage").Sum(c => (int?)c.StudentCount) ?? 0,
                            HOMELSSTATUS = g.Where(c => c.HOMELESSNESSSTATUS == "HomelessUnaccompaniedYouth").Sum(c => (int?)c.StudentCount) ?? 0,
                            LEP = g.Where(c => c.ENGLISHLEARNERSTATUS == "LEP").Sum(c => (int?)c.StudentCount) ?? 0,
                            MIGRNTSTATUS = g.Where(c => c.MIGRANTSTATUS == "Migrant").Sum(c => (int?)c.StudentCount) ?? 0,
                            Total = g.Sum(c => c.StudentCount)
                        });

                    foreach (var queryItem in queryDim)
                    {

                        dynamic dataRow = new ExpandoObject();

                        dataRow.stateCode = queryItem.StateCode;
                        dataRow.stateName = queryItem.StateName;

                        //dataRow.rowId = queryItem.OrganizationId;
                        dataRow.rowKey = queryItem.OrganizationName;

                        dataRow.col_1 = queryItem.ECODIS;
                        dataRow.col_2 = queryItem.HOMELSSTATUS;
                        dataRow.col_3 = queryItem.LEP;
                        dataRow.col_4 = queryItem.MIGRNTSTATUS;
                        dataRow.col_5 = queryItem.Total;

                        dataRows.Add(dataRow);

                    }

                    reportDto.data.AddRange(dataRows);

                }
                else if (reportLevel == "sch")
                {
                    var queryDim = queryStudentCountReportDto
                        .GroupBy(c => new
                        {
                            c.StateAbbreviationCode,
                            c.StateAbbreviationDescription,
                            //c.OrganizationId,
                            c.OrganizationName
                        })
                        .Select(g => new
                        {
                            StateCode = g.Key.StateAbbreviationCode,
                            StateName = g.Key.StateAbbreviationDescription,
                            //OrganizationId = g.Key.OrganizationId,
                            OrganizationName = g.Key.OrganizationName,
                            ECODIS = g.Where(c => c.ECONOMICDISADVANTAGESTATUS == "EconomicDisadvantage").Sum(c => (int?)c.StudentCount) ?? 0,
                            HOMELSSTATUS = g.Where(c => c.HOMELESSNESSSTATUS == "HomelessUnaccompaniedYouth").Sum(c => (int?)c.StudentCount) ?? 0,
                            LEP = g.Where(c => c.ENGLISHLEARNERSTATUS == "LEP").Sum(c => (int?)c.StudentCount) ?? 0,
                            MIGRNTSTATUS = g.Where(c => c.MIGRANTSTATUS == "Migrant").Sum(c => (int?)c.StudentCount) ?? 0,
                            Total = g.Sum(c => (int?)c.StudentCount) ?? 0
                        });

                    foreach (var queryItem in queryDim)
                    {

                        dynamic dataRow = new ExpandoObject();

                        dataRow.stateCode = queryItem.StateCode;
                        dataRow.stateName = queryItem.StateName;

                        //dataRow.rowId = queryItem.OrganizationId;
                        dataRow.rowKey = queryItem.OrganizationName;

                        dataRow.col_1 = queryItem.ECODIS;
                        dataRow.col_2 = queryItem.HOMELSSTATUS;
                        dataRow.col_3 = queryItem.LEP;
                        dataRow.col_4 = queryItem.MIGRNTSTATUS;
                        dataRow.col_5 = queryItem.Total;

                        dataRows.Add(dataRow);

                    }

                    reportDto.data.AddRange(dataRows);
                }
            }
            else if (reportCode == "studentdisability")
            {

                Dictionary<string, string> columns = new Dictionary<string, string>();
                columns.Add("AUT", "AUT");
                columns.Add("DB", "DB");
                columns.Add("DD", "DD");
                columns.Add("EMN", "EMN");
                columns.Add("HI", "HI");
                columns.Add("ID", "ID");
                columns.Add("MD", "MD");
                columns.Add("OHI", "OHI");
                columns.Add("OI", "OI");
                columns.Add("SLD", "SLD");
                columns.Add("SLI", "SLI");
                columns.Add("TBI", "TBI");
                columns.Add("VI", "VI");
                columns.Add("Missing", "Missing");
                columns.Add("Total", "Total");

                reportDto.structure.columnHeaders = new List<string>();
                foreach (var item in columns)
                {
                    reportDto.structure.columnHeaders.Add(item.Value);
                }


                if (reportLevel == "lea")
                {


                    var queryDim = queryStudentCountReportDto
                        .GroupBy(c => new
                        {
                            c.StateAbbreviationCode,
                            c.StateAbbreviationDescription,
                            //c.OrganizationId,
                            c.OrganizationName
                        })
                        .Select(g => new
                        {
                            StateCode = g.Key.StateAbbreviationCode,
                            StateName = g.Key.StateAbbreviationDescription,
                            //OrganizationId = g.Key.OrganizationId,
                            OrganizationName = g.Key.OrganizationName,
                            AUT = g.Where(c => c.IDEADISABILITYTYPE == "AUT").Sum(c => (int?)c.StudentCount) ?? 0,
                            DB = g.Where(c => c.IDEADISABILITYTYPE == "DB").Sum(c => (int?)c.StudentCount) ?? 0,
                            DD = g.Where(c => c.IDEADISABILITYTYPE == "DD").Sum(c => (int?)c.StudentCount) ?? 0,
                            EMN = g.Where(c => c.IDEADISABILITYTYPE == "EMN").Sum(c => (int?)c.StudentCount) ?? 0,
                            HI = g.Where(c => c.IDEADISABILITYTYPE == "HI").Sum(c => (int?)c.StudentCount) ?? 0,
                            ID = g.Where(c => c.IDEADISABILITYTYPE == "ID").Sum(c => (int?)c.StudentCount) ?? 0,
                            MD = g.Where(c => c.IDEADISABILITYTYPE == "MD").Sum(c => (int?)c.StudentCount) ?? 0,
                            OHI = g.Where(c => c.IDEADISABILITYTYPE == "OHI").Sum(c => (int?)c.StudentCount) ?? 0,
                            OI = g.Where(c => c.IDEADISABILITYTYPE == "OI").Sum(c => (int?)c.StudentCount) ?? 0,
                            SLD = g.Where(c => c.IDEADISABILITYTYPE == "SLD").Sum(c => (int?)c.StudentCount) ?? 0,
                            SLI = g.Where(c => c.IDEADISABILITYTYPE == "SLI").Sum(c => (int?)c.StudentCount) ?? 0,
                            TBI = g.Where(c => c.IDEADISABILITYTYPE == "TBI").Sum(c => (int?)c.StudentCount) ?? 0,
                            VI = g.Where(c => c.IDEADISABILITYTYPE == "VI").Sum(c => (int?)c.StudentCount) ?? 0,
                            Missing = g.Where(c => c.IDEADISABILITYTYPE == "MISSING").Sum(c => (int?)c.StudentCount) ?? 0,
                            Total = g.Sum(c => c.StudentCount)
                        });

                    foreach (var queryItem in queryDim)
                    {

                        dynamic dataRow = new ExpandoObject();

                        dataRow.stateCode = queryItem.StateCode;
                        dataRow.stateName = queryItem.StateName;

                        //dataRow.rowId = queryItem.OrganizationId;
                        dataRow.rowKey = queryItem.OrganizationName;

                        dataRow.col_1 = queryItem.AUT;
                        dataRow.col_2 = queryItem.DB;
                        dataRow.col_3 = queryItem.DD;
                        dataRow.col_4 = queryItem.EMN;
                        dataRow.col_5 = queryItem.HI;
                        dataRow.col_6 = queryItem.ID;
                        dataRow.col_7 = queryItem.MD;
                        dataRow.col_8 = queryItem.OHI;
                        dataRow.col_9 = queryItem.OI;
                        dataRow.col_10 = queryItem.SLD;
                        dataRow.col_11 = queryItem.SLI;
                        dataRow.col_12 = queryItem.TBI;
                        dataRow.col_13 = queryItem.VI;
                        dataRow.col_14 = queryItem.Missing;
                        dataRow.col_15 = queryItem.Total;

                        dataRows.Add(dataRow);

                    }

                    reportDto.data.AddRange(dataRows);


                }
                else if (reportLevel == "sch")
                {

                    var queryDim = queryStudentCountReportDto
                        .GroupBy(c => new
                        {
                            c.StateAbbreviationCode,
                            c.StateAbbreviationDescription,
                            //c.OrganizationId,
                            c.OrganizationName
                        })
                        .Select(g => new
                        {
                            StateCode = g.Key.StateAbbreviationCode,
                            StateName = g.Key.StateAbbreviationDescription,
                            //OrganizationId = g.Key.OrganizationId,
                            OrganizationName = g.Key.OrganizationName,
                            AUT = g.Where(c => c.IDEADISABILITYTYPE == "AUT").Sum(c => (int?)c.StudentCount) ?? 0,
                            DB = g.Where(c => c.IDEADISABILITYTYPE == "DB").Sum(c => (int?)c.StudentCount) ?? 0,
                            DD = g.Where(c => c.IDEADISABILITYTYPE == "DD").Sum(c => (int?)c.StudentCount) ?? 0,
                            EMN = g.Where(c => c.IDEADISABILITYTYPE == "EMN").Sum(c => (int?)c.StudentCount) ?? 0,
                            HI = g.Where(c => c.IDEADISABILITYTYPE == "HI").Sum(c => (int?)c.StudentCount) ?? 0,
                            ID = g.Where(c => c.IDEADISABILITYTYPE == "ID").Sum(c => (int?)c.StudentCount) ?? 0,
                            MD = g.Where(c => c.IDEADISABILITYTYPE == "MD").Sum(c => (int?)c.StudentCount) ?? 0,
                            OHI = g.Where(c => c.IDEADISABILITYTYPE == "OHI").Sum(c => (int?)c.StudentCount) ?? 0,
                            OI = g.Where(c => c.IDEADISABILITYTYPE == "OI").Sum(c => (int?)c.StudentCount) ?? 0,
                            SLD = g.Where(c => c.IDEADISABILITYTYPE == "SLD").Sum(c => (int?)c.StudentCount) ?? 0,
                            SLI = g.Where(c => c.IDEADISABILITYTYPE == "SLI").Sum(c => (int?)c.StudentCount) ?? 0,
                            TBI = g.Where(c => c.IDEADISABILITYTYPE == "TBI").Sum(c => (int?)c.StudentCount) ?? 0,
                            VI = g.Where(c => c.IDEADISABILITYTYPE == "VI").Sum(c => (int?)c.StudentCount) ?? 0,
                            Missing = g.Where(c => c.IDEADISABILITYTYPE == "MISSING").Sum(c => (int?)c.StudentCount) ?? 0,
                            Total = g.Sum(c => c.StudentCount)
                        });

                    foreach (var queryItem in queryDim)
                    {
                        dynamic dataRow = new ExpandoObject();

                        dataRow.stateCode = queryItem.StateCode;
                        dataRow.stateName = queryItem.StateName;

                        //dataRow.rowId = queryItem.OrganizationId;
                        dataRow.rowKey = queryItem.OrganizationName;

                        dataRow.col_1 = queryItem.AUT;
                        dataRow.col_2 = queryItem.DB;
                        dataRow.col_3 = queryItem.DD;
                        dataRow.col_4 = queryItem.EMN;
                        dataRow.col_5 = queryItem.HI;
                        dataRow.col_6 = queryItem.ID;
                        dataRow.col_7 = queryItem.MD;
                        dataRow.col_8 = queryItem.OHI;
                        dataRow.col_9 = queryItem.OI;
                        dataRow.col_10 = queryItem.SLD;
                        dataRow.col_11 = queryItem.SLI;
                        dataRow.col_12 = queryItem.TBI;
                        dataRow.col_13 = queryItem.VI;
                        dataRow.col_14 = queryItem.Missing;
                        dataRow.col_15 = queryItem.Total;


                        dataRows.Add(dataRow);

                    }

                    reportDto.data.AddRange(dataRows);


                }


            }
            else if (reportCode == "studentdiscipline")
            {


                Dictionary<string, string> columns = new Dictionary<string, string>();

                columns.Add("03086", "Expulsion with services");
                columns.Add("03087", "Expulsion without services");
                columns.Add("03100", "Suspension, in-school");
                columns.Add("03154", "Suspension, out-of-school, greater than 10 consecutive school days");
                columns.Add("03155", "Suspension, out-of-school, separate days cumulating to more than 10 school days");
                columns.Add("03101", "Suspension, out-of-school, with services");
                columns.Add("03102", "Suspension, out-of-school, without services");
                columns.Add("Missing", "Missing");
                columns.Add("Total", "Total");

                reportDto.structure.columnHeaders = new List<string>();
                foreach (var item in columns)
                {
                    reportDto.structure.columnHeaders.Add(item.Value);
                }


                if (reportLevel == "lea")
                {
                    var queryDim = queryStudentDisciplineReportDto
                        .GroupBy(c => new
                        {
                            c.StateAbbreviationCode,
                            c.StateAbbreviationDescription,
                            //c.OrganizationId,
                            c.OrganizationName
                        })
                        .Select(g => new
                        {
                            StateCode = g.Key.StateAbbreviationCode,
                            StateName = g.Key.StateAbbreviationDescription,
                            //OrganizationId = g.Key.OrganizationId,
                            OrganizationName = g.Key.OrganizationName,
                            d03086 = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "03086").Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                            d03087 = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "03087").Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                            d03100 = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "03100").Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                            d03154 = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "03154").Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                            d03155 = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "03155").Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                            d03101 = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "03101").Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                            d03102 = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "03102").Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                            Missing = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "MISSING").Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                            Total = g.Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                        });


                    foreach (var queryItem in queryDim)
                    {
                        dynamic dataRow = new ExpandoObject();

                        dataRow.stateCode = queryItem.StateCode;
                        dataRow.stateName = queryItem.StateName;

                        //dataRow.rowId = queryItem.OrganizationId;
                        dataRow.rowKey = queryItem.OrganizationName;

                        dataRow.col_1 = queryItem.d03086;
                        dataRow.col_2 = queryItem.d03087;
                        dataRow.col_3 = queryItem.d03100;
                        dataRow.col_4 = queryItem.d03154;
                        dataRow.col_5 = queryItem.d03155;
                        dataRow.col_6 = queryItem.d03101;
                        dataRow.col_7 = queryItem.d03102;
                        dataRow.col_8 = queryItem.Missing;
                        dataRow.col_9 = queryItem.Total;

                        dataRows.Add(dataRow);

                    }

                    reportDto.data.AddRange(dataRows);

                }
                else if (reportLevel == "sch")
                {

                    var queryDim = queryStudentDisciplineReportDto
                        .GroupBy(c => new
                        {
                            c.StateAbbreviationCode,
                            c.StateAbbreviationDescription,
                            //c.OrganizationId,
                            c.OrganizationName
                        })
                        .Select(g => new
                        {
                            StateCode = g.Key.StateAbbreviationCode,
                            StateName = g.Key.StateAbbreviationDescription,
                            //OrganizationId = g.Key.OrganizationId,
                            OrganizationName = g.Key.OrganizationName,
                            d03086 = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "03086").Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                            d03087 = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "03087").Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                            d03100 = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "03100").Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                            d03154 = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "03154").Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                            d03155 = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "03155").Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                            d03101 = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "03101").Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                            d03102 = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "03102").Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                            Missing = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "MISSING").Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                            Total = g.Sum(c => ((int?)c.DisciplineCount ?? 0) > 0 ? 1 : 0),
                        });

                    foreach (var queryItem in queryDim)
                    {
                        dynamic dataRow = new ExpandoObject();

                        dataRow.stateCode = queryItem.StateCode;
                        dataRow.stateName = queryItem.StateName;

                        //dataRow.rowId = queryItem.OrganizationId;
                        dataRow.rowKey = queryItem.OrganizationName;

                        dataRow.col_1 = queryItem.d03086;
                        dataRow.col_2 = queryItem.d03087;
                        dataRow.col_3 = queryItem.d03100;
                        dataRow.col_4 = queryItem.d03154;
                        dataRow.col_5 = queryItem.d03155;
                        dataRow.col_6 = queryItem.d03101;
                        dataRow.col_7 = queryItem.d03102;
                        dataRow.col_8 = queryItem.Missing;
                        dataRow.col_9 = queryItem.Total;

                        dataRows.Add(dataRow);

                    }

                    reportDto.data.AddRange(dataRows);


                }


            }
            else if (reportCode == "studentcount")
            {

                Dictionary<string, string> columns = new Dictionary<string, string>();
                columns.Add("StudentCount", "Student Count");


                reportDto.structure.columnHeaders = new List<string>();
                foreach (var item in columns)
                {
                    reportDto.structure.columnHeaders.Add(item.Value);
                }



                if (reportLevel == "lea")
                {


                    var queryDim = queryStudentCountReportDto
                        .GroupBy(c => new
                        {
                            c.StateAbbreviationCode,
                            c.StateAbbreviationDescription,
                            //c.OrganizationId,
                            c.OrganizationName
                        })
                        .Select(g => new
                        {
                            StateCode = g.Key.StateAbbreviationCode,
                            StateName = g.Key.StateAbbreviationDescription,
                           //OrganizationId = g.Key.OrganizationId,
                            OrganizationName = g.Key.OrganizationName,
                            StudentCount = g.Sum(c => c.StudentCount)
                        });

                    foreach (var queryItem in queryDim)
                    {
                        dynamic dataRow = new ExpandoObject();

                        dataRow.stateCode = queryItem.StateCode;
                        dataRow.stateName = queryItem.StateName;

                        //dataRow.rowId = queryItem.OrganizationId;
                        dataRow.rowKey = queryItem.OrganizationName;

                        dataRow.col_1 = queryItem.StudentCount;

                        dataRows.Add(dataRow);

                    }

                    reportDto.data.AddRange(dataRows);

                }
                else if (reportLevel == "sch")
                {

                    var queryDim = queryStudentCountReportDto
                        .GroupBy(c => new
                        {
                            c.StateAbbreviationCode,
                            c.StateAbbreviationDescription,
                            //c.OrganizationId,
                            c.OrganizationName
                        })
                        .Select(g => new
                        {
                            StateCode = g.Key.StateAbbreviationCode,
                            StateName = g.Key.StateAbbreviationDescription,
                            //OrganizationId = g.Key.OrganizationId,
                            OrganizationName = g.Key.OrganizationName,
                            StudentCount = g.Sum(c => c.StudentCount)
                        });


                    foreach (var queryItem in queryDim)
                    {
                        dynamic dataRow = new ExpandoObject();

                        dataRow.stateCode = queryItem.StateCode;
                        dataRow.stateName = queryItem.StateName;

                        //dataRow.rowId = queryItem.OrganizationId;
                        dataRow.rowKey = queryItem.OrganizationName;

                        dataRow.col_1 = queryItem.StudentCount;

                        dataRows.Add(dataRow);

                    }

                    reportDto.data.AddRange(dataRows);


                }

            }
            else if (reportCode == "studentswdtitle1")
            {
                reportDto.data = queryStudentCountReportDto.ToList();
            }
            else
            {
                // Set to -1 to indicate that it is not yet implemented
                reportDto.dataCount = -1;

            }

            return reportDto;
        }


        private List<ExpandoObject> GeneratePlaceHolderData(string reportLevel, int columnCount, IEnumerable<DimK12School> organizations, int skip, int take)
        {

            List<ExpandoObject> dataRows = new List<ExpandoObject>();

            if (reportLevel == "lea")
            {
                var leas = organizations
                    .Where(o => o.DimK12SchoolId != -1)
                    .Select(o => new { StateCode = o.StateAbbreviationCode, StateName = o.StateAbbreviationDescription, LeaName = o.LeaName })
                    .Distinct().OrderBy(o => o.LeaName);

                foreach (var item in leas)
                {
                    dynamic dataRow = new ExpandoObject();

                    dataRow.StateCode = item.StateCode;
                    dataRow.StateName = item.StateName;
                    //dataRow.rowId = item.LeaOrganizationId;
                    dataRow.rowKey = item.LeaName;


                    dataRows.Add(dataRow);
                }
            }
            else if (reportLevel == "sch")
            {
                var schools = organizations
                    .Where(o => o.DimK12SchoolId != -1)
                    .OrderBy(o => o.NameOfInstitution);

                foreach (var item in schools)
                {
                    dynamic dataRow = new ExpandoObject();

                    dataRow.StateCode = item.StateAbbreviationCode;
                    dataRow.StateName = item.StateAbbreviationDescription;
                    //dataRow.rowId = item.SchoolOrganizationId;
                    dataRow.rowKey = item.NameOfInstitution;



                    dataRows.Add(dataRow);
                }
            }

            return dataRows;

        }

    }
}
