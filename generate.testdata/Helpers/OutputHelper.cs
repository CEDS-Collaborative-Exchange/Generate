using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO.Abstractions;
using System.IO;
using generate.testdata.Interfaces;
using System.Reflection;

namespace generate.testdata.Helpers
{
    public class OutputHelper : IOutputHelper
    {
        private readonly IFileSystem _fileSystem;

        // <summary>Create with the given fileSystem implementation</summary>
        public OutputHelper(IFileSystem fileSystem)
        {
            _fileSystem = fileSystem;
        }
        /// <summary>Create</summary>
        public OutputHelper() : this(
            fileSystem: new FileSystem() //use default implementation which calls System.IO
        )
        {
        }

        public void DeleteExistingFiles(string testDataType, string filePath = ".")
        {
            if (filePath == "")
            {
                filePath = ".";
            }

            var allScripts = _fileSystem.Directory.GetFiles(filePath, testDataType + "TestData*.*", System.IO.SearchOption.TopDirectoryOnly);

            // Delete
            if (allScripts.Any())
            {
                foreach (var sqlScriptFile in allScripts)
                {
                    _fileSystem.File.Delete(sqlScriptFile);
                }
            }
        }

        public void WriteOutput(StringBuilder output, string testDataType, string formatType, string outputType, string filePath, string sectionName = null)
        {

            if (output == null)
            {
                output = new StringBuilder();
            }

            string fileExtension = "txt";

            switch (formatType)
            {
                case "sql":
                    fileExtension = "sql";
                    break;

                case "json":
                    fileExtension = "json";
                    break;

                case "c#":
                    fileExtension = "cs";
                    break;

                case "powershell":
                    fileExtension = "ps1";
                    break;

                default:
                    break;
            }


            var convertedTestDataType = testDataType.Substring(0, 1).ToUpper() + testDataType.Substring(1);

            string fileName = convertedTestDataType + "TestData";

            if (formatType == "c#")
            {
                fileName = convertedTestDataType + "TestDataHelper";
            }

            if (sectionName != null)
            {
                fileName += "_" + sectionName;
            }

            fileName += "." + fileExtension;

            if (filePath != "" && filePath != null)
            {
                fileName = _fileSystem.Path.Combine(filePath, fileName);
            }


            switch (outputType)
            {
                case "console":
                    Console.WriteLine(output.ToString());
                    break;

                case "file":

                    if (_fileSystem.File.Exists(fileName))
                    {
                        _fileSystem.File.Delete(fileName);
                    }

                    using (StreamWriter sw = _fileSystem.File.AppendText(fileName))
                    {
                        sw.WriteLine(output.ToString());
                    }

                    break;

                default:
                    Console.WriteLine(output.ToString());
                    break;
            }

        }

        public StringBuilder AppendOutputIfNotEmpty(StringBuilder output, string textToAdd)
        {
            if (textToAdd != null && textToAdd.Trim() != "")
            {
                output.AppendLine(textToAdd);
            }
            return output;
        }

        public string GetTestDataValuesSql(object[] collection, Type objectType, string collectionName, string schema, bool usesIdentity)
        {
            if (collection == null || collection.Length == 0)
            {
                return null;
            }

            StringBuilder output = new StringBuilder();

            output.AppendLine("-- " + collectionName);
            output.AppendLine();

            if (usesIdentity)
            {
                output.AppendLine("set identity_insert " + schema + "." + collectionName + " on");
                output.AppendLine();
            }

            for (int i = 0; i < collection.Length; i++)
            {
                var obj = collection[i];

                output.AppendLine("insert into " + schema + "." + collectionName);
                output.AppendLine(GetPropertyOutputSqlFields(objectType));
                output.AppendLine("values");
                output.AppendLine(this.GetPropertyOutputSqlValues(obj, objectType));
                output.AppendLine();
            }

            if (usesIdentity)
            {
                output.AppendLine("set identity_insert " + schema + "." + collectionName + " off");
            }
            return output.ToString();
        }

        public string GetPropertyOutputSqlFields(Type type)
        {

            StringBuilder output = new StringBuilder();

            PropertyInfo[] properties = type.GetProperties().Where(p => p.Name.ToLower() != "id").ToArray();

            output.Append("(");

            for (int j = 0; j < properties.Length; j++)
            {

                PropertyInfo property = properties[j];

                var propertyComma = "";

                if (j != 0 && j < properties.Length)
                {
                    propertyComma = ",";
                }

                var propertyName = property.Name;

                // TODO: Get this information from Model instead using HasColumnName property

                if (propertyName == "ParentOrganizationId")
                {
                    propertyName = "Parent_OrganizationId";
                }

                if (!property.PropertyType.ToString().Contains("System.Collections") && !property.PropertyType.ToString().Contains("generate.core"))
                {
                    output.Append(propertyComma + propertyName);
                }
            }

            output.Append(")");

            return output.ToString();

        }

        public string GetPropertyOutputSqlValues(object obj, Type type)
        {

            StringBuilder output = new StringBuilder();

            PropertyInfo[] properties = type.GetProperties().Where(p => p.Name.ToLower() != "id").ToArray();

            output.Append("(");

            for (int j = 0; j < properties.Length; j++)
            {

                PropertyInfo property = properties[j];

                var propertyComma = "";

                if (j != 0 && j < properties.Length)
                {
                    propertyComma = ",";
                }


                var propertyValue = property.GetValue(obj);

                if (propertyValue == null)
                {
                    propertyValue = "null";
                }
                else if (property.PropertyType == typeof(string))
                {
                    string propertyValueString = (string)propertyValue;

                    if (propertyValueString != null)
                    {
                        propertyValueString.Replace("'", "''");
                    }

                    propertyValue = "'" + propertyValueString + "'";
                }
                else if (property.PropertyType == typeof(bool) || property.PropertyType == typeof(bool?))
                {
                    if ((bool)propertyValue)
                    {
                        propertyValue = "1";
                    }
                    else
                    {
                        propertyValue = "0";
                    }
                }
                else if (property.PropertyType == typeof(DateTime) || property.PropertyType == typeof(DateTime?))
                {
                    DateTime dateTimeProperty = (DateTime)propertyValue;
                    propertyValue = "'" + dateTimeProperty.Month + "/" + dateTimeProperty.Day + "/" + dateTimeProperty.Year + "'";
                }

                if (!property.PropertyType.ToString().Contains("System.Collections") && !property.PropertyType.ToString().Contains("generate.core"))
                {
                    output.Append(propertyComma + propertyValue);
                }

            }

            output.Append(")");

            return output.ToString();

        }

        public string GetTestDataValuesCSharp(object[] collection, Type objectType, string collectionName, string commaText)
        {
            StringBuilder output = new StringBuilder();

            if (collection == null || collection.Length == 0)
            {
                return null;
            }

            output.AppendLine("             " + collectionName + " = new List<" + objectType.ToString() + "> ()");
            output.AppendLine("             {");
            for (int i = 0; i < collection.Length; i++)
            {
                var obj = collection[i];
                var schoolComma = "";
                if (i < collection.Length - 1)
                {
                    schoolComma = ",";
                }
                output.AppendLine("                 new " + objectType.ToString() + "()");
                output.AppendLine("                 {");
                output.AppendLine(this.GetPropertyOutputCSharp(obj, objectType));
                output.AppendLine("                 }" + schoolComma);
            }
            output.AppendLine("             }" + commaText);

            return output.ToString();
        }

        public string GetPropertyOutputCSharp(object obj, Type type)
        {

            StringBuilder output = new StringBuilder();

            PropertyInfo[] properties = type.GetProperties();

            for (int j = 0; j < properties.Length; j++)
            {

                PropertyInfo property = properties[j];



                var propertyComma = "";

                if (j < properties.Length - 1)
                {
                    propertyComma = ",";
                }


                var propertyValue = property.GetValue(obj);

                if (propertyValue == null)
                {
                    propertyValue = "null";
                }
                else if (property.PropertyType == typeof(string))
                {
                    propertyValue = "\"" + propertyValue + "\"";
                }
                else if (property.PropertyType == typeof(bool) || property.PropertyType == typeof(bool?))
                {
                    if ((bool)propertyValue)
                    {
                        propertyValue = "true";
                    }
                    else
                    {
                        propertyValue = "false";
                    }
                }
                else if (property.PropertyType == typeof(decimal) || property.PropertyType == typeof(decimal?))
                {
                    propertyValue = propertyValue + "M";
                }
                else if (property.PropertyType == typeof(DateTime) || property.PropertyType == typeof(DateTime?))
                {
                    var dateTimeProperty = (DateTime)propertyValue;
                    propertyValue = "new DateTime(" + dateTimeProperty.Year + ", " + dateTimeProperty.Month + ", " + dateTimeProperty.Day + ")";
                }

                if (!property.PropertyType.ToString().Contains("System.Collections"))
                {
                    output.AppendLine("                     " + property.Name + " = " + propertyValue + propertyComma);
                }
            }

            return output.ToString();

        }

        public StringBuilder CreateStartOutput(string sectionName, int quantity, string formatType, int seed, string testDataType)
        {
            StringBuilder output = new StringBuilder();

            if (formatType == "sql")
            {
                output = this.CreateSqlStartOutput(output, sectionName, quantity, seed, testDataType);
            }
            else if (formatType == "c#")
            {
                output = this.CreateCSharpStartOutput(output, sectionName, quantity, seed, testDataType);
            }
            else
            {
                // Default to JSON
                output.AppendLine("[");
            }

            return output;
        }

