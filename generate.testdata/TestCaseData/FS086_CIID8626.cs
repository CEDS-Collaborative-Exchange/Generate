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
    public class FS086_CIID8626
    {
        public static void AppendTestCaseData(StagingTestDataObject testData, Random rnd, ITestDataHelper testDataHelper, int schoolYear)
        {
            IStagingTestDataProfile testDataProfile = new StagingTestDataProfile();
            IdsReferenceData idsReferenceData = new IdsReferenceData();
            //Test data for FS086

            // Data for CIID-8626 - We need 2 students in Discipline with a firearms incident assigned the same incident ID

            var org = testDataHelper.GetRandomObject(rnd, testData.K12Organizations);

            var firstStudentK12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "0860000001",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("12/03/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                FirstName = "Firearm",
                LastOrSurname = "Student1",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "09",
                Sex = "Male"
            };

            var secondStudentK12Enrollment = new K12Enrollment()
            {
                StudentIdentifierState = "0860000002",
                LeaIdentifierSeaAccountability = firstStudentK12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = firstStudentK12Enrollment.SchoolIdentifierSea,
                Birthdate = DateTime.Parse("10/12/" + (schoolYear - 15).ToString()),
                EnrollmentEntryDate = DateTime.Parse("7/1/" + (schoolYear - 1).ToString()),
                FirstName = "Firearm",
                LastOrSurname = "Student2",
                SchoolYear = (schoolYear).ToString(),
                GradeLevel = "10",
                Sex = "Male"
            };

            var firstStudentRace = new K12PersonRace()
            {
                StudentIdentifierState = "0860000001",
                RaceType = "White",
                LeaIdentifierSeaAccountability = firstStudentK12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = firstStudentK12Enrollment.SchoolIdentifierSea,
                RecordStartDateTime = firstStudentK12Enrollment.EnrollmentEntryDate,
                SchoolYear = (schoolYear).ToString()
            };

            var secondStudentRace = new K12PersonRace()
            {
                StudentIdentifierState = "0860000002",
                RaceType = "White",
                LeaIdentifierSeaAccountability = secondStudentK12Enrollment.LeaIdentifierSeaAccountability,
                SchoolIdentifierSea = secondStudentK12Enrollment.SchoolIdentifierSea,
                RecordStartDateTime = secondStudentK12Enrollment.EnrollmentEntryDate,
                SchoolYear = (schoolYear).ToString()
            };

            var refDisciplinaryActionTaken = testDataHelper.GetRandomObject<RefDisciplinaryActionTaken>(rnd, idsReferenceData.RefDisciplinaryActionTakens).Code;
            string refDisciplineMethodFirearms = testDataHelper.GetRandomObject<RefDisciplineMethodFirearms>(rnd, idsReferenceData.RefDisciplineMethodFirearms).Code;

            var firstStudentDiscipline = new Discipline()
            {
                StudentIdentifierState = "0860000001",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IncidentIdentifier = "086-001",
                DisciplinaryActionStartDate = DateTime.Parse("10/1/" + (schoolYear - 1).ToString()),
                DisciplinaryActionTaken = refDisciplinaryActionTaken,
                FirearmType = "Handguns_1",
                DisciplineMethodFirearm = refDisciplineMethodFirearms,
                SchoolYear = Convert.ToInt16(schoolYear),
            };

            var secondStudentDiscipline = new Discipline()
            {
                StudentIdentifierState = "0860000002",
                LeaIdentifierSeaAccountability = org.LeaIdentifierSea,
                SchoolIdentifierSea = org.SchoolIdentifierSea,
                IncidentIdentifier = "086-001",
                DisciplinaryActionStartDate = DateTime.Parse("10/1/" + (schoolYear - 1).ToString()),
                DisciplinaryActionTaken = refDisciplinaryActionTaken,
                FirearmType = "RiflesShotguns_1",
                DisciplineMethodFirearm = refDisciplineMethodFirearms,
                SchoolYear = Convert.ToInt16(schoolYear),
            };

            testData.K12Enrollments.Add(firstStudentK12Enrollment);
            testData.K12Enrollments.Add(secondStudentK12Enrollment);
            testData.PersonRaces.Add(firstStudentRace);
            testData.PersonRaces.Add(secondStudentRace);
            testData.Disciplines.Add(firstStudentDiscipline);
            testData.Disciplines.Add(secondStudentDiscipline);

        }

    }
}
