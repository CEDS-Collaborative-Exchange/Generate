using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using generate.core.Models.App;

namespace generate.core.Helpers.ReferenceData
{
    public class FactTableHelper
    {
        public static List<FactTable> GetData()
        {

            /*
            select 'data.Add(new FactTable() { 
            FactTableId = ' + convert(varchar(20), FactTableId) + ',
            FactTableName = "' + isnull(FactTableName, '') + '",
            FactTableIdName = "' + isnull(FactTableIdName, '') + '",
            FactReportTableName = "' + isnull(FactReportTableName, '') + '",
            FactReportTableIdName = "' + isnull(FactReportTableIdName, '') + '",
            FactReportDtoName = "' + isnull(FactReportDtoName, '') + '",
            FactReportDtoIdName = "' + isnull(FactReportDtoIdName, '') + '"
            });'
            from App.FactTables

            */

            var data = new List<FactTable>();


            data.Add(new FactTable() { FactTableId = 1, FactTableName = "FactStudentCounts", FactTableIdName = "FactStudentCountId", FactReportTableName = "FactStudentCountReports", FactReportTableIdName = "FactStudentCountReportId", FactReportDtoName = "FactStudentCountReportDto", FactReportDtoIdName = "FactStudentCountReportDtoId" });
            data.Add(new FactTable() { FactTableId = 2, FactTableName = "FactStudentDisciplines", FactTableIdName = "FactStudentDisciplineId", FactReportTableName = "FactStudentDisciplineReports", FactReportTableIdName = "FactStudentDisciplineReportId", FactReportDtoName = "FactStudentDisciplineReportDto", FactReportDtoIdName = "FactStudentDisciplineReportDtoId" });
            data.Add(new FactTable() { FactTableId = 3, FactTableName = "FactStudentAssessments", FactTableIdName = "FactStudentAssessmentId", FactReportTableName = "FactStudentAssessmentReports", FactReportTableIdName = "FactStudentAssessmentReportId", FactReportDtoName = "FactStudentAssessmentReportDto", FactReportDtoIdName = "FactStudentAssessmentReportDtoId" });
            data.Add(new FactTable() { FactTableId = 4, FactTableName = "FactPersonnelCounts", FactTableIdName = "FactPersonnelCountId", FactReportTableName = "FactPersonnelCountReports", FactReportTableIdName = "FactPersonnelCountReportId", FactReportDtoName = "FactPersonnelCountReportDto", FactReportDtoIdName = "FactPersonnelCountReportDtoId" });
            data.Add(new FactTable() { FactTableId = 5, FactTableName = "FactCustomCounts", FactTableIdName = "FactCustomCountId", FactReportTableName = "", FactReportTableIdName = "", FactReportDtoName = "", FactReportDtoIdName = "" });
            data.Add(new FactTable() { FactTableId = 6, FactTableName = "FactOrganizationCounts", FactTableIdName = "FactOrganizationCountId", FactReportTableName = "FactOrganizationCountReports", FactReportTableIdName = "FactOrganizationCountReportId", FactReportDtoName = "FactOrganizationCountReportDto", FactReportDtoIdName = "FactOrganizationCountReportDtoId" });
            data.Add(new FactTable() { FactTableId = 7, FactTableName = "FactOrganizationStatusCounts", FactTableIdName = "FactOrganizationStatusCountId", FactReportTableName = "FactOrganizationStatusCountReports", FactReportTableIdName = "FactOrganizationStatusCountReportId", FactReportDtoName = "FactOrganizationStatusCountReportDto", FactReportDtoIdName = "FactOrganizationStatusCountReportDtoId" });

            return data;

        }
    }
}
 