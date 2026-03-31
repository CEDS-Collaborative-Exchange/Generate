using generate.core.Helpers.TestDataHelper;
using generate.core.Models.IDS;
using generate.core.Models.Staging;
using generate.testdata.Interfaces;
using generate.testdata.Profiles;
using System;
using System.Collections.Generic;
using System.Text;

namespace generate.testdata.TestCaseData
{
    public class FS006TestCaseData
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            IStagingTestDataProfile testDataProfile = new StagingTestDataProfile();
            IdsReferenceData idsReferenceData = new IdsReferenceData();

            // Data for CIID-4484 - We need a record in RDS.DimK12Students that is end dated so we can test Migrate_DimDisciplines 
            // logic that was pulling only DimK12Students record with end dates. 

            var org = testDataHelper.GetRandomObject(rnd, testData.K12Organizations);

            var k12Enrollment = new K12Enrollment() 
            {
                StudentIdentifierState = "0060000001",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("1/13/" + schoolYear.ToString()),
                ExitOrWithdrawalType = testDataHelper.GetWeightedSelection(rnd, testDataProfile.RefExitOrWithdrawalTypeDistribution),
                FirstName = "Jake",
                LastOrSurname = "WithAnEndDate",
                SchoolYear = schoolYear.ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var personRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "0060000001",
                RaceType = "AmericanIndianorAlaskaNative",
                LeaIdentifierSeaAccountability = k12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = k12Enrollment.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = k12Enrollment.EnrollmentEntryDate,
                RecordEndDateTime = k12Enrollment.EnrollmentExitDate
            };

            var personStatus = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "0060000001",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
            };

            var env = testDataHelper.GetRandomObject<generate.core.Models.IDS.RefIdeaeducationalEnvironmentSchoolAge>(rnd, idsReferenceData.RefIdeaeducationalEnvironmentSchoolAges).Code;

            var ppse = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "0060000001",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                IDEAEducationalEnvironmentForSchoolAge = env,
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                IDEAIndicator = true
            };

            var refDisciplinaryActionTaken = testDataHelper.GetRandomObject<RefDisciplinaryActionTaken>(rnd, idsReferenceData.RefDisciplinaryActionTakens).Code;
            var refDisciplineReason = testDataHelper.GetRandomObject<RefDisciplineReason>(rnd, idsReferenceData.RefDisciplineReasons).Code;
            string refIdeainterimRemoval = testDataHelper.GetRandomObject<RefIdeainterimRemoval>(rnd, idsReferenceData.RefIdeainterimRemovals).Code;
            string refIdeainterimRemovalReason = testDataHelper.GetRandomObject<RefIdeainterimRemovalReason>(rnd, idsReferenceData.RefIdeainterimRemovalReasons).Code;
            string refDisciplineMethodOfCwd = testDataHelper.GetRandomObject<RefDisciplineMethodOfCwd>(rnd, idsReferenceData.RefDisciplineMethodOfCwds).Code;
            string refFirearmType = testDataHelper.GetRandomObject<RefFirearmType>(rnd, idsReferenceData.RefFirearmTypes).Code;
            string refWeaponType = testDataHelper.GetRandomObject<RefWeaponType>(rnd, idsReferenceData.RefWeaponTypes).Code;

            var discipline = new Discipline()
            {
                StudentIdentifierState = "0060000001",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IncidentIdentifier = "005001",
                DisciplineActionIdentifier = "1",
                DurationOfDisciplinaryAction = "2",
                DisciplinaryActionStartDate = DateTime.Parse("10/1/" + (schoolYear - 2).ToString()),
                DisciplinaryActionTaken = refDisciplinaryActionTaken,
                DisciplineMethodOfCwd = refDisciplineMethodOfCwd,
                IdeaInterimRemoval = refIdeainterimRemoval,
                IdeaInterimRemovalReason = refIdeainterimRemovalReason,
                FirearmType = refFirearmType,
                WeaponType = refWeaponType,
                DisciplineReason = refDisciplineReason
            };

            var disciplineTwo = new Discipline()
            {
                StudentIdentifierState = "0060000001",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IncidentIdentifier = "005001",
                DisciplineActionIdentifier = "1",
                DurationOfDisciplinaryAction = "2",
                DisciplinaryActionStartDate = DateTime.Parse("10/1/" + (schoolYear - 1).ToString()),
                DisciplinaryActionTaken = refDisciplinaryActionTaken,
                DisciplineMethodOfCwd = refDisciplineMethodOfCwd,
                IdeaInterimRemoval = refIdeainterimRemoval,
                IdeaInterimRemovalReason = refIdeainterimRemovalReason,
                FirearmType = refFirearmType,
                WeaponType = refWeaponType,
                DisciplineReason = refDisciplineReason
            };
            testData.K12Enrollments.Add(k12Enrollment);
            testData.PersonRaces.Add(personRaceLea);
            testData.PersonStatuses.Add(personStatus);
            testData.ProgramParticipationSpecialEducations.Add(ppse);
            testData.Disciplines.Add(discipline);
            testData.Disciplines.Add(disciplineTwo);

            // Data for CIID-4503 - We need an IDEA InterimRemoval record and a non-IDEA InterimRemoval record to test the 
            // summing of Discipline Duration for c006.  The non record should be <= 10 and the IDEA value (when added) should 
            //put the total > 10
            var k12Enrollment4503 = new K12Enrollment()
            {
                StudentIdentifierState = "006CID4503",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("1/13/" + schoolYear.ToString()),
                ExitOrWithdrawalType = testDataHelper.GetWeightedSelection(rnd, testDataProfile.RefExitOrWithdrawalTypeDistribution),
                FirstName = "Billy",
                LastOrSurname = "TheKid",
                SchoolYear = schoolYear.ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var personRaceLea4503 = new K12PersonRace()
            {
                StudentIdentifierState = "006CID4503",
                RaceType = "AmericanIndianorAlaskaNative",
                LeaIdentifierSeaAccountability = k12Enrollment4503.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = k12Enrollment4503.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                RecordStartDateTime = k12Enrollment4503.EnrollmentEntryDate,
                RecordEndDateTime = k12Enrollment4503.EnrollmentExitDate
            };

            var personStatus4503 = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "006CID4503",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
            };

            var ppse4503 = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "006CID4503",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                SchoolYear = (schoolYear).ToString(),
                IDEAEducationalEnvironmentForSchoolAge = "RC80",
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                IDEAIndicator = true
            };

            var discipline4503 = new Discipline()
            {
                StudentIdentifierState = "006CID4503",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IncidentIdentifier = "006450301",
                DisciplineActionIdentifier = "1",
                DurationOfDisciplinaryAction = "9",
                DisciplinaryActionStartDate = DateTime.Parse("10/1/" + (schoolYear - 2).ToString()),
                DisciplinaryActionTaken = "03101",
                DisciplineMethodOfCwd = "OutOfSchool",
            };

            var disciplineTwo4503 = new Discipline()
            {
                StudentIdentifierState = "006CID4503",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IncidentIdentifier = "006450302",
                DisciplineActionIdentifier = "1",
                DurationOfDisciplinaryAction = "3",
                DisciplinaryActionStartDate = DateTime.Parse("3/1/" + (schoolYear - 1).ToString()),
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
            };
            testData.K12Enrollments.Add(k12Enrollment4503);
            testData.PersonRaces.Add(personRaceLea4503);
            testData.PersonStatuses.Add(personStatus4503);
            testData.ProgramParticipationSpecialEducations.Add(ppse4503);
            testData.Disciplines.Add(discipline4503);
            testData.Disciplines.Add(disciplineTwo4503);

        }
    }
}