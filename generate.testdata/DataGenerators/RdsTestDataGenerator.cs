using generate.core.Helpers.ReferenceData;
using generate.core.Helpers.TestDataHelper;
using generate.core.Models.IDS;
using generate.core.Models.RDS;
using generate.shared.Utilities;
using generate.testdata.Interfaces;
using Newtonsoft.Json;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace generate.testdata.DataGenerators
{
    public class RdsTestDataGenerator : IRdsTestDataGenerator
    {

        private readonly IOutputHelper _outputHelper;
        private readonly ITestDataHelper _testDataHelper;
        private readonly IRdsTestDataProfile _testDataProfile;


        public RdsReferenceData RdsReferenceData { get; private set; }


        public string FilePath { get; set; }
        public string FormatType { get; set; }
        public string OutputType { get; set; }
        public int Seed { get; set; }
        public Random GlobalRandom { get; set; }  // Will need to be replaced if parallel tasks are ever implemented

        public ConcurrentDictionary<string, int> MaxIds { get; set; }
        public ConcurrentBag<string> ScriptsToExecute { get; set; }



        public int TotalLeasCreated { get; set; }
        public int TotalSchoolsCreated { get; set; }
        public int TotalStudentsCreated { get; set; }
        public int TotalPersonnelCreated { get; set; }

        // Common test data
        public List<string> LastNames { get; private set; }
        public List<string> FemaleNames { get; private set; }
        public List<string> MaleNames { get; private set; }
        public List<string> FirstNames { get; private set; }
        public List<string> PlaceNames { get; private set; }
        public List<string> StreetTypes { get; private set; }
        public List<string> OperationalStatuses { get; private set; }


        public List<DimSea> AllDimSeas { get; set; }
        public List<DimLea> AllDimLeas { get; set; }
        public List<DimK12School> AllDimSchools { get; set; }
        public List<DimK12Student> AllDimStudents { get; set; }
        public List<DimK12Staff> AllDimPersonnel { get; set; }

        public List<DimCharterSchoolAuthorizer> AllDimCharterSchoolAuthorizers { get; set; }


        public RdsTestDataGenerator(
            IOutputHelper outputHelper,
            ITestDataHelper testDataHelper,
            IRdsTestDataProfile testDataProfile
        )
        {
            _outputHelper = outputHelper ?? throw new ArgumentNullException(nameof(outputHelper));
            _testDataHelper = testDataHelper ?? throw new ArgumentNullException(nameof(testDataHelper));
            _testDataProfile = testDataProfile ?? throw new ArgumentNullException(nameof(testDataProfile));
        }


        /// <summary>
        /// Generate test data
        /// </summary>
        /// <param name="seed"></param>
        public StringBuilder GenerateTestData(int seed, int quantityOfStudents, string formatType, string outputType, string filePath)
        {
            //    this.GlobalRandom = new Random(this.Seed);
            //    Random rnd = this.GlobalRandom;


            //    _outputHelper.DeleteExistingFiles("rds", filePath);

            //    this.InitializeVariables(filePath, seed, formatType, outputType);

            //    // Begin Output

            StringBuilder output = new StringBuilder();

            //    // Organizations                      
            //    var sectionName = "01_0001_DimSeas_DimLeas_DimSchools";
            //    if (this.FormatType == "c#")
            //    {
            //        sectionName = "DimSeasLeasSchools";
            //    }
            //    RdsTestDataObject testData = this.GetFreshTestDataObject();
            //    testData = CreateOrganizations(testData, quantityOfStudents);

            //    output = _outputHelper.CreateStartOutput(sectionName, quantityOfStudents, this.FormatType, this.Seed, "rds");
            //    if (this.FormatType == "sql")
            //    {
            //        output = _outputHelper.AddSqlDeletesToOutput(output, "rds");
            //    }
            //    output = this.AddTestDataToOutput(testData, output, sectionName, "DimSeas / DimLeas / DimSchools Data", false);
            //    output = _outputHelper.AddEndToOutput(output, this.FormatType);
            //    _outputHelper.WriteOutput(output, "rds", this.FormatType, this.OutputType, this.FilePath, sectionName);
            //    if (this.FormatType == "sql")
            //    {
            //        this.ScriptsToExecute.Add("RdsTestData_" + sectionName + ".sql");
            //    }

            //    // DimStudents
            //    sectionName = "01_0002_DimStudents";
            //    if (this.FormatType == "c#")
            //    {
            //        sectionName = "DimStudents";
            //    }
            //    testData = this.GetFreshTestDataObject();
            //    testData = CreateDimStudents(testData, quantityOfStudents);

            //    output = _outputHelper.CreateStartOutput(sectionName, quantityOfStudents, this.FormatType, this.Seed, "rds");
            //    output = this.AddTestDataToOutput(testData, output, sectionName, "DimStudents Data", false);
            //    output = _outputHelper.AddEndToOutput(output, this.FormatType);
            //    _outputHelper.WriteOutput(output, "rds", this.FormatType, this.OutputType, this.FilePath, sectionName);
            //    if (this.FormatType == "sql")
            //    {
            //        this.ScriptsToExecute.Add("RdsTestData_" + sectionName + ".sql");
            //    }

            //    // DimPersonnel
            //    int studentTeacherRatio = _testDataHelper.GetRandomIntInRange(rnd, _testDataProfile.MinimumStudentTeacherRatio, _testDataProfile.MaximumStudentsTeacherRatio);

            //    int quantityOfPersonnel = quantityOfStudents / studentTeacherRatio;

            //    if (quantityOfPersonnel < 1)
            //    {
            //        quantityOfPersonnel = 1;
            //    }

            //    sectionName = "01_0003_DimPersonnel";
            //    if (this.FormatType == "c#")
            //    {
            //        sectionName = "DimPersonnel";
            //    }
            //    testData = this.GetFreshTestDataObject();
            //    testData = CreateDimPersonnel(testData, quantityOfPersonnel);

            //    output = _outputHelper.CreateStartOutput(sectionName, quantityOfPersonnel, this.FormatType, this.Seed, "rds");
            //    output = this.AddTestDataToOutput(testData, output, sectionName, "DimPersonnel Data", false);
            //    output = _outputHelper.AddEndToOutput(output, this.FormatType);
            //    _outputHelper.WriteOutput(output, "rds", this.FormatType, this.OutputType, this.FilePath, sectionName);
            //    if (this.FormatType == "sql")
            //    {
            //        this.ScriptsToExecute.Add("RdsTestData_" + sectionName + ".sql");
            //    }


            //    // DimCharterSchoolAuthorizers
            //    sectionName = "01_0004_DimCharterSchoolAuthorizers";
            //    if (this.FormatType == "c#")
            //    {
            //        sectionName = "DimCharterSchoolAuthorizers";
            //    }
            //    testData = this.GetFreshTestDataObject();
            //    testData = CreateDimCharterSchoolAuthorizers(testData);

            //    output = _outputHelper.CreateStartOutput(sectionName, quantityOfStudents, this.FormatType, this.Seed, "rds");
            //    output = this.AddTestDataToOutput(testData, output, sectionName, "DimCharterSchoolAuthorizers Data", false);
            //    output = _outputHelper.AddEndToOutput(output, this.FormatType);
            //    _outputHelper.WriteOutput(output, "rds", this.FormatType, this.OutputType, this.FilePath, sectionName);
            //    if (this.FormatType == "sql")
            //    {
            //        this.ScriptsToExecute.Add("RdsTestData_" + sectionName + ".sql");
            //    }

            //    // Facts
            //    int batchSize = _testDataProfile.BatchSize;

            //    if (this.FormatType == "c#")
            //    {
            //        batchSize = 200;
            //    }

            //    int numberOfBatches = (int)Math.Ceiling((decimal)quantityOfStudents / (decimal)batchSize);



            //    // FactStudentCounts
            //    for (int batchNumber = 0; batchNumber < numberOfBatches; batchNumber++)
            //    {
            //        sectionName = "02_0001_" + (batchNumber + 1).ToString().PadLeft(2, '0') + "_FactStudentCounts";
            //        if (this.FormatType == "c#")
            //        {
            //            sectionName = "FactStudentCounts_" + (batchNumber + 1).ToString().PadLeft(2, '0');
            //        }
            //        testData = this.GetFreshTestDataObject();
            //        testData = CreateFactStudentCounts(testData, (batchNumber * batchSize), (batchNumber * batchSize) + batchSize - 1);

            //        output = _outputHelper.CreateStartOutput(sectionName, quantityOfStudents, this.FormatType, this.Seed, "rds");
            //        output = this.AddTestDataToOutput(testData, output, sectionName, "FactStudentCounts Data", false);
            //        output = _outputHelper.AddEndToOutput(output, this.FormatType);
            //        _outputHelper.WriteOutput(output, "rds", this.FormatType, this.OutputType, this.FilePath, sectionName);
            //        if (this.FormatType == "sql")
            //        {
            //            this.ScriptsToExecute.Add("RdsTestData_" + sectionName + ".sql");
            //        }
            //    }



            //    // FactStudentDisciplines
            //    for (int batchNumber = 0; batchNumber < numberOfBatches; batchNumber++)
            //    {

            //        sectionName = "02_0002_" + (batchNumber + 1).ToString().PadLeft(2, '0') + "_FactStudentDisciplines";
            //        if (this.FormatType == "c#")
            //        {
            //            sectionName = "FactStudentDisciplines_" + (batchNumber + 1).ToString().PadLeft(2, '0');
            //        }
            //        testData = this.GetFreshTestDataObject();
            //        testData = CreateFactStudentDisciplines(testData, (batchNumber * batchSize), (batchNumber * batchSize) + batchSize - 1);

            //        output = _outputHelper.CreateStartOutput(sectionName, quantityOfStudents, this.FormatType, this.Seed, "rds");
            //        output = this.AddTestDataToOutput(testData, output, sectionName, "FactStudentDisciplines Data", false);
            //        output = _outputHelper.AddEndToOutput(output, this.FormatType);
            //        _outputHelper.WriteOutput(output, "rds", this.FormatType, this.OutputType, this.FilePath, sectionName);
            //        if (this.FormatType == "sql")
            //        {
            //            this.ScriptsToExecute.Add("RdsTestData_" + sectionName + ".sql");
            //        }
            //    }

            //    // FactStudentAssessments
            //    for (int batchNumber = 0; batchNumber < numberOfBatches; batchNumber++)
            //    {

            //        sectionName = "02_0003_" + (batchNumber + 1).ToString().PadLeft(2, '0') + "_FactStudentAssessments";
            //        if (this.FormatType == "c#")
            //        {
            //            sectionName = "FactStudentAssessments_" + (batchNumber + 1).ToString().PadLeft(2, '0');
            //        }
            //        testData = this.GetFreshTestDataObject();
            //        testData = CreateFactStudentAssessments(testData, (batchNumber * batchSize), (batchNumber * batchSize) + batchSize - 1);

            //        output = _outputHelper.CreateStartOutput(sectionName, quantityOfStudents, this.FormatType, this.Seed, "rds");
            //        output = this.AddTestDataToOutput(testData, output, sectionName, "FactStudentAssessments Data", false);
            //        output = _outputHelper.AddEndToOutput(output, this.FormatType);
            //        _outputHelper.WriteOutput(output, "rds", this.FormatType, this.OutputType, this.FilePath, sectionName);
            //        if (this.FormatType == "sql")
            //        {
            //            this.ScriptsToExecute.Add("RdsTestData_" + sectionName + ".sql");
            //        }
            //    }

            //    // FactPersonnelCounts
            //    sectionName = "02_0004_FactPersonnelCounts";
            //    if (this.FormatType == "c#")
            //    {
            //        sectionName = "FactPersonnelCounts";
            //    }
            //    testData = this.GetFreshTestDataObject();
            //    testData = CreateFactPersonnelCounts(testData);

            //    output = _outputHelper.CreateStartOutput(sectionName, quantityOfStudents, this.FormatType, this.Seed, "rds");
            //    output = this.AddTestDataToOutput(testData, output, sectionName, "FactPersonnelCounts Data", false);
            //    output = _outputHelper.AddEndToOutput(output, this.FormatType);
            //    _outputHelper.WriteOutput(output, "rds", this.FormatType, this.OutputType, this.FilePath, sectionName);
            //    if (this.FormatType == "sql")
            //    {
            //        this.ScriptsToExecute.Add("RdsTestData_" + sectionName + ".sql");
            //    }

            //    // FactOrganizationCounts
            //    sectionName = "02_0005_FactOrganizationCounts";
            //    if (this.FormatType == "c#")
            //    {
            //        sectionName = "FactOrganizationCounts";
            //    }
            //    testData = this.GetFreshTestDataObject();
            //    testData = CreateFactOrganizationCounts(testData);

            //    output = _outputHelper.CreateStartOutput(sectionName, quantityOfStudents, this.FormatType, this.Seed, "rds");
            //    output = this.AddTestDataToOutput(testData, output, sectionName, "FactOrganizationCounts Data", false);
            //    output = _outputHelper.AddEndToOutput(output, this.FormatType);
            //    _outputHelper.WriteOutput(output, "rds", this.FormatType, this.OutputType, this.FilePath, sectionName);
            //    if (this.FormatType == "sql")
            //    {
            //        this.ScriptsToExecute.Add("RdsTestData_" + sectionName + ".sql");
            //    }

            //    // FactOrganizationStatusCounts
            //    sectionName = "02_0006_FactOrganizationStatusCounts";
            //    if (this.FormatType == "c#")
            //    {
            //        sectionName = "FactOrganizationStatusCounts";
            //    }
            //    testData = this.GetFreshTestDataObject();
            //    testData = CreateFactOrganizationStatusCounts(testData);

            //    output = _outputHelper.CreateStartOutput(sectionName, quantityOfStudents, this.FormatType, this.Seed, "rds");
            //    output = this.AddTestDataToOutput(testData, output, sectionName, "FactOrganizationStatusCounts Data", false);
            //    output = _outputHelper.AddEndToOutput(output, this.FormatType);
            //    _outputHelper.WriteOutput(output, "rds", this.FormatType, this.OutputType, this.FilePath, sectionName);
            //    if (this.FormatType == "sql")
            //    {
            //        this.ScriptsToExecute.Add("RdsTestData_" + sectionName + ".sql");
            //    }


            //    // FactCustomCounts
            //    sectionName = "02_0007_FactCustomCounts";
            //    if (this.FormatType == "c#")
            //    {
            //        sectionName = "FactCustomCounts";
            //    }
            //    testData = this.GetFreshTestDataObject();
            //    testData = CreateFactCustomCounts(testData);

            //    output = _outputHelper.CreateStartOutput(sectionName, quantityOfStudents, this.FormatType, this.Seed, "rds");
            //    output = this.AddTestDataToOutput(testData, output, sectionName, "FactCustomCounts Data", false);
            //    output = _outputHelper.AddEndToOutput(output, this.FormatType);
            //    _outputHelper.WriteOutput(output, "rds", this.FormatType, this.OutputType, this.FilePath, sectionName);
            //    if (this.FormatType == "sql")
            //    {
            //        this.ScriptsToExecute.Add("RdsTestData_" + sectionName + ".sql");
            //    }


            //    // Finish up


            //    if (this.OutputType != "console")
            //    {
            //        Console.WriteLine("");
            //        Console.WriteLine("======================");
            //        Console.WriteLine("Total LEAs = " + this.TotalLeasCreated);
            //        Console.WriteLine("Total Schools = " + this.TotalSchoolsCreated);
            //        Console.WriteLine("Total Students = " + this.TotalStudentsCreated);
            //        Console.WriteLine("Total Personnel = " + this.TotalPersonnelCreated);
            //        Console.WriteLine("======================");
            //    }


            //    if (this.FormatType == "sql")
            //    {
            //        var powershellScriptOutput = _outputHelper.CreateSqlPowershellScript(this.ScriptsToExecute.ToList());
            //        _outputHelper.WriteOutput(powershellScriptOutput, "rds", "powershell", this.OutputType, this.FilePath);
            //    }


            return output;
        }

        private void InitializeVariables(string filePath = null, int? seed = null, string formatType = null, string outputType = null)
        {
            this.FilePath = filePath;

            this.RdsReferenceData = new RdsReferenceData();


            this.LastNames = _testDataHelper.ListofLastNames();
            this.MaleNames = _testDataHelper.ListofMaleNames();
            this.FemaleNames = _testDataHelper.ListofFemaleNames();
            this.FirstNames = this.MaleNames.Union(this.FemaleNames).ToList();
            this.PlaceNames = _testDataHelper.ListofPlaceNames();
            this.StreetTypes = _testDataHelper.ListofStreetTypes();


            if (seed.HasValue)
            {
                this.Seed = (int)seed;
            }
            

            if (formatType != null)
            {
                this.FormatType = formatType;
            }

            if (outputType != null)
            {
                this.OutputType = outputType;
            }

            if (this.ScriptsToExecute == null)
            {
                this.ScriptsToExecute = new ConcurrentBag<string>();
            }

            if (this.MaxIds == null)
            {
                this.MaxIds = new ConcurrentDictionary<string, int>();
            }

            if (this.AllDimSeas == null)
            {
                this.AllDimSeas = new List<DimSea>();
            }
            if (this.AllDimLeas == null)
            {
                this.AllDimLeas = new List<DimLea>();
            }

            if (this.AllDimSchools == null)
            {
                this.AllDimSchools = new List<DimK12School>();
            }
            if (this.AllDimStudents == null)
            {
                this.AllDimStudents = new List<DimK12Student>();
            }
            if (this.AllDimPersonnel == null)
            {
                this.AllDimPersonnel = new List<DimK12Staff>();
            }

            if (this.AllDimCharterSchoolAuthorizers == null)
            {
                this.AllDimCharterSchoolAuthorizers = new List<DimCharterSchoolAuthorizer>();
            }
        }
        
        public RdsTestDataObject GetFreshTestDataObject(int seaOrganizationId = 0)
        {
            this.InitializeVariables();

            RdsTestDataObject testData = new RdsTestDataObject()
            {
                TestDatatype = "rds",
                DimSeas = new List<DimSea>(),
                DimLeas = new List<DimLea>(),
                DimSchools = new List<DimK12School>(),
                DimStudents = new List<DimK12Student>(),
                DimPersonnel = new List<DimK12Staff>(),
                DimCharterSchoolAuthorizers = new List<DimCharterSchoolAuthorizer>(),
                FactStudentCounts = new List<FactK12StudentCount>(),
                FactStudentDisciplines = new List<FactK12StudentDiscipline>(),
                FactStudentAssessments = new List<FactK12StudentAssessment>(),
                FactPersonnelCounts = new List<FactK12StaffCount>(),
                FactOrganizationCounts = new List<FactOrganizationCount>(),
                FactOrganizationStatusCounts = new List<FactOrganizationStatusCount>(),
                FactCustomCounts = new List<FactCustomCount>()
            };

            return testData;
        }

        private StringBuilder AddTestDataToOutput(RdsTestDataObject testData, StringBuilder output, string sectionName, string sectionDescription, bool isLastSection)
        {
            testData.TestDataSection = sectionName;
            testData.TestDataSectionDescription = sectionDescription;

            if (this.FormatType == "sql")
            {
                output.AppendLine("--------------------------");
                output.AppendLine("-- " + sectionName + " / " + sectionDescription);
                output.AppendLine("--------------------------");


                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.DimSeas.ToArray(), typeof(DimSea), "DimSeas", "rds", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.DimLeas.ToArray(), typeof(DimLea), "DimLeas", "rds", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.DimSchools.ToArray(), typeof(DimK12School), "DimSchools", "rds", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.DimStudents.ToArray(), typeof(DimK12Student), "DimStudents", "rds", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.DimPersonnel.ToArray(), typeof(DimK12Staff), "DimPersonnel", "rds", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.DimCharterSchoolAuthorizers.ToArray(), typeof(DimCharterSchoolAuthorizer), "DimCharterSchoolAuthorizer", "rds", true));

                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.FactStudentCounts.ToArray(), typeof(FactK12StudentCount), "FactStudentCounts", "rds", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.FactStudentDisciplines.ToArray(), typeof(FactK12StudentDiscipline), "FactStudentDisciplines", "rds", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.FactStudentAssessments.ToArray(), typeof(FactK12StudentAssessment), "FactStudentAssessments", "rds", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.FactPersonnelCounts.ToArray(), typeof(FactK12StaffCount), "FactPersonnelCounts", "rds", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.FactOrganizationCounts.ToArray(), typeof(FactOrganizationCount), "FactOrganizationCounts", "rds", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.FactOrganizationStatusCounts.ToArray(), typeof(FactOrganizationStatusCount), "FactOrganizationStatusCounts", "rds", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.FactCustomCounts.ToArray(), typeof(FactCustomCount), "FactCustomCounts", "rds", true));

            }
            else if (this.FormatType == "c#")
            {

                output.AppendLine();
                output.AppendLine("         testData = new RdsTestDataObject()");
                output.AppendLine("         {");

                output.AppendLine("             TestDataSection = \"" + testData.TestDataSection + "\",");
                output.AppendLine("             TestDataSectionDescription = \"" + testData.TestDataSectionDescription + "\",");

                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.DimSeas.ToArray(), typeof(DimSea), "DimSeas", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.DimLeas.ToArray(), typeof(DimLea), "DimLeas", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.DimSchools.ToArray(), typeof(DimK12School), "DimSchools", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.DimStudents.ToArray(), typeof(DimK12Student), "DimStudents", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.DimPersonnel.ToArray(), typeof(DimK12Staff), "DimPersonnel", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.DimCharterSchoolAuthorizers.ToArray(), typeof(DimCharterSchoolAuthorizer), "DimCharterSchoolAuthorizers", ","));

                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.FactStudentCounts.ToArray(), typeof(FactK12StudentCount), "FactStudentCounts", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.FactStudentDisciplines.ToArray(), typeof(FactK12StudentDiscipline), "FactStudentDisciplines", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.FactStudentAssessments.ToArray(), typeof(FactK12StudentAssessment), "FactStudentAssessments", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.FactPersonnelCounts.ToArray(), typeof(FactK12StaffCount), "FactPersonnelCounts", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.FactOrganizationCounts.ToArray(), typeof(FactOrganizationCount), "FactOrganizationCounts", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.FactOrganizationStatusCounts.ToArray(), typeof(FactOrganizationStatusCount), "FactOrganizationStatusCounts", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.FactCustomCounts.ToArray(), typeof(FactCustomCount), "FactCustomCounts", ""));


                output.AppendLine("         };");
                output.AppendLine();

            }
            else
            {
                // Default to JSON
                JsonSerializerSettings jsonSerializerSettings = new JsonSerializerSettings
                {
                    NullValueHandling = NullValueHandling.Ignore,
                    DefaultValueHandling = DefaultValueHandling.Ignore,
                    ReferenceLoopHandling = ReferenceLoopHandling.Ignore,
                    ContractResolver = DoNotSerializeIfEmptyResolver.Instance
                };


                string commaValue = "";
                if (!isLastSection)
                {
                    commaValue = ",";
                }

                output.AppendLine(JsonConvert.SerializeObject(testData, Formatting.Indented, jsonSerializerSettings) + commaValue);
            }

            return output;
        }

        private int SetAndGetMaxId(string fieldKey)
        {
            return this.MaxIds.AddOrUpdate(fieldKey, 1, (key, oldValue) => oldValue + 1);
        }
        
        private RdsTestDataObject CreateOrganizations(RdsTestDataObject testData, int quantityOfStudents)
        {
            Random rnd = this.GlobalRandom;

            // Reference Data

            var placeNames = _testDataHelper.ListofPlaceNames();
            var schoolTypes = _testDataHelper.ListofSchoolNameTypes();

            // Add missing

            var dimSea = new DimSea()
            {
                DimSeaId = -1,
                SeaName = "MISSING"
            };
            testData.DimSeas.Add(dimSea);
            this.AllDimSeas.Add(dimSea);

            var dimLea = new DimLea()
            {
                DimLeaID = -1,
                LeaName = "MISSING"
            };
            testData.DimLeas.Add(dimLea);
            this.AllDimLeas.Add(dimLea);

            var dimSchool = new DimK12School()
            {
                DimK12SchoolId = -1,
                NameOfInstitution = "MISSING"
            };
            testData.DimSchools.Add(dimSchool);
            this.AllDimSchools.Add(dimSchool);


            int quantityOfSeas = _testDataProfile.QuantityOfSeas;
            int averageStudentsPerLea = _testDataHelper.GetRandomIntInRange(rnd, _testDataProfile.MinimumAverageStudentsPerLea, _testDataProfile.MaximumAverageStudentsPerLea);
            int quantityOfLeas = (int)Math.Ceiling((decimal)quantityOfStudents / (decimal)averageStudentsPerLea);
            
            for (int seaCounter = 0; seaCounter < quantityOfSeas; seaCounter++)
            {
                var state = _testDataHelper.GetRandomObject<RefState>(rnd, this.RdsReferenceData.RefStates);
                var seaName = _testDataHelper.GetK12SeaName(state.Description);
                var refStateAnsicode = this.RdsReferenceData.RefStateAnsicodes.FirstOrDefault(x => x.StateName == state.Description);
                var seaOrganizationId = int.Parse(refStateAnsicode.Code);
                var streetNumberAndName = _testDataHelper.GetRandomIntInRange(rnd, 1, 20000) + " " + _testDataHelper.GetStreetName(rnd, this.PlaceNames, this.StreetTypes);
                var postalCode = _testDataHelper.GetRandomIntInRange(rnd, 10000, 90000).ToString();
                var city = _testDataHelper.GetCityName(rnd, this.PlaceNames);
                var website = "https://www." + _testDataHelper.MakeAcronym(dimSea.SeaName).ToLower() + ".org";
                var telephone = _testDataHelper.GetRandomIntInRange(rnd, 100, 700) + "-" + _testDataHelper.GetRandomIntInRange(rnd, 100, 700) + "-" + _testDataHelper.GetRandomIntInRange(rnd, 100, 700);
                var startDate = _testDataHelper.GetRandomDate(rnd, 10);

                dimSea = new DimSea()
                {
                    DimSeaId = this.SetAndGetMaxId("DimSeas"),
                    SeaName = seaName,
                    SeaOrganizationId = seaOrganizationId,
                    StateAnsiCode = refStateAnsicode.Code,
                    StateAbbreviationCode = state.Code,
                    SeaIdentifierState = seaOrganizationId.ToString(),
                    StateAbbreviationDescription = state.Description,
                    MailingAddressStreet = streetNumberAndName,
                    MailingAddressCity = city,
                    MailingAddressState = dimSea.StateAbbreviationCode,
                    MailingAddressPostalCode = postalCode,
                    PhysicalAddressStreet = streetNumberAndName,
                    PhysicalAddressCity = city,
                    PhysicalAddressState = dimSea.StateAbbreviationCode,
                    PhysicalAddressPostalCode = postalCode,
                    Website = website,
                    Telephone = telephone,
                    RecordStartDateTime = startDate

                };
                testData.DimSeas.Add(dimSea);
                this.AllDimSeas.Add(dimSea);

                for (int leaCounter = 0; leaCounter < quantityOfLeas; leaCounter++)
                {
                    var leaName = _testDataHelper.GetK12LeaName(rnd, placeNames);
                    var leaOrganizationId = _testDataHelper.GetRandomIntInRange(rnd, 1000, 9999);

                    // Ensure leaOrganizationId is not already used
                    //while (this.AllDimLeas.Any(x => x.LeaOrganizationId == leaOrganizationId))
                    //{
                    //    leaOrganizationId = _testDataHelper.GetRandomIntInRange(rnd, 1000, 9999);
                    //}


                    var leaNcesId = refStateAnsicode.Code + leaOrganizationId.ToString().PadLeft(5, '0');
                    var leaEffectiveDate = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(1920, 1, 1), DateTime.Now.AddYears(-5));
                    var isSupervisoryUnion = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IsSupervisoryUnionDistribution);
                    var isReportedFederally = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IsReportedFederallyDistribution);
                    var leaHasNcesId = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LeaHasNcesIdDistribution);
                    streetNumberAndName = _testDataHelper.GetRandomIntInRange(rnd, 1, 20000) + " " + _testDataHelper.GetStreetName(rnd, this.PlaceNames, this.StreetTypes);
                    postalCode = _testDataHelper.GetRandomIntInRange(rnd, 10000, 90000).ToString();
                    city = _testDataHelper.GetCityName(rnd, this.PlaceNames);
                    website = "https://www." + _testDataHelper.MakeAcronym(dimLea.LeaName).ToLower() + ".org";
                    telephone = _testDataHelper.GetRandomIntInRange(rnd, 100, 700) + "-" + _testDataHelper.GetRandomIntInRange(rnd, 100, 700) + "-" + _testDataHelper.GetRandomIntInRange(rnd, 100, 700);
                    var refLeaType = _testDataHelper.GetRandomObject<RefLeaType>(rnd, this.RdsReferenceData.RefLeaTypes);
                    var isCharterLea = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IsCharterSchoolDistribution);
                    var leaoperationalStatus = _testDataHelper.GetRandomObject<RefOperationalStatus>(rnd, this.RdsReferenceData.RefLeaOperationalStatuses);
                    startDate = _testDataHelper.GetRandomDate(rnd, 10);

                    string supervisoryUnionNumber = null;
                    if (isSupervisoryUnion)
                    {
                        supervisoryUnionNumber = _testDataHelper.GetRandomIntInRange(rnd, 100, 999).ToString();
                    }

                    if (!leaHasNcesId)
                    {
                        leaNcesId = null;
                    }

                    dimLea = new DimLea()
                    {
                        DimLeaID = this.SetAndGetMaxId("DimLeas"),
                        StateAbbreviationCode = state.Code,
                        StateAbbreviationDescription = state.Description,
                        StateAnsiCode = seaOrganizationId.ToString(),
                        //SeaOrganizationId = seaOrganizationId,
                        SeaName = state.Description + " Department of Education",
                        SeaIdentifierState = seaOrganizationId.ToString(),
                        LeaName = leaName,
                        //LeaOrganizationId = leaOrganizationId,
                        LeaIdentifierNces = leaNcesId,
                        LeaIdentifierState = leaOrganizationId.ToString(),
                        LeaSupervisoryUnionIdentificationNumber = supervisoryUnionNumber,
                        ReportedFederally = isReportedFederally,
                        OperationalStatusEffectiveDate = leaEffectiveDate,
                        PriorLeaIdentifierState = leaHasNcesId ? leaOrganizationId.ToString() : null,
                        MailingAddressStreet = streetNumberAndName,
                        MailingAddressCity = city,
                        MailingAddressState = dimSea.StateAbbreviationCode,
                        MailingAddressPostalCode = postalCode,
                        OutOfStateIndicator = dimLea.StateAbbreviationCode != dimSea.StateAbbreviationCode,
                        PhysicalAddressStreet = streetNumberAndName,
                        PhysicalAddressCity = city,
                        PhysicalAddressState = dimSea.StateAbbreviationCode,
                        PhysicalAddressPostalCode = postalCode,
                        Website = website,
                        Telephone = telephone,
                        LeaTypeId = refLeaType.RefLeaTypeId,
                        LeaTypeCode = refLeaType.Code,
                        LeaTypeDescription = refLeaType.Description,
                        LeaTypeEdFactsCode = refLeaType.Code,
                        LeaOperationalStatus = leaoperationalStatus.Code,
                        LeaOperationalStatusEdFactsCode = leaoperationalStatus.RefOperationalStatusId.ToString(),
                        RecordStartDateTime = startDate
                    };
                    testData.DimLeas.Add(dimLea);
                    this.AllDimLeas.Add(dimLea);
                    this.TotalLeasCreated++;

                    string leaGeographicType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LeaGeographicDistribution);
                    int numberOfSchoolsInLea = _testDataHelper.GetRandomIntInRange(rnd, _testDataProfile.MinimumSchoolsPerLeaRural, _testDataProfile.MaximumSchoolsPerLeaRural);
                    if (leaGeographicType == "Urban")
                    {
                        numberOfSchoolsInLea = _testDataHelper.GetRandomIntInRange(rnd, _testDataProfile.MinimumSchoolsPerLeaUrban, _testDataProfile.MaximumSchoolsPerLeaUrban);
                    }

                    for (int schoolCounter = 0; schoolCounter < numberOfSchoolsInLea; schoolCounter++)
                    {
                        var schoolOrganizationId = _testDataHelper.GetRandomIntInRange(rnd, 100000, 999999);

                        //while (this.AllDimSchools.Any(x => x.SchoolOrganizationId == schoolOrganizationId))
                        //{
                        //    schoolOrganizationId = _testDataHelper.GetRandomIntInRange(rnd, 100000, 999999);
                        //}

                        var schoolNcesId = refStateAnsicode.Code + schoolOrganizationId.ToString().PadLeft(8, '0');
                        var schoolEffectiveDate = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(1920, 1, 1), DateTime.Now.AddYears(-5));
                        var schoolHasNcesId = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SchoolHasNcesIdDistribution);
                        streetNumberAndName = _testDataHelper.GetRandomIntInRange(rnd, 1, 20000) + " " + _testDataHelper.GetStreetName(rnd, this.PlaceNames, this.StreetTypes);
                        postalCode = _testDataHelper.GetRandomIntInRange(rnd, 10000, 90000).ToString();
                        city = _testDataHelper.GetCityName(rnd, this.PlaceNames);
                        website = "https://www." + _testDataHelper.MakeAcronym(dimSchool.NameOfInstitution).ToLower() + ".org";
                        telephone = _testDataHelper.GetRandomIntInRange(rnd, 100, 700) + "-" + _testDataHelper.GetRandomIntInRange(rnd, 100, 700) + "-" + _testDataHelper.GetRandomIntInRange(rnd, 100, 700);
                        var refSchoolType = _testDataHelper.GetRandomObject<RefSchoolType>(rnd, this.RdsReferenceData.RefSchoolTypes);
                        var schoolOperationalStatus = _testDataHelper.GetRandomObject<RefOperationalStatus>(rnd, this.RdsReferenceData.RefSchoolOperationalStatuses);
                        startDate = _testDataHelper.GetRandomDate(rnd, 10);

                        bool isCharterSchool = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IsCharterSchoolDistribution);

                        if (!schoolHasNcesId)
                        {
                            schoolNcesId = null;
                        }

                        dimSchool = new DimK12School()
                        {
                            DimK12SchoolId = this.SetAndGetMaxId("DimSchools"),
                            StateAbbreviationCode = state.Code,
                            StateAbbreviationDescription = state.Description,
                            StateAnsiCode = seaOrganizationId.ToString(),
                            //SeaOrganizationId = seaOrganizationId,
                            SeaName = state.Description + " Department of Education",
                            SeaIdentifierState = seaOrganizationId.ToString(),
                            //LeaOrganizationId = leaOrganizationId,
                            LeaIdentifierNces = leaNcesId,
                            LeaIdentifierState = leaOrganizationId.ToString(),
                            LeaName = leaName,
                            //SchoolOrganizationId = schoolOrganizationId,
                            SchoolIdentifierNces = leaNcesId + schoolNcesId,
                            SchoolIdentifierState = schoolOrganizationId.ToString(),
                            NameOfInstitution = _testDataHelper.GetK12SchoolName(rnd, placeNames, schoolTypes),
                            PriorLeaIdentifierState = leaOrganizationId.ToString(),
                            PriorSchoolIdentifierState = schoolOrganizationId.ToString(),      
                            ReportedFederally = isReportedFederally,
                            OperationalStatusEffectiveDate = schoolEffectiveDate,
                            CharterSchoolIndicator = isCharterSchool,
                            MailingAddressStreet = streetNumberAndName,
                            MailingAddressCity = city,
                            MailingAddressState = dimSea.StateAbbreviationCode,
                            MailingAddressPostalCode = postalCode,
                            OutOfStateIndicator = dimSchool.StateAbbreviationCode != dimSea.StateAbbreviationCode,
                            PhysicalAddressStreet = streetNumberAndName,
                            PhysicalAddressCity = city,
                            PhysicalAddressState = dimSea.StateAbbreviationCode,
                            PhysicalAddressPostalCode = postalCode,
                            Website = website,
                            Telephone = telephone,
                            LeaTypeId = refLeaType.RefLeaTypeId,
                            LeaTypeCode = refLeaType.Code,
                            LeaTypeDescription = refLeaType.Description,
                            LeaTypeEdFactsCode = refLeaType.Code,
                            SchoolTypeId = refSchoolType.RefSchoolTypeId,
                            SchoolTypeCode = refSchoolType.Code,
                            SchoolTypeDescription = refSchoolType.Description,
                            SchoolTypeEdFactsCode = refSchoolType.Code,
                            SchoolOperationalStatus = schoolOperationalStatus.Code,
                            SchoolOperationalStatusEdFactsCode = schoolOperationalStatus.RefOperationalStatusId.ToString(),
                            RecordStartDateTime = startDate
                        };

                        if (isCharterSchool)
                        {
                            dimSchool.CharterSchoolContractIdNumber = "ct" + _testDataHelper.GetRandomIntInRange(rnd, 1, 1000).ToString();
                            dimSchool.CharterSchoolContractApprovalDate = _testDataHelper.GetRandomDateInRange(rnd, DateTime.Now.AddYears(-10), DateTime.Now).ToShortDateString();
                            dimSchool.CharterSchoolContractRenewalDate = _testDataHelper.GetRandomDateAfter(rnd, DateTime.Now, 720).ToShortDateString();
                            dimSchool.CharterSchoolAuthorizerIdPrimary = _testDataHelper.GetRandomIntInRange(rnd, 100000, 999999).ToString();
                            dimSchool.CharterSchoolAuthorizerIdSecondary = _testDataHelper.GetRandomIntInRange(rnd, 100000, 999999).ToString();
                        }

                        testData.DimSchools.Add(dimSchool);
                        this.AllDimSchools.Add(dimSchool);
                        this.TotalSchoolsCreated++;
                    }
                }
            }

            return testData;

        }

        private RdsTestDataObject CreateDimStudents(RdsTestDataObject testData, int quantityOfStudents)
        {
            Random rnd = this.GlobalRandom;

            for (int i = 0; i < quantityOfStudents; i++)
            {

                // Sex
                string refSexCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SexDistribution);
                

                var firstName = _testDataHelper.GetRandomString(rnd, this.FirstNames);
                var middleName = _testDataHelper.GetRandomString(rnd, this.FirstNames);

                if (refSexCode == "Male")
                {
                    firstName = _testDataHelper.GetRandomString(rnd, this.MaleNames);
                    middleName = _testDataHelper.GetRandomString(rnd, this.MaleNames);
                }
                else if (refSexCode == "Female")
                {
                    firstName = _testDataHelper.GetRandomString(rnd, this.FemaleNames);
                    middleName = _testDataHelper.GetRandomString(rnd, this.FemaleNames);
                }

                var birthDate = _testDataHelper.GetBirthDate(rnd, _testDataProfile.MinimumAgeOfStudent, _testDataProfile.MaximumAgeOfStudent);

                var cohortYear = _testDataHelper.GetRandomObject(rnd, this.RdsReferenceData.DimDates).Year;
                var cohort = cohortYear + "-" + (cohortYear + 4);

                var hasCohort = _testDataHelper.GetWeightedSelection(rnd, this._testDataProfile.HasCohortDistribution);

                if (!hasCohort)
                {
                    cohort = null;
                }

                var dimStudent = new DimK12Student()
                {
                    DimK12StudentId = this.SetAndGetMaxId("DimStudents"),
                    LastName = _testDataHelper.GetRandomString(rnd, this.LastNames),
                    FirstName = firstName,
                    MiddleName = middleName,
                    Cohort = cohort,
                    BirthDate = new DateTime(birthDate.Year, birthDate.Month, birthDate.Day),
                    //StudentPersonId = this.SetAndGetMaxId("StudentPersons")
                };

                dimStudent.StateStudentIdentifier = (rnd.Next(1000000).ToString() + dimStudent.DimK12StudentId.ToString()).PadLeft(10, '0');
               

                testData.DimStudents.Add(dimStudent);
                this.AllDimStudents.Add(dimStudent);
                this.TotalStudentsCreated++;

            }

            return testData;
        }

        private RdsTestDataObject CreateDimPersonnel(RdsTestDataObject testData, int quantityOfPersonnel)
        {
            Random rnd = this.GlobalRandom;

            for (int i = 0; i < quantityOfPersonnel; i++)
            {

                // Sex
                string refSexCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SexDistribution);


                var firstName = _testDataHelper.GetRandomString(rnd, this.FirstNames);
                var middleName = _testDataHelper.GetRandomString(rnd, this.FirstNames);

                if (refSexCode == "Male")
                {
                    firstName = _testDataHelper.GetRandomString(rnd, this.MaleNames);
                    middleName = _testDataHelper.GetRandomString(rnd, this.MaleNames);
                }
                else if (refSexCode == "Female")
                {
                    firstName = _testDataHelper.GetRandomString(rnd, this.FemaleNames);
                    middleName = _testDataHelper.GetRandomString(rnd, this.FemaleNames);
                }
                var lastName = _testDataHelper.GetRandomString(rnd, this.LastNames);

                var birthDate = _testDataHelper.GetBirthDate(rnd, _testDataProfile.MinimumAgeOfStudent, _testDataProfile.MaximumAgeOfStudent);

                DimK12School dimSchool = _testDataHelper.GetRandomObject<DimK12School>(rnd, this.AllDimSchools);

                var dimPersonnel = new DimK12Staff()
                {
                    DimK12StaffId = this.SetAndGetMaxId("DimPersonnel"),
                    LastOrSurname = lastName,
                    FirstName = firstName,
                    MiddleName = middleName,
                    K12StaffRole = i == 0 ? "Chief State School Officer" : "K12 Personnel",
                    ElectronicMailAddress = firstName + "." + lastName + "@" + _testDataHelper.MakeAcronym(dimSchool.NameOfInstitution) + ".edu",
                    BirthDate = new DateTime(birthDate.Year, birthDate.Month, birthDate.Day),
                    TelephoneNumber = _testDataHelper.GetRandomIntInRange(rnd, 100, 700) + "-" + _testDataHelper.GetRandomIntInRange(rnd, 100, 700) + "-" + _testDataHelper.GetRandomIntInRange(rnd, 100, 700),
                    //PersonnelPersonId = this.SetAndGetMaxId("StudentPersons"),
                    PositionTitle = i == 0 ? "CSSO" : null
                };

                dimPersonnel.StaffMemberIdentifierState = (rnd.Next(100).ToString() + dimPersonnel.DimK12StaffId.ToString()).PadLeft(10, '0');

                testData.DimPersonnel.Add(dimPersonnel);
                this.AllDimPersonnel.Add(dimPersonnel);
                this.TotalPersonnelCreated++;

            }

            return testData;
        }

        private RdsTestDataObject CreateDimCharterSchoolAuthorizers(RdsTestDataObject testData)
        {
            var rnd = this.GlobalRandom;

            var organizationElementType = this.RdsReferenceData.RefOrganizationElementTypes.Single(x => x.Code == "001156");
            var leaOrganizationType = this.RdsReferenceData.RefOrganizationTypes.Single(x => x.Code == "LEA" && x.RefOrganizationElementTypeId == organizationElementType.RefOrganizationElementTypeId);
            var schoolOrganizationType = this.RdsReferenceData.RefOrganizationTypes.Single(x => x.Code == "K12School" && x.RefOrganizationElementTypeId == organizationElementType.RefOrganizationElementTypeId);


            // Add missing

            var dimCharterSchoolAuthorizer = new DimCharterSchoolAuthorizer()
            {
                DimCharterSchoolAuthorizerId = -1
            };

            testData.DimCharterSchoolAuthorizers.Add(dimCharterSchoolAuthorizer);
            this.AllDimCharterSchoolAuthorizers.Add(dimCharterSchoolAuthorizer);

            // Add actual data

            foreach (var dimSchool in this.AllDimSchools.Where(x => x.DimK12SchoolId != -1))
            {
                if (dimSchool.CharterSchoolIndicator.HasValue && (bool)dimSchool.CharterSchoolIndicator)
                {

                    dimCharterSchoolAuthorizer = new DimCharterSchoolAuthorizer()
                    {
                        DimCharterSchoolAuthorizerId = this.SetAndGetMaxId("DimCharterSchoolAuthorizers"),
                        //OrganizationId = dimSchool.SchoolOrganizationId,
                        StateIdentifier = dimSchool.SchoolIdentifierState,
                        StateANSICode = dimSchool.StateAnsiCode,
                        StateCode = dimSchool.StateAbbreviationCode,
                        State = dimSchool.StateAbbreviationDescription,
                        //SeaOrganizationId = dimSchool.SeaOrganizationId.HasValue ? dimSchool.SeaOrganizationId.ToString() : null,
                        Name = dimSchool.NameOfInstitution,
                        //OrganizationType = leaOrganizationType.Code
                        
                    };

                    testData.DimCharterSchoolAuthorizers.Add(dimCharterSchoolAuthorizer);
                    this.AllDimCharterSchoolAuthorizers.Add(dimCharterSchoolAuthorizer);

                }
            }


            return testData;
        }


        //private RdsTestDataObject CreateFactStudentCounts(RdsTestDataObject testData, int start, int end)
        //{
        //    var rnd = this.GlobalRandom;

        //    var dimDates = this.RdsReferenceData.DimDates.OrderByDescending(x => x.Year);

        //    int cntr = 0;

        //    foreach (var dimStudent in this.AllDimStudents.Where(x => x.DimStudentId != -1))
        //    {
        //        if (cntr >= start && cntr <= end)
        //        {
        //            DimSchool dimSchool = _testDataHelper.GetRandomObject<DimSchool>(rnd, this.AllDimSchools);
        //            DimLea dimLea = this.AllDimLeas.Single(x => x.LeaStateIdentifier == dimSchool.LeaStateIdentifier);

        //            foreach (var dimDate in dimDates)
        //            {
        //                if (dimDate.Year >= _testDataProfile.OldestStartingYear)
        //                {
        //                    bool hasStudentCutOverStartDate = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasStudentCutOverStartDateDistribution);

        //                    var factStudentCount = new FactK12StudentCount()
        //                    {
        //                        FactStudentCountId = this.SetAndGetMaxId("FactStudentCounts"),
        //                        DimStudentId = dimStudent.DimStudentId,
        //                        DimSchoolId = dimSchool.DimSchoolId,
        //                        DimLeaId = dimLea.DimLeaID,
        //                        DimFactTypeId = this.RdsReferenceData.DimFactTypes.Single(x => x.FactTypeCode == "submission").DimFactTypeId,
        //                        DimCountDateId = dimDate.DimDateId,
        //                        DimAgeId = _testDataHelper.GetRandomObject<DimAge>(rnd, this.RdsReferenceData.DimAges).DimAgeId,
        //                        DimDemographicId = _testDataHelper.GetRandomObject<DimDemographic>(rnd, this.RdsReferenceData.DimDemographics).DimDemographicId,
        //                        DimLanguageId = _testDataHelper.GetRandomObject<DimLanguage>(rnd, this.RdsReferenceData.DimLanguages).DimLanguageId,
        //                        DimProgramStatusId = _testDataHelper.GetRandomObject<DimProgramStatus>(rnd, this.RdsReferenceData.DimProgramStatuses).DimProgramStatusId,
        //                        DimGradeLevelId = _testDataHelper.GetRandomObject<DimGradeLevel>(rnd, this.RdsReferenceData.DimGradeLevels).DimGradeLevelId,
        //                        DimMigrantId = _testDataHelper.GetRandomObject<DimMigrant>(rnd, this.RdsReferenceData.DimMigrants).DimMigrantId,
        //                        DimAttendanceId = _testDataHelper.GetRandomObject<DimAttendance>(rnd, this.RdsReferenceData.DimAttendances).DimAttendanceId,
        //                        DimCohortStatusId = _testDataHelper.GetRandomObject<DimCohortStatus>(rnd, this.RdsReferenceData.DimCohortStatuses).DimCohortStatusId,
        //                        DimEnrollmentId = _testDataHelper.GetRandomObject<DimEnrollment>(rnd, this.RdsReferenceData.DimEnrollments).DimEnrollmentId,
        //                        DimIdeaStatusId = _testDataHelper.GetRandomObject<DimIdeaStatus>(rnd, this.RdsReferenceData.DimIdeaStatuses).DimIdeaStatusId,
        //                        DimNorDProgramStatusId = _testDataHelper.GetRandomObject<DimNorDProgramStatus>(rnd, this.RdsReferenceData.DimNorDProgramStatuses).DimNorDProgramStatusId,
        //                        DimStudentStatusId = _testDataHelper.GetRandomObject<DimStudentStatus>(rnd, this.RdsReferenceData.DimStudentStatuses).DimStudentStatusId,
        //                        //_testDataHelper.GetRandomIntInRange(rnd, 86449, 91888), // There is too much data to use a regular helper class, so getting random int in range
        //                        DimTitle1StatusId = _testDataHelper.GetRandomObject<DimTitle1Status>(rnd, this.RdsReferenceData.DimTitle1Statuses).DimTitle1StatusId,
        //                        DimTitleiiiStatusId = _testDataHelper.GetRandomObject<DimTitleiiiStatus>(rnd, this.RdsReferenceData.DimTitleiiiStatuses).DimTitleiiiStatusId,
        //                        DimRaceId = _testDataHelper.GetRandomObject<DimRace>(rnd, this.RdsReferenceData.DimRaces).DimRaceId,
        //                        StudentCutOverStartDate = hasStudentCutOverStartDate ? (DateTime?)_testDataHelper.GetRandomDateInRange(rnd, new DateTime(2015, 1, 1), DateTime.Now) : null,
        //                        StudentCount = 1
        //                    };
                            
        //                    testData.FactStudentCounts.Add(factStudentCount);

        //                }

        //            }

        //        }

        //        cntr++;

        //    }


        //    return testData;
        //}

        //private RdsTestDataObject CreateFactStudentDisciplines(RdsTestDataObject testData, int start, int end)
        //{
        //    var rnd = this.GlobalRandom;

        //    var dimDates = this.RdsReferenceData.DimDates.OrderByDescending(x => x.Year);

        //    var dimFactTypeId = this.RdsReferenceData.DimFactTypes.Single(x => x.FactTypeCode == "submission").DimFactTypeId;

        //    var dimDisciplines = DimDisciplineHelper_1.GetData();
        //    dimDisciplines.AddRange(DimDisciplineHelper_2.GetData());
        //    dimDisciplines.AddRange(DimDisciplineHelper_3.GetData());

        //    int cntr = 0;

        //    foreach (var dimStudent in this.AllDimStudents.Where(x => x.DimStudentId != -1))
        //    {
        //        if (cntr >= start && cntr <= end)
        //        {
        //            DimSchool dimSchool = _testDataHelper.GetRandomObject<DimSchool>(rnd, this.AllDimSchools);
        //            DimLea dimLea = this.AllDimLeas.Single(x => x.LeaStateIdentifier == dimSchool.LeaStateIdentifier);
                    
        //            foreach (var dimDate in dimDates)
        //            {
        //                if (dimDate.Year >= _testDataProfile.OldestStartingYear)
        //                {
        //                    int disciplineCount = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.DisciplineDistribution);
                            
        //                    for (int disciplineCntr = 0; disciplineCntr < disciplineCount; disciplineCntr++)
        //                    {
        //                        var factStudentDiscipline = new FactK12StudentDiscipline()
        //                        {
        //                            FactStudentDisciplineId = this.SetAndGetMaxId("FactStudentDisciplines"),
        //                            DimStudentId = dimStudent.DimStudentId,
        //                            DimLeaId = dimLea.DimLeaID,
        //                            DimSchoolId = dimSchool.DimSchoolId,
        //                            DimFactTypeId = dimFactTypeId,
        //                            DimCountDateId = dimDate.DimDateId,
        //                            DimAgeId = _testDataHelper.GetRandomObject<DimAge>(rnd, this.RdsReferenceData.DimAges).DimAgeId,
        //                            DimDemographicId = _testDataHelper.GetRandomObject<DimDemographic>(rnd, this.RdsReferenceData.DimDemographics).DimDemographicId,
        //                            DimDisciplineId = _testDataHelper.GetRandomObject<DimDiscipline>(rnd, dimDisciplines).DimDisciplineId,
        //                            DimFirearmsDisciplineId = _testDataHelper.GetRandomObject<DimFirearmsDiscipline>(rnd, this.RdsReferenceData.DimFirearmsDisciplines).DimFirearmsDisciplineId,
        //                            DimFirearmsId = _testDataHelper.GetRandomObject<DimFirearms>(rnd, this.RdsReferenceData.DimFirearms).DimFirearmsId,
        //                            DimGradeLevelId = _testDataHelper.GetRandomObject<DimGradeLevel>(rnd, this.RdsReferenceData.DimGradeLevels).DimGradeLevelId,
        //                            DimIdeaStatusId = _testDataHelper.GetRandomObject<DimIdeaStatus>(rnd, this.RdsReferenceData.DimIdeaStatuses).DimIdeaStatusId,
        //                            DimProgramStatusId = _testDataHelper.GetRandomObject<DimProgramStatus>(rnd, this.RdsReferenceData.DimProgramStatuses).DimProgramStatusId,
        //                            DimRaceId = _testDataHelper.GetRandomObject<DimRace>(rnd, this.RdsReferenceData.DimRaces.Where(x => x.DimFactTypeId == dimFactTypeId).ToList()).DimRaceId,
        //                            DisciplinaryActionStartDate = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(2015, 1, 1), DateTime.Now),
        //                            DisciplineCount = _testDataHelper.GetRandomIntInRange(rnd, 0, 10),
        //                            DisciplineDuration = (decimal)(rnd.Next(400) * 0.1)
        //                        };

        //                        testData.FactStudentDisciplines.Add(factStudentDiscipline);

        //                    }
        //                }

        //            }

        //        }

        //        cntr++;

        //    }

        //    return testData;
        //}

        //private RdsTestDataObject CreateFactStudentAssessments(RdsTestDataObject testData, int start, int end)
        //{
        //    var rnd = this.GlobalRandom;

        //    var dimDates = this.RdsReferenceData.DimDates.OrderByDescending(x => x.Year);

        //    int cntr = 0;

        //    foreach (var dimStudent in this.AllDimStudents.Where(x => x.DimStudentId != -1))
        //    {
        //        if (cntr >= start && cntr <= end)
        //        {
        //            DimSchool dimSchool = _testDataHelper.GetRandomObject<DimSchool>(rnd, this.AllDimSchools);
        //            DimLea dimLea = this.AllDimLeas.Single(x => x.LeaStateIdentifier == dimSchool.LeaStateIdentifier);
                    
        //            foreach (var dimDate in dimDates)
        //            {
        //                if (dimDate.Year >= _testDataProfile.OldestStartingYear)
        //                {

        //                    var factStudentAssessment = new FactK12StudentAssessment()
        //                    {
        //                        FactStudentAssessmentId = this.SetAndGetMaxId("FactStudentAssessments"),
        //                        DimStudentId = dimStudent.DimStudentId,
        //                        DimSchoolId = dimSchool.DimSchoolId,
        //                        DimLeaId = dimLea.DimLeaID,
        //                        DimFactTypeId = this.RdsReferenceData.DimFactTypes.Single(x => x.FactTypeCode == "submission").DimFactTypeId,
        //                        DimCountDateId = dimDate.DimDateId,
        //                        DimDemographicId = _testDataHelper.GetRandomObject<DimDemographic>(rnd, this.RdsReferenceData.DimDemographics).DimDemographicId,
        //                        DimGradeLevelId = _testDataHelper.GetRandomObject<DimGradeLevel>(rnd, this.RdsReferenceData.DimGradeLevels).DimGradeLevelId,
        //                        DimIdeaStatusId = _testDataHelper.GetRandomObject<DimIdeaStatus>(rnd, this.RdsReferenceData.DimIdeaStatuses).DimIdeaStatusId,
        //                        DimProgramStatusId = _testDataHelper.GetRandomObject<DimProgramStatus>(rnd, this.RdsReferenceData.DimProgramStatuses).DimProgramStatusId,
        //                        DimAssessmentId = _testDataHelper.GetRandomIntInRange(rnd, 1, 95255), // There is too much data to use a regular helper class, so getting random int in range
        //                        DimAssessmentStatusId = _testDataHelper.GetRandomObject<DimAssessmentStatus>(rnd, this.RdsReferenceData.DimAssessmentStatuses).DimAssessmentStatusId,
        //                        DimNorDProgramStatusId = _testDataHelper.GetRandomObject<DimNorDProgramStatus>(rnd, this.RdsReferenceData.DimNorDProgramStatuses).DimNorDProgramStatusId,
        //                        DimStudentStatusId = _testDataHelper.GetRandomObject<DimStudentStatus>(rnd, this.RdsReferenceData.DimStudentStatuses).DimStudentStatusId,
        //                        //_testDataHelper.GetRandomIntInRange(rnd, 86447, 172845), // There is too much data to use a regular helper class, so getting random int in range
        //                        DimTitleiiiStatusId = _testDataHelper.GetRandomObject<DimTitleiiiStatus>(rnd, this.RdsReferenceData.DimTitleiiiStatuses).DimTitleiiiStatusId,
        //                        DimRaceId = _testDataHelper.GetRandomObject<DimRace>(rnd, this.RdsReferenceData.DimRaces).DimRaceId,
        //                        DimTitle1StatusId = _testDataHelper.GetRandomObject<DimTitle1Status>(rnd, this.RdsReferenceData.DimTitle1Statuses).DimTitle1StatusId,
        //                        AssessmentCount = _testDataHelper.GetRandomIntInRange(rnd, 0, 10)
        //                    };
                            
        //                    testData.FactStudentAssessments.Add(factStudentAssessment);

        //                }
        //            }

        //        }

        //        cntr++;


        //    }

        //    return testData;
        //}

        //private RdsTestDataObject CreateFactPersonnelCounts(RdsTestDataObject testData)
        //{
        //    var rnd = this.GlobalRandom;

        //    var dimDates = this.RdsReferenceData.DimDates.OrderByDescending(x => x.Year);

        //    foreach (var dimDate in dimDates)
        //    {
        //        if (dimDate.Year >= _testDataProfile.OldestStartingYear)
        //        {

        //            DimSchool dimSchool = _testDataHelper.GetRandomObject<DimSchool>(rnd, this.AllDimSchools);
        //            DimLea dimLea = this.AllDimLeas.Single(x => x.LeaStateIdentifier == dimSchool.LeaStateIdentifier);

        //            foreach (var dimPersonnel in this.AllDimPersonnel.Where(x => x.DimPersonnelId != -1))
        //            {

        //                var factPersonnelCount = new FactK12StaffCount()
        //                {
        //                    FactPersonnelCountId = this.SetAndGetMaxId("FactPersonnelCounts"),
        //                    DimPersonnelId = dimPersonnel.DimPersonnelId,
        //                    DimSchoolId = dimSchool.DimSchoolId,
        //                    DimFactTypeId = this.RdsReferenceData.DimFactTypes.Single(x => x.FactTypeCode == "submission").DimFactTypeId,
        //                    DimCountDateId = dimDate.DimDateId,
        //                    DimTitleiiiStatusId = _testDataHelper.GetRandomObject<DimTitleiiiStatus>(rnd, this.RdsReferenceData.DimTitleiiiStatuses).DimTitleiiiStatusId,
        //                    DimPersonnelCategoryId = _testDataHelper.GetRandomObject<DimPersonnelCategory>(rnd, this.RdsReferenceData.DimPersonnelCategories).DimPersonnelCategoryId,
        //                    DimPersonnelStatusId = _testDataHelper.GetRandomIntInRange(rnd, 2160, 415671), // There is too much data to use a regular helper class, so getting random int in range
        //                    PersonnelFTE = (decimal)(rnd.Next(5000) * 0.1),
        //                    PersonnelCount = _testDataHelper.GetRandomIntInRange(rnd, 0, 500)
        //                };


        //                testData.FactPersonnelCounts.Add(factPersonnelCount);
        //            }

        //        }
        //    }


        //    return testData;
        //}

        //private RdsTestDataObject CreateFactOrganizationCounts(RdsTestDataObject testData)
        //{
        //    var rnd = this.GlobalRandom;

        //    var dimDates = this.RdsReferenceData.DimDates.OrderByDescending(x => x.Year);

        //    foreach (var dimDate in dimDates)
        //    {
        //        if (dimDate.Year >= _testDataProfile.OldestStartingYear)
        //        {


        //            foreach (var dimSea in this.AllDimSeas.Where(x => x.DimSeaId != -1))
        //            {

        //                var factOrganizationCount = new FactOrganizationCount()
        //                {
        //                    FactOrganizationCountId = this.SetAndGetMaxId("FactOrganizationCounts"),
        //                    DimSchoolId = -1,
        //                    DimLeaId = -1,
        //                    DimSeaId = dimSea.DimSeaId,
        //                    DimPersonnelId = _testDataHelper.GetRandomObject<DimPersonnel>(rnd, this.AllDimPersonnel).DimPersonnelId,
        //                    DimFactTypeId = this.RdsReferenceData.DimFactTypes.Single(x => x.FactTypeCode == "submission").DimFactTypeId,
        //                    DimCountDateId = dimDate.DimDateId,
        //                    DimOrganizationStatusId = _testDataHelper.GetRandomObject<DimOrganizationStatus>(rnd, this.RdsReferenceData.DimOrganizationStatuses).DimOrganizationStatusId,
        //                    DimSchoolStatusId = _testDataHelper.GetRandomIntInRange(rnd, 420, 164228), // There is too much data to use a regular helper class, so getting random int in range
        //                    DimTitle1StatusId = _testDataHelper.GetRandomObject<DimTitle1Status>(rnd, this.RdsReferenceData.DimTitle1Statuses).DimTitle1StatusId,
        //                    DimCharterSchoolAuthorizerId = -1,
        //                    DimCharterSchoolManagementOrganizationId = -1,
        //                    DimCharterSchoolUpdatedManagementOrganizationId = -1,
        //                    DimCharterSchoolSecondaryAuthorizerId = -1,
        //                    DimComprehensiveAndTargetedSupportId = -1,
        //                    DimSchoolStateStatusId = _testDataHelper.GetRandomObject<DimSchoolStateStatus>(rnd, this.RdsReferenceData.DimSchoolStateStatuses).DimSchoolStateStatusId,
        //                    OrganizationCount = 1,
        //                    TitleiParentalInvolveRes = 1,
        //                    TitleiPartaAllocations = 1,
        //                    SCHOOLIMPROVEMENTFUNDS = _testDataHelper.GetRandomIntInRange(rnd, 100000, 400000),
        //                    FederalFundAllocationType = _testDataHelper.GetRandomObject<string>(rnd, this.RdsReferenceData.FederalFundAllocationTypes),
        //                    FederalProgramCode = _testDataHelper.GetRandomString(rnd, _testDataProfile.FederalProgramCodes),
        //                    FederalFundAllocated = _testDataHelper.GetRandomIntInRange(rnd, 100000, 400000)
        //                };

        //                testData.FactOrganizationCounts.Add(factOrganizationCount);

        //            }

        //            foreach (var dimLea in this.AllDimLeas.Where(x => x.DimLeaID != -1))
        //            {
        //                DimSea dimSea = this.AllDimSeas.Single(x => x.SeaStateIdentifier == dimLea.SeaStateIdentifier);

        //                var factOrganizationCount = new FactOrganizationCount()
        //                {
        //                    FactOrganizationCountId = this.SetAndGetMaxId("FactOrganizationCounts"),
        //                    DimSchoolId = -1,
        //                    DimLeaId = dimLea.DimLeaID,
        //                    DimSeaId = dimSea.DimSeaId,
        //                    DimPersonnelId = _testDataHelper.GetRandomObject<DimPersonnel>(rnd, this.AllDimPersonnel).DimPersonnelId,
        //                    DimFactTypeId = this.RdsReferenceData.DimFactTypes.Single(x => x.FactTypeCode == "submission").DimFactTypeId,
        //                    DimCountDateId = dimDate.DimDateId,
        //                    DimOrganizationStatusId = _testDataHelper.GetRandomObject<DimOrganizationStatus>(rnd, this.RdsReferenceData.DimOrganizationStatuses).DimOrganizationStatusId,
        //                    DimSchoolStatusId = _testDataHelper.GetRandomIntInRange(rnd, 420, 164228), // There is too much data to use a regular helper class, so getting random int in range
        //                    DimTitle1StatusId = _testDataHelper.GetRandomObject<DimTitle1Status>(rnd, this.RdsReferenceData.DimTitle1Statuses).DimTitle1StatusId,
        //                    DimCharterSchoolAuthorizerId = -1,
        //                    DimCharterSchoolManagementOrganizationId = -1,
        //                    DimCharterSchoolUpdatedManagementOrganizationId = -1,
        //                    DimCharterSchoolSecondaryAuthorizerId = -1,
        //                    DimComprehensiveAndTargetedSupportId = -1,
        //                    DimSchoolStateStatusId = _testDataHelper.GetRandomObject<DimSchoolStateStatus>(rnd, this.RdsReferenceData.DimSchoolStateStatuses).DimSchoolStateStatusId,
        //                    OrganizationCount = 1,
        //                    TitleiParentalInvolveRes = 1,
        //                    TitleiPartaAllocations = 1,
        //                    SCHOOLIMPROVEMENTFUNDS = _testDataHelper.GetRandomIntInRange(rnd, 100000, 400000),
        //                    FederalFundAllocationType = _testDataHelper.GetRandomObject<string>(rnd, this.RdsReferenceData.FederalFundAllocationTypes),
        //                    FederalProgramCode = _testDataHelper.GetRandomString(rnd, _testDataProfile.FederalProgramCodes),
        //                    FederalFundAllocated = _testDataHelper.GetRandomIntInRange(rnd, 100000, 400000)
        //                };

        //                testData.FactOrganizationCounts.Add(factOrganizationCount);

        //            }

        //            foreach (var dimSchool in this.AllDimSchools.Where(x => x.DimSchoolId != -1))
        //            {
        //                DimSea dimSea = this.AllDimSeas.Single(x => x.SeaStateIdentifier == dimSchool.SeaStateIdentifier);
        //                DimLea dimLea = this.AllDimLeas.Single(x => x.LeaStateIdentifier == dimSchool.LeaStateIdentifier);

        //                var factOrganizationCount = new FactOrganizationCount()
        //                {
        //                    FactOrganizationCountId = this.SetAndGetMaxId("FactOrganizationCounts"),
        //                    DimSchoolId = dimSchool.DimSchoolId,
        //                    DimLeaId = dimLea.DimLeaID,
        //                    DimSeaId = dimSea.DimSeaId,
        //                    DimPersonnelId = _testDataHelper.GetRandomObject<DimPersonnel>(rnd, this.AllDimPersonnel).DimPersonnelId,
        //                    DimFactTypeId = this.RdsReferenceData.DimFactTypes.Single(x => x.FactTypeCode == "submission").DimFactTypeId,
        //                    DimCountDateId = dimDate.DimDateId,
        //                    DimOrganizationStatusId = _testDataHelper.GetRandomObject<DimOrganizationStatus>(rnd, this.RdsReferenceData.DimOrganizationStatuses).DimOrganizationStatusId,
        //                    DimSchoolStatusId = _testDataHelper.GetRandomIntInRange(rnd, 420, 164228), // There is too much data to use a regular helper class, so getting random int in range
        //                    DimTitle1StatusId = _testDataHelper.GetRandomObject<DimTitle1Status>(rnd, this.RdsReferenceData.DimTitle1Statuses).DimTitle1StatusId,
        //                    DimCharterSchoolAuthorizerId = _testDataHelper.GetRandomObject<DimCharterSchoolAuthorizer>(rnd, this.AllDimCharterSchoolAuthorizers).DimCharterSchoolAuthorizerId,
        //                   // DimCharterSchoolManagementOrganizationId = _testDataHelper.GetRandomObject<DimCharterSchoolManagementOrganizationy>(rnd, this.AllDimCharterSchoolApproverAgencies).DimCharterSchoolApproverAgencyId,
        //                   // DimCharterSchoolUpdatedManagementOrganizationId = _testDataHelper.GetRandomObject<DimCharterSchoolApproverAgency>(rnd, this.AllDimCharterSchoolApproverAgencies).DimCharterSchoolApproverAgencyId,
        //                    DimCharterSchoolSecondaryAuthorizerId = _testDataHelper.GetRandomObject<DimCharterSchoolAuthorizer>(rnd, this.AllDimCharterSchoolAuthorizers).DimCharterSchoolAuthorizerId,
        //                    DimComprehensiveAndTargetedSupportId = -1,
        //                    DimSchoolStateStatusId = _testDataHelper.GetRandomObject<DimSchoolStateStatus>(rnd, this.RdsReferenceData.DimSchoolStateStatuses).DimSchoolStateStatusId,
        //                    OrganizationCount = 1,
        //                    TitleiParentalInvolveRes = 1,
        //                    TitleiPartaAllocations = 1,
        //                    SCHOOLIMPROVEMENTFUNDS = _testDataHelper.GetRandomIntInRange(rnd, 100000, 400000),
        //                    FederalFundAllocationType = _testDataHelper.GetRandomObject<string>(rnd, this.RdsReferenceData.FederalFundAllocationTypes),
        //                    FederalProgramCode = _testDataHelper.GetRandomString(rnd, _testDataProfile.FederalProgramCodes),
        //                    FederalFundAllocated = _testDataHelper.GetRandomIntInRange(rnd, 100000, 400000)
        //                };
                        
        //                testData.FactOrganizationCounts.Add(factOrganizationCount);

        //            }

        //        }
        //    }


        //    return testData;
        //}

        //private RdsTestDataObject CreateFactOrganizationStatusCounts(RdsTestDataObject testData)
        //{
        //    var rnd = this.GlobalRandom;

        //    var dimDates = this.RdsReferenceData.DimDates.OrderByDescending(x => x.Year);

        //    foreach (var dimDate in dimDates)
        //    {
        //        if (dimDate.Year >= _testDataProfile.OldestStartingYear)
        //        {

        //            foreach (var dimSchool in this.AllDimSchools.Where(x => x.DimSchoolId != -1))
        //            {
        //                DimLea dimLea = this.AllDimLeas.Single(x => x.LeaStateIdentifier == dimSchool.LeaStateIdentifier);

        //                var factOrganizationStatusCount = new FactOrganizationStatusCount()
        //                {
        //                    FactOrganizationStatusCountId = this.SetAndGetMaxId("FactOrganizationStatusCounts"),
        //                    DimSchoolId = dimSchool.DimSchoolId,
        //                    DimFactTypeId = this.RdsReferenceData.DimFactTypes.Single(x => x.FactTypeCode == "submission").DimFactTypeId,
        //                    DimCountDateId = dimDate.DimDateId,
        //                    DimDemographicId = _testDataHelper.GetRandomObject<DimDemographic>(rnd, this.RdsReferenceData.DimDemographics).DimDemographicId,
        //                    DimEcoDisStatusId = _testDataHelper.GetRandomObject<DimDemographic>(rnd, this.RdsReferenceData.DimDemographics).DimDemographicId,
        //                    DimIdeaStatusId = _testDataHelper.GetRandomObject<DimIdeaStatus>(rnd, this.RdsReferenceData.DimIdeaStatuses).DimIdeaStatusId,
        //                    DimIndicatorStatusId = _testDataHelper.GetRandomObject<DimIndicatorStatus>(rnd, this.RdsReferenceData.DimIndicatorStatuses).DimIndicatorStatusId,
        //                    DimIndicatorStatusTypeId = _testDataHelper.GetRandomObject<DimIndicatorStatusType>(rnd, this.RdsReferenceData.DimIndicatorStatusTypes).DimIndicatorStatusTypeId,
        //                    DimRaceId = _testDataHelper.GetRandomObject<DimRace>(rnd, this.RdsReferenceData.DimRaces).DimRaceId,
        //                    DimStateDefinedCustomIndicatorId = _testDataHelper.GetRandomObject<DimStateDefinedCustomIndicator>(rnd, this.RdsReferenceData.DimStateDefinedCustomIndicators).DimStateDefinedCustomIndicatorId,
        //                    DimStateDefinedStatusId = _testDataHelper.GetRandomObject<DimStateDefinedStatus>(rnd, this.RdsReferenceData.DimStateDefinedStatuses).DimStateDefinedStatusId,
        //                    OrganizationStatusCount = 1
        //                };

        //                testData.FactOrganizationStatusCounts.Add(factOrganizationStatusCount);
        //            }

        //        }
        //    }


        //    return testData;
        //}

        //private RdsTestDataObject CreateFactCustomCounts(RdsTestDataObject testData)
        //{
        //    return testData;
        //}

    }
}
