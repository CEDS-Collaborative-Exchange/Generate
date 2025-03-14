using generate.core.Config;
using generate.core.Helpers.TestDataHelper;
using generate.core.Interfaces.Services;
using generate.core.Models.IDS;
using generate.core.Models.Staging;
using generate.shared.Utilities;
using generate.testdata.Interfaces;
using generate.testdata.StaticData;
using Hangfire;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using generate.testdata.TestCaseData;
using Newtonsoft.Json;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using generate.infrastructure.Helpers;
using generate.infrastructure.Contexts;
using System.Threading.Tasks;

namespace generate.testdata.DataGenerators
{
    public class StagingTestDataGenerator : IStagingTestDataGenerator
    {

        private readonly IOutputHelper _outputHelper;
        private readonly ITestDataHelper _testDataHelper;
        private readonly IStagingTestDataProfile _testDataProfile;
        private readonly ILoggerFactory _loggerFactory;
        private readonly IOptions<DataSettings> _dataSettings;


        public IdsReferenceData IdsReferenceData { get; private set; }

        //private readonly bool _showDebugInfo = false;

        public string FilePath { get; set; }
        public string FormatType { get; set; }
        public string OutputType { get; set; }
        public int Seed { get; set; }
        public int SchoolYear { get; set; }

        public ConcurrentDictionary<string, int> MaxIds { get; set; }
        public ConcurrentBag<string> ScriptsToExecute { get; set; }

        // Common test data
        public List<string> LastNames { get; private set; }
        public List<string> FemaleNames { get; private set; }
        public List<string> MaleNames { get; private set; }
        public List<string> FirstNames { get; private set; }
        public List<string> PlaceNames { get; private set; }
        public List<string> StreetTypes { get; private set; }
        public List<string> UnitTypes { get; private set; }

        public DateTime BaseProgramEntryDate { get; set; }
        public DateTime BaseProgramExitDate { get; set; }


        // Data that needs to carry over from batch to batch
        public ConcurrentBag<K12Organization> AllOrganizations { get; set; }
        public ConcurrentBag<OrganizationFederalFunding> AllOrganizationFederalFundings { get; set; }
        public ConcurrentBag<core.Models.Staging.Assessment> AllAssessments { get; set; }
        public ConcurrentBag<OrganizationGradeOffered> AllK12SchoolGradeOffered { get; set; }
        public ConcurrentBag<K12Enrollment> AllK12Enrollments { get; set; }
        public ConcurrentBag<K12Enrollment> BaseK12Enrollments { get; set; }
        public ConcurrentBag<Discipline> AllDisciplines { get; set; }
        //public ConcurrentBag<> AllDisciplineCounts { get; set; }
        public ConcurrentBag<Disability> AllDisabilities { get; set; }
        public ConcurrentBag<core.Models.Staging.AssessmentResult> AllAssessmentResults { get; set; }
        public ConcurrentBag<K12PersonRace> AllPersonRaces { get; set; }
        public ConcurrentBag<core.Models.Staging.PersonStatus> AllPersonStatuses { get; set; }
        public ConcurrentBag<core.Models.Staging.ProgramParticipationSpecialEducation> AllProgramParticipationSpecialEducation { get; set; }
        public ConcurrentBag<core.Models.Staging.IdeaDisabilityType> AllIdeaDisabilityTypes { get; set; }
        public ConcurrentBag<core.Models.Staging.ProgramParticipationTitleIII> AllProgramParticipationTitleIII { get; set; }
        public ConcurrentBag<core.Models.Staging.ProgramParticipationTitleI> AllProgramParticipationTitleI { get; set; }
        public ConcurrentBag<core.Models.Staging.ProgramParticipationCte> AllProgramParticipationCte { get; set; }
        public ConcurrentBag<core.Models.Staging.ProgramParticipationNorDClass> AllProgramParticipationNorD { get; set; }
        public ConcurrentBag<core.Models.Staging.Migrant> AllMigrant { get; set; }
        public ConcurrentBag<core.Models.Staging.K12StudentCourseSection> AllK12StudentCourseSection { get; set; }
        public ConcurrentBag<core.Models.Staging.AccessibleEducationMaterialAssignment> AllAccessibleEducationMaterialAssignment { get; set; }
        public ConcurrentBag<core.Models.Staging.AccessibleEducationMaterialProvider> AllAccessibleEducationMaterialProviders { get; set; }

        public ConcurrentBag<int> randomStudentIdentifierState = new ConcurrentBag<int>();
        public int QuantityRemaining { get; set; }
        public int QuantityOfStudents { get; set; }
        public int TotalLeasCreated { get; set; }
        public int TotalSchoolsCreated { get; set; }
        public int TotalStudentsCreated { get; set; }
        public int TotalPersonnelCreated { get; set; }

        public StagingTestDataGenerator(
            IOutputHelper outputHelper,
            ITestDataHelper testDataHelper,
            IStagingTestDataProfile testDataProfile,
            ILoggerFactory loggerFactory,
            IOptions<DataSettings> dataSettings
        )
        {
            _outputHelper = outputHelper ?? throw new ArgumentNullException(nameof(outputHelper));
            _testDataHelper = testDataHelper ?? throw new ArgumentNullException(nameof(testDataHelper));
            _testDataProfile = testDataProfile ?? throw new ArgumentNullException(nameof(testDataProfile));
            _loggerFactory = loggerFactory ?? throw new ArgumentNullException(nameof(loggerFactory));
            _dataSettings = dataSettings ?? throw new ArgumentNullException(nameof(dataSettings));
        }

        public string NewStudentIdentifierState(Random rnd)
        {
            return ThreadSafeRandom.Next(100000000, 999999999).ToString();
        }

        public void GenerateTestData(int seed, int quantityOfStudents, int schoolYear, int numberOfYears, string formatType, string outputType, string dataStandardType, string filePath, ITestDataInitializer testDataInitializer)
        {

            var globalRandom = new Random(seed);
            QuantityOfStudents = quantityOfStudents;
            StagingEnrollmentTestDataObject stagingEnrollmentTestDataObject = new StagingEnrollmentTestDataObject();

            _outputHelper.DeleteExistingFiles("staging", filePath);
            this.InitializeVariables(filePath, seed, formatType, outputType);

            // Begin Output
            StringBuilder output = new StringBuilder();
            // Write output - top level
            var sectionName = "StagingTestDataInitialization";
            this.ScriptsToExecute.Add("StagingTestData_" + sectionName + ".sql");
            output = _outputHelper.CreateStartOutput(sectionName, quantityOfStudents, this.FormatType, this.Seed, "staging");
            output = _outputHelper.AddSqlDeletesToOutput(output, "staging");

            for (int i = 0; i < numberOfYears; i++)
            {
                SchoolYear = schoolYear - i;
                Boolean isStartingSY = (schoolYear == SchoolYear)? true : false;
                output = _outputHelper.AddRepopulationOfSourceSystemReferenceData(output, "staging", SchoolYear, isStartingSY);
            }

            //// Save to SQL file
            _outputHelper.WriteOutput(output, "staging", this.FormatType, this.OutputType, this.FilePath, sectionName);

            // Execute the SQL file truncate/SourceSystemReferenceData using Hangfire
            testDataInitializer.ExecuteTestData("staging", JobCancellationToken.Null, filePath);

            for (int i = 0; i < numberOfYears; i++)
            {
                SchoolYear = schoolYear - i;
                Boolean isStartingSY = (schoolYear == SchoolYear) ? true : false;
                BaseProgramEntryDate = new DateTime(SchoolYear - 1, 9, 1);
                BaseProgramExitDate = new DateTime(SchoolYear, 6, 1);
             

                // Build actual test data
                StagingTestDataObject testData = this.GetFreshTestDataObject();

                K12OrganizationStaticDataUtility.AppendStaticK12OrganizationData(testData, globalRandom, _testDataHelper, SchoolYear, isStartingSY);
                UpdateRandomizedOrganizationData(testData, globalRandom);
                LEAwithMultipleOpStatusesTestCaseData.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);
                LEAnoSchoolTestCaseData.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);
                LEAGradePKOnlyTestCaseData.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);
                LEAGradeKGOnlyTestCaseData.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);
                OrganizationsNotReportedFederallyTestCaseData.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);
                ReservedK12OrganizationStaticData.AppendStaticK12OrganizationData(testData, globalRandom, _testDataHelper, SchoolYear);
                FS029_CIID4827_TestCaseData.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);
                //FS002_CIID4780_TestCaseData.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);
                AccessibleEducationMaterialProviderStaticDataUtility.AppendAccessibleEducationMaterialProviderData(testData, globalRandom, _testDataHelper, SchoolYear);
                testData = this.CreateGradesOfferedData(globalRandom, testData, SchoolYear);
                testData = this.CreateOrganizationFederalFundingData(globalRandom, testData, SchoolYear);

                TotalLeasCreated = testData.K12Organizations.Select(o => o.LeaIdentifierSea).Distinct().Count();
                TotalSchoolsCreated = testData.K12Organizations.Select(o => o.SchoolIdentifierSea).Distinct().Count();

                int numberOfAssessments = (int)Math.Ceiling((decimal)quantityOfStudents / (decimal)_testDataProfile.AverageNumberOfStudentsPerAssessment);
                testData = CreateAssessments(globalRandom, testData, numberOfAssessments, SchoolYear);

                if (this.OutputType != "console")
                {
                    Console.WriteLine("");
                    Console.WriteLine("======================");
                    Console.WriteLine("School Year = " + SchoolYear.ToString());
                    Console.WriteLine("Total LEAs = " + TotalLeasCreated.ToString());
                    Console.WriteLine("Total Schools = " + TotalSchoolsCreated.ToString());
                    
                }

                var stagingConnectionString = _dataSettings.Value.StagingDbContextConnection;
                var stagingContextLogger = _loggerFactory.CreateLogger<StagingDbContext>();

                stagingContextLogger.LogInformation("");
                stagingContextLogger.LogInformation("Connection String = " + stagingConnectionString);
                stagingContextLogger.LogInformation("");
                stagingContextLogger.LogInformation("======================");
                stagingContextLogger.LogInformation("School Year = " + SchoolYear.ToString());
                stagingContextLogger.LogInformation("Total LEAs = " + TotalLeasCreated.ToString());
                stagingContextLogger.LogInformation("Total Schools = " + TotalSchoolsCreated.ToString());
                

                DbContextOptions<StagingDbContext> stagingDbOptions = new DbContextOptionsBuilder<StagingDbContext>()
                    .UseSqlServer(stagingConnectionString)
                    .Options;

                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.StateDetail", testData.StateDetails);
                stagingContextLogger.LogInformation("State Details Saved");

                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.K12Organization", testData.K12Organizations);
                stagingContextLogger.LogInformation("K12Organization Saved");

                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.CharterSchoolAuthorizer", testData.CharterSchoolAuthorizers);
                stagingContextLogger.LogInformation("CharterSchoolAuthorizer Saved");

                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.Assessment", testData.Assessments);
                stagingContextLogger.LogInformation("AssessmentSaved");

                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.OrganizationAddress", testData.OrganizationAddresses);
                stagingContextLogger.LogInformation("OrganizationAddress Saved");

                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.OrganizationPhone", testData.OrganizationPhones);
                stagingContextLogger.LogInformation("OrganizationPhone Saved");

                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.OrganizationGradeOffered", testData.OrganizationGradeOffereds);
                stagingContextLogger.LogInformation("OrganizationGradeOffered Saved");

                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.OrganizationFederalFunding", testData.OrganizationFederalFundings);
                stagingContextLogger.LogInformation("OrganizationFederalFunding Saved");

                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.OrganizationProgramType", testData.OrganizationProgramTypes);
                stagingContextLogger.LogInformation("OrganizationProgramType Saved");

                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.AccessibleEducationMaterialProvider", testData.AccessibleEducationMaterialProviders);
                stagingContextLogger.LogInformation("AccessibleEducationMaterialProvider Saved");

                //stagingEnrollmentTestDataObject.K12Organizations = testData.K12Organizations;
                
                stagingEnrollmentTestDataObject.Assessments = testData.Assessments;
                stagingEnrollmentTestDataObject.AccessibleEducationMaterialProviders = testData.AccessibleEducationMaterialProviders;
                int disciplineCountLowerLimit = 3;
                int disciplineCountUpperLimit = 6;

                if (isStartingSY)
                {
                    stagingContextLogger.LogInformation("Creating K12Enrollment, Discipline, PersonRace, PersonStatus, Assessment Result, and all Program Participation data");
                    this.CreateK12EnrollmentData(testData,QuantityOfStudents, disciplineCountLowerLimit, disciplineCountUpperLimit);

                    FS002TestCaseData.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);
                    FS089TestCaseData.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);
                    //FS005TestCaseData.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);
                    FS009TestCaseData.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);
                    FS150TestCaseData.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);
                    //FS194TestCaseData.AppendTestCaseData(testData, globalRandom, _testDataHelper, schoolYear);
                    //FS037TestCaseData.AppendTestCaseData(testData, globalRandom, _testDataHelper, schoolYear);
                    FS118TestCaseData.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);
                    StudentsWithMultipleEnrollments.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);
                    StudentsEnrolledAtSeaLevelOnly.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);
                    StudentsEnrolledAtLeaLevelOnly.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);
                    CIID5128MulipleRace.AppendTestCaseData(testData, globalRandom, _testDataHelper, SchoolYear);

                }
                else
                {
                    disciplineCountLowerLimit = disciplineCountLowerLimit > 1 ? disciplineCountLowerLimit - 1 : 1;
                    disciplineCountUpperLimit = disciplineCountUpperLimit - 1;
                    this.UpdateK12EnrollmentData(stagingEnrollmentTestDataObject, stagingEnrollmentTestDataObject.K12Enrollments.Count, disciplineCountLowerLimit, disciplineCountUpperLimit);
                }

                testData.K12Enrollments.ForEach(t => AllK12Enrollments.Add(t));
                testData.Disciplines.ForEach(t => AllDisciplines.Add(t));
                testData.Disabilities.ForEach(t => AllDisabilities.Add(t));
                testData.PersonRaces.ForEach(t => AllPersonRaces.Add(t));
                testData.PersonStatuses.ForEach(t => AllPersonStatuses.Add(t));
                testData.AssessmentResults.ForEach(t => AllAssessmentResults.Add(t));
                testData.ProgramParticipationSpecialEducations.ForEach(t => AllProgramParticipationSpecialEducation.Add(t));
                testData.IdeaDisabilityTypes.ForEach(t => AllIdeaDisabilityTypes.Add(t));
                testData.ProgramParticipationCTEs.ForEach(t => AllProgramParticipationCte.Add(t));
                testData.ProgramParticipationNorDs.ForEach(t => AllProgramParticipationNorD.Add(t));
                testData.ProgramParticipationTitleIs.ForEach(t => AllProgramParticipationTitleI.Add(t));
                testData.ProgramParticipationTitleIIIs.ForEach(t => AllProgramParticipationTitleIII.Add(t));
                testData.Migrants.ForEach(t => AllMigrant.Add(t));
                testData.AccessibleEducationMaterialAssignments.ForEach(t => AllAccessibleEducationMaterialAssignment.Add(t));
                testData.K12StudentCourseSections.ForEach(t => AllK12StudentCourseSection.Add(t));

                stagingEnrollmentTestDataObject.K12Enrollments = AllK12Enrollments.ToList();
                stagingEnrollmentTestDataObject.K12PersonRaces = AllPersonRaces.ToList();

                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.K12Enrollment", AllK12Enrollments.ToList());
                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.Discipline", AllDisciplines.ToList());
                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.Disability", AllDisabilities.ToList());
                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.K12PersonRace", AllPersonRaces.ToList());
                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.PersonStatus", AllPersonStatuses.ToList());
                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.AssessmentResult", AllAssessmentResults.ToList());
                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.ProgramParticipationSpecialEducation", AllProgramParticipationSpecialEducation.ToList());
                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.IdeaDisabilityType", AllIdeaDisabilityTypes.ToList());
                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.ProgramParticipationCte", AllProgramParticipationCte.ToList());
                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.ProgramParticipationNorD", AllProgramParticipationNorD.ToList());
                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.ProgramParticipationTitleI", AllProgramParticipationTitleI.ToList());
                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.ProgramParticipationTitleIII", AllProgramParticipationTitleIII.ToList());
                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.Migrant", AllMigrant.ToList());
                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.AccessibleEducationMaterialAssignment", AllAccessibleEducationMaterialAssignment.ToList());
                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.K12StudentCourseSection", AllK12StudentCourseSection.ToList());

                

                stagingContextLogger.LogInformation("K12Enrollment, Discipline, PersonRace, PersonStatus, Assessment Result, Migrant, all Program Participation, Accessible Education Material Assignment, and K12 Student Course Section data saved");

                testData = CreateStateDefinedIndicatorData(globalRandom, testData, SchoolYear, "RaceEthnicity");
                testData = CreateStateDefinedIndicatorData(globalRandom, testData, SchoolYear, "DisabilityStatus");
                testData = CreateStateDefinedIndicatorData(globalRandom, testData, SchoolYear, "EnglishLearnerStatus");
                testData = CreateStateDefinedIndicatorData(globalRandom, testData, SchoolYear, "EconomicallyDisadvantagedStatus");

                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.StateDefinedCustomIndicator", testData.StateDefinedCustomIndicators);
                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.OrganizationCustomSchoolIndicatorStatusType", testData.OrganizationCustomSchoolIndicatorStatusTypes);

                testData = CreateK12SchoolComprehensiveSupportIdentificationTypeData(globalRandom, testData, SchoolYear);
                testData = CreateK12SchoolTargetedSupportIdentificationTypeData(globalRandom, testData, SchoolYear);

                int percentStaffToStudent = 10;
                int staffCount = quantityOfStudents / 100 * percentStaffToStudent;
                testData = CreateStaffAssignmentData(globalRandom, testData, SchoolYear, staffCount);

                //SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.K12SchoolComprehensiveSupportIdentificationType", testData.K12SchoolComprehensiveSupportIdentificationTypes);
                //SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.K12SchoolTargetedSupportIdentificationType", testData.K12SchoolTargetedSupportIdentificationType);

                stagingContextLogger.LogInformation("Comprehensive and Targeted Support data saved");

                SqlHelper.BulkInsertHelper(stagingConnectionString, "Staging.K12StaffAssignment", testData.StaffAssignments);
                stagingContextLogger.LogInformation("K12StaffAssignment data saved");

                if (this.OutputType != "console")
                {
                    Console.WriteLine("Total Students = " + AllK12Enrollments.Select(o => o.StudentIdentifierState).Distinct().Count());
                    Console.WriteLine("======================");
                }

                stagingContextLogger.LogInformation("Total Students = " + AllK12Enrollments.Select(o => o.StudentIdentifierState).Distinct().Count().ToString());

                AllDisciplines.Clear();
                AllK12Enrollments.Clear();
                AllDisabilities.Clear();
                AllPersonRaces.Clear();
                AllPersonStatuses.Clear();
                AllAssessmentResults.Clear();
                AllProgramParticipationSpecialEducation.Clear();
                AllIdeaDisabilityTypes.Clear();
                AllProgramParticipationCte.Clear();
                AllProgramParticipationNorD.Clear();
                AllProgramParticipationTitleI.Clear();
                AllProgramParticipationTitleIII.Clear();
                AllMigrant.Clear();
                AllAccessibleEducationMaterialAssignment.Clear();
                AllK12StudentCourseSection.Clear();

                if (dataStandardType != "ceds" && i == (numberOfYears - 1))
                {
                    output = output.Clear();
                    sectionName = "UpdateStagingTestData";
                    this.ScriptsToExecute.Add("StagingTestData_" + sectionName + ".sql");
                    output = _outputHelper.UpdateCEDSValuesToNonCEDS(output);
                    // Save to SQL file
                    _outputHelper.WriteOutput(output, "staging", this.FormatType, this.OutputType, this.FilePath, sectionName);
                    // Execute the SQL file truncate/SourceSystemReferenceData using Hangfire
                    testDataInitializer.ExecuteTestData("staging", JobCancellationToken.Null, filePath);

                }

                if (this.FormatType == "sql")
                {

                    var powershellScriptOutput = _outputHelper.CreateSqlPowershellScript(this.ScriptsToExecute.ToList());
                    _outputHelper.WriteOutput(powershellScriptOutput, "staging", "powershell", this.OutputType, this.FilePath);
                }

            }

            
        }

        private void InitializeVariables(string filePath = null, int? seed = null, string formatType = null, string outputType = null)
        {
            this.IdsReferenceData = new IdsReferenceData();

            if (filePath != null)
            {
                this.FilePath = filePath;
            }

            if (seed.HasValue)
            {
                this.Seed = (int)seed;
            }

            if (this.ScriptsToExecute == null)
            {
                this.ScriptsToExecute = new ConcurrentBag<string>();
            }

            if (this.MaxIds == null)
            {
                this.MaxIds = new ConcurrentDictionary<string, int>();
            }

            if (formatType != null)
            {
                this.FormatType = formatType;
            }

            if (outputType != null)
            {
                this.OutputType = outputType;
            }


            this.LastNames = _testDataHelper.ListofLastNames();
            this.MaleNames = _testDataHelper.ListofMaleNames();
            this.FemaleNames = _testDataHelper.ListofFemaleNames();
            this.FirstNames = this.MaleNames.Union(this.FemaleNames).ToList();
            this.PlaceNames = _testDataHelper.ListofPlaceNames();
            this.StreetTypes = _testDataHelper.ListofStreetTypes();
            this.UnitTypes = _testDataHelper.ListofUnitTypes();


            if (this.AllOrganizations == null)
            {
                this.AllOrganizations = new ConcurrentBag<K12Organization>();
            }

            if (this.AllOrganizationFederalFundings == null)
            {
                this.AllOrganizationFederalFundings = new ConcurrentBag<OrganizationFederalFunding>();
            }

            if (this.AllK12SchoolGradeOffered == null)
            {
                this.AllK12SchoolGradeOffered = new ConcurrentBag<OrganizationGradeOffered>();
            }

            if (this.AllK12Enrollments == null)
            {
                this.AllK12Enrollments = new ConcurrentBag<K12Enrollment>();
            }

            if (this.BaseK12Enrollments == null)
            {
                this.BaseK12Enrollments = new ConcurrentBag<K12Enrollment>();
            }

            if (this.AllPersonRaces == null)
            {
                this.AllPersonRaces = new ConcurrentBag<K12PersonRace>();
            }

            if (this.AllPersonStatuses == null)
            {
                this.AllPersonStatuses = new ConcurrentBag<core.Models.Staging.PersonStatus>();
            }

            if (this.AllDisciplines == null)
            {
                this.AllDisciplines = new ConcurrentBag<Discipline>();
            }

            if (this.AllAssessmentResults == null)
            {
                this.AllAssessmentResults = new ConcurrentBag<core.Models.Staging.AssessmentResult>();
            }

            if (this.AllProgramParticipationSpecialEducation == null)
            {
                this.AllProgramParticipationSpecialEducation = new ConcurrentBag<core.Models.Staging.ProgramParticipationSpecialEducation>();
            }

            if (this.AllIdeaDisabilityTypes == null)
            {
                this.AllIdeaDisabilityTypes = new ConcurrentBag<core.Models.Staging.IdeaDisabilityType>();
            }

            if (this.AllProgramParticipationCte == null)
            {
                this.AllProgramParticipationCte = new ConcurrentBag<core.Models.Staging.ProgramParticipationCte>();
            }

            if (this.AllProgramParticipationNorD == null)
            {
                this.AllProgramParticipationNorD = new ConcurrentBag<core.Models.Staging.ProgramParticipationNorDClass>();
            }

            if (this.AllProgramParticipationTitleI == null)
            {
                this.AllProgramParticipationTitleI = new ConcurrentBag<core.Models.Staging.ProgramParticipationTitleI>();
            }

            if (this.AllProgramParticipationTitleIII == null)
            {
                this.AllProgramParticipationTitleIII = new ConcurrentBag<core.Models.Staging.ProgramParticipationTitleIII>();
            }

            if (this.AllMigrant == null)
            {
                this.AllMigrant = new ConcurrentBag<core.Models.Staging.Migrant>();
            }

            if(this.AllAccessibleEducationMaterialProviders == null)
            {
                this.AllAccessibleEducationMaterialProviders = new ConcurrentBag<AccessibleEducationMaterialProvider>();
            }

            if (this.AllAccessibleEducationMaterialAssignment == null)
            {
                this.AllAccessibleEducationMaterialAssignment = new ConcurrentBag<core.Models.Staging.AccessibleEducationMaterialAssignment>();
            }

            if (this.AllDisabilities == null)
            {
                this.AllDisabilities = new ConcurrentBag<core.Models.Staging.Disability>();
            }

            if (this.AllK12StudentCourseSection == null)
            {
                this.AllK12StudentCourseSection = new ConcurrentBag<core.Models.Staging.K12StudentCourseSection>();
            }

        }

        //private void EmptyIterationData()
        //{

        //    this.AllOrganizations.Clear();
        //    this.AllK12SchoolGradeOffered.Clear();

        //}
        //private StringBuilder AddStudentDataToOutput(StagingTestDataObject testData, StringBuilder output, string sectionName, string sectionDescription, bool isLastSection)
        //{
        //    testData.TestDataSection = sectionName;
        //    testData.TestDataSectionDescription = sectionDescription;

        //    if (this.FormatType == "sql")
        //    {
        //        output.AppendLine("--------------------------");
        //        output.AppendLine("-- " + sectionName + " / " + sectionDescription);
        //        output.AppendLine("--------------------------");


        //        output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12Enrollments.ToArray(), typeof(K12Enrollment), "K12Enrollment", "staging", false));
        //        output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.PersonRaces.ToArray(), typeof(PersonRace), "PersonDetail", "staging", false));
        //        output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.PersonStatuses.ToArray(), typeof(core.Models.Staging.PersonStatus), "PersonStatuses", "staging", false));
        //        output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.Disciplines.ToArray(), typeof(Discipline), "Disciplines", "staging", false));
        //        output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.ProgramParticipationSpecialEducations.ToArray(), typeof(core.Models.Staging.ProgramParticipationSpecialEducation), "ProgramParticipationSpecialEducations", "staging", false));
        //        output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.AssessmentResults.ToArray(), typeof(core.Models.Staging.AssessmentResult), "AssessmentForm", "staging", false));


        //    }
        //    else if (this.FormatType == "c#")
        //    {

        //        output.AppendLine();
        //        output.AppendLine("         testData = new StagingTestDataObject()");
        //        output.AppendLine("         {");

        //        output.AppendLine("             TestDataSection = \"" + testData.TestDataSection + "\",");
        //        output.AppendLine("             TestDataSectionDescription = \"" + testData.TestDataSectionDescription + "\",");
        //        output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12Organizations.ToArray(), typeof(RefIndicatorStatusCustomType), "K12Organization", ","));
        //        output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationAddresses.ToArray(), typeof(OrganizationAddress), "OrganizationAddresses", ","));
        //        output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationPhones.ToArray(), typeof(OrganizationPhone), "OrganizationPhones", ","));
        //        output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationGradeOffereds.ToArray(), typeof(OrganizationGradeOffered), "OrganizationGradeOffereds", ","));
        //        output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.Assessments.ToArray(), typeof(core.Models.Staging.Assessment), "Assessments", ","));
        //        output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.AssessmentResults.ToArray(), typeof(core.Models.Staging.AssessmentResult), "AssessmentResults", ","));
        //        output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12Enrollments.ToArray(), typeof(K12Enrollment), "K12Enrollments", ","));
        //        output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.PersonRaces.ToArray(), typeof(PersonRace), "PersonRaces", ","));
        //        output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.PersonStatuses.ToArray(), typeof(core.Models.Staging.PersonStatus), "PersonStatuses", ","));
        //        output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.ProgramParticipationSpecialEducations.ToArray(), typeof(core.Models.Staging.ProgramParticipationSpecialEducation), "ProgramParticipationSpecialEducations", ","));

        //        output.AppendLine("         };");
        //        output.AppendLine();

        //    }
        //    else
        //    {
        //        // Default to JSON
        //        JsonSerializerSettings jsonSerializerSettings = new JsonSerializerSettings
        //        {
        //            NullValueHandling = NullValueHandling.Ignore,
        //            DefaultValueHandling = DefaultValueHandling.Ignore,
        //            ReferenceLoopHandling = ReferenceLoopHandling.Ignore,
        //            ContractResolver = DoNotSerializeIfEmptyResolver.Instance
        //        };


        //        string commaValue = "";
        //        if (!isLastSection)
        //        {
        //            commaValue = ",";
        //        }

        //        output.AppendLine(JsonConvert.SerializeObject(testData, Formatting.Indented, jsonSerializerSettings) + commaValue);
        //    }

        //    return output;
        //}

        //private int SetAndGetMaxId(string fieldKey)
        //{
        //    return this.MaxIds.AddOrUpdate(fieldKey, 1, (key, oldValue) => oldValue + 1);
        //}

        public StagingTestDataObject GetFreshTestDataObject(int seaOrganizationId = 0)
        {
            this.InitializeVariables(this.FilePath, this.Seed, this.FormatType, this.OutputType);

            StagingTestDataObject testData = new StagingTestDataObject()
            {
                AssessmentResults = new List<core.Models.Staging.AssessmentResult>(),
                Assessments = new List<core.Models.Staging.Assessment>(),
                CharterSchoolAuthorizers = new List<CharterSchoolAuthorizer>(),
                CharterSchoolManagementOrganizations = new List<CharterSchoolManagementOrganization>(),
                DataCollections = new List<DataCollection>(),
                Disciplines = new List<Discipline>(),
                Disabilities = new List<Disability>(),
                IndicatorStatusCustomTypes = new List<IndicatorStatusCustomType>(),
                IdeaDisabilityTypes = new List<IdeaDisabilityType>(),
                K12Enrollments = new List<K12Enrollment>(),
                K12Organizations = new List<K12Organization>(),
                K12ProgramEnrollments = new List<K12ProgramEnrollment>(),
                K12SchoolComprehensiveSupportIdentificationTypes = new List<K12SchoolComprehensiveSupportIdentificationType>(),
                K12SchoolTargetedSupportIdentificationType = new List<K12SchoolTargetedSupportIdentificationType>(),
                StaffAssignments = new List<K12StaffAssignment>(),
                K12StudentCourseSections = new List<K12StudentCourseSection>(),
                Migrants = new List<Migrant>(),
                OrganizationAddresses = new List<OrganizationAddress>(),
                OrganizationCalendarSessions = new List<core.Models.Staging.OrganizationCalendarSession>(),
                OrganizationCustomSchoolIndicatorStatusTypes = new List<OrganizationCustomSchoolIndicatorStatusType>(),
                OrganizationFederalFundings = new List<OrganizationFederalFunding>(),
                OrganizationGradeOffereds = new List<OrganizationGradeOffered>(),
                OrganizationPhones = new List<OrganizationPhone>(),
                OrganizationProgramTypes = new List<core.Models.Staging.OrganizationProgramType>(),
                OrganizationSchoolComprehensiveAndTargetedSupports = new List<OrganizationSchoolComprehensiveAndTargetedSupport>(),
                OrganizationSchoolIndicatorStatuses = new List<OrganizationSchoolIndicatorStatus>(),
                PersonRaces = new List<K12PersonRace>(),
                PersonStatuses = new List<core.Models.Staging.PersonStatus>(),
                ProgramParticipationCTEs = new List<core.Models.Staging.ProgramParticipationCte>(),
                ProgramParticipationNorDs = new List<ProgramParticipationNorDClass>(),
                ProgramParticipationSpecialEducations = new List<core.Models.Staging.ProgramParticipationSpecialEducation>(),
                ProgramParticipationTitleIIIs = new List<ProgramParticipationTitleIII>(),
                ProgramParticipationTitleIs = new List<core.Models.Staging.ProgramParticipationTitleI>(),
                StateDefinedCustomIndicators = new List<StateDefinedCustomIndicator>(),
                StateDetails = new List<StateDetail>(),
                AccessibleEducationMaterialAssignments = new List<AccessibleEducationMaterialAssignment>(),
                AccessibleEducationMaterialProviders = new List<AccessibleEducationMaterialProvider>()
            };

            return testData;
        }

        public StagingTestDataObject CreateAssessments(Random rnd, StagingTestDataObject testData, int numberOfAssessments, int SchoolYear)
        {

            // Assessments
            var assessments = new List<core.Models.Staging.Assessment>();
            for (int i = 0; i < numberOfAssessments; i++)
            {
                string refAcademicSubjectCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAcademicSubjectDistribution);
                string refAcademicSubjectDescription = this.IdsReferenceData.RefAcademicSubjects.Single(x => x.Code == refAcademicSubjectCode).Description;
                string refAssessmentPurpose = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAssessmentPurposeDistribution);
                string refAssessmentType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAssessmentTypeDistribution);

                int minimumPerformanceLevel = 1;
                int maximumPerformanceLevel = 5;

                string refAssessmentTypeAdministeredCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAssessmentTypeAdministeredDistribution);
                string refAssessmentTypeAdministeredToEnglishLearnersCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAssessmentTypeAdministeredToEnglishLearnersDistribution);


                for (int performanceLevel = minimumPerformanceLevel; performanceLevel <= maximumPerformanceLevel; performanceLevel++)
                {
                    int startingYear = _testDataProfile.OldestStartingYear;
                    int endingYear = DateTime.Now.Year + 1;

                    for (int administrationYear = startingYear; administrationYear <= endingYear; administrationYear++)
                    {

                        int randomDuration = _testDataHelper.GetRandomInt(rnd, new List<int>() { 1, 2, 3, 4 });

                        // Current Year
                        var assessmentStartDate = DateTime.Parse("05/15/" + SchoolYear.ToString());

                        var assessment = new core.Models.Staging.Assessment()
                        {
                            AssessmentTitle = (refAcademicSubjectDescription + " Assessment").Substring(0, refAcademicSubjectDescription.Length + 11 > 30 ? 30 : refAcademicSubjectDescription.Length + 11),
                            AssessmentFamilyTitle = refAcademicSubjectDescription + " Family",
                            AssessmentFamilyShortName = refAcademicSubjectDescription.Substring(0, refAcademicSubjectDescription.Length > 30 ? 30 : refAcademicSubjectDescription.Length),
                            AssessmentAcademicSubject = refAcademicSubjectCode,
                            AssessmentTypeAdministered = refAssessmentTypeAdministeredCode,
                            AssessmentTypeAdministeredToEnglishLearners = refAssessmentTypeAdministeredToEnglishLearnersCode,
                            AssessmentPerformanceLevelIdentifier = "L" + performanceLevel,
                            AssessmentPerformanceLevelLabel = "Level " + performanceLevel,
                            AssessmentAdministrationStartDate = assessmentStartDate,
                            AssessmentAdministrationFinishDate = assessmentStartDate.AddDays(15),
                            AssessmentPurpose = refAssessmentPurpose, // "Federal Accountability" from CEDS https://ceds.ed.gov/element/000026#03459
                            AssessmentShortName = refAcademicSubjectCode,
                            AssessmentType = refAssessmentType // "LanguageProficiency" from CEDS https://ceds.ed.gov/element/000029#AchievementTest
                        };

                        assessments.Add(assessment);
                    }
                }
            }
            var distinctAssessmentsWithPL = assessments.DistinctBy(a => new {
                a.AssessmentTitle,
                a.AssessmentAcademicSubject,
                a.AssessmentTypeAdministered,
                a.AssessmentTypeAdministeredToEnglishLearners,
                a.AssessmentPerformanceLevelIdentifier,
                a.AssessmentPurpose,
                a.AssessmentType
            }).ToList();

            var distinctAssessmentsWithoutPL = assessments.DistinctBy(a => new {
                a.AssessmentTitle,
                a.AssessmentFamilyShortName,
                a.AssessmentAcademicSubject,
                a.AssessmentTypeAdministered,
                a.AssessmentTypeAdministeredToEnglishLearners,
                a.AssessmentPurpose,
                a.AssessmentType
            }).ToList();


            foreach (var distinctAssessmentWithoutPL in distinctAssessmentsWithoutPL)
            {
                var assessmentIdentifier = _testDataHelper.GetRandomIntInRange(rnd, 10000, 99999).ToString();
                foreach (var assessment in distinctAssessmentsWithPL.Where(a => a.AssessmentTitle == distinctAssessmentWithoutPL.AssessmentTitle
                                                                 && a.AssessmentAcademicSubject == distinctAssessmentWithoutPL.AssessmentAcademicSubject
                                                                 && a.AssessmentTypeAdministered == distinctAssessmentWithoutPL.AssessmentTypeAdministered
                                                                 && a.AssessmentTypeAdministeredToEnglishLearners == distinctAssessmentWithoutPL.AssessmentTypeAdministeredToEnglishLearners
                                                                 && a.AssessmentPurpose == distinctAssessmentWithoutPL.AssessmentPurpose
                                                                 && a.AssessmentType == distinctAssessmentWithoutPL.AssessmentType).ToList())
                {
                    assessment.AssessmentIdentifier = assessmentIdentifier;
                }
            }

            testData.Assessments.AddRange(distinctAssessmentsWithPL);

            return testData;
        }

        public StagingTestDataObject CreateGradesOfferedData(Random rnd, StagingTestDataObject testData, int schoolYear)
        {
            foreach (var o in testData.K12Organizations)
            {
                // K12schoolGradeOffered

                List<string> gradesForSchoolType = new List<string>();
                IEnumerable<RefGradeLevel> gradeLevelsForSchoolType = new List<RefGradeLevel>();
                IEnumerable<RefGradeLevel> entryGradeLevels = new List<RefGradeLevel>(); ;

                if (o.School_Type == "Elementary")
                {
                    gradesForSchoolType = new List<string>()
                    {
                        "KG", "01", "02", "03", "04", "05"
                    };

                    gradeLevelsForSchoolType = this.IdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.IdsReferenceData.GradesOfferedTypeId);
                }
                else if (o.School_Type == "Middle School" || o.School_Type == "Junior High")
                {
                    gradesForSchoolType = new List<string>()
                    {
                        "06", "07", "08"
                    };

                    gradeLevelsForSchoolType = this.IdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.IdsReferenceData.GradesOfferedTypeId);
                }
                else if (o.School_Type == "High School")
                {
                    gradesForSchoolType = new List<string>()
                    {
                        "09", "10", "11", "12", "13"
                    };

                    gradeLevelsForSchoolType = this.IdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.IdsReferenceData.GradesOfferedTypeId);
                }
                else if (o.School_Type == "Pre-kindergarten/early childhood")
                {
                    gradesForSchoolType = new List<string>()
                    {
                        "PK"
                    };

                    gradeLevelsForSchoolType = this.IdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.IdsReferenceData.GradesOfferedTypeId);
                }
                else if (o.School_Type == "Adult")
                {
                    gradesForSchoolType = new List<string>()
                    {
                        "ABE"
                    };

                    gradeLevelsForSchoolType = this.IdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.IdsReferenceData.GradesOfferedTypeId);
                }
                else
                {
                    gradesForSchoolType = new List<string>()
                    {
                        "KG", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "UG", "ABE", "PK"
                    };

                    gradeLevelsForSchoolType = this.IdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.IdsReferenceData.GradesOfferedTypeId);
                }

                // Grades Offered
                foreach (var gradeLevel in gradeLevelsForSchoolType)
                {
                    OrganizationGradeOffered k12schoolGradeOffered = new OrganizationGradeOffered()
                    {
                        OrganizationIdentifier = o.SchoolIdentifierSea,
                        GradeOffered = gradeLevel.Code,
                        RecordStartDateTime = o.LEA_RecordStartDateTime,
                        RecordEndDateTime = o.LEA_RecordEndDateTime,
                        SchoolYear = schoolYear.ToString()
                    };

                    testData.OrganizationGradeOffereds.Add(k12schoolGradeOffered);
                    AllK12SchoolGradeOffered.Add(k12schoolGradeOffered);
                }
            }

            return testData;
        }

        public StagingTestDataObject CreateStateDefinedIndicatorData(Random rnd, StagingTestDataObject testData, int schoolYear, string IndicatorStatusSubgroup)
        {
            testData.K12Organizations.Where(o => !string.IsNullOrEmpty(o.SchoolIdentifierSea)).ToList().ForEach(o =>
            {
                var statusTypes = new List<string>();
                statusTypes.Add("GraduationRateIndicatorStatus");
                statusTypes.Add("AcademicAchievementIndicatorStatus");
                statusTypes.Add("OtherAcademicIndicatorStatus");
                statusTypes.Add("SchoolQualityOrStudentSuccessIndicatorStatus");

                foreach (var statusType in statusTypes)
                {
                    var organizationCustomSchoolIndicatorStatusType = new OrganizationCustomSchoolIndicatorStatusType()
                    {
                        SchoolIdentifierSea = o.SchoolIdentifierSea,
                        IndicatorStatusType = statusType,
                        IndicatorStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IndicatorStatusDistribution),
                        StatedDefinedIndicatorStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefStateDefinedIndicatorStatusDistribution),
                        IndicatorStatusSubgroupType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefIndicatorStatusSubgroupTypeDistribution),
                        StatedDefinedCustomIndicatorStatusType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefIndicatorStatusCustomTypeDistribution),
                        RecordStartDateTime = _testDataHelper.GetSessionStartDate(rnd, schoolYear),
                        RecordEndDateTime = _testDataHelper.GetSessionEndDate(rnd, schoolYear),
                        SchoolYear = schoolYear.ToString()
                    };

                    switch (organizationCustomSchoolIndicatorStatusType.IndicatorStatusSubgroupType)
                    {
                        case "RaceEthnicity":
                            organizationCustomSchoolIndicatorStatusType.IndicatorStatusSubgroup = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RaceSubgroupTypeDistribution);
                            break;
                        case "DisabilityStatus":
                            organizationCustomSchoolIndicatorStatusType.IndicatorStatusSubgroup = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.DisabilitySubgroupTypeDistribution);
                            break;
                        case "EnglishLearnerStatus":
                            organizationCustomSchoolIndicatorStatusType.IndicatorStatusSubgroup = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.EnglishLearnerSubgroupTypeDistribution);
                            break;
                        case "EconomicallyDisadvantagedStatus":
                            organizationCustomSchoolIndicatorStatusType.IndicatorStatusSubgroup = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.EconomicallyDisadvantagedSubgroupTypeDistribution);
                            break;
                    }

                    testData.OrganizationCustomSchoolIndicatorStatusTypes.Add(organizationCustomSchoolIndicatorStatusType);
                }
            });

            return testData;
        }

        public StagingTestDataObject CreateStaffAssignmentData(Random rnd, StagingTestDataObject testData, int schoolYear, int staffCount)
        {
            for (int i = 0; i < staffCount; i++)
            {
                var orgs = _testDataHelper.GetRandomObject(rnd, AllOrganizations.ToList());

                var staff = new K12StaffAssignment();

                staff.StaffMemberIdentifierState = i.ToString().PadLeft(10, '0');
                staff.LeaIdentifierSea = orgs.LeaIdentifierSea;
                staff.SchoolIdentifierSea = orgs.SchoolIdentifierSea;
                //staff.Sex = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SexDistribution);
                //staff.LastName = _testDataHelper.GetRandomString(rnd, this.LastNames);

                staff.AssignmentStartDate = _testDataHelper.GetRandomDateInRange(rnd, DateTime.Parse("7/1/" + (SchoolYear - 11).ToString()), DateTime.Parse("4/30/" + SchoolYear.ToString()));
                staff.AssignmentEndDate = _testDataHelper.GetRandomDateInRange(rnd, DateTime.Parse("6/30/" + (SchoolYear + 1).ToString()), DateTime.Parse("6/30/" + SchoolYear.ToString()));
                staff.CredentialIssuanceDate = _testDataHelper.GetRandomDateInRange(rnd, DateTime.Parse("7/1/" + (SchoolYear - 5).ToString()), DateTime.Parse("4/30/" + (SchoolYear - 2).ToString()));
                staff.CredentialExpirationDate = _testDataHelper.GetRandomDateInRange(rnd, DateTime.Parse("6/30/" + (SchoolYear + 1).ToString()), DateTime.Parse("4/30/" + (SchoolYear + 5).ToString()));

                staff.TeachingCredentialType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTeachingCredentialTypeDistribution);
                staff.FullTimeEquivalency = _testDataHelper.GetRandomDecimalInRange(rnd, 25, 100);
                staff.K12StaffClassification = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefK12StaffClassificationDistribution);
                staff.EdFactsTeacherInexperiencedStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefInexperiencedStatusDistribution);
                staff.EDFactsTeacherOutOfFieldStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefOutOfFieldStatusDistribution);
                staff.EdFactsCertificationStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefEdFactsCertificationStatusDistribution);
                staff.RecordStartDateTime = _testDataHelper.GetSessionStartDate(rnd, schoolYear);
                staff.RecordEndDateTime = _testDataHelper.GetSessionEndDate(rnd, schoolYear);
                staff.SchoolYear = schoolYear.ToString();

                staff.SpecialEducationStaffCategory = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefSpecialEducationStaffCategoryDistribution);
                staff.TitleIProgramStaffCategory = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIProgramStaffCategoryDistribution);


                if (staff.K12StaffClassification == "Paraprofessionals")
                {
                    staff.ParaprofessionalQualificationStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefParaprofessionalQualificationDistribution);
                }
                else
                {
                    staff.ParaprofessionalQualificationStatus = null;
                }

                if (staff.K12StaffClassification == "SpecialEducationTeachers")
                {
                    staff.ProgramTypeCode = "04888";
                    staff.HighlyQualifiedTeacherIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HighlyQualifiedDistribution);
                    staff.SpecialEducationTeacherQualificationStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefSpecialEducationTeacherQualificationStatusDistribution);
                }
                else
                {
                    staff.ProgramTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefProgramTypeDistribution);
                    staff.HighlyQualifiedTeacherIndicator = null;
                    staff.SpecialEducationTeacherQualificationStatus = null;
                }

                if (staff.K12StaffClassification == "SpecialEducationTeachers" || staff.K12StaffClassification == "Paraprofessionals")
                {
                    staff.SpecialEducationAgeGroupTaught = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefSpecialEducationAgeGroupTaughtDistribution);
                }
                else
                {
                    staff.SpecialEducationAgeGroupTaught = null;
                }

                //if (staff.Sex == "Male")
                //{
                //    staff.FirstName = _testDataHelper.GetRandomString(rnd, this.MaleNames);
                //    staff.MiddleName = _testDataHelper.GetRandomString(rnd, this.MaleNames);
                //}
                //else
                //{
                //    staff.FirstName = _testDataHelper.GetRandomString(rnd, this.FemaleNames);
                //    staff.MiddleName = _testDataHelper.GetRandomString(rnd, this.FemaleNames);
                //}

                testData.StaffAssignments.Add(staff);
            }

            return testData;
        }
        public StagingTestDataObject CreateOrganizationFederalFundingData(Random rnd, StagingTestDataObject testData, int schoolYear)
        {
            var programCodes = new List<string>
            {
                "84.010",
                "84.011",
                "84.013",
                "84.027",
                "84.048",
                "84.173",
                "84.196",
                "84.287",
                "84.323A",
                "84.358",
                "84.365A",
                "84.367A",
                "84.371",
                "84.424"
            };

            //SEA Federal Program Funding
            foreach (var programCode in programCodes)
            {
                var SeaFedFunds = new OrganizationFederalFunding
                {
                    OrganizationIdentifier = "39",
                    OrganizationType = "SEA",
                    FederalProgramCode = programCode,
                    FederalProgramsFundingAllocation = _testDataHelper.GetRandomDecimalInRange(rnd, 10000, 100000),
                    FederalProgramFundingAllocationType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefFederalProgramFundingAllocationTypeDistribution),
                    SchoolYear = schoolYear.ToString()
                };
                testData.OrganizationFederalFundings.Add(SeaFedFunds);
            }

            //LEA Federal Program Funding
            foreach (var o in testData.K12Organizations.Select(s => s.LeaIdentifierSea).Distinct().ToList())
            {
                foreach (var programCode in programCodes)
                {
                    var LeaFedFunds = new OrganizationFederalFunding
                    {
                        OrganizationIdentifier = o,
                        OrganizationType = "LEA",
                        FederalProgramCode = programCode,
                        FederalProgramsFundingAllocation = _testDataHelper.GetRandomDecimalInRange(rnd, 1000, 10000),
                        FederalProgramFundingAllocationType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefFederalProgramFundingAllocationTypeDistribution),
                        SchoolYear = schoolYear.ToString()
                    };
                    testData.OrganizationFederalFundings.Add(LeaFedFunds);
                }
            }

            return testData;
        }


        public StagingTestDataObject CreateK12SchoolComprehensiveSupportIdentificationTypeData(Random rnd, StagingTestDataObject testData, int schoolYear)
        {
            // LEA Identifier State excluded for FS212 hard-coded test case data 
            testData.K12Organizations.Where(o => o.LeaIdentifierSea != "00A" && !string.IsNullOrEmpty(o.SchoolIdentifierSea)).ToList().ForEach(o =>
            {
                var k12SchoolComprehensiveSupportIdentificationType = new K12SchoolComprehensiveSupportIdentificationType()
                {

                    ComprehensiveSupport = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ComprehensiveSupport),
                    ComprehensiveSupportReasonApplicability = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ComprehensiveSupportReasonApplicability),
                    LEAIdentifierSea = o.LeaIdentifierSea,
                    SchoolIdentifierSea = o.SchoolIdentifierSea,
                    RecordStartDateTime = _testDataHelper.GetSessionStartDate(rnd, schoolYear),
                    RecordEndDateTime = _testDataHelper.GetSessionEndDate(rnd, schoolYear),
                    SchoolYear = schoolYear.ToString()
                };

                testData.K12SchoolComprehensiveSupportIdentificationTypes.Add(k12SchoolComprehensiveSupportIdentificationType);
            });

            return testData;
        }

        public StagingTestDataObject CreateK12SchoolTargetedSupportIdentificationTypeData(Random rnd, StagingTestDataObject testData, int schoolYear)
        {
            // LEA Identifier State excluded for FS212 hard-coded test case data 
            testData.K12Organizations.Where(o => o.LeaIdentifierSea != "997" && !string.IsNullOrEmpty(o.SchoolIdentifierSea)).ToList().ForEach(o =>
            {
                var subgroups = new List<string>();
                subgroups.Add("EconomicDisadvantage");
                subgroups.Add("IDEA");
                subgroups.Add("LEP");
                subgroups.Add("AmericanIndianorAlaskaNative");
                subgroups.Add("Asian");
                subgroups.Add("AsianPacificIslander");
                subgroups.Add("BlackorAfricanAmerican");
                subgroups.Add("Filipino");
                subgroups.Add("HispanicNotPurtoRican");
                subgroups.Add("HispanicLatino");
                subgroups.Add("TwoorMoreRaces");
                subgroups.Add("NativeHawaiianorOtherPacificIslander");
                subgroups.Add("PuertoRican");
                subgroups.Add("White");

                foreach (var subgroup in subgroups)
                {
                    var k12schoolTargetedSupportIdentificationType = new K12SchoolTargetedSupportIdentificationType()
                    {
                        Subgroup = subgroup,
                        ComprehensiveSupportReasonApplicability = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ComprehensiveSupportReasonApplicability),
                        LEAIdentifierState = o.LeaIdentifierSea,
                        SchoolIdentifierState = o.SchoolIdentifierSea,
                        RecordStartDateTime = _testDataHelper.GetSessionStartDate(rnd, schoolYear),
                        RecordEndDateTime = _testDataHelper.GetSessionEndDate(rnd, schoolYear),
                        SchoolYear = schoolYear.ToString()
                    };

                    testData.K12SchoolTargetedSupportIdentificationType.Add(k12schoolTargetedSupportIdentificationType);
                }
            });

            return testData;
        }

        public StagingTestDataObject CreateK12EnrollmentData(StagingTestDataObject testData, int recordCount, int disciplineCountLowerLimit, int disciplineCountUpperLimit)
        {
            DateTime startTime = DateTime.UtcNow;
            List<string> CohortDescriptions = new List<string>();
            CohortDescriptions.Add("Regular Diploma");
            CohortDescriptions.Add("Alternate Diploma");
            CohortDescriptions.Add("Alternate Diploma - Removed");

            if (AllOrganizations.Count() == 0)
            {
                testData.K12Organizations.AsParallel().ForAll(o => AllOrganizations.Add(o));
            }

            var allOrgs = AllOrganizations.Where(o => o.SchoolIdentifierSea != null).ToList();
            var allGrades = AllK12SchoolGradeOffered.ToList();

            Enumerable.Range(1, recordCount).AsParallel().ForAll(i =>
            {
                var s = new K12Enrollment();
                var rnd = ThreadSafeRandom.NewRandom();

                var orgs = _testDataHelper.GetRandomObject(rnd, allOrgs);
                var birthdate = _testDataHelper.GetBirthDate(rnd, SchoolYear, _testDataProfile.MinimumAgeOfStudent, _testDataProfile.MaximumAgeOfStudent);
                var entryDate = _testDataHelper.GetEntryDate(rnd, BaseProgramEntryDate);
                var cohortYear = _testDataHelper.GetEntryDate(rnd, entryDate).Year.ToString();
                var absences = _testDataHelper.GetRandomIntInRange(rnd, 1, 170);

                s.Sex = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SexDistribution);
                s.LastOrSurname = _testDataHelper.GetRandomString(rnd, this.LastNames);
                s.Birthdate = birthdate;
                s.HispanicLatinoEthnicity = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HispanicDistribution);
                s.StudentIdentifierState = i.ToString().PadLeft(10, '0');
                s.LeaIdentifierSeaAccountability = orgs.LeaIdentifierSea;
                s.SchoolIdentifierSea = orgs.SchoolIdentifierSea;
                s.GradeLevel = GetGradeLevelForStudent(s.Birthdate, rnd);
                s.ExitOrWithdrawalType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefExitOrWithdrawalTypeDistribution);
                s.FoodServiceEligibility = _testDataHelper.GetRandomObject<RefFoodServiceEligibility>(rnd, this.IdsReferenceData.RefFoodServiceEligibilities).Code;
                s.ERSRuralUrbanContinuumCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ERSRuralUrbanContinuumCodeDistribution);
                s.RuralResidencyStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RuralResidencyStatusDistribution);
                s.FoodServiceEligibility = _testDataHelper.GetRandomObject<RefFoodServiceEligibility>(rnd, this.IdsReferenceData.RefFoodServiceEligibilities).Code;
                s.NumberOfSchoolDays = 180;
                s.NumberOfDaysAbsent = absences;
                s.AttendanceRate = Decimal.Divide(180 - absences, 180);
                s.EnrollmentEntryDate = entryDate;
                s.CohortYear = cohortYear;
                s.CohortGraduationYear = new DateTime(int.Parse(cohortYear), 1, 1).AddYears(4).Year.ToString();
                s.CohortDescription = _testDataHelper.GetRandomString(rnd, CohortDescriptions);
                s.PostSecondaryEnrollmentStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.PostSecondaryEnrollmentActionDistribution) == "Enrolled" ? true : false;
                s.SchoolYear = SchoolYear.ToString();

                if (s.GradeLevel == "12")
                {
                    if (_testDataHelper.GetRandomIntInRange(rnd, 0, 100) >= 30) // 70 graduation rate, which is honestly way better than reality
                    {
                        s.HighSchoolDiplomaType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HighSchoolDiplomaTypeDistribution);
                        s.DiplomaOrCredentialAwardDate = new DateTime(int.Parse(s.CohortGraduationYear), 6, 15);
                    }
                }

                if (s.Sex == "Male")
                {
                    s.FirstName = _testDataHelper.GetRandomString(rnd, this.MaleNames);
                    s.MiddleName = _testDataHelper.GetRandomString(rnd, this.MaleNames);
                }
                else
                {
                    s.FirstName = _testDataHelper.GetRandomString(rnd, this.FemaleNames);
                    s.MiddleName = _testDataHelper.GetRandomString(rnd, this.FemaleNames);
                }

                if (_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.EnrollmentExitDuringSchoolYearDistribution))
                {
                    if (entryDate < BaseProgramExitDate)
                    {
                        s.EnrollmentExitDate = _testDataHelper.GetExitDate(rnd, s.EnrollmentEntryDate.Value, BaseProgramExitDate);
                    }
                }

                var races = new List<K12PersonRace>();
                for (int raceCount = 0; raceCount < _testDataHelper.GetRandomIntInRange(rnd, 1, 2); raceCount++)
                {
                    string race = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefRaceDistribution);
                    while (races.Exists(r => r.RaceType == race))
                    {
                        race = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefRaceDistribution);
                    }

                    races.Add(new K12PersonRace()
                    {
                        LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                        SchoolIdentifierSea = s.SchoolIdentifierSea,
                        RaceType = race,
                        StudentIdentifierState = s.StudentIdentifierState,
                        RecordStartDateTime = s.EnrollmentEntryDate,
                        RecordEndDateTime = s.EnrollmentExitDate,
                        SchoolYear = SchoolYear.ToString()
                    });
                }

                races.ForEach(r => AllPersonRaces.Add(r));

                var personStatus = new core.Models.Staging.PersonStatus()
                {
                    LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                    SchoolIdentifierSea = s.SchoolIdentifierSea,
                    StudentIdentifierState = s.StudentIdentifierState,
                    EconomicDisadvantageStatus = Convert.ToBoolean(_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.EcoDisStatusDistribution)),
                    EligibilityStatusForSchoolFoodServicePrograms = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.EligibilityStatusForSchoolFoodServiceProgramsDistribution),
                    EnglishLearnerStatus = Convert.ToBoolean(_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LepStatusDistribution)),
                    EnglishLearner_StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate.AddYears(-6), s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate),
                    EnglishLearner_StatusEndDate = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LepExitingDistribution) ? BaseProgramExitDate : (DateTime?)null,
                    HomelessnessStatus = Convert.ToBoolean(_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HomelessProgramParticipantNowDistribution)),
                    MigrantStatus = Convert.ToBoolean(_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.MigrantProgramParticipationDistribution)),
                    //MilitaryConnectedStudentIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.MilitaryConnectedStudentIndicatorDistribution) ? "1" : "0",
                    MilitaryConnectedStudentIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefMilitaryConnectedStudentIndicatorDistribution),
                    PerkinsEnglishLearnerStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.PerkinsLepStatusDistribution) ? "1" : "0",
                    ProgramType_FosterCare = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.FosterCareProgramParticipantNowDistribution),
                    ProgramType_Immigrant = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ImmigrantTitleIIIProgramParticipantNowDistribution),
                    ProgramType_Section504 = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.Section504ProgramParticipantNowDistribution),
                    NationalSchoolLunchProgramDirectCertificationIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NationalSchoolLunchProgramDirectCertificationIndicatorDistribution)
                };

                if (personStatus.EconomicDisadvantageStatus.Value == true)
                {
                    personStatus.EconomicDisadvantage_StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    personStatus.EconomicDisadvantage_StatusEndDate = _testDataHelper.GetExitDate(rnd, personStatus.EconomicDisadvantage_StatusStartDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                }
                else
                {
                    personStatus.EconomicDisadvantage_StatusStartDate = BaseProgramExitDate;
                    personStatus.EconomicDisadvantage_StatusEndDate = BaseProgramExitDate;
                }


                if (personStatus.ProgramType_FosterCare.Value == true)
                {
                    personStatus.FosterCare_ProgramParticipationStartDate = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    personStatus.FosterCare_ProgramParticipationEndDate = _testDataHelper.GetExitDate(rnd, personStatus.FosterCare_ProgramParticipationStartDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                }
                else
                {
                    personStatus.FosterCare_ProgramParticipationStartDate = BaseProgramExitDate;
                    personStatus.FosterCare_ProgramParticipationEndDate = BaseProgramExitDate;
                }

                if (personStatus.HomelessnessStatus.Value == true)
                {
                    personStatus.Homelessness_StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    personStatus.Homelessness_StatusEndDate = _testDataHelper.GetExitDate(rnd, personStatus.Homelessness_StatusStartDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);

                    personStatus.HomelessNightTimeResidence = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefHomelessNighttimeResidenceDistribution);
                    personStatus.HomelessNightTimeResidence_StartDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate, BaseProgramExitDate.AddDays(-5));
                    personStatus.HomelessNightTimeResidence_EndDate = _testDataHelper.GetExitDate(rnd, personStatus.HomelessNightTimeResidence_StartDate.Value, BaseProgramExitDate);

                    personStatus.HomelessServicedIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HomelessServicedProgramParticipationDistribution);

                    personStatus.HomelessUnaccompaniedYouth = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HomelessUnaccompaniedYouthStatusDistribution);
                }
                else
                {
                    personStatus.Homelessness_StatusStartDate = BaseProgramExitDate;
                    personStatus.Homelessness_StatusEndDate = BaseProgramExitDate;
                }


                if (personStatus.ProgramType_Immigrant.Value == true)
                {
                    personStatus.Immigrant_ProgramParticipationStartDate = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    personStatus.Immigrant_ProgramParticipationEndDate = _testDataHelper.GetExitDate(rnd, personStatus.Immigrant_ProgramParticipationStartDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    personStatus.ISO_639_2_NativeLanguage = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefLanguageDistribution);
                }
                else
                {
                    personStatus.Immigrant_ProgramParticipationStartDate = BaseProgramExitDate;
                    personStatus.Immigrant_ProgramParticipationEndDate = BaseProgramExitDate;
                }

                if (personStatus.ProgramType_Section504.Value == true)
                {
                    var section504Status = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.Section504ProgramParticipationDistribution);

                    var section504_startDate = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    var section504_endDate = _testDataHelper.GetExitDate(rnd, section504_startDate, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);

                    personStatus.Section504_ProgramParticipationStartDate = section504_startDate;
                    personStatus.Section504_ProgramParticipationEndDate = section504_endDate;

                    var section504Disability = new core.Models.Staging.Disability()
                    {
                        Section504Status = section504Status,
                        LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                        LeaIdentifierSeaAttendance = s.LeaIdentifierSeaAttendance,
                        LeaIdentifierSeaFunding = s.LeaIdentifierSeaFunding,
                        LeaIdentifierSeaGraduation = s.LeaIdentifierSeaGraduation,
                        LeaIdentifierSeaIndividualizedEducationProgram = s.LeaIdentifierSeaIndividualizedEducationProgram,
                        SchoolYear = Convert.ToInt16(SchoolYear),
                        ResponsibleSchoolTypeAccountability = s.ResponsibleSchoolTypeAccountability,
                        ResponsibleSchoolTypeAttendance = s.ResponsibleSchoolTypeAttendance,
                        ResponsibleSchoolTypeFunding = s.ResponsibleSchoolTypeFunding,
                        ResponsibleSchoolTypeGraduation = s.ResponsibleSchoolTypeGraduation,
                        ResponsibleSchoolTypeIepServiceProvider = s.ResponsibleSchoolTypeIepServiceProvider,
                        ResponsibleSchoolTypeIndividualizedEducationProgram = s.ResponsibleSchoolTypeIndividualizedEducationProgram,
                        ResponsibleSchoolTypeTransportation = s.ResponsibleSchoolTypeTransportation,
                        SchoolIdentifierSea = s.SchoolIdentifierSea,
                        Disability_StatusStartDate = section504_startDate,
                        Disability_StatusEndDate = section504_endDate,
                        StudentIdentifierState = s.StudentIdentifierState
                    };
                    AllDisabilities.Add(section504Disability);
                }
                else
                {
                    personStatus.Section504_ProgramParticipationStartDate = BaseProgramExitDate;
                    personStatus.Section504_ProgramParticipationEndDate = BaseProgramExitDate;
                }

                if (personStatus.MigrantStatus.Value == true)
                {
                    personStatus.Migrant_StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    personStatus.Migrant_StatusEndDate = _testDataHelper.GetExitDate(rnd, personStatus.Migrant_StatusStartDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                }
                else
                {
                    personStatus.Migrant_StatusStartDate = BaseProgramExitDate;
                    personStatus.Migrant_StatusEndDate = BaseProgramExitDate;
                }

                if (personStatus.MilitaryConnectedStudentIndicator == "ActiveDuty" || personStatus.MilitaryConnectedStudentIndicator == "NationalGuardOrReserve")
                {
                    personStatus.MilitaryConnected_StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    personStatus.MilitaryConnected_StatusEndDate = _testDataHelper.GetExitDate(rnd, personStatus.MilitaryConnected_StatusStartDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                }
                else
                {
                    personStatus.MilitaryConnected_StatusStartDate = BaseProgramExitDate;
                    personStatus.MilitaryConnected_StatusEndDate = BaseProgramExitDate;
                }

                if (personStatus.PerkinsEnglishLearnerStatus == "1")
                {
                    personStatus.PerkinsEnglishLearnerStatus_StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    personStatus.PerkinsEnglishLearnerStatus_StatusEndDate = _testDataHelper.GetExitDate(rnd, personStatus.PerkinsEnglishLearnerStatus_StatusStartDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                }
                else
                {
                    personStatus.PerkinsEnglishLearnerStatus_StatusStartDate = BaseProgramExitDate;
                    personStatus.PerkinsEnglishLearnerStatus_StatusEndDate = BaseProgramExitDate;
                }

                AllPersonStatuses.Add(personStatus);

                AllK12Enrollments.Add(s);

                var disabilityType = new IdeaDisabilityType();
                var sped = new core.Models.Staging.ProgramParticipationSpecialEducation();
                bool ideaIndicator = false;

                if (Convert.ToBoolean(_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SpecialEdProgramParticipantNowDistribution)) == true)
                {
                    s.Sex = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SexForIdeaDistribution);
                    if (s.Sex == "Male")
                    {
                        s.FirstName = _testDataHelper.GetRandomString(rnd, this.MaleNames);
                        s.MiddleName = _testDataHelper.GetRandomString(rnd, this.MaleNames);
                    }
                    else
                    {
                        s.FirstName = _testDataHelper.GetRandomString(rnd, this.FemaleNames);
                        s.MiddleName = _testDataHelper.GetRandomString(rnd, this.FemaleNames);
                    }


                    disabilityType.StudentIdentifierState = s.StudentIdentifierState;
                    disabilityType.SchoolIdentifierSea = s.SchoolIdentifierSea;
                    disabilityType.LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability;
                    disabilityType.SchoolYear = short.Parse(s.SchoolYear);
                    disabilityType.IdeaDisabilityTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefIdeaDisabilityTypeDistribution);
                    disabilityType.IsPrimaryDisability = true;
                    disabilityType.RecordStartDateTime = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    if (!_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SpecialEdProgramParticipantNowDistribution))
                    {
                        disabilityType.RecordEndDateTime = _testDataHelper.GetExitDate(rnd, disabilityType.RecordStartDateTime.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    }

                    TimeSpan span = DateTime.Parse("6/1/" + SchoolYear.ToString()) - s.Birthdate.Value;
                    // Because we start at year 1 for the Gregorian
                    // calendar, we must subtract a year here.
                    int age = (new DateTime(1, 1, 1) + span).Year - 1;

                    sped.IDEAEducationalEnvironmentForEarlyChildhood = (age < 5 || (age == 5 && (s.GradeLevel == "MISSING" || s.GradeLevel == "PK"))) ? _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefIDEAEducationalEnvironmentForEarlyChildhoodDistribution) : null;
                    sped.IDEAEducationalEnvironmentForSchoolAge = (age > 5 || (age == 5 && s.GradeLevel != "PK" && s.GradeLevel != "MISSING")) ? _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefIDEAEducationalEnvironmentForSchoolAgeDistribution) : null;
                    sped.SchoolIdentifierSea = s.SchoolIdentifierSea;
                    sped.LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability;
                    sped.ProgramParticipationBeginDate = disabilityType.RecordStartDateTime;
                    sped.StudentIdentifierState = s.StudentIdentifierState;
                    ideaIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefIdeaIndicatorDistribution);
                    sped.IDEAIndicator = ideaIndicator;

                    if (disabilityType.RecordEndDateTime.HasValue)
                    {
                        sped.ProgramParticipationEndDate = disabilityType.RecordEndDateTime;
                        sped.SpecialEducationExitReason = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefSpecialEducationExitReasonDistribution);
                    }

                    AllProgramParticipationSpecialEducation.Add(sped);
                    AllIdeaDisabilityTypes.Add(disabilityType);
                }

                if ((personStatus.ProgramType_Section504.HasValue && personStatus.ProgramType_Section504.Value == true &&
                        rnd.Next(100) >= 50)
                    || (sped.IDEAIndicator.HasValue && sped.IDEAIndicator.Value == true &&
                        rnd.Next(100) >= 80))
                {
                    var courseSectionStartDate = _testDataHelper.GetSessionStartDate(rnd, SchoolYear);
                    var courseSectionEndDate = _testDataHelper.GetSessionEndDate(rnd, SchoolYear);
                    var accessibleMaterial_orderedDate = _testDataHelper.GetRandomDateInRange(rnd, courseSectionStartDate, courseSectionStartDate.AddDays(90));
                    var accessibleMaterial_receivedDate = _testDataHelper.GetRandomDateAfter(rnd, accessibleMaterial_orderedDate, 60, courseSectionEndDate);
                    var accessibleMaterial_issuedDate = _testDataHelper.GetRandomDateAfter(rnd, accessibleMaterial_receivedDate, 60, courseSectionEndDate);


                    var accessibleEducationMaterialAssignment = new core.Models.Staging.AccessibleEducationMaterialAssignment()
                    {
                        SchoolYear = SchoolYear,
                        CountDate = DateTime.Now.Date,
                        LeaIdentifierSea = s.LeaIdentifierSeaAccountability,
                        SchoolIdentifierSea = s.SchoolIdentifierSea,
                        K12StudentStudentIdentifierState = s.StudentIdentifierState,
                        ScedCourseCode = _testDataHelper.GetRandomString(rnd, _testDataProfile.SCEDCodes),
                        CourseIdentifier = _testDataHelper.GetRandomIntInRange(rnd, 1, 10000).ToString(),
                        CourseCodeSystemCode = "SCED",
                        AccessibleEducationMaterialProviderOrganizationIdentifierSea = _testDataHelper.GetRandomObject(rnd, testData.AccessibleEducationMaterialProviders).AccessibleEducationMaterialProviderOrganizationIdentifierSea,
                        AccessibleFormatIssuedIndicatorCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.AccessibleFormatIndicatorDistribution),
                        AccessibleFormatRequiredIndicatorCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.AccessibleFormatRequiredIndicatorDistribution),
                        AccessibleFormatTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.AccessibleFormatTypeDistribution),
                        LearningResourceIssuedDate = accessibleMaterial_issuedDate,
                        LearningResourceOrderedDate = accessibleMaterial_orderedDate,
                        LearningResourceReceivedDate = accessibleMaterial_receivedDate,
                    };

                    var k12StudentCourseSection = new core.Models.Staging.K12StudentCourseSection()
                    {
                        StudentIdentifierState = s.StudentIdentifierState,
                        LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                        LeaIdentifierSeaAttendance = s.LeaIdentifierSeaAttendance,
                        LeaIdentifierSeaFunding = s.LeaIdentifierSeaFunding,
                        LeaIdentifierSeaGraduation = s.LeaIdentifierSeaGraduation,
                        LeaIdentifierSeaIndividualizedEducationProgram = s.LeaIdentifierSeaIndividualizedEducationProgram,
                        SchoolIdentifierSea = s.SchoolIdentifierSea,
                        CourseGradeLevel = s.GradeLevel,
                        ScedCourseCode = accessibleEducationMaterialAssignment.ScedCourseCode,
                        CourseIdentifier = accessibleEducationMaterialAssignment.CourseIdentifier,
                        CourseCodeSystemCode = accessibleEducationMaterialAssignment.CourseCodeSystemCode,
                        CourseRecordStartDateTime = courseSectionStartDate,
                        EntryDate = courseSectionStartDate,
                        ExitDate = courseSectionEndDate,
                        SchoolYear = SchoolYear
                    };

                    AllAccessibleEducationMaterialAssignment.Add(accessibleEducationMaterialAssignment);
                    AllK12StudentCourseSection.Add(k12StudentCourseSection);
                }

                if (_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ImmigrantTitleIIIProgramParticipationDistribution))
                {
                    var prog = new core.Models.Staging.ProgramParticipationTitleIII()
                    {
                        EnglishLearnerParticipation = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LepProgramParticipantNowDistribution),
                        TitleIIILanguageInstructionProgramType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIiilanguageInstructionProgramTypeDistribution),
                        LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                        SchoolIdentifierSea = s.SchoolIdentifierSea,
                        StudentIdentifierState = s.StudentIdentifierState,
                        ProgramParticipationBeginDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate, BaseProgramExitDate.AddDays(-5)),
                        TitleIIIAccountabilityProgressStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIiiAccountability),
                    };

                    if (!_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ImmigrantTitleIIIProgramParticipantNowDistribution))
                    {
                        prog.ProgramParticipationEndDate = _testDataHelper.GetExitDate(rnd, prog.ProgramParticipationBeginDate.Value, BaseProgramExitDate);
                    }

                    if (_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ImmigrantTitleIIIProgramParticipantNowDistribution))
                    {
                        prog.TitleIIIImmigrantStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ImmigrantTitleIIIStatusDistribution);
                        prog.TitleIIIImmigrantStatus_StartDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate, BaseProgramExitDate.AddDays(-5));
                        if (!_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ImmigrantTitleIIIProgramParticipantNowDistribution))
                        {
                            prog.TitleIIIImmigrantStatus_EndDate = _testDataHelper.GetExitDate(rnd, prog.TitleIIIImmigrantStatus_StartDate.Value, BaseProgramExitDate);
                        }
                    }

                    AllProgramParticipationTitleIII.Add(prog);
                }

                var titleI = new core.Models.Staging.ProgramParticipationTitleI()
                {
                    LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                    SchoolIdentifierSea = s.SchoolIdentifierSea,
                    StudentIdentifierState = s.StudentIdentifierState,
                    TitleIIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIIndicator)
                };

                if (titleI.TitleIIndicator != "05") // Anything but "Was Not Served"
                {
                    titleI.ProgramParticipationBeginDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate, BaseProgramExitDate.AddDays(-5));
                    titleI.ProgramParticipationEndDate = _testDataHelper.GetExitDate(rnd, titleI.ProgramParticipationBeginDate.Value, BaseProgramExitDate);

                }

                AllProgramParticipationTitleI.Add(titleI);

                //var migrant = new core.Models.Staging.Migrant()
                //{
                //    LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                //    SchoolIdentifierSea = s.SchoolIdentifierSea,
                //    StudentIdentifierState = s.StudentIdentifierState,
                //    MigrantStatus = Convert.ToString(personStatus.MigrantStatus.Value),
                //    SchoolYear = SchoolYear.ToString(),
                //};

                //if (migrant.MigrantStatus == "True")
                //{
                //    //migrant.ProgramParticipationStartDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate.AddYears(-6), s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                //    //migrant.ProgramParticipationExitDate = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LepExitingDistribution) ? BaseProgramExitDate : (DateTime?)null;
                //    migrant.ProgramParticipationStartDate = personStatus.Migrant_StatusStartDate = BaseProgramExitDate;
                //    migrant.ProgramParticipationExitDate = personStatus.Migrant_StatusEndDate = BaseProgramExitDate;
                //    migrant.MigrantEducationProgramEnrollmentType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.MigrantEducationProgramEnrollmentTypeDistribution);
                //    migrant.MigrantEducationProgramServicesType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.MigrantEducationProgramServicesTypeDistribution);
                //    migrant.MigrantEducationProgramContinuationOfServicesStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.MigrantEducationProgramContinuationOfServices);
                //    migrant.ContinuationOfServicesReason = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ContinuationOfServicesReason);
                //    migrant.MigrantPrioritizedForServices = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.MigrantPrioritizedForServices);
                //}

                //AllMigrant.Add(migrant);

                var cte = new core.Models.Staging.ProgramParticipationCte()
                {
                    LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                    SchoolIdentifierSea = s.SchoolIdentifierSea,
                    StudentIdentifierState = s.StudentIdentifierState,
                    CteParticipant = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.CteProgramParticipationDistribution),
                };

                if (cte.CteParticipant.Value)
                {
                    cte.ProgramParticipationBeginDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate, BaseProgramExitDate.AddDays(-5));
                    cte.CteCompleter = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.CteCompleterDistribution);
                    cte.CteConcentrator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.CteConcentratorDistribution);

                    if (!_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.CteProgramParticipantNowDistribution))
                    {
                        cte.ProgramParticipationEndDate = _testDataHelper.GetExitDate(rnd, cte.ProgramParticipationBeginDate.Value, BaseProgramExitDate);
                        cte.DiplomaCredentialAwardDate = _testDataHelper.GetRandomDateInRange(rnd, cte.ProgramParticipationBeginDate.Value, cte.ProgramParticipationEndDate.Value);
                        /*cte.DiplomaCredentialType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HighSchoolDiplomaTypeDistribution);*/
                    }

                    cte.DisplacedHomeMakerIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.DisplacedHomemakerDistribution);

                    if (cte.DisplacedHomeMakerIndicator.Value)
                    {
                        cte.DisplacedHomeMaker_StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate, BaseProgramExitDate.AddDays(-5));
                        cte.DisplacedHomeMaker_StatusEndDate = _testDataHelper.GetExitDate(rnd, cte.DisplacedHomeMaker_StatusStartDate.Value, BaseProgramExitDate);
                    }

                    cte.SingleParentIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SingleParentOrPregnantWomanDistribution);

                    if (cte.SingleParentIndicator.Value)
                    {
                        cte.SingleParent_StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate, BaseProgramExitDate.AddDays(-5));
                        cte.SingleParent_StatusEndDate = _testDataHelper.GetExitDate(rnd, cte.SingleParent_StatusStartDate.Value, BaseProgramExitDate);
                    }

                    cte.NonTraditionalGenderStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.CteNonTraditionalCompletionDistribution);
                }

                AllProgramParticipationCte.Add(cte);

                if (_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NeglectedProgramParticipationDistribution))
                {
                    var nord = new ProgramParticipationNorDClass()
                    {
                        LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                        SchoolIdentifierSea = s.SchoolIdentifierSea,
                        StudentIdentifierState = s.StudentIdentifierState,
                        NeglectedOrDelinquentStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NorDStatusDistribution),
                    };

                    if (nord.NeglectedOrDelinquentStatus.Value == true)
                    {
                        nord.ProgramParticipationBeginDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate, BaseProgramExitDate.AddDays(-90));
                        nord.NeglectedOrDelinquentProgramType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefNeglectedOrDelinquentProgramTypeDistribution);
                        nord.NeglectedOrDelinquentProgramEnrollmentSubpart = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NorDSubpartDistribution);
                        nord.ProgressLevel_Math = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefProgressLevelDistribution);
                        nord.ProgressLevel_Reading = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefProgressLevelDistribution);
                        nord.ProgramParticipationEndDate = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NorDExitingDistribution) ? BaseProgramExitDate.AddDays(-10) : (DateTime?)null;
                        nord.NeglectedProgramType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefNeglectedProgramTypeDistribution);
                        nord.DelinquentProgramType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefDelinquentProgramTypeDistribution);
                    }

                    if (nord.ProgramParticipationEndDate.HasValue)
                    {
                        nord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NorDOutcomeExitDistribution);
                    }
                    else
                    {
                        nord.EdFactsAcademicOrCareerAndTechnicalOutcomeType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NorDOutcomeDistribution);
                    }

                    //RefNeglectedProgramType refNeglectedProgramType = _testDataHelper.GetRandomObject<RefNeglectedProgramType>(rnd, this.IdsReferenceData.RefNeglectedProgramTypes);

                    //if (_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NeglectedProgramParticipantNowDistribution))
                    //{
                    //    nord.DiplomaCredentialAwardDate = cte.DiplomaCredentialAwardDate ?? _testDataHelper.GetExitDate(rnd, nord.ProgramParticipationBeginDate.Value, BaseProgramExitDate);
                    //}

                    AllProgramParticipationNorD.Add(nord);
                }

                int adjustedDisciplineCountLowerLimit = disciplineCountLowerLimit;
                int adjustedDisciplineCountUpperLimit = disciplineCountUpperLimit;
                if (races.FirstOrDefault() != null && races.FirstOrDefault().RaceType == "BlackorAfricanAmerican") {
                    adjustedDisciplineCountLowerLimit = disciplineCountLowerLimit + 2;
                }
                else
                {

                    adjustedDisciplineCountUpperLimit = disciplineCountUpperLimit - 2;
                }
                
                AppendDisciplineData(rnd, s, ideaIndicator, adjustedDisciplineCountLowerLimit, adjustedDisciplineCountUpperLimit);
                AppendAssessmentResults(rnd, testData.Assessments, s, SchoolYear);

            });

            return testData;
        }

        public StagingEnrollmentTestDataObject UpdateK12EnrollmentData(StagingEnrollmentTestDataObject testData, int recordCount, int disciplineCountLowerLimit, int disciplineCountUpperLimit)
        {
            //DateTime startTime = DateTime.UtcNow;
            List<string> CohortDescriptions = new List<string>();
            CohortDescriptions.Add("Regular Diploma");
            CohortDescriptions.Add("Alternate Diploma");
            CohortDescriptions.Add("Alternate Diploma - Removed");

            Parallel.ForEach(testData.K12Enrollments, s =>
            {
                var rnd = ThreadSafeRandom.NewRandom();

                var entryDate = _testDataHelper.GetEntryDate(rnd, BaseProgramEntryDate);
                var absences = _testDataHelper.GetRandomIntInRange(rnd, 1, 170);
                s.SchoolYear = SchoolYear.ToString();
                s.EnrollmentEntryDate = entryDate;
                s.NumberOfDaysAbsent = absences;
                s.AttendanceRate = Decimal.Divide(180 - absences, 180);
                if (int.TryParse(s.GradeLevel, out var gradeLevel))
                {
                    if (gradeLevel == 1) { s.GradeLevel = "KG"; }
                    else
                    {
                        string tempGrade = (gradeLevel - 1).ToString();
                        if (tempGrade.Length == 1) { s.GradeLevel = "0" + tempGrade; }
                        else { s.GradeLevel = tempGrade; }
                    }
                }
                else
                {
                    if (s.GradeLevel == "KG") { s.GradeLevel = "PK"; }
                    else if (s.GradeLevel == "PK") { s.EnrollmentExitDate = entryDate; }

                }
                //s.EnrollmentExitDate = _testDataHelper.GetExitDate(rnd, entryDate, BaseProgramExitDate);

                if (_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.EnrollmentExitDuringSchoolYearDistribution))
                {
                    if (entryDate < BaseProgramExitDate)
                    {
                        s.EnrollmentExitDate = _testDataHelper.GetExitDate(rnd, entryDate, BaseProgramExitDate);
                    }
                }

                var races = testData.K12PersonRaces.Where(r => r.StudentIdentifierState == s.StudentIdentifierState
                                                && r.LeaIdentifierSeaAccountability == s.LeaIdentifierSeaAccountability
                                                && r.SchoolIdentifierSea == s.SchoolIdentifierSea
                                                ).ToList();
                                    
                
                 races.ForEach(r =>
                 {
                     r.SchoolYear = SchoolYear.ToString();
                     r.RecordStartDateTime = s.EnrollmentEntryDate;
                     r.RecordEndDateTime = s.EnrollmentExitDate;
                     AllPersonRaces.Add(r);
                 });



                var personStatus = new core.Models.Staging.PersonStatus()
                {
                    LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                    SchoolIdentifierSea = s.SchoolIdentifierSea,
                    StudentIdentifierState = s.StudentIdentifierState,
                    EconomicDisadvantageStatus = Convert.ToBoolean(_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.EcoDisStatusDistribution)),
                    EligibilityStatusForSchoolFoodServicePrograms = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.EligibilityStatusForSchoolFoodServiceProgramsDistribution),
                    EnglishLearnerStatus = Convert.ToBoolean(_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LepStatusDistribution)),
                    EnglishLearner_StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate.AddYears(-6), s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate),
                    EnglishLearner_StatusEndDate = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LepExitingDistribution) ? BaseProgramExitDate : (DateTime?)null,
                    HomelessnessStatus = Convert.ToBoolean(_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HomelessProgramParticipantNowDistribution)),
                    MigrantStatus = Convert.ToBoolean(_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.MigrantProgramParticipationDistribution)),
                    //MilitaryConnectedStudentIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.MilitaryConnectedStudentIndicatorDistribution) ? "1" : "0",
                    MilitaryConnectedStudentIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefMilitaryConnectedStudentIndicatorDistribution),
                    PerkinsEnglishLearnerStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.PerkinsLepStatusDistribution) ? "1" : "0",
                    ProgramType_FosterCare = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.FosterCareProgramParticipantNowDistribution),
                    ProgramType_Immigrant = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ImmigrantTitleIIIProgramParticipantNowDistribution),
                    ProgramType_Section504 = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.Section504ProgramParticipantNowDistribution),
                    NationalSchoolLunchProgramDirectCertificationIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NationalSchoolLunchProgramDirectCertificationIndicatorDistribution)
                };

                if (personStatus.EconomicDisadvantageStatus.Value == true)
                {
                    personStatus.EconomicDisadvantage_StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    personStatus.EconomicDisadvantage_StatusEndDate = _testDataHelper.GetExitDate(rnd, personStatus.EconomicDisadvantage_StatusStartDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                }
                else
                {
                    personStatus.EconomicDisadvantage_StatusStartDate = BaseProgramExitDate;
                    personStatus.EconomicDisadvantage_StatusEndDate = BaseProgramExitDate;
                }


                if (personStatus.ProgramType_FosterCare.Value == true)
                {
                    personStatus.FosterCare_ProgramParticipationStartDate = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    personStatus.FosterCare_ProgramParticipationEndDate = _testDataHelper.GetExitDate(rnd, personStatus.FosterCare_ProgramParticipationStartDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                }
                else
                {
                    personStatus.FosterCare_ProgramParticipationStartDate = BaseProgramExitDate;
                    personStatus.FosterCare_ProgramParticipationEndDate = BaseProgramExitDate;
                }

                if (personStatus.HomelessnessStatus.Value == true)
                {
                    personStatus.Homelessness_StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    personStatus.Homelessness_StatusEndDate = _testDataHelper.GetExitDate(rnd, personStatus.Homelessness_StatusStartDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);

                    personStatus.HomelessNightTimeResidence = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefHomelessNighttimeResidenceDistribution);
                    personStatus.HomelessNightTimeResidence_StartDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate, BaseProgramExitDate.AddDays(-5));
                    personStatus.HomelessNightTimeResidence_EndDate = _testDataHelper.GetExitDate(rnd, personStatus.HomelessNightTimeResidence_StartDate.Value, BaseProgramExitDate);

                    personStatus.HomelessServicedIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HomelessServicedProgramParticipationDistribution);

                    personStatus.HomelessUnaccompaniedYouth = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HomelessUnaccompaniedYouthStatusDistribution);
                }
                else
                {
                    personStatus.Homelessness_StatusStartDate = BaseProgramExitDate;
                    personStatus.Homelessness_StatusEndDate = BaseProgramExitDate;
                }


                if (personStatus.ProgramType_Immigrant.Value == true)
                {
                    personStatus.Immigrant_ProgramParticipationStartDate = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    personStatus.Immigrant_ProgramParticipationEndDate = _testDataHelper.GetExitDate(rnd, personStatus.Immigrant_ProgramParticipationStartDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    personStatus.ISO_639_2_NativeLanguage = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefLanguageDistribution);
                }
                else
                {
                    personStatus.Immigrant_ProgramParticipationStartDate = BaseProgramExitDate;
                    personStatus.Immigrant_ProgramParticipationEndDate = BaseProgramExitDate;
                }

                if (personStatus.ProgramType_Section504.Value == true)
                {
                    var section504Status = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.Section504ProgramParticipationDistribution);

                    var section504_startDate = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    var section504_endDate = _testDataHelper.GetExitDate(rnd, section504_startDate, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);

                    personStatus.Section504_ProgramParticipationStartDate = section504_startDate;
                    personStatus.Section504_ProgramParticipationEndDate = section504_endDate;

                    var section504Disability = new core.Models.Staging.Disability()
                    {
                        Section504Status = section504Status,
                        LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                        LeaIdentifierSeaAttendance = s.LeaIdentifierSeaAttendance,
                        LeaIdentifierSeaFunding = s.LeaIdentifierSeaFunding,
                        LeaIdentifierSeaGraduation = s.LeaIdentifierSeaGraduation,
                        LeaIdentifierSeaIndividualizedEducationProgram = s.LeaIdentifierSeaIndividualizedEducationProgram,
                        SchoolYear = Convert.ToInt16(SchoolYear),
                        ResponsibleSchoolTypeAccountability = s.ResponsibleSchoolTypeAccountability,
                        ResponsibleSchoolTypeAttendance = s.ResponsibleSchoolTypeAttendance,
                        ResponsibleSchoolTypeFunding = s.ResponsibleSchoolTypeFunding,
                        ResponsibleSchoolTypeGraduation = s.ResponsibleSchoolTypeGraduation,
                        ResponsibleSchoolTypeIepServiceProvider = s.ResponsibleSchoolTypeIepServiceProvider,
                        ResponsibleSchoolTypeIndividualizedEducationProgram = s.ResponsibleSchoolTypeIndividualizedEducationProgram,
                        ResponsibleSchoolTypeTransportation = s.ResponsibleSchoolTypeTransportation,
                        SchoolIdentifierSea = s.SchoolIdentifierSea,
                        Disability_StatusStartDate = section504_startDate,
                        Disability_StatusEndDate = section504_endDate,
                        StudentIdentifierState = s.StudentIdentifierState
                    };
                    AllDisabilities.Add(section504Disability);
                }
                else
                {
                    personStatus.Section504_ProgramParticipationStartDate = BaseProgramExitDate;
                    personStatus.Section504_ProgramParticipationEndDate = BaseProgramExitDate;
                }

                if (personStatus.MigrantStatus.Value == true)
                {
                    personStatus.Migrant_StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    personStatus.Migrant_StatusEndDate = _testDataHelper.GetExitDate(rnd, personStatus.Migrant_StatusStartDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                }
                else
                {
                    personStatus.Migrant_StatusStartDate = BaseProgramExitDate;
                    personStatus.Migrant_StatusEndDate = BaseProgramExitDate;
                }

                if (personStatus.MilitaryConnectedStudentIndicator == "ActiveDuty" || personStatus.MilitaryConnectedStudentIndicator == "NationalGuardOrReserve")
                {
                    personStatus.MilitaryConnected_StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    personStatus.MilitaryConnected_StatusEndDate = _testDataHelper.GetExitDate(rnd, personStatus.MilitaryConnected_StatusStartDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                }
                else
                {
                    personStatus.MilitaryConnected_StatusStartDate = BaseProgramExitDate;
                    personStatus.MilitaryConnected_StatusEndDate = BaseProgramExitDate;
                }

                if (personStatus.PerkinsEnglishLearnerStatus == "1")
                {
                    personStatus.PerkinsEnglishLearnerStatus_StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    personStatus.PerkinsEnglishLearnerStatus_StatusEndDate = _testDataHelper.GetExitDate(rnd, personStatus.PerkinsEnglishLearnerStatus_StatusStartDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                }
                else
                {
                    personStatus.PerkinsEnglishLearnerStatus_StatusStartDate = BaseProgramExitDate;
                    personStatus.PerkinsEnglishLearnerStatus_StatusEndDate = BaseProgramExitDate;
                }

                AllPersonStatuses.Add(personStatus);

                AllK12Enrollments.Add(s);

                var disabilityType = new IdeaDisabilityType();
                var sped = new core.Models.Staging.ProgramParticipationSpecialEducation();
                bool ideaIndicator = false;

                if (Convert.ToBoolean(_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SpecialEdProgramParticipantNowDistribution)) == true)
                {
                   
                    disabilityType.StudentIdentifierState = s.StudentIdentifierState;
                    disabilityType.SchoolIdentifierSea = s.SchoolIdentifierSea;
                    disabilityType.LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability;
                    disabilityType.SchoolYear = short.Parse(s.SchoolYear);
                    disabilityType.IdeaDisabilityTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefIdeaDisabilityTypeDistribution);
                    disabilityType.IsPrimaryDisability = true;
                    disabilityType.RecordStartDateTime = _testDataHelper.GetRandomDateInRange(rnd, s.EnrollmentEntryDate.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    if (!_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SpecialEdProgramParticipantNowDistribution))
                    {
                        disabilityType.RecordEndDateTime = _testDataHelper.GetExitDate(rnd, disabilityType.RecordStartDateTime.Value, s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                    }

                    TimeSpan span = DateTime.Parse("6/1/" + SchoolYear.ToString()) - s.Birthdate.Value;
                    // Because we start at year 1 for the Gregorian
                    // calendar, we must subtract a year here.
                    int age = (new DateTime(1, 1, 1) + span).Year - 1;

                    sped.IDEAEducationalEnvironmentForEarlyChildhood = (age < 5 || (age == 5 && (s.GradeLevel == "MISSING" || s.GradeLevel == "PK"))) ? _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefIDEAEducationalEnvironmentForEarlyChildhoodDistribution) : null;
                    sped.IDEAEducationalEnvironmentForSchoolAge = (age > 5 || (age == 5 && s.GradeLevel != "PK" && s.GradeLevel != "MISSING")) ? _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefIDEAEducationalEnvironmentForSchoolAgeDistribution) : null;
                    sped.SchoolIdentifierSea = s.SchoolIdentifierSea;
                    sped.LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability;
                    sped.ProgramParticipationBeginDate = disabilityType.RecordStartDateTime;
                    sped.StudentIdentifierState = s.StudentIdentifierState;
                    ideaIndicator = true;
                    sped.IDEAIndicator = ideaIndicator;

                    if (disabilityType.RecordEndDateTime.HasValue)
                    {
                        sped.ProgramParticipationEndDate = disabilityType.RecordEndDateTime;
                        sped.SpecialEducationExitReason = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefSpecialEducationExitReasonDistribution);
                    }

                    AllProgramParticipationSpecialEducation.Add(sped);
                    AllIdeaDisabilityTypes.Add(disabilityType);
                }

                if ((personStatus.ProgramType_Section504.HasValue && personStatus.ProgramType_Section504.Value == true &&
                        rnd.Next(100) >= 50)
                    || (sped.IDEAIndicator.HasValue && sped.IDEAIndicator.Value == true &&
                        rnd.Next(100) >= 80))
                {
                    var courseSectionStartDate = _testDataHelper.GetSessionStartDate(rnd, SchoolYear);
                    var courseSectionEndDate = _testDataHelper.GetSessionEndDate(rnd, SchoolYear);
                    var accessibleMaterial_orderedDate = _testDataHelper.GetRandomDateInRange(rnd, courseSectionStartDate, courseSectionStartDate.AddDays(90));
                    var accessibleMaterial_receivedDate = _testDataHelper.GetRandomDateAfter(rnd, accessibleMaterial_orderedDate, 60, courseSectionEndDate);
                    var accessibleMaterial_issuedDate = _testDataHelper.GetRandomDateAfter(rnd, accessibleMaterial_receivedDate, 60, courseSectionEndDate);


                    var accessibleEducationMaterialAssignment = new core.Models.Staging.AccessibleEducationMaterialAssignment()
                    {
                        SchoolYear = SchoolYear,
                        CountDate = DateTime.Now.Date,
                        LeaIdentifierSea = s.LeaIdentifierSeaAccountability,
                        SchoolIdentifierSea = s.SchoolIdentifierSea,
                        K12StudentStudentIdentifierState = s.StudentIdentifierState,
                        ScedCourseCode = _testDataHelper.GetRandomString(rnd, _testDataProfile.SCEDCodes),
                        CourseIdentifier = _testDataHelper.GetRandomIntInRange(rnd, 1, 10000).ToString(),
                        CourseCodeSystemCode = "SCED",
                        AccessibleEducationMaterialProviderOrganizationIdentifierSea = _testDataHelper.GetRandomObject(rnd, testData.AccessibleEducationMaterialProviders).AccessibleEducationMaterialProviderOrganizationIdentifierSea,
                        AccessibleFormatIssuedIndicatorCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.AccessibleFormatIndicatorDistribution),
                        AccessibleFormatRequiredIndicatorCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.AccessibleFormatRequiredIndicatorDistribution),
                        AccessibleFormatTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.AccessibleFormatTypeDistribution),
                        LearningResourceIssuedDate = accessibleMaterial_issuedDate,
                        LearningResourceOrderedDate = accessibleMaterial_orderedDate,
                        LearningResourceReceivedDate = accessibleMaterial_receivedDate,
                    };

                    var k12StudentCourseSection = new core.Models.Staging.K12StudentCourseSection()
                    {
                        StudentIdentifierState = s.StudentIdentifierState,
                        LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                        LeaIdentifierSeaAttendance = s.LeaIdentifierSeaAttendance,
                        LeaIdentifierSeaFunding = s.LeaIdentifierSeaFunding,
                        LeaIdentifierSeaGraduation = s.LeaIdentifierSeaGraduation,
                        LeaIdentifierSeaIndividualizedEducationProgram = s.LeaIdentifierSeaIndividualizedEducationProgram,
                        SchoolIdentifierSea = s.SchoolIdentifierSea,
                        CourseGradeLevel = s.GradeLevel,
                        ScedCourseCode = accessibleEducationMaterialAssignment.ScedCourseCode,
                        CourseIdentifier = accessibleEducationMaterialAssignment.CourseIdentifier,
                        CourseCodeSystemCode = accessibleEducationMaterialAssignment.CourseCodeSystemCode,
                        CourseRecordStartDateTime = courseSectionStartDate,
                        EntryDate = courseSectionStartDate,
                        ExitDate = courseSectionEndDate,
                        SchoolYear = SchoolYear
                    };

                    AllAccessibleEducationMaterialAssignment.Add(accessibleEducationMaterialAssignment);
                    AllK12StudentCourseSection.Add(k12StudentCourseSection);
                }

                if (_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ImmigrantTitleIIIProgramParticipationDistribution))
                {
                    var prog = new core.Models.Staging.ProgramParticipationTitleIII()
                    {
                        EnglishLearnerParticipation = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LepProgramParticipantNowDistribution),
                        TitleIIILanguageInstructionProgramType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIiilanguageInstructionProgramTypeDistribution),
                        LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                        SchoolIdentifierSea = s.SchoolIdentifierSea,
                        StudentIdentifierState = s.StudentIdentifierState,
                        ProgramParticipationBeginDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate, BaseProgramExitDate.AddDays(-5)),
                        TitleIIIAccountabilityProgressStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIiiAccountability),
                    };

                    if (!_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ImmigrantTitleIIIProgramParticipantNowDistribution))
                    {
                        prog.ProgramParticipationEndDate = _testDataHelper.GetExitDate(rnd, prog.ProgramParticipationBeginDate.Value, BaseProgramExitDate);
                    }

                    if (_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ImmigrantTitleIIIProgramParticipantNowDistribution))
                    {
                        prog.TitleIIIImmigrantStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ImmigrantTitleIIIStatusDistribution);
                        prog.TitleIIIImmigrantStatus_StartDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate, BaseProgramExitDate.AddDays(-5));
                        if (!_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ImmigrantTitleIIIProgramParticipantNowDistribution))
                        {
                            prog.TitleIIIImmigrantStatus_EndDate = _testDataHelper.GetExitDate(rnd, prog.TitleIIIImmigrantStatus_StartDate.Value, BaseProgramExitDate);
                        }
                    }

                    AllProgramParticipationTitleIII.Add(prog);
                }

                var titleI = new core.Models.Staging.ProgramParticipationTitleI()
                {
                    LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                    SchoolIdentifierSea = s.SchoolIdentifierSea,
                    StudentIdentifierState = s.StudentIdentifierState,
                    TitleIIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIIndicator)
                };

                if (titleI.TitleIIndicator != "05") // Anything but "Was Not Served"
                {
                    titleI.ProgramParticipationBeginDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate, BaseProgramExitDate.AddDays(-5));
                    titleI.ProgramParticipationEndDate = _testDataHelper.GetExitDate(rnd, titleI.ProgramParticipationBeginDate.Value, BaseProgramExitDate);

                }

                AllProgramParticipationTitleI.Add(titleI);

                //var migrant = new core.Models.Staging.Migrant()
                //{
                //    LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                //    SchoolIdentifierSea = s.SchoolIdentifierSea,
                //    StudentIdentifierState = s.StudentIdentifierState,
                //    MigrantStatus = Convert.ToString(personStatus.MigrantStatus.Value),
                //    SchoolYear = SchoolYear.ToString(),
                //};

                //if (migrant.MigrantStatus == "True")
                //{
                //    //migrant.ProgramParticipationStartDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate.AddYears(-6), s.EnrollmentExitDate.HasValue ? s.EnrollmentExitDate.Value : BaseProgramExitDate);
                //    //migrant.ProgramParticipationExitDate = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LepExitingDistribution) ? BaseProgramExitDate : (DateTime?)null;
                //    migrant.ProgramParticipationStartDate = personStatus.Migrant_StatusStartDate = BaseProgramExitDate;
                //    migrant.ProgramParticipationExitDate = personStatus.Migrant_StatusEndDate = BaseProgramExitDate;
                //    migrant.MigrantEducationProgramEnrollmentType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.MigrantEducationProgramEnrollmentTypeDistribution);
                //    migrant.MigrantEducationProgramServicesType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.MigrantEducationProgramServicesTypeDistribution);
                //    migrant.MigrantEducationProgramContinuationOfServicesStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.MigrantEducationProgramContinuationOfServices);
                //    migrant.ContinuationOfServicesReason = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ContinuationOfServicesReason);
                //    migrant.MigrantPrioritizedForServices = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.MigrantPrioritizedForServices);
                //}

                //AllMigrant.Add(migrant);

                var cte = new core.Models.Staging.ProgramParticipationCte()
                {
                    LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                    SchoolIdentifierSea = s.SchoolIdentifierSea,
                    StudentIdentifierState = s.StudentIdentifierState,
                    CteParticipant = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.CteProgramParticipationDistribution),
                };

                if (cte.CteParticipant.Value)
                {
                    cte.ProgramParticipationBeginDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate, BaseProgramExitDate.AddDays(-5));
                    cte.CteCompleter = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.CteCompleterDistribution);
                    cte.CteConcentrator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.CteConcentratorDistribution);

                    if (!_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.CteProgramParticipantNowDistribution))
                    {
                        cte.ProgramParticipationEndDate = _testDataHelper.GetExitDate(rnd, cte.ProgramParticipationBeginDate.Value, BaseProgramExitDate);
                        cte.DiplomaCredentialAwardDate = _testDataHelper.GetRandomDateInRange(rnd, cte.ProgramParticipationBeginDate.Value, cte.ProgramParticipationEndDate.Value);
                        /*cte.DiplomaCredentialType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HighSchoolDiplomaTypeDistribution);*/
                    }

                    cte.DisplacedHomeMakerIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.DisplacedHomemakerDistribution);

                    if (cte.DisplacedHomeMakerIndicator.Value)
                    {
                        cte.DisplacedHomeMaker_StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate, BaseProgramExitDate.AddDays(-5));
                        cte.DisplacedHomeMaker_StatusEndDate = _testDataHelper.GetExitDate(rnd, cte.DisplacedHomeMaker_StatusStartDate.Value, BaseProgramExitDate);
                    }

                    cte.SingleParentIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SingleParentOrPregnantWomanDistribution);

                    if (cte.SingleParentIndicator.Value)
                    {
                        cte.SingleParent_StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate, BaseProgramExitDate.AddDays(-5));
                        cte.SingleParent_StatusEndDate = _testDataHelper.GetExitDate(rnd, cte.SingleParent_StatusStartDate.Value, BaseProgramExitDate);
                    }

                    cte.NonTraditionalGenderStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.CteNonTraditionalCompletionDistribution);
                }

                AllProgramParticipationCte.Add(cte);

                if (_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NeglectedProgramParticipationDistribution))
                {
                    var nord = new ProgramParticipationNorDClass()
                    {
                        LeaIdentifierSeaAccountability = s.LeaIdentifierSeaAccountability,
                        SchoolIdentifierSea = s.SchoolIdentifierSea,
                        StudentIdentifierState = s.StudentIdentifierState,
                        NeglectedOrDelinquentStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NorDStatusDistribution),
                    };

                    if (nord.NeglectedOrDelinquentStatus.Value == true)
                    {
                        nord.ProgramParticipationBeginDate = _testDataHelper.GetRandomDateInRange(rnd, BaseProgramEntryDate, BaseProgramExitDate.AddDays(-90));
                        nord.NeglectedOrDelinquentProgramType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefNeglectedOrDelinquentProgramTypeDistribution);
                        nord.NeglectedOrDelinquentProgramEnrollmentSubpart = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NorDSubpartDistribution);
                        nord.ProgressLevel_Math = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefProgressLevelDistribution);
                        nord.ProgressLevel_Reading = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefProgressLevelDistribution);
                        nord.ProgramParticipationEndDate = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NorDExitingDistribution) ? BaseProgramExitDate.AddDays(-10) : (DateTime?)null;
                    }

                    if (nord.ProgramParticipationEndDate.HasValue)
                    {
                        nord.EdFactsAcademicOrCareerAndTechnicalOutcomeExitType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NorDOutcomeExitDistribution);
                    }
                    else
                    {
                        nord.EdFactsAcademicOrCareerAndTechnicalOutcomeType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NorDOutcomeDistribution);
                    }

                    //RefNeglectedProgramType refNeglectedProgramType = _testDataHelper.GetRandomObject<RefNeglectedProgramType>(rnd, this.IdsReferenceData.RefNeglectedProgramTypes);

                    //if (_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NeglectedProgramParticipantNowDistribution))
                    //{
                    //    nord.DiplomaCredentialAwardDate = cte.DiplomaCredentialAwardDate ?? _testDataHelper.GetExitDate(rnd, nord.ProgramParticipationBeginDate.Value, BaseProgramExitDate);
                    //}

                    AllProgramParticipationNorD.Add(nord);
                }

               
                int adjustedDisciplineCountLowerLimit = disciplineCountLowerLimit;
                int adjustedDisciplineCountUpperLimit = disciplineCountUpperLimit;
                if (races.Count() > 0 && races.FirstOrDefault() is not null && races.FirstOrDefault().RaceType == "BlackorAfricanAmerican")
                {
                    adjustedDisciplineCountLowerLimit = disciplineCountLowerLimit + 2;
                }
                else
                {

                    adjustedDisciplineCountUpperLimit = disciplineCountUpperLimit - 2;
                }

                AppendDisciplineData(rnd, s, ideaIndicator, adjustedDisciplineCountLowerLimit, adjustedDisciplineCountUpperLimit);
                AppendAssessmentResults(rnd, testData.Assessments, s, SchoolYear);

            });

            return testData;
        }

        private string GetGradeLevelForStudent(DateTime? birthdate, Random rnd)
        {
            TimeSpan span = DateTime.Parse("6/1/" + (SchoolYear - 1).ToString()) - birthdate.Value;
            // Because we start at year 1 for the Gregorian
            // calendar, we must subtract a year here.
            int age = (new DateTime(1, 1, 1) + span).Year -1;

            string grade = null;

            if (age == 4)
            {
                grade = "PK";
            }
            else if (age == 5)
            {
                grade = _testDataHelper.GetRandomString(rnd, new List<string>() { "KG", "PK" });
            }
            else if (age > 5)
            {
                if(age == 6)
                {
                    grade = _testDataHelper.GetRandomString(rnd, new List<string>() { "KG", "01" });
                }
                if(age >= 7 & age < 17)
                {
                    grade = (age - 5 + _testDataHelper.GetRandomIntInRange(rnd, -1, 1)).ToString().PadLeft(2, '0');
                }
                if (age >= 17)
                {
                    grade = _testDataHelper.GetRandomString(rnd, new List<string>() { "11", "12", "13", "UG", "ABE" });                
                }

            }

            return grade;
        }

        private void AppendAssessmentResults(Random rnd, List<core.Models.Staging.Assessment> assessments, K12Enrollment k12Enrollment, int schoolYear)
        {
            int numberOfAssessmentAdministrations = 2;

            if (!k12Enrollment.EnrollmentExitDate.HasValue)
            {
                for (int i = 0; i < numberOfAssessmentAdministrations; i++)
                {
                    var assessmentAdministration = _testDataHelper.GetRandomObject<core.Models.Staging.Assessment>(rnd, assessments);

                    int? refAssessmentReasonNotTestedId = _testDataHelper.GetRandomObject<RefAssessmentReasonNotTested>(rnd, this.IdsReferenceData.RefAssessmentReasonNotTested).RefAssessmentReasonNotTestedId;
                    int? refAssessmentReasonNotCompletingId = _testDataHelper.GetRandomObject<RefAssessmentReasonNotCompleting>(rnd, this.IdsReferenceData.RefAssessmentReasonNotCompletings).RefAssessmentReasonNotCompletingId;
                    var refAssessmentParticipationIndicatorCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAssessmentParticipationIndicatorDistribution);
                    var refAssessmentParticipationIndicatorId = this.IdsReferenceData.RefAssessmentParticipationIndicators.Single(x => x.Code == refAssessmentParticipationIndicatorCode).RefAssessmentParticipationIndicatorId;

                    if (refAssessmentParticipationIndicatorCode == "Participated")
                    {
                        refAssessmentReasonNotTestedId = null;
                    }
                    else
                    {
                        refAssessmentReasonNotCompletingId = null;
                    }

                    bool fullYearStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.FullAcademicYearPersonStatusDistribution);

                    var assessmentPerformanceLevel = _testDataHelper.GetRandomObject(rnd, this.IdsReferenceData.AssessmentPerformanceLevels);

                    var assessmentResult = new core.Models.Staging.AssessmentResult()
                    {
                        StudentIdentifierState = k12Enrollment.StudentIdentifierState,
                        LeaIdentifierSeaAccountability = k12Enrollment.LeaIdentifierSeaAccountability,
                        SchoolIdentifierSea = k12Enrollment.SchoolIdentifierSea,
                        AssessmentIdentifier = assessmentAdministration.AssessmentIdentifier,
                        AssessmentAcademicSubject = assessmentAdministration.AssessmentAcademicSubject,
                        AssessmentAdministrationStartDate = assessmentAdministration.AssessmentAdministrationStartDate,
                        AssessmentAdministrationFinishDate = assessmentAdministration.AssessmentAdministrationFinishDate,
                        AssessmentPurpose = assessmentAdministration.AssessmentPurpose,
                        AssessmentTypeAdministered = assessmentAdministration.AssessmentTypeAdministered,
                        AssessmentTypeAdministeredToEnglishLearners = assessmentAdministration.AssessmentTypeAdministeredToEnglishLearners,
                        AssessmentRegistrationParticipationIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAssessmentParticipationIndicatorDistribution) == "Participated" ? true : false,
                        // - These are 2 new fields that are being added to staging.AssessmentResult
                        AssessmentAccommodationCategory = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.AssessmentAccommodationCategoryDistribution),
                        AccommodationType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.AssessmentAccommodationTypeDistribution),

                        AssessmentTitle = assessmentAdministration.AssessmentTitle,
                        AssessmentType = assessmentAdministration.AssessmentType,
                        GradeLevelWhenAssessed = k12Enrollment.GradeLevel,
                        SchoolYear = schoolYear.ToString(),
                        StateFullAcademicYear = fullYearStatus ? true : false,
                        LEAFullAcademicYear = fullYearStatus ? true : false,
                        SchoolFullAcademicYear = fullYearStatus ? true : false
                    };

                    if (!assessmentResult.AssessmentRegistrationParticipationIndicator.Value)
                    {
                        assessmentResult.AssessmentRegistrationReasonNotTested = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAssessmentRegistrationReasonNotTested);
                    }

                    if (assessmentResult.AssessmentRegistrationParticipationIndicator.Value)
                    {
                        if (_testDataHelper.GetRandomIntInRange(rnd, 1, 100) >= 90)
                        {
                            assessmentResult.AssessmentRegistrationReasonNotCompleting = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAssessmentRegistrationReasonNotCompleting);
                        }
                        else
                        {
                            assessmentResult.AssessmentRegistrationReasonNotCompleting = null;
                            assessmentResult.AssessmentPerformanceLevelIdentifier = assessmentPerformanceLevel.Identifier;
                            assessmentResult.AssessmentPerformanceLevelLabel = assessmentPerformanceLevel.Label;
                            assessmentResult.AssessmentScoreMetricType = this.IdsReferenceData.RefScoreMetricType;
                            assessmentResult.ScoreValue = rnd.Next(50, 100).ToString();
                        }
                    }

                    AllAssessmentResults.Add(assessmentResult);
                }
            }
        }

        private void AppendDisciplineData(Random rnd, K12Enrollment k12Enrollment, bool ideaIndicator, int disciplineCountLowerLimit, int disciplineCountUpperLimit)
        {

            // Discipline ----
            //////////////////////////////////////

            int disciplineCount = rnd.Next(disciplineCountLowerLimit, disciplineCountUpperLimit);

            for (int disciplineNumber = 0; disciplineNumber < disciplineCount; disciplineNumber++)
            {
                // Note: Using fully random (non-weighted) properites for disciplines (might consider using TestDataProfile in future)

                var refDisciplinaryActionTaken = _testDataHelper.GetRandomObject<RefDisciplinaryActionTaken>(rnd, this.IdsReferenceData.RefDisciplinaryActionTakens).Code;
                var refDisciplineReason = _testDataHelper.GetRandomObject<RefDisciplineReason>(rnd, this.IdsReferenceData.RefDisciplineReasons).Code;
                var refDisciplineLengthDifferenceReason = _testDataHelper.GetRandomObject<RefDisciplineLengthDifferenceReason>(rnd, this.IdsReferenceData.RefDisciplineLengthDifferenceReasons).Code;
                string refIdeainterimRemoval = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefIdeaInterimRemovalDistribution);
                //  string refIdeainterimRemoval = _testDataHelper.GetRandomObject<RefIdeainterimRemoval>(rnd, this.IdsReferenceData.RefIdeainterimRemovals).Code;
                string refIdeainterimRemovalReason = _testDataHelper.GetRandomObject<RefIdeainterimRemovalReason>(rnd, this.IdsReferenceData.RefIdeainterimRemovalReasons).Code;
                string refDisciplineMethodOfCwd = _testDataHelper.GetRandomObject<RefDisciplineMethodOfCwd>(rnd, this.IdsReferenceData.RefDisciplineMethodOfCwds).Code;
                string refFirearmType = _testDataHelper.GetRandomObject<RefFirearmType>(rnd, this.IdsReferenceData.RefFirearmTypes).Code;
                string refWeaponType = _testDataHelper.GetRandomObject<RefWeaponType>(rnd, this.IdsReferenceData.RefWeaponTypes).Code;

                var iepPlacementMeetingIndicator = _testDataHelper.GetRandomObject<bool>(rnd, new List<bool>() { true, false });
                var educationalServicesAfterRemoval = _testDataHelper.GetRandomObject<bool>(rnd, new List<bool>() { true, false });
                string refDisciplineMethodFirearms = _testDataHelper.GetRandomObject<RefDisciplineMethodFirearms>(rnd, this.IdsReferenceData.RefDisciplineMethodFirearms).Code;
                string refIdeadisciplineMethodFirearm = _testDataHelper.GetRandomObject<RefIdeadisciplineMethodFirearm>(rnd, this.IdsReferenceData.RefIdeadisciplineMethodFirearms).Code;

                if (!ideaIndicator)
                {
                    refIdeainterimRemoval = null;
                    refIdeainterimRemovalReason = null;
                    refDisciplineMethodOfCwd = null;

                    refIdeadisciplineMethodFirearm = null;
                }
                else
                {
                    refDisciplineMethodFirearms = null;
                }

                if (refIdeainterimRemoval != "REMDW" && refIdeainterimRemoval != "REMHO")
                {
                    refIdeainterimRemovalReason = null;
                }

                if (refFirearmType != "Handguns" && refFirearmType != "RiflesShotguns" && refFirearmType != "Multiple" && refFirearmType != "Other")
                {
                    // Only set for Weapon Types = firearms
                    refDisciplineMethodFirearms = null;
                    refIdeadisciplineMethodFirearm = null;
                }

                decimal disciplineDuration = (decimal)(rnd.Next(150) * 0.1);

                var numberOfYears = (DateTime.Now.Year + 2) - _testDataProfile.OldestStartingYear;
                //var organizationStartDateTime = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(1920, 1, 1), DateTime.Now.AddYears(-5));

                var incidentDate = _testDataHelper.GetRandomDateInRange(rnd, k12Enrollment.EnrollmentEntryDate.Value, new DateTime(SchoolYear, 6, 20));
                var disciplinaryActionStartDate = _testDataHelper.GetRandomDateInRange(rnd, incidentDate, incidentDate.AddDays(3));
                var disciplinaryActionEndDate = disciplinaryActionStartDate.AddDays((double)disciplineDuration);
                var incidentIdentifier = _testDataHelper.GetRandomIntInRange(rnd, 100000, 999999);

                Discipline discipline = new Discipline()
                {
                    StudentIdentifierState = k12Enrollment.StudentIdentifierState,
                    LeaIdentifierSeaAccountability = k12Enrollment.LeaIdentifierSeaAccountability,
                    SchoolIdentifierSea = k12Enrollment.SchoolIdentifierSea,
                    DisciplinaryActionTaken = refDisciplinaryActionTaken,
                    DurationOfDisciplinaryAction = disciplineDuration.ToString(),
                    DisciplinaryActionStartDate = disciplinaryActionStartDate,
                    DisciplinaryActionEndDate = disciplinaryActionEndDate,
                    DisciplineReason = refDisciplineReason,
                    IdeaInterimRemoval = refIdeainterimRemoval,
                    IdeaInterimRemovalReason = refIdeainterimRemovalReason,
                    EducationalServicesAfterRemoval = educationalServicesAfterRemoval,
                    DisciplineMethodFirearm = refDisciplineMethodFirearms,
                    IDEADisciplineMethodFirearm = refIdeadisciplineMethodFirearm,
                    DisciplineMethodOfCwd = refDisciplineMethodOfCwd,
                    DisciplineActionIdentifier = string.Concat(incidentIdentifier.ToString(), _testDataHelper.GetRandomIntInRange(rnd, 100, 999).ToString()),
                    FirearmType = refFirearmType,
                    IncidentDate = incidentDate,
                    IncidentIdentifier = incidentIdentifier.ToString(),
                    WeaponType = refWeaponType,
                    IncidentTime = _testDataHelper.GetRandomTimeSpan(rnd),
                    SchoolYear = (short)SchoolYear
                };

                AllDisciplines.Add(discipline);

                //for (int i = 0; i < numberOfYears; i++)
                //{

                //    var disciplinaryActionStartDate = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(DateTime.Now.Year - i, 7, 1), new DateTime(DateTime.Now.Year + i, 6, 30));
                //    // GetRandomDateAfter(rnd, (DateTime)enrollmentOrganizationPersonRole.EntryDate, 180, enrollmentOrganizationPersonRole.ExitDate);
                //    var disciplinaryActionEndDate = disciplinaryActionStartDate.AddDays((double)disciplineDuration);
                //    var incidentIdentifier = _testDataHelper.GetRandomIntInRange(rnd, 100000, 999999);


                //    Discipline discipline = new Discipline()
                //    {
                //        StudentIdentifierState = k12Enrollment.StudentIdentifierState,
                //        LeaIdentifierState = k12Enrollment.LeaIdentifierState,
                //        SchoolIdentifierState = k12Enrollment.SchoolIdentifierState,
                //        DisciplinaryActionTaken = refDisciplinaryActionTaken,
                //        DurationOfDisciplinaryAction = disciplineDuration.ToString(),
                //        DisciplinaryActionStartDate = disciplinaryActionStartDate.ToString(),
                //        DisciplinaryActionEndDate = disciplinaryActionEndDate.ToString(),
                //        DisciplineReason = refDisciplineReason,
                //        IdeaInterimRemoval = refIdeainterimRemoval,
                //        IdeaInterimRemovalReason = refIdeainterimRemovalReason,
                //        EducationalServicesAfterRemoval = educationalServicesAfterRemoval,
                //        DisciplineMethodFirearm = refDisciplineMethodFirearms,
                //        IdeadisciplineMethodFirearm = refIdeadisciplineMethodFirearm,
                //        DisciplineMethodOfCwd = refDisciplineMethodOfCwd,
                //        DisciplineActionIdentifier = string.Concat(incidentIdentifier.ToString(), _testDataHelper.GetRandomIntInRange(rnd, 100, 999).ToString()),
                //        FirearmType = refFirearmType,
                //        IncidentDate = _testDataHelper.GetRandomDateInRange(rnd, k12Enrollment.EnrollmentEntryDate.Value, disciplinaryActionStartDate),
                //        IncidentIdentifier = incidentIdentifier.ToString(),
                //        WeaponType = refWeaponType,
                //        IncidentTime = _testDataHelper.GetRandomTimeSpan(rnd),
                //    };

                //    AllDisciplines.Add(discipline);
                //}
            }
        }


        //    public void AppendStaffData(Random rnd, StagingTestDataObject testData, int StaffCount)
        //{
        //    for (int i = 0; i < staffCount; i++)
        //    {
        //        var orgs = _testDataHelper.GetRandomObject(rnd, AllOrganizations.ToList());

        //        var staff = new K12StaffAssignment();

        //        staff.PersonnelIdentifierState = i.ToString().PadLeft(10, '9');
        //        staff.LeaIdentifierState = orgs.LeaIdentifierState;
        //        staff.SchoolIdentifierState = orgs.SchoolIdentifierState;

        //        staff.Sex = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SexDistribution);
        //        staff.LastName = _testDataHelper.GetRandomString(rnd, this.LastNames);

        //        staff.AssignmentStartDate = _testDataHelper.GetRandomDateInRange(rnd, DateTime.Parse("7/1/" + (SchoolYear - 11).ToString()), DateTime.Parse("4/30/" + SchoolYear.ToString()));
        //        staff.AssignmentEndDate = _testDataHelper.GetRandomDateInRange(rnd, DateTime.Parse("7/1/" + (SchoolYear + 1).ToString()), DateTime.Parse("6/30/" + SchoolYear.ToString()));
        //        staff.CredentialIssuanceDate = _testDataHelper.GetRandomDateInRange(rnd, DateTime.Parse("7/1/" + (SchoolYear - 5).ToString()), DateTime.Parse("4/30/" + (SchoolYear - 2).ToString()));
        //        staff.CredentialExpirationDate = _testDataHelper.GetRandomDateInRange(rnd, DateTime.Parse("7/1/" + (SchoolYear + 1).ToString()), DateTime.Parse("4/30/" + (SchoolYear + 5).ToString()));
        //        staff.CredentialType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefCredentialTypeDistribution);
        //        staff.EmergencyorProvisionalCredentialStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefEmergencyOrProvisionalCredentialStatusDistribution);
        //        staff.FullTimeEquivalency = _testDataHelper.GetRandomDecimalInRange(rnd, 25, 100);
        //        staff.HighlyQualifiedTeacherIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HighlyQualifiedDistribution);
        //        staff.InexperiencedStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefUnexperiencedStatusDistribution);
        //        staff.K12staffClassification = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefK12StaffClassificationDistribution);
        //        staff.OutOfFieldStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefOutOfFieldStatusDistribution);

        //        staff.SpecialEducationStaffCategory = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefSpecialEducationStaffCategoryDistribution);
        //        staff.TitleIProgramStaffCategory = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIProgramStaffCategoryDistribution);
        //        staff.ParaprofessionalQualification = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefParaprofessionalQualificationDistribution);
        //        staff.SpecialEducationAgeGroupTaught = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefSpecialEducationAgeGroupTaughtDistribution);
        //        staff.ProgramTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefProgramTypeDistribution);

        //        if (staff.Sex == "Male")
        //        {
        //            staff.FirstName = _testDataHelper.GetRandomString(rnd, this.MaleNames);
        //            staff.MiddleName = _testDataHelper.GetRandomString(rnd, this.MaleNames);
        //        }
        //        else
        //        {
        //            staff.FirstName = _testDataHelper.GetRandomString(rnd, this.FemaleNames);
        //            staff.MiddleName = _testDataHelper.GetRandomString(rnd, this.FemaleNames);
        //        }

        //        //AllK12StaffAssignments.Add(staff);
        //        //testData.K12StaffAssignments.Add(staff);
        //    }
        //}

        public void UpdateRandomizedOrganizationData(StagingTestDataObject testData, Random rnd)
        {
            testData.K12Organizations.ForEach(o =>
            {
                o.School_TitleISchoolStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIschoolStatusDistribution);
                o.School_GunFreeSchoolsActReportingStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefGunFreeSchoolsActReportingStatusDistribution);
                o.School_SchoolDangerousStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefSchoolDangerousStatusDistribution);
                o.School_Type = this.IdsReferenceData.RefSchoolTypes.Single(x => x.RefSchoolTypeId == Convert.ToInt32(o.School_Type)).Code;
                //FS129 columns
                o.School_SharedTimeIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SharedTimeOrganizationIndicatorValueDistribution);
                o.School_VirtualSchoolStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefVirtualSchoolStatusDistribution);
                o.School_NationalSchoolLunchProgramStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefNSLPStatusDistribution);

                if ((bool)o.School_CharterSchoolIndicator == true) {
                    o.School_CharterContractIDNumber = _testDataHelper.GetRandomIntInRange(rnd, 1000, 100000).ToString();
                    DateTime charterContractApprovalDate = _testDataHelper.GetRandomDateInRange(rnd, DateTime.Now.AddYears(-6), DateTime.Now);
                    o.School_CharterContractApprovalDate = charterContractApprovalDate;
                    if(_testDataHelper.GetWeightedSelection(rnd, _testDataProfile.CharterRenewalDistribution))
                    {
                        o.School_CharterContractRenewalDate = _testDataHelper.GetRandomDateInRange(rnd, charterContractApprovalDate, DateTime.Now);
                    }
                }

            });

            //testData.OrganizationPhones.ForEach(p =>
            //{
            //    p.InstitutionTelephoneNumberType = _testDataHelper.GetRandomObject<RefInstitutionTelephoneType>(rnd, this.IdsReferenceData.RefInstitutionTelephoneTypes).Code;
            //});
        }

    }
}
