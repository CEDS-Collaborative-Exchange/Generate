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


            if (reportCode == "studentsex" && queryStudentCountReportDto != null)
            {
                var sexColumns = new Dictionary<string, string>
                                    {
                                        { "Female", "Female" },
                                        { "Male", "Male" },
                                        { "NotSelected", "Not Selected" },
                                        { "MISSING", "Missing" },
                                        { "Total", "Total" }
                                    };

                reportDto.structure.columnHeaders = sexColumns.Values.ToList();

                var groupedData = GroupStudentSexData(queryStudentCountReportDto);
                dataRows = BuildDataRows(groupedData, sexColumns);

                reportDto.data.AddRange(dataRows);
            }
            else if (reportCode == "studentrace" && queryStudentCountReportDto != null)
            {
                var raceColumns = new Dictionary<string, string>
                                        {
                                            { "AM", "American Indian or Alaska Native" },
                                            { "AS", "Asian" },
                                            { "BL", "Black or African American" },
                                            { "HI", "Hispanic" },
                                            { "PI", "Native Hawaiian or Other Pacific Islander" },
                                            { "WH", "White" },
                                            { "MU", "Demographic Race Two or More Races" },
                                            { "MISSING", "Missing" },
                                            { "Total", "Total" }
                                        };

                reportDto.structure.columnHeaders = raceColumns.Values.ToList();

                var groupedData = GroupStudentRaceData(queryStudentCountReportDto);
                dataRows = BuildDataRows(groupedData, raceColumns);

                reportDto.data.AddRange(dataRows);
            }
            else if (reportCode == "studentsubpopulation" && queryStudentCountReportDto != null)
            {
                var columns = new Dictionary<string, string>
                                    {
                                        { "ECODIS", "Economic Disadvantage Status" },
                                        { "HOMELSSTATUS", "Homeless Status" },
                                        { "LEP", Convert.ToInt32(reportYear[..4]) >= 2017 ? "English Learner Status" : "Limited English Proficiency Status" },
                                        { "MIGRNTSTATUS", "Migrant Status" },
                                        { "Total", "Total" }
                                    };

                reportDto.structure.columnHeaders = columns.Values.ToList();

                var groupedData = GroupStudentSubpopData(queryStudentCountReportDto);
                dataRows = BuildDataRows(groupedData, columns);

                reportDto.data.AddRange(dataRows);
            }
            else if (reportCode == "studentdisability" && queryStudentCountReportDto != null)
            {
                var columns = new Dictionary<string, string>
                                    {
                                        { "AUT", "AUT" },
                                        { "DB", "DB" },
                                        { "DD", "DD" },
                                        { "EMN", "EMN" },
                                        { "HI", "HI" },
                                        { "ID", "ID" },
                                        { "MD", "MD" },
                                        { "OHI", "OHI" },
                                        { "OI", "OI" },
                                        { "SLD", "SLD" },
                                        { "SLI", "SLI" },
                                        { "TBI", "TBI" },
                                        { "VI", "VI" },
                                        { "Missing", "Missing" },
                                        { "Total", "Total" }
                                    };

                reportDto.structure.columnHeaders = columns.Values.ToList();

                var groupedData = GroupStudentDisabilityData(queryStudentCountReportDto);
                dataRows = BuildDataRows(groupedData, columns);

                reportDto.data.AddRange(dataRows);
            }
            else if (reportCode == "studentdiscipline" && queryStudentDisciplineReportDto != null)
            {
                var columns = new Dictionary<string, string>
                                    {
                                        { "03086", "Expulsion with services" },
                                        { "03087", "Expulsion without services" },
                                        { "03100", "Suspension, in-school" },
                                        { "03154", "Suspension, out-of-school, greater than 10 consecutive school days" },
                                        { "03155", "Suspension, out-of-school, separate days cumulating to more than 10 school days" },
                                        { "03101", "Suspension, out-of-school, with services" },
                                        { "03102", "Suspension, out-of-school, without services" },
                                        { "Missing", "Missing" },
                                        { "Total", "Total" }
                                    };

                reportDto.structure.columnHeaders = columns.Values.ToList();

                var groupedData = GroupStudentDisciplineData(queryStudentDisciplineReportDto, columns.Keys.ToList());
                dataRows = BuildDataRows(groupedData, columns);

                reportDto.data.AddRange(dataRows);
            }
            else if (reportCode == "studentcount")
            {
                var columns = new Dictionary<string, string>
                                        {
                                            { "StudentCount", "Student Count" }
                                        };

                reportDto.structure.columnHeaders = columns.Values.ToList();

                var groupedData = queryStudentCountReportDto
                    .GroupBy(c => new
                    {
                        c.StateAbbreviationCode,
                        c.StateAbbreviationDescription,
                        c.OrganizationName
                    })
                    .Select(g => new
                    {
                        StateCode = g.Key.StateAbbreviationCode,
                        StateName = g.Key.StateAbbreviationDescription,
                        OrganizationName = g.Key.OrganizationName,
                        StudentCount = g.Sum(c => c.StudentCount)
                    });

                foreach (var item in groupedData)
                {
                    dynamic row = new ExpandoObject();
                    row.stateCode = item.StateCode;
                    row.stateName = item.StateName;
                    row.rowKey = item.OrganizationName;
                    row.col_1 = item.StudentCount;

                    dataRows.Add(row);
                }

                reportDto.data.AddRange(dataRows);
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

        private IEnumerable<dynamic> GroupStudentSexData(IEnumerable<ReportEDFactsK12StudentCount> data)
        {
            return data
                .GroupBy(c => new
                {
                    c.StateAbbreviationCode,
                    c.StateAbbreviationDescription,
                    c.OrganizationName
                })
                .Select(g => new
                {
                    StateCode = g.Key.StateAbbreviationCode,
                    StateName = g.Key.StateAbbreviationDescription,
                    OrganizationName = g.Key.OrganizationName,
                    Female = g.Where(c => c.SEX == "Female").Sum(c => (int?)c.StudentCount) ?? 0,
                    Male = g.Where(c => c.SEX == "Male").Sum(c => (int?)c.StudentCount) ?? 0,
                    NotSelected = g.Where(c => c.SEX == "NotSelected").Sum(c => (int?)c.StudentCount) ?? 0,
                    MISSING = g.Where(c => c.SEX == "MISSING").Sum(c => (int?)c.StudentCount) ?? 0,
                    Total = g.Sum(c => c.StudentCount)
                });
        }

        private IEnumerable<dynamic> GroupStudentRaceData(IEnumerable<ReportEDFactsK12StudentCount> data)
        {
            return data
                .GroupBy(c => new
                {
                    c.StateAbbreviationCode,
                    c.StateAbbreviationDescription,
                    c.OrganizationName
                })
                .Select(g => new
                {
                    StateCode = g.Key.StateAbbreviationCode,
                    StateName = g.Key.StateAbbreviationDescription,
                    OrganizationName = g.Key.OrganizationName,
                    AM = g.Where(c => c.RACE == "AmericanIndianorAlaskaNative").Sum(c => (int?)c.StudentCount) ?? 0,
                    AS = g.Where(c => c.RACE == "Asian").Sum(c => (int?)c.StudentCount) ?? 0,
                    BL = g.Where(c => c.RACE == "BlackorAfricanAmerican").Sum(c => (int?)c.StudentCount) ?? 0,
                    HI = g.Where(c => c.RACE == "HI").Sum(c => (int?)c.StudentCount) ?? 0,
                    PI = g.Where(c => c.RACE == "NativeHawaiianorOtherPacificIslander").Sum(c => (int?)c.StudentCount) ?? 0,
                    WH = g.Where(c => c.RACE == "White").Sum(c => (int?)c.StudentCount) ?? 0,
                    MU = g.Where(c => c.RACE == "TwoorMoreRaces").Sum(c => (int?)c.StudentCount) ?? 0,
                    MISSING = g.Where(c => c.RACE == "MISSING").Sum(c => (int?)c.StudentCount) ?? 0,
                    Total = g.Sum(c => c.StudentCount)
                });
        }

        private IEnumerable<dynamic> GroupStudentSubpopData(IEnumerable<ReportEDFactsK12StudentCount> data)
        {
            return data
                .GroupBy(c => new
                {
                    c.StateAbbreviationCode,
                    c.StateAbbreviationDescription,
                    c.OrganizationName
                })
                .Select(g => new
                {
                    StateCode = g.Key.StateAbbreviationCode,
                    StateName = g.Key.StateAbbreviationDescription,
                    OrganizationName = g.Key.OrganizationName,
                    ECODIS = g.Where(c => c.ECONOMICDISADVANTAGESTATUS == "EconomicDisadvantage").Sum(c => (int?)c.StudentCount) ?? 0,
                    HOMELSSTATUS = g.Where(c => c.HOMELESSNESSSTATUS == "HomelessUnaccompaniedYouth").Sum(c => (int?)c.StudentCount) ?? 0,
                    LEP = g.Where(c => c.ENGLISHLEARNERSTATUS == "LEP").Sum(c => (int?)c.StudentCount) ?? 0,
                    MIGRNTSTATUS = g.Where(c => c.MIGRANTSTATUS == "Migrant").Sum(c => (int?)c.StudentCount) ?? 0,
                    Total = g.Sum(c => (int?)c.StudentCount) ?? 0
                });
        }

        private IEnumerable<dynamic> GroupStudentDisabilityData(IEnumerable<ReportEDFactsK12StudentCount> data)
        {
            return data
                .GroupBy(c => new
                {
                    c.StateAbbreviationCode,
                    c.StateAbbreviationDescription,
                    c.OrganizationName
                })
                .Select(g => new
                {
                    StateCode = g.Key.StateAbbreviationCode,
                    StateName = g.Key.StateAbbreviationDescription,
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
                    Total = g.Sum(c => (int?)c.StudentCount) ?? 0
                });
        }

        private IEnumerable<dynamic> GroupStudentDisciplineData(IEnumerable<ReportEDFactsK12StudentDiscipline> data, List<string> disciplineCodes)
        {
            return data
                .GroupBy(c => new
                {
                    c.StateAbbreviationCode,
                    c.StateAbbreviationDescription,
                    c.OrganizationName
                })
                .Select(g =>
                {
                    dynamic result = new ExpandoObject();
                    var dict = (IDictionary<string, object>)result;

                    dict["StateCode"] = g.Key.StateAbbreviationCode;
                    dict["StateName"] = g.Key.StateAbbreviationDescription;
                    dict["OrganizationName"] = g.Key.OrganizationName;

                    foreach (var code in disciplineCodes)
                    {
                        if (code == "Missing")
                        {
                            dict[code] = g.Where(c => c.DISCIPLINARYACTIONTAKEN == "MISSING")
                                          .Sum(c => (c.DisciplineCount > 0) ? 1 : 0);
                        }
                        else if (code == "Total")
                        {
                            dict[code] = g.Sum(c => (c.DisciplineCount > 0) ? 1 : 0);
                        }
                        else
                        {
                            dict[$"d{code}"] = g.Where(c => c.DISCIPLINARYACTIONTAKEN == code)
                                                .Sum(c => (c.DisciplineCount > 0) ? 1 : 0);
                        }
                    }

                    return result;
                });
        }


        private IEnumerable<ExpandoObject> BuildDataRows(IEnumerable<dynamic> groupedData, Dictionary<string, string> columnMappings)
        {
            foreach (var item in groupedData)
            {
                dynamic row = new ExpandoObject();
                var dict = (IDictionary<string, object>)row;

                dict["stateCode"] = item.StateCode;
                dict["stateName"] = item.StateName;
                dict["rowKey"] = item.OrganizationName;

                int colIndex = 1;
                foreach (var key in columnMappings.Keys)
                {
                    object value;

                    if (key == "Total" || key == "Missing")
                        value = ((IDictionary<string, object>)item)[key];
                    else
                        value = ((IDictionary<string, object>)item)[$"d{key}"];

                    dict[$"col_{colIndex++}"] = value ?? 0;
                }

                yield return row;
            }
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
