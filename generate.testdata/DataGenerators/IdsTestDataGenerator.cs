using generate.core.Helpers.ReferenceData;
using generate.core.Helpers.TestDataHelper;
using generate.core.Models.IDS;
using generate.shared.Utilities;
using generate.testdata.Interfaces;
using Newtonsoft.Json;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.testdata.DataGenerators
{
    public class IdsTestDataGenerator : IIdsTestDataGenerator
    {

        private readonly IOutputHelper _outputHelper;
        private readonly ITestDataHelper _testDataHelper;
        private readonly IIdsTestDataProfile _testDataProfile;

        public IdsReferenceData OdsReferenceData { get; private set; }

        private readonly bool _showDebugInfo = false;

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

        // Data that needs to carry over from batch to batch
        public ConcurrentBag<Role> AllRoles { get; set; }
        public ConcurrentBag<int> AllLeaIds { get; set; }
        public ConcurrentBag<OrganizationDetail> AllSchools { get; set; }
        public ConcurrentBag<OrganizationRelationship> AllLeaSchoolRelationships { get; set; }
        public ConcurrentBag<OrganizationRelationship> AllSchoolProgramRelationships { get; set; }
        public ConcurrentBag<int> SpecialEdProgramIds { get; set; }
        public ConcurrentBag<int> ImmigrantTitleIIIProgramIds { get; set; }
        public ConcurrentBag<int> Section504ProgramIds { get; set; }
        public ConcurrentBag<int> FosterCareProgramIds { get; set; }
        public ConcurrentBag<int> ImmigrantEducationProgramIds { get; set; }
        public ConcurrentBag<int> MigrantEducationProgramIds { get; set; }
        public ConcurrentBag<int> CTEProgramIds { get; set; }
        public ConcurrentBag<int> LepProgramIds { get; set; }
        public ConcurrentBag<int> NeglectedProgramIds { get; set; }
        public ConcurrentBag<int> HomelessProgramIds { get; set; }
        public ConcurrentBag<AssessmentAdministration> AllAssessmentAdministrations { get; set; }
        public ConcurrentBag<AssessmentSubtest> AllAssessmentSubtests { get; set; }
        public ConcurrentBag<AssessmentPerformanceLevel> AllAssessmentPerformanceLevels { get; set; }
        public ConcurrentBag<AssessmentAdministrationOrganization> AllAssessmentAdministrationOrganizations { get; set; }
        public ConcurrentBag<AssessmentForm> AllAssessmentForms { get; set; }
        public ConcurrentBag<K12school> AllK12Schools { get; set; }
        public ConcurrentBag<K12schoolGradeOffered> AllK12schoolGradeOffered { get; set; }

        public int QuantityRemaining { get; set; }
        public int TotalLeasCreated { get; set; }
        public int TotalSchoolsCreated { get; set; }
        public int TotalStudentsCreated { get; set; }
        public int TotalPersonnelCreated { get; set; }

        public IdsTestDataGenerator(
            IOutputHelper outputHelper,
            ITestDataHelper testDataHelper,
            IIdsTestDataProfile testDataProfile
        )
        {
            _outputHelper = outputHelper ?? throw new ArgumentNullException(nameof(outputHelper));
            _testDataHelper = testDataHelper ?? throw new ArgumentNullException(nameof(testDataHelper));
            _testDataProfile = testDataProfile ?? throw new ArgumentNullException(nameof(testDataProfile));
        }

        public void GenerateTestData(int seed, int quantityOfStudents, int schoolYear, string formatType, string outputType, string filePath)
        {
            SchoolYear = schoolYear;

            var globalRandom = new Random(seed);

            _outputHelper.DeleteExistingFiles("ods", filePath);

            this.InitializeVariables(filePath, seed, formatType, outputType);

            // Begin Output

            StringBuilder output = new StringBuilder();

            output = _outputHelper.CreateStartOutput("0001_Generate", quantityOfStudents, this.FormatType, this.Seed, "ods");

            if (this.FormatType == "sql")
            {
                output = _outputHelper.AddSqlDeletesToOutput(output, "ods");
            }

            IdsTestDataObject testData = this.GetFreshTestDataObject();


            int generateOrganizationId = 0;


            testData = CreateGenerateOrganization(globalRandom, testData, out generateOrganizationId);
            testData = CreateRoles(testData, generateOrganizationId);

            int numberOfAssessments = (int)Math.Ceiling((decimal)quantityOfStudents / (decimal)_testDataProfile.AverageNumberOfStudentsPerAssessment);
            testData = CreateAssessments(globalRandom, testData, numberOfAssessments);

            output = this.AddTestDataToOutput(testData, output, "Generate", "Top Level Organization and Roles", false);

            // Write output - top level
            output = _outputHelper.AddEndToOutput(output, this.FormatType);
            var sectionName = "01_0001_Generate";
            _outputHelper.WriteOutput(output, "ods", this.FormatType, this.OutputType, this.FilePath, sectionName);
            if (this.FormatType == "sql")
            {
                this.ScriptsToExecute.Add("OdsTestData_" + sectionName + ".sql");
            }


            for (int seaCntr = 0; seaCntr < _testDataProfile.QuantityOfSeas; seaCntr++)
            {

                output = _outputHelper.CreateStartOutput((seaCntr + 2).ToString().PadLeft(4, '0') + "_SEA", quantityOfStudents, this.FormatType, this.Seed, "ods");

                int seaOrganizationId = 0;
                RefState refState = null;

                testData = this.GetFreshTestDataObject(seaOrganizationId);

                // SEA
                testData = CreateSea(globalRandom, testData, out seaOrganizationId, out refState);
                output = this.AddTestDataToOutput(testData, output, (seaCntr + 2).ToString().PadLeft(4, '0') + "-0000-SEA", "SEA Data - " + (seaCntr + 1) + " of " + _testDataProfile.QuantityOfSeas, false);

                // Write output - SEA
                output = _outputHelper.AddEndToOutput(output, this.FormatType);
                sectionName = "02_" + (seaCntr + 2).ToString().PadLeft(4, '0') + "_0000_SEA";
                _outputHelper.WriteOutput(output, "ods", this.FormatType, this.OutputType, this.FilePath, sectionName);
                if (this.FormatType == "sql")
                {
                    this.ScriptsToExecute.Add("OdsTestData_" + sectionName + ".sql");
                }

                if (this.OutputType != "console")
                {
                    Console.WriteLine();
                    Console.WriteLine("======================");
                    Console.WriteLine("SEA Id = " + seaOrganizationId + " (" + (seaCntr + 1) + " of " + _testDataProfile.QuantityOfSeas + ")");
                    Console.WriteLine("======================");
                }

                // Get LEA count
                int averageStudentsPerLea = _testDataHelper.GetRandomIntInRange(globalRandom, _testDataProfile.MinimumAverageStudentsPerLea, _testDataProfile.MaximumAverageStudentsPerLea);
                int quantityOfLeas = (int)Math.Ceiling((decimal)quantityOfStudents / (decimal)averageStudentsPerLea);


                int quantityOfStudentsPerIteration = _testDataProfile.StudentIterationSize;
                int totalIterations = (int)Math.Ceiling((decimal)quantityOfStudents / (decimal)_testDataProfile.StudentIterationSize);

                int quantityOfLeasPerIteration = quantityOfLeas / totalIterations;
                int quantityofRemainingLeas = quantityOfLeas;

                
                int quantityofRemainingStudents = quantityOfStudents;

                if (totalIterations < 1)
                {
                    totalIterations = 1;
                }

                for (int i = 1; i <= totalIterations; i++)
                {
                                       
                    if(quantityOfLeasPerIteration > quantityofRemainingLeas)
                    {
                        quantityOfLeasPerIteration = quantityofRemainingLeas;
                    }

                    if (quantityOfStudentsPerIteration > quantityofRemainingStudents)
                    {
                        quantityOfStudentsPerIteration = quantityofRemainingStudents;
                    }
                   
                    this.CreateTestDataInBatches("Organizations", quantityOfLeasPerIteration, seaCntr, seaOrganizationId, refState, i, globalRandom);

                    this.CreateTestDataInBatches("Persons", quantityOfStudentsPerIteration, seaCntr, seaOrganizationId, refState, i, globalRandom);

                    quantityofRemainingLeas = quantityofRemainingLeas - quantityOfLeasPerIteration;
                    quantityofRemainingStudents = quantityofRemainingStudents - quantityOfStudentsPerIteration;

                    this.EmptyIterationData();
                }

                if (this.OutputType != "console")
                {
                    Console.WriteLine("");
                    Console.WriteLine("======================");
                    Console.WriteLine("Total LEAs = " + this.TotalLeasCreated);
                    Console.WriteLine("Total Schools = " + this.TotalSchoolsCreated);
                    Console.WriteLine("Total Students = " + this.TotalStudentsCreated);
                    Console.WriteLine("Total Personnel = " + this.TotalPersonnelCreated);
                    Console.WriteLine("======================");
                }

               

            }

            if (this.FormatType == "sql")
            {
                var powershellScriptOutput = _outputHelper.CreateSqlPowershellScript(this.ScriptsToExecute.ToList());
                _outputHelper.WriteOutput(powershellScriptOutput, "ods", "powershell", this.OutputType, this.FilePath);
            }

           
        }

        private void InitializeVariables(string filePath = null, int? seed = null, string formatType = null, string outputType = null)
        {
            this.OdsReferenceData = new IdsReferenceData();

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


            if (this.AllRoles == null)
            {
                this.AllRoles = new ConcurrentBag<Role>();
            }

            if (this.AllLeaIds == null)
            {
                this.AllLeaIds = new ConcurrentBag<int>();
            }

            if (this.AllSchools == null)
            {
                this.AllSchools = new ConcurrentBag<OrganizationDetail>();
            }

            if (this.AllLeaSchoolRelationships == null)
            {
                this.AllLeaSchoolRelationships = new ConcurrentBag<OrganizationRelationship>();
            }

            if (this.SpecialEdProgramIds == null)
            {
                this.SpecialEdProgramIds = new ConcurrentBag<int>();
            }
            if (this.ImmigrantTitleIIIProgramIds == null)
            {
                this.ImmigrantTitleIIIProgramIds = new ConcurrentBag<int>();
            }
            if (this.Section504ProgramIds == null)
            {
                this.Section504ProgramIds = new ConcurrentBag<int>();
            }
            if (this.FosterCareProgramIds == null)
            {
                this.FosterCareProgramIds = new ConcurrentBag<int>();
            }
            if (this.ImmigrantEducationProgramIds == null)
            {
                this.ImmigrantEducationProgramIds = new ConcurrentBag<int>();
            }
            if (this.MigrantEducationProgramIds == null)
            {
                this.MigrantEducationProgramIds = new ConcurrentBag<int>();
            }
            if (this.CTEProgramIds == null)
            {
                this.CTEProgramIds = new ConcurrentBag<int>();
            }
            if (this.LepProgramIds == null)
            {
                this.LepProgramIds = new ConcurrentBag<int>();
            }
            if (this.NeglectedProgramIds == null)
            {
                this.NeglectedProgramIds = new ConcurrentBag<int>();
            }
            if (this.HomelessProgramIds == null)
            {
                this.HomelessProgramIds = new ConcurrentBag<int>();
            }
            if (this.AllAssessmentAdministrations == null)
            {
                this.AllAssessmentAdministrations = new ConcurrentBag<AssessmentAdministration>();
            }
            if (this.AllAssessmentSubtests == null)
            {
                this.AllAssessmentSubtests = new ConcurrentBag<AssessmentSubtest>();
            }
            if (this.AllAssessmentPerformanceLevels == null)
            {
                this.AllAssessmentPerformanceLevels = new ConcurrentBag<AssessmentPerformanceLevel>();
            }
            if (this.AllAssessmentAdministrationOrganizations == null)
            {
                this.AllAssessmentAdministrationOrganizations = new ConcurrentBag<AssessmentAdministrationOrganization>();
            }
            if (this.AllAssessmentForms == null)
            {
                this.AllAssessmentForms = new ConcurrentBag<AssessmentForm>();
            }

            if (this.AllK12Schools == null)
            {
                this.AllK12Schools = new ConcurrentBag<K12school>();
            }
            if (this.AllK12schoolGradeOffered == null)
            {
                this.AllK12schoolGradeOffered = new ConcurrentBag<K12schoolGradeOffered>();
            }

            if (this.AllSchoolProgramRelationships == null)
            {
                this.AllSchoolProgramRelationships = new ConcurrentBag<OrganizationRelationship>();
            }


        }

        private void EmptyIterationData()
        {

            this.AllLeaIds.Clear();
            this.AllSchools.Clear();
            this.AllLeaSchoolRelationships.Clear();
            this.AllSchoolProgramRelationships.Clear();
            this.SpecialEdProgramIds.Clear();
            this.ImmigrantTitleIIIProgramIds.Clear();
            this.Section504ProgramIds.Clear();
            this.FosterCareProgramIds.Clear();
            this.ImmigrantEducationProgramIds.Clear();
            this.MigrantEducationProgramIds.Clear();
            this.CTEProgramIds.Clear();
            this.LepProgramIds.Clear();
            this.NeglectedProgramIds.Clear();
            this.HomelessProgramIds.Clear();
            this.AllAssessmentAdministrations.Clear();
            this.AllAssessmentSubtests.Clear();
            this.AllAssessmentPerformanceLevels.Clear();
            this.AllAssessmentAdministrationOrganizations.Clear();
            this.AllAssessmentForms.Clear();
            this.AllK12Schools.Clear();
            this.AllK12schoolGradeOffered.Clear();

        }
        private void CreateTestDataInBatches(string batchType, int totalQuantityRequired, int seaCntr, int seaOrganizationId, RefState refState, int iterationCounter, Random rnd)
        {

            int batchSize = _testDataProfile.BatchSize;
            int numberOfParallelTasks = _testDataProfile.NumberOfParallelTasks;
            int totalQuantity = totalQuantityRequired;

            //var randomSeed = this.Seed + seaCntr + (batchNumber * _testDataProfile.NumberOfParallelTasks) + taskNumber;
            //Random rnd = new Random(randomSeed);


            if (batchType == "Organizations")
            {
                batchSize = (int)Math.Ceiling((decimal)_testDataProfile.BatchSize / 500);
                numberOfParallelTasks = numberOfParallelTasks * 3;
            }

           

            Console.WriteLine("batchSize = " + batchSize + " / numberOfParallelTasks = " + numberOfParallelTasks);
            int numberOfBatches = (int)Math.Ceiling((decimal)totalQuantityRequired / (decimal)batchSize / (decimal)numberOfParallelTasks);

            if (totalQuantityRequired / batchSize < numberOfParallelTasks)
            {
                numberOfParallelTasks = (int)Math.Ceiling((decimal)totalQuantityRequired / (decimal)batchSize);
                if (numberOfParallelTasks <= 0)
                {
                    numberOfParallelTasks = 1;
                }
            }

            this.QuantityRemaining = totalQuantityRequired;

            Console.WriteLine();
            Console.WriteLine("----------------------");
            Console.WriteLine(batchType + " (" + totalQuantityRequired + ") - Batches = " + numberOfBatches + " / Parallel Tasks = " + numberOfParallelTasks + " / Batch Size = " + batchSize);
            Console.WriteLine("----------------------");

            for (int batchCntr = 0; batchCntr < numberOfBatches; batchCntr++)
            {

                // Revise number of parallel tasks if quantity remaining is low
                if (this.QuantityRemaining / batchSize < numberOfParallelTasks)
                {
                    numberOfParallelTasks = (int)Math.Ceiling((decimal)this.QuantityRemaining / (decimal)batchSize);

                    if (numberOfParallelTasks <= 0)
                    {
                        numberOfParallelTasks = 1;
                    }
                }

                Task[] taskArray = new Task[numberOfParallelTasks];



                for (int taskCntr = 0; taskCntr < taskArray.Length; taskCntr++)
                {
                    var taskNumber = taskCntr;
                    var batchNumber = batchCntr;

                    if (batchType == "Organizations")
                    {

                        taskArray[taskCntr] = Task.Factory.StartNew(() =>
                                           this.CreateOrganizationsInBatch(totalQuantityRequired, seaCntr, batchNumber, taskNumber, batchSize, numberOfBatches, seaOrganizationId, refState, iterationCounter, rnd)
                                       );
                    }
                    else if (batchType == "Persons")
                    {
                        taskArray[taskCntr] = Task.Factory.StartNew(() =>
                                           this.CreatePersonsInBatch(totalQuantityRequired, seaCntr, batchNumber, taskNumber, batchSize, numberOfBatches, seaOrganizationId, refState, iterationCounter)
                                       );
                    }

                }


                Task.WaitAll(taskArray);

            }


        }

        private void CreateOrganizationsInBatch(int totalQuantityRequired, int seaCntr, int batchNumber, int taskNumber, int batchSize, int numberOfBatches, int seaOrganizationId, RefState refState, int iterationCounter, Random rnd)
        {
            

            if (this.QuantityRemaining <= 0)
            {
                if (this.OutputType != "console")
                {
                    Console.WriteLine("Total Quantity Required reached early, exiting");
                }
                return;
            }

            StringBuilder output = _outputHelper.CreateStartOutput((seaCntr + 2).ToString().PadLeft(4, '0') + "_" + (batchNumber + 1).ToString().PadLeft(4, '0') + "_Organizations", totalQuantityRequired, this.FormatType, this.Seed, "ods");

            int quantityInBatch = batchSize;
            if (quantityInBatch > this.QuantityRemaining)
            {
                quantityInBatch = this.QuantityRemaining;
            }
            if (this.OutputType != "console")
            {
                Console.WriteLine("Iteration " + iterationCounter  + "/ Batch " + (batchNumber + 1) + " of " + numberOfBatches + " / Task " + (taskNumber + 1) + " / " + quantityInBatch + " in batch");
            }

            // LEAs, Schools
            IdsTestDataObject testData = this.CreateOrganizations(rnd, quantityInBatch, seaOrganizationId, refState);

            TotalLeasCreated += testData.QuantityOfLeas;
            TotalSchoolsCreated += testData.QuantityOfSchools;

            //Console.WriteLine("Batch " + batchNumber + " - " + testData.QuantityOfSchools + " schools");

            this.QuantityRemaining = this.QuantityRemaining - testData.QuantityOfLeas;

            bool isLastSection = batchNumber == numberOfBatches - 1 ? true : false;


            output = this.AddTestDataToOutput(testData, output, (batchNumber + 3) + "_Organizations", "Organizations - Batch " + (batchNumber + 1) + " of " + numberOfBatches + " - Task " + (taskNumber + 1), isLastSection);

            // Write output - Organizations
            output = _outputHelper.AddEndToOutput(output, this.FormatType);

            var sectionName = "03_" + iterationCounter.ToString().PadLeft(4, '0') + "_" + (seaCntr + 2).ToString().PadLeft(4, '0') + "_" + (batchNumber + 1).ToString().PadLeft(4, '0') + "_" + (taskNumber + 1).ToString().PadLeft(4, '0') + "_Organizations";
            _outputHelper.WriteOutput(output, "ods", this.FormatType, this.OutputType, this.FilePath, sectionName);
            if (this.FormatType == "sql")
            {
                this.ScriptsToExecute.Add("OdsTestData_" + sectionName + ".sql");
            }
        }

        private void CreatePersonsInBatch(int totalQuantityRequired, int seaCntr, int batchNumber, int taskNumber, int batchSize, int numberOfBatches, int seaOrganizationId, RefState refState, int iterationCounter)
        {
            var randomSeed = this.Seed + seaCntr + (batchNumber * _testDataProfile.NumberOfParallelTasks) + taskNumber;
            Random rnd = new Random(randomSeed);

            if (this.QuantityRemaining <= 0)
            {
                if (this.OutputType != "console")
                {
                    Console.WriteLine("Total Quantity Required reached early, exiting");
                }
                return;
            }

            StringBuilder output = _outputHelper.CreateStartOutput((seaCntr + 2).ToString().PadLeft(4, '0') + "_" + (batchNumber + 1).ToString().PadLeft(4, '0') + "_Persons", totalQuantityRequired, this.FormatType, this.Seed, "ods");

            int quantityInBatch = batchSize;
            if (quantityInBatch > this.QuantityRemaining)
            {
                quantityInBatch = this.QuantityRemaining;
            }
            if (this.OutputType != "console")
            {
                Console.WriteLine("Iteration " + iterationCounter + "/ Batch " + (batchNumber + 1) + " of " + numberOfBatches + " / Task " + (taskNumber + 1) + " / " + quantityInBatch + " in batch");
            }

            // Students, Personnel
            IdsTestDataObject testData = this.CreatePersons(rnd, quantityInBatch, seaOrganizationId, refState);

            TotalStudentsCreated += testData.QuantityOfStudents;
            TotalPersonnelCreated += testData.QuantityOfPersonnel;

            this.QuantityRemaining = this.QuantityRemaining - testData.QuantityOfStudents;

            bool isLastSection = batchNumber == numberOfBatches - 1 ? true : false;


            output = this.AddTestDataToOutput(testData, output, (batchNumber + 3) + "_Persons", "Persons - Batch " + (batchNumber + 1) + " of " + numberOfBatches + " - Task " + (taskNumber + 1), isLastSection);

            // Write output - Persons
            output = _outputHelper.AddEndToOutput(output, this.FormatType);

            var sectionName = "04_" + iterationCounter.ToString().PadLeft(4, '0') + "_" + (seaCntr + 2).ToString().PadLeft(4, '0') + "_" + (batchNumber + 1).ToString().PadLeft(4, '0') + "_" + (taskNumber + 1).ToString().PadLeft(4, '0') + "_Persons";
            _outputHelper.WriteOutput(output, "ods", this.FormatType, this.OutputType, this.FilePath, sectionName);
            if (this.FormatType == "sql")
            {
                this.ScriptsToExecute.Add("OdsTestData_" + sectionName + ".sql");
            }
        }


        private StringBuilder AddTestDataToOutput(IdsTestDataObject testData, StringBuilder output, string sectionName, string sectionDescription, bool isLastSection)
        {
            testData.TestDataSection = sectionName;
            testData.TestDataSectionDescription = sectionDescription;

            if (this.FormatType == "sql")
            {
                output.AppendLine("--------------------------");
                output.AppendLine("-- " + sectionName + " / " + sectionDescription);
                output.AppendLine("--------------------------");


                if (testData.Assessments.Any())
                {
                    output.AppendLine();
                    output.AppendLine("-- Assessments");
                    output.AppendLine("--------------------------");
                    output.AppendLine();
                }
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.Assessments.ToArray(), typeof(Assessment), "Assessment", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.AssessmentForms.ToArray(), typeof(AssessmentForm), "AssessmentForm", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.AssessmentSubtests.ToArray(), typeof(AssessmentSubtest), "AssessmentSubtest", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.AssessmentPerformanceLevels.ToArray(), typeof(AssessmentPerformanceLevel), "AssessmentPerformanceLevel", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.AssessmentAdministrations.ToArray(), typeof(AssessmentAdministration), "AssessmentAdministration", "dbo", true));


                if (testData.Organizations.Any())
                {
                    output.AppendLine();
                    output.AppendLine("-- Organizations");
                    output.AppendLine("--------------------------");
                    output.AppendLine();
                }



                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.RefIndicatorStatusCustomTypes.ToArray(), typeof(RefIndicatorStatusCustomType), "RefIndicatorStatusCustomType", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.Organizations.ToArray(), typeof(Organization), "Organization", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.Roles.ToArray(), typeof(Role), "Role", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.OrganizationDetails.ToArray(), typeof(OrganizationDetail), "OrganizationDetail", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.OrganizationWebsites.ToArray(), typeof(OrganizationWebsite), "OrganizationWebsite", "dbo", false));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.OrganizationTelephones.ToArray(), typeof(OrganizationTelephone), "OrganizationTelephone", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.OrganizationIdentifiers.ToArray(), typeof(OrganizationIdentifier), "OrganizationIdentifier", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.OrganizationIndicators.ToArray(), typeof(OrganizationIndicator), "OrganizationIndicator", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12Seas.ToArray(), typeof(K12sea), "K12sea", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12Leas.ToArray(), typeof(K12lea), "K12lea", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12CharterSchoolAuthorizers.ToArray(), typeof(K12CharterSchoolAuthorizer), "K12CharterSchoolAuthorizer", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12CharterSchoolManagementOrganizations.ToArray(), typeof(K12CharterSchoolManagementOrganization), "K12CharterSchoolManagementOrganization", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12Schools.ToArray(), typeof(K12school), "K12school", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.Locations.ToArray(), typeof(Location), "Location", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.OrganizationLocations.ToArray(), typeof(OrganizationLocation), "OrganizationLocation", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.LocationAddresses.ToArray(), typeof(LocationAddress), "LocationAddress", "dbo", false));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12LeaTitleISupportServices.ToArray(), typeof(K12leaTitleIsupportService), "K12leaTitleIsupportService", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12ProgramOrServices.ToArray(), typeof(K12programOrService), "K12programOrService", "dbo", false));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12titleIiilanguageInstructions.ToArray(), typeof(K12titleIiilanguageInstruction), "K12titleIiilanguageInstruction", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.OrganizationRelationships.ToArray(), typeof(OrganizationRelationship), "OrganizationRelationship", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.OrganizationOperationalStatuses.ToArray(), typeof(OrganizationOperationalStatus), "OrganizationOperationalStatus", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.OrganizationFederalAccountabilities.ToArray(), typeof(OrganizationFederalAccountability), "OrganizationFederalAccountability", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.OrganizationCalendars.ToArray(), typeof(OrganizationCalendar), "OrganizationCalendar", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.OrganizationCalendarSessions.ToArray(), typeof(OrganizationCalendarSession), "OrganizationCalendarSession", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12FederalFundAllocations.ToArray(), typeof(K12FederalFundAllocation), "K12FederalFundAllocation", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12LeaFederalFunds.ToArray(), typeof(K12LeaFederalFunds), "K12LeaFederalFunds", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.FinancialAccounts.ToArray(), typeof(FinancialAccount), "FinancialAccount", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.OrganizationFinancials.ToArray(), typeof(OrganizationFinancial), "OrganizationFinancial", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12SchoolImprovements.ToArray(), typeof(K12schoolImprovement), "K12schoolImprovement", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12SchoolGradeOffereds.ToArray(), typeof(K12schoolGradeOffered), "K12schoolGradeOffered", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.OrganizationProgramTypes.ToArray(), typeof(OrganizationProgramType), "OrganizationProgramType", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12SchoolStatuses.ToArray(), typeof(K12schoolStatus), "K12schoolStatus", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12SchoolIndicatorStatuses.ToArray(), typeof(K12schoolIndicatorStatus), "K12SchoolIndicatorStatus", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.AssessmentAdministrationOrganizations.ToArray(), typeof(AssessmentAdministrationOrganization), "AssessmentAdministration_Organization", "dbo", true));
              
                

                if (testData.Persons.Any())
                {
                    output.AppendLine();
                    output.AppendLine("-- Persons");
                    output.AppendLine("--------------------------");
                    output.AppendLine();
                }

                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.Persons.ToArray(), typeof(Person), "Person", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.PersonDetails.ToArray(), typeof(PersonDetail), "PersonDetail", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.OrganizationPersonRoles.ToArray(), typeof(OrganizationPersonRole), "OrganizationPersonRole", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.OrganizationPersonRoleRelations.ToArray(), typeof(OrganizationPersonRoleRelationship), "OrganizationPersonRoleRelationship", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12organizationStudentResponsibilities.ToArray(), typeof(K12organizationStudentResponsibility), "K12organizationStudentResponsibility", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.PersonStatuses.ToArray(), typeof(PersonStatus), "PersonStatus", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.PersonDisabilities.ToArray(), typeof(PersonDisability), "PersonDisability", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.PersonHomelessnesses.ToArray(), typeof(PersonHomelessness), "PersonHomelessness", "dbo", false));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.PersonLanguages.ToArray(), typeof(PersonLanguage), "PersonLanguage", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.PersonDemographicRaces.ToArray(), typeof(PersonDemographicRace), "PersonDemographicRace", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.PersonIdentifiers.ToArray(), typeof(PersonIdentifier), "PersonIdentifier", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12studentDisciplines.ToArray(), typeof(K12studentDiscipline), "K12studentDiscipline", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.Incidents.ToArray(), typeof(Incident), "Incident", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12studentEnrollments.ToArray(), typeof(K12studentEnrollment), "K12studentEnrollment", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12studentCohorts.ToArray(), typeof(K12studentCohort), "K12studentCohort", "dbo", false));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12studentAcademicRecords.ToArray(), typeof(K12studentAcademicRecord), "K12studentAcademicRecord", "dbo", false));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.RoleAttendances.ToArray(), typeof(RoleAttendance), "RoleAttendance", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.PersonProgramParticipations.ToArray(), typeof(PersonProgramParticipation), "PersonProgramParticipation", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.AssessmentRegistrations.ToArray(), typeof(AssessmentRegistration), "AssessmentRegistration", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.ProgramParticipationSpecialEducations.ToArray(), typeof(ProgramParticipationSpecialEducation), "ProgramParticipationSpecialEducation", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.ProgramParticipationCtes.ToArray(), typeof(ProgramParticipationCte), "ProgramParticipationCte", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.WorkforceEmploymentQuarterlyDatas.ToArray(), typeof(WorkforceEmploymentQuarterlyData), "WorkforceEmploymentQuarterlyData", "dbo", false));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.WorkforceProgramParticipations.ToArray(), typeof(WorkforceProgramParticipation), "WorkforceProgramParticipation", "dbo", false));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.ProgramParticipationTitleIiileps.ToArray(), typeof(ProgramParticipationTitleIiilep), "ProgramParticipationTitleIiilep", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.ProgramParticipationMigrants.ToArray(), typeof(ProgramParticipationMigrant), "ProgramParticipationMigrant", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.ProgramParticipationNeglecteds.ToArray(), typeof(ProgramParticipationNeglected), "ProgramParticipationNeglected", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.ProgramParticipationNeglectedProgressLevels.ToArray(), typeof(ProgramParticipationNeglectedProgressLevel), "ProgramParticipationNeglectedProgressLevel", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.AssessmentResults.ToArray(), typeof(AssessmentResult), "AssessmentResult", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.AssessmentResult_PerformanceLevels.ToArray(), typeof(AssessmentResult_PerformanceLevel), "AssessmentResult_PerformanceLevel", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.K12staffAssignments.ToArray(), typeof(K12staffAssignment), "K12staffAssignment", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.AeStaffs.ToArray(), typeof(AeStaff), "AeStaff", "dbo", false));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.PersonCredentials.ToArray(), typeof(PersonCredential), "PersonCredential", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.StaffCredentials.ToArray(), typeof(StaffCredential), "StaffCredential", "dbo", true));

                
            }
            else if (this.FormatType == "c#")
            {

                output.AppendLine();
                output.AppendLine("         testData = new OdsTestDataObject()");
                output.AppendLine("         {");

                output.AppendLine("             TestDataSection = \"" + testData.TestDataSection + "\",");
                output.AppendLine("             TestDataSectionDescription = \"" + testData.TestDataSectionDescription + "\",");
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.Assessments.ToArray(), typeof(Assessment), "Assessments", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.AssessmentForms.ToArray(), typeof(AssessmentForm), "AssessmentForms", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.AssessmentSubtests.ToArray(), typeof(AssessmentSubtest), "AssessmentSubtests", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.AssessmentPerformanceLevels.ToArray(), typeof(AssessmentPerformanceLevel), "AssessmentPerformanceLevels", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.AssessmentAdministrations.ToArray(), typeof(AssessmentAdministration), "AssessmentAdministrations", ","));


                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.RefIndicatorStatusCustomTypes.ToArray(), typeof(RefIndicatorStatusCustomType), "RefIndicatorStatusCustomTypes", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.Organizations.ToArray(), typeof(Organization), "Organizations", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.Roles.ToArray(), typeof(Role), "Roles", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationDetails.ToArray(), typeof(OrganizationDetail), "OrganizationDetails", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationWebsites.ToArray(), typeof(OrganizationWebsite), "OrganizationWebsites", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationTelephones.ToArray(), typeof(OrganizationTelephone), "OrganizationTelephones", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationIdentifiers.ToArray(), typeof(OrganizationIdentifier), "OrganizationIdentifiers", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationIndicators.ToArray(), typeof(OrganizationIndicator), "OrganizationIndicators", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12Seas.ToArray(), typeof(K12sea), "K12Seas", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12Leas.ToArray(), typeof(K12lea), "K12Leas", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12Schools.ToArray(), typeof(K12school), "K12Schools", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.Locations.ToArray(), typeof(Location), "Locations", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationLocations.ToArray(), typeof(OrganizationLocation), "OrganizationLocations", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.LocationAddresses.ToArray(), typeof(LocationAddress), "LocationAddresses", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12LeaTitleISupportServices.ToArray(), typeof(K12leaTitleIsupportService), "K12LeaTitleISupportServices", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12ProgramOrServices.ToArray(), typeof(K12programOrService), "K12ProgramOrServices", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12titleIiilanguageInstructions.ToArray(), typeof(K12titleIiilanguageInstruction), "K12titleIiilanguageInstructions", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationRelationships.ToArray(), typeof(OrganizationRelationship), "OrganizationRelationships", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationOperationalStatuses.ToArray(), typeof(OrganizationOperationalStatus), "OrganizationOperationalStatuses", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationFederalAccountabilities.ToArray(), typeof(OrganizationFederalAccountability), "OrganizationFederalAccountabilities", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationCalendars.ToArray(), typeof(OrganizationCalendar), "OrganizationCalendars", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationCalendarSessions.ToArray(), typeof(OrganizationCalendarSession), "OrganizationCalendarSessions", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12FederalFundAllocations.ToArray(), typeof(K12FederalFundAllocation), "K12FederalFundAllocations", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12LeaFederalFunds.ToArray(), typeof(K12LeaFederalFunds), "K12LeaFederalFunds", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.FinancialAccounts.ToArray(), typeof(FinancialAccount), "FinancialAccounts", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationFinancials.ToArray(), typeof(OrganizationFinancial), "OrganizationFinancials", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12SchoolImprovements.ToArray(), typeof(K12schoolImprovement), "K12SchoolImprovements", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12SchoolGradeOffereds.ToArray(), typeof(K12schoolGradeOffered), "K12SchoolGradeOffereds", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationProgramTypes.ToArray(), typeof(OrganizationProgramType), "OrganizationProgramTypes", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12SchoolStatuses.ToArray(), typeof(K12schoolStatus), "K12SchoolStatuses", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12SchoolIndicatorStatuses.ToArray(), typeof(K12schoolIndicatorStatus), "K12SchoolIndicatorStatuses", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.AssessmentAdministrationOrganizations.ToArray(), typeof(AssessmentAdministrationOrganization), "AssessmentAdministrationOrganizations", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12CharterSchoolAuthorizers.ToArray(), typeof(K12CharterSchoolAuthorizer), "K12CharterSchoolAuthorizers", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12CharterSchoolManagementOrganizations.ToArray(), typeof(K12CharterSchoolManagementOrganization), "K12CharterSchoolManagementOrganizations", ","));

                

                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.Persons.ToArray(), typeof(Person), "Persons", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.PersonDetails.ToArray(), typeof(PersonDetail), "PersonDetails", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationPersonRoles.ToArray(), typeof(OrganizationPersonRole), "OrganizationPersonRoles", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.OrganizationPersonRoleRelations.ToArray(), typeof(OrganizationPersonRoleRelationship), "OrganizationPersonRoleRelations", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12organizationStudentResponsibilities.ToArray(), typeof(K12organizationStudentResponsibility), "K12organizationStudentResponsibilities", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.PersonStatuses.ToArray(), typeof(PersonStatus), "PersonStatuses", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.PersonDisabilities.ToArray(), typeof(PersonDisability), "PersonDisabilities", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.PersonHomelessnesses.ToArray(), typeof(PersonHomelessness), "PersonHomelessnesses", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.PersonLanguages.ToArray(), typeof(PersonLanguage), "PersonLanguages", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.PersonDemographicRaces.ToArray(), typeof(PersonDemographicRace), "PersonDemographicRaces", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.PersonIdentifiers.ToArray(), typeof(PersonIdentifier), "PersonIdentifiers", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12studentDisciplines.ToArray(), typeof(K12studentDiscipline), "K12studentDisciplines", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.Incidents.ToArray(), typeof(Incident), "Incidents", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12studentEnrollments.ToArray(), typeof(K12studentEnrollment), "K12studentEnrollments", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12studentCohorts.ToArray(), typeof(K12studentCohort), "K12studentCohorts", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12studentAcademicRecords.ToArray(), typeof(K12studentAcademicRecord), "K12studentAcademicRecords", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.RoleAttendances.ToArray(), typeof(RoleAttendance), "RoleAttendances", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.PersonProgramParticipations.ToArray(), typeof(PersonProgramParticipation), "PersonProgramParticipations", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.AssessmentRegistrations.ToArray(), typeof(AssessmentRegistration), "AssessmentRegistrations", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.ProgramParticipationSpecialEducations.ToArray(), typeof(ProgramParticipationSpecialEducation), "ProgramParticipationSpecialEducations", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.ProgramParticipationCtes.ToArray(), typeof(ProgramParticipationCte), "ProgramParticipationCtes", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.WorkforceEmploymentQuarterlyDatas.ToArray(), typeof(WorkforceEmploymentQuarterlyData), "WorkforceEmploymentQuarterlyDatas", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.WorkforceProgramParticipations.ToArray(), typeof(WorkforceProgramParticipation), "WorkforceProgramParticipations", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.ProgramParticipationTitleIiileps.ToArray(), typeof(ProgramParticipationTitleIiilep), "ProgramParticipationTitleIiileps", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.ProgramParticipationMigrants.ToArray(), typeof(ProgramParticipationMigrant), "ProgramParticipationMigrants", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.ProgramParticipationNeglecteds.ToArray(), typeof(ProgramParticipationNeglected), "ProgramParticipationNeglecteds", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesSql(testData.ProgramParticipationNeglectedProgressLevels.ToArray(), typeof(ProgramParticipationNeglectedProgressLevel), "ProgramParticipationNeglectedProgressLevel", "dbo", true));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.AssessmentResults.ToArray(), typeof(AssessmentResult), "AssessmentResults", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.AssessmentResult_PerformanceLevels.ToArray(), typeof(AssessmentResult_PerformanceLevel), "AssessmentResult_PerformanceLevels", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.K12staffAssignments.ToArray(), typeof(K12staffAssignment), "K12staffAssignments", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.AeStaffs.ToArray(), typeof(AeStaff), "AeStaffs", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.PersonCredentials.ToArray(), typeof(PersonCredential), "PersonCredentials", ","));
                output = _outputHelper.AppendOutputIfNotEmpty(output, _outputHelper.GetTestDataValuesCSharp(testData.StaffCredentials.ToArray(), typeof(StaffCredential), "StaffCredentials", ""));

                

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

        public IdsTestDataObject GetFreshTestDataObject(int seaOrganizationId = 0)
        {
            this.InitializeVariables(this.FilePath, this.Seed, this.FormatType, this.OutputType);

            IdsTestDataObject testData = new IdsTestDataObject()
            {
                TestDatatype = "ods",
                QuantityOfLeas = 0,
                QuantityOfSchools = 0,
                QuantityOfPersonnel = 0,
                QuantityOfStudents = 0,
                SeaOrganizationId = seaOrganizationId,
                LeaOrganizationIds = new List<int>(),
                SchoolOrganizationIds = new List<int>(),
                StudentPersonIds = new List<int>(),
                PersonnelPersonIds = new List<int>(),
                Roles = new List<Role>(),
                Assessments = new List<Assessment>(),
                AssessmentForms = new List<AssessmentForm>(),
                AssessmentSubtests = new List<AssessmentSubtest>(),
                AssessmentPerformanceLevels = new List<AssessmentPerformanceLevel>(),
                AssessmentAdministrations = new List<AssessmentAdministration>(),
                AssessmentAdministrationOrganizations = new List<AssessmentAdministrationOrganization>(),
                RefIndicatorStatusCustomTypes = new List<RefIndicatorStatusCustomType>(),
                Organizations = new List<Organization>(),
                OrganizationDetails = new List<OrganizationDetail>(),
                OrganizationWebsites = new List<OrganizationWebsite>(),
                OrganizationTelephones = new List<OrganizationTelephone>(),
                Locations = new List<Location>(),
                LocationAddresses = new List<LocationAddress>(),
                OrganizationLocations = new List<OrganizationLocation>(),
                OrganizationIdentifiers = new List<OrganizationIdentifier>(),
                OrganizationIndicators = new List<OrganizationIndicator>(),
                K12titleIiilanguageInstructions = new List<K12titleIiilanguageInstruction>(),
                OrganizationRelationships = new List<OrganizationRelationship>(),
                OrganizationOperationalStatuses = new List<OrganizationOperationalStatus>(),
                OrganizationFederalAccountabilities = new List<OrganizationFederalAccountability>(),
                OrganizationCalendars = new List<OrganizationCalendar>(),
                OrganizationCalendarSessions = new List<OrganizationCalendarSession>(),
                K12Seas = new List<K12sea>(),
                K12Leas = new List<K12lea>(),
                K12LeaTitleISupportServices = new List<K12leaTitleIsupportService>(),
                K12ProgramOrServices = new List<K12programOrService>(),
                K12Schools = new List<K12school>(),
                K12FederalFundAllocations = new List<K12FederalFundAllocation>(),
                K12LeaFederalFunds = new List<K12LeaFederalFunds>(),
                OrganizationFinancials = new List<OrganizationFinancial>(),
                FinancialAccounts = new List<FinancialAccount>(),
                K12SchoolImprovements = new List<K12schoolImprovement>(),
                K12SchoolGradeOffereds = new List<K12schoolGradeOffered>(),
                OrganizationProgramTypes = new List<OrganizationProgramType>(),
                K12SchoolStatuses = new List<K12schoolStatus>(),
                K12SchoolIndicatorStatuses = new List<K12schoolIndicatorStatus>(),
                Persons = new List<Person>(),
                PersonDetails = new List<PersonDetail>(),
                OrganizationPersonRoles = new List<OrganizationPersonRole>(),
                OrganizationPersonRoleRelations = new List<OrganizationPersonRoleRelationship>(),
                K12organizationStudentResponsibilities = new List<K12organizationStudentResponsibility>(),
                PersonStatuses = new List<PersonStatus>(),
                PersonDisabilities = new List<PersonDisability>(),
                PersonHomelessnesses = new List<PersonHomelessness>(),
                PersonLanguages = new List<PersonLanguage>(),
                PersonDemographicRaces = new List<PersonDemographicRace>(),
                PersonIdentifiers = new List<PersonIdentifier>(),
                K12studentDisciplines = new List<K12studentDiscipline>(),
                Incidents = new List<Incident>(),
                K12studentEnrollments = new List<K12studentEnrollment>(),
                K12studentCohorts = new List<K12studentCohort>(),
                K12studentAcademicRecords = new List<K12studentAcademicRecord>(),
                RoleAttendances = new List<RoleAttendance>(),
                PersonProgramParticipations = new List<PersonProgramParticipation>(),
                AssessmentRegistrations = new List<AssessmentRegistration>(),
                ProgramParticipationSpecialEducations = new List<ProgramParticipationSpecialEducation>(),
                ProgramParticipationCtes = new List<ProgramParticipationCte>(),
                WorkforceEmploymentQuarterlyDatas = new List<WorkforceEmploymentQuarterlyData>(),
                WorkforceProgramParticipations = new List<WorkforceProgramParticipation>(),
                ProgramParticipationTitleIiileps = new List<ProgramParticipationTitleIiilep>(),
                ProgramParticipationMigrants = new List<ProgramParticipationMigrant>(),
                ProgramParticipationNeglecteds = new List<ProgramParticipationNeglected>(),
                ProgramParticipationNeglectedProgressLevels = new List<ProgramParticipationNeglectedProgressLevel>(),
                AssessmentResults = new List<AssessmentResult>(),
                AssessmentResult_PerformanceLevels = new List<AssessmentResult_PerformanceLevel>(),
                K12staffAssignments = new List<K12staffAssignment>(),
                AeStaffs = new List<AeStaff>(),
                PersonCredentials = new List<PersonCredential>(),
                StaffCredentials = new List<StaffCredential>(),
                K12CharterSchoolAuthorizers = new List<K12CharterSchoolAuthorizer>(),
                K12CharterSchoolManagementOrganizations = new List<K12CharterSchoolManagementOrganization>()
            };

            return testData;
        }

        public IdsTestDataObject CreateGenerateOrganization(Random rnd, IdsTestDataObject testData, out int generateOrganizationId)
        {

            Organization organization = new Organization()
            {
                OrganizationId = this.SetAndGetMaxId("Organizations")
            };

            testData.Organizations.Add(organization);

            generateOrganizationId = organization.OrganizationId;

            // OrganizationDetail

            var organizationElementTypeId = this.OdsReferenceData.RefOrganizationElementTypes.Single(o => o.Code == "001156").RefOrganizationElementTypeId;


            var otherRefOrganizationTypeId = this.OdsReferenceData.RefOrganizationTypes.Single(o => o.Code == "Employer" && o.RefOrganizationElementTypeId == organizationElementTypeId).RefOrganizationTypeId;

            
            OrganizationDetail organizationDetail = new OrganizationDetail()
            {
                OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                OrganizationId = organization.OrganizationId,
                Name = "Generate",
                RefOrganizationTypeId = otherRefOrganizationTypeId,
                ShortName = "Generate",
                RecordStartDateTime = new DateTime(1900, 1, 1)
            };

            testData.OrganizationDetails.Add(organizationDetail);

            // RefIndicatorStatusCustomType

            testData.RefIndicatorStatusCustomTypes.Add(new RefIndicatorStatusCustomType()
            {
                RefIndicatorStatusCustomTypeId = this.SetAndGetMaxId("RefIndicatorStatusCustomTypes"),
                Code = "IND01",
                Description = "Chronic Absenteeism"
            });

            testData.RefIndicatorStatusCustomTypes.Add(new RefIndicatorStatusCustomType()
            {
                RefIndicatorStatusCustomTypeId = this.SetAndGetMaxId("RefIndicatorStatusCustomTypes"),
                Code = "IND02",
                Description = "Access to Advanced Coursework"
            });

            return testData;
        }

        public IdsTestDataObject CreateRoles(IdsTestDataObject testData, int generateOrganizationId)
        {
            testData.Roles.Add(new Role()
            {
                RoleId = this.SetAndGetMaxId("Roles"),
                Name = "K12 Student",
                RefJurisdictionId = generateOrganizationId
            });

            testData.Roles.Add(new Role()
            {
                RoleId = this.SetAndGetMaxId("Roles"),
                Name = "K12 Personnel",
                RefJurisdictionId = generateOrganizationId
            });

            testData.Roles.Add(new Role()
            {
                RoleId = this.SetAndGetMaxId("Roles"),
                Name = "Chief State School Officer",
                RefJurisdictionId = generateOrganizationId
            });

            foreach (var role in testData.Roles)
            {
                this.AllRoles.Add(role);
            }

            return testData;
        }

        public IdsTestDataObject CreateAssessments(Random rnd, IdsTestDataObject testData, int numberOfAssessments)
        {

            // Assessments

            for (int i = 0; i < numberOfAssessments; i++)
            {
                string refAcademicSubjectCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAcademicSubjectDistribution);
                int refAcademicSubjectId = this.OdsReferenceData.RefAcademicSubjects.Single(x => x.Code == refAcademicSubjectCode).RefAcademicSubjectId;
                string refAcademicSubjectDescription = this.OdsReferenceData.RefAcademicSubjects.Single(x => x.Code == refAcademicSubjectCode).Description;
                string refAssessmentPurpose = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAssessmentPurposeDistribution);

                string refAssessmentTypeChildrenWithDisabilitiesCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAssessmentTypeChildrenWithDisabilitiesDistribution);
                int? refAssessmentTypeChildrenWithDisabilitiesId = null;

                string refAssessmentTypeAdministeredToEnglishLearnersCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAssessmentTypeAdministeredToEnglishLearnersDistribution);
                int? refAssessmentTypeAdministeredToEnglishLearnersId = null;


                if (refAssessmentTypeChildrenWithDisabilitiesCode != "-1")
                {
                    refAssessmentTypeChildrenWithDisabilitiesId = this.OdsReferenceData.RefAssessmentTypeChildrenWithDisabilities.Single(x => x.Code == refAssessmentTypeChildrenWithDisabilitiesCode).RefAssessmentTypeChildrenWithDisabilitiesId;
                }

                if (refAssessmentTypeAdministeredToEnglishLearnersCode != "-1")
                {
                    refAssessmentTypeAdministeredToEnglishLearnersId = this.OdsReferenceData.RefAssessmentTypeAdministeredToEnglishLearners.Single(x => x.Code == refAssessmentTypeAdministeredToEnglishLearnersCode).RefAssessmentTypeAdministeredToEnglishLearnersId;
                }

                if (refAcademicSubjectDescription.Length > 40)
                {
                    refAcademicSubjectDescription = refAcademicSubjectDescription.Substring(0, 40);
                }

                var assessment = new Assessment()
                {
                    AssessmentId = this.SetAndGetMaxId("Assessments"),
                    Title = refAcademicSubjectDescription + " Assessment",
                    AssessmentFamilyTitle = refAcademicSubjectDescription + " Family",
                    RefAcademicSubjectId = refAcademicSubjectId,
                    RefAssessmentTypeChildrenWithDisabilitiesId = refAssessmentTypeChildrenWithDisabilitiesId,
                    RefAssessmentTypeAdministeredToEnglishLearnersId = refAssessmentTypeAdministeredToEnglishLearnersId
                };

                testData.Assessments.Add(assessment);

                // AssessmentForm

                string assessmentFormName = assessment.Title;
                if (assessmentFormName.Length > 35)
                {
                    assessmentFormName = assessmentFormName.Substring(0, 35);
                }

                var assessmentForm = new AssessmentForm()
                {
                    AssessmentFormId = this.SetAndGetMaxId("AssessmentForms"),
                    AssessmentId = assessment.AssessmentId,
                    Name = assessmentFormName
                };

                testData.AssessmentForms.Add(assessmentForm);
                this.AllAssessmentForms.Add(assessmentForm);


                // AssessmentSubtest

                var assessmentSubtest = new AssessmentSubtest()
                {
                    AssessmentSubtestId = this.SetAndGetMaxId("AssessmentSubtests"),
                    AssessmentFormId = assessmentForm.AssessmentFormId,
                    Title = assessmentForm.Name
                };

                testData.AssessmentSubtests.Add(assessmentSubtest);
                this.AllAssessmentSubtests.Add(assessmentSubtest);

                // AssessmentPerformanceLevel

                int minimumPerformanceLevel = _testDataHelper.GetRandomIntInRange(rnd, 1, 2);
                int maximumPerformanceLevel = _testDataHelper.GetRandomIntInRange(rnd, 5, 6);

                for (int performanceLevel = minimumPerformanceLevel; performanceLevel <= maximumPerformanceLevel; performanceLevel++)
                {
                    int lowerScore = 0;
                    int upperScore = 100;

                    switch (performanceLevel)
                    {
                        case 1:
                            lowerScore = 0;
                            upperScore = 49;
                            break;
                        case 2:
                            lowerScore = 50;
                            upperScore = 59;
                            break;
                        case 3:
                            lowerScore = 60;
                            upperScore = 69;
                            break;
                        case 4:
                            lowerScore = 70;
                            upperScore = 79;
                            break;
                        case 5:
                            lowerScore = 80;
                            upperScore = 89;
                            break;
                        case 6:
                            lowerScore = 90;
                            upperScore = 100;
                            break;

                        default:
                            break;
                    }

                    var assessmentPerformanceLevel = new AssessmentPerformanceLevel()
                    {
                        AssessmentPerformanceLevelId = this.SetAndGetMaxId("AssessmentPerformanceLevels"),
                        AssessmentSubtestId = assessmentSubtest.AssessmentSubtestId,
                        Identifier = "L" + performanceLevel,
                        Label = "Level " + performanceLevel,
                        LowerCutScore = lowerScore.ToString(),
                        UpperCutScore = upperScore.ToString()
                    };

                    testData.AssessmentPerformanceLevels.Add(assessmentPerformanceLevel);
                    this.AllAssessmentPerformanceLevels.Add(assessmentPerformanceLevel);
                }

                // AssessmentAdministration


                int startingYear = _testDataProfile.OldestStartingYear;
                int endingYear = SchoolYear;

                for (int administrationYear = startingYear; administrationYear <= endingYear; administrationYear++)
                {

                    int randomDuration = _testDataHelper.GetRandomInt(rnd, new List<int>() { 1, 2, 3, 4 });

                    // Current Year
                    var assessmentStartDate = _testDataHelper.GetSessionStartDate(rnd, administrationYear).AddDays(90);

                    var assessmentAdministration = new AssessmentAdministration()
                    {
                        AssessmentAdministrationId = this.SetAndGetMaxId("AssessmentAdministrations"),
                        AssessmentId = assessment.AssessmentId,
                        StartDate = assessmentStartDate,
                        FinishDate = assessmentStartDate.AddDays(randomDuration)
                    };

                    testData.AssessmentAdministrations.Add(assessmentAdministration);
                    this.AllAssessmentAdministrations.Add(assessmentAdministration);
                }



            }


            return testData;
        }

        public IdsTestDataObject CreateOrganizations(Random rnd, int quantityInBatch, int seaOrganizationId, RefState refState)
        {

            IdsTestDataObject testData = this.GetFreshTestDataObject(seaOrganizationId);

            while (testData.QuantityOfLeas < quantityInBatch)
            {

                // LEA
                int leaOrganizationId = 0;
                testData = CreateLea(rnd, testData, seaOrganizationId, refState, out leaOrganizationId);
                this.AllLeaIds.Add(leaOrganizationId);

                // Schools
                string leaGeographicType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LeaGeographicDistribution);
                int numberOfSchoolsInLea = _testDataHelper.GetRandomIntInRange(rnd, _testDataProfile.MinimumSchoolsPerLeaRural, _testDataProfile.MaximumSchoolsPerLeaRural);
                if (leaGeographicType == "Urban")
                {
                    numberOfSchoolsInLea = _testDataHelper.GetRandomIntInRange(rnd, _testDataProfile.MinimumSchoolsPerLeaUrban, _testDataProfile.MaximumSchoolsPerLeaUrban);
                }

                for (int i = 0; i < numberOfSchoolsInLea; i++)
                {

                    OrganizationDetail schoolOrganizationDetail = null;
                    testData = CreateSchool(rnd, testData, i, refState, leaOrganizationId, out schoolOrganizationDetail);
                    this.AllSchools.Add(testData.OrganizationDetails.Single(x => x.OrganizationId == schoolOrganizationDetail.OrganizationId));
                }

                if (_showDebugInfo)
                {
                    Console.WriteLine("LEA " + leaOrganizationId + " / # Schools = " + numberOfSchoolsInLea);
                }
            }

            return testData;
        }

        public IdsTestDataObject CreatePersons(Random rnd, int quantityInBatch, int seaOrganizationId, RefState refState)
        {

            IdsTestDataObject testData = this.GetFreshTestDataObject(seaOrganizationId);

            var studentRole = this.AllRoles.Single(x => x.Name == "K12 Student");
            var personnelRole = this.AllRoles.Single(x => x.Name == "K12 Personnel");

            // Students

            testData = this.CreateStudentsAndPersonnel(rnd, quantityInBatch, testData, studentRole);

            testData.QuantityOfStudents += quantityInBatch;

            // Personnel
            int studentTeacherRatio = _testDataHelper.GetRandomIntInRange(rnd, _testDataProfile.MinimumStudentTeacherRatio, _testDataProfile.MaximumStudentsTeacherRatio);

            int quantityOfPersonnelInBatch = quantityInBatch / studentTeacherRatio;

            if (quantityOfPersonnelInBatch < 1)
            {
                quantityOfPersonnelInBatch = 1;
            }

            testData = CreateStudentsAndPersonnel(rnd, quantityOfPersonnelInBatch, testData, personnelRole);

            testData.QuantityOfPersonnel += quantityOfPersonnelInBatch;

            return testData;

        }

        public IdsTestDataObject CreateSea(Random rnd, IdsTestDataObject testData, out int seaOrganizationId, out RefState refState)
        {
            Organization organization = new Organization()
            {
                OrganizationId = this.SetAndGetMaxId("Organizations")
            };

            testData.Organizations.Add(organization);


            seaOrganizationId = organization.OrganizationId;
            testData.SeaOrganizationId = organization.OrganizationId;


            // OrganizationDetail


            // Reference Data

            var organizationElementType = this.OdsReferenceData.RefOrganizationElementTypes.Single(x => x.Code == "001156");
            var seaOrganizationTypeId = this.OdsReferenceData.RefOrganizationTypes.Single(x => x.Code == "SEA" && x.RefOrganizationElementTypeId == organizationElementType.RefOrganizationElementTypeId).RefOrganizationTypeId;

            // OrganizationDetail

            // Determine State
            var randomRefState = _testDataHelper.GetRandomObject<RefState>(rnd, this.OdsReferenceData.RefStates);
            var refStateAnsicode = this.OdsReferenceData.RefStateAnsicodes.FirstOrDefault(x => x.StateName == randomRefState.Description);

            // Find a new state if we cannot find an ANSI code for that state
            while (refStateAnsicode == null)
            {
                randomRefState = _testDataHelper.GetRandomObject<RefState>(rnd, this.OdsReferenceData.RefStates);
                refStateAnsicode = this.OdsReferenceData.RefStateAnsicodes.FirstOrDefault(x => x.StateName == randomRefState.Description);
            }

            refState = randomRefState;

            string organizationName = _testDataHelper.GetK12SeaName(refState.Description);
            string shortName = _testDataHelper.MakeAcronym(organizationName);
            var recordStartDateTime = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(1920, 1, 1), new DateTime(SchoolYear, 6, 30));

            OrganizationDetail organizationDetail = new OrganizationDetail()
            {
                OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                OrganizationId = seaOrganizationId,
                Name = organizationName,
                RefOrganizationTypeId = seaOrganizationTypeId,
                ShortName = shortName,
                RecordStartDateTime = recordStartDateTime
            };

            testData.OrganizationDetails.Add(organizationDetail);

            // OrganizationOperationalStatus

            var numberOfYears = SchoolYear - _testDataProfile.OldestStartingYear;
            //var organizationStartDateTime = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(1920, 1, 1), DateTime.Now.AddYears(-5));

            for (int i = 0; i < numberOfYears; i++)
            {
                //var effectiveDate = _testDataHelper.GetSessionStartDate(rnd, DateTime.Now.Year - i);

                //organizationStartDateTime = _testDataHelper.GetSessionStartDate(rnd, DateTime.Now.Year + 1).AddMonths(-2);
                //effectiveDate = organizationStartDateTime;

                
                int year = SchoolYear - i;

                // OrganizationCalendar

                OrganizationCalendar organizationCalendar = new OrganizationCalendar()
                {
                    OrganizationCalendarId = this.SetAndGetMaxId("OrganizationCalendars"),
                    OrganizationId = seaOrganizationId,
                    CalendarCode = year.ToString() + seaOrganizationId.ToString().PadLeft(10, '0'),
                    CalendarYear = year.ToString(),
                    CalendarDescription = $"FiscalYear{year}"
                };

                testData.OrganizationCalendars.Add(organizationCalendar);

                // OrganizationCalendarSession

                string yearDesignator = (year - 1).ToString() + "-" + year.ToString().Substring(2, 2);

                DateTime? sessionStart = _testDataHelper.GetSessionStartDate(rnd, year);
                DateTime? sessionEnd = _testDataHelper.GetSessionEndDate(rnd, year);

                OrganizationCalendarSession organizationCalendarSession = new OrganizationCalendarSession()
                {
                    OrganizationCalendarSessionId = this.SetAndGetMaxId("OrganizationCalendarSessions"),
                    OrganizationCalendarId = organizationCalendar.OrganizationCalendarId,
                    Designator = yearDesignator,
                    Code = organizationCalendar.CalendarCode,
                    Description = organizationCalendar.CalendarDescription,
                    RefSessionTypeId = this.OdsReferenceData.FullSchoolYearTypeId,
                    BeginDate = sessionStart,
                    EndDate = sessionEnd
                };

                testData.OrganizationCalendarSessions.Add(organizationCalendarSession);

                // K12FederalFundAllocation

               
              
                foreach (string federalCode in _testDataProfile.FederalProgramCodes)
                {

                    var refFederalProgramFundingAllocationTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefFederalProgramFundingAllocationTypeDistribution);
                    var refFederalProgramFundingAllocationTypeId = this.OdsReferenceData.RefFederalProgramFundingAllocationTypes.Single(x => x.Code == refFederalProgramFundingAllocationTypeCode).RefFederalProgramFundingAllocationTypeId;

                    var refReapAlternativeFundingStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefReapAlternativeFundingStatusDistribution);
                    var refReapAlternativeFundingStatusId = this.OdsReferenceData.RefReapAlternativeFundingStatuses.Single(x => x.Code == refReapAlternativeFundingStatusCode).RefReapAlternativeFundingStatusId;


                    K12FederalFundAllocation k12FederalFundAllocation = new K12FederalFundAllocation()
                    {
                        K12FederalFundAllocationId = this.SetAndGetMaxId("K12FederalFundAllocations"),
                        OrganizationCalendarSessionId = organizationCalendarSession.OrganizationCalendarSessionId,
                        RecordStartDateTime = sessionStart,
                        RecordEndDateTime = sessionEnd,
                        FederalProgramCode = federalCode,
                        FederalProgramsFundingAllocation = _testDataHelper.GetRandomDecimalInRange(rnd, 100000, 400000),
                        SchoolImprovementAllocation = _testDataHelper.GetRandomDecimalInRange(rnd, 100000, 400000),
                        RefReapAlternativeFundingStatusId = refReapAlternativeFundingStatusId,
                        RefFederalProgramFundingAllocationTypeId = refFederalProgramFundingAllocationTypeId
                    };

                    testData.K12FederalFundAllocations.Add(k12FederalFundAllocation);
                }

                



                

                

            }

            // K12sea

            K12sea k12Sea = new K12sea()
            {
                K12SeaId = this.SetAndGetMaxId("K12sea"),
                OrganizationId = seaOrganizationId,
                RefStateAnsicodeId = refStateAnsicode.RefStateAnsicodeId
            };

            testData.K12Seas.Add(k12Sea);

            // OrganizationWebsite
            OrganizationWebsite organizationWebsite = new OrganizationWebsite()
            {
                OrganizationId = seaOrganizationId,
                Website = "https://www." + shortName.ToLower() + ".org"
            };

            testData.OrganizationWebsites.Add(organizationWebsite);

            // OrganizationTelephone
            OrganizationTelephone organizationTelephone = new OrganizationTelephone()
            {
                OrganizationTelephoneId = this.SetAndGetMaxId("OrganizationTelephones"),
                OrganizationId = seaOrganizationId,
                PrimaryTelephoneNumberIndicator = true,
                TelephoneNumber = _testDataHelper.GetRandomIntInRange(rnd, 100, 700) + "-" + _testDataHelper.GetRandomIntInRange(rnd, 100, 700) + "-" + _testDataHelper.GetRandomIntInRange(rnd, 1000, 7000)
            };

            testData.OrganizationTelephones.Add(organizationTelephone);

            // Locations

            bool hasMailingAddress = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasMailingAddressDistribution);
            bool hasShippingAddress = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasMailingAddressDistribution);

            var validRefOrganizationLocationTypes = this.OdsReferenceData.RefOrganizationLocationTypes;

            if (!hasMailingAddress)
            {
                validRefOrganizationLocationTypes = validRefOrganizationLocationTypes.Where(x => x.Code != "Mailing").ToList();
            }
            if (!hasShippingAddress)
            {
                validRefOrganizationLocationTypes = validRefOrganizationLocationTypes.Where(x => x.Code != "Shipping").ToList();
            }


            foreach (var locationType in validRefOrganizationLocationTypes)
            {
                Location location = new Location()
                {
                    LocationId = this.SetAndGetMaxId("Locations"),
                };

                testData.Locations.Add(location);


                // OrganizationLocations

                OrganizationLocation organizationLocation = new OrganizationLocation()
                {
                    OrganizationLocationId = this.SetAndGetMaxId("OrganizationLocations"),
                    LocationId = location.LocationId,
                    OrganizationId = seaOrganizationId,
                    RefOrganizationLocationTypeId = locationType.RefOrganizationLocationTypeId
                };

                testData.OrganizationLocations.Add(organizationLocation);


                // LocationAddresses

                bool includePlus4Code = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IncludePlus4ZipCodeDistribution);

                var streetNumberAndName = _testDataHelper.GetRandomIntInRange(rnd, 1, 20000) + " " + _testDataHelper.GetStreetName(rnd, this.PlaceNames, this.StreetTypes);
                var apartmentRoomOrSuiteNumber = _testDataHelper.GetUnitType(rnd, this.UnitTypes) + _testDataHelper.GetRandomIntInRange(rnd, 1, 50);
                var postalCode = _testDataHelper.GetRandomIntInRange(rnd, 10000, 90000).ToString();

                LocationAddress locationAddress = new LocationAddress()
                {
                    LocationId = location.LocationId,
                    StreetNumberAndName = streetNumberAndName,
                    ApartmentRoomOrSuiteNumber = apartmentRoomOrSuiteNumber,
                    City = _testDataHelper.GetCityName(rnd, this.PlaceNames),
                    PostalCode = postalCode,
                    RefStateId = refState.RefStateId
                };

                if (includePlus4Code)
                {
                    locationAddress.PostalCode = postalCode + "-" + _testDataHelper.GetRandomIntInRange(rnd, 1000, 9000).ToString();
                }

                testData.LocationAddresses.Add(locationAddress);

            }

            // OrganizationIdentifier

            var seaOrganizationIdentifierTypeId = this.OdsReferenceData.RefOrganizationIdentifierTypes.Single(x => x.Code == "001491").RefOrganizationIdentifierTypeId;
            var seaFederalIdentificationSystemId = this.OdsReferenceData.RefOrganizationIdentificationSystems.Single(s => s.Code == "Federal" && s.RefOrganizationIdentifierTypeId == seaOrganizationIdentifierTypeId).RefOrganizationIdentificationSystemId;

            OrganizationIdentifier organizationIdentifier = new OrganizationIdentifier()
            {
                OrganizationIdentifierId = this.SetAndGetMaxId("OrganizationIdentifiers"),
                OrganizationId = seaOrganizationId,
                Identifier = refStateAnsicode.Code,
                RefOrganizationIdentifierTypeId = seaOrganizationIdentifierTypeId,
                RefOrganizationIdentificationSystemId = seaFederalIdentificationSystemId
            };

            testData.OrganizationIdentifiers.Add(organizationIdentifier);

            // CSSO

            var cssoRole = this.AllRoles.Single(x => x.Name == "Chief State School Officer");
            testData = this.CreateStudentsAndPersonnel(rnd, 1, testData, cssoRole);


            return testData;
        }

        private IdsTestDataObject CreateLea(Random rnd, IdsTestDataObject testData, int seaOrganizationId, RefState refState, out int leaOrganizationId)
        {

            testData.QuantityOfLeas += 1;

            // Organization

            Organization organization = new Organization()
            {
                OrganizationId = this.SetAndGetMaxId("Organizations"),
            };

            testData.Organizations.Add(organization);

            testData.LeaOrganizationIds.Add(organization.OrganizationId);
            leaOrganizationId = organization.OrganizationId;

            // Reference Data

            var placeNames = _testDataHelper.ListofPlaceNames();
            var streetTypes = _testDataHelper.ListofStreetTypes();

            var refStateAnsicode = this.OdsReferenceData.RefStateAnsicodes.Single(x => x.StateName == refState.Description);
            var organizationElementType = this.OdsReferenceData.RefOrganizationElementTypes.Single(x => x.Code == "001156");
            var leaOrganizationTypeId = this.OdsReferenceData.RefOrganizationTypes.Single(x => x.Code == "LEA" && x.RefOrganizationElementTypeId == organizationElementType.RefOrganizationElementTypeId).RefOrganizationTypeId;

            var leaOrganizationIdentifierTypeId = this.OdsReferenceData.RefOrganizationIdentifierTypes.Single(x => x.Code == "001072").RefOrganizationIdentifierTypeId;
            var leaNcesIdentificationSystemId = this.OdsReferenceData.RefOrganizationIdentificationSystems.Single(s => s.Code == "NCES" && s.RefOrganizationIdentifierTypeId == leaOrganizationIdentifierTypeId).RefOrganizationIdentificationSystemId;
            var leaSeaIdentificationSystemId = this.OdsReferenceData.RefOrganizationIdentificationSystems.Single(s => s.Code == "SEA" && s.RefOrganizationIdentifierTypeId == leaOrganizationIdentifierTypeId).RefOrganizationIdentificationSystemId;

            bool isOrganizationClosed = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IsOrganizationClosedDistribution);

            var organizationStartDate = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(SchoolYear - 10, 7, 1), new DateTime(SchoolYear, 6, 30));
            DateTime? organizationEndDate = null;

            if (isOrganizationClosed)
            {
                organizationEndDate = _testDataHelper.GetRandomDateInRange(rnd, organizationStartDate, new DateTime(SchoolYear, 6, 30));
            }

            // OrganizationDetail

            string organizationName = _testDataHelper.GetK12LeaName(rnd, placeNames);
            string shortName = _testDataHelper.MakeAcronym(organizationName);

            OrganizationDetail organizationDetail = new OrganizationDetail()
            {
                OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                OrganizationId = leaOrganizationId,
                Name = organizationName,
                RefOrganizationTypeId = leaOrganizationTypeId,
                ShortName = shortName,
                RecordStartDateTime = organizationStartDate,
                RecordEndDateTime = organizationEndDate
            };

            testData.OrganizationDetails.Add(organizationDetail);

            // OrganizationOperationalStatus

            var numberOfYears = (DateTime.Now.Year + 2) - _testDataProfile.OldestStartingYear;
            var organizationStartDateTime = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(1920, 1, 1), new DateTime(SchoolYear - 5, 6, 30));
           
            for (int i = 0; i < numberOfYears; i++)
            {
                var effectiveDate = _testDataHelper.GetSessionStartDate(rnd, SchoolYear - i);
                // .GetRandomDateInRange(rnd, DateTime.Now.AddYears(-i), DateTime.Now.AddYears(i - 1));

                var leaOperationalStatusTypeId = this.OdsReferenceData.RefOperationalStatusTypes.Single(x => x.Code == "000174").RefOperationalStatusTypeId;
                var refOperationalStatuses = this.OdsReferenceData.RefOperationalStatuses.Where(x => x.RefOperationalStatusTypeId == leaOperationalStatusTypeId);

                var refOperationalStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LeaRefOperationalStatusDistribution);
                var refOperationalStatusId = refOperationalStatuses.Single(x => x.Code == refOperationalStatusCode).RefOperationalStatusId;

                
                if (refOperationalStatusCode == "New")
                {
                    // If new, set start date to this summer (a couple months before next school year start)
                    organizationStartDateTime = _testDataHelper.GetSessionStartDate(rnd, SchoolYear).AddMonths(-2);
                    effectiveDate = organizationStartDateTime;
                }



                OrganizationOperationalStatus organizationOperationalStatus = new OrganizationOperationalStatus()
                {
                    OrganizationOperationalStatusId = this.SetAndGetMaxId("OrganizationOperationalStatuses"),
                    OrganizationId = leaOrganizationId,
                    RefOperationalStatusId = refOperationalStatusId,
                    OperationalStatusEffectiveDate = effectiveDate,
                    RecordStartDateTime = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(1910, 1, 1), organizationStartDateTime.AddYears(-1))
                };

                testData.OrganizationOperationalStatuses.Add(organizationOperationalStatus);

                if (refOperationalStatusCode == "Reopened")
                {
                    // If Reopened, add another OperationalStatus in the past

                    OrganizationOperationalStatus organizationOperationalStatus2 = new OrganizationOperationalStatus()
                    {
                        OrganizationOperationalStatusId = this.SetAndGetMaxId("OrganizationOperationalStatuses"),
                        OrganizationId = leaOrganizationId,
                        RefOperationalStatusId = refOperationalStatuses.Single(x => x.Code == "Closed").RefOperationalStatusId,
                        OperationalStatusEffectiveDate = effectiveDate.AddYears(-1),
                        RecordStartDateTime = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(1910, 1, 1), organizationStartDateTime.AddYears(-1))
                    };

                    testData.OrganizationOperationalStatuses.Add(organizationOperationalStatus2);
                }

                // OrganizationCalendar

            if (refOperationalStatusCode != "Closed" && refOperationalStatusCode != "Inactive" && refOperationalStatusCode != "FutureAgency")
            {
                // Include next full school year 
               // var numberOfYears = (DateTime.Now.Year + 2) - _testDataProfile.OldestStartingYear;

                //if (refOperationalStatusCode == "New")
                //{
                //    numberOfYears = 1;
                //}

                    //for (int i = 0; i < numberOfYears; i++)
                    //{
                        // Starting with next year
                        int year = SchoolYear - i;

                        // OrganizationCalendar

                        OrganizationCalendar organizationCalendar = new OrganizationCalendar()
                        {
                            OrganizationCalendarId = this.SetAndGetMaxId("OrganizationCalendars"),
                            OrganizationId = leaOrganizationId,
                            CalendarCode = year.ToString() + leaOrganizationId.ToString().PadLeft(10, '0'),
                            CalendarYear = year.ToString(),
                            CalendarDescription = $"FiscalYear{year}"
                        };

                        testData.OrganizationCalendars.Add(organizationCalendar);

                        // OrganizationCalendarSession

                        string yearDesignator = (year - 1).ToString() + "-" + year.ToString().Substring(2, 2);

                        DateTime? sessionStart = _testDataHelper.GetSessionStartDate(rnd, year);
                        DateTime? sessionEnd = _testDataHelper.GetSessionEndDate(rnd, year);

                        OrganizationCalendarSession organizationCalendarSession = new OrganizationCalendarSession()
                        {
                            OrganizationCalendarSessionId = this.SetAndGetMaxId("OrganizationCalendarSessions"),
                            OrganizationCalendarId = organizationCalendar.OrganizationCalendarId,
                            Designator = yearDesignator,
                            Code = organizationCalendar.CalendarCode,
                            Description = organizationCalendar.CalendarDescription,
                            RefSessionTypeId = this.OdsReferenceData.FullSchoolYearTypeId,
                            BeginDate = sessionStart,
                            EndDate = sessionEnd
                        };

                        testData.OrganizationCalendarSessions.Add(organizationCalendarSession);

                        // K12FederalFundAllocation

                        var refReapAlternativeFundingStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefReapAlternativeFundingStatusDistribution);
                        var refReapAlternativeFundingStatusId = this.OdsReferenceData.RefReapAlternativeFundingStatuses.Single(x => x.Code == refReapAlternativeFundingStatusCode).RefReapAlternativeFundingStatusId;

                        var refFederalProgramFundingAllocationTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefFederalProgramFundingAllocationTypeDistribution);
                        var refFederalProgramFundingAllocationTypeId = this.OdsReferenceData.RefFederalProgramFundingAllocationTypes.Single(x => x.Code == refFederalProgramFundingAllocationTypeCode).RefFederalProgramFundingAllocationTypeId;

                        K12FederalFundAllocation k12FederalFundAllocation = new K12FederalFundAllocation()
                        {
                            K12FederalFundAllocationId = this.SetAndGetMaxId("K12FederalFundAllocations"),
                            OrganizationCalendarSessionId = organizationCalendarSession.OrganizationCalendarSessionId,
                            RecordStartDateTime = sessionStart,
                            RecordEndDateTime = sessionEnd,
                            FederalProgramCode = _testDataHelper.GetRandomString(rnd, _testDataProfile.FederalProgramCodes),
                            FederalProgramsFundingAllocation = _testDataHelper.GetRandomDecimalInRange(rnd, 100000, 400000),
                            SchoolImprovementAllocation = _testDataHelper.GetRandomDecimalInRange(rnd, 100000, 400000),
                            RefReapAlternativeFundingStatusId = refReapAlternativeFundingStatusId,
                            RefFederalProgramFundingAllocationTypeId = refFederalProgramFundingAllocationTypeId
                        };

                        testData.K12FederalFundAllocations.Add(k12FederalFundAllocation);

                        // K12LeaFederalFunds

                        K12LeaFederalFunds k12LeaFederalFunds = new K12LeaFederalFunds()
                        {
                            K12LeaFederalFundsId = this.SetAndGetMaxId("K12LeaFederalFunds"),
                            OrganizationCalendarSessionId = organizationCalendarSession.OrganizationCalendarSessionId,
                            RecordStartDateTime = sessionStart,
                            RecordEndDateTime = sessionEnd,
                            ParentalInvolvementReservationFunds = _testDataHelper.GetRandomDecimalInRange(rnd, 10000, 40000)
                        };

                        testData.K12LeaFederalFunds.Add(k12LeaFederalFunds);

                        bool hasReceivedMckinneyGrant = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasReceivedMckinneyGrantDistribution);

                    if (hasReceivedMckinneyGrant)
                    {

                        // FinancialAccount

                        FinancialAccount financialAccount = new FinancialAccount()
                        {
                            FinancialAccountId = this.SetAndGetMaxId("FinancialAccounts"),
                            Name = organizationName + ' ' + "McKinney-Vento subgrant",
                            FederalProgramCode = "84.196"
                        };

                        testData.FinancialAccounts.Add(financialAccount);

                        // OrganizationFinancial

                        OrganizationFinancial organizationFinancial = new OrganizationFinancial()
                        {
                            OrganizationFinancialId = this.SetAndGetMaxId("OrganizationFinancials"),
                            OrganizationCalendarSessionId = organizationCalendarSession.OrganizationCalendarSessionId,
                            FinancialAccountId = financialAccount.FinancialAccountId
                        };

                        testData.OrganizationFinancials.Add(organizationFinancial);

                    }

                }

            }


            // OrganizationRelationship

            OrganizationRelationship organizationRelationship = new OrganizationRelationship()
            {
                OrganizationRelationshipId = this.SetAndGetMaxId("OrganizationRelationships"),
                OrganizationId = leaOrganizationId,
                ParentOrganizationId = seaOrganizationId
            };

            testData.OrganizationRelationships.Add(organizationRelationship);

            // OrganizationFederalAccountability

            var refGunFreeSchoolsActReportingStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefGunFreeSchoolsActReportingStatusDistribution);
            var refGunFreeSchoolsActReportingStatusId = this.OdsReferenceData.RefGunFreeSchoolsActReportingStatuses.Single(x => x.Code == refGunFreeSchoolsActReportingStatusCode).RefGunFreeSchoolsActStatusReportingId;

            OrganizationFederalAccountability organizationFederalAccountability = new OrganizationFederalAccountability()
            {
                OrganizationFederalAccountabilityId = this.SetAndGetMaxId("OrganizationFederalAccountabilities"),
                OrganizationId = leaOrganizationId,
                RefGunFreeSchoolsActReportingStatusId = refGunFreeSchoolsActReportingStatusId
            };

            testData.OrganizationFederalAccountabilities.Add(organizationFederalAccountability);

            // K12lea

            string refLeaTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LeaTypeDistribution);
            RefLeaType refLeaType = this.OdsReferenceData.RefLeaTypes.Single(x => x.Code == refLeaTypeCode);
            bool isCharterLea = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IsCharterLeaDistribution);
            string charterLeaStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefCharterLeaStatusDistribution);
            RefCharterLeaStatus refCharterLea = this.OdsReferenceData.RefCharterLeaStatuses.Single(x => x.Code == charterLeaStatusCode);

            string supervisoryUnionNumber = null;

            if (refLeaTypeCode == "SupervisoryUnion" || refLeaTypeCode == "SpecializedPublicSchoolDistrict")
            {
                supervisoryUnionNumber = _testDataHelper.GetRandomIntInRange(rnd, 100, 999).ToString();
            }

            K12lea k12Lea = new K12lea()
            {
                K12LeaId = this.SetAndGetMaxId("K12Leas"),
                OrganizationId = leaOrganizationId,
                RefLeaTypeId = refLeaType.RefLeaTypeId,
                CharterSchoolIndicator = isCharterLea,
                RefCharterLeaStatusId = refCharterLea.RefCharterLeaStatusId,
                SupervisoryUnionIdentificationNumber = supervisoryUnionNumber
            };

            testData.K12Leas.Add(k12Lea);
            var newk12LeaId = k12Lea.K12LeaId;


            // OrganizationWebsite
            OrganizationWebsite organizationWebsite = new OrganizationWebsite()
            {
                OrganizationId = leaOrganizationId,
                Website = "https://www." + shortName.ToLower() + ".org"
            };

            testData.OrganizationWebsites.Add(organizationWebsite);

            // OrganizationTelephone
            OrganizationTelephone organizationTelephone = new OrganizationTelephone()
            {
                OrganizationTelephoneId = this.SetAndGetMaxId("OrganizationTelephones"),
                OrganizationId = leaOrganizationId,
                PrimaryTelephoneNumberIndicator = true,
                TelephoneNumber = _testDataHelper.GetRandomIntInRange(rnd, 100, 700) + "-" + _testDataHelper.GetRandomIntInRange(rnd, 100, 700) + "-" + _testDataHelper.GetRandomIntInRange(rnd, 1000, 7000)
            };

            testData.OrganizationTelephones.Add(organizationTelephone);

            // Locations

            bool hasMailingAddress = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasMailingAddressDistribution);
            bool hasShippingAddress = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasMailingAddressDistribution);

            var validRefOrganizationLocationTypes = this.OdsReferenceData.RefOrganizationLocationTypes;

            if (!hasMailingAddress)
            {
                validRefOrganizationLocationTypes = validRefOrganizationLocationTypes.Where(x => x.Code != "Mailing").ToList();
            }
            if (!hasShippingAddress)
            {
                validRefOrganizationLocationTypes = validRefOrganizationLocationTypes.Where(x => x.Code != "Shipping").ToList();
            }


            foreach (var locationType in validRefOrganizationLocationTypes)
            {
                Location location = new Location()
                {
                    LocationId = this.SetAndGetMaxId("Locations")
                };

                testData.Locations.Add(location);

                // OrganizationLocations

                OrganizationLocation organizationLocation = new OrganizationLocation()
                {
                    OrganizationLocationId = this.SetAndGetMaxId("OrganizationLocations"),
                    LocationId = location.LocationId,
                    OrganizationId = leaOrganizationId,
                    RefOrganizationLocationTypeId = locationType.RefOrganizationLocationTypeId
                };

                testData.OrganizationLocations.Add(organizationLocation);

                // LocationAddresses

                bool includePlus4Code = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IncludePlus4ZipCodeDistribution);

                var streetNumberAndName = _testDataHelper.GetRandomIntInRange(rnd, 1, 20000) + " " + _testDataHelper.GetStreetName(rnd, placeNames, streetTypes);
                var apartmentRoomOrSuiteNumber = _testDataHelper.GetUnitType(rnd, this.UnitTypes) + _testDataHelper.GetRandomIntInRange(rnd, 1, 20);
                var postalCode = _testDataHelper.GetRandomIntInRange(rnd, 10000, 90000).ToString();

                LocationAddress locationAddress = new LocationAddress()
                {
                    LocationId = location.LocationId,
                    StreetNumberAndName = streetNumberAndName,
                    ApartmentRoomOrSuiteNumber = apartmentRoomOrSuiteNumber,
                    City = _testDataHelper.GetCityName(rnd, placeNames),
                    PostalCode = postalCode,
                    RefStateId = refState.RefStateId
                };

                if (includePlus4Code)
                {
                    locationAddress.PostalCode = postalCode + "-" + _testDataHelper.GetRandomIntInRange(rnd, 1000, 9000).ToString();
                }

                testData.LocationAddresses.Add(locationAddress);

            }

            // OrganizationIdentifier - NCES Id

            bool leaHasNcesId = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LeaHasNcesIdDistribution);

            if (leaHasNcesId)
            {

                OrganizationIdentifier ncesOrganizationIdentifier = new OrganizationIdentifier()
                {
                    OrganizationIdentifierId = this.SetAndGetMaxId("OrganizationIdentifiers"),
                    OrganizationId = leaOrganizationId,
                    Identifier = refStateAnsicode.Code + leaOrganizationId.ToString().PadLeft(5, '0'),
                    RefOrganizationIdentifierTypeId = leaOrganizationIdentifierTypeId,
                    RefOrganizationIdentificationSystemId = leaNcesIdentificationSystemId
                };

                testData.OrganizationIdentifiers.Add(ncesOrganizationIdentifier);

            }

            // OrganizationIdentifier - SEA Id
            OrganizationIdentifier seaOrganizationIdentifier = new OrganizationIdentifier()
            {
                OrganizationIdentifierId = this.SetAndGetMaxId("OrganizationIdentifiers"),
                OrganizationId = leaOrganizationId,
                Identifier = leaOrganizationId.ToString().PadLeft(7, '0'),
                RefOrganizationIdentifierTypeId = leaOrganizationIdentifierTypeId,
                RefOrganizationIdentificationSystemId = leaSeaIdentificationSystemId
            };

            testData.OrganizationIdentifiers.Add(seaOrganizationIdentifier);

            // K12leaTitleIsupportService

            var refK12leaTitleIsupportServiceCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefK12leaTitleIsupportServiceDistribution);
            var refK12leaTitleIsupportService = this.OdsReferenceData.RefK12leaTitleIsupportServices.Single(x => x.Code == refK12leaTitleIsupportServiceCode);

            K12leaTitleIsupportService k12leaTitleIsupportService = new K12leaTitleIsupportService()
            {
                K12leaTitleIsupportServiceId = this.SetAndGetMaxId("K12leaTitleIsupportServices"),
                K12LeaId = newk12LeaId,
                OrganizationId = leaOrganizationId,
                RefK12leaTitleIsupportServiceId = refK12leaTitleIsupportService.RefK12leatitleIsupportServiceId,
                RecordStartDateTime = _testDataHelper.GetRandomDateInRange(rnd, organizationStartDateTime, new DateTime(SchoolYear, 6, 30))
            };

            testData.K12LeaTitleISupportServices.Add(k12leaTitleIsupportService);

            // K12programOrService

            var refTitleIinstructionalServicesCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIinstructionalServiceDistribution);
            var refTitleIinstructionalServicesId = this.OdsReferenceData.RefTitleIinstructionalServices.Single(x => x.Code == refTitleIinstructionalServicesCode).RefTitleIinstructionalServicesId;

            var refTitleIProgramTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIprogramTypeDistribution);
            var refTitleIProgramTypeId = this.OdsReferenceData.RefTitleIprogramTypes.Single(x => x.Code == refTitleIProgramTypeCode).RefTitleIprogramTypeId;

            var refMepProjectTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefMepProjectTypeDistribution);
            var refMepProjectTypeId = this.OdsReferenceData.RefMepProjectTypes.Single(x => x.Code == refMepProjectTypeCode).RefMepProjectTypeId;

            K12programOrService k12programOrservice = new K12programOrService()
            {
                OrganizationId = leaOrganizationId,
                RefTitleIinstructionalServicesId = refTitleIinstructionalServicesId,
                RefTitleIprogramTypeId = refTitleIProgramTypeId,
                RefMepProjectTypeId = refMepProjectTypeId,
                RecordStartDateTime = _testDataHelper.GetRandomDateInRange(rnd, organizationStartDateTime, new DateTime(SchoolYear, 6, 30))
            };

            testData.K12ProgramOrServices.Add(k12programOrservice);


            // OrganizationIndicator

            var refOrganizationIndicatorCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefOrganizationIndicatorDistribution);
            var refOrganizationIndicatorId = this.OdsReferenceData.RefOrganizationIndicators.Single(x => x.Code == refOrganizationIndicatorCode).RefOrganizationIndicatorId;

            var sharedTimeIndicatorValue = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SharedTimeOrganizationIndicatorValueDistribution);
    
            string indicatorValue = "N/A";

            if (refOrganizationIndicatorCode == "SharedTime")
            {
                indicatorValue = sharedTimeIndicatorValue;
            }


            OrganizationIndicator organizationIndicator = new OrganizationIndicator()
            {
                OrganizationIndicatorId = this.SetAndGetMaxId("OrganizationIndicators"),
                OrganizationId = leaOrganizationId,
                RefOrganizationIndicatorId = refOrganizationIndicatorId,
                IndicatorValue = indicatorValue
            };

            testData.OrganizationIndicators.Add(organizationIndicator);

            // K12titleIiilanguageInstruction

            var refTitleIiilanguageInstructionProgramTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIiilanguageInstructionProgramTypeDistribution);
            var refTitleIiilanguageInstructionProgramTypeId = this.OdsReferenceData.RefTitleIiilanguageInstructionProgramTypes.Single(x => x.Code == refTitleIiilanguageInstructionProgramTypeCode).RefTitleIiilanguageInstructionProgramTypeId;

            K12titleIiilanguageInstruction k12titleIiilanguageInstruction = new K12titleIiilanguageInstruction()
            {
                K12titleIiilanguageInstructionId = this.SetAndGetMaxId("K12titleIiilanguageInstructions"),
                OrganizationId = leaOrganizationId,
                RefTitleIiilanguageInstructionProgramTypeId = refTitleIiilanguageInstructionProgramTypeId
            };

            testData.K12titleIiilanguageInstructions.Add(k12titleIiilanguageInstruction);

            return testData;
        }

        private IdsTestDataObject CreateSchool(Random rnd, IdsTestDataObject testData, int schoolNumber, RefState refState, int parentLeaOrganizationId, out OrganizationDetail schoolOrganizationDetail)
        {

            testData.QuantityOfSchools += 1;

            // Organization

            Organization organization = new Organization()
            {
                OrganizationId = this.SetAndGetMaxId("Organizations")
            };

            testData.Organizations.Add(organization);

            testData.SchoolOrganizationIds.Add(organization.OrganizationId);

            var schoolOrganizationId = organization.OrganizationId;



            // Reference Data

            var placeNames = _testDataHelper.ListofPlaceNames();
            var streetTypes = _testDataHelper.ListofStreetTypes();

            var refStateAnsicode = this.OdsReferenceData.RefStateAnsicodes.Single(x => x.StateName == refState.Description);

            var schoolOrganizationIdentifierTypeId = this.OdsReferenceData.RefOrganizationIdentifierTypes.Single(x => x.Code == "001073").RefOrganizationIdentifierTypeId;
            var schoolNcesIdentificationSystemId = this.OdsReferenceData.RefOrganizationIdentificationSystems.Single(s => s.Code == "NCES" && s.RefOrganizationIdentifierTypeId == schoolOrganizationIdentifierTypeId).RefOrganizationIdentificationSystemId;
            var schoolSeaIdentificationSystemId = this.OdsReferenceData.RefOrganizationIdentificationSystems.Single(s => s.Code == "SEA" && s.RefOrganizationIdentifierTypeId == schoolOrganizationIdentifierTypeId).RefOrganizationIdentificationSystemId;


            bool isOrganizationClosed = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IsOrganizationClosedDistribution);

            var organizationStartDate = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(SchoolYear, 6, 30).AddYears(-10), new DateTime(SchoolYear, 6, 30));
            DateTime? organizationEndDate = null;

            if (isOrganizationClosed)
            {
                organizationEndDate = _testDataHelper.GetRandomDateInRange(rnd, organizationStartDate, new DateTime(SchoolYear, 6, 30));
            }



            // OrganizationDetail

            var schoolType = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SchoolTypesInLeaDistribution);

            if (schoolNumber == 0)
            {
                // Set first school in LEA to Academy to ensure all grades exist in LEA
                schoolType = "Academy";
            }

            string organizationName = _testDataHelper.GetK12SchoolName(rnd, placeNames, schoolType);
            string shortName = _testDataHelper.MakeAcronym(organizationName);

            OrganizationDetail organizationDetail = new OrganizationDetail()
            {
                OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                OrganizationId = schoolOrganizationId,
                Name = organizationName,
                RefOrganizationTypeId = this.OdsReferenceData.SchoolOrganizationTypeId,
                ShortName = shortName,
                RecordStartDateTime = organizationStartDate,
                RecordEndDateTime = organizationEndDate
            };

            testData.OrganizationDetails.Add(organizationDetail);

            schoolOrganizationDetail = organizationDetail;



            // OrganizationOperationalStatus
                                                  
            var numberOfYears = (DateTime.Now.Year + 2) - _testDataProfile.OldestStartingYear;



            //if (refOperationalStatusCode == "New")
            //{
            //    numberOfYears = 1;
            //}

            for (int i = 0; i < numberOfYears; i++)
            {
                var effectiveDate = _testDataHelper.GetSessionStartDate(rnd, DateTime.Now.Year - i);
                   // .GetRandomDateInRange(rnd, DateTime.Now.AddYears(-i), DateTime.Now.AddYears(i - 1));

                var schoolStartDate = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(SchoolYear - i - 1, 7, 1), new DateTime(SchoolYear - i, 6, 30));

                var schoolOperationalStatusTypeId = this.OdsReferenceData.RefOperationalStatusTypes.Single(x => x.Code == "000533").RefOperationalStatusTypeId;
                var schoolRefOperationalStatuses = this.OdsReferenceData.RefOperationalStatuses.Where(x => x.RefOperationalStatusTypeId == schoolOperationalStatusTypeId);

                var refOperationalStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SchoolRefOperationalStatusDistribution);
                var refOperationalStatusId = schoolRefOperationalStatuses.Single(x => x.Code == refOperationalStatusCode).RefOperationalStatusId;


                if (refOperationalStatusCode == "New")
                {
                    // If new, set start date to this summer (a couple months before next school year start)
                    effectiveDate = _testDataHelper.GetSessionStartDate(rnd, SchoolYear).AddMonths(-2);
                }

                OrganizationOperationalStatus organizationOperationalStatus = new OrganizationOperationalStatus()
                {
                    OrganizationOperationalStatusId = this.SetAndGetMaxId("OrganizationOperationalStatuses"),
                    OrganizationId = schoolOrganizationId,
                    RefOperationalStatusId = refOperationalStatusId,
                    OperationalStatusEffectiveDate = effectiveDate,
                    RecordStartDateTime = schoolStartDate
                };

                testData.OrganizationOperationalStatuses.Add(organizationOperationalStatus);

                if (refOperationalStatusCode == "Reopened")
                {
                    // If Reopened, add another OperationalStatus in the past

                    OrganizationOperationalStatus organizationOperationalStatus2 = new OrganizationOperationalStatus()
                    {
                        OrganizationOperationalStatusId = this.SetAndGetMaxId("OrganizationOperationalStatuses"),
                        OrganizationId = schoolOrganizationId,
                        RefOperationalStatusId = schoolRefOperationalStatuses.Single(x => x.Code == "Closed").RefOperationalStatusId,
                        OperationalStatusEffectiveDate = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(1910, 1, 1), schoolStartDate.AddYears(-1)),
                        RecordStartDateTime = effectiveDate.AddYears(-1)
                    };

                    testData.OrganizationOperationalStatuses.Add(organizationOperationalStatus2);

                }

                // OrganizationCalendar


                if (refOperationalStatusCode != "Closed" && refOperationalStatusCode != "Inactive" && refOperationalStatusCode != "FutureSchool")
                {

                    // Starting with next year
                    int year = SchoolYear - i;

                    // OrganizationCalendar

                    OrganizationCalendar organizationCalendar = new OrganizationCalendar()
                    {
                        OrganizationCalendarId = this.SetAndGetMaxId("OrganizationCalendars"),
                        OrganizationId = schoolOrganizationId,
                        CalendarCode = year.ToString() + schoolOrganizationId.ToString().PadLeft(10, '0'),
                        CalendarYear = year.ToString(),
                        CalendarDescription = $"FullSchoolYear{year}"
                    };

                    testData.OrganizationCalendars.Add(organizationCalendar);

                    // OrganizationCalendarSession

                    string yearDesignator = (year - 1).ToString() + "-" + year.ToString().Substring(2, 2);

                    DateTime? sessionStart = _testDataHelper.GetSessionStartDate(rnd, year);
                    DateTime? sessionEnd = _testDataHelper.GetSessionEndDate(rnd, year);

                    OrganizationCalendarSession organizationCalendarSession = new OrganizationCalendarSession()
                    {
                        OrganizationCalendarSessionId = this.SetAndGetMaxId("OrganizationCalendarSessions"),
                        OrganizationCalendarId = organizationCalendar.OrganizationCalendarId,
                        Designator = yearDesignator,
                        Code = organizationCalendar.CalendarCode,
                        Description = organizationCalendar.CalendarDescription,
                        RefSessionTypeId = this.OdsReferenceData.FullSchoolYearTypeId,
                        BeginDate = sessionStart,
                        EndDate = sessionEnd
                    };

                    testData.OrganizationCalendarSessions.Add(organizationCalendarSession);



                    // K12FederalFundAllocation

                    var refReapAlternativeFundingStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefReapAlternativeFundingStatusDistribution);
                    var refReapAlternativeFundingStatusId = this.OdsReferenceData.RefReapAlternativeFundingStatuses.Single(x => x.Code == refReapAlternativeFundingStatusCode).RefReapAlternativeFundingStatusId;

                    var refFederalProgramFundingAllocationTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefFederalProgramFundingAllocationTypeDistribution);
                    var refFederalProgramFundingAllocationTypeId = this.OdsReferenceData.RefFederalProgramFundingAllocationTypes.Single(x => x.Code == refFederalProgramFundingAllocationTypeCode).RefFederalProgramFundingAllocationTypeId;

                    K12FederalFundAllocation k12FederalFundAllocation = new K12FederalFundAllocation()
                    {
                        K12FederalFundAllocationId = this.SetAndGetMaxId("K12FederalFundAllocations"),
                        OrganizationCalendarSessionId = organizationCalendarSession.OrganizationCalendarSessionId,
                        RecordStartDateTime = sessionStart,
                        RecordEndDateTime = sessionEnd,
                        FederalProgramCode = "84.010",
                        SchoolImprovementAllocation = _testDataHelper.GetRandomDecimalInRange(rnd, 100000, 400000)
                    };

                    testData.K12FederalFundAllocations.Add(k12FederalFundAllocation);
                }
            }

            var organizationStartDateTime = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(SchoolYear - 1, 7, 1).AddYears(-2), new DateTime(SchoolYear, 6, 30));

            // OrganizationRelationship

            OrganizationRelationship organizationRelationship = new OrganizationRelationship()
            {
                OrganizationRelationshipId = this.SetAndGetMaxId("OrganizationRelationships"),
                OrganizationId = schoolOrganizationId,
                ParentOrganizationId = parentLeaOrganizationId
            };

            testData.OrganizationRelationships.Add(organizationRelationship);

            // Add to AllLeaSchoolRelationships
            this.AllLeaSchoolRelationships.Add(organizationRelationship);


            // OrganizationFederalAccountability

            var refGunFreeSchoolsActReportingStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefGunFreeSchoolsActReportingStatusDistribution);
            var refGunFreeSchoolsActReportingStatusId = this.OdsReferenceData.RefGunFreeSchoolsActReportingStatuses.Single(x => x.Code == refGunFreeSchoolsActReportingStatusCode).RefGunFreeSchoolsActStatusReportingId;

            var refHighSchoolGraduationRateIndicatorCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefHighSchoolGraduationRateIndicatorDistribution);
            var refHighSchoolGraduationRateIndicatorId = this.OdsReferenceData.RefHighSchoolGraduationRateIndicators.Single(x => x.Code == refHighSchoolGraduationRateIndicatorCode).RefHsgraduationRateIndicatorId;

            var refReconstitutedStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefReconstitutedStatusDistribution);
            var refReconstitutedStatusId = this.OdsReferenceData.RefReconstitutedStatuses.Single(x => x.Code == refReconstitutedStatusCode).RefReconstitutedStatusId;

            var refCteGraduationRateInclusionCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefCteGraduationRateInclusionDistribution);
            var refCteGraduationRateInclusionsId = this.OdsReferenceData.RefCteGraduationRateInclusions.Single(x => x.Code == refCteGraduationRateInclusionCode).RefCteGraduationRateInclusionId;

            var persistentlyDangerousStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.PersistentlyDangerousStatusDistribution);

            var refAmaoAttainmentStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAmaoAttainmentStatusDistribution);
            var refAmaoAttainmentStatusId = this.OdsReferenceData.RefAmaoAttainmentStatuses.Single(x => x.Code == refAmaoAttainmentStatusCode).RefAmaoAttainmentStatusId;

            OrganizationFederalAccountability organizationFederalAccountability = new OrganizationFederalAccountability()
            {
                OrganizationFederalAccountabilityId = this.SetAndGetMaxId("OrganizationFederalAccountabilities"),
                OrganizationId = schoolOrganizationId,
                RefReconstitutedStatusId = refReconstitutedStatusId,
                RefCteGraduationRateInclusionId = refCteGraduationRateInclusionsId,
                PersistentlyDangerousStatus = persistentlyDangerousStatus,
                AmaoAypProgressAttainmentLepStudents = refAmaoAttainmentStatusId,
                RefHighSchoolGraduationRateIndicatorId = refHighSchoolGraduationRateIndicatorId,
                RefGunFreeSchoolsActReportingStatusId = refGunFreeSchoolsActReportingStatusId
            };

            testData.OrganizationFederalAccountabilities.Add(organizationFederalAccountability);

            // K12School

            bool isCharterSchool = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IsCharterSchoolDistribution);
            string refStatePovertyDesignationTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.StatePovertyDesignationDistribution);
            RefStatePovertyDesignation refStatePovertyDesignation = this.OdsReferenceData.RefStatePovertyDesignations.Single(x => x.Code == refStatePovertyDesignationTypeCode);
            string refSchoolTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SchoolTypeDistribution);
            RefSchoolType refSchoolType = this.OdsReferenceData.RefSchoolTypes.Single(x => x.Code == refSchoolTypeCode);

            K12school k12school = new K12school()
            {
                K12schoolId = this.SetAndGetMaxId("K12schools"),
                OrganizationId = schoolOrganizationId,
                RefSchoolTypeId = refSchoolType.RefSchoolTypeId,
                CharterSchoolIndicator = isCharterSchool,
                RefStatePovertyDesignationId = refStatePovertyDesignation.RefStatePovertyDesignationId,
                RecordStartDateTime = organizationStartDateTime
            };

            if (isCharterSchool)
            {
                string refStateAppropriationMethodCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.StateAppropriationMethodDistribution);
                RefStateAppropriationMethod refStateAppropriationMethod = this.OdsReferenceData.RefStateAppropriationMethods.Single(x => x.Code == refStateAppropriationMethodCode);
                
                k12school.CharterSchoolContractIdNumber = "ct" + _testDataHelper.GetRandomIntInRange(rnd, 1, 1000).ToString();
                k12school.CharterSchoolContractApprovalDate = _testDataHelper.GetRandomDateInRange(rnd, organizationStartDateTime, organizationStartDateTime.AddMonths(6));
                k12school.CharterSchoolContractRenewalDate = _testDataHelper.GetRandomDateAfter(rnd, DateTime.Now, 720);
            }

 

            // Charter School Authorizer Identifier 
            if (isCharterSchool)
            {

                // Primary Authorizer

                Organization authorizerOrganization = new Organization()
                {
                    OrganizationId = this.SetAndGetMaxId("Organizations")
                };
                testData.Organizations.Add(authorizerOrganization);

                var authorizerRefOrganizationTypeId = this.OdsReferenceData.RefOrganizationTypes.Single(o => o.Code == "CharterSchoolAuthorizingOrganization" && o.RefOrganizationElementTypeId == this.OdsReferenceData.OrganizationElementTypeId).RefOrganizationTypeId;

                OrganizationDetail authorizerOrganizationDetail = new OrganizationDetail()
                {
                    OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                    OrganizationId = authorizerOrganization.OrganizationId,
                    Name = organizationDetail.Name + " Charter Auth",
                    RefOrganizationTypeId = authorizerRefOrganizationTypeId,
                    ShortName = _testDataHelper.MakeAcronym(organizationDetail.Name + " Charter Auth"),
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationDetails.Add(authorizerOrganizationDetail);

                OrganizationRelationship authorizerOrganizationRelationship = new OrganizationRelationship()
                {
                    OrganizationRelationshipId = this.SetAndGetMaxId("OrganizationRelationships"),
                    OrganizationId = schoolOrganizationId,
                    ParentOrganizationId = authorizerOrganization.OrganizationId,
                    RefOrganizationRelationshipId = this.OdsReferenceData.RefOrganizationRelationships.Single(x => x.Code == "AuthorizingBody").RefOrganizationRelationshipId
                };

                testData.OrganizationRelationships.Add(authorizerOrganizationRelationship);

                var k12CharterSchoolAuthorizerId = this.SetAndGetMaxId("K12CharterSchoolAuthorizers");

                K12CharterSchoolAuthorizer authorizerK12CharterSchool = new K12CharterSchoolAuthorizer()
                {
                    K12CharterSchoolAuthorizerId = k12CharterSchoolAuthorizerId,
                    OrganizationId = authorizerOrganization.OrganizationId,
                    RefCharterSchoolAuthorizerTypeId = _testDataHelper.GetRandomObject<RefCharterSchoolAuthorizerType>(rnd, this.OdsReferenceData.RefCharterSchoolAuthorizerTypes).RefCharterSchoolAuthorizerTypeId
                };
                testData.K12CharterSchoolAuthorizers.Add(authorizerK12CharterSchool);

                var managementOrganizationIdentificationId = this.OdsReferenceData.RefOrganizationIdentifierTypes.Single(x => x.Code == "000827").RefOrganizationIdentifierTypeId;
                var authorizerIdentifierId = this.OdsReferenceData.RefOrganizationIdentificationSystems.Single(x => x.Code == "SEA" && x.RefOrganizationIdentifierTypeId == managementOrganizationIdentificationId).RefOrganizationIdentificationSystemId;

                OrganizationIdentifier authorizerOrganizationIdentifier = new OrganizationIdentifier()
                {
                    OrganizationIdentifierId = this.SetAndGetMaxId("OrganizationIdentifiers"),
                    OrganizationId = authorizerOrganization.OrganizationId,
                    Identifier = authorizerOrganization.OrganizationId.ToString().PadLeft(9, '0'),
                    RefOrganizationIdentifierTypeId = managementOrganizationIdentificationId,
                    RefOrganizationIdentificationSystemId = authorizerIdentifierId
                };
                testData.OrganizationIdentifiers.Add(authorizerOrganizationIdentifier);


                bool hasAuthorizerMailingAddress = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasMailingAddressDistribution);
                bool hasAuthorizerShippingAddress = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasMailingAddressDistribution);

                var validAuthorizerRefOrganizationLocationTypes = this.OdsReferenceData.RefOrganizationLocationTypes;

                if (!hasAuthorizerMailingAddress)
                {
                    validAuthorizerRefOrganizationLocationTypes = validAuthorizerRefOrganizationLocationTypes.Where(x => x.Code != "Mailing").ToList();
                }
                if (!hasAuthorizerShippingAddress)
                {
                    validAuthorizerRefOrganizationLocationTypes = validAuthorizerRefOrganizationLocationTypes.Where(x => x.Code != "Shipping").ToList();
                }


                foreach (var locationType in validAuthorizerRefOrganizationLocationTypes)
                {
                    Location location = new Location()
                    {
                        LocationId = this.SetAndGetMaxId("Locations")
                    };

                    testData.Locations.Add(location);

                    // OrganizationLocations

                    OrganizationLocation organizationLocation = new OrganizationLocation()
                    {
                        OrganizationLocationId = this.SetAndGetMaxId("OrganizationLocations"),
                        LocationId = location.LocationId,
                        OrganizationId = authorizerOrganization.OrganizationId,
                        RefOrganizationLocationTypeId = locationType.RefOrganizationLocationTypeId
                    };

                    testData.OrganizationLocations.Add(organizationLocation);

                    // LocationAddresses

                    bool includePlus4Code = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IncludePlus4ZipCodeDistribution);

                    var streetNumberAndName = _testDataHelper.GetRandomIntInRange(rnd, 1, 20000) + " " + _testDataHelper.GetStreetName(rnd, placeNames, streetTypes);
                    var apartmentRoomOrSuiteNumber = _testDataHelper.GetUnitType(rnd, this.UnitTypes) + _testDataHelper.GetRandomIntInRange(rnd, 1, 20);
                    var postalCode = _testDataHelper.GetRandomIntInRange(rnd, 10000, 90000).ToString();

                    LocationAddress locationAddress = new LocationAddress()
                    {
                        LocationId = location.LocationId,
                        StreetNumberAndName = streetNumberAndName,
                        ApartmentRoomOrSuiteNumber = apartmentRoomOrSuiteNumber,
                        City = _testDataHelper.GetCityName(rnd, placeNames),
                        PostalCode = postalCode,
                        RefStateId = refState.RefStateId
                    };

                    if (includePlus4Code)
                    {
                        locationAddress.PostalCode = postalCode + "-" + _testDataHelper.GetRandomIntInRange(rnd, 1000, 9000).ToString();
                    }

                    testData.LocationAddresses.Add(locationAddress);

                }


                k12school.OrganizationId = organizationRelationship.OrganizationId;



                // Manager

                Organization managerOrganization = new Organization()
                {
                    OrganizationId = this.SetAndGetMaxId("Organizations")
                };
                testData.Organizations.Add(managerOrganization);

                var managerRefOrganizationTypeId = this.OdsReferenceData.RefOrganizationTypes.Single(o => o.Code == "CharterSchoolManagementOrganization" && o.RefOrganizationElementTypeId == this.OdsReferenceData.OrganizationElementTypeId).RefOrganizationTypeId;

                OrganizationDetail managerOrganizationDetail = new OrganizationDetail()
                {
                    OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                    OrganizationId = managerOrganization.OrganizationId,
                    Name = organizationDetail.Name + " Charter Mgmt",
                    RefOrganizationTypeId = managerRefOrganizationTypeId,
                    ShortName = _testDataHelper.MakeAcronym(organizationDetail.Name + " Charter Mgmt"),
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationDetails.Add(managerOrganizationDetail);

                OrganizationRelationship managerOrganizationRelationship = new OrganizationRelationship()
                {
                    OrganizationRelationshipId = this.SetAndGetMaxId("OrganizationRelationships"),
                    OrganizationId = schoolOrganizationId,
                    ParentOrganizationId = managerOrganization.OrganizationId
                };
                testData.OrganizationRelationships.Add(managerOrganizationRelationship);

                var K12CharterSchoolManagementOrganizationId = this.SetAndGetMaxId("K12CharterSchoolManagementOrganizations");

                K12CharterSchoolManagementOrganization managerK12CharterSchoolManagementOrganization = new K12CharterSchoolManagementOrganization()
                {
                    K12CharterSchoolManagementOrganizationId = K12CharterSchoolManagementOrganizationId,
                    OrganizationId = managerOrganization.OrganizationId,
                    RefCharterSchoolManagementOrganizationTypeId = _testDataHelper.GetRandomObject<RefCharterSchoolManagementOrganizationType>(rnd, this.OdsReferenceData.RefCharterSchoolManagementOrganizationTypes).RefCharterSchoolManagementOrganizationTypeId
                };
                testData.K12CharterSchoolManagementOrganizations.Add(managerK12CharterSchoolManagementOrganization);

                k12school.K12CharterSchoolManagementOrganizationId = K12CharterSchoolManagementOrganizationId;

                var managementOrganizationIdentifierId = this.OdsReferenceData.RefOrganizationIdentificationSystems.Single(x => x.Code == "Federal" && x.RefOrganizationIdentifierTypeId == managementOrganizationIdentificationId).RefOrganizationIdentificationSystemId;

                OrganizationIdentifier managerOrganizationIdentifier = new OrganizationIdentifier()
                {
                    OrganizationIdentifierId = this.SetAndGetMaxId("OrganizationIdentifiers"),
                    OrganizationId = managerOrganization.OrganizationId,
                    Identifier = managerOrganization.OrganizationId.ToString().PadLeft(9, '0'),
                    RefOrganizationIdentifierTypeId = managementOrganizationIdentificationId,
                    RefOrganizationIdentificationSystemId = managementOrganizationIdentifierId
                };
                testData.OrganizationIdentifiers.Add(managerOrganizationIdentifier);

                bool hasManagerMailingAddress = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasMailingAddressDistribution);
                bool hasManagerShippingAddress = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasMailingAddressDistribution);

                var validManagerRefOrganizationLocationTypes = this.OdsReferenceData.RefOrganizationLocationTypes;

                if (!hasManagerMailingAddress)
                {
                    validManagerRefOrganizationLocationTypes = validAuthorizerRefOrganizationLocationTypes.Where(x => x.Code != "Mailing").ToList();
                }
                if (!hasManagerShippingAddress)
                {
                    validManagerRefOrganizationLocationTypes = validAuthorizerRefOrganizationLocationTypes.Where(x => x.Code != "Shipping").ToList();
                }


                foreach (var locationType in validManagerRefOrganizationLocationTypes)
                {
                    Location location = new Location()
                    {
                        LocationId = this.SetAndGetMaxId("Locations")
                    };

                    testData.Locations.Add(location);

                    // OrganizationLocations

                    OrganizationLocation organizationLocation = new OrganizationLocation()
                    {
                        OrganizationLocationId = this.SetAndGetMaxId("OrganizationLocations"),
                        LocationId = location.LocationId,
                        OrganizationId = managerOrganization.OrganizationId,
                        RefOrganizationLocationTypeId = locationType.RefOrganizationLocationTypeId
                    };

                    testData.OrganizationLocations.Add(organizationLocation);

                    // LocationAddresses

                    bool includePlus4Code = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IncludePlus4ZipCodeDistribution);

                    var streetNumberAndName = _testDataHelper.GetRandomIntInRange(rnd, 1, 20000) + " " + _testDataHelper.GetStreetName(rnd, placeNames, streetTypes);
                    var apartmentRoomOrSuiteNumber = _testDataHelper.GetUnitType(rnd, this.UnitTypes) + _testDataHelper.GetRandomIntInRange(rnd, 1, 20);
                    var postalCode = _testDataHelper.GetRandomIntInRange(rnd, 10000, 90000).ToString();

                    LocationAddress locationAddress = new LocationAddress()
                    {
                        LocationId = location.LocationId,
                        StreetNumberAndName = streetNumberAndName,
                        ApartmentRoomOrSuiteNumber = apartmentRoomOrSuiteNumber,
                        City = _testDataHelper.GetCityName(rnd, placeNames),
                        PostalCode = postalCode,
                        RefStateId = refState.RefStateId
                    };

                    if (includePlus4Code)
                    {
                        locationAddress.PostalCode = postalCode + "-" + _testDataHelper.GetRandomIntInRange(rnd, 1000, 9000).ToString();
                    }

                    testData.LocationAddresses.Add(locationAddress);

                }


                // Secondary Authorizer

                bool hasSecondaryAuthorizer = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasSecondaryCharterAuthorizerDistribution);

                if (hasSecondaryAuthorizer)
                {

                    Organization secondaryAuthorizerOrganization = new Organization()
                    {
                        OrganizationId = this.SetAndGetMaxId("Organizations")
                    };
                    testData.Organizations.Add(secondaryAuthorizerOrganization);

                    OrganizationDetail secondaryAuthorizerOrganizationDetail = new OrganizationDetail()
                    {
                        OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                        OrganizationId = secondaryAuthorizerOrganization.OrganizationId,
                        Name = organizationDetail.Name + " Second Charter Auth",
                        RefOrganizationTypeId = authorizerRefOrganizationTypeId,
                        ShortName = _testDataHelper.MakeAcronym(organizationDetail.Name + " Second Charter Auth"),
                        RecordStartDateTime = organizationStartDateTime
                    };

                    testData.OrganizationDetails.Add(secondaryAuthorizerOrganizationDetail);

                    OrganizationRelationship secondaryAuthorizerOrganizationRelationship = new OrganizationRelationship()
                    {
                        OrganizationRelationshipId = this.SetAndGetMaxId("OrganizationRelationships"),
                        OrganizationId = schoolOrganizationId,
                        ParentOrganizationId = secondaryAuthorizerOrganization.OrganizationId,
                        RefOrganizationRelationshipId = this.OdsReferenceData.RefOrganizationRelationships.Single(x => x.Code == "SecondaryAuthorizingBody").RefOrganizationRelationshipId
                    };

                    testData.OrganizationRelationships.Add(secondaryAuthorizerOrganizationRelationship);


                    K12CharterSchoolAuthorizer secondaryAuthorizer = new K12CharterSchoolAuthorizer()
                    {
                        K12CharterSchoolAuthorizerId = this.SetAndGetMaxId("K12CharterSchoolAuthorizers"),
                        OrganizationId = secondaryAuthorizerOrganization.OrganizationId,
                        RefCharterSchoolAuthorizerTypeId = _testDataHelper.GetRandomObject<RefCharterSchoolAuthorizerType>(rnd, this.OdsReferenceData.RefCharterSchoolAuthorizerTypes).RefCharterSchoolAuthorizerTypeId
                    };
                    testData.K12CharterSchoolAuthorizers.Add(secondaryAuthorizer);

                    OrganizationIdentifier secondaryAuthorizerOrganizationIdentifier = new OrganizationIdentifier()
                    {
                        OrganizationIdentifierId = this.SetAndGetMaxId("OrganizationIdentifiers"),
                        OrganizationId = secondaryAuthorizerOrganization.OrganizationId,
                        Identifier = secondaryAuthorizerOrganization.OrganizationId.ToString().PadLeft(9, '0'),
                        RefOrganizationIdentifierTypeId = managementOrganizationIdentificationId,
                        RefOrganizationIdentificationSystemId = authorizerIdentifierId
                    };
                    testData.OrganizationIdentifiers.Add(secondaryAuthorizerOrganizationIdentifier);


                }

                // Updated Manager

                bool hasUpdatedManager = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasUpdatedCharterManagerDistribution);

                if (hasUpdatedManager)
                {

                    Organization updatedManagerOrganization = new Organization()
                    {
                        OrganizationId = this.SetAndGetMaxId("Organizations")
                    };
                    testData.Organizations.Add(updatedManagerOrganization);

                    OrganizationDetail updatedManagerOrganizationDetail = new OrganizationDetail()
                    {
                        OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                        OrganizationId = updatedManagerOrganization.OrganizationId,
                        Name = organizationDetail.Name + " Updated Charter Mgmt",
                        RefOrganizationTypeId = managerRefOrganizationTypeId,
                        ShortName = _testDataHelper.MakeAcronym(organizationDetail.Name + " Updated Charter Mgmt"),
                        RecordStartDateTime = organizationStartDateTime
                    };

                    testData.OrganizationDetails.Add(updatedManagerOrganizationDetail);

                    OrganizationRelationship updatedManagerOrganizationRelationship = new OrganizationRelationship()
                    {
                        OrganizationRelationshipId = this.SetAndGetMaxId("OrganizationRelationships"),
                        OrganizationId = schoolOrganizationId,
                        ParentOrganizationId = updatedManagerOrganization.OrganizationId
                    };

                    testData.OrganizationRelationships.Add(updatedManagerOrganizationRelationship);

                    K12CharterSchoolManagementOrganization updatedManagerK12CharterSchoolManagementOrganization = new K12CharterSchoolManagementOrganization()
                    {
                        K12CharterSchoolManagementOrganizationId = this.SetAndGetMaxId("K12CharterSchoolManagementOrganizations"),
                        OrganizationId = updatedManagerOrganization.OrganizationId,
                        RefCharterSchoolManagementOrganizationTypeId = _testDataHelper.GetRandomObject<RefCharterSchoolManagementOrganizationType>(rnd, this.OdsReferenceData.RefCharterSchoolManagementOrganizationTypes).RefCharterSchoolManagementOrganizationTypeId
                    };
                    testData.K12CharterSchoolManagementOrganizations.Add(updatedManagerK12CharterSchoolManagementOrganization);

                    OrganizationIdentifier updatedAuthorizerOrganizationIdentifier = new OrganizationIdentifier()
                    {
                        OrganizationIdentifierId = this.SetAndGetMaxId("OrganizationIdentifiers"),
                        OrganizationId = updatedManagerOrganization.OrganizationId,
                        Identifier = updatedManagerOrganization.OrganizationId.ToString().PadLeft(9, '0'),
                        RefOrganizationIdentifierTypeId = managementOrganizationIdentificationId,
                        RefOrganizationIdentificationSystemId = managementOrganizationIdentifierId
                    };
                    testData.OrganizationIdentifiers.Add(updatedAuthorizerOrganizationIdentifier);
                }

            }


            testData.K12Schools.Add(k12school);
            this.AllK12Schools.Add(k12school);

            // K12schoolGradeOffered

            List<string> gradesForSchoolType = new List<string>();
            IEnumerable<RefGradeLevel> gradeLevelsForSchoolType = new List<RefGradeLevel>();
            IEnumerable<RefGradeLevel> entryGradeLevels = new List<RefGradeLevel>(); ;
            RefGradeLevel exitGradeLevel;

            if (schoolType == "Elementary")
            {
                gradesForSchoolType = new List<string>()
                {
                    "KG", "01", "02", "03", "04", "05"
                };

                gradeLevelsForSchoolType = this.OdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.OdsReferenceData.GradesOfferedTypeId);
                entryGradeLevels = this.OdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.OdsReferenceData.EntryGradeLevelTypeId);
                exitGradeLevel = this.OdsReferenceData.RefGradeLevels.Single(x => x.Code == "05" && x.RefGradeLevelTypeId == this.OdsReferenceData.ExitGradeLevelTypeId);
            }
            else if (schoolType == "Middle School" || schoolType == "Junior High")
            {
                gradesForSchoolType = new List<string>()
                {
                    "06", "07", "08"
                };

                gradeLevelsForSchoolType = this.OdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.OdsReferenceData.GradesOfferedTypeId);
                entryGradeLevels = this.OdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.OdsReferenceData.EntryGradeLevelTypeId);
                exitGradeLevel = this.OdsReferenceData.RefGradeLevels.Single(x => x.Code == "08" && x.RefGradeLevelTypeId == this.OdsReferenceData.ExitGradeLevelTypeId);
            }
            else if (schoolType == "High School")
            {
                gradesForSchoolType = new List<string>()
                {
                    "09", "10", "11", "12", "13"
                };

                gradeLevelsForSchoolType = this.OdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.OdsReferenceData.GradesOfferedTypeId);
                entryGradeLevels = this.OdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.OdsReferenceData.EntryGradeLevelTypeId);
               
                if (entryGradeLevels.Count(t => t.Code == "13") > 0)
                {
                    exitGradeLevel = this.OdsReferenceData.RefGradeLevels.Single(x => x.Code == "13" && x.RefGradeLevelTypeId == this.OdsReferenceData.ExitGradeLevelTypeId);
                }
                else
                {
                    exitGradeLevel = this.OdsReferenceData.RefGradeLevels.Single(x => x.Code == "12" && x.RefGradeLevelTypeId == this.OdsReferenceData.ExitGradeLevelTypeId);
                }
            }
            else if (schoolType == "Pre-kindergarten/early childhood")
            {
                gradesForSchoolType = new List<string>()
                {
                    "PK"
                };

                gradeLevelsForSchoolType = this.OdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.OdsReferenceData.GradesOfferedTypeId);
                entryGradeLevels = this.OdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.OdsReferenceData.EntryGradeLevelTypeId);
                exitGradeLevel = this.OdsReferenceData.RefGradeLevels.Single(x => x.Code == "PK" && x.RefGradeLevelTypeId == this.OdsReferenceData.ExitGradeLevelTypeId);
            }
            else if (schoolType == "Adult")
            {
                gradesForSchoolType = new List<string>()
                {
                    "ABE"
                };

                gradeLevelsForSchoolType = this.OdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.OdsReferenceData.GradesOfferedTypeId);
                entryGradeLevels = this.OdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.OdsReferenceData.EntryGradeLevelTypeId);
                exitGradeLevel = this.OdsReferenceData.RefGradeLevels.Single(x => x.Code == "ABE" && x.RefGradeLevelTypeId == this.OdsReferenceData.ExitGradeLevelTypeId);
            }
            else
            {
                gradesForSchoolType = new List<string>()
                {
                    "KG", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "UG", "ABE", "PK"
                };

                gradeLevelsForSchoolType = this.OdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.OdsReferenceData.GradesOfferedTypeId);
                entryGradeLevels = this.OdsReferenceData.RefGradeLevels.Join(gradesForSchoolType, x => x.Code, id => id, (x, id) => x).Where(x => x.RefGradeLevelTypeId == this.OdsReferenceData.EntryGradeLevelTypeId);
                exitGradeLevel = this.OdsReferenceData.RefGradeLevels.Single(x => x.Code == "12" && x.RefGradeLevelTypeId == this.OdsReferenceData.ExitGradeLevelTypeId);

            }

            // Grades Offered
            foreach (var gradeLevel in gradeLevelsForSchoolType)
            {
                K12schoolGradeOffered k12schoolGradeOffered = new K12schoolGradeOffered()
                {
                    K12schoolGradeOfferedId = this.SetAndGetMaxId("K12SchoolGradeOffereds"),
                    K12schoolId = k12school.K12schoolId,
                    RefGradeLevelId = gradeLevel.RefGradeLevelId,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.K12SchoolGradeOffereds.Add(k12schoolGradeOffered);
                
            }



            // Entry Grade
            foreach (var entrygradeLevel in entryGradeLevels)
            {
                K12schoolGradeOffered entryk12schoolGradeOffered = new K12schoolGradeOffered()
                {
                    K12schoolGradeOfferedId = this.SetAndGetMaxId("K12SchoolGradeOffereds"),
                    K12schoolId = k12school.K12schoolId,
                    RefGradeLevelId = entrygradeLevel.RefGradeLevelId,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.K12SchoolGradeOffereds.Add(entryk12schoolGradeOffered);
                this.AllK12schoolGradeOffered.Add(entryk12schoolGradeOffered);
            }

            // Exit Grade
            K12schoolGradeOffered exitk12schoolGradeOffered = new K12schoolGradeOffered()
            {
                K12schoolGradeOfferedId = this.SetAndGetMaxId("K12SchoolGradeOffereds"),
                K12schoolId = k12school.K12schoolId,
                RefGradeLevelId = exitGradeLevel.RefGradeLevelId,
                RecordStartDateTime = organizationStartDateTime
            };

            testData.K12SchoolGradeOffereds.Add(exitk12schoolGradeOffered);


            // K12schoolImprovement

            var refSchoolImprovementStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefSchoolImprovementStatusDistribution);
            var refSchoolImprovementStatusId = this.OdsReferenceData.RefSchoolImprovementStatuses.Single(x => x.Code == refSchoolImprovementStatusCode).RefSchoolImprovementStatusId;

            var refSchoolImprovementFundsCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefSchoolImprovementFundsDistribution);
            var refSchoolImprovementFundsId = this.OdsReferenceData.RefSchoolImprovementFunds.Single(x => x.Code == refSchoolImprovementFundsCode).RefSchoolImprovementFundsId;

            K12schoolImprovement k12SchoolImprovement = new K12schoolImprovement()
            {
                K12schoolImprovementId = this.SetAndGetMaxId("K12SchoolImprovements"),
                K12schoolId = k12school.K12schoolId,
                RefSchoolImprovementStatusId = refSchoolImprovementStatusId,
                RefSchoolImprovementFundsId = refSchoolImprovementFundsId
            };

            testData.K12SchoolImprovements.Add(k12SchoolImprovement);


            // OrganizationWebsite
            OrganizationWebsite organizationWebsite = new OrganizationWebsite()
            {
                OrganizationId = schoolOrganizationId,
                Website = "https://www." + shortName.ToLower() + ".org"
            };

            testData.OrganizationWebsites.Add(organizationWebsite);

            // OrganizationTelephone
            OrganizationTelephone organizationTelephone = new OrganizationTelephone()
            {
                OrganizationTelephoneId = this.SetAndGetMaxId("OrganizationTelephones"),
                OrganizationId = schoolOrganizationId,
                PrimaryTelephoneNumberIndicator = true,
                TelephoneNumber = _testDataHelper.GetRandomIntInRange(rnd, 100, 700) + "-" + _testDataHelper.GetRandomIntInRange(rnd, 100, 700) + "-" + _testDataHelper.GetRandomIntInRange(rnd, 1000, 7000)
            };

            testData.OrganizationTelephones.Add(organizationTelephone);

            // Locations

            bool hasMailingAddress = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasMailingAddressDistribution);
            bool hasShippingAddress = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasMailingAddressDistribution);

            var validRefOrganizationLocationTypes = this.OdsReferenceData.RefOrganizationLocationTypes;

            if (!hasMailingAddress)
            {
                validRefOrganizationLocationTypes = validRefOrganizationLocationTypes.Where(x => x.Code != "Mailing").ToList();
            }
            if (!hasShippingAddress)
            {
                validRefOrganizationLocationTypes = validRefOrganizationLocationTypes.Where(x => x.Code != "Shipping").ToList();
            }


            foreach (var locationType in validRefOrganizationLocationTypes)
            {
                Location location = new Location()
                {
                    LocationId = this.SetAndGetMaxId("Locations")
                };

                testData.Locations.Add(location);

                // OrganizationLocations

                OrganizationLocation organizationLocation = new OrganizationLocation()
                {
                    OrganizationLocationId = this.SetAndGetMaxId("OrganizationLocations"),
                    LocationId = location.LocationId,
                    OrganizationId = schoolOrganizationId,
                    RefOrganizationLocationTypeId = locationType.RefOrganizationLocationTypeId
                };

                testData.OrganizationLocations.Add(organizationLocation);

                // LocationAddresses

                bool includePlus4Code = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IncludePlus4ZipCodeDistribution);

                var streetNumberAndName = _testDataHelper.GetRandomIntInRange(rnd, 1, 20000) + " " + _testDataHelper.GetStreetName(rnd, placeNames, streetTypes);
                var apartmentRoomOrSuiteNumber = _testDataHelper.GetUnitType(rnd, this.UnitTypes) + _testDataHelper.GetRandomIntInRange(rnd, 1, 20);
                var postalCode = _testDataHelper.GetRandomIntInRange(rnd, 10000, 90000).ToString();

                LocationAddress locationAddress = new LocationAddress()
                {
                    LocationId = location.LocationId,
                    StreetNumberAndName = streetNumberAndName,
                    ApartmentRoomOrSuiteNumber = apartmentRoomOrSuiteNumber,
                    City = _testDataHelper.GetCityName(rnd, placeNames),
                    PostalCode = postalCode,
                    RefStateId = refState.RefStateId
                };

                if (includePlus4Code)
                {
                    locationAddress.PostalCode = postalCode + "-" + _testDataHelper.GetRandomIntInRange(rnd, 1000, 9000).ToString();
                }

                testData.LocationAddresses.Add(locationAddress);

            }

            bool schoolHasNcesId = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SchoolHasNcesIdDistribution);

            if (schoolHasNcesId)
            {

                // NCES Id
                OrganizationIdentifier ncesOrganizationIdentifier = new OrganizationIdentifier()
                {
                    OrganizationIdentifierId = this.SetAndGetMaxId("OrganizationIdentifiers"),
                    OrganizationId = schoolOrganizationId,
                    Identifier = refStateAnsicode.Code + schoolOrganizationId.ToString().PadLeft(8, '0'),
                    RefOrganizationIdentifierTypeId = schoolOrganizationIdentifierTypeId,
                    RefOrganizationIdentificationSystemId = schoolNcesIdentificationSystemId
                };

                testData.OrganizationIdentifiers.Add(ncesOrganizationIdentifier);

            }

            // SEA Id
            OrganizationIdentifier seaOrganizationIdentifier = new OrganizationIdentifier()
            {
                OrganizationIdentifierId = this.SetAndGetMaxId("OrganizationIdentifiers"),
                OrganizationId = schoolOrganizationId,
                Identifier = schoolOrganizationId.ToString().PadLeft(10, '0'),
                RefOrganizationIdentifierTypeId = schoolOrganizationIdentifierTypeId,
                RefOrganizationIdentificationSystemId = schoolSeaIdentificationSystemId
            };

            testData.OrganizationIdentifiers.Add(seaOrganizationIdentifier);

            // K12programOrService

            var refTitleIinstructionalServicesCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIinstructionalServiceDistribution);
            var refTitleIinstructionalServicesId = this.OdsReferenceData.RefTitleIinstructionalServices.Single(x => x.Code == refTitleIinstructionalServicesCode).RefTitleIinstructionalServicesId;

            var refTitleIProgramTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIprogramTypeDistribution);
            var refTitleIProgramTypeId = this.OdsReferenceData.RefTitleIprogramTypes.Single(x => x.Code == refTitleIProgramTypeCode).RefTitleIprogramTypeId;

            var refMepProjectTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefMepProjectTypeDistribution);
            var refMepProjectTypeId = this.OdsReferenceData.RefMepProjectTypes.Single(x => x.Code == refMepProjectTypeCode).RefMepProjectTypeId;

            K12programOrService k12programOrservice = new K12programOrService()
            {
                OrganizationId = schoolOrganizationId,
                RefTitleIinstructionalServicesId = refTitleIinstructionalServicesId,
                RefTitleIprogramTypeId = refTitleIProgramTypeId,
                RefMepProjectTypeId = refMepProjectTypeId
            };

            testData.K12ProgramOrServices.Add(k12programOrservice);


            // OrganizationIndicator

            var refOrganizationIndicatorCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefOrganizationIndicatorDistribution);
            var refOrganizationIndicatorId = this.OdsReferenceData.RefOrganizationIndicators.Single(x => x.Code == refOrganizationIndicatorCode).RefOrganizationIndicatorId;

            var sharedTimeIndicatorValue = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SharedTimeOrganizationIndicatorValueDistribution);
           
            string indicatorValue = "N/A";

            if (refOrganizationIndicatorCode == "SharedTime")
            {
                indicatorValue = sharedTimeIndicatorValue;
            }
          

            OrganizationIndicator organizationIndicator = new OrganizationIndicator()
            {
                OrganizationIndicatorId = this.SetAndGetMaxId("OrganizationIndicators"),
                OrganizationId = schoolOrganizationId,
                RefOrganizationIndicatorId = refOrganizationIndicatorId,
                IndicatorValue = indicatorValue
            };

            testData.OrganizationIndicators.Add(organizationIndicator);

            // K12titleIiilanguageInstruction

            var refTitleIiilanguageInstructionProgramTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIiilanguageInstructionProgramTypeDistribution);
            var refTitleIiilanguageInstructionProgramTypeId = this.OdsReferenceData.RefTitleIiilanguageInstructionProgramTypes.Single(x => x.Code == refTitleIiilanguageInstructionProgramTypeCode).RefTitleIiilanguageInstructionProgramTypeId;

            K12titleIiilanguageInstruction k12titleIiilanguageInstruction = new K12titleIiilanguageInstruction()
            {
                K12titleIiilanguageInstructionId = this.SetAndGetMaxId("K12titleIiilanguageInstructions"),
                OrganizationId = schoolOrganizationId,
                RefTitleIiilanguageInstructionProgramTypeId = refTitleIiilanguageInstructionProgramTypeId
            };

            testData.K12titleIiilanguageInstructions.Add(k12titleIiilanguageInstruction);

            // Programs


            // Special Ed Program

            bool hasSpecialEdProgram = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasSpecialEdProgramDistribution);

            if (hasSpecialEdProgram)
            {

                string specialEdProgramName = organizationDetail.ShortName + " Special ED Program";
                string specialEdProgramShortName = organizationDetail.ShortName + "SEP";

                Organization specialEdProgramOrganization = new Organization()
                {
                    OrganizationId = this.SetAndGetMaxId("Organizations")
                };

                testData.Organizations.Add(specialEdProgramOrganization);
                this.SpecialEdProgramIds.Add(specialEdProgramOrganization.OrganizationId);

                OrganizationDetail specialEdProgramOrganizationDetail = new OrganizationDetail()
                {
                    OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                    OrganizationId = specialEdProgramOrganization.OrganizationId,
                    Name = specialEdProgramName,
                    RefOrganizationTypeId = this.OdsReferenceData.ProgramRefOrganizationTypeId,
                    ShortName = specialEdProgramShortName,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationDetails.Add(specialEdProgramOrganizationDetail);

                OrganizationProgramType specialEdOrganizationProgramType = new OrganizationProgramType()
                {
                    OrganizationProgramTypeId = this.SetAndGetMaxId("OrganizationProgramTypes"),
                    OrganizationId = specialEdProgramOrganization.OrganizationId,
                    RefProgramTypeId = this.OdsReferenceData.SpecialEdProgramTypeId,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationProgramTypes.Add(specialEdOrganizationProgramType);

                OrganizationRelationship specialEdOrganizationRelationship = new OrganizationRelationship()
                {
                    OrganizationRelationshipId = this.SetAndGetMaxId("OrganizationRelationships"),
                    ParentOrganizationId = schoolOrganizationId,
                    OrganizationId = specialEdProgramOrganization.OrganizationId
                };

                testData.OrganizationRelationships.Add(specialEdOrganizationRelationship);
                this.AllSchoolProgramRelationships.Add(specialEdOrganizationRelationship);
            }

            // LEP Program

            bool hasLepProgram = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasLepProgramDistribution);

            if (hasLepProgram)
            {
                
                string lepProgramName = organizationDetail.ShortName + " LEP Program";
                string lepProgramShortName = organizationDetail.ShortName + "LEP";

                Organization lepProgramOrganization = new Organization()
                {
                    OrganizationId = this.SetAndGetMaxId("Organizations")
                };

                testData.Organizations.Add(lepProgramOrganization);
                this.LepProgramIds.Add(lepProgramOrganization.OrganizationId);

                OrganizationDetail lepProgramOrganizationDetail = new OrganizationDetail()
                {
                    OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                    OrganizationId = lepProgramOrganization.OrganizationId,
                    Name = lepProgramName,
                    RefOrganizationTypeId = this.OdsReferenceData.ProgramRefOrganizationTypeId,
                    ShortName = lepProgramShortName,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationDetails.Add(lepProgramOrganizationDetail);

                OrganizationProgramType lepOrganizationProgramType = new OrganizationProgramType()
                {
                    OrganizationProgramTypeId = this.SetAndGetMaxId("OrganizationProgramTypes"),
                    OrganizationId = lepProgramOrganization.OrganizationId,
                    RefProgramTypeId = this.OdsReferenceData.LepProgramTypeId,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationProgramTypes.Add(lepOrganizationProgramType);

                OrganizationRelationship lepOrganizationRelationship = new OrganizationRelationship()
                {
                    OrganizationRelationshipId = this.SetAndGetMaxId("OrganizationRelationships"),
                    ParentOrganizationId = schoolOrganizationId,
                    OrganizationId = lepProgramOrganization.OrganizationId
                };

                testData.OrganizationRelationships.Add(lepOrganizationRelationship);
                this.AllSchoolProgramRelationships.Add(lepOrganizationRelationship);

                // K12schoolStatus

                var refTitleIschoolStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIschoolStatusDistribution);
                var refTitleIschoolStatusId = this.OdsReferenceData.RefTitleIschoolStatuses.Single(x => x.Code == refTitleIschoolStatusCode).RefTitle1SchoolStatusId;

                var refMagnetSpecialProgramCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefMagnetSpecialProgramDistribution);
                var refMagnetSpecialProgramId = this.OdsReferenceData.RefMagnetSpecialPrograms.Single(x => x.Code == refMagnetSpecialProgramCode).RefMagnetSpecialProgramId;

                var refNSLPStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefNSLPStatusDistribution);
                var refNSLPStatusId = this.OdsReferenceData.RefNSLPStatuses.Single(x => x.Code == refNSLPStatusCode).RefNSLPStatusId;

                var refSchoolDangerousStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefSchoolDangerousStatusDistribution);
                var refSchoolDangerousStatusId = this.OdsReferenceData.RefSchoolDangerousStatuses.Single(x => x.Code == refSchoolDangerousStatusCode).RefSchoolDangerousStatusId;

                var refProgressAchievingEnglishLanguageProficiencyIndicatorStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusDistribution);
                var refProgressAchievingEnglishLanguageProficiencyIndicatorStatusId = this.OdsReferenceData.RefProgressAchievingEnglishLanguageProficiencyIndicatorStatuses.Single(x => x.Code == refProgressAchievingEnglishLanguageProficiencyIndicatorStatusCode).RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId;

                var refComprehensiveAndTargetedSupportCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefComprehensiveAndTargetedSupportDistribution);
                
                var refVirtualschoolStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefVirtualSchoolStatusDistribution);
                var refVirtualschoolStatusId = this.OdsReferenceData.RefVirtualSchoolStatuses.Single(x => x.Code == refVirtualschoolStatusCode).RefVirtualSchoolStatusId;

                var consolidatedMepFundsStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ConsolidatedMepFundsStatusDistribution);


                int? refComprehensiveSupportId;
                int? refTargetedSupportId;
                int? refComprehensiveSupportImprovementId;
                int? refTargetedSupportImpovementId;
                int? refAdditionalTargetedSupportImpovementId;

                switch (refComprehensiveAndTargetedSupportCode)
                {
                    case "CSI":
                    case "CSIEXIT":
                        var refComprehensiveSupportCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefComprehensiveSupportDistribution);
                        refComprehensiveSupportId = this.OdsReferenceData.RefComprehensiveSupports.Single(x => x.Code == refComprehensiveSupportCode).RefComprehensiveSupportId;
                        refComprehensiveSupportImprovementId = this.OdsReferenceData.RefComprehensiveSupportImprovements.Single(x => x.Code == refComprehensiveAndTargetedSupportCode).RefComprehensiveSupportImprovementId;
                        
                        refTargetedSupportId = null;
                        refTargetedSupportImpovementId = this.OdsReferenceData.RefTargetedSupportImprovements.Single(x => x.Code == "NOTTSI").RefTargetedSupportImprovementId;

                        refAdditionalTargetedSupportImpovementId = null;
                        break;
                    case "TSI":
                    case "TSIEXIT":
                        refComprehensiveSupportId = null;
                        refComprehensiveSupportImprovementId = this.OdsReferenceData.RefComprehensiveSupportImprovements.Single(x => x.Code == "NOTCSI").RefComprehensiveSupportImprovementId;

                        var refTargetedSupportCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTargetedSupportDistribution);
                        refTargetedSupportId = this.OdsReferenceData.RefTargetedSupports.Single(x => x.Code == refTargetedSupportCode).RefTargetedSupportId;
                        refTargetedSupportImpovementId = this.OdsReferenceData.RefTargetedSupportImprovements.Single(x => x.Code == refComprehensiveAndTargetedSupportCode).RefTargetedSupportImprovementId;
                        refAdditionalTargetedSupportImpovementId = null;

                        break;
                    case "ADDLTSI":
                        refComprehensiveSupportId = null;
                        refComprehensiveSupportImprovementId = this.OdsReferenceData.RefComprehensiveSupportImprovements.Single(x => x.Code == "NOTCSI").RefComprehensiveSupportImprovementId;
                        refTargetedSupportId = null;
                        refTargetedSupportImpovementId = null;

                        var refAdditionalTargetedSupportCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAdditionalTargetedSupportDistribution);
                        //refTargetedSupportId = this.OdsReferenceData.RefTargetedSupports.Single(x => x.Code == refPrimaryTargetedSupportCode).RefTargetedSupportId;
                        //refTargetedSupportImpovementId = this.OdsReferenceData.RefTargetedSupportImprovements.Single(x => x.Code == refPrimaryTargetedSupportCode).RefTargetedSupportImprovementId;
                        refAdditionalTargetedSupportImpovementId = this.OdsReferenceData.RefAdditionalTargetedSupportImprovements.Single(x => x.Code == refAdditionalTargetedSupportCode).RefAdditionalTargetedSupportId;

                        break;
                    case "NOTCSITSI":
                        refComprehensiveSupportId = null;
                        refTargetedSupportId = null;
                        refTargetedSupportImpovementId = null;
                        refComprehensiveSupportImprovementId = null;
                        refAdditionalTargetedSupportImpovementId = null;
                        break;
                    default:
                        refComprehensiveSupportId = null;
                        refTargetedSupportId = null;
                        refTargetedSupportImpovementId = null;
                        refComprehensiveSupportImprovementId = null;
                        refAdditionalTargetedSupportImpovementId = null;
                        break;
                }


                K12schoolStatus title1k12SchoolStatus = new K12schoolStatus()
                {
                    K12schoolStatusId = this.SetAndGetMaxId("K12SchoolStatuses"),
                    K12schoolId = k12school.K12schoolId,
                    RefTitleIschoolStatusId = refTitleIschoolStatusId,
                    RefMagnetSpecialProgramId = refMagnetSpecialProgramId,
                    ConsolidatedMepFundsStatus = consolidatedMepFundsStatus,
                    RefNSLPStatusId = refNSLPStatusId,
                    RefSchoolDangerousStatusId = refSchoolDangerousStatusId,
                    RefSchoolImprovementStatusId = refSchoolImprovementStatusId,
                    RefProgressAchievingEnglishLanguageProficiencyIndicatorStatusId = refProgressAchievingEnglishLanguageProficiencyIndicatorStatusId,
                    RefComprehensiveSupportId = refComprehensiveSupportId,
                    RefVirtualSchoolStatusId = refVirtualschoolStatusId,
                    RefTargetedSupportId = refTargetedSupportId,
                    RecordStartDateTime = organizationStartDateTime
                };

                if (refProgressAchievingEnglishLanguageProficiencyIndicatorStatusCode == "STTDEF")
                {

                    bool hasProgressAcheivingEnglishLearnerProficiencyStateDefinedStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasProgressAcheivingEnglishLearnerProficiencyStateDefinedStatusDistribution);
                    if (hasProgressAcheivingEnglishLearnerProficiencyStateDefinedStatus)
                    {
                        var progressAcheivingEnglishLearnerProficiencyStateDefinedStatusCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatusDistribution);
                        title1k12SchoolStatus.ProgressAcheivingEnglishLearnerProficiencyStateDefinedStatus = progressAcheivingEnglishLearnerProficiencyStateDefinedStatusCode;
                    }
                }


                testData.K12SchoolStatuses.Add(title1k12SchoolStatus);


            }


            // K12SchoolIndicatorStatuses

            DateTime? indicatorStartDate = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(SchoolYear - 4, 1, 1), new DateTime(SchoolYear, 6, 30));

            // Iterate through each status type for FS199, FS200, FS201, FS202
            foreach (var refIndicatorStatusType in this.OdsReferenceData.RefIndicatorStatusTypes)
            {
                // Iterate through each status subgroup type
                foreach (var refIndicatorStatusSubgroupType in this.OdsReferenceData.RefIndicatorStatusSubgroupTypes)
                {
                    RefIndicatorStateDefinedStatus refIndicatorStateDefinedStatus = _testDataHelper.GetRandomObject<RefIndicatorStateDefinedStatus>(rnd, this.OdsReferenceData.RefIndicatorStateDefinedStatuses);
                    string indicatorStatus = null;

                    // Only set indicator status for State Defined Statuses
                    if (refIndicatorStateDefinedStatus.Code == "STTDEF")
                    {
                        indicatorStatus = _testDataHelper.GetRandomObject<string>(rnd, this.OdsReferenceData.IndicatorStatuses);
                    }

                    int? refIndicatorStatusCustomTypeId = null;

                    if (refIndicatorStatusType.Code == "SchoolQualityOrStudentSuccessIndicatorStatus")
                    {
                        var refIndicatorStatusCustomType = _testDataHelper.GetRandomObject<RefIndicatorStatusCustomType>(rnd, this.OdsReferenceData.RefIndicatorStatusCustomTypes);
                        refIndicatorStatusCustomTypeId = refIndicatorStatusCustomType.RefIndicatorStatusCustomTypeId;
                    }

                    if (refIndicatorStatusSubgroupType.Code == "RaceEthnicity")
                    {
                        // Iterate through races

                        foreach (var majorRacialEthnicGroup in this.OdsReferenceData.MajorRacialEthnicGroups)
                        {
                            bool includeRace = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IncludeMajorRaceStatusDistribution);

                            if (includeRace)
                            {
                                K12schoolIndicatorStatus k12SchoolIndicatorStatus = new K12schoolIndicatorStatus
                                {
                                    K12SchoolIndicatorStatusId = this.SetAndGetMaxId("K12schoolIndicatorStatuses"),
                                    K12schoolId = k12school.K12schoolId,
                                    RefIndicatorStatusTypeId = refIndicatorStatusType.RefIndicatorStatusTypeId,
                                    RefIndicatorStatusSubgroupTypeId = refIndicatorStatusSubgroupType.RefIndicatorStatusSubgroupTypeId,
                                    IndicatorStatusSubgroup = majorRacialEthnicGroup,
                                    RefIndicatorStateDefinedStatusId = refIndicatorStateDefinedStatus.RefIndicatorStateDefinedStatusId,
                                    IndicatorStatus = indicatorStatus,
                                    RefIndicatorStatusCustomTypeId = refIndicatorStatusCustomTypeId,
                                    RecordStartDateTime = indicatorStartDate
                                };

                                testData.K12SchoolIndicatorStatuses.Add(k12SchoolIndicatorStatus);
                            }

                        }

                    }
                    else
                    {
                        K12schoolIndicatorStatus k12SchoolIndicatorStatus = new K12schoolIndicatorStatus
                        {
                            K12SchoolIndicatorStatusId = this.SetAndGetMaxId("K12schoolIndicatorStatuses"),
                            K12schoolId = k12school.K12schoolId,
                            RefIndicatorStatusTypeId = refIndicatorStatusType.RefIndicatorStatusTypeId,
                            RefIndicatorStatusSubgroupTypeId = refIndicatorStatusSubgroupType.RefIndicatorStatusSubgroupTypeId,
                            IndicatorStatusSubgroup = refIndicatorStatusSubgroupType.Code,
                            RefIndicatorStateDefinedStatusId = refIndicatorStateDefinedStatus.RefIndicatorStateDefinedStatusId,
                            IndicatorStatus = indicatorStatus,
                            RefIndicatorStatusCustomTypeId = refIndicatorStatusCustomTypeId,
                            RecordStartDateTime = indicatorStartDate
                        };

                        testData.K12SchoolIndicatorStatuses.Add(k12SchoolIndicatorStatus);

                    }
                }
            }



            // Section 504 Program
            bool hasSection504Program = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasSection504ProgramDistribution);

            if (hasSection504Program)
            {
                var section504ProgramTypeId = this.OdsReferenceData.RefProgramTypes.Single(o => o.Code == "04967").RefProgramTypeId;

                string section504ProgramName = organizationDetail.ShortName + " Section 504 Program";
                string section504ProgramShortName = organizationDetail.ShortName + "504";

                Organization section504ProgramOrganization = new Organization()
                {
                    OrganizationId = this.SetAndGetMaxId("Organizations")
                };

                testData.Organizations.Add(section504ProgramOrganization);
                this.Section504ProgramIds.Add(section504ProgramOrganization.OrganizationId);

                OrganizationDetail section504ProgramOrganizationDetail = new OrganizationDetail()
                {
                    OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                    OrganizationId = section504ProgramOrganization.OrganizationId,
                    Name = section504ProgramName,
                    RefOrganizationTypeId = this.OdsReferenceData.ProgramRefOrganizationTypeId,
                    ShortName = section504ProgramShortName,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationDetails.Add(section504ProgramOrganizationDetail);

                OrganizationProgramType section504OrganizationProgramType = new OrganizationProgramType()
                {
                    OrganizationProgramTypeId = this.SetAndGetMaxId("OrganizationProgramTypes"),
                    OrganizationId = section504ProgramOrganization.OrganizationId,
                    RefProgramTypeId = section504ProgramTypeId,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationProgramTypes.Add(section504OrganizationProgramType);

                OrganizationRelationship section504OrganizationRelationship = new OrganizationRelationship()
                {
                    OrganizationRelationshipId = this.SetAndGetMaxId("OrganizationRelationships"),
                    ParentOrganizationId = schoolOrganizationId,
                    OrganizationId = section504ProgramOrganization.OrganizationId
                };

                testData.OrganizationRelationships.Add(section504OrganizationRelationship);
                this.AllSchoolProgramRelationships.Add(section504OrganizationRelationship);

            }


            // Foster Care Program
            bool hasFosterCareProgram = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasFosterCareProgramDistribution);

            if (hasFosterCareProgram)
            {

                string fosterCareProgramName = organizationDetail.ShortName + " Foster Care Program";
                string fosterCareProgramShortName = organizationDetail.ShortName + "Foster";

                Organization fosterCareProgramOrganization = new Organization()
                {
                    OrganizationId = this.SetAndGetMaxId("Organizations")
                };

                testData.Organizations.Add(fosterCareProgramOrganization);
                this.FosterCareProgramIds.Add(fosterCareProgramOrganization.OrganizationId);

                OrganizationDetail fosterCareProgramOrganizationDetail = new OrganizationDetail()
                {
                    OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                    OrganizationId = fosterCareProgramOrganization.OrganizationId,
                    Name = fosterCareProgramName,
                    RefOrganizationTypeId = this.OdsReferenceData.ProgramRefOrganizationTypeId,
                    ShortName = fosterCareProgramShortName,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationDetails.Add(fosterCareProgramOrganizationDetail);

                OrganizationProgramType section504OrganizationProgramType = new OrganizationProgramType()
                {
                    OrganizationProgramTypeId = this.SetAndGetMaxId("OrganizationProgramTypes"),
                    OrganizationId = fosterCareProgramOrganization.OrganizationId,
                    RefProgramTypeId = this.OdsReferenceData.FosterCareProgramTypeId,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationProgramTypes.Add(section504OrganizationProgramType);

                OrganizationRelationship fosterCareOrganizationRelationship = new OrganizationRelationship()
                {
                    OrganizationRelationshipId = this.SetAndGetMaxId("OrganizationRelationships"),
                    ParentOrganizationId = schoolOrganizationId,
                    OrganizationId = fosterCareProgramOrganization.OrganizationId
                };

                testData.OrganizationRelationships.Add(fosterCareOrganizationRelationship);
                this.AllSchoolProgramRelationships.Add(fosterCareOrganizationRelationship);

            }

            // Immigrant Education Program
            bool hasImmigrantEducationProgram = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasImmigrantEducationProgramDistribution);

            if (hasImmigrantEducationProgram)
            {

                string immigrantEducationProgramName = organizationDetail.ShortName + " Immigrant Education Program";
                string immigrantEducationProgramShortName = organizationDetail.ShortName + "ImmigrantEd";

                Organization immigrantEducationProgramOrganization = new Organization()
                {
                    OrganizationId = this.SetAndGetMaxId("Organizations")
                };

                testData.Organizations.Add(immigrantEducationProgramOrganization);
                this.ImmigrantEducationProgramIds.Add(immigrantEducationProgramOrganization.OrganizationId);


                OrganizationDetail immigrantEducationProgramOrganizationDetail = new OrganizationDetail()
                {
                    OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                    OrganizationId = immigrantEducationProgramOrganization.OrganizationId,
                    Name = immigrantEducationProgramName,
                    RefOrganizationTypeId = this.OdsReferenceData.ProgramRefOrganizationTypeId,
                    ShortName = immigrantEducationProgramShortName,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationDetails.Add(immigrantEducationProgramOrganizationDetail);

                OrganizationProgramType immigrantEducationOrganizationProgramType = new OrganizationProgramType()
                {
                    OrganizationProgramTypeId = this.SetAndGetMaxId("OrganizationProgramTypes"),
                    OrganizationId = immigrantEducationProgramOrganization.OrganizationId,
                    RefProgramTypeId = this.OdsReferenceData.ImmigrantEducationProgramTypeId,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationProgramTypes.Add(immigrantEducationOrganizationProgramType);

                OrganizationRelationship immigrantEducationOrganizationRelationship = new OrganizationRelationship()
                {
                    OrganizationRelationshipId = this.SetAndGetMaxId("OrganizationRelationships"),
                    ParentOrganizationId = schoolOrganizationId,
                    OrganizationId = immigrantEducationProgramOrganization.OrganizationId
                };

                testData.OrganizationRelationships.Add(immigrantEducationOrganizationRelationship);
                this.AllSchoolProgramRelationships.Add(immigrantEducationOrganizationRelationship);

            }

            // Migrant Education Program

            bool hasMigrantEducationProgram = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasMigrantEducationProgramDistribution);

            if (hasMigrantEducationProgram)
            {

                string migrantEducationProgramName = organizationDetail.ShortName + " Migrant Education Program";
                string migrantEducationProgramShortName = organizationDetail.ShortName + "MigrantEd";

                Organization migrantEducationProgramOrganization = new Organization()
                {
                    OrganizationId = this.SetAndGetMaxId("Organizations")
                };

                testData.Organizations.Add(migrantEducationProgramOrganization);
                this.MigrantEducationProgramIds.Add(migrantEducationProgramOrganization.OrganizationId);

                OrganizationDetail migrantEducationProgramOrganizationDetail = new OrganizationDetail()
                {
                    OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                    OrganizationId = migrantEducationProgramOrganization.OrganizationId,
                    Name = migrantEducationProgramName,
                    RefOrganizationTypeId = this.OdsReferenceData.ProgramRefOrganizationTypeId,
                    ShortName = migrantEducationProgramShortName,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationDetails.Add(migrantEducationProgramOrganizationDetail);

                OrganizationProgramType migrantEducationOrganizationProgramType = new OrganizationProgramType()
                {
                    OrganizationProgramTypeId = this.SetAndGetMaxId("OrganizationProgramTypes"),
                    OrganizationId = migrantEducationProgramOrganization.OrganizationId,
                    RefProgramTypeId = this.OdsReferenceData.MigrantEducationProgramTypeId,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationProgramTypes.Add(migrantEducationOrganizationProgramType);

                OrganizationRelationship migrantEducationOrganizationRelationship = new OrganizationRelationship()
                {
                    OrganizationRelationshipId = this.SetAndGetMaxId("OrganizationRelationships"),
                    ParentOrganizationId = schoolOrganizationId,
                    OrganizationId = migrantEducationProgramOrganization.OrganizationId
                };

                testData.OrganizationRelationships.Add(migrantEducationOrganizationRelationship);
                this.AllSchoolProgramRelationships.Add(migrantEducationOrganizationRelationship);

            }

            // CTE Program

            bool hasCTEProgram = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasCTEProgramDistribution);

            if (hasCTEProgram)
            {

                string cteProgramName = organizationDetail.ShortName + " CTE Program";
                string cteProgramShortName = organizationDetail.ShortName + "CTE";

                Organization cteProgramOrganization = new Organization()
                {
                    OrganizationId = this.SetAndGetMaxId("Organizations")
                };

                testData.Organizations.Add(cteProgramOrganization);
                this.CTEProgramIds.Add(cteProgramOrganization.OrganizationId);

                OrganizationDetail cteProgramOrganizationDetail = new OrganizationDetail()
                {
                    OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                    OrganizationId = cteProgramOrganization.OrganizationId,
                    Name = cteProgramName,
                    RefOrganizationTypeId = this.OdsReferenceData.ProgramRefOrganizationTypeId,
                    ShortName = cteProgramShortName,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationDetails.Add(cteProgramOrganizationDetail);

                OrganizationProgramType cteOrganizationProgramType = new OrganizationProgramType()
                {
                    OrganizationProgramTypeId = this.SetAndGetMaxId("OrganizationProgramTypes"),
                    OrganizationId = cteProgramOrganization.OrganizationId,
                    RefProgramTypeId = this.OdsReferenceData.CteProgramTypeId,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationProgramTypes.Add(cteOrganizationProgramType);

                OrganizationRelationship cteOrganizationRelationship = new OrganizationRelationship()
                {
                    OrganizationRelationshipId = this.SetAndGetMaxId("OrganizationRelationships"),
                    ParentOrganizationId = schoolOrganizationId,
                    OrganizationId = cteProgramOrganization.OrganizationId
                };

                testData.OrganizationRelationships.Add(cteOrganizationRelationship);
                this.AllSchoolProgramRelationships.Add(cteOrganizationRelationship);

            }

            // Neglected Program



            bool hasNeglectedProgram = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasNeglectedProgramDistribution);

            if (hasNeglectedProgram)
            {

                string neglectedProgramName = organizationDetail.ShortName + " Neglected Program";
                string neglectedProgramShortName = organizationDetail.ShortName + "Neglected";

                Organization neglectedProgramOrganization = new Organization()
                {
                    OrganizationId = this.SetAndGetMaxId("Organizations")
                };

                testData.Organizations.Add(neglectedProgramOrganization);
                this.NeglectedProgramIds.Add(neglectedProgramOrganization.OrganizationId);

                OrganizationDetail neglectedProgramOrganizationDetail = new OrganizationDetail()
                {
                    OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                    OrganizationId = neglectedProgramOrganization.OrganizationId,
                    Name = neglectedProgramName,
                    RefOrganizationTypeId = this.OdsReferenceData.ProgramRefOrganizationTypeId,
                    ShortName = neglectedProgramShortName,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationDetails.Add(neglectedProgramOrganizationDetail);

                OrganizationProgramType neglectedOrganizationProgramType = new OrganizationProgramType()
                {
                    OrganizationProgramTypeId = this.SetAndGetMaxId("OrganizationProgramTypes"),
                    OrganizationId = neglectedProgramOrganization.OrganizationId,
                    RefProgramTypeId = this.OdsReferenceData.NeglectedProgramTypeId,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationProgramTypes.Add(neglectedOrganizationProgramType);

                OrganizationRelationship neglectedOrganizationRelationship = new OrganizationRelationship()
                {
                    OrganizationRelationshipId = this.SetAndGetMaxId("OrganizationRelationships"),
                    ParentOrganizationId = schoolOrganizationId,
                    OrganizationId = neglectedProgramOrganization.OrganizationId
                };

                testData.OrganizationRelationships.Add(neglectedOrganizationRelationship);
                this.AllSchoolProgramRelationships.Add(neglectedOrganizationRelationship);

            }

            // Homeless Program

            bool hasHomelessProgram = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HasHomelessProgramDistribution);

            if (hasHomelessProgram)
            {

                string homelessProgramName = organizationDetail.ShortName + " Homeless Program";
                string homelessProgramShortName = organizationDetail.ShortName + "Homeless";

                Organization homelessProgramOrganization = new Organization()
                {
                    OrganizationId = this.SetAndGetMaxId("Organizations")
                };

                testData.Organizations.Add(homelessProgramOrganization);
                this.HomelessProgramIds.Add(homelessProgramOrganization.OrganizationId);

                OrganizationDetail homelessProgramOrganizationDetail = new OrganizationDetail()
                {
                    OrganizationDetailId = this.SetAndGetMaxId("OrganizationDetails"),
                    OrganizationId = homelessProgramOrganization.OrganizationId,
                    Name = homelessProgramName,
                    RefOrganizationTypeId = this.OdsReferenceData.ProgramRefOrganizationTypeId,
                    ShortName = homelessProgramShortName,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationDetails.Add(homelessProgramOrganizationDetail);

                OrganizationProgramType homelessOrganizationProgramType = new OrganizationProgramType()
                {
                    OrganizationProgramTypeId = this.SetAndGetMaxId("OrganizationProgramTypes"),
                    OrganizationId = homelessProgramOrganization.OrganizationId,
                    RefProgramTypeId = this.OdsReferenceData.HomelessProgramTypeId,
                    RecordStartDateTime = organizationStartDateTime
                };

                testData.OrganizationProgramTypes.Add(homelessOrganizationProgramType);

                OrganizationRelationship homelessOrganizationRelationship = new OrganizationRelationship()
                {
                    OrganizationRelationshipId = this.SetAndGetMaxId("OrganizationRelationships"),
                    ParentOrganizationId = schoolOrganizationId,
                    OrganizationId = homelessProgramOrganization.OrganizationId
                };

                testData.OrganizationRelationships.Add(homelessOrganizationRelationship);
                this.AllSchoolProgramRelationships.Add(homelessOrganizationRelationship);

            }

            // AssessmentAdministrationOrganization

            foreach (var assessmentAdministration in this.AllAssessmentAdministrations)
            {
                var assessmentAdministrationOrganization = new AssessmentAdministrationOrganization()
                {
                    AssessmentAdministration_OrganizationId = this.SetAndGetMaxId("AssessmentAdministrationOrganizations"),
                    OrganizationId = schoolOrganizationId,
                    AssessmentAdministrationId = assessmentAdministration.AssessmentAdministrationId
                };
                testData.AssessmentAdministrationOrganizations.Add(assessmentAdministrationOrganization);
                this.AllAssessmentAdministrationOrganizations.Add(assessmentAdministrationOrganization);

            }


            return testData;
        }

        private IdsTestDataObject CreateStudentsAndPersonnel(Random rnd, int quantityOfPersons, IdsTestDataObject testData, Role role)
        {
            DateTime startTime = DateTime.UtcNow;

            if (_showDebugInfo && role.Name != "Chief State School Officer")
            {
                Console.WriteLine("    - " + role.Name + " / " + quantityOfPersons);
            }


            int leaEnrollmentCntr = 0;
            int schoolEnrollmentCntr = 0;


            var personIdsAdded = new List<int>();

            for (int personCounter = 0; personCounter < quantityOfPersons; personCounter++)
            {
                var person = new Person()
                {
                    PersonId = this.SetAndGetMaxId("Persons")
                };

                testData.Persons.Add(person);

                personIdsAdded.Add(person.PersonId);

            }

            if (role.Name == "K12 Student")
            {
                testData.StudentPersonIds.AddRange(personIdsAdded);
            }
            else if (role.Name == "K12 Personnel")
            {
                testData.PersonnelPersonIds.AddRange(personIdsAdded);
            }



            // PersonDetails


            int cntr = 0;

            // Additional Person Attributes
            /////////////////////////////////////

            foreach (var personId in personIdsAdded)
            {
                cntr++;


                // Sex
                string refSexCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SexDistribution);

                var refSexId = this.OdsReferenceData.RefSexes.FirstOrDefault(x => x.Code == refSexCode)?.RefSexId;

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

                var birthDate = _testDataHelper.GetBirthDate(rnd, SchoolYear, _testDataProfile.MinimumAgeOfStudent, _testDataProfile.MaximumAgeOfStudent);

                if (role.Name != "K12 Student")
                {
                    // If not student, then assume is an adult (age 21 through 80)
                    _testDataHelper.GetBirthDate(rnd, SchoolYear, 21, 80);
                }

                bool hispanicIndicator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HispanicDistribution);

                var personDetail = new PersonDetail()
                {
                    PersonDetailId = this.SetAndGetMaxId("PersonDetails"),
                    PersonId = personId,
                    RefSexId = refSexId,
                    LastName = lastName,
                    FirstName = firstName,
                    MiddleName = middleName,
                    Birthdate = new DateTime(birthDate.Year, birthDate.Month, birthDate.Day),
                    HispanicLatinoEthnicity = hispanicIndicator,
                    RecordStartDateTime = birthDate
                };


                testData.PersonDetails.Add(personDetail);


                // PersonIdentifier

                int? refPersonalInformationVerificationId = null;
                int refPersonIdentificationSystemId = this.OdsReferenceData.PersonStateIdentificationSystemId;
                
                if (role.Name == "K12 Student")
                {
                    refPersonalInformationVerificationId = this.OdsReferenceData.StateIssuedId;
                    refPersonIdentificationSystemId = this.OdsReferenceData.StudentStateIdentificationSystemId;
                }
                else if (role.Name == "K12 Personnel")
                {
                    refPersonalInformationVerificationId = this.OdsReferenceData.StateIssuedId;
                    refPersonIdentificationSystemId = this.OdsReferenceData.StaffStateIdentificationSystemId;
                }



                // State ID

                var personStateIdentifier = new PersonIdentifier()
                {
                    PersonIdentifierId = this.SetAndGetMaxId("PersonIdentifiers"),
                    PersonId = personId,
                    Identifier = (rnd.Next(1000000).ToString() + personId.ToString()).PadLeft(10, '0'),
                    RefPersonalInformationVerificationId = refPersonalInformationVerificationId,
                    RefPersonIdentificationSystemId = refPersonIdentificationSystemId

                };

                testData.PersonIdentifiers.Add(personStateIdentifier);

                refPersonalInformationVerificationId = null;
                refPersonIdentificationSystemId = this.OdsReferenceData.PersonSchoolIdentificationSystemId;

                if (role.Name == "K12 Student")
                {
                    refPersonalInformationVerificationId = this.OdsReferenceData.StateIssuedId;
                    refPersonIdentificationSystemId = this.OdsReferenceData.StudentSchoolIdentificationSystemId;
                }
                else if (role.Name == "K12 Personnel" || role.Name == "Chief State School Officer")
                {
                    refPersonalInformationVerificationId = this.OdsReferenceData.StateIssuedId;
                    refPersonIdentificationSystemId = this.OdsReferenceData.StaffSchoolIdentificationSystemId;
                }

                // School ID

                var personSchoolIdentifier = new PersonIdentifier()
                {
                    PersonIdentifierId = this.SetAndGetMaxId("PersonIdentifiers"),
                    PersonId = personId,
                    Identifier = (rnd.Next(100).ToString() + personId.ToString()).PadLeft(10, '0'),
                    RefPersonalInformationVerificationId = refPersonalInformationVerificationId,
                    RefPersonIdentificationSystemId = refPersonIdentificationSystemId

                };

                testData.PersonIdentifiers.Add(personSchoolIdentifier);


                // CSSO specific data

                if (role.Name == "Chief State School Officer")
                {
                    var entryDate = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(1990, 1, 1), new DateTime(SchoolYear, 1, 1));

                    OrganizationPersonRole organizationPersonRole = new OrganizationPersonRole()
                    {
                        OrganizationPersonRoleId = this.SetAndGetMaxId("OrganizationPersonRoles"),
                        OrganizationId = testData.SeaOrganizationId,
                        PersonId = personId,
                        RoleId = role.RoleId,
                        EntryDate = entryDate
                    };

                    testData.OrganizationPersonRoles.Add(organizationPersonRole);

                }

                // PersonStatus

                int ecoDisStatus = -1;
                int homlessStatus = -1;
                int homlessUnaccompaniedYouthStatus = -1;
                int lepStatus = -1;
                int perkinsLepStatus = -1;
                int migrantStatus = -1;
                int specialEdStatus = -1;
                int immigrantTitleIIIStatus = -1;
                int disabilityStatus = -1;
                int homelessnessStatus = -1;

                if (role.Name == "K12 Student")
                {

                    // PersonStatus - EcoDis

                    ecoDisStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.EcoDisStatusDistribution);

                    // -1 = missing, 0 = false, 1 = true
                    if (ecoDisStatus >= 0)
                    {

                        PersonStatus personStatus = new PersonStatus()
                        {
                            PersonStatusId = this.SetAndGetMaxId("PersonStatuses"),
                            PersonId = personId,
                            RefPersonStatusTypeId = this.OdsReferenceData.EcoDisStatusTypeId,
                            StatusValue = ecoDisStatus == 1 ? true : false,
                            StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, birthDate, new DateTime(SchoolYear, 5, 1))
                        };

                        testData.PersonStatuses.Add(personStatus);

                    }

                    // PersonStatus - Homeless

                    homlessStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HomelessStatusDistribution);

                    // -1 = missing, 0 = false, 1 = true
                    if (homlessStatus >= 0)
                    {

                        PersonStatus personStatus = new PersonStatus()
                        {
                            PersonStatusId = this.SetAndGetMaxId("PersonStatuses"),
                            PersonId = personId,
                            RefPersonStatusTypeId = this.OdsReferenceData.HomelessStatusTypeId,
                            StatusValue = homlessStatus == 1 ? true : false,
                            StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, birthDate, new DateTime(SchoolYear, 5, 1))
                        };

                        testData.PersonStatuses.Add(personStatus);

                    }

                    // PersonStatus - Homeless Unaccompanied Youth

                    homlessUnaccompaniedYouthStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HomelessUnaccompaniedYouthStatusDistribution);

                    // -1 = missing, 0 = false, 1 = true
                    if (homlessUnaccompaniedYouthStatus >= 0)
                    {

                        PersonStatus personStatus = new PersonStatus()
                        {
                            PersonStatusId = this.SetAndGetMaxId("PersonStatuses"),
                            PersonId = personId,
                            RefPersonStatusTypeId = this.OdsReferenceData.HomlessUnaccompaniedYouthStatusTypeId,
                            StatusValue = homlessUnaccompaniedYouthStatus == 1 ? true : false,
                            StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, birthDate, new DateTime(SchoolYear, 5, 1))
                        };

                        testData.PersonStatuses.Add(personStatus);

                    }

                    // PersonStatus - LEP

                    lepStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LepStatusDistribution);

                    // -1 = missing, 0 = false, 1 = true
                    if (lepStatus >= 0)
                    {

                        PersonStatus personStatus = new PersonStatus()
                        {
                            PersonStatusId = this.SetAndGetMaxId("PersonStatuses"),
                            PersonId = personId,
                            RefPersonStatusTypeId = this.OdsReferenceData.LepStatusTypeId,
                            StatusValue = lepStatus == 1 ? true : false,
                            StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, birthDate, new DateTime(SchoolYear, 5, 1))
                        };

                        testData.PersonStatuses.Add(personStatus);

                    }


                    // PersonStatus - Perkins LEP

                    perkinsLepStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.PerkinsLepStatusDistribution);

                    // -1 = missing, 0 = false, 1 = true
                    if (perkinsLepStatus >= 0)
                    {

                        PersonStatus personStatus = new PersonStatus()
                        {
                            PersonStatusId = this.SetAndGetMaxId("PersonStatuses"),
                            PersonId = personId,
                            RefPersonStatusTypeId = this.OdsReferenceData.PerkinsLepStatusTypeId,
                            StatusValue = perkinsLepStatus == 1 ? true : false,
                            StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, birthDate, new DateTime(SchoolYear, 5, 1))
                        };

                        testData.PersonStatuses.Add(personStatus);

                    }


                    // PersonStatus - Migrant

                    migrantStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.MigrantStatusDistribution);

                    // -1 = missing, 0 = false, 1 = true
                    if (migrantStatus >= 0)
                    {
                        var migrantStatusTypeId = this.OdsReferenceData.RefPersonStatusTypes.Single(x => x.Code == "Migrant").RefPersonStatusTypeId;

                        PersonStatus personStatus = new PersonStatus()
                        {
                            PersonStatusId = this.SetAndGetMaxId("PersonStatuses"),
                            PersonId = personId,
                            RefPersonStatusTypeId = this.OdsReferenceData.MigrantStatusTypeId,
                            StatusValue = migrantStatus == 1 ? true : false,
                            StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, birthDate, new DateTime(SchoolYear, 5, 1))
                        };

                        testData.PersonStatuses.Add(personStatus);

                    }


                    // PersonStatus - Special Ed

                    specialEdStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SpecialEdStatusDistribution);

                    // -1 = missing, 0 = false, 1 = true
                    if (specialEdStatus >= 0)
                    {

                        PersonStatus personStatus = new PersonStatus()
                        {
                            PersonStatusId = this.SetAndGetMaxId("PersonStatuses"),
                            PersonId = personId,
                            RefPersonStatusTypeId = this.OdsReferenceData.SpecialEdStatusTypeId,
                            StatusValue = specialEdStatus == 1 ? true : false,
                            StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, birthDate, new DateTime(SchoolYear, 5, 1))
                        };

                        testData.PersonStatuses.Add(personStatus);

                    }


                    // PersonStatus - Immigrant Title III

                    immigrantTitleIIIStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ImmigrantTitleIIIStatusDistribution);

                    // -1 = missing, 0 = false, 1 = true
                    if (immigrantTitleIIIStatus >= 0)
                    {

                        PersonStatus personStatus = new PersonStatus()
                        {
                            PersonStatusId = this.SetAndGetMaxId("PersonStatuses"),
                            PersonId = personId,
                            RefPersonStatusTypeId = this.OdsReferenceData.ImmigrantTitleIIIStatusTypeId,
                            StatusValue = immigrantTitleIIIStatus == 1 ? true : false,
                            StatusStartDate = _testDataHelper.GetRandomDateInRange(rnd, birthDate, new DateTime(SchoolYear, 5, 1))
                        };

                        testData.PersonStatuses.Add(personStatus);

                    }


                    // Disability Status

                    disabilityStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.DisabilityStatusDistribution);

                    // -1 = missing, 0 = false, 1 = true
                    if (disabilityStatus >= 0)
                    {
                        string disabilityTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefDisabilityTypeDistribution);
                        int refDisabilityTypeId = this.OdsReferenceData.RefDisabilityTypes.Single(x => x.Code == disabilityTypeCode).RefDisabilityTypeId;

                        PersonDisability personDisability = new PersonDisability()
                        {
                            PersonDisabilityId = this.SetAndGetMaxId("PersonDisabilities"),
                            PersonId = personId,
                            DisabilityStatus = disabilityStatus == 1 ? true : false,
                            PrimaryDisabilityTypeId = refDisabilityTypeId,
                            RecordStartDateTime = _testDataHelper.GetRandomDateInRange(rnd, birthDate.AddYears(5), new DateTime(SchoolYear, 5, 1))
                        };

                        testData.PersonDisabilities.Add(personDisability);

                    }

                    // Person Homelessness Status

                    homelessnessStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.PersonHomelessnessDistribution);

                    // -1 = missing, 0 = false, 1 = true
                    if (homelessnessStatus >= 0)
                    {
                        string refHomelessNighttimeResidenceCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefHomelessNighttimeResidenceDistribution);
                        int refHomelessNighttimeResidenceId = this.OdsReferenceData.RefHomelessNighttimeResidences.Single(x => x.Code == refHomelessNighttimeResidenceCode).RefHomelessNighttimeResidenceId;

                        PersonHomelessness personHomelessness = new PersonHomelessness()
                        {
                            PersonId = personId,
                            HomelessnessStatus = homelessnessStatus == 1 ? true : false,
                            RefHomelessNighttimeResidenceId = refHomelessNighttimeResidenceId,
                            RecordStartDateTime = _testDataHelper.GetRandomDateInRange(rnd, birthDate, new DateTime(SchoolYear, 5, 1))
                        };

                        testData.PersonHomelessnesses.Add(personHomelessness);

                    }

                }

                // PersonLanguage

                if (role.Name == "K12 Student")
                {

                    string refLanguageCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefLanguageDistribution);
                    int refLanguageId = this.OdsReferenceData.RefLanguages.Single(x => x.Code == refLanguageCode).RefLanguageId;

                    string refLanguageUseTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefLanguageUseTypeDistribution);
                    int refLanguageUseTypeId = this.OdsReferenceData.RefLanguageUseTypes.Single(x => x.Code == refLanguageUseTypeCode).RefLanguageUseTypeId;

                    PersonLanguage personLanguage = new PersonLanguage()
                    {
                        PersonLanguageId = this.SetAndGetMaxId("PersonLanguages"),
                        PersonId = personId,
                        RefLanguageId = refLanguageId,
                        RefLanguageUseTypeId = refLanguageUseTypeId
                    };

                    testData.PersonLanguages.Add(personLanguage);

                }

                // Race

                if (role.Name == "K12 Student")
                {

                    var numberOfRaces = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NumberOfRacesDistribution);

                    for (int i = 0; i < numberOfRaces; i++)
                    {
                        var refRaceCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefRaceDistribution);
                        var refRaceId = this.OdsReferenceData.RefRaces.Single(x => x.Code == refRaceCode).RefRaceId;

                        PersonDemographicRace personDemographicRace = new PersonDemographicRace()
                        {
                            PersonDemographicRaceId = this.SetAndGetMaxId("PersonDemographicRaces"),
                            PersonId = personId,
                            RefRaceId = refRaceId,
                            RecordStartDateTime = birthDate
                        };

                        testData.PersonDemographicRaces.Add(personDemographicRace);

                    }

                }

                // Enrollment

                if (role.Name == "K12 Student" || role.Name == "K12 Personnel")
                {

                   

                    foreach (int leaId in this.AllLeaIds)
                    {

                    var leaOrganizationId = leaId;

                    var schoolOrganizationIdsInThisLea = this.AllLeaSchoolRelationships.Where(x => x.ParentOrganizationId == leaOrganizationId).Select(x => x.OrganizationId).ToList();
                    var schoolOrganizationIdsOutsideThisLea = this.AllLeaSchoolRelationships.Where(x => x.ParentOrganizationId != leaOrganizationId).Select(x => x.OrganizationId).ToList();

                    var allSchoolsInThisLea = this.AllSchools.Join(schoolOrganizationIdsInThisLea, x => x.OrganizationId, id => id, (x, id) => x);
                    var elementarySchoolsInThisLea = this.AllSchools.Join(schoolOrganizationIdsInThisLea, x => x.OrganizationId, id => id, (x, id) => x).Where(x => x.Name.EndsWith("Elementary") || x.Name.EndsWith("Academy"));
                    var middleSchoolsInThisLea = this.AllSchools.Join(schoolOrganizationIdsInThisLea, x => x.OrganizationId, id => id, (x, id) => x).Where(x => x.Name.EndsWith("Middle School") || x.Name.EndsWith("Junior High") || x.Name.EndsWith("Academy"));
                    var highSchoolsInThisLea = this.AllSchools.Join(schoolOrganizationIdsInThisLea, x => x.OrganizationId, id => id, (x, id) => x).Where(x => x.Name.EndsWith("High School") || x.Name.EndsWith("Academy"));

                    var allSchoolsNotInThisLea = this.AllSchools.Join(schoolOrganizationIdsOutsideThisLea, x => x.OrganizationId, id => id, (x, id) => x);
                    var elementarySchoolsNotInThisLea = this.AllSchools.Join(schoolOrganizationIdsOutsideThisLea, x => x.OrganizationId, id => id, (x, id) => x).Where(x => x.Name.EndsWith("Elementary") || x.Name.EndsWith("Academy"));
                    var middleSchoolsNotInThisLea = this.AllSchools.Join(schoolOrganizationIdsOutsideThisLea, x => x.OrganizationId, id => id, (x, id) => x).Where(x => x.Name.EndsWith("Middle School") || x.Name.EndsWith("Junior High") || x.Name.EndsWith("Academy"));
                    var highSchoolsNotInThisLea = this.AllSchools.Join(schoolOrganizationIdsOutsideThisLea, x => x.OrganizationId, id => id, (x, id) => x).Where(x => x.Name.EndsWith("High School") || x.Name.EndsWith("Academy"));

                    int startingYear = _testDataProfile.OldestStartingYear;
                    int endingYear = SchoolYear;

                        for (int enrollmentYear = startingYear; enrollmentYear <= endingYear; enrollmentYear++)
                        {
                            var approximateAgeAtEnrollment = DateUtilities.GetDifferenceInYears(birthDate, new DateTime(enrollmentYear, 8, 1));

                            if ((role.Name == "K12 Student" && approximateAgeAtEnrollment >= 5 && approximateAgeAtEnrollment <= 17) || role.Name == "K12 Personnel")
                            {
                                //Console.WriteLine("Person = " + personId + " / EnrollmentYear = " + enrollmentYear + " / Age = " + approximateAgeAtEnrollment);

                                int numberOfSchoolEnrollments = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NumberOfConcurrentSchoolEnrollmentDistribution);

                                int? leaOfEnrollmentId = null;
                                OrganizationDetail schoolOfEnrollment = null;

                                int lastSchoolOrganizationId = 0;

                                // Iterate through number of concurrent enrollments

                                for (int enrollmentNumber = 0; enrollmentNumber < numberOfSchoolEnrollments; enrollmentNumber++)
                                {

                                    bool outOfLeaSchoolEnrollment = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.EnrollmentAtOutOfLeaSchoolDistribution);
                                    bool enrollmentOnlyAtLea = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.EnrollmentOnlyAtLeaDistribution);

                                    if (role.Name == "K12 Student")
                                    {

                                        if (approximateAgeAtEnrollment >= 5 && approximateAgeAtEnrollment <= 9)
                                        {

                                            // KG, 1, 2, 3, 4
                                            if (elementarySchoolsInThisLea.Any())
                                            {

                                                if (!outOfLeaSchoolEnrollment || !elementarySchoolsNotInThisLea.Any())
                                                {
                                                    // In LEA

                                                    schoolOfEnrollment = _testDataHelper.GetRandomObject<OrganizationDetail>(rnd, elementarySchoolsInThisLea.ToList());

                                                    if (schoolOfEnrollment.OrganizationId == lastSchoolOrganizationId && elementarySchoolsInThisLea.Count() > 1)
                                                    {
                                                        while (schoolOfEnrollment.OrganizationId != lastSchoolOrganizationId)
                                                        {
                                                            schoolOfEnrollment = _testDataHelper.GetRandomObject<OrganizationDetail>(rnd, elementarySchoolsInThisLea.ToList());
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    // Out of LEA

                                                    schoolOfEnrollment = _testDataHelper.GetRandomObject<OrganizationDetail>(rnd, elementarySchoolsNotInThisLea.ToList());

                                                    if (schoolOfEnrollment.OrganizationId == lastSchoolOrganizationId && elementarySchoolsNotInThisLea.Count() > 1)
                                                    {
                                                        while (schoolOfEnrollment.OrganizationId != lastSchoolOrganizationId)
                                                        {
                                                            schoolOfEnrollment = _testDataHelper.GetRandomObject<OrganizationDetail>(rnd, elementarySchoolsNotInThisLea.ToList());
                                                        }
                                                    }
                                                }
                                            }

                                        }
                                        else if (approximateAgeAtEnrollment >= 10 && approximateAgeAtEnrollment <= 13)
                                        {
                                            // 5, 6, 7, 8
                                            if (middleSchoolsInThisLea.Any())
                                            {
                                                if (!outOfLeaSchoolEnrollment || !middleSchoolsNotInThisLea.Any())
                                                {
                                                    // In LEA
                                                    schoolOfEnrollment = _testDataHelper.GetRandomObject<OrganizationDetail>(rnd, middleSchoolsInThisLea.ToList());

                                                    if (schoolOfEnrollment.OrganizationId == lastSchoolOrganizationId && middleSchoolsInThisLea.Count() > 1)
                                                    {
                                                        while (schoolOfEnrollment.OrganizationId != lastSchoolOrganizationId)
                                                        {
                                                            schoolOfEnrollment = _testDataHelper.GetRandomObject<OrganizationDetail>(rnd, middleSchoolsInThisLea.ToList());
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    // Out of LEA
                                                    schoolOfEnrollment = _testDataHelper.GetRandomObject<OrganizationDetail>(rnd, middleSchoolsNotInThisLea.ToList());

                                                    if (schoolOfEnrollment.OrganizationId == lastSchoolOrganizationId && middleSchoolsNotInThisLea.Count() > 1)
                                                    {
                                                        while (schoolOfEnrollment.OrganizationId != lastSchoolOrganizationId)
                                                        {
                                                            schoolOfEnrollment = _testDataHelper.GetRandomObject<OrganizationDetail>(rnd, middleSchoolsNotInThisLea.ToList());
                                                        }
                                                    }
                                                }

                                            }
                                        }
                                        else if (approximateAgeAtEnrollment >= 14 && approximateAgeAtEnrollment <= 17)
                                        {
                                            // 9, 10, 11, 12
                                            if (highSchoolsInThisLea.Any())
                                            {

                                                if (!outOfLeaSchoolEnrollment || !highSchoolsNotInThisLea.Any())
                                                {
                                                    // In LEA
                                                    schoolOfEnrollment = _testDataHelper.GetRandomObject<OrganizationDetail>(rnd, highSchoolsInThisLea.ToList());

                                                    if (schoolOfEnrollment.OrganizationId == lastSchoolOrganizationId && highSchoolsInThisLea.Count() > 1)
                                                    {
                                                        while (schoolOfEnrollment.OrganizationId != lastSchoolOrganizationId)
                                                        {
                                                            schoolOfEnrollment = _testDataHelper.GetRandomObject<OrganizationDetail>(rnd, highSchoolsInThisLea.ToList());
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    // Out of LEA
                                                    schoolOfEnrollment = _testDataHelper.GetRandomObject<OrganizationDetail>(rnd, highSchoolsNotInThisLea.ToList());

                                                    if (schoolOfEnrollment.OrganizationId == lastSchoolOrganizationId && highSchoolsNotInThisLea.Count() > 1)
                                                    {
                                                        while (schoolOfEnrollment.OrganizationId != lastSchoolOrganizationId)
                                                        {
                                                            schoolOfEnrollment = _testDataHelper.GetRandomObject<OrganizationDetail>(rnd, highSchoolsNotInThisLea.ToList());
                                                        }

                                                    }
                                                }


                                            }
                                        }

                                    }
                                    else
                                    {

                                        if (allSchoolsInThisLea.Any())
                                        {

                                            if (!outOfLeaSchoolEnrollment || !allSchoolsNotInThisLea.Any())
                                            {
                                                // In LEA
                                                schoolOfEnrollment = _testDataHelper.GetRandomObject<OrganizationDetail>(rnd, allSchoolsInThisLea.ToList());

                                                if (schoolOfEnrollment.OrganizationId == lastSchoolOrganizationId && allSchoolsInThisLea.Count() > 1)
                                                {
                                                    while (schoolOfEnrollment.OrganizationId != lastSchoolOrganizationId)
                                                    {
                                                        schoolOfEnrollment = _testDataHelper.GetRandomObject<OrganizationDetail>(rnd, allSchoolsInThisLea.ToList());
                                                    }
                                                }
                                            }
                                            else
                                            {
                                                // Out of LEA
                                                schoolOfEnrollment = _testDataHelper.GetRandomObject<OrganizationDetail>(rnd, allSchoolsNotInThisLea.ToList());

                                                if (schoolOfEnrollment.OrganizationId == lastSchoolOrganizationId && allSchoolsNotInThisLea.Count() > 1)
                                                {
                                                    while (schoolOfEnrollment.OrganizationId != lastSchoolOrganizationId)
                                                    {
                                                        schoolOfEnrollment = _testDataHelper.GetRandomObject<OrganizationDetail>(rnd, allSchoolsNotInThisLea.ToList());
                                                    }

                                                }
                                            }


                                        }
                                    }

                                    DateTime entryDate = _testDataHelper.GetEntryDate(rnd, new DateTime(enrollmentYear - 1, 8, 5));
                                    DateTime exitDate = _testDataHelper.GetExitDate(rnd, entryDate, new DateTime(enrollmentYear + 2, 5, 5));

                                    // Get LEA

                                    leaOfEnrollmentId = leaOrganizationId;

                                    int leaEnrollmentOrganizationPersonRoleId = this.SetAndGetMaxId("OrganizationPersonRoles");

                                    if (leaOfEnrollmentId != null)
                                    {

                                        // LEA Enrollment

                                        OrganizationPersonRole leaEnrollmentOrganizationPersonRole = new OrganizationPersonRole()
                                        {
                                            OrganizationPersonRoleId = leaEnrollmentOrganizationPersonRoleId,
                                            OrganizationId = (int)leaOfEnrollmentId,
                                            PersonId = personId,
                                            RoleId = role.RoleId,
                                            EntryDate = entryDate,
                                            ExitDate = exitDate
                                        };

                                        testData.OrganizationPersonRoles.Add(leaEnrollmentOrganizationPersonRole);

                                        leaEnrollmentCntr++;

                                        if (role.Name == "K12 Student")
                                        {

                                            // Funding Responsibility

                                            K12organizationStudentResponsibility leaFundingK12organizationStudentResponsibility = new K12organizationStudentResponsibility()
                                            {
                                                K12organizationStudentResponsibilityId = this.SetAndGetMaxId("K12organizationStudentResponsibilities"),
                                                OrganizationPersonRoleId = leaEnrollmentOrganizationPersonRole.OrganizationPersonRoleId,
                                                RefK12responsibilityTypeId = this.OdsReferenceData.FundingResponsibilityTypeId
                                            };

                                            testData.K12organizationStudentResponsibilities.Add(leaFundingK12organizationStudentResponsibility);

                                            // Attendance Responsibility

                                            K12organizationStudentResponsibility leaAttendanceK12organizationStudentResponsibility = new K12organizationStudentResponsibility()
                                            {
                                                K12organizationStudentResponsibilityId = this.SetAndGetMaxId("K12organizationStudentResponsibilities"),
                                                OrganizationPersonRoleId = leaEnrollmentOrganizationPersonRole.OrganizationPersonRoleId,
                                                RefK12responsibilityTypeId = this.OdsReferenceData.AttendanceResponsibilityTypeId
                                            };

                                            testData.K12organizationStudentResponsibilities.Add(leaAttendanceK12organizationStudentResponsibility);

                                            // Add disciplines
                                            testData = this.CreateDisciplines(rnd, testData, leaEnrollmentOrganizationPersonRole, specialEdStatus);

                                            if (enrollmentOnlyAtLea)
                                            {
                                                // Add attendance
                                                testData = this.CreateStudentEnrollmentRelatedData(rnd, testData, leaEnrollmentOrganizationPersonRole, false, leaOfEnrollmentId);

                                            }
                                        }
                                        else
                                        {
                                            if (enrollmentOnlyAtLea)
                                            {
                                                // Personnel specific enrollment related data
                                                testData = this.CreatePersonnelEnrollmentRelatedData(rnd, testData, leaEnrollmentOrganizationPersonRole, false, leaOfEnrollmentId);
                                            }
                                        }

                                    }


                                    if (schoolOfEnrollment != null && !enrollmentOnlyAtLea)
                                    {

                                        // School Enrollment

                                        OrganizationPersonRole schoolEnrollmentOrganizationPersonRole = new OrganizationPersonRole()
                                        {
                                            OrganizationPersonRoleId = this.SetAndGetMaxId("OrganizationPersonRoles"),
                                            OrganizationId = schoolOfEnrollment.OrganizationId,
                                            PersonId = personId,
                                            RoleId = role.RoleId,
                                            EntryDate = entryDate,
                                            ExitDate = exitDate
                                        };

                                        testData.OrganizationPersonRoles.Add(schoolEnrollmentOrganizationPersonRole);

                                        OrganizationPersonRoleRelationship schoolRelationship = new OrganizationPersonRoleRelationship()
                                        {
                                            OrganizationPersonRoleRelationshipId = this.SetAndGetMaxId("OrganizationPersonRoleRelations"),
                                            OrganizationPersonRoleId = schoolEnrollmentOrganizationPersonRole.OrganizationPersonRoleId,
                                            OrganizationPersonRoleId_Parent = leaEnrollmentOrganizationPersonRoleId,
                                            RecordStartDateTime = entryDate,
                                            RecordEndDateTime = exitDate
                                        };

                                        testData.OrganizationPersonRoleRelations.Add(schoolRelationship);

                                        schoolEnrollmentCntr++;

                                        if (role.Name == "K12 Student")
                                        {
                                            // Funding Responsibility

                                            K12organizationStudentResponsibility schoolFundingK12organizationStudentResponsibility = new K12organizationStudentResponsibility()
                                            {
                                                K12organizationStudentResponsibilityId = this.SetAndGetMaxId("K12organizationStudentResponsibilities"),
                                                OrganizationPersonRoleId = schoolEnrollmentOrganizationPersonRole.OrganizationPersonRoleId,
                                                RefK12responsibilityTypeId = this.OdsReferenceData.FundingResponsibilityTypeId
                                            };

                                            testData.K12organizationStudentResponsibilities.Add(schoolFundingK12organizationStudentResponsibility);

                                            // Attendance Responsibility

                                            K12organizationStudentResponsibility schoolAttendanceK12organizationStudentResponsibility = new K12organizationStudentResponsibility()
                                            {
                                                K12organizationStudentResponsibilityId = this.SetAndGetMaxId("K12organizationStudentResponsibilities"),
                                                OrganizationPersonRoleId = schoolEnrollmentOrganizationPersonRole.OrganizationPersonRoleId,
                                                RefK12responsibilityTypeId = this.OdsReferenceData.AttendanceResponsibilityTypeId
                                            };

                                            testData.K12organizationStudentResponsibilities.Add(schoolAttendanceK12organizationStudentResponsibility);

                                            // Add disciplines
                                            testData = this.CreateDisciplines(rnd, testData, schoolEnrollmentOrganizationPersonRole, specialEdStatus);

                                            // Add attendance
                                            testData = this.CreateStudentEnrollmentRelatedData(rnd, testData, schoolEnrollmentOrganizationPersonRole, true, leaOfEnrollmentId);

                                            //Console.WriteLine("personId = " + personId + " / age = " + ageAtEnrollment + " / year = " + yearOfEnrollment + " / lea = " + leaOfEnrollment.Name + " / school = " + schoolOfEnrollment.Name);


                                        }
                                        else
                                        {
                                            // Personnel specific enrollment related data
                                            testData = this.CreatePersonnelEnrollmentRelatedData(rnd, testData, schoolEnrollmentOrganizationPersonRole, true, leaOfEnrollmentId);

                                        }

                                    }



                                }


                                if (role.Name == "K12 Student" && schoolOfEnrollment != null)
                                {
                                    // Program Participation ----
                                    //////////////////////////////////////
                                    ///

                                    // Base Program Participation Dates
                                    DateTime baseProgramEntryDate = new DateTime(enrollmentYear, 10, 15);
                                    DateTime baseProgramExitDate = new DateTime(enrollmentYear + 1, 3, 15);


                                    // Special Ed Program Participation

                                    bool isSpecialEdProgramParticipant = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SpecialEdProgramParticipationDistribution);

                                    if (specialEdStatus == 1 && isSpecialEdProgramParticipant)
                                    {
                                        var relatedSpecialEdProgram = this.AllSchoolProgramRelationships.Join(this.SpecialEdProgramIds, x => x.OrganizationId, id => id, (x, id) => x).FirstOrDefault(x => x.ParentOrganizationId == schoolOfEnrollment.OrganizationId);

                                        // Not every school has this program, so check
                                        if (relatedSpecialEdProgram != null)
                                        {
                                            bool isParticipantNow = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SpecialEdProgramParticipantNowDistribution);

                                            DateTime entryDate = _testDataHelper.GetEntryDate(rnd, baseProgramEntryDate);
                                            DateTime? exitDate = _testDataHelper.GetExitDate(rnd, entryDate, baseProgramExitDate);


                                            OrganizationPersonRole specialEdOrganizationPersonRole = new OrganizationPersonRole()
                                            {
                                                OrganizationPersonRoleId = this.SetAndGetMaxId("OrganizationPersonRoles"),
                                                OrganizationId = relatedSpecialEdProgram.OrganizationId,
                                                PersonId = personId,
                                                RoleId = role.RoleId,
                                                EntryDate = entryDate,
                                                ExitDate = exitDate
                                            };

                                            testData.OrganizationPersonRoles.Add(specialEdOrganizationPersonRole);


                                            // PersonStatus

                                            bool useDatesInPersonStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.UseDatesInPersonStatusDistribution);
                                            if (useDatesInPersonStatus)
                                            {

                                                PersonStatus personStatusToUpdate = testData.PersonStatuses.FirstOrDefault(s => s.PersonId == personId && s.RefPersonStatusTypeId == this.OdsReferenceData.SpecialEdStatusTypeId);
                                                if (personStatusToUpdate != null)
                                                {
                                                    personStatusToUpdate.StatusStartDate = entryDate;
                                                    personStatusToUpdate.StatusEndDate = exitDate;
                                                }
                                            }


                                            // Add IEP - Special Ed

                                            K12organizationStudentResponsibility iepK12organizationStudentResponsibility = new K12organizationStudentResponsibility()
                                            {
                                                K12organizationStudentResponsibilityId = this.SetAndGetMaxId("K12organizationStudentResponsibilities"),
                                                OrganizationPersonRoleId = specialEdOrganizationPersonRole.OrganizationPersonRoleId,
                                                RefK12responsibilityTypeId = this.OdsReferenceData.IepResponsibilityTypeId
                                            };

                                            testData.K12organizationStudentResponsibilities.Add(iepK12organizationStudentResponsibility);


                                            // PersonProgramParticipation - Special Ed

                                            PersonProgramParticipation specialEdPersonProgramParticipation = new PersonProgramParticipation()
                                            {
                                                PersonProgramParticipationId = this.SetAndGetMaxId("PersonProgramParticipations"),
                                                OrganizationPersonRoleId = specialEdOrganizationPersonRole.OrganizationPersonRoleId,
                                                RefParticipationTypeId = null,
                                                RecordStartDateTime = entryDate
                                            };

                                            if (!isParticipantNow)
                                            {
                                                var refProgramExitReason = _testDataHelper.GetRandomObject<RefProgramExitReason>(rnd, this.OdsReferenceData.RefProgramExitReasons);

                                                specialEdPersonProgramParticipation.RefProgramExitReasonId = refProgramExitReason.RefProgramExitReasonId;
                                            }

                                            testData.PersonProgramParticipations.Add(specialEdPersonProgramParticipation);


                                            // ProgramParticipationSpecialEducations

                                            int yearOfParticipation = SchoolYear;
                                            int yearOffset = 0;

                                            if (specialEdOrganizationPersonRole.EntryDate.HasValue)
                                            {
                                                yearOfParticipation = specialEdOrganizationPersonRole.EntryDate.Value.Year;
                                                yearOffset = SchoolYear - yearOfParticipation;
                                            }

                                            int personAge = 0;
                                            if (personDetail.Birthdate.HasValue)
                                            {
                                                DateTime personBirthDate = (DateTime)personDetail.Birthdate;

                                                DateTime today = DateTime.Today.AddYears(yearOffset * -1);
                                                personAge = Convert.ToInt32((today - personBirthDate).Days / 365.25);
                                            }


                                            if (personAge > 0)
                                            {
                                                int schoolAgeIDEAEnvTypeId = _testDataHelper.GetRandomObject<RefIdeaeducationalEnvironmentSchoolAge>(rnd, this.OdsReferenceData.RefIdeaeducationalEnvironmentSchoolAges).RefIdeaEducationalEnvironmentSchoolAge;

                                                int ecIDEAEnvTypeId = _testDataHelper.GetRandomObject<RefIdeaeducationalEnvironmentEc>(rnd, this.OdsReferenceData.RefIdeaeducationalEnvironmentEcs).RefIdeaeducationalEnvironmentEcid;

                                                ProgramParticipationSpecialEducation newProgramParticipationSpecialEducation = new ProgramParticipationSpecialEducation()
                                                {
                                                    ProgramParticipationSpecialEducationId = this.SetAndGetMaxId("ProgramParticipationSpecialEducations"),
                                                    PersonProgramParticipationId = specialEdPersonProgramParticipation.PersonProgramParticipationId,
                                                    RecordStartDateTime = specialEdOrganizationPersonRole.EntryDate.Value,
                                                    SpecialEducationServicesExitDate = specialEdOrganizationPersonRole.ExitDate
                                                };

                                                if (!isParticipantNow)
                                                {
                                                    newProgramParticipationSpecialEducation.SpecialEducationServicesExitDate = specialEdOrganizationPersonRole.ExitDate;
                                                }

                                                if (personAge <= 5)
                                                {
                                                    newProgramParticipationSpecialEducation.RefIdeaeducationalEnvironmentEcid = ecIDEAEnvTypeId;
                                                }
                                                else
                                                {
                                                    newProgramParticipationSpecialEducation.RefIdeaedEnvironmentSchoolAgeId = schoolAgeIDEAEnvTypeId;
                                                }

                                                var specialEducationExitReason = _testDataHelper.GetRandomObject<RefSpecialEducationExitReason>(rnd, this.OdsReferenceData.RefSpecialEducationExitReasons);

                                                if (specialEdPersonProgramParticipation.RefProgramExitReasonId != null)
                                                {
                                                    newProgramParticipationSpecialEducation.RefSpecialEducationExitReasonId = specialEducationExitReason.RefSpecialEducationExitReasonId;
                                                }

                                                testData.ProgramParticipationSpecialEducations.Add(newProgramParticipationSpecialEducation);
                                            }


                                        }

                                    }

                                    // Immigrant Title III Program Participation

                                    bool isImmigrantTitleIIIProgramParticipant = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ImmigrantTitleIIIProgramParticipationDistribution);

                                    if (immigrantTitleIIIStatus == 1 && isImmigrantTitleIIIProgramParticipant)
                                    {
                                        //   var relatedImmigrantProgram = this.AllSchoolProgramRelationships.Join(this.ImmigrantTitleIIIProgramIds, x => x.OrganizationId, id => id, (x, id) => x).FirstOrDefault(x => x.ParentOrganizationId == schoolOfEnrollment.OrganizationId);
                                        var relatedImmigrantProgram = this.AllSchoolProgramRelationships.Join(this.ImmigrantEducationProgramIds, x => x.OrganizationId, id => id, (x, id) => x).FirstOrDefault(x => x.ParentOrganizationId == schoolOfEnrollment.OrganizationId);


                                        // Not every school has this program, so check
                                        if (relatedImmigrantProgram != null)
                                        {
                                            bool isParticipantNow = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ImmigrantTitleIIIProgramParticipantNowDistribution);

                                            DateTime entryDate = _testDataHelper.GetEntryDate(rnd, baseProgramEntryDate);
                                            DateTime? exitDate = _testDataHelper.GetExitDate(rnd, entryDate, baseProgramExitDate);

                                            if (!isParticipantNow)
                                            {
                                                exitDate = null;
                                            }

                                            OrganizationPersonRole immigrantTitleIIIOrganizationPersonRole = new OrganizationPersonRole()
                                            {
                                                OrganizationPersonRoleId = this.SetAndGetMaxId("OrganizationPersonRoles"),
                                                OrganizationId = relatedImmigrantProgram.OrganizationId,
                                                PersonId = personId,
                                                RoleId = role.RoleId,
                                                EntryDate = entryDate,
                                                ExitDate = exitDate
                                            };

                                            testData.OrganizationPersonRoles.Add(immigrantTitleIIIOrganizationPersonRole);

                                            // PersonStatus

                                            bool useDatesInPersonStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.UseDatesInPersonStatusDistribution);
                                            if (useDatesInPersonStatus)
                                            {

                                                PersonStatus personStatusToUpdate = testData.PersonStatuses.FirstOrDefault(s => s.PersonId == personId && s.RefPersonStatusTypeId == this.OdsReferenceData.ImmigrantTitleIIIStatusTypeId);
                                                if (personStatusToUpdate != null)
                                                {
                                                    personStatusToUpdate.StatusStartDate = entryDate;
                                                    personStatusToUpdate.StatusEndDate = exitDate;
                                                }
                                            }


                                            // PersonProgramParticipation - immigrantTitleIII

                                            int migrantParticipationTypeId = this.OdsReferenceData.RefParticipationTypes.Single(t => t.Code == "TitleIIIImmigrantParticipation").RefParticipationTypeId;


                                            PersonProgramParticipation immigrantTitleIIIPersonProgramParticipation = new PersonProgramParticipation()
                                            {
                                                PersonProgramParticipationId = this.SetAndGetMaxId("PersonProgramParticipations"),
                                                OrganizationPersonRoleId = immigrantTitleIIIOrganizationPersonRole.OrganizationPersonRoleId,
                                                RefParticipationTypeId = migrantParticipationTypeId,
                                                RecordStartDateTime = entryDate
                                            };

                                            if (!isParticipantNow)
                                            {
                                                var refProgramExitReason = _testDataHelper.GetRandomObject<RefProgramExitReason>(rnd, this.OdsReferenceData.RefProgramExitReasons);

                                                immigrantTitleIIIPersonProgramParticipation.RefProgramExitReasonId = refProgramExitReason.RefProgramExitReasonId;
                                            }

                                            testData.PersonProgramParticipations.Add(immigrantTitleIIIPersonProgramParticipation);


                                        }

                                    }

                                    bool isMigrantProgramParticipant = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.MigrantProgramParticipationDistribution);

                                    if (migrantStatus == 1 && isMigrantProgramParticipant)
                                    {
                                        var relatedMigrantProgram = this.AllSchoolProgramRelationships.Join(this.MigrantEducationProgramIds, x => x.OrganizationId, id => id, (x, id) => x).FirstOrDefault(x => x.ParentOrganizationId == schoolOfEnrollment.OrganizationId);

                                        // Not every school has this program, so check
                                        if (relatedMigrantProgram != null)
                                        {
                                            bool isParticipantNow = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.ImmigrantTitleIIIProgramParticipantNowDistribution);

                                            DateTime entryDate = _testDataHelper.GetEntryDate(rnd, baseProgramEntryDate);
                                            DateTime? exitDate = _testDataHelper.GetExitDate(rnd, entryDate, baseProgramExitDate);

                                            if (!isParticipantNow)
                                            {
                                                exitDate = null;
                                            }

                                            OrganizationPersonRole migrantOrganizationPersonRole = new OrganizationPersonRole()
                                            {
                                                OrganizationPersonRoleId = this.SetAndGetMaxId("OrganizationPersonRoles"),
                                                OrganizationId = relatedMigrantProgram.OrganizationId,
                                                PersonId = personId,
                                                RoleId = role.RoleId,
                                                EntryDate = entryDate,
                                                ExitDate = exitDate
                                            };

                                            testData.OrganizationPersonRoles.Add(migrantOrganizationPersonRole);

                                            // PersonStatus

                                            bool useDatesInPersonStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.UseDatesInPersonStatusDistribution);
                                            if (useDatesInPersonStatus)
                                            {

                                                PersonStatus personStatusToUpdate = testData.PersonStatuses.FirstOrDefault(s => s.PersonId == personId && s.RefPersonStatusTypeId == this.OdsReferenceData.MigrantStatusTypeId);
                                                if (personStatusToUpdate != null)
                                                {
                                                    personStatusToUpdate.StatusStartDate = entryDate;
                                                    personStatusToUpdate.StatusEndDate = exitDate;
                                                }
                                            }


                                            // PersonProgramParticipation - migrant

                                            int migrantParticipationTypeId = this.OdsReferenceData.RefParticipationTypes.Single(t => t.Code == "MEPParticipation").RefParticipationTypeId;


                                            PersonProgramParticipation migrantPersonProgramParticipation = new PersonProgramParticipation()
                                            {
                                                PersonProgramParticipationId = this.SetAndGetMaxId("PersonProgramParticipations"),
                                                OrganizationPersonRoleId = migrantOrganizationPersonRole.OrganizationPersonRoleId,
                                                RefParticipationTypeId = migrantParticipationTypeId,
                                                RecordStartDateTime = entryDate
                                            };

                                            if (!isParticipantNow)
                                            {
                                                var refProgramExitReason = _testDataHelper.GetRandomObject<RefProgramExitReason>(rnd, this.OdsReferenceData.RefProgramExitReasons);

                                                migrantPersonProgramParticipation.RefProgramExitReasonId = refProgramExitReason.RefProgramExitReasonId;
                                            }

                                            testData.PersonProgramParticipations.Add(migrantPersonProgramParticipation);

                                            // ProgramParticipationMigrant

                                            bool continuationValue = _testDataHelper.GetRandomObject<bool>(rnd, new List<bool>() { true, false });
                                            bool prioritizedForServicesValue = _testDataHelper.GetRandomObject<bool>(rnd, new List<bool>() { true, false });
                                            DateTime mepEligibilityExpirationDate = _testDataHelper.GetRandomDateInRange(rnd, entryDate, DateTime.Now);

                                            RefMepServiceType refMepServiceType = _testDataHelper.GetRandomObject<RefMepServiceType>(rnd, this.OdsReferenceData.RefMepServiceTypes);


                                            ProgramParticipationMigrant programParticipationMigrant = new ProgramParticipationMigrant()
                                            {
                                                ProgramParticipationMigrantId = this.SetAndGetMaxId("ProgramParticipationMigrants"),
                                                PersonProgramParticipationId = migrantPersonProgramParticipation.PersonProgramParticipationId,
                                                ContinuationOfServicesStatus = continuationValue,
                                                PrioritizedForServices = prioritizedForServicesValue,
                                                RefMepServiceTypeId = refMepServiceType.RefMepServiceTypeId,
                                                MigrantStudentQualifyingArrivalDate = entryDate,
                                                MepEligibilityExpirationDate = mepEligibilityExpirationDate
                                            };

                                            testData.ProgramParticipationMigrants.Add(programParticipationMigrant);

                                        }
                                    }
                                    // Section 504 Program Participation

                                    bool isSection504ProgramParticipant = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SpecialEdProgramParticipationDistribution);

                                    if (isSection504ProgramParticipant)
                                    {
                                        var relatedSection504Program = this.AllSchoolProgramRelationships.Join(this.Section504ProgramIds, x => x.OrganizationId, id => id, (x, id) => x).FirstOrDefault(x => x.ParentOrganizationId == schoolOfEnrollment.OrganizationId);

                                        // Not every school has this program, so check
                                        if (relatedSection504Program != null)
                                        {

                                            bool isParticipantNow = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.Section504ProgramParticipantNowDistribution);

                                            DateTime entryDate = _testDataHelper.GetEntryDate(rnd, baseProgramEntryDate);
                                            DateTime? exitDate = _testDataHelper.GetExitDate(rnd, entryDate, baseProgramExitDate);

                                            if (!isParticipantNow)
                                            {
                                                exitDate = null;
                                            }

                                            OrganizationPersonRole section504OrganizationPersonRole = new OrganizationPersonRole()
                                            {
                                                OrganizationPersonRoleId = this.SetAndGetMaxId("OrganizationPersonRoles"),
                                                OrganizationId = relatedSection504Program.OrganizationId,
                                                PersonId = personId,
                                                RoleId = role.RoleId,
                                                EntryDate = entryDate,
                                                ExitDate = exitDate
                                            };

                                            testData.OrganizationPersonRoles.Add(section504OrganizationPersonRole);


                                            // PersonProgramParticipation - Section504

                                            PersonProgramParticipation section504PersonProgramParticipation = new PersonProgramParticipation()
                                            {
                                                PersonProgramParticipationId = this.SetAndGetMaxId("PersonProgramParticipations"),
                                                OrganizationPersonRoleId = section504OrganizationPersonRole.OrganizationPersonRoleId,
                                                RefParticipationTypeId = null,
                                                RecordStartDateTime = entryDate
                                            };

                                            if (!isParticipantNow)
                                            {
                                                var refProgramExitReason = _testDataHelper.GetRandomObject<RefProgramExitReason>(rnd, this.OdsReferenceData.RefProgramExitReasons);

                                                section504PersonProgramParticipation.RefProgramExitReasonId = refProgramExitReason.RefProgramExitReasonId;
                                            }

                                            testData.PersonProgramParticipations.Add(section504PersonProgramParticipation);

                                        }

                                    }

                                    // Foster Care Program Participation

                                    bool isFosterCareProgramParticipant = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.FosterCareProgramParticipationDistribution);

                                    if (isFosterCareProgramParticipant)
                                    {
                                        var relatedFosterCareProgram = this.AllSchoolProgramRelationships.Join(this.FosterCareProgramIds, x => x.OrganizationId, id => id, (x, id) => x).FirstOrDefault(x => x.ParentOrganizationId == schoolOfEnrollment.OrganizationId);

                                        // Not every school has this program, so check
                                        if (relatedFosterCareProgram != null)
                                        {
                                            bool isParticipantNow = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.FosterCareProgramParticipantNowDistribution);

                                            DateTime entryDate = _testDataHelper.GetEntryDate(rnd, baseProgramEntryDate);
                                            DateTime? exitDate = _testDataHelper.GetExitDate(rnd, entryDate, baseProgramExitDate);

                                            if (!isParticipantNow)
                                            {
                                                exitDate = null;
                                            }

                                            OrganizationPersonRole fosterCareOrganizationPersonRole = new OrganizationPersonRole()
                                            {
                                                OrganizationPersonRoleId = this.SetAndGetMaxId("OrganizationPersonRoles"),
                                                OrganizationId = relatedFosterCareProgram.OrganizationId,
                                                PersonId = personId,
                                                RoleId = role.RoleId,
                                                EntryDate = entryDate,
                                                ExitDate = exitDate
                                            };

                                            testData.OrganizationPersonRoles.Add(fosterCareOrganizationPersonRole);


                                            // PersonProgramParticipation - FosterCare

                                            PersonProgramParticipation fosterCarePersonProgramParticipation = new PersonProgramParticipation()
                                            {
                                                PersonProgramParticipationId = this.SetAndGetMaxId("PersonProgramParticipations"),
                                                OrganizationPersonRoleId = fosterCareOrganizationPersonRole.OrganizationPersonRoleId,
                                                RefParticipationTypeId = null,
                                                RecordStartDateTime = entryDate
                                            };

                                            if (!isParticipantNow)
                                            {
                                                var refProgramExitReason = _testDataHelper.GetRandomObject<RefProgramExitReason>(rnd, this.OdsReferenceData.RefProgramExitReasons);

                                                fosterCarePersonProgramParticipation.RefProgramExitReasonId = refProgramExitReason.RefProgramExitReasonId;
                                            }

                                            testData.PersonProgramParticipations.Add(fosterCarePersonProgramParticipation);


                                        }

                                    }

                                    // CTE Program Participation

                                    bool isCteProgramParticipant = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.CteProgramParticipationDistribution);

                                    if (isCteProgramParticipant)
                                    {
                                        var relatedCteProgram = this.AllSchoolProgramRelationships.Join(this.CTEProgramIds, x => x.OrganizationId, id => id, (x, id) => x).FirstOrDefault(x => x.ParentOrganizationId == schoolOfEnrollment.OrganizationId);

                                        // Not every school has this program, so check
                                        if (relatedCteProgram != null)
                                        {
                                            bool isParticipantNow = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.CteProgramParticipantNowDistribution);

                                            DateTime entryDate = _testDataHelper.GetEntryDate(rnd, baseProgramEntryDate);
                                            DateTime? exitDate = _testDataHelper.GetExitDate(rnd, entryDate, baseProgramExitDate);

                                            if (!isParticipantNow)
                                            {
                                                exitDate = null;
                                            }

                                            OrganizationPersonRole cteOrganizationPersonRole = new OrganizationPersonRole()
                                            {
                                                OrganizationPersonRoleId = this.SetAndGetMaxId("OrganizationPersonRoles"),
                                                OrganizationId = relatedCteProgram.OrganizationId,
                                                PersonId = personId,
                                                RoleId = role.RoleId,
                                                EntryDate = entryDate,
                                                ExitDate = exitDate
                                            };

                                            testData.OrganizationPersonRoles.Add(cteOrganizationPersonRole);


                                            // Add IEP - CTE

                                            K12organizationStudentResponsibility iepK12organizationStudentResponsibility = new K12organizationStudentResponsibility()
                                            {
                                                K12organizationStudentResponsibilityId = this.SetAndGetMaxId("K12organizationStudentResponsibilities"),
                                                OrganizationPersonRoleId = cteOrganizationPersonRole.OrganizationPersonRoleId,
                                                RefK12responsibilityTypeId = this.OdsReferenceData.IepResponsibilityTypeId
                                            };

                                            testData.K12organizationStudentResponsibilities.Add(iepK12organizationStudentResponsibility);


                                            // PersonProgramParticipation - CTE

                                            PersonProgramParticipation ctePersonProgramParticipation = new PersonProgramParticipation()
                                            {
                                                PersonProgramParticipationId = this.SetAndGetMaxId("PersonProgramParticipations"),
                                                OrganizationPersonRoleId = cteOrganizationPersonRole.OrganizationPersonRoleId,
                                                RefParticipationTypeId = null,
                                                RecordStartDateTime = entryDate
                                            };

                                            if (!isParticipantNow)
                                            {
                                                var refProgramExitReason = _testDataHelper.GetRandomObject<RefProgramExitReason>(rnd, this.OdsReferenceData.RefProgramExitReasons);

                                                ctePersonProgramParticipation.RefProgramExitReasonId = refProgramExitReason.RefProgramExitReasonId;
                                            }

                                            testData.PersonProgramParticipations.Add(ctePersonProgramParticipation);


                                            // ProgramParticipationCTE

                                            bool isDisplacedHomeMaker = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.DisplacedHomemakerDistribution);
                                            bool isSingle = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.SingleParentOrPregnantWomanDistribution);
                                            bool isNonTraditionalCompletion = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.CteNonTraditionalCompletionDistribution);
                                            bool cteConcentrator = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.CteConcentratorDistribution);
                                            bool cteCompleter = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.CteCompleterDistribution);

                                            var refCteNonTraditionalGenderStatus = _testDataHelper.GetRandomObject<RefCteNonTraditionalGenderStatus>(rnd, this.OdsReferenceData.RefCteNonTraditionalGenderStatuses);

                                            ProgramParticipationCte programParticipationCte = new ProgramParticipationCte()
                                            {
                                                ProgramParticipationCteId = this.SetAndGetMaxId("ProgramParticipationCtes"),
                                                PersonProgramParticipationId = ctePersonProgramParticipation.PersonProgramParticipationId,
                                                RecordStartDateTime = cteOrganizationPersonRole.EntryDate.Value,
                                                CteParticipant = isParticipantNow,
                                                CteConcentrator = cteConcentrator,
                                                CteCompleter = cteCompleter,
                                                DisplacedHomemakerIndicator = isDisplacedHomeMaker,
                                                SingleParentOrSinglePregnantWoman = isSingle,
                                                CteNonTraditionalCompletion = isNonTraditionalCompletion,
                                                RefNonTraditionalGenderStatusId = refCteNonTraditionalGenderStatus.RefCtenonTraditionalGenderStatusId
                                            };

                                            testData.ProgramParticipationCtes.Add(programParticipationCte);

                                            bool isEmployed = _testDataHelper.GetRandomObject<bool>(rnd, new List<bool>() { true, false });

                                            if (isEmployed)
                                            {
                                                RefEmployedWhileEnrolled employedWhileEnrolled = _testDataHelper.GetRandomObject<RefEmployedWhileEnrolled>(rnd, this.OdsReferenceData.RefEmployedWhileEnrolleds);

                                                RefEmployedAfterExit employedAfterExit = _testDataHelper.GetRandomObject<RefEmployedAfterExit>(rnd, this.OdsReferenceData.RefEmployedAfterExits);

                                                var employedInMultipleJobsCount = _testDataHelper.GetRandomDecimalInRange(rnd, 0, 6);
                                                var militaryEnlistmentAfterExit = _testDataHelper.GetRandomObject<bool>(rnd, new List<bool>() { true, false });

                                                WorkforceEmploymentQuarterlyData newWfEmpdata = new WorkforceEmploymentQuarterlyData()
                                                {
                                                    OrganizationPersonRoleId = cteOrganizationPersonRole.OrganizationPersonRoleId,
                                                    RefEmployedWhileEnrolledId = employedWhileEnrolled.RefEmployedWhileEnrolledId,
                                                    RefEmployedAfterExitId = employedAfterExit.RefEmployedAfterExitId,
                                                    EmployedInMultipleJobsCount = employedInMultipleJobsCount,
                                                    MilitaryEnlistmentAfterExit = militaryEnlistmentAfterExit
                                                };

                                                testData.WorkforceEmploymentQuarterlyDatas.Add(newWfEmpdata);

                                                RefWfProgramParticipation refWfProgramParticipation = _testDataHelper.GetRandomObject<RefWfProgramParticipation>(rnd, this.OdsReferenceData.RefWfProgramParticipations);

                                                RefProfessionalTechnicalCredentialType refProfessionalTechnicalCredentialType = _testDataHelper.GetRandomObject<RefProfessionalTechnicalCredentialType>(rnd, this.OdsReferenceData.RefProfessionalTechnicalCredentialTypes);

                                                DateTime diplomaDate = _testDataHelper.GetRandomDate(rnd, SchoolYear, 6, 2);
                                                var diplomaOrCredentialAwardDate = diplomaDate.Month.ToString() + '/' + diplomaDate.Year.ToString();

                                                WorkforceProgramParticipation wfProgramParticipation = new WorkforceProgramParticipation()
                                                {
                                                    PersonProgramParticipationId = ctePersonProgramParticipation.PersonProgramParticipationId,
                                                    RefWfProgramParticipationId = refWfProgramParticipation.RefWfProgramParticipationId,
                                                    RefProfessionalTechnicalCredentialTypeId = refProfessionalTechnicalCredentialType.RefProfessionalTechnicalCredentialTypeId,
                                                    DiplomaOrCredentialAwardDate = diplomaOrCredentialAwardDate

                                                };

                                                testData.WorkforceProgramParticipations.Add(wfProgramParticipation);
                                            }



                                        }

                                    }

                                    // LEP Program Participation

                                    bool isLepProgramParticipant = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LepProgramParticipationDistribution);

                                    if (isLepProgramParticipant)
                                    {


                                        var relatedLepProgram = this.AllSchoolProgramRelationships.Join(this.LepProgramIds, x => x.OrganizationId, id => id, (x, id) => x).FirstOrDefault(x => x.ParentOrganizationId == schoolOfEnrollment.OrganizationId);

                                        // Not every school has this program, so check
                                        if (relatedLepProgram != null)
                                        {

                                            bool isParticipantNow = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.LepProgramParticipantNowDistribution);

                                            DateTime entryDate = _testDataHelper.GetEntryDate(rnd, baseProgramEntryDate);
                                            DateTime? exitDate = _testDataHelper.GetExitDate(rnd, entryDate, baseProgramExitDate);

                                            if (!isParticipantNow)
                                            {
                                                exitDate = null;
                                            }

                                            OrganizationPersonRole lepOrganizationPersonRole = new OrganizationPersonRole()
                                            {
                                                OrganizationPersonRoleId = this.SetAndGetMaxId("OrganizationPersonRoles"),
                                                OrganizationId = relatedLepProgram.OrganizationId,
                                                PersonId = personId,
                                                RoleId = role.RoleId,
                                                EntryDate = entryDate,
                                                ExitDate = exitDate
                                            };

                                            testData.OrganizationPersonRoles.Add(lepOrganizationPersonRole);


                                            bool useDatesInPersonStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.UseDatesInPersonStatusDistribution);
                                            if (useDatesInPersonStatus)
                                            {

                                                PersonStatus personStatusToUpdate = testData.PersonStatuses.FirstOrDefault(s => s.PersonId == personId && s.RefPersonStatusTypeId == this.OdsReferenceData.LepStatusTypeId);
                                                if (personStatusToUpdate != null)
                                                {
                                                    personStatusToUpdate.StatusStartDate = entryDate;
                                                    personStatusToUpdate.StatusEndDate = exitDate;
                                                }
                                            }


                                            // PersonProgramParticipation - LEP

                                            PersonProgramParticipation lepPersonProgramParticipation = new PersonProgramParticipation()
                                            {
                                                PersonProgramParticipationId = this.SetAndGetMaxId("PersonProgramParticipations"),
                                                OrganizationPersonRoleId = lepOrganizationPersonRole.OrganizationPersonRoleId,
                                                RefParticipationTypeId = null,
                                                RecordStartDateTime = entryDate
                                            };

                                            if (!isParticipantNow)
                                            {
                                                var refProgramExitReason = _testDataHelper.GetRandomObject<RefProgramExitReason>(rnd, this.OdsReferenceData.RefProgramExitReasons);

                                                lepPersonProgramParticipation.RefProgramExitReasonId = refProgramExitReason.RefProgramExitReasonId;
                                            }

                                            testData.PersonProgramParticipations.Add(lepPersonProgramParticipation);

                                            // ProgramParticipationTitleIiilep

                                            RefTitleIiiaccountability refTitleIiiaccountability = _testDataHelper.GetRandomObject<RefTitleIiiaccountability>(rnd, this.OdsReferenceData.RefTitleIiiaccountabilities);
                                            var refTitleIiilanguageInstructionProgramTypeCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefTitleIiilanguageInstructionProgramTypeDistribution);
                                            var refTitleIiilanguageInstructionProgramTypeId = this.OdsReferenceData.RefTitleIiilanguageInstructionProgramTypes.Single(x => x.Code == refTitleIiilanguageInstructionProgramTypeCode).RefTitleIiilanguageInstructionProgramTypeId;


                                            ProgramParticipationTitleIiilep programParticipationTitleIiilep = new ProgramParticipationTitleIiilep()
                                            {
                                                ProgramParticipationTitleIiiLepId = this.SetAndGetMaxId("ProgramParticipationTitleIiileps"),
                                                RefTitleIiiaccountabilityId = refTitleIiiaccountability.RefTitleIiiaccountabilityId,
                                                PersonProgramParticipationId = lepPersonProgramParticipation.PersonProgramParticipationId,
                                                RefTitleIiilanguageInstructionProgramTypeId = refTitleIiilanguageInstructionProgramTypeId,
                                                RecordStartDateTime = lepOrganizationPersonRole.EntryDate.Value
                                            };

                                            testData.ProgramParticipationTitleIiileps.Add(programParticipationTitleIiilep);

                                        }

                                    }

                                    // Neglected Program Participation

                                    bool isNeglectedProgramParticipant = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NeglectedProgramParticipationDistribution);

                                    if (isNeglectedProgramParticipant)
                                    {
                                        var relatedNeglectedProgram = this.AllSchoolProgramRelationships.Join(this.NeglectedProgramIds, x => x.OrganizationId, id => id, (x, id) => x).FirstOrDefault(x => x.ParentOrganizationId == schoolOfEnrollment.OrganizationId);

                                        // Not every school has this program, so check
                                        if (relatedNeglectedProgram != null)
                                        {
                                            bool isParticipantNow = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NeglectedProgramParticipantNowDistribution);

                                            DateTime entryDate = _testDataHelper.GetEntryDate(rnd, baseProgramEntryDate);
                                            DateTime? exitDate = _testDataHelper.GetExitDate(rnd, entryDate, baseProgramExitDate);

                                            if (!isParticipantNow)
                                            {
                                                exitDate = null;
                                            }

                                            OrganizationPersonRole neglectedOrganizationPersonRole = new OrganizationPersonRole()
                                            {
                                                OrganizationPersonRoleId = this.SetAndGetMaxId("OrganizationPersonRoles"),
                                                OrganizationId = relatedNeglectedProgram.OrganizationId,
                                                PersonId = personId,
                                                RoleId = role.RoleId,
                                                EntryDate = entryDate,
                                                ExitDate = exitDate
                                            };

                                            testData.OrganizationPersonRoles.Add(neglectedOrganizationPersonRole);



                                            // PersonProgramParticipation - Neglected
                                            int refParticipationTypeId = this.OdsReferenceData.RefParticipationTypes.Single(t => t.Code == "CorrectionalEducationReentryServicesParticipation").RefParticipationTypeId;

                                            PersonProgramParticipation neglectedPersonProgramParticipation = new PersonProgramParticipation()
                                            {
                                                PersonProgramParticipationId = this.SetAndGetMaxId("PersonProgramParticipations"),
                                                OrganizationPersonRoleId = neglectedOrganizationPersonRole.OrganizationPersonRoleId,
                                                RefParticipationTypeId = refParticipationTypeId,
                                                RecordStartDateTime = entryDate
                                            };

                                            if (!isParticipantNow)
                                            {
                                                var refProgramExitReason = _testDataHelper.GetRandomObject<RefProgramExitReason>(rnd, this.OdsReferenceData.RefProgramExitReasons);

                                                neglectedPersonProgramParticipation.RefProgramExitReasonId = refProgramExitReason.RefProgramExitReasonId;
                                            }

                                            testData.PersonProgramParticipations.Add(neglectedPersonProgramParticipation);

                                            // ProgramParticipationNeglected

                                            RefNeglectedProgramType refNeglectedProgramType = _testDataHelper.GetRandomObject<RefNeglectedProgramType>(rnd, this.OdsReferenceData.RefNeglectedProgramTypes);
                                            RefAcademicCareerAndTechnicalOutcomesInProgram refAcademicCareerAndTechnicalOutcomesInProgram = _testDataHelper.GetRandomObject<RefAcademicCareerAndTechnicalOutcomesInProgram>(rnd, this.OdsReferenceData.RefAcademicCareerAndTechnicalOutcomesInPrograms);
                                            RefAcademicCareerAndTechnicalOutcomesExitedProgram refAcademicCareerAndTechnicalOutcomesExitedProgram = _testDataHelper.GetRandomObject<RefAcademicCareerAndTechnicalOutcomesExitedProgram>(rnd, this.OdsReferenceData.RefAcademicCareerAndTechnicalOutcomesExitedPrograms);

                                            ProgramParticipationNeglected programParticipationNeglected = new ProgramParticipationNeglected()
                                            {
                                                ProgramParticipationNeglectedId = this.SetAndGetMaxId("ProgramParticipationNeglecteds"),
                                                PersonProgramParticipationId = neglectedPersonProgramParticipation.PersonProgramParticipationId,
                                                RefNeglectedProgramTypeId = refNeglectedProgramType.RefNeglectedProgramTypeId,
                                                AchievementIndicator = _testDataHelper.GetRandomObject<bool>(rnd, new List<bool>() { true, false }),
                                                OutcomeIndicator = _testDataHelper.GetRandomObject<bool>(rnd, new List<bool>() { true, false }),
                                                ObtainedEmployment = _testDataHelper.GetRandomObject<bool>(rnd, new List<bool>() { true, false }),
                                               
                                            };



                                            testData.ProgramParticipationNeglecteds.Add(programParticipationNeglected);


                                            string refAcademicSubjectCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAcademicSubjectDistribution);
                                            int refAcademicSubjectId = this.OdsReferenceData.RefAcademicSubjects.Single(x => x.Code == refAcademicSubjectCode).RefAcademicSubjectId;
                                            int refProgressLevelId = _testDataHelper.GetRandomObject<RefProgressLevel>(rnd, this.OdsReferenceData.RefProgressLevels).RefProgressLevelId;

                                            ProgramParticipationNeglectedProgressLevel programParticipationNeglectedProgressLevel = new ProgramParticipationNeglectedProgressLevel
                                            {
                                                ProgramParticipationNeglectedProgressLevelId = this.SetAndGetMaxId("ProgramParticipationNeglectedProgressLevels"),
                                                PersonProgramParticipationId = neglectedPersonProgramParticipation.PersonProgramParticipationId,
                                                RefAcademicSubjectId = refAcademicSubjectId,
                                                RefProgressLevelId = refProgressLevelId
                                            };

                                            testData.ProgramParticipationNeglectedProgressLevels.Add(programParticipationNeglectedProgressLevel);



                                        }

                                    }

                                    // Homeless Services Program Participation

                                    bool isHomelessServicedProgramParticipant = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HomelessServicedProgramParticipationDistribution);

                                    if (isHomelessServicedProgramParticipant)
                                    {
                                        var relatedHomelessProgram = this.AllSchoolProgramRelationships.Join(this.HomelessProgramIds, x => x.OrganizationId, id => id, (x, id) => x).FirstOrDefault(x => x.ParentOrganizationId == schoolOfEnrollment.OrganizationId);

                                        // Not every school has this program, so check
                                        if (relatedHomelessProgram != null)
                                        {
                                            bool isParticipantNow = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HomelessProgramParticipantNowDistribution);

                                            DateTime entryDate = _testDataHelper.GetEntryDate(rnd, baseProgramEntryDate);
                                            DateTime? exitDate = _testDataHelper.GetExitDate(rnd, entryDate, baseProgramExitDate);

                                            if (!isParticipantNow)
                                            {
                                                exitDate = null;
                                            }

                                            OrganizationPersonRole homelessOrganizationPersonRole = new OrganizationPersonRole()
                                            {
                                                OrganizationPersonRoleId = this.SetAndGetMaxId("OrganizationPersonRoles"),
                                                OrganizationId = relatedHomelessProgram.OrganizationId,
                                                PersonId = personId,
                                                RoleId = role.RoleId,
                                                EntryDate = entryDate,
                                                ExitDate = exitDate
                                            };

                                            testData.OrganizationPersonRoles.Add(homelessOrganizationPersonRole);



                                            // PersonProgramParticipation - Homeless
                                            int refParticipationTypeId = this.OdsReferenceData.RefParticipationTypes.Single(t => t.Code == "HomelessServiced").RefParticipationTypeId;

                                            PersonProgramParticipation homelessPersonProgramParticipation = new PersonProgramParticipation()
                                            {
                                                PersonProgramParticipationId = this.SetAndGetMaxId("PersonProgramParticipations"),
                                                OrganizationPersonRoleId = homelessOrganizationPersonRole.OrganizationPersonRoleId,
                                                RefParticipationTypeId = refParticipationTypeId,
                                                RecordStartDateTime = entryDate
                                            };

                                            if (!isParticipantNow)
                                            {
                                                var refProgramExitReason = _testDataHelper.GetRandomObject<RefProgramExitReason>(rnd, this.OdsReferenceData.RefProgramExitReasons);

                                                homelessPersonProgramParticipation.RefProgramExitReasonId = refProgramExitReason.RefProgramExitReasonId;
                                            }

                                            testData.PersonProgramParticipations.Add(homelessPersonProgramParticipation);

                                            


                                        }

                                    }

                                }


                            }
                        }


                    }


                }

            }

            //if (role.Name == "K12 Student")
            //{
            //    Console.WriteLine("Duration = " + DateTime.UtcNow.Subtract(startTime).ToString());
            //}

            return testData;

        }

        private IdsTestDataObject CreateDisciplines(Random rnd, IdsTestDataObject testData, OrganizationPersonRole enrollmentOrganizationPersonRole, int specialEdStatus)
        {

            // Discipline ----
            //////////////////////////////////////


            int disciplineCount = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.NumberOfDisciplinesDistribution);

            for (int disciplineNumber = 0; disciplineNumber < disciplineCount; disciplineNumber++)
            {
                // Note: Using fully random (non-weighted) properites for disciplines (might consider using TestDataProfile in future)

                var refDisciplinaryActionTakenId = _testDataHelper.GetRandomObject<RefDisciplinaryActionTaken>(rnd, this.OdsReferenceData.RefDisciplinaryActionTakens).RefDisciplinaryActionTakenId;
                var refDisciplineReasonId = _testDataHelper.GetRandomObject<RefDisciplineReason>(rnd, this.OdsReferenceData.RefDisciplineReasons).RefDisciplineReasonId;
                var refDisciplineLengthDifferenceReasonId = _testDataHelper.GetRandomObject<RefDisciplineLengthDifferenceReason>(rnd, this.OdsReferenceData.RefDisciplineLengthDifferenceReasons).RefDisciplineLengthDifferenceReasonId;
                int? refIdeainterimRemovalId = _testDataHelper.GetRandomObject<RefIdeainterimRemoval>(rnd, this.OdsReferenceData.RefIdeainterimRemovals).RefIdeainterimRemovalId;
                int? refIdeainterimRemovalReasonId = _testDataHelper.GetRandomObject<RefIdeainterimRemovalReason>(rnd, this.OdsReferenceData.RefIdeainterimRemovalReasons).RefIdeainterimRemovalReasonId;

                if (specialEdStatus != 1)
                {
                    refIdeainterimRemovalId = null;
                    refIdeainterimRemovalReasonId = null;
                }

                var iepPlacementMeetingIndicator = _testDataHelper.GetRandomObject<bool>(rnd, new List<bool>() { true, false });
                var educationalServicesAfterRemoval = _testDataHelper.GetRandomObject<bool>(rnd, new List<bool>() { true, false });
                int? refDisciplineMethodFirearmsId = _testDataHelper.GetRandomObject<RefDisciplineMethodFirearms>(rnd, this.OdsReferenceData.RefDisciplineMethodFirearms).RefDisciplineMethodFirearmsId;
                int? refIdeadisciplineMethodFirearmId = _testDataHelper.GetRandomObject<RefIdeadisciplineMethodFirearm>(rnd, this.OdsReferenceData.RefIdeadisciplineMethodFirearms).RefIdeadisciplineMethodFirearmId;


                if (refDisciplineReasonId != 3)
                {
                    // Only set for WeaponsPossession
                    refDisciplineMethodFirearmsId = null;

                    if (specialEdStatus != 1)
                    {
                        refIdeadisciplineMethodFirearmId = null;
                    }
                }

                decimal disciplineDuration = (decimal)(rnd.Next(150) * 0.1);

                var numberOfYears = SchoolYear - _testDataProfile.OldestStartingYear;
                //var organizationStartDateTime = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(1920, 1, 1), DateTime.Now.AddYears(-5));

                for (int i = 0; i < numberOfYears; i++)
                {
                    
                    var disciplinaryActionStartDate = _testDataHelper.GetRandomDateInRange(rnd, new DateTime(SchoolYear - i - 1, 7, 1), new DateTime(SchoolYear - i, 6, 30));
                    // GetRandomDateAfter(rnd, (DateTime)enrollmentOrganizationPersonRole.EntryDate, 180, enrollmentOrganizationPersonRole.ExitDate);
                    var disciplinaryActionEndDate = disciplinaryActionStartDate.AddDays((double)disciplineDuration);



                    K12studentDiscipline k12StudentDiscipline = new K12studentDiscipline()
                    {
                        K12studentDisciplineId = this.SetAndGetMaxId("K12studentDisciplines"),
                        OrganizationPersonRoleId = enrollmentOrganizationPersonRole.OrganizationPersonRoleId,
                        RefDisciplinaryActionTakenId = refDisciplinaryActionTakenId,
                        DurationOfDisciplinaryAction = disciplineDuration,
                        DisciplinaryActionStartDate = disciplinaryActionStartDate,
                        DisciplinaryActionEndDate = disciplinaryActionEndDate,
                        RefDisciplineReasonId = refDisciplineReasonId,
                        RefDisciplineLengthDifferenceReasonId = refDisciplineLengthDifferenceReasonId,
                        RefIdeaInterimRemovalId = refIdeainterimRemovalId,
                        RefIdeaInterimRemovalReasonId = refIdeainterimRemovalReasonId,
                        IepplacementMeetingIndicator = iepPlacementMeetingIndicator,
                        EducationalServicesAfterRemoval = educationalServicesAfterRemoval,
                        RefDisciplineMethodFirearmsId = refDisciplineMethodFirearmsId,
                        RefIdeadisciplineMethodFirearmId = refIdeadisciplineMethodFirearmId
                    };

                    testData.K12studentDisciplines.Add(k12StudentDiscipline);



                    // Incident

                    var incidentDate = _testDataHelper.GetRandomDateInRange(rnd, (DateTime)enrollmentOrganizationPersonRole.EntryDate, (DateTime)k12StudentDiscipline.DisciplinaryActionStartDate);
                    var refIncidentBehaviorId = _testDataHelper.GetRandomObject<RefIncidentBehavior>(rnd, this.OdsReferenceData.RefIncidentBehaviors).RefIncidentBehaviorId;
                    int? refFirearmTypeId = null;

                    if (refDisciplineReasonId == 3)
                    {
                        // WeaponsPossession

                        refIncidentBehaviorId = this.OdsReferenceData.RefIncidentBehaviors.Single(x => x.Code == "04705").RefIncidentBehaviorId;
                        refFirearmTypeId = _testDataHelper.GetRandomObject<RefFirearmType>(rnd, this.OdsReferenceData.RefFirearmTypes).RefFirearmTypeId;
                    }

                    Incident incident = new Incident()
                    {
                        IncidentId = this.SetAndGetMaxId("Incidents"),
                        OrganizationPersonRoleId = enrollmentOrganizationPersonRole.OrganizationPersonRoleId,
                        IncidentDate = incidentDate,
                        RefIncidentBehaviorId = refIncidentBehaviorId,
                        RefFirearmTypeId = refFirearmTypeId
                    };

                    testData.Incidents.Add(incident);

                }
            }

            return testData;

        }

        private IdsTestDataObject CreateStudentEnrollmentRelatedData(Random rnd, IdsTestDataObject testData, OrganizationPersonRole enrollmentOrganizationPersonRole, bool isSchoolEnrollment, int? leaOfEnrollmentId)
        {

            // K12studentEnrollment

            int? entryRefGradeLevelId = null;
            int? exitRefGradeLevelId = null;

            if (isSchoolEnrollment)
            {
                var k12School = this.AllK12Schools.Single(x => x.OrganizationId == enrollmentOrganizationPersonRole.OrganizationId);

                //var entryGrade = this.AllK12schoolGradeOffered.Join(this.OdsReferenceData.EntryGradeLevelIds, x => x.RefGradeLevelId, id => id, (x, id) => x).Single(x => x.K12schoolId == k12School.K12schoolId);
                //var exitGrade = this.AllK12schoolGradeOffered.Join(this.OdsReferenceData.ExitGradeLevelIds, x => x.RefGradeLevelId, id => id, (x, id) => x).Single(x => x.K12schoolId == k12School.K12schoolId);
                var allGrades = this.AllK12schoolGradeOffered.Join(this.OdsReferenceData.EntryGradeLevelIds, x => x.RefGradeLevelId, id => id, (x, id) => x).Where(x => x.K12schoolId == k12School.K12schoolId).ToList();

                var entryGrade = _testDataHelper.GetRandomObject<K12schoolGradeOffered>(rnd, allGrades);
                var exitGrade = _testDataHelper.GetRandomObject<K12schoolGradeOffered>(rnd, allGrades);

                // Should be using RefGradeLevel.SortOrder, but using Id should be roughly equivalent
                while (exitGrade.RefGradeLevelId < entryGrade.RefGradeLevelId)
                {
                    exitGrade = _testDataHelper.GetRandomObject<K12schoolGradeOffered>(rnd, allGrades);
                }


                entryRefGradeLevelId = entryGrade.RefGradeLevelId;
                exitRefGradeLevelId = exitGrade.RefGradeLevelId;
            }

            string exitType = _testDataHelper.GetWeightedSelection(rnd, this._testDataProfile.RefExitOrWithdrawalTypeDistribution);

            var refFoodServiceEligibilityId = _testDataHelper.GetRandomObject<RefFoodServiceEligibility>(rnd, this.OdsReferenceData.RefFoodServiceEligibilities).RefFoodServiceEligibilityId;
            var RefExitOrWithdrawalTypeId = this.OdsReferenceData.RefExitOrWithdrawalTypes.Find(s => s.Code == exitType).RefExitOrWithdrawalTypeId;

            var nslpDirectCertificationIndicator = _testDataHelper.GetRandomObject<bool>(rnd, new List<bool>() { true, false });

            K12studentEnrollment k12studentEnrollment = new K12studentEnrollment()
            {
                K12studentEnrollmentId = this.SetAndGetMaxId("K12studentEnrollments"),
                OrganizationPersonRoleId = enrollmentOrganizationPersonRole.OrganizationPersonRoleId,
                RefEntryGradeLevelId = entryRefGradeLevelId,
                RefExitGradeLevel = exitRefGradeLevelId,
                RefFoodServiceEligibilityId = refFoodServiceEligibilityId,
                RecordStartDateTime = enrollmentOrganizationPersonRole.EntryDate.Value,
                NslpdirectCertificationIndicator = nslpDirectCertificationIndicator,
                RefExitOrWithdrawalTypeId = RefExitOrWithdrawalTypeId
            };

            testData.K12studentEnrollments.Add(k12studentEnrollment);


            if (isSchoolEnrollment)
            {

                // K12StudentCohort

                string cohortYear = _testDataHelper.GetEntryDate(rnd, (DateTime)enrollmentOrganizationPersonRole.EntryDate).Year.ToString();
                DateTime graduationStartDate = new DateTime(int.Parse(cohortYear), 1, 1).AddYears(4);
                DateTime graduationEndDate = new DateTime(int.Parse(cohortYear), 1, 1).AddYears(6);
                string cohortGraduationYear = _testDataHelper.GetRandomDateInRange(rnd, graduationStartDate, graduationEndDate).Year.ToString();

                string[] CohortDescriptions = { "Regular Diploma", "Alternate Diploma", "Alternate Diploma - Removed" };
                string CohortDescription = _testDataHelper.GetRandomString(rnd, CohortDescriptions.ToList());

                K12studentCohort k12studentCohort = new K12studentCohort()
                {
                    OrganizationPersonRoleId = enrollmentOrganizationPersonRole.OrganizationPersonRoleId,
                    CohortYear = cohortYear,
                    CohortGraduationYear = cohortGraduationYear,
                    CohortDescription = CohortDescription
                };

                testData.K12studentCohorts.Add(k12studentCohort);


                // K12StudentAcademicRecord

                var refHighSchoolDiplomaTypeId = _testDataHelper.GetRandomObject<RefHighSchoolDiplomaType>(rnd, this.OdsReferenceData.RefHighSchoolDiplomaTypes).RefHighSchoolDiplomaTypeId;
                var refPsEnrollmentActionId = _testDataHelper.GetRandomObject<RefPsEnrollmentAction>(rnd, this.OdsReferenceData.RefPsEnrollmentActions).RefPsEnrollmentActionId;
              


                K12studentAcademicRecord k12studentAcademicRecord = new K12studentAcademicRecord()
                {
                    OrganizationPersonRoleId = enrollmentOrganizationPersonRole.OrganizationPersonRoleId,
                    RefHighSchoolDiplomaTypeId = refHighSchoolDiplomaTypeId,
                    DiplomaOrCredentialAwardDate = new DateTime(int.Parse(cohortYear), 6, 15),
                    RefPsEnrollmentActionId = refPsEnrollmentActionId
                };

                testData.K12studentAcademicRecords.Add(k12studentAcademicRecord);



                // RoleAttendance

                decimal totalSchoolDays = 200m;
                int daysAttended = _testDataHelper.GetRandomIntInRange(rnd, 1, 180);
                Decimal daysAbsent = Decimal.Subtract(totalSchoolDays, daysAttended);
                Decimal attendanceRate = Decimal.Divide(daysAttended, totalSchoolDays);

                RoleAttendance roleAttendance = new RoleAttendance()
                {
                    RoleAttendanceId = this.SetAndGetMaxId("RoleAttendances"),
                    OrganizationPersonRoleId = enrollmentOrganizationPersonRole.OrganizationPersonRoleId,
                    NumberOfDaysInAttendance = Convert.ToDecimal(daysAttended),
                    NumberOfDaysAbsent = Convert.ToDecimal(daysAbsent),
                    AttendanceRate = attendanceRate
                };

                testData.RoleAttendances.Add(roleAttendance);

                // PersonProgramParticipation - GED Preparation Program

                bool isGEDParticipant = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.GEDPreparationProgramParticipationDistribution);

                if (isGEDParticipant)
                {

                    int? gedParticipationTypeId = null;

                    gedParticipationTypeId = this.OdsReferenceData.GedParticipationTypeId;

                    int refProgramExitReasonId = _testDataHelper.GetRandomObject<RefProgramExitReason>(rnd, this.OdsReferenceData.RefProgramExitReasons).RefProgramExitReasonId;

                    PersonProgramParticipation personProgramParticipation = new PersonProgramParticipation()
                    {
                        PersonProgramParticipationId = this.SetAndGetMaxId("PersonProgramParticipations"),
                        OrganizationPersonRoleId = enrollmentOrganizationPersonRole.OrganizationPersonRoleId,
                        RefParticipationTypeId = gedParticipationTypeId,
                        RecordStartDateTime = enrollmentOrganizationPersonRole.EntryDate,
                        RecordEndDateTime = enrollmentOrganizationPersonRole.ExitDate,
                        RefProgramExitReasonId = refProgramExitReasonId
                    };

                    testData.PersonProgramParticipations.Add(personProgramParticipation);

                }

                // AssessmentRegistration

                var assessmentAdministrationIds = this.AllAssessmentAdministrationOrganizations.Where(x => x.OrganizationId == enrollmentOrganizationPersonRole.OrganizationId).Select(x => x.AssessmentAdministrationId);

                var assessmentAdministrationsForDates = this.AllAssessmentAdministrations.Where(x => x.StartDate >= enrollmentOrganizationPersonRole.EntryDate && (x.FinishDate <= enrollmentOrganizationPersonRole.ExitDate || !enrollmentOrganizationPersonRole.ExitDate.HasValue));

                if (assessmentAdministrationsForDates.Any())
                {
                    var assessmentAdministrationsForOrganization = assessmentAdministrationsForDates.Join(assessmentAdministrationIds, x => x.AssessmentAdministrationId, id => id, (x, id) => x).ToList();

                    int numberOfAssessmentAdministrations = _testDataHelper.GetRandomIntInRange(rnd, 0, 6);

                    if (numberOfAssessmentAdministrations > 0)
                    {
                        var assessmentAdministrations = _testDataHelper.GetRandomObjects<AssessmentAdministration>(rnd, assessmentAdministrationsForOrganization, numberOfAssessmentAdministrations);

                        foreach (var assessmentAdministration in assessmentAdministrations)
                        {

                            int? refAssessmentReasonNotCompletingId = _testDataHelper.GetRandomObject<RefAssessmentReasonNotCompleting>(rnd, this.OdsReferenceData.RefAssessmentReasonNotCompletings).RefAssessmentReasonNotCompletingId;
                            var refAssessmentParticipationIndicatorCode = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.RefAssessmentParticipationIndicatorDistribution);
                            var refAssessmentParticipationIndicatorId = this.OdsReferenceData.RefAssessmentParticipationIndicators.Single(x => x.Code == refAssessmentParticipationIndicatorCode).RefAssessmentParticipationIndicatorId;

                            if (refAssessmentParticipationIndicatorCode == "Participated")
                            {
                                refAssessmentReasonNotCompletingId = null;
                            }

                            bool fullYearStatus = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.FullAcademicYearPersonStatusDistribution);

                            var assessmentForm = this.AllAssessmentForms.Single(x => x.AssessmentId == assessmentAdministration.AssessmentId);

                            var assessmentRegistration = new AssessmentRegistration()
                            {
                                AssessmentRegistrationId = this.SetAndGetMaxId("AssessmentRegistrations"),
                                PersonId = enrollmentOrganizationPersonRole.PersonId,
                                LeaOrganizationId = leaOfEnrollmentId,
                                SchoolOrganizationId = enrollmentOrganizationPersonRole.OrganizationId,
                                AssessmentAdministrationId = assessmentAdministration.AssessmentAdministrationId,
                                AssessmentFormId = assessmentForm.AssessmentFormId,
                                RefGradeLevelWhenAssessedId = k12studentEnrollment.RefEntryGradeLevelId,
                                RefAssessmentParticipationIndicatorId = refAssessmentParticipationIndicatorId,
                                RefAssessmentReasonNotCompletingId = refAssessmentReasonNotCompletingId,
                                StateFullAcademicYear = fullYearStatus,
                                LeafullAcademicYear = fullYearStatus,
                                SchoolFullAcademicYear = fullYearStatus
                            };

                            testData.AssessmentRegistrations.Add(assessmentRegistration);


                            // AssessmentResult

                            int assessmentScore = rnd.Next(50, 100);


                            AssessmentSubtest subtest = this.AllAssessmentSubtests.Single(x => x.AssessmentFormId == assessmentForm.AssessmentFormId);

                            AssessmentResult assessmentResult = new AssessmentResult()
                            {
                                AssessmentResultId = this.SetAndGetMaxId("AssessmentResults"),
                                AssessmentRegistrationId = assessmentRegistration.AssessmentRegistrationId,
                                RefScoreMetricTypeId = this.OdsReferenceData.RefScoreMetricTypeId,
                                ScoreValue = assessmentScore.ToString(),
                                AssessmentSubtestId = subtest.AssessmentSubtestId
                            };

                            testData.AssessmentResults.Add(assessmentResult);

                            // AssessmentResult_PerformanceLevel

                            AssessmentPerformanceLevel performanceLevel = this.AllAssessmentPerformanceLevels
                                .Where(x => x.AssessmentSubtestId == subtest.AssessmentSubtestId
                                            && int.Parse(x.LowerCutScore) <= assessmentScore && int.Parse(x.UpperCutScore) >= assessmentScore)
                                .FirstOrDefault();

                            if (performanceLevel != null)
                            {
                                var assessmentResultPerformanceLevel = new AssessmentResult_PerformanceLevel()
                                {
                                    AssessmentResult_PerformanceLevelId = this.SetAndGetMaxId("AssessmentResult_PerformanceLevels"),
                                    AssessmentResultId = assessmentResult.AssessmentResultId,
                                    AssessmentPerformanceLevelId = performanceLevel.AssessmentPerformanceLevelId
                                };

                                testData.AssessmentResult_PerformanceLevels.Add(assessmentResultPerformanceLevel);
                            }



                        }
                    }
                }
            }

            return testData;
        }

        private IdsTestDataObject CreatePersonnelEnrollmentRelatedData(Random rnd, IdsTestDataObject testData, OrganizationPersonRole enrollmentOrganizationPersonRole, bool isSchoolEnrollment, int? leaOfEnrollmentId)
        {
            // K12staffAssignment

            RefSpecialEducationAgeGroupTaught refSpecialEducationAgeGroupTaught = _testDataHelper.GetRandomObject<RefSpecialEducationAgeGroupTaught>(rnd, this.OdsReferenceData.RefSpecialEducationAgeGroupTaughts);
            RefSpecialEducationStaffCategory refSpecialEducationStaffCategory = _testDataHelper.GetRandomObject<RefSpecialEducationStaffCategory>(rnd, this.OdsReferenceData.RefSpecialEducationStaffCategories);
            RefClassroomPositionType refClassroomPositionType = _testDataHelper.GetRandomObject<RefClassroomPositionType>(rnd, this.OdsReferenceData.RefClassroomPositionTypes);
            RefK12staffClassification refK12staffClassification = _testDataHelper.GetRandomObject<RefK12staffClassification>(rnd, this.OdsReferenceData.RefK12staffClassifications);
            RefTitleIprogramStaffCategory refTitleIprogramStaffCategory = _testDataHelper.GetRandomObject<RefTitleIprogramStaffCategory>(rnd, this.OdsReferenceData.RefTitleIprogramStaffCategories);
            RefUnexperiencedStatus refUnexperiencedStatus = _testDataHelper.GetRandomObject<RefUnexperiencedStatus>(rnd, this.OdsReferenceData.RefUnexperiencedStatuses);
            RefOutOfFieldStatus refOutOfFieldStatus = _testDataHelper.GetRandomObject<RefOutOfFieldStatus>(rnd, this.OdsReferenceData.RefOutOfFieldStatuses);
            RefEmergencyOrProvisionalCredentialStatus refEmergencyOrProvisionalCredentialStatus = _testDataHelper.GetRandomObject<RefEmergencyOrProvisionalCredentialStatus>(rnd, this.OdsReferenceData.RefEmergencyOrProvisionalCredentialStatuses);

            bool isHighlyQualified = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.HighlyQualifiedDistribution);
            decimal fte = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.StaffFteDistribution);


            K12staffAssignment k12staffAssignment = new K12staffAssignment()
            {
                K12staffAssignmentId = this.SetAndGetMaxId("K12staffAssignments"),
                OrganizationPersonRoleId = enrollmentOrganizationPersonRole.OrganizationPersonRoleId,
                HighlyQualifiedTeacherIndicator = isHighlyQualified,
                RefClassroomPositionTypeId = refClassroomPositionType.RefClassroomPositionTypeId,
                RefK12staffClassificationId = refK12staffClassification.RefEducationStaffClassificationId,
                RefSpecialEducationAgeGroupTaughtId = refSpecialEducationAgeGroupTaught.RefSpecialEducationAgeGroupTaughtId,
                RefTitleIprogramStaffCategoryId = refTitleIprogramStaffCategory.RefTitleIprogramStaffCategoryId,
                FullTimeEquivalency = fte,
                RefUnexperiencedStatusId = refUnexperiencedStatus.RefUnexperiencedStatusId,
                RefOutOfFieldStatusId = refOutOfFieldStatus.RefOutOfFieldStatusId,
                RefEmergencyOrProvisionalCredentialStatusId = refEmergencyOrProvisionalCredentialStatus.RefEmergencyOrProvisionalCredentialStatusId
            };

            bool isSpecialEdStaff = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IsSpecialEdStaffDistribution);

            if (isSpecialEdStaff)
            {
                k12staffAssignment.RefSpecialEducationStaffCategoryId = refSpecialEducationStaffCategory.RefSpecialEducationStaffCategoryId;
            }

            testData.K12staffAssignments.Add(k12staffAssignment);

            // AeStaff

            bool isAeStaff = _testDataHelper.GetWeightedSelection(rnd, _testDataProfile.IsAeStaffDistribution);

            if (isAeStaff)
            {
                RefAeCertificationType refAeCertificationType = _testDataHelper.GetRandomObject<RefAeCertificationType>(rnd, this.OdsReferenceData.RefAeCertificationTypes);

                AeStaff aeStaff = new AeStaff()
                {
                    OrganizationPersonRoleId = enrollmentOrganizationPersonRole.OrganizationPersonRoleId,
                    RefAeCertificationTypeId = refAeCertificationType.RefAeCertificationTypeId
                };

                testData.AeStaffs.Add(aeStaff);
            }



            RefCredentialType credentialType = _testDataHelper.GetRandomObject<RefCredentialType>(rnd, this.OdsReferenceData.RefCredentialTypes);

            var issuanceDate = _testDataHelper.GetEntryDate(rnd, (DateTime)enrollmentOrganizationPersonRole.EntryDate);
            var credentialDuration = _testDataHelper.GetRandomIntInRange(rnd, 100, 3000);
            var expirationDate = _testDataHelper.GetExitDate(rnd, (DateTime)enrollmentOrganizationPersonRole.EntryDate, enrollmentOrganizationPersonRole.EntryDate.Value.AddDays(credentialDuration));
            
            PersonCredential personCredential = new PersonCredential()
            {
                PersonCredentialId = this.SetAndGetMaxId("PersonCredentials"),
                PersonId = enrollmentOrganizationPersonRole.PersonId,
                RefCredentialTypeId = credentialType.RefCredentialTypeId,
                IssuanceDate = issuanceDate,
                ExpirationDate = expirationDate
            };

            testData.PersonCredentials.Add(personCredential);

            // Paraprofessional

            if (k12staffAssignment.RefK12staffClassificationId == this.OdsReferenceData.ParaProfessionalId)
            {

                RefParaprofessionalQualification paraprofessionalQualification = _testDataHelper.GetRandomObject<RefParaprofessionalQualification>(rnd, this.OdsReferenceData.RefParaprofessionalQualifications);

                StaffCredential staffCredential = new StaffCredential()
                {
                    StaffCredentialId = this.SetAndGetMaxId("StaffCredentials"),
                    PersonCredentialId = personCredential.PersonCredentialId,
                    RefParaprofessionalQualificationId = paraprofessionalQualification.RefParaprofessionalQualificationId
                };

                testData.StaffCredentials.Add(staffCredential);

            }


            return testData;
        }
    }

}
