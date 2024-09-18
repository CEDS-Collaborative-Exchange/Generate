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
    public class FS005TestCaseData
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            IStagingTestDataProfile testDataProfile = new StagingTestDataProfile();
            IdsReferenceData idsReferenceData = new IdsReferenceData();
            //Test data for FS005 test

            // Data for CIID-4441 - We need a record in RDS.DimK12Students that is end dated so we can test Migrate_DimDisciplines 
            // logic that was pulling only DimK12Students record with end dates. 

            var org = testDataHelper.GetRandomObject(rnd, testData.K12Organizations);

            var firstK12Enrollment = new K12Enrollment() // Last year's record
            {
                StudentIdentifierState = "0050000001",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 2).ToString()),
                EnrollmentExitDate = DateTime.Parse("1/13/" + (schoolYear - 1).ToString()),
                ExitOrWithdrawalType = testDataHelper.GetWeightedSelection(rnd, testDataProfile.RefExitOrWithdrawalTypeDistribution),
                FirstName = "Jake",
                LastOrSurname = "WithAnEndDate",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "09",
                Sex = "Male"
            };

            var secondK12Enrollment = new K12Enrollment() // This year's record
            {
                StudentIdentifierState = "0050000001",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("1/14/" + (schoolYear).ToString()),
                EnrollmentExitDate = DateTime.Parse("6/30/" + schoolYear.ToString()),
                ExitOrWithdrawalType = testDataHelper.GetWeightedSelection(rnd, testDataProfile.RefExitOrWithdrawalTypeDistribution),
                FirstName = "Jake",
                LastOrSurname = "WithAnEndDate",
                SchoolYear = schoolYear.ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var leaOnlyStudent = new K12Enrollment() // This year's record
            {
                StudentIdentifierState = "0050000002",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                Birthdate = DateTime.Parse("1/05/" + (schoolYear - 14).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("6/30/" + schoolYear.ToString()),
                ExitOrWithdrawalType = testDataHelper.GetWeightedSelection(rnd, testDataProfile.RefExitOrWithdrawalTypeDistribution),
                FirstName = "Charlie",
                LastOrSurname = "Brown",
                SchoolYear = schoolYear.ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var firstPersonRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "0050000001",
                RaceType = "AmericanIndianorAlaskaNative",
                LeaIdentifierSeaAccountability = firstK12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = firstK12Enrollment.SchoolIdentifierSea,
                RecordStartDateTime = leaOnlyStudent.EnrollmentEntryDate,
                RecordEndDateTime = leaOnlyStudent.EnrollmentExitDate,
                SchoolYear = (schoolYear).ToString()
            };

            var leaOnlyStudentRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "0050000002",
                RaceType = "AmericanIndianorAlaskaNative",
                LeaIdentifierSeaAccountability = leaOnlyStudent.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = leaOnlyStudent.SchoolIdentifierSea,
                RecordStartDateTime = leaOnlyStudent.EnrollmentEntryDate,
                RecordEndDateTime = leaOnlyStudent.EnrollmentExitDate,
                SchoolYear = (schoolYear).ToString()
            };

            var firstPersonStatus = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "0050000001",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
            };

            var firstIdt = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "0050000001",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IdeaDisabilityTypeCode = "VisualImpairment",
                IsPrimaryDisability = true,
                SchoolYear = Convert.ToInt16(schoolYear),
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 2).ToString())
            };

            var leaOnlyStudentPersonStatus = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "0050000002",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString())
            };

            var secondIdt = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "0050000002",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                IdeaDisabilityTypeCode = "Hearingimpairment",
                SchoolYear = Convert.ToInt16(schoolYear),
                IsPrimaryDisability = true,
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 2).ToString())
            };

            var env = testDataHelper.GetRandomObject<generate.core.Models.IDS.RefIdeaeducationalEnvironmentSchoolAge>(rnd, idsReferenceData.RefIdeaeducationalEnvironmentSchoolAges).Code;

            var firstPpse = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "0050000001",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = env,
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                IDEAIndicator = true
            };

            var leaOnlyStudentPpse = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "0050000002",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
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
                StudentIdentifierState = "0050000001",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IncidentIdentifier = "005001",
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
                StudentIdentifierState = "0050000001",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IncidentIdentifier = "005002",
                DisciplinaryActionStartDate = DateTime.Parse("2/10/" + (schoolYear).ToString()),
                DisciplinaryActionTaken = refDisciplinaryActionTaken,
                DisciplineMethodOfCwd = refDisciplineMethodOfCwd,
                IdeaInterimRemoval = refIdeainterimRemoval,
                IdeaInterimRemovalReason = refIdeainterimRemovalReason,
                FirearmType = refFirearmType,
                WeaponType = refWeaponType,
                DisciplineReason = refDisciplineReason
            };

            var leaOnlyStudentDiscipline = new Discipline()
            {
                StudentIdentifierState = "0050000002",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                IncidentIdentifier = "005003",
                DisciplinaryActionStartDate = DateTime.Parse("10/1/" + (schoolYear - 1).ToString()),
                DisciplinaryActionTaken = refDisciplinaryActionTaken,
                DisciplineMethodOfCwd = refDisciplineMethodOfCwd,
                IdeaInterimRemoval = refIdeainterimRemoval,
                IdeaInterimRemovalReason = refIdeainterimRemovalReason,
                FirearmType = refFirearmType,
                WeaponType = refWeaponType,
                DisciplineReason = refDisciplineReason
            };

            testData.K12Enrollments.Add(firstK12Enrollment);
            testData.K12Enrollments.Add(secondK12Enrollment);
            testData.K12Enrollments.Add(leaOnlyStudent);
            testData.PersonRaces.Add(firstPersonRaceLea);
            testData.PersonRaces.Add(leaOnlyStudentRaceLea);
            testData.PersonStatuses.Add(firstPersonStatus);
            testData.PersonStatuses.Add(leaOnlyStudentPersonStatus);
            testData.IdeaDisabilityTypes.Add(firstIdt);
            testData.IdeaDisabilityTypes.Add(secondIdt);
            testData.ProgramParticipationSpecialEducations.Add(firstPpse);
            testData.ProgramParticipationSpecialEducations.Add(leaOnlyStudentPpse);
            testData.Disciplines.Add(discipline);
            testData.Disciplines.Add(disciplineTwo);
            testData.Disciplines.Add(leaOnlyStudentDiscipline);


            // Data for CIID-4494 - We need a REMDW record and a different type Discipline record that combined total more than 45 days

            var aK12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "CD4494_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("1/13/" + (schoolYear).ToString()),
                ExitOrWithdrawalType = testDataHelper.GetWeightedSelection(rnd, testDataProfile.RefExitOrWithdrawalTypeDistribution),
                FirstName = "Daffy",
                LastOrSurname = "Duck",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "09",
                Sex = "Male"
            };

            var aPersonRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "CD4494_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                RaceType = "AmericanIndianorAlaskaNative",
                RecordStartDateTime = aK12Enrollment.EnrollmentEntryDate,
                RecordEndDateTime = aK12Enrollment.EnrollmentExitDate,
                SchoolYear = (schoolYear).ToString()
            };

            var aPersonStatus = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CD4494_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
            };

            var aIdt = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CD4494_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true
            };

            var aPpse = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CD4494_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = env,
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                IDEAIndicator = true,
            };

            var aDiscipline = new Discipline()
            {
                StudentIdentifierState = "CD4494_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IncidentIdentifier = "CIID4494_111",
                DisciplineActionIdentifier = "1",
                DisciplinaryActionStartDate = DateTime.Parse("10/1/" + (schoolYear - 1).ToString()),
                DurationOfDisciplinaryAction = "25",
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
            };

            var aDisciplineTwo = new Discipline()
            {
                StudentIdentifierState = "CD4494_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IncidentIdentifier = "CIID4494_222",
                DisciplineActionIdentifier = "2",
                DisciplinaryActionStartDate = DateTime.Parse("02/1/" + (schoolYear).ToString()),
                DurationOfDisciplinaryAction = "25",
                DisciplinaryActionTaken = "03101",
                DisciplineMethodOfCwd = "OutOfSchool",
            };

            testData.K12Enrollments.Add(aK12Enrollment);
            testData.PersonRaces.Add(aPersonRaceLea);
            testData.PersonStatuses.Add(aPersonStatus);
            testData.ProgramParticipationSpecialEducations.Add(aPpse);
            testData.IdeaDisabilityTypes.Add(aIdt);
            testData.Disciplines.Add(aDiscipline);
            testData.Disciplines.Add(aDisciplineTwo);


            // CIID-4522 - Data for multiple IDEA statuses, one EL status that spans the SY

            var bK12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "CD4522_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                EnrollmentExitDate = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                FirstName = "Captain",
                LastOrSurname = "Caveman",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "09",
                Sex = "Male"
            };

            var bPersonRaceLea = new K12PersonRace()
            {
                StudentIdentifierState = "CD4522_005",
                RaceType = "AmericanIndianorAlaskaNative",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                RecordStartDateTime = bK12Enrollment.EnrollmentEntryDate,
                RecordEndDateTime = bK12Enrollment.EnrollmentExitDate,
                SchoolYear = (schoolYear).ToString()
            };

            var bPersonStatus1 = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CD4522_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
            };

            var bIdt1 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CD4522_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                RecordStartDateTime = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("8/10/" + (schoolYear - 1).ToString()),
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                SchoolYear = Convert.ToInt16(schoolYear),
                IsPrimaryDisability = true
            };

            var bPersonStatus2 = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CD4522_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
            };

            var bIdt2 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CD4522_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                RecordStartDateTime = DateTime.Parse("8/11/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("12/1/" + (schoolYear - 1).ToString()),
                SchoolYear = Convert.ToInt16(schoolYear),
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                IsPrimaryDisability = true
            };

            var bPersonStatus3 = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CD4522_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
            };

            var bIdt3 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CD4522_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                RecordStartDateTime = DateTime.Parse("12/2/" + (schoolYear - 1).ToString()),
                RecordEndDateTime = DateTime.Parse("2/12/" + (schoolYear).ToString()),
                IdeaDisabilityTypeCode = "Emotionaldisturbance",
                SchoolYear = Convert.ToInt16(schoolYear),
                IsPrimaryDisability = true
            };

            var bPersonStatus4 = new core.Models.Staging.PersonStatus()
            {
                StudentIdentifierState = "CD4522_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                EnglishLearnerStatus = false,
                EnglishLearner_StatusStartDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
            };

            var bIdt4 = new core.Models.Staging.IdeaDisabilityType()
            {
                StudentIdentifierState = "CD4522_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                RecordStartDateTime = DateTime.Parse("2/13/" + (schoolYear).ToString()),
                RecordEndDateTime = DateTime.Parse("6/30/" + (schoolYear).ToString()),
                IdeaDisabilityTypeCode = "Hearingimpairment",
                SchoolYear = Convert.ToInt16(schoolYear),
                IsPrimaryDisability = true
            };

            var bPpse1 = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CD4522_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = env,
                ProgramParticipationBeginDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("8/10/" + (schoolYear - 1).ToString()),
                IDEAIndicator = true
            };

            var bPpse2 = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CD4522_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = env,
                ProgramParticipationBeginDate = DateTime.Parse("8/11/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("12/1/" + (schoolYear - 1).ToString()),
                IDEAIndicator = true
            };

            var bPpse3 = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CD4522_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = env,
                ProgramParticipationBeginDate = DateTime.Parse("12/2/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("2/12/" + (schoolYear - 1).ToString()),
                IDEAIndicator = true
            };

            var bPpse4 = new core.Models.Staging.ProgramParticipationSpecialEducation()
            {
                StudentIdentifierState = "CD4522_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IDEAEducationalEnvironmentForSchoolAge = env,
                ProgramParticipationBeginDate = DateTime.Parse("2/13/" + (schoolYear - 1).ToString()),
                ProgramParticipationEndDate = DateTime.Parse("6/30/" + (schoolYear - 1).ToString()),
                IDEAIndicator = true
            };

            var bDiscipline1 = new Discipline()
            {
                StudentIdentifierState = "CD4522_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IncidentIdentifier = "CIID4522_111",
                DisciplineActionIdentifier = "1",
                DisciplinaryActionStartDate = DateTime.Parse("10/1/" + (schoolYear - 1).ToString()),
                DurationOfDisciplinaryAction = "25",
                IdeaInterimRemoval = "REMDW",
                IdeaInterimRemovalReason = "Drugs",
            };

            var bDiscipline2 = new Discipline()
            {
                StudentIdentifierState = "CD4522_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IncidentIdentifier = "CIID4522_222",
                DisciplineActionIdentifier = "2",
                DisciplinaryActionStartDate = DateTime.Parse("02/1/" + (schoolYear).ToString()),
                DurationOfDisciplinaryAction = "4",
                DisciplinaryActionTaken = "03101",
                DisciplineMethodOfCwd = "OutOfSchool",
            };

            var bDiscipline3 = new Discipline()
            {
                StudentIdentifierState = "CD4522_005",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IncidentIdentifier = "CIID4522_333",
                DisciplineActionIdentifier = "2",
                DisciplinaryActionStartDate = DateTime.Parse("03/15/" + (schoolYear).ToString()),
                DurationOfDisciplinaryAction = "8",
                DisciplinaryActionTaken = "03101",
                DisciplineMethodOfCwd = "OutOfSchool",
            };

            testData.K12Enrollments.Add(bK12Enrollment);
            testData.PersonRaces.Add(bPersonRaceLea);
            testData.PersonStatuses.Add(bPersonStatus1);
            testData.PersonStatuses.Add(bPersonStatus2);
            testData.PersonStatuses.Add(bPersonStatus3);
            testData.PersonStatuses.Add(bPersonStatus4);
            testData.IdeaDisabilityTypes.Add(bIdt1);
            testData.IdeaDisabilityTypes.Add(bIdt2);
            testData.IdeaDisabilityTypes.Add(bIdt3);
            testData.IdeaDisabilityTypes.Add(bIdt4);
            testData.ProgramParticipationSpecialEducations.Add(bPpse1);
            testData.ProgramParticipationSpecialEducations.Add(bPpse2);
            testData.ProgramParticipationSpecialEducations.Add(bPpse3);
            testData.ProgramParticipationSpecialEducations.Add(bPpse4);
            testData.Disciplines.Add(bDiscipline1);
            testData.Disciplines.Add(bDiscipline2);
            testData.Disciplines.Add(bDiscipline3);

        }

    }
}