        private StringBuilder CreateSqlStartOutput(StringBuilder output, string sectionName, int quantity, int seed, string testDataType)
        {
            output.AppendLine("-- Generate Test Data");
            output.AppendLine("-- " + sectionName);
            output.AppendLine();
            output.AppendLine("-- Parameters --");
            output.AppendLine("-- TestDataType = " + testDataType);
            output.AppendLine("-- Seed = " + seed);
            output.AppendLine("-- Quantity = " + quantity);
            output.AppendLine();

            return output;
        }

        private StringBuilder CreateCSharpStartOutput(StringBuilder output, string sectionName, int quantity, int seed, string testDataType)
        {
            var testDataTypeProper = testDataType.Substring(0, 1).ToUpper() + testDataType.Substring(1);

            output.AppendLine("using System;");
            output.AppendLine("using System.Collections.Generic;");
            output.AppendLine("using System.Linq;");
            output.AppendLine("using System.Text;");
            output.AppendLine("using generate.core.Models." + testDataType.ToUpper() + ";");
            output.AppendLine();
            output.AppendLine("namespace generate.core.Helpers.TestDataHelper.Rds");
            output.AppendLine("{");
            output.AppendLine(" public static partial class " + testDataTypeProper + "TestDataHelper");
            output.AppendLine(" {");
            output.AppendLine("     public static " + testDataTypeProper + "TestDataObject Get" + testDataTypeProper + "TestData_" + sectionName + "()");
            output.AppendLine("     {");
            output.AppendLine("         // SeedValue = " + seed);
            output.AppendLine();
            output.AppendLine("         var testData = new " + testDataTypeProper + "TestDataObject();");
            output.AppendLine();

            return output;
        }

        public StringBuilder AddSqlDeletesToOutput(StringBuilder output, string testDataType)
        {
            if (testDataType == "staging")
            {
                output.AppendLine("-- Delete Staging Data ");
                output.AppendLine();
                output.AppendLine("TRUNCATE TABLE Staging.Assessment");
                output.AppendLine("TRUNCATE TABLE Staging.AssessmentResult");
                output.AppendLine("TRUNCATE TABLE staging.AccessibleEducationMaterialAssignment");
                output.AppendLine("TRUNCATE TABLE staging.AccessibleEducationMaterialProvider");
                //output.AppendLine("TRUNCATE TABLE Staging.CharterSchoolApprovalAgency");
                output.AppendLine("TRUNCATE TABLE Staging.CharterSchoolAuthorizer");
                output.AppendLine("TRUNCATE TABLE Staging.CharterSchoolManagementOrganization");
                output.AppendLine("TRUNCATE TABLE Staging.Disability");
                output.AppendLine("TRUNCATE TABLE Staging.Discipline");
                output.AppendLine("TRUNCATE TABLE Staging.IndicatorStatusCustomType");
                output.AppendLine("TRUNCATE TABLE Staging.IdeaDisabilityType");
                output.AppendLine("TRUNCATE TABLE Staging.K12Enrollment");
                output.AppendLine("TRUNCATE TABLE Staging.K12Organization");
                output.AppendLine("TRUNCATE TABLE Staging.K12SchoolComprehensiveSupportIdentificationType");
                output.AppendLine("TRUNCATE TABLE Staging.K12StaffAssignment");
                output.AppendLine("TRUNCATE TABLE Staging.K12StudentCourseSection");
                output.AppendLine("TRUNCATE TABLE Staging.Migrant");
                output.AppendLine("TRUNCATE TABLE Staging.OrganizationAddress");
                output.AppendLine("TRUNCATE TABLE Staging.OrganizationCalendarSession");
                output.AppendLine("TRUNCATE TABLE Staging.OrganizationCustomSchoolIndicatorStatusType");
                output.AppendLine("TRUNCATE TABLE Staging.OrganizationFederalFunding");
                output.AppendLine("TRUNCATE TABLE Staging.OrganizationGradeOffered");
                output.AppendLine("TRUNCATE TABLE Staging.OrganizationPhone");
                output.AppendLine("TRUNCATE TABLE Staging.OrganizationProgramType");
                output.AppendLine("TRUNCATE TABLE Staging.OrganizationSchoolComprehensiveAndTargetedSupport");
                output.AppendLine("TRUNCATE TABLE Staging.OrganizationSchoolIndicatorStatus");
                output.AppendLine("TRUNCATE TABLE Staging.K12PersonRace");
                output.AppendLine("TRUNCATE TABLE Staging.PersonStatus");
                output.AppendLine("TRUNCATE TABLE Staging.ProgramParticipationCTE");
                output.AppendLine("TRUNCATE TABLE Staging.ProgramParticipationNorD");
                output.AppendLine("TRUNCATE TABLE Staging.ProgramParticipationSpecialEducation");
                output.AppendLine("TRUNCATE TABLE Staging.ProgramParticipationTitleI");
                output.AppendLine("TRUNCATE TABLE Staging.ProgramParticipationTitleIII");
                output.AppendLine("TRUNCATE TABLE Staging.PsInstitution");
                output.AppendLine("TRUNCATE TABLE Staging.PsStudentAcademicAward");
                output.AppendLine("TRUNCATE TABLE Staging.PsStudentAcademicRecord");
                output.AppendLine("TRUNCATE TABLE Staging.PsStudentEnrollment");
                output.AppendLine("TRUNCATE TABLE Staging.StateDefinedCustomIndicator");
                output.AppendLine("TRUNCATE TABLE Staging.StateDetail");
                output.AppendLine("TRUNCATE TABLE Staging.AccessibleEducationMaterialAssignment");
                output.AppendLine("TRUNCATE TABLE Staging.AccessibleEducationMaterialProvider");

                output.AppendLine("truncate table rds.BridgeK12AccessibleEducationMaterialAssignmentIdeaDisabilityTypes");
                output.AppendLine("truncate table rds.BridgeK12AccessibleEducationMaterialRaces");
                output.AppendLine("truncate table rds.BridgeLeaGradeLevels");
                output.AppendLine("truncate table rds.BridgeK12SchoolGradeLevels");
                output.AppendLine("truncate table rds.BridgeK12StudentAssessmentRaces");
                output.AppendLine("truncate table rds.BridgeK12ProgramParticipationRaces");
                output.AppendLine("truncate table rds.BridgeK12StudentCourseSectionK12Staff");
                output.AppendLine("truncate table rds.BridgeK12StudentCourseSectionRaces");
                output.AppendLine("truncate table rds.BridgeK12StudentEnrollmentRaces");
                output.AppendLine("truncate table rds.BridgeK12StudentDisciplineRaces");
                output.AppendLine("truncate table rds.BridgeK12StudentAssessmentAccommodations");
                output.AppendLine("delete from rds.FactK12StaffCounts");
                output.AppendLine("delete from rds.ReportEDFactsK12StudentAssessments");
                output.AppendLine("delete from rds.FactK12StudentAssessments");
                output.AppendLine("delete from rds.FactK12StudentAttendanceRates");
                output.AppendLine("delete from rds.ReportEDFactsK12StudentAttendance");
                output.AppendLine("delete from rds.FactK12StudentCounts");
                output.AppendLine("delete from rds.FactK12StudentDisciplines");
                output.AppendLine("delete from rds.FactK12AccessibleEducationMaterialAssignments");
                output.AppendLine("delete from rds.FactK12StudentEnrollments");
                //output.AppendLine("delete from rds.FactOrganizationCountReports");
                //output.AppendLine("delete from rds.FactOrganizationCounts");
                //output.AppendLine("delete from rds.FactOrganizationStatusCountReports");
                //output.AppendLine("delete from rds.FactOrganizationStatusCounts");
                //output.AppendLine("delete from rds.dimseas");
                //output.AppendLine("delete from rds.dimieus");
                //output.AppendLine("delete from rds.dimleas");
                //output.AppendLine("delete from rds.DimK12Schools");
                //output.AppendLine("delete from rds.DimCharterSchoolManagementOrganizations");
                //output.AppendLine("delete from rds.DimCharterSchoolAuthorizers");
                output.AppendLine("delete from rds.DimPeople");
                //output.AppendLine("delete from rds.DimK12Staff");

                output.AppendLine("DBCC CHECKIDENT('rds.FactK12StaffCounts', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.ReportEDFactsK12StudentAssessments', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.FactK12StudentAssessments', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.FactK12StudentAttendanceRates', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.ReportEDFactsK12StudentAttendance', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.FactK12StudentCounts', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.FactK12StudentDisciplines', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.FactK12AccessibleEducationMaterialAssignments', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.FactK12StudentEnrollments', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.FactOrganizationCountReports', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.FactOrganizationCounts', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.FactOrganizationStatusCountReports', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.FactOrganizationStatusCounts', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.dimseas', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.dimieus', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.dimleas', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.DimK12Schools', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.DimCharterSchoolManagementOrganizations', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.DimCharterSchoolAuthorizers', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.DimPeople', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.DimK12Staff', RESEED, 1);");
            }

            if (testDataType == "ods")
            {
                output.AppendLine("-- Delete IDS Data");
                output.AppendLine();
                output.AppendLine("truncate table dbo.LocationAddress");
                output.AppendLine("truncate table dbo.OrganizationLocation");
                output.AppendLine("delete from dbo.[Location]");
                output.AppendLine("delete from dbo.Incident");
                output.AppendLine("delete from dbo.IncidentPerson");
                output.AppendLine("delete from dbo.K12Sea");
                output.AppendLine("truncate table dbo.K12OrganizationStudentResponsibility");
                output.AppendLine("truncate table dbo.RoleAttendance");
                output.AppendLine("truncate table dbo.AeStaff");
                output.AppendLine("truncate table dbo.ProgramParticipationNeglectedProgressLevel");
                output.AppendLine("delete from dbo.ProgramParticipationAE");
                output.AppendLine("truncate table dbo.ProgramParticipationCte");
                output.AppendLine("delete from dbo.ProgramParticipationFoodService");
                output.AppendLine("truncate table dbo.ProgramParticipationMigrant");
                output.AppendLine("truncate table dbo.ProgramParticipationNeglected");
                output.AppendLine("truncate table dbo.ProgramParticipationSpecialEducation");
                output.AppendLine("delete from dbo.ProgramParticipationTeacherPrep");
                output.AppendLine("delete from dbo.ProgramParticipationTitleI");
                output.AppendLine("truncate table dbo.ProgramParticipationTitleIIILep");
                output.AppendLine("truncate table dbo.WorkforceEmploymentQuarterlyData");
                output.AppendLine("truncate table dbo.WorkforceProgramParticipation");
                output.AppendLine("delete from dbo.PersonProgramParticipation");
                output.AppendLine("delete from dbo.StaffEmployment");
                output.AppendLine("truncate table dbo.K12StudentCohort");
                output.AppendLine("truncate table dbo.K12organizationStudentResponsibility");
                output.AppendLine("delete from dbo.K12StudentAcademicRecord");
                output.AppendLine("delete from dbo.OrganizationPersonRoleRelationship");
                output.AppendLine("delete from dbo.OrganizationPersonRole");
                output.AppendLine("truncate table dbo.PersonEmailAddress");
                output.AppendLine("delete from dbo.PersonAddress");
                output.AppendLine("truncate table dbo.PersonDemographicRace");
                output.AppendLine("truncate table dbo.PersonTelephone");
                output.AppendLine("truncate table dbo.PersonDisability");
                output.AppendLine("truncate table dbo.PersonHomelessness");
                output.AppendLine("truncate table dbo.PersonIdentifier");
                output.AppendLine("truncate table dbo.PersonLanguage");
                output.AppendLine("truncate table dbo.PersonStatus");
                output.AppendLine("delete from dbo.AssessmentResult_PerformanceLevel");
                output.AppendLine("delete from dbo.AssessmentResult");
                output.AppendLine("delete from dbo.AssessmentRegistration");
                output.AppendLine("truncate table dbo.StaffCredential");
                output.AppendLine("delete from dbo.PersonCredential");
                output.AppendLine("truncate table dbo.PersonDetail");
                output.AppendLine("delete from dbo.Person");
                output.AppendLine("truncate table dbo.K12LeaTitleISupportService");
                output.AppendLine("delete from dbo.AssessmentAdministration_Organization");
                output.AppendLine("delete from dbo.AssessmentAdministration");
                output.AppendLine("delete from dbo.AssessmentPerformanceLevel");
                output.AppendLine("delete from dbo.AssessmentSubtest");
                output.AppendLine("delete from dbo.AssessmentForm");
                output.AppendLine("delete from dbo.Assessment");
                output.AppendLine("truncate table dbo.K12SchoolStatus");
                output.AppendLine("truncate table dbo.K12SchoolImprovement");
                output.AppendLine("truncate table dbo.K12SchoolGradeOffered");
                output.AppendLine("truncate table dbo.K12SchoolIndicatorStatus");
                output.AppendLine("delete from dbo.K12School");
                output.AppendLine("delete from dbo.K12Lea");
                output.AppendLine("delete from dbo.K12CharterSchoolManagementOrganization");
                output.AppendLine("delete from dbo.K12CharterSchoolAuthorizer");
                output.AppendLine("truncate table dbo.OrganizationFederalAccountability");
                output.AppendLine("truncate table dbo.OrganizationOperationalStatus");
                output.AppendLine("truncate table dbo.OrganizationProgramType");
                output.AppendLine("truncate table dbo.OrganizationIndicator");
                output.AppendLine("truncate table dbo.K12ProgramOrService");
                output.AppendLine("truncate table dbo.K12TitleIIILanguageInstruction");
                output.AppendLine("truncate table dbo.K12FederalFundAllocation");
                output.AppendLine("truncate table dbo.K12LeaFederalFunds");
                output.AppendLine("delete from dbo.K12SeaFederalFunds");
                output.AppendLine("delete from dbo.OrganizationFinancial");
                output.AppendLine("delete from dbo.FinancialAccount");
                output.AppendLine("delete from dbo.OrganizationAccreditation");
                output.AppendLine("delete from dbo.OrganizationCalendarSession");
                output.AppendLine("delete from dbo.OrganizationCalendar");
                output.AppendLine("truncate table dbo.OrganizationEmail");
                output.AppendLine("truncate table dbo.OrganizationIdentifier");
                output.AppendLine("truncate table dbo.OrganizationRelationship");
                output.AppendLine("truncate table dbo.OrganizationTelephone");
                output.AppendLine("truncate table dbo.OrganizationWebsite");
                output.AppendLine("truncate table dbo.OrganizationDetail");
                output.AppendLine("delete from dbo.[Role]");
                output.AppendLine("delete from dbo.Organization");
                output.AppendLine("delete from dbo.RefIndicatorStatusCustomType");
                output.AppendLine();
                //output.AppendLine("-- Delete RDS Data");
                //output.AppendLine();
                //output.AppendLine("--Facts");
                //output.AppendLine("truncate table rds.ReportEDFactsK12StudentCounts");
                //output.AppendLine("truncate table rds.FactK12StudentCounts");

                //output.AppendLine("truncate table rds.ReportEDFactsK12StudentDisciplines");
                //output.AppendLine("truncate table rds.FactK12StudentDisciplines");

                //output.AppendLine("truncate table rds.FactK12StudentAssessmentReports");
                //output.AppendLine("truncate table rds.BridgeK12AssessmentRaces");
                //output.AppendLine("truncate table rds.FactK12StudentAssessments");

                //output.AppendLine("truncate table rds.ReportEDFactsK12StaffCounts");
                //output.AppendLine("truncate table rds.FactK12StaffCounts");

                //output.AppendLine("truncate table rds.FactK12StudentAttendance");
                //output.AppendLine("truncate table rds.FactK12StudentAttendanceReports");

                //output.AppendLine("truncate table rds.FactOrganizationCounts");
                //output.AppendLine("truncate table rds.FactOrganizationCountReports");

                //output.AppendLine("truncate table rds.FactOrganizationStatusCounts");
                //output.AppendLine("truncate table rds.FactOrganizationStatusCountReports");

                //output.AppendLine("-- Bridge Tables");

                //output.AppendLine("truncate table rds.[BridgeLeaGradeLevels]");
                //output.AppendLine("truncate table rds.[BridgeSchoolGradeLevels]");

                //output.AppendLine("-- Dimensions");

                //output.AppendLine("delete from rds.DimK12Schools");
                //output.AppendLine("delete from rds.DimK12Students");
                //output.AppendLine("delete from rds.DimK12Staff");
                //output.AppendLine("delete from rds.DimSeas");
                //output.AppendLine("delete from rds.DimLeas");
                //output.AppendLine("delete from rds.DimCharterSchoolAuthorizers where DimCharterSchoolAuthorizerId <> -1");
                //output.AppendLine("delete from rds.DimCharterSchoolManagementOrganizations where DimCharterSchoolManagementOrganizationId <> -1");

            }

            if (testDataType == "rds")
            {
                output.AppendLine("--Facts");
                //output.AppendLine("truncate table rds.ReportEDFactsK12StudentCounts");
                output.AppendLine("truncate table rds.FactK12StudentCounts");

                //output.AppendLine("truncate table rds.ReportEDFactsK12StudentDisciplines");
                output.AppendLine("truncate table rds.FactK12StudentDisciplines");

                //output.AppendLine("truncate table rds.FactK12StudentAssessmentReports");
                output.AppendLine("delete from rds.FactK12StudentAssessments");

                //output.AppendLine("truncate table rds.ReportEDFactsK12StaffCounts");
                output.AppendLine("truncate table rds.FactK12StaffCounts");

                output.AppendLine("truncate table rds.FactK12StudentAttendance");
                //output.AppendLine("truncate table rds.FactK12StudentAttendanceReports");

                output.AppendLine("truncate table rds.FactOrganizationCounts");
                //output.AppendLine("truncate table rds.FactOrganizationCountReports");

                output.AppendLine("truncate table rds.FactOrganizationStatusCounts");
                //output.AppendLine("truncate table rds.FactOrganizationStatusCountReports");

                output.AppendLine("-- Bridge Tables");

                output.AppendLine("truncate table rds.[BridgeLeaGradeLevels]");
                output.AppendLine("truncate table rds.[BridgeK12SchoolGradeLevels]");


                output.AppendLine("-- Dimensions");

                output.AppendLine("delete from rds.DimK12Schools");
                output.AppendLine("delete from rds.DimK12Students");
                output.AppendLine("delete from rds.DimK12Staff");
                output.AppendLine("delete from rds.DimSeas");
                output.AppendLine("delete from rds.DimLeas");
                output.AppendLine("delete from rds.DimCharterSchoolAuthorizers where DimCharterSchoolAuthorizerId <> -1");
                output.AppendLine("delete from rds.DimCharterSchoolManagementOrganizations where DimCharterSchoolManagementOrganizationId <> -1");

                //output.AppendLine("DBCC CHECKIDENT('rds.ReportEDFactsK12StudentCounts', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.FactK12StudentCounts', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.ReportEDFactsK12StudentDisciplines', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.FactK12StudentAssessmentReports', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.FactK12StudentAssessments', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.ReportEDFactsK12StaffCounts', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.FactK12StaffCounts', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.FactK12StudentAttendance', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.FactK12StudentAttendanceReports', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.FactOrganizationCounts', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.FactK12StudentAttendanceReports', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.FactOrganizationStatusCounts', RESEED, 1);");
                //output.AppendLine("DBCC CHECKIDENT('rds.FactOrganizationStatusCountReports', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.BridgeLeaGradeLevels', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.BridgeK12SchoolGradeLevels', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.DimK12Schools', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.DimK12Students', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.DimK12Staff', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.DimSeas', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.DimLeas', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.DimCharterSchoolAuthorizers', RESEED, 1);");
                output.AppendLine("DBCC CHECKIDENT('rds.DimCharterSchoolManagementOrganizations', RESEED, 1);");


                output.AppendLine();
            }

            return output;
        }

        public StringBuilder AddRepopulationOfSourceSystemReferenceData(StringBuilder output, string testDataType, int schoolYear, Boolean isStartingSY)
        {
            
            if (isStartingSY)
            {
                output.AppendLine("-- Repopulate Staging.SourceSystemReferenceData");
                output.AppendLine("");
                output.AppendLine("TRUNCATE TABLE Staging.SourceSystemReferenceData");
                output.AppendLine("");
            }
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefK12StaffClassification', NULL, Code, Code FROM RefK12StaffClassification"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefParaprofessionalQualification', NULL, Code, Code FROM RefParaprofessionalQualification"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefSpecialEducationStaffCategory', NULL, Code, Code FROM RefSpecialEducationStaffCategory"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefSpecialEducationAgeGroupTaught', NULL, Code, Code FROM RefSpecialEducationAgeGroupTaught"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefTitleIProgramStaffCategory', NULL, Code, Code FROM RefTitleIProgramStaffCategory"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefCredentialType', NULL, Code, Code FROM RefCredentialType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefHighSchoolDiplomaType', NULL, Code, Code FROM RefHighSchoolDiplomaType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefAcademicSubject', NULL, Code, Code FROM RefAcademicSubject"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefAssessmentPurpose', NULL, Code, Code FROM RefAssessmentPurpose"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefAssessmentType', NULL, Code, Code FROM RefAssessmentType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ", 'RefAssessmentParticipationIndicator', NULL, '1', 'Participated'), (", schoolYear, ", 'RefAssessmentParticipationIndicator', NULL, '0', 'DidNotParticipate')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefGradeLevel', '000100', gl.Code, gl.Code FROM RefGradeLevel gl JOIN RefGradeLevelType glt on gl.RefGradeLevelTypeId = glt.RefGradeLevelTypeId WHERE glt.Code = '000100'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefGradeLevel', '000126', gl.Code, gl.Code FROM RefGradeLevel gl JOIN RefGradeLevelType glt on gl.RefGradeLevelTypeId = glt.RefGradeLevelTypeId WHERE glt.Code = '000126'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefGradeLevel', '000131', gl.Code, gl.Code FROM RefGradeLevel gl JOIN RefGradeLevelType glt on gl.RefGradeLevelTypeId = glt.RefGradeLevelTypeId WHERE glt.Code = '000131'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefGradeLevel', '001210', gl.Code, gl.Code FROM RefGradeLevel gl JOIN RefGradeLevelType glt on gl.RefGradeLevelTypeId = glt.RefGradeLevelTypeId WHERE glt.Code = '001210'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefAssessmentReasonNotCompleting', NULL, Code, Code FROM RefAssessmentReasonNotCompleting"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefAssessmentReasonNotTested', NULL, Code, Code FROM RefAssessmentReasonNotTested"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefFirearmType', NULL, Code, Code FROM RefFirearmType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefDisciplineReason', NULL, Code, Code FROM RefDisciplineReason"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefDisciplinaryActionTaken', NULL, Code, Code FROM RefDisciplinaryActionTaken"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefIdeaInterimRemoval', NULL, Code, Code FROM RefIdeaInterimRemoval"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefIDEAInterimRemovalReason', NULL, Code, Code FROM RefIDEAInterimRemovalReason"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefDisciplineMethodOfCwd', NULL, Code, Code FROM RefDisciplineMethodOfCwd"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefDisciplineMethodFirearms', NULL, Code, Code FROM RefDisciplineMethodFirearms"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefIDEADisciplineMethodFirearm', NULL, Code, Code FROM RefIDEADisciplineMethodFirearm"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefIDEAEducationalEnvironmentEC', NULL, Code, Code FROM RefIDEAEducationalEnvironmentEC"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefIDEAEducationalEnvironmentSchoolAge', NULL, Code, Code FROM RefIDEAEducationalEnvironmentSchoolAge"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefSpecialEducationExitReason', NULL, Code, Code FROM RefSpecialEducationExitReason"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefHomelessNighttimeResidence', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'HomelessPrimaryNighttimeResidence'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefLanguage', NULL, Code, Code FROM RefLanguage"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefMilitaryConnectedStudentIndicator', NULL, Code, Code FROM RefMilitaryConnectedStudentIndicator"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefDisabilityType', NULL, Code, Code FROM RefDisabilityType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefIdeaDisabilityType', NULL, Code, Code FROM RefIdeaDisabilityType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefFoodServiceEligibility', NULL, Code, Code FROM RefFoodServiceEligibility"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefRace', NULL, Code, Code FROM RefRace"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefSex', NULL, Code, Code FROM RefSex"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefOrganizationType', '001156', o.Code, o.Code FROM RefOrganizationType o JOIN RefOrganizationElementType t ON o.RefOrganizationElementTypeId = t.RefOrganizationElementTypeId WHERE t.Code = '001156'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefInstitutionTelephoneType', NULL, Code, Code FROM RefInstitutionTelephoneType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefOperationalStatus', '000174', os.Code, os.Code FROM RefOperationalStatus os JOIN RefOperationalStatusType ost on os.RefOperationalStatusTypeId = ost.RefOperationalStatusTypeId WHERE ost.Code = '000174'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefOperationalStatus', '000533', os.Code, os.Code FROM RefOperationalStatus os JOIN RefOperationalStatusType ost on os.RefOperationalStatusTypeId = ost.RefOperationalStatusTypeId WHERE ost.Code = '000533'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefCharterSchoolAuthorizerType', NULL, Code, Code FROM RefCharterSchoolAuthorizerType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefLeaType', NULL, CASE Code WHEN 'RegularNotInSupervisoryUnion' THEN '1' WHEN 'RegularInSupervisoryUnion' THEN '2' WHEN 'SupervisoryUnion' THEN '3' WHEN 'SpecializedPublicSchoolDistrict' THEN '9' WHEN 'ServiceAgency' THEN '4' WHEN 'StateOperatedAgency' THEN '5' WHEN 'FederalOperatedAgency' THEN '6' WHEN 'Other' THEN '8' WHEN 'IndependentCharterDistrict' THEN '7' END, Code FROM RefLeaType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefProgramType', NULL, Code, Code FROM RefProgramType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefCharterLeaStatus', NULL, Code, Code FROM RefCharterLeaStatus"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefK12LeaTitleISupportService', NULL, Code, Code FROM RefK12LeaTitleISupportService"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefTitleIInstructionalServices', NULL, Code, Code FROM RefTitleIInstructionalServices"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefTitleIProgramType', NULL, Code, Code FROM RefTitleIProgramType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefMepProjectType', NULL, Code, Code FROM RefMepProjectType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefSchoolType', NULL, Code, Code FROM RefSchoolType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefOrganizationLocationType', NULL, Code, Code FROM RefOrganizationLocationType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefState', NULL, Code, Code FROM RefState"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefOrganizationIdentificationSystem', '001156', ois.Code, ois.Code FROM RefOrganizationIdentificationSystem ois JOIN RefOrganizationIdentifierType oit ON ois.RefOrganizationIdentifierTypeId = oit.RefOrganizationIdentifierTypeId where oit.Code = '001156'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefFederalProgramFundingAllocationType', NULL, Code, Code FROM RefFederalProgramFundingAllocationType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefGunFreeSchoolsActReportingStatus', NULL, Code, Code FROM RefGunFreeSchoolsActReportingStatus"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefReconstitutedStatus', NULL, Code, Code FROM RefReconstitutedStatus"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus', NULL, Code, Code FROM RefProgressAchievingEnglishLanguageProficiencyIndicatorStatus"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefTitleISchoolStatus', NULL, Code, Code FROM RefTitleISchoolStatus"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefComprehensiveAndTargetedSupport', NULL, Code, Code FROM RefComprehensiveAndTargetedSupport"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefComprehensiveSupport', NULL, Code, Code FROM RefComprehensiveSupport"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefTargetedSupport', NULL, Code, Code FROM RefTargetedSupport"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefSchoolDangerousStatus', NULL, Code, Code FROM RefSchoolDangerousStatus"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefMagnetSpecialProgram', NULL, Code, Code FROM RefMagnetSpecialProgram"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefVirtualSchoolStatus', NULL, Code, Code FROM RefVirtualSchoolStatus"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefNSLPStatus', NULL, Code, Code FROM RefNSLPStatus"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefAssessmentTypeAdministered', NULL, Code, Code FROM RefAssessmentTypeChildrenWithDisabilities"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefAssessmentTypeAdministeredToEnglishLearners', NULL, Code, Code FROM RefAssessmentTypeAdministeredToEnglishLearners"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefNeglectedProgramType', NULL, Code, Code FROM RefNeglectedProgramType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefTitleIIndicator', NULL, Code, Code FROM RefTitleIIndicator"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefEnrollmentStatus', NULL, Code, Code FROM RefEnrollmentStatus"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefEntryType', NULL, Code, Code FROM RefEntryType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefExitOrWithdrawalType', NULL, Code, Code FROM RefExitOrWithdrawalType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefPsEnrollmentStatus', NULL, Code, Code FROM RefPsEnrollmentStatus"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ", 'AssessmentPerformanceLevel_Identifier', null, 'L1', 'L1'), (", schoolYear, ", 'AssessmentPerformanceLevel_Identifier', null, 'L2', 'L2'), (", schoolYear, ", 'AssessmentPerformanceLevel_Identifier', null, 'L3', 'L3'), (", schoolYear, ", 'AssessmentPerformanceLevel_Identifier', null, 'L4', 'L4'), (", schoolYear, ", 'AssessmentPerformanceLevel_Identifier', null, 'L5', 'L5'), (", schoolYear, ", 'AssessmentPerformanceLevel_Identifier', null, 'L6', 'L6')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefSubgroup', NULL, Code, Code FROM RefSubgroup"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefComprehensiveSupportReasonApplicability', NULL, Code, Code FROM RefComprehensiveSupportReasonApplicability"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefUnexperiencedStatus', NULL, Code, Code FROM RefUnexperiencedStatus"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefOutOfFieldStatus', NULL, Code, Code FROM RefOutOfFieldStatus"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefEmergencyOrProvisionalCredentialStatus', NULL, Code, Code FROM RefEmergencyOrProvisionalCredentialStatus"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefContinuationOfServices', NULL, Code, Code FROM RefContinuationOfServices"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefMepServiceType', NULL, Code, Code FROM RefMepServiceType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefMepEnrollmentType', NULL, Code, Code FROM RefMepEnrollmentType"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT ", schoolYear, ", 'RefEdFactsTeacherInexperiencedStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'EdFactsTeacherInexperiencedStatus'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefTeachingCredentialType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'TeachingCredentialType'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefSpecialEducationTeacherQualificationStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'SpecialEducationTeacherQualificationStatus'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefEdFactsCertificationStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'EdFactsCertificationStatus'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefTitleIIILanguageInstructionProgramType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'TitleIIILanguageInstructionProgramType'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefProficiencyStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'ProficiencyStatus'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefTitleIIIAccountability', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'TitleIIIAccountabilityProgressStatus'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefEdFactsAcademicOrCareerAndTechnicalOutcomeExitType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'EdFactsAcademicOrCareerAndTechnicalOutcomeExitType'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefEdFactsAcademicOrCareerAndTechnicalOutcomeType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'EdFactsAcademicOrCareerAndTechnicalOutcomeType'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefNeglectedOrDelinquentProgramType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'NeglectedOrDelinquentProgramType'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefAccessibleFormatIssuedIndicator', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'AccessibleFormatIssuedIndicator'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefAccessibleFormatRequiredIndicator', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'AccessibleFormatRequiredIndicator'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefAccessibleFormatType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'AccessibleFormatType'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefERSRuralUrbanContinuumCode', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'ERSRuralUrbanContinuumCode'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefRuralResidencyStatus', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'RuralResidencyStatus'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefSection504Status', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'Section504Status'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ", 'RefNeglectedOrDelinquentProgramEnrollmentSubpart', NULL, 'Subpart1', 'Subpart1'), (", schoolYear, ", 'RefNeglectedOrDelinquentProgramEnrollmentSubpart', NULL, 'Subpart2', 'Subpart2')"));

            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ", 'RefAccessibleFormatIssuedIndicator', NULL, 'Yes', 'Yes'), (", schoolYear, ", 'RefAccessibleFormatIssuedIndicator', NULL, 'No', 'No')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ", 'RefAccessibleFormatRequiredIndicator', NULL, 'Yes', 'Yes'), (", schoolYear, ", 'RefAccessibleFormatRequiredIndicator', NULL, 'No', 'No'), (", schoolYear, ", 'RefAccessibleFormatRequiredIndicator', NULL, 'Unknown', 'Unknown')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ", 'RefAccessibleFormatType', NULL, 'LEA', 'LEA'), (", schoolYear, ", 'RefAccessibleFormatType', NULL, 'K12School', 'K12School'), (", schoolYear, ", 'RefAccessibleFormatType', NULL, 'NationalOrStateService', 'NationalOrStateService'), (", schoolYear, ", 'RefAccessibleFormatType', NULL, 'NonProfitOrganization', 'NonProfitOrganization')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefAssessmentAccommodationCategory', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'AssessmentAccommodationCategory'"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData SELECT DISTINCT ", schoolYear, ", 'RefAccommodationType', NULL, CedsOptionSetCode, CedsOptionSetCode FROM CEDS.CedsOptionSetMapping WHERE CedsElementTechnicalName = 'AccommodationType'"));

            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ",'RefNeglectedProgramType' ,NULL,'OTHER','OTHER')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ",'RefNeglectedProgramType' ,NULL,'CMNTYDAYPRG','CMNTYDAYPRG')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ",'RefNeglectedProgramType' ,NULL,'SHELTERS','SHELTERS')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ",'RefNeglectedProgramType' ,NULL,'GRPHOMES','GRPHOMES')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ",'RefNeglectedProgramType' ,NULL,'RSDNTLTRTMTHOME','RSDNTLTRTMTHOME')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ",'RefDelinquentProgramType' ,NULL,'ADLTCORR','ADLTCORR')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ",'RefDelinquentProgramType' ,NULL,'GRPHOMES','GRPHOMES')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ",'RefDelinquentProgramType' ,NULL,'CMNTYDAYPRG','CMNTYDAYPRG')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ",'RefDelinquentProgramType' ,NULL,'JUVDET','JUVDET')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ",'RefDelinquentProgramType' ,NULL,'JUVLNGTRMFAC','JUVLNGTRMFAC')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ",'RefDelinquentProgramType' ,NULL,'RNCHWLDRNSCMPS','RNCHWLDRNSCMPS')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ",'RefDelinquentProgramType' ,NULL,'RSDNTLTRTMTCTRS','RSDNTLTRTMTCTRS')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ",'RefDelinquentProgramType' ,NULL,'SHELTERS','SHELTERS')"));
            output.AppendLine(string.Concat("INSERT INTO Staging.SourceSystemReferenceData VALUES (", schoolYear, ",'RefDelinquentProgramType' ,NULL,'OTHER','OTHER')"));


            output.AppendLine();

            return output;
        }
        public StringBuilder AddEndToOutput(StringBuilder output, string formatType)
        {
            if (formatType == "sql")
            {
                output = this.AddSqlEndToOutput(output);
            }
            else if (formatType == "c#")
            {
                output = this.AddCSharpEndToOutput(output);
            }
            else
            {
                // Default to JSON
                output.AppendLine("]");
            }

            return output;
        }


        private StringBuilder AddSqlEndToOutput(StringBuilder output)
        {
            return output;
        }

        private StringBuilder AddCSharpEndToOutput(StringBuilder output)
        {
            output.AppendLine("         return testData;");
            output.AppendLine("     }");
            output.AppendLine(" }");
            output.AppendLine("}");
            return output;
        }


        public StringBuilder CreateSqlPowershellScript(List<string> scriptsToExecute)
        {
            StringBuilder output = new StringBuilder();


            output.AppendLine("Param(");
            output.AppendLine("  [string] $server = \"\",");
            output.AppendLine("  [string] $db = \"\",");
            output.AppendLine("  [string] $user = \"\",");
            output.AppendLine("  [string] $password = \"\")");
            output.AppendLine();
            output.AppendLine();
            output.AppendLine("# Example Usage:");
            output.AppendLine("# ./OdsTestData.ps1");
            output.AppendLine("# ./OdsTestData.ps1 \"192.168.51.53\" \"generate-test\" \"generate\" \"xxxxxxx\"");
            output.AppendLine();
            output.AppendLine("# You may need to modify the sqlCmdPath for your specific environment");
            output.AppendLine();
            output.AppendLine("$sqlCmdPath = \"c:\\program files\\microsoft sql server\\130\\Tools\\Binn\\sqlcmd.exe\"");
            output.AppendLine();
            output.AppendLine("If ($server) {");
            output.AppendLine();
            output.AppendLine("Echo \"Server = $server\"");
            output.AppendLine("Echo \"Database = $db\"");
            output.AppendLine("Echo \"User = $user\"");
            output.AppendLine("Echo \"Password = $password\"");
            output.AppendLine();
            foreach (var script in scriptsToExecute.OrderBy(x => x))
            {
                output.AppendLine("Echo \"Executing " + script + "\"");
                output.AppendLine(" & $sqlCmdPath -b -S $server -d $db -U $user -P $password -i \"" + script + "\"");
            }
            output.AppendLine();
            output.AppendLine("}");
            output.AppendLine("Else {");
            output.AppendLine();
            output.AppendLine(" $server = \"(local)\\SQLExpress\"");
            output.AppendLine(" $db = \"generate\"");
            output.AppendLine();
            output.AppendLine("Echo \"Server = $server\"");
            output.AppendLine("Echo \"Database = $db\"");
            output.AppendLine();
            foreach (var script in scriptsToExecute.OrderBy(x => x))
            {
                output.AppendLine("Echo \"Executing " + script + "\"");
                output.AppendLine(" & $sqlCmdPath -b -S $server -d $db -i \"" + script + "\"");
            }
            output.AppendLine();
            output.AppendLine("}");
            output.AppendLine("Echo \"Execution Complete\"");

            return output;
        }

        public StringBuilder UpdateCEDSValuesToNonCEDS(StringBuilder output)
        {
            output.AppendLine();

            output.AppendLine("Update Staging.SourceSystemReferenceData set InputCode = InputCode + '_1' where tablename not in ('RefAssessmentParticipationIndicator','RefAssessmentType')");
            output.AppendLine("Update Staging.CharterSchoolAuthorizer set CharterSchoolAuthorizerType =  CASE WHEN CharterSchoolAuthorizerType IS NOT NULL THEN CharterSchoolAuthorizerType +  '_1' else CharterSchoolAuthorizerType END ");
            output.AppendLine("Update Staging.K12SchoolComprehensiveSupportIdentificationType set ComprehensiveSupportReasonApplicability =  CASE WHEN ComprehensiveSupportReasonApplicability IS NOT NULL THEN ComprehensiveSupportReasonApplicability +  '_1' else ComprehensiveSupportReasonApplicability END ");
            output.AppendLine("Update Staging.K12Organization set LEA_OperationalStatus =  CASE WHEN LEA_OperationalStatus IS NOT NULL THEN LEA_OperationalStatus +  '_1' else LEA_OperationalStatus END ");
            output.AppendLine("Update Staging.K12Organization set LEA_TitleIinstructionalService =  CASE WHEN LEA_TitleIinstructionalService IS NOT NULL THEN LEA_TitleIinstructionalService +  '_1' else LEA_TitleIinstructionalService END ");
            output.AppendLine("Update Staging.K12Organization set LEA_TitleIProgramType =  CASE WHEN LEA_TitleIProgramType IS NOT NULL THEN LEA_TitleIProgramType +  '_1' else LEA_TitleIProgramType END ");
            output.AppendLine("Update Staging.K12Organization set LEA_K12LeaTitleISupportService =  CASE WHEN LEA_K12LeaTitleISupportService IS NOT NULL THEN LEA_K12LeaTitleISupportService +  '_1' else LEA_K12LeaTitleISupportService END ");
            output.AppendLine("Update Staging.K12Organization set LEA_MepProjectType =  CASE WHEN LEA_MepProjectType IS NOT NULL THEN LEA_MepProjectType +  '_1' else LEA_MepProjectType END ");
            output.AppendLine("Update Staging.K12Organization set LEA_Type =  CASE WHEN LEA_Type IS NOT NULL THEN LEA_Type +  '_1' else LEA_Type END ");
            output.AppendLine("Update Staging.K12Organization set LEA_CharterLeaStatus =  CASE WHEN LEA_CharterLeaStatus IS NOT NULL THEN LEA_CharterLeaStatus +  '_1' else LEA_CharterLeaStatus END ");
            output.AppendLine("Update Staging.K12Organization set LEA_GunFreeSchoolsActReportingStatus =  CASE WHEN LEA_GunFreeSchoolsActReportingStatus IS NOT NULL THEN LEA_GunFreeSchoolsActReportingStatus +  '_1' else LEA_GunFreeSchoolsActReportingStatus END ");
            output.AppendLine("Update Staging.K12Organization set School_Type =  CASE WHEN School_Type IS NOT NULL THEN School_Type +  '_1' else School_Type END ");
            output.AppendLine("Update Staging.K12Organization set School_OperationalStatus =  CASE WHEN School_OperationalStatus IS NOT NULL THEN School_OperationalStatus +  '_1' else School_OperationalStatus END ");
            output.AppendLine("Update Staging.K12Organization set School_GunFreeSchoolsActReportingStatus =  CASE WHEN School_GunFreeSchoolsActReportingStatus IS NOT NULL THEN School_GunFreeSchoolsActReportingStatus +  '_1' else School_GunFreeSchoolsActReportingStatus END ");
            output.AppendLine("Update Staging.K12Organization set School_ReconstitutedStatus =  CASE WHEN School_ReconstitutedStatus IS NOT NULL THEN School_ReconstitutedStatus +  '_1' else School_ReconstitutedStatus END ");
            output.AppendLine("Update Staging.K12Organization set School_TitleISchoolStatus =  CASE WHEN School_TitleISchoolStatus IS NOT NULL THEN School_TitleISchoolStatus +  '_1' else School_TitleISchoolStatus END ");
            output.AppendLine("Update Staging.K12Organization set School_ComprehensiveAndTargetedSupport =  CASE WHEN School_ComprehensiveAndTargetedSupport IS NOT NULL THEN School_ComprehensiveAndTargetedSupport +  '_1' else School_ComprehensiveAndTargetedSupport END ");
            output.AppendLine("Update Staging.K12Organization set School_ComprehensiveSupport =  CASE WHEN School_ComprehensiveSupport IS NOT NULL THEN School_ComprehensiveSupport +  '_1' else School_ComprehensiveSupport END ");
            output.AppendLine("Update Staging.K12Organization set School_TargetedSupport =  CASE WHEN School_TargetedSupport IS NOT NULL THEN School_TargetedSupport +  '_1' else School_TargetedSupport END ");
            output.AppendLine("Update Staging.K12Organization set School_SchoolDangerousStatus =  CASE WHEN School_SchoolDangerousStatus IS NOT NULL THEN School_SchoolDangerousStatus +  '_1' else School_SchoolDangerousStatus END ");
            output.AppendLine("Update Staging.K12Organization set School_MagnetOrSpecialProgramEmphasisSchool =  CASE WHEN School_MagnetOrSpecialProgramEmphasisSchool IS NOT NULL THEN School_MagnetOrSpecialProgramEmphasisSchool +  '_1' else School_MagnetOrSpecialProgramEmphasisSchool END ");
            output.AppendLine("Update Staging.K12Organization set School_VirtualSchoolStatus =  CASE WHEN School_VirtualSchoolStatus IS NOT NULL THEN School_VirtualSchoolStatus +  '_1' else School_VirtualSchoolStatus END ");
            output.AppendLine("Update Staging.K12Organization set School_NationalSchoolLunchProgramStatus =  CASE WHEN School_NationalSchoolLunchProgramStatus IS NOT NULL THEN School_NationalSchoolLunchProgramStatus +  '_1' else School_NationalSchoolLunchProgramStatus END ");
            output.AppendLine("Update Staging.K12Organization set School_ProgressAchievingEnglishLanguageProficiencyIndicatorType =  CASE WHEN School_ProgressAchievingEnglishLanguageProficiencyIndicatorType IS NOT NULL THEN School_ProgressAchievingEnglishLanguageProficiencyIndicatorType +  '_1' else School_ProgressAchievingEnglishLanguageProficiencyIndicatorType END ");
            output.AppendLine("Update Staging.OrganizationAddress set AddressTypeForOrganization =  CASE WHEN AddressTypeForOrganization IS NOT NULL THEN AddressTypeForOrganization +  '_1' else AddressTypeForOrganization END ");
            //output.AppendLine("Update Staging.OrganizationAddress set StateAbbreviation =  CASE WHEN StateAbbreviation IS NOT NULL THEN StateAbbreviation +  '_1' else StateAbbreviation END ");
            output.AppendLine("Update Staging.OrganizationGradeOffered set GradeOffered =  CASE WHEN GradeOffered IS NOT NULL THEN GradeOffered +  '_1' else GradeOffered END ");
            output.AppendLine("Update Staging.OrganizationFederalFunding set FederalProgramFundingAllocationType =  CASE WHEN FederalProgramFundingAllocationType IS NOT NULL THEN FederalProgramFundingAllocationType +  '_1' else FederalProgramFundingAllocationType END ");
            output.AppendLine("Update Staging.OrganizationPhone set InstitutionTelephoneNumberType =  CASE WHEN InstitutionTelephoneNumberType IS NOT NULL THEN InstitutionTelephoneNumberType +  '_1' else InstitutionTelephoneNumberType END ");
            output.AppendLine("Update Staging.Assessment set AssessmentAcademicSubject =  CASE WHEN AssessmentAcademicSubject IS NOT NULL THEN AssessmentAcademicSubject +  '_1' else AssessmentAcademicSubject END ");
            output.AppendLine("Update Staging.Assessment set AssessmentPurpose =  CASE WHEN AssessmentPurpose IS NOT NULL THEN AssessmentPurpose +  '_1' else AssessmentPurpose END ");
            output.AppendLine("Update Staging.Assessment set AssessmentTypeAdministered =  CASE WHEN AssessmentTypeAdministered IS NOT NULL THEN AssessmentTypeAdministered +  '_1' else AssessmentTypeAdministered END ");
            output.AppendLine("Update Staging.Assessment set AssessmentTypeAdministeredToEnglishLearners =  CASE WHEN AssessmentTypeAdministeredToEnglishLearners IS NOT NULL THEN AssessmentTypeAdministeredToEnglishLearners +  '_1' else AssessmentTypeAdministeredToEnglishLearners END ");
            output.AppendLine("Update Staging.Assessment set AssessmentPerformanceLevelIdentifier =  CASE WHEN AssessmentPerformanceLevelIdentifier IS NOT NULL THEN AssessmentPerformanceLevelIdentifier +  '_1' else AssessmentPerformanceLevelIdentifier END ");
            output.AppendLine("Update Staging.AssessmentResult set AssessmentPerformanceLevelIdentifier =  CASE WHEN AssessmentPerformanceLevelIdentifier IS NOT NULL THEN AssessmentPerformanceLevelIdentifier +  '_1' else AssessmentPerformanceLevelIdentifier END ");
            output.AppendLine("Update Staging.AssessmentResult set AssessmentPurpose =  CASE WHEN AssessmentPurpose IS NOT NULL THEN AssessmentPurpose +  '_1' else AssessmentPurpose END ");
            //output.AppendLine("Update Staging.AssessmentResult set AssessmentRegistrationParticipationIndicator =  CASE WHEN AssessmentRegistrationParticipationIndicator IS NOT NULL THEN AssessmentRegistrationParticipationIndicator +  '_1' else AssessmentRegistrationParticipationIndicator END ");
            output.AppendLine("Update Staging.AssessmentResult set AssessmentRegistrationReasonNotCompleting =  CASE WHEN AssessmentRegistrationReasonNotCompleting IS NOT NULL THEN AssessmentRegistrationReasonNotCompleting +  '_1' else AssessmentRegistrationReasonNotCompleting END ");
            output.AppendLine("Update Staging.AssessmentResult set AssessmentRegistrationReasonNotTested =  CASE WHEN AssessmentRegistrationReasonNotTested IS NOT NULL THEN AssessmentRegistrationReasonNotTested +  '_1' else AssessmentRegistrationReasonNotTested END ");
            output.AppendLine("Update Staging.AssessmentResult set AssessmentAcademicSubject =  CASE WHEN AssessmentAcademicSubject IS NOT NULL THEN AssessmentAcademicSubject +  '_1' else AssessmentAcademicSubject END ");
            output.AppendLine("Update Staging.AssessmentResult set GradeLevelWhenAssessed =  CASE WHEN GradeLevelWhenAssessed IS NOT NULL THEN GradeLevelWhenAssessed +  '_1' else GradeLevelWhenAssessed END ");
            output.AppendLine("Update Staging.AssessmentResult set AssessmentTypeAdministered =  CASE WHEN AssessmentTypeAdministered IS NOT NULL THEN AssessmentTypeAdministered +  '_1' else AssessmentTypeAdministered END ");
            output.AppendLine("Update Staging.AssessmentResult set AssessmentTypeAdministeredToEnglishLearners =  CASE WHEN AssessmentTypeAdministeredToEnglishLearners IS NOT NULL THEN AssessmentTypeAdministeredToEnglishLearners +  '_1' else AssessmentTypeAdministeredToEnglishLearners END ");
            output.AppendLine("Update Staging.AssessmentResult set AssessmentAccommodationCategory =  CASE WHEN AssessmentAccommodationCategory IS NOT NULL THEN AssessmentAccommodationCategory +  '_1' else AssessmentAccommodationCategory END ");
            output.AppendLine("Update Staging.AssessmentResult set AccommodationType =  CASE WHEN AccommodationType IS NOT NULL THEN AccommodationType +  '_1' else AccommodationType END ");
            output.AppendLine("Update Staging.Discipline set FirearmType =  CASE WHEN FirearmType IS NOT NULL THEN FirearmType +  '_1' else FirearmType END ");
            output.AppendLine("Update Staging.Discipline set DisciplineReason =  CASE WHEN DisciplineReason IS NOT NULL THEN DisciplineReason +  '_1' else DisciplineReason END ");
            output.AppendLine("Update Staging.Discipline set DisciplinaryActionTaken =  CASE WHEN DisciplinaryActionTaken IS NOT NULL THEN DisciplinaryActionTaken +  '_1' else DisciplinaryActionTaken END ");
            output.AppendLine("Update Staging.Discipline set IdeaInterimRemoval =  CASE WHEN IdeaInterimRemoval IS NOT NULL THEN IdeaInterimRemoval +  '_1' else IdeaInterimRemoval END ");
            output.AppendLine("Update Staging.Discipline set IdeaInterimRemovalReason =  CASE WHEN IdeaInterimRemovalReason IS NOT NULL THEN IdeaInterimRemovalReason +  '_1' else IdeaInterimRemovalReason END ");
            output.AppendLine("Update Staging.Discipline set DisciplineMethodOfCwd =  CASE WHEN DisciplineMethodOfCwd IS NOT NULL THEN DisciplineMethodOfCwd +  '_1' else DisciplineMethodOfCwd END ");
            output.AppendLine("Update Staging.Discipline set DisciplineMethodFirearm =  CASE WHEN DisciplineMethodFirearm IS NOT NULL THEN DisciplineMethodFirearm +  '_1' else DisciplineMethodFirearm END ");
            output.AppendLine("Update Staging.Discipline set IDEADisciplineMethodFirearm =  CASE WHEN IDEADisciplineMethodFirearm IS NOT NULL THEN IDEADisciplineMethodFirearm +  '_1' else IDEADisciplineMethodFirearm END ");
            //output.AppendLine("Update Staging.Disability set Section504Status =  CASE WHEN Section504Status IS NOT NULL THEN Section504Status +  '_1' else Section504Status END ");
            output.AppendLine("Update Staging.IdeaDisabilityType set IdeaDisabilityTypeCode =  CASE WHEN IdeaDisabilityTypeCode IS NOT NULL THEN IdeaDisabilityTypeCode +  '_1' else IdeaDisabilityTypeCode END ");
            output.AppendLine("Update Staging.K12StaffAssignment set K12StaffClassification =  CASE WHEN K12StaffClassification IS NOT NULL THEN K12StaffClassification +  '_1' else K12StaffClassification END ");
            output.AppendLine("Update Staging.K12StaffAssignment set ParaprofessionalQualificationStatus =  CASE WHEN ParaprofessionalQualificationStatus IS NOT NULL THEN ParaprofessionalQualificationStatus +  '_1' else ParaprofessionalQualificationStatus END ");
            output.AppendLine("Update Staging.K12StaffAssignment set SpecialEducationStaffCategory =  CASE WHEN SpecialEducationStaffCategory IS NOT NULL THEN SpecialEducationStaffCategory +  '_1' else SpecialEducationStaffCategory END ");
            output.AppendLine("Update Staging.K12StaffAssignment set SpecialEducationAgeGroupTaught =  CASE WHEN SpecialEducationAgeGroupTaught IS NOT NULL THEN SpecialEducationAgeGroupTaught +  '_1' else SpecialEducationAgeGroupTaught END ");
            output.AppendLine("Update Staging.K12StaffAssignment set TitleIProgramStaffCategory =  CASE WHEN TitleIProgramStaffCategory IS NOT NULL THEN TitleIProgramStaffCategory +  '_1' else TitleIProgramStaffCategory END ");
            output.AppendLine("Update Staging.K12StaffAssignment set EDFactsTeacherOutOfFieldStatus =  CASE WHEN EDFactsTeacherOutOfFieldStatus IS NOT NULL THEN EDFactsTeacherOutOfFieldStatus +  '_1' else EDFactsTeacherOutOfFieldStatus END ");
            output.AppendLine("Update Staging.K12StaffAssignment set EdFactsTeacherInexperiencedStatus =  CASE WHEN EdFactsTeacherInexperiencedStatus IS NOT NULL THEN EdFactsTeacherInexperiencedStatus +  '_1' else EdFactsTeacherInexperiencedStatus END ");
            output.AppendLine("Update Staging.K12StaffAssignment set TeachingCredentialType =  CASE WHEN TeachingCredentialType IS NOT NULL THEN TeachingCredentialType +  '_1' else TeachingCredentialType END ");
            output.AppendLine("Update Staging.K12StaffAssignment set SpecialEducationTeacherQualificationStatus =  CASE WHEN SpecialEducationTeacherQualificationStatus IS NOT NULL THEN SpecialEducationTeacherQualificationStatus +  '_1' else SpecialEducationTeacherQualificationStatus END ");
            output.AppendLine("Update Staging.K12StaffAssignment set EdFactsCertificationStatus =  CASE WHEN EdFactsCertificationStatus IS NOT NULL THEN EdFactsCertificationStatus +  '_1' else EdFactsCertificationStatus END ");
            output.AppendLine("Update Staging.K12StaffAssignment set ProgramTypeCode =  CASE WHEN ProgramTypeCode IS NOT NULL THEN ProgramTypeCode +  '_1' else ProgramTypeCode END ");
            output.AppendLine("Update Staging.K12Enrollment set Sex =  CASE WHEN Sex IS NOT NULL THEN Sex +  '_1' else Sex END ");
            output.AppendLine("Update Staging.K12Enrollment set GradeLevel =  CASE WHEN GradeLevel IS NOT NULL THEN GradeLevel +  '_1' else GradeLevel END ");
            output.AppendLine("Update Staging.K12Enrollment set HighSchoolDiplomaType =  CASE WHEN HighSchoolDiplomaType IS NOT NULL THEN HighSchoolDiplomaType +  '_1' else HighSchoolDiplomaType END ");
            output.AppendLine("Update Staging.K12Enrollment set EnrollmentStatus =  CASE WHEN EnrollmentStatus IS NOT NULL THEN EnrollmentStatus +  '_1' else EnrollmentStatus END ");
            output.AppendLine("Update Staging.K12Enrollment set EntryType =  CASE WHEN EntryType IS NOT NULL THEN EntryType +  '_1' else EntryType END ");
            output.AppendLine("Update Staging.K12Enrollment set ExitOrWithdrawalType =  CASE WHEN ExitOrWithdrawalType IS NOT NULL THEN ExitOrWithdrawalType +  '_1' else ExitOrWithdrawalType END ");
            output.AppendLine("Update Staging.K12Enrollment set FoodServiceEligibility =  CASE WHEN FoodServiceEligibility IS NOT NULL THEN FoodServiceEligibility +  '_1' else FoodServiceEligibility END ");
            output.AppendLine("Update Staging.K12Enrollment set ERSRuralUrbanContinuumCode =  CASE WHEN ERSRuralUrbanContinuumCode IS NOT NULL THEN ERSRuralUrbanContinuumCode +  '_1' else ERSRuralUrbanContinuumCode END ");
            output.AppendLine("Update Staging.K12Enrollment set RuralResidencyStatus =  CASE WHEN RuralResidencyStatus IS NOT NULL THEN RuralResidencyStatus +  '_1' else RuralResidencyStatus END ");
            output.AppendLine("Update Staging.K12PersonRace set RaceType =  CASE WHEN RaceType IS NOT NULL THEN RaceType +  '_1' else RaceType END ");
            //output.AppendLine("Update Staging.Migrant set MigrantEducationProgramContinuationOfServicesStatus =  CASE WHEN MigrantEducationProgramContinuationOfServicesStatus IS NOT NULL THEN MigrantEducationProgramContinuationOfServicesStatus +  '_1' else MigrantEducationProgramContinuationOfServicesStatus END ");
            output.AppendLine("Update Staging.Migrant set MigrantEducationProgramServicesType =  CASE WHEN MigrantEducationProgramServicesType IS NOT NULL THEN MigrantEducationProgramServicesType +  '_1' else MigrantEducationProgramServicesType END ");
            output.AppendLine("Update Staging.Migrant set MigrantEducationProgramEnrollmentType =  CASE WHEN MigrantEducationProgramEnrollmentType IS NOT NULL THEN MigrantEducationProgramEnrollmentType +  '_1' else MigrantEducationProgramEnrollmentType END ");
            output.AppendLine("Update Staging.PersonStatus set HomelessNightTimeResidence =  CASE WHEN HomelessNightTimeResidence IS NOT NULL THEN HomelessNightTimeResidence +  '_1' else HomelessNightTimeResidence END ");
            output.AppendLine("Update Staging.PersonStatus set ISO_639_2_NativeLanguage =  CASE WHEN ISO_639_2_NativeLanguage IS NOT NULL THEN ISO_639_2_NativeLanguage +  '_1' else ISO_639_2_NativeLanguage END ");
            output.AppendLine("Update Staging.PersonStatus set ISO_639_2_HomeLanguage =  CASE WHEN ISO_639_2_HomeLanguage IS NOT NULL THEN ISO_639_2_HomeLanguage +  '_1' else ISO_639_2_HomeLanguage END ");
            output.AppendLine("Update Staging.PersonStatus set MilitaryActiveStudentIndicator =  CASE WHEN MilitaryActiveStudentIndicator IS NOT NULL THEN MilitaryActiveStudentIndicator +  '_1' else MilitaryActiveStudentIndicator END ");
            output.AppendLine("Update Staging.PersonStatus set EligibilityStatusForSchoolFoodServicePrograms =  CASE WHEN EligibilityStatusForSchoolFoodServicePrograms IS NOT NULL THEN EligibilityStatusForSchoolFoodServicePrograms +  '_1' else EligibilityStatusForSchoolFoodServicePrograms END ");
            output.AppendLine("Update Staging.PersonStatus set MilitaryConnectedStudentIndicator =  CASE WHEN MilitaryConnectedStudentIndicator IS NOT NULL THEN MilitaryConnectedStudentIndicator +  '_1' else MilitaryConnectedStudentIndicator END ");
            output.AppendLine("Update Staging.ProgramParticipationNorD set NeglectedOrDelinquentProgramType =  CASE WHEN NeglectedOrDelinquentProgramType IS NOT NULL THEN NeglectedOrDelinquentProgramType +  '_1' else NeglectedOrDelinquentProgramType END ");
            output.AppendLine("Update Staging.ProgramParticipationNorD set NeglectedProgramType =  CASE WHEN NeglectedProgramType IS NOT NULL THEN NeglectedProgramType +  '_1' else NeglectedProgramType END ");
            output.AppendLine("Update Staging.ProgramParticipationNorD set DelinquentProgramType =  CASE WHEN DelinquentProgramType IS NOT NULL THEN DelinquentProgramType +  '_1' else DelinquentProgramType END ");
            output.AppendLine("Update Staging.ProgramParticipationNorD set NeglectedOrDelinquentProgramEnrollmentSubpart = CASE WHEN NeglectedOrDelinquentProgramEnrollmentSubpart IS NOT NULL THEN NeglectedOrDelinquentProgramEnrollmentSubpart +  '_1' else NeglectedOrDelinquentProgramEnrollmentSubpart END ");
            output.AppendLine("Update Staging.ProgramParticipationNorD set EdFactsAcademicOrCareerAndTechnicalOutcomeType = CASE WHEN EdFactsAcademicOrCareerAndTechnicalOutcomeType IS NOT NULL THEN EdFactsAcademicOrCareerAndTechnicalOutcomeType +  '_1' else EdFactsAcademicOrCareerAndTechnicalOutcomeType END ");
            output.AppendLine("Update Staging.ProgramParticipationNorD set EdFactsAcademicOrCareerAndTechnicalOutcomeExitType = CASE WHEN EdFactsAcademicOrCareerAndTechnicalOutcomeExitType IS NOT NULL THEN EdFactsAcademicOrCareerAndTechnicalOutcomeExitType +  '_1' else EdFactsAcademicOrCareerAndTechnicalOutcomeExitType END ");
            output.AppendLine("Update Staging.ProgramParticipationSpecialEducation set IDEAEducationalEnvironmentForEarlyChildhood =  CASE WHEN IDEAEducationalEnvironmentForEarlyChildhood IS NOT NULL THEN IDEAEducationalEnvironmentForEarlyChildhood +  '_1' else IDEAEducationalEnvironmentForEarlyChildhood END ");
            output.AppendLine("Update Staging.ProgramParticipationSpecialEducation set IDEAEducationalEnvironmentForSchoolAge =  CASE WHEN IDEAEducationalEnvironmentForSchoolAge IS NOT NULL THEN IDEAEducationalEnvironmentForSchoolAge +  '_1' else IDEAEducationalEnvironmentForSchoolAge END ");
            output.AppendLine("Update Staging.ProgramParticipationSpecialEducation set SpecialEducationExitReason =  CASE WHEN SpecialEducationExitReason IS NOT NULL THEN SpecialEducationExitReason +  '_1' else SpecialEducationExitReason END ");
            output.AppendLine("Update Staging.ProgramParticipationTitleI set TitleIIndicator =  CASE WHEN TitleIIndicator IS NOT NULL THEN TitleIIndicator +  '_1' else TitleIIndicator END ");
            output.AppendLine("Update Staging.ProgramParticipationTitleIII set TitleIIILanguageInstructionProgramType =  CASE WHEN TitleIIILanguageInstructionProgramType IS NOT NULL THEN TitleIIILanguageInstructionProgramType +  '_1' else TitleIIILanguageInstructionProgramType END ");
            output.AppendLine("Update Staging.ProgramParticipationTitleIII set TitleIIIAccountabilityProgressStatus =  CASE WHEN TitleIIIAccountabilityProgressStatus IS NOT NULL THEN TitleIIIAccountabilityProgressStatus +  '_1' else TitleIIIAccountabilityProgressStatus END ");
            output.AppendLine("Update Staging.ProgramParticipationTitleIII set Proficiency_TitleIII =  CASE WHEN Proficiency_TitleIII IS NOT NULL THEN Proficiency_TitleIII +  '_1' else Proficiency_TitleIII END ");
            output.AppendLine("Update Staging.AccessibleEducationMaterialAssignment set AccessibleFormatIssuedIndicatorCode =  CASE WHEN AccessibleFormatIssuedIndicatorCode IS NOT NULL THEN AccessibleFormatIssuedIndicatorCode +  '_1' else AccessibleFormatIssuedIndicatorCode END ");
            output.AppendLine("Update Staging.AccessibleEducationMaterialAssignment set AccessibleFormatRequiredIndicatorCode =  CASE WHEN AccessibleFormatRequiredIndicatorCode IS NOT NULL THEN AccessibleFormatRequiredIndicatorCode +  '_1' else AccessibleFormatRequiredIndicatorCode END ");
            output.AppendLine("Update Staging.AccessibleEducationMaterialAssignment set AccessibleFormatTypeCode =  CASE WHEN AccessibleFormatTypeCode IS NOT NULL THEN AccessibleFormatTypeCode +  '_1' else AccessibleFormatTypeCode END ");

            output.AppendLine();

            return output;
        }
    }
}
