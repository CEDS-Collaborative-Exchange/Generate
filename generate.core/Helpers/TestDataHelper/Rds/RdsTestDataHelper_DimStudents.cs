using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using generate.core.Models.RDS;

namespace generate.core.Helpers.TestDataHelper.Rds
{
 public static partial class RdsTestDataHelper
 {
     public static RdsTestDataObject GetRdsTestData_DimStudents()
     {
         // SeedValue = 50000

         var testData = new RdsTestDataObject();


         //testData = new RdsTestDataObject()
         //{
         //    TestDataSection = "DimStudents",
         //    TestDataSectionDescription = "DimStudents Data",
         //    DimStudents = new List<generate.core.Models.RDS.DimK12Student> ()
         //    {
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1,
         //            //StudentPersonId = 1,
         //            StateStudentIdentifier = "0003187211",
         //            FirstName = "Jared",
         //            MiddleName = "Xavier",
         //            LastName = "Berger",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2013, 7, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 2,
         //            //StudentPersonId = 2,
         //            StateStudentIdentifier = "0007993232",
         //            FirstName = "Noelle",
         //            MiddleName = "Hayfa",
         //            LastName = "Harding",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 12, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 3,
         //            //StudentPersonId = 3,
         //            StateStudentIdentifier = "0003390423",
         //            FirstName = "Madonna",
         //            MiddleName = "Serina",
         //            LastName = "Bass",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2006, 7, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 4,
         //            //StudentPersonId = 4,
         //            StateStudentIdentifier = "0001122054",
         //            FirstName = "Kasper",
         //            MiddleName = "Ursa",
         //            LastName = "Shields",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2000, 3, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 5,
         //            //StudentPersonId = 5,
         //            StateStudentIdentifier = "0005824085",
         //            FirstName = "Warren",
         //            MiddleName = "Hiram",
         //            LastName = "Hooper",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 10, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 6,
         //            //StudentPersonId = 6,
         //            StateStudentIdentifier = "0006613706",
         //            FirstName = "Noel",
         //            MiddleName = "Lilah",
         //            LastName = "Beard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 5, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 7,
         //            //StudentPersonId = 7,
         //            StateStudentIdentifier = "0000759147",
         //            FirstName = "Malcolm",
         //            MiddleName = "Akeem",
         //            LastName = "Barry",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2013, 3, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 8,
         //            //StudentPersonId = 8,
         //            StateStudentIdentifier = "0009366958",
         //            FirstName = "Germane",
         //            MiddleName = "Zia",
         //            LastName = "Bennett",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2016, 12, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 9,
         //            //StudentPersonId = 9,
         //            StateStudentIdentifier = "0007060209",
         //            FirstName = "Lyle",
         //            MiddleName = "Ulysses",
         //            LastName = "Paul",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2010, 9, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 10,
         //            //StudentPersonId = 10,
         //            StateStudentIdentifier = "0073404610",
         //            FirstName = "Cedric",
         //            MiddleName = "Hammett",
         //            LastName = "Walker",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 4, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 11,
         //            //StudentPersonId = 11,
         //            StateStudentIdentifier = "0019466211",
         //            FirstName = "Macey",
         //            MiddleName = "Levi",
         //            LastName = "Emerson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 3, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 12,
         //            //StudentPersonId = 12,
         //            StateStudentIdentifier = "0086415912",
         //            FirstName = "Griffith",
         //            MiddleName = "Sebastian",
         //            LastName = "Keith",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1997, 11, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 13,
         //            //StudentPersonId = 13,
         //            StateStudentIdentifier = "0097043513",
         //            FirstName = "Curran",
         //            MiddleName = "Ezra",
         //            LastName = "Banks",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 6, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 14,
         //            //StudentPersonId = 14,
         //            StateStudentIdentifier = "0097931914",
         //            FirstName = "Madison",
         //            MiddleName = "Rae",
         //            LastName = "Walsh",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 9, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 15,
         //            //StudentPersonId = 15,
         //            StateStudentIdentifier = "0007706815",
         //            FirstName = "Zenaida",
         //            MiddleName = "Hiroko",
         //            LastName = "Rice",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2010, 12, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 16,
         //            //StudentPersonId = 16,
         //            StateStudentIdentifier = "0054203916",
         //            FirstName = "Amos",
         //            MiddleName = "Kibo",
         //            LastName = "Buchanan",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2000, 9, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 17,
         //            //StudentPersonId = 17,
         //            StateStudentIdentifier = "0029324317",
         //            FirstName = "Lani",
         //            MiddleName = "Tiger",
         //            LastName = "Turner",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2019, 3, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 18,
         //            //StudentPersonId = 18,
         //            StateStudentIdentifier = "0084321018",
         //            FirstName = "Katell",
         //            MiddleName = "Anjolie",
         //            LastName = "Ashley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 5, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 19,
         //            //StudentPersonId = 19,
         //            StateStudentIdentifier = "0000632419",
         //            FirstName = "Daquan",
         //            MiddleName = "Patrick",
         //            LastName = "Hoover",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 4, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 20,
         //            //StudentPersonId = 20,
         //            StateStudentIdentifier = "0021938720",
         //            FirstName = "Oliver",
         //            MiddleName = "Ferdinand",
         //            LastName = "Lott",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2015, 6, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 21,
         //            //StudentPersonId = 21,
         //            StateStudentIdentifier = "0027586021",
         //            FirstName = "Shea",
         //            MiddleName = "Carson",
         //            LastName = "Craig",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 10, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 22,
         //            //StudentPersonId = 22,
         //            StateStudentIdentifier = "0058148222",
         //            FirstName = "Hedy",
         //            MiddleName = "Daphne",
         //            LastName = "Kirk",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 10, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 23,
         //            //StudentPersonId = 23,
         //            StateStudentIdentifier = "0064691023",
         //            FirstName = "Colin",
         //            MiddleName = "Richard",
         //            LastName = "Mcmahon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 12, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 24,
         //            //StudentPersonId = 24,
         //            StateStudentIdentifier = "0079661524",
         //            FirstName = "Callum",
         //            MiddleName = "Demetrius",
         //            LastName = "Hall",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 3, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 25,
         //            //StudentPersonId = 25,
         //            StateStudentIdentifier = "0029960825",
         //            FirstName = "Nadine",
         //            MiddleName = "Grace",
         //            LastName = "Burke",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2019, 3, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 26,
         //            //StudentPersonId = 26,
         //            StateStudentIdentifier = "0090099326",
         //            FirstName = "Emmanuel",
         //            MiddleName = "Henry",
         //            LastName = "Franco",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 3, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 27,
         //            //StudentPersonId = 27,
         //            StateStudentIdentifier = "0012805327",
         //            FirstName = "Madonna",
         //            MiddleName = "Cassandra",
         //            LastName = "Potter",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 8, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 28,
         //            //StudentPersonId = 28,
         //            StateStudentIdentifier = "0054444628",
         //            FirstName = "Sophia",
         //            MiddleName = "Yvette",
         //            LastName = "Powell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 6, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 29,
         //            //StudentPersonId = 29,
         //            StateStudentIdentifier = "0063549329",
         //            FirstName = "Barry",
         //            MiddleName = "Rafael",
         //            LastName = "Conrad",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2011, 10, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 30,
         //            //StudentPersonId = 30,
         //            StateStudentIdentifier = "0046529530",
         //            FirstName = "Burke",
         //            MiddleName = "Raphael",
         //            LastName = "Olsen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 6, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 31,
         //            //StudentPersonId = 31,
         //            StateStudentIdentifier = "0003660631",
         //            FirstName = "Zahir",
         //            MiddleName = "Cadman",
         //            LastName = "Good",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2012, 11, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 32,
         //            //StudentPersonId = 32,
         //            StateStudentIdentifier = "0048381532",
         //            FirstName = "Rana",
         //            MiddleName = "Elaine",
         //            LastName = "Salas",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 5, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 33,
         //            //StudentPersonId = 33,
         //            StateStudentIdentifier = "0004754533",
         //            FirstName = "Baxter",
         //            MiddleName = "Gary",
         //            LastName = "Berg",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2019, 9, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 34,
         //            //StudentPersonId = 34,
         //            StateStudentIdentifier = "0007611034",
         //            FirstName = "Deacon",
         //            MiddleName = "Amery",
         //            LastName = "Wagner",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 2, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 35,
         //            //StudentPersonId = 35,
         //            StateStudentIdentifier = "0017493035",
         //            FirstName = "Wang",
         //            MiddleName = "Sloane",
         //            LastName = "Valenzuela",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 1, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 36,
         //            //StudentPersonId = 36,
         //            StateStudentIdentifier = "0030640136",
         //            FirstName = "Thor",
         //            MiddleName = "Adrienne",
         //            LastName = "Ballard",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2000, 10, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 37,
         //            //StudentPersonId = 37,
         //            StateStudentIdentifier = "0078934237",
         //            FirstName = "Callum",
         //            MiddleName = "Stewart",
         //            LastName = "Mcdaniel",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2011, 4, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 38,
         //            //StudentPersonId = 38,
         //            StateStudentIdentifier = "0073010238",
         //            FirstName = "Wendy",
         //            MiddleName = "Josephine",
         //            LastName = "Rutledge",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 4, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 39,
         //            //StudentPersonId = 39,
         //            StateStudentIdentifier = "0062983539",
         //            FirstName = "Elton",
         //            MiddleName = "Philip",
         //            LastName = "Dorsey",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 12, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 40,
         //            //StudentPersonId = 40,
         //            StateStudentIdentifier = "0076945240",
         //            FirstName = "Mike",
         //            MiddleName = "Cruz",
         //            LastName = "Hart",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 7, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 41,
         //            //StudentPersonId = 41,
         //            StateStudentIdentifier = "0004889141",
         //            FirstName = "Mary",
         //            MiddleName = "Lois",
         //            LastName = "Hunt",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 7, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 42,
         //            //StudentPersonId = 42,
         //            StateStudentIdentifier = "0016594542",
         //            FirstName = "Ryder",
         //            MiddleName = "Kenneth",
         //            LastName = "Mckay",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 5, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 43,
         //            //StudentPersonId = 43,
         //            StateStudentIdentifier = "0097705843",
         //            FirstName = "Maggy",
         //            MiddleName = "Penelope",
         //            LastName = "Pratt",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2004, 5, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 44,
         //            //StudentPersonId = 44,
         //            StateStudentIdentifier = "0022945744",
         //            FirstName = "Althea",
         //            MiddleName = "Lacy",
         //            LastName = "Reynolds",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 11, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 45,
         //            //StudentPersonId = 45,
         //            StateStudentIdentifier = "0018774645",
         //            FirstName = "Dahlia",
         //            MiddleName = "Darrel",
         //            LastName = "Brown",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2008, 9, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 46,
         //            //StudentPersonId = 46,
         //            StateStudentIdentifier = "0019767746",
         //            FirstName = "Colton",
         //            MiddleName = "Marvin",
         //            LastName = "Sykes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 10, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 47,
         //            //StudentPersonId = 47,
         //            StateStudentIdentifier = "0018962947",
         //            FirstName = "Ira",
         //            MiddleName = "Roth",
         //            LastName = "Frazier",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 11, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 48,
         //            //StudentPersonId = 48,
         //            StateStudentIdentifier = "0018814548",
         //            FirstName = "Hyacinth",
         //            MiddleName = "Roary",
         //            LastName = "Harding",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2019, 8, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 49,
         //            //StudentPersonId = 49,
         //            StateStudentIdentifier = "0053850549",
         //            FirstName = "Julian",
         //            MiddleName = "Derek",
         //            LastName = "Gregory",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 8, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 50,
         //            //StudentPersonId = 50,
         //            StateStudentIdentifier = "0082149850",
         //            FirstName = "Kareem",
         //            MiddleName = "Jonah",
         //            LastName = "Griffith",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 2, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 51,
         //            //StudentPersonId = 51,
         //            StateStudentIdentifier = "0068856151",
         //            FirstName = "Trevor",
         //            MiddleName = "Tanek",
         //            LastName = "Holman",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2002, 8, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 52,
         //            //StudentPersonId = 52,
         //            StateStudentIdentifier = "0066715652",
         //            FirstName = "Fay",
         //            MiddleName = "Jarrod",
         //            LastName = "Reyes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 8, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 53,
         //            //StudentPersonId = 53,
         //            StateStudentIdentifier = "0012988353",
         //            FirstName = "Brielle",
         //            MiddleName = "Aline",
         //            LastName = "Mosley",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2014, 6, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 54,
         //            //StudentPersonId = 54,
         //            StateStudentIdentifier = "0018137254",
         //            FirstName = "Keaton",
         //            MiddleName = "Cain",
         //            LastName = "Mckay",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 3, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 55,
         //            //StudentPersonId = 55,
         //            StateStudentIdentifier = "0067491855",
         //            FirstName = "Gareth",
         //            MiddleName = "Hanae",
         //            LastName = "Hebert",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 6, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 56,
         //            //StudentPersonId = 56,
         //            StateStudentIdentifier = "0055309056",
         //            FirstName = "Amir",
         //            MiddleName = "Vaughan",
         //            LastName = "Kramer",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2009, 4, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 57,
         //            //StudentPersonId = 57,
         //            StateStudentIdentifier = "0016453357",
         //            FirstName = "Alexandra",
         //            MiddleName = "Fredericka",
         //            LastName = "Combs",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 12, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 58,
         //            //StudentPersonId = 58,
         //            StateStudentIdentifier = "0023013258",
         //            FirstName = "Melvin",
         //            MiddleName = "Bernard",
         //            LastName = "Alston",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 12, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 59,
         //            //StudentPersonId = 59,
         //            StateStudentIdentifier = "0026554859",
         //            FirstName = "Heather",
         //            MiddleName = "Daryl",
         //            LastName = "Colon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 1, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 60,
         //            //StudentPersonId = 60,
         //            StateStudentIdentifier = "0094180060",
         //            FirstName = "Derek",
         //            MiddleName = "Jared",
         //            LastName = "Summers",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 2, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 61,
         //            //StudentPersonId = 61,
         //            StateStudentIdentifier = "0050320361",
         //            FirstName = "Dominique",
         //            MiddleName = "Ann",
         //            LastName = "Walters",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2016, 6, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 62,
         //            //StudentPersonId = 62,
         //            StateStudentIdentifier = "0061920562",
         //            FirstName = "Dominic",
         //            MiddleName = "Dane",
         //            LastName = "Rutledge",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2017, 6, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 63,
         //            //StudentPersonId = 63,
         //            StateStudentIdentifier = "0098350763",
         //            FirstName = "Tyrone",
         //            MiddleName = "Mannix",
         //            LastName = "Christensen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 6, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 64,
         //            //StudentPersonId = 64,
         //            StateStudentIdentifier = "0036193364",
         //            FirstName = "Arsenio",
         //            MiddleName = "Tobias",
         //            LastName = "Flores",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 3, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 65,
         //            //StudentPersonId = 65,
         //            StateStudentIdentifier = "0060947665",
         //            FirstName = "Mike",
         //            MiddleName = "Noah",
         //            LastName = "Bailey",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 9, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 66,
         //            //StudentPersonId = 66,
         //            StateStudentIdentifier = "0028528966",
         //            FirstName = "Erica",
         //            MiddleName = "Kyla",
         //            LastName = "Mayer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 8, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 67,
         //            //StudentPersonId = 67,
         //            StateStudentIdentifier = "0015971067",
         //            FirstName = "Fleur",
         //            MiddleName = "Aristotle",
         //            LastName = "Knowles",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 1, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 68,
         //            //StudentPersonId = 68,
         //            StateStudentIdentifier = "0049932368",
         //            FirstName = "Felicia",
         //            MiddleName = "Paloma",
         //            LastName = "Heath",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 2, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 69,
         //            //StudentPersonId = 69,
         //            StateStudentIdentifier = "0041760369",
         //            FirstName = "Josephine",
         //            MiddleName = "Keiko",
         //            LastName = "York",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 2, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 70,
         //            //StudentPersonId = 70,
         //            StateStudentIdentifier = "0069837670",
         //            FirstName = "Davis",
         //            MiddleName = "Thane",
         //            LastName = "Berg",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 4, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 71,
         //            //StudentPersonId = 71,
         //            StateStudentIdentifier = "0067155671",
         //            FirstName = "Henry",
         //            MiddleName = "Benjamin",
         //            LastName = "Blanchard",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2018, 6, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 72,
         //            //StudentPersonId = 72,
         //            StateStudentIdentifier = "0046650072",
         //            FirstName = "Jolie",
         //            MiddleName = "Farrah",
         //            LastName = "Cabrera",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 8, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 73,
         //            //StudentPersonId = 73,
         //            StateStudentIdentifier = "0071336773",
         //            FirstName = "Belle",
         //            MiddleName = "Margaret",
         //            LastName = "Hardy",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 3, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 74,
         //            //StudentPersonId = 74,
         //            StateStudentIdentifier = "0055811274",
         //            FirstName = "Noelle",
         //            MiddleName = "Nichole",
         //            LastName = "Graham",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 12, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 75,
         //            //StudentPersonId = 75,
         //            StateStudentIdentifier = "0067729775",
         //            FirstName = "Gloria",
         //            MiddleName = "Doris",
         //            LastName = "Wolfe",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 1, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 76,
         //            //StudentPersonId = 76,
         //            StateStudentIdentifier = "0069603076",
         //            FirstName = "Wendy",
         //            MiddleName = "Leila",
         //            LastName = "Sims",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 12, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 77,
         //            //StudentPersonId = 77,
         //            StateStudentIdentifier = "0098786777",
         //            FirstName = "Rahim",
         //            MiddleName = "Brandon",
         //            LastName = "Nunez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 8, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 78,
         //            //StudentPersonId = 78,
         //            StateStudentIdentifier = "0057809678",
         //            FirstName = "Emerson",
         //            MiddleName = "Laurel",
         //            LastName = "Bryan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 3, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 79,
         //            //StudentPersonId = 79,
         //            StateStudentIdentifier = "0071005979",
         //            FirstName = "Bree",
         //            MiddleName = "Simone",
         //            LastName = "Thomas",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2001, 5, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 80,
         //            //StudentPersonId = 80,
         //            StateStudentIdentifier = "0086770980",
         //            FirstName = "Aristotle",
         //            MiddleName = "Tarik",
         //            LastName = "Bernard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 12, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 81,
         //            //StudentPersonId = 81,
         //            StateStudentIdentifier = "0025247581",
         //            FirstName = "Winter",
         //            MiddleName = "Amaya",
         //            LastName = "Nicholson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 1, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 82,
         //            //StudentPersonId = 82,
         //            StateStudentIdentifier = "0057345682",
         //            FirstName = "Leonard",
         //            MiddleName = "Aidan",
         //            LastName = "Dean",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2007, 5, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 83,
         //            //StudentPersonId = 83,
         //            StateStudentIdentifier = "0063958983",
         //            FirstName = "Kermit",
         //            MiddleName = "Hector",
         //            LastName = "Little",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 10, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 84,
         //            //StudentPersonId = 84,
         //            StateStudentIdentifier = "0084958284",
         //            FirstName = "Robert",
         //            MiddleName = "Driscoll",
         //            LastName = "Bolton",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2014, 10, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 85,
         //            //StudentPersonId = 85,
         //            StateStudentIdentifier = "0027683385",
         //            FirstName = "Shelly",
         //            MiddleName = "Wallace",
         //            LastName = "Britt",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2010, 2, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 86,
         //            //StudentPersonId = 86,
         //            StateStudentIdentifier = "0029540486",
         //            FirstName = "Cullen",
         //            MiddleName = "Hector",
         //            LastName = "Ball",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 3, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 87,
         //            //StudentPersonId = 87,
         //            StateStudentIdentifier = "0018245087",
         //            FirstName = "Sumanth",
         //            MiddleName = "Samson",
         //            LastName = "Schneider",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(1995, 7, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 88,
         //            //StudentPersonId = 88,
         //            StateStudentIdentifier = "0023731788",
         //            FirstName = "Patricia",
         //            MiddleName = "Blair",
         //            LastName = "Fisher",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 7, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 89,
         //            //StudentPersonId = 89,
         //            StateStudentIdentifier = "0004896689",
         //            FirstName = "Gray",
         //            MiddleName = "Dominic",
         //            LastName = "Roy",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 4, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 90,
         //            //StudentPersonId = 90,
         //            StateStudentIdentifier = "0043804890",
         //            FirstName = "Debra",
         //            MiddleName = "Maia",
         //            LastName = "Blackwell",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2008, 5, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 91,
         //            //StudentPersonId = 91,
         //            StateStudentIdentifier = "0043919191",
         //            FirstName = "Evangeline",
         //            MiddleName = "Zahir",
         //            LastName = "Gray",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 3, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 92,
         //            //StudentPersonId = 92,
         //            StateStudentIdentifier = "0042041392",
         //            FirstName = "Willow",
         //            MiddleName = "Amanda",
         //            LastName = "Patton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 10, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 93,
         //            //StudentPersonId = 93,
         //            StateStudentIdentifier = "0075006793",
         //            FirstName = "Frank",
         //            MiddleName = "Geoffrey",
         //            LastName = "Irwin",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 5, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 94,
         //            //StudentPersonId = 94,
         //            StateStudentIdentifier = "0091952694",
         //            FirstName = "Madonna",
         //            MiddleName = "Joy",
         //            LastName = "Oneal",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2016, 4, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 95,
         //            //StudentPersonId = 95,
         //            StateStudentIdentifier = "0097251895",
         //            FirstName = "Alexander",
         //            MiddleName = "Chancellor",
         //            LastName = "Walton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 5, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 96,
         //            //StudentPersonId = 96,
         //            StateStudentIdentifier = "0070026796",
         //            FirstName = "Kyle",
         //            MiddleName = "Hilel",
         //            LastName = "Davidson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 12, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 97,
         //            //StudentPersonId = 97,
         //            StateStudentIdentifier = "0018850397",
         //            FirstName = "Marcia",
         //            MiddleName = "Geraldine",
         //            LastName = "Keith",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 2, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 98,
         //            //StudentPersonId = 98,
         //            StateStudentIdentifier = "0066422298",
         //            FirstName = "Quinlan",
         //            MiddleName = "Wylie",
         //            LastName = "Clemons",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 3, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 99,
         //            //StudentPersonId = 99,
         //            StateStudentIdentifier = "0076047499",
         //            FirstName = "Xavier",
         //            MiddleName = "Ross",
         //            LastName = "Randall",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 6, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 100,
         //            //StudentPersonId = 100,
         //            StateStudentIdentifier = "0239629100",
         //            FirstName = "Rhona",
         //            MiddleName = "Venus",
         //            LastName = "Sharpe",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 7, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 101,
         //            //StudentPersonId = 101,
         //            StateStudentIdentifier = "0043465101",
         //            FirstName = "George",
         //            MiddleName = "Tad",
         //            LastName = "Lambert",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 12, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 102,
         //            //StudentPersonId = 102,
         //            StateStudentIdentifier = "0497407102",
         //            FirstName = "Galvin",
         //            MiddleName = "Francis",
         //            LastName = "Davidson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 1, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 103,
         //            //StudentPersonId = 103,
         //            StateStudentIdentifier = "0719745103",
         //            FirstName = "Vladimir",
         //            MiddleName = "Garth",
         //            LastName = "Hooper",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 11, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 104,
         //            //StudentPersonId = 104,
         //            StateStudentIdentifier = "0448934104",
         //            FirstName = "Dorian",
         //            MiddleName = "Stacy",
         //            LastName = "Morris",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 10, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 105,
         //            //StudentPersonId = 105,
         //            StateStudentIdentifier = "0575698105",
         //            FirstName = "Nissim",
         //            MiddleName = "Garrison",
         //            LastName = "Hall",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 8, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 106,
         //            //StudentPersonId = 106,
         //            StateStudentIdentifier = "0074212106",
         //            FirstName = "Connor",
         //            MiddleName = "Lance",
         //            LastName = "Salas",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 7, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 107,
         //            //StudentPersonId = 107,
         //            StateStudentIdentifier = "0097728107",
         //            FirstName = "Serena",
         //            MiddleName = "Tamekah",
         //            LastName = "Rice",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 2, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 108,
         //            //StudentPersonId = 108,
         //            StateStudentIdentifier = "0118398108",
         //            FirstName = "Graham",
         //            MiddleName = "Alec",
         //            LastName = "Arnold",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 8, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 109,
         //            //StudentPersonId = 109,
         //            StateStudentIdentifier = "0711793109",
         //            FirstName = "Sybil",
         //            MiddleName = "Christopher",
         //            LastName = "Mcgowan",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2011, 7, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 110,
         //            //StudentPersonId = 110,
         //            StateStudentIdentifier = "0167447110",
         //            FirstName = "Hunter",
         //            MiddleName = "Owen",
         //            LastName = "Burks",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2009, 4, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 111,
         //            //StudentPersonId = 111,
         //            StateStudentIdentifier = "0604827111",
         //            FirstName = "Danielle",
         //            MiddleName = "Destiny",
         //            LastName = "Woodard",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2011, 2, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 112,
         //            //StudentPersonId = 112,
         //            StateStudentIdentifier = "0072598112",
         //            FirstName = "Aladdin",
         //            MiddleName = "Ronan",
         //            LastName = "Edwards",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 2, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 113,
         //            //StudentPersonId = 113,
         //            StateStudentIdentifier = "0116652113",
         //            FirstName = "September",
         //            MiddleName = "Dana",
         //            LastName = "Dejesus",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2004, 10, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 114,
         //            //StudentPersonId = 114,
         //            StateStudentIdentifier = "0174454114",
         //            FirstName = "Sonya",
         //            MiddleName = "Joy",
         //            LastName = "Kramer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 8, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 115,
         //            //StudentPersonId = 115,
         //            StateStudentIdentifier = "0026476115",
         //            FirstName = "Mona",
         //            MiddleName = "Martena",
         //            LastName = "Riddle",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 11, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 116,
         //            //StudentPersonId = 116,
         //            StateStudentIdentifier = "0210378116",
         //            FirstName = "Hyacinth",
         //            MiddleName = "Signe",
         //            LastName = "Hancock",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2001, 7, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 117,
         //            //StudentPersonId = 117,
         //            StateStudentIdentifier = "0486529117",
         //            FirstName = "Stephen",
         //            MiddleName = "Judah",
         //            LastName = "Marsh",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 8, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 118,
         //            //StudentPersonId = 118,
         //            StateStudentIdentifier = "0881810118",
         //            FirstName = "Rana",
         //            MiddleName = "Ferris",
         //            LastName = "Compton",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 3, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 119,
         //            //StudentPersonId = 119,
         //            StateStudentIdentifier = "0598567119",
         //            FirstName = "Jocelyn",
         //            MiddleName = "Irene",
         //            LastName = "Bartlett",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 2, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 120,
         //            //StudentPersonId = 120,
         //            StateStudentIdentifier = "0799411120",
         //            FirstName = "Zoe",
         //            MiddleName = "Amy",
         //            LastName = "Rivas",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 10, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 121,
         //            //StudentPersonId = 121,
         //            StateStudentIdentifier = "0227051121",
         //            FirstName = "Cheyenne",
         //            MiddleName = "Vivien",
         //            LastName = "Tanner",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2002, 1, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 122,
         //            //StudentPersonId = 122,
         //            StateStudentIdentifier = "0846528122",
         //            FirstName = "Omar",
         //            MiddleName = "Reed",
         //            LastName = "Burton",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1996, 3, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 123,
         //            //StudentPersonId = 123,
         //            StateStudentIdentifier = "0836657123",
         //            FirstName = "Camilla",
         //            MiddleName = "Brenden",
         //            LastName = "Richmond",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 1, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 124,
         //            //StudentPersonId = 124,
         //            StateStudentIdentifier = "0681779124",
         //            FirstName = "Pearl",
         //            MiddleName = "Delilah",
         //            LastName = "Rice",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 12, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 125,
         //            //StudentPersonId = 125,
         //            StateStudentIdentifier = "0657815125",
         //            FirstName = "Brooke",
         //            MiddleName = "Aiko",
         //            LastName = "Berg",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 7, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 126,
         //            //StudentPersonId = 126,
         //            StateStudentIdentifier = "0577605126",
         //            FirstName = "Adria",
         //            MiddleName = "Yael",
         //            LastName = "Stevenson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 4, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 127,
         //            //StudentPersonId = 127,
         //            StateStudentIdentifier = "0423922127",
         //            FirstName = "Kennan",
         //            MiddleName = "Jelani",
         //            LastName = "Montgomery",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2003, 12, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 128,
         //            //StudentPersonId = 128,
         //            StateStudentIdentifier = "0262708128",
         //            FirstName = "Brennan",
         //            MiddleName = "Rogan",
         //            LastName = "Shaw",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2010, 11, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 129,
         //            //StudentPersonId = 129,
         //            StateStudentIdentifier = "0348559129",
         //            FirstName = "Martin",
         //            MiddleName = "Cooper",
         //            LastName = "Stuart",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 7, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 130,
         //            //StudentPersonId = 130,
         //            StateStudentIdentifier = "0653560130",
         //            FirstName = "Cedric",
         //            MiddleName = "Colt",
         //            LastName = "Mcmillan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 7, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 131,
         //            //StudentPersonId = 131,
         //            StateStudentIdentifier = "0343812131",
         //            FirstName = "Medge",
         //            MiddleName = "Alyssa",
         //            LastName = "Cleveland",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2006, 8, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 132,
         //            //StudentPersonId = 132,
         //            StateStudentIdentifier = "0738295132",
         //            FirstName = "Len",
         //            MiddleName = "Brock",
         //            LastName = "Golden",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2000, 4, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 133,
         //            //StudentPersonId = 133,
         //            StateStudentIdentifier = "0565879133",
         //            FirstName = "Dieter",
         //            MiddleName = "Tate",
         //            LastName = "Trevino",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 5, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 134,
         //            //StudentPersonId = 134,
         //            StateStudentIdentifier = "0771778134",
         //            FirstName = "Chadwick",
         //            MiddleName = "Arthur",
         //            LastName = "Montgomery",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 3, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 135,
         //            //StudentPersonId = 135,
         //            StateStudentIdentifier = "0017394135",
         //            FirstName = "Joshua",
         //            MiddleName = "Ryan",
         //            LastName = "Bass",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 11, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 136,
         //            //StudentPersonId = 136,
         //            StateStudentIdentifier = "0222753136",
         //            FirstName = "Stacey",
         //            MiddleName = "Whilemina",
         //            LastName = "Ramirez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 9, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 137,
         //            //StudentPersonId = 137,
         //            StateStudentIdentifier = "0775760137",
         //            FirstName = "Mariko",
         //            MiddleName = "Lillith",
         //            LastName = "Lott",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 7, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 138,
         //            //StudentPersonId = 138,
         //            StateStudentIdentifier = "0944849138",
         //            FirstName = "Lucy",
         //            MiddleName = "Xaviera",
         //            LastName = "Hopkins",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 10, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 139,
         //            //StudentPersonId = 139,
         //            StateStudentIdentifier = "0525664139",
         //            FirstName = "Tallulah",
         //            MiddleName = "Chelsea",
         //            LastName = "Delaney",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 10, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 140,
         //            //StudentPersonId = 140,
         //            StateStudentIdentifier = "0142450140",
         //            FirstName = "Gray",
         //            MiddleName = "Hoyt",
         //            LastName = "Williams",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2008, 12, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 141,
         //            //StudentPersonId = 141,
         //            StateStudentIdentifier = "0841743141",
         //            FirstName = "Deacon",
         //            MiddleName = "Stone",
         //            LastName = "Thornton",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2019, 11, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 142,
         //            //StudentPersonId = 142,
         //            StateStudentIdentifier = "0458081142",
         //            FirstName = "Rajeev",
         //            MiddleName = "Brett",
         //            LastName = "Hopper",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(1996, 3, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 143,
         //            //StudentPersonId = 143,
         //            StateStudentIdentifier = "0414448143",
         //            FirstName = "Ahmed",
         //            MiddleName = "Erich",
         //            LastName = "Bright",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2019, 5, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 144,
         //            //StudentPersonId = 144,
         //            StateStudentIdentifier = "0176347144",
         //            FirstName = "Drew",
         //            MiddleName = "Calvin",
         //            LastName = "Alston",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 9, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 145,
         //            //StudentPersonId = 145,
         //            StateStudentIdentifier = "0922527145",
         //            FirstName = "Hoyt",
         //            MiddleName = "Genevieve",
         //            LastName = "Perry",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2004, 11, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 146,
         //            //StudentPersonId = 146,
         //            StateStudentIdentifier = "0334629146",
         //            FirstName = "Claudia",
         //            MiddleName = "Lunea",
         //            LastName = "Case",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2008, 1, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 147,
         //            //StudentPersonId = 147,
         //            StateStudentIdentifier = "0541137147",
         //            FirstName = "Selma",
         //            MiddleName = "Macaulay",
         //            LastName = "Cleveland",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 9, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 148,
         //            //StudentPersonId = 148,
         //            StateStudentIdentifier = "0243243148",
         //            FirstName = "Steel",
         //            MiddleName = "Bruce",
         //            LastName = "Jefferson",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2019, 5, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 149,
         //            //StudentPersonId = 149,
         //            StateStudentIdentifier = "0474813149",
         //            FirstName = "Delilah",
         //            MiddleName = "Emerald",
         //            LastName = "Fry",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 2, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 150,
         //            //StudentPersonId = 150,
         //            StateStudentIdentifier = "0999295150",
         //            FirstName = "Alexander",
         //            MiddleName = "Bevis",
         //            LastName = "Sparks",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2009, 4, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 151,
         //            //StudentPersonId = 151,
         //            StateStudentIdentifier = "0126214151",
         //            FirstName = "Jolie",
         //            MiddleName = "Jane",
         //            LastName = "Fernandez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 1, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 152,
         //            //StudentPersonId = 152,
         //            StateStudentIdentifier = "0700167152",
         //            FirstName = "Logan",
         //            MiddleName = "Basil",
         //            LastName = "Frank",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 11, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 153,
         //            //StudentPersonId = 153,
         //            StateStudentIdentifier = "0594251153",
         //            FirstName = "Colin",
         //            MiddleName = "Callum",
         //            LastName = "Lawson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 10, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 154,
         //            //StudentPersonId = 154,
         //            StateStudentIdentifier = "0575449154",
         //            FirstName = "Bruno",
         //            MiddleName = "Grady",
         //            LastName = "Best",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 12, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 155,
         //            //StudentPersonId = 155,
         //            StateStudentIdentifier = "0191337155",
         //            FirstName = "Hiram",
         //            MiddleName = "Grady",
         //            LastName = "Bird",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(1999, 11, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 156,
         //            //StudentPersonId = 156,
         //            StateStudentIdentifier = "0097082156",
         //            FirstName = "Isaac",
         //            MiddleName = "Justin",
         //            LastName = "Stevenson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 8, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 157,
         //            //StudentPersonId = 157,
         //            StateStudentIdentifier = "0706630157",
         //            FirstName = "Amy",
         //            MiddleName = "Mohammad",
         //            LastName = "Mosley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 1, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 158,
         //            //StudentPersonId = 158,
         //            StateStudentIdentifier = "0946122158",
         //            FirstName = "Keefe",
         //            MiddleName = "Jarrod",
         //            LastName = "Tate",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 3, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 159,
         //            //StudentPersonId = 159,
         //            StateStudentIdentifier = "0528750159",
         //            FirstName = "Xyla",
         //            MiddleName = "Chastity",
         //            LastName = "Parrish",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 4, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 160,
         //            //StudentPersonId = 160,
         //            StateStudentIdentifier = "0965343160",
         //            FirstName = "Aurora",
         //            MiddleName = "Maggie",
         //            LastName = "Dominguez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 10, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 161,
         //            //StudentPersonId = 161,
         //            StateStudentIdentifier = "0612935161",
         //            FirstName = "Murphy",
         //            MiddleName = "Ian",
         //            LastName = "Oneill",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 11, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 162,
         //            //StudentPersonId = 162,
         //            StateStudentIdentifier = "0322431162",
         //            FirstName = "Jeremy",
         //            MiddleName = "Cullen",
         //            LastName = "Gilliam",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2000, 6, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 163,
         //            //StudentPersonId = 163,
         //            StateStudentIdentifier = "0681593163",
         //            FirstName = "Britanni",
         //            MiddleName = "Inga",
         //            LastName = "Whitley",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 4, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 164,
         //            //StudentPersonId = 164,
         //            StateStudentIdentifier = "0414644164",
         //            FirstName = "Ulysses",
         //            MiddleName = "Devin",
         //            LastName = "Kennedy",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2002, 12, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 165,
         //            //StudentPersonId = 165,
         //            StateStudentIdentifier = "0382445165",
         //            FirstName = "Axel",
         //            MiddleName = "Blake",
         //            LastName = "Shields",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2014, 8, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 166,
         //            //StudentPersonId = 166,
         //            StateStudentIdentifier = "0307083166",
         //            FirstName = "Tyler",
         //            MiddleName = "Lucas",
         //            LastName = "Foster",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 6, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 167,
         //            //StudentPersonId = 167,
         //            StateStudentIdentifier = "0923214167",
         //            FirstName = "Aaron",
         //            MiddleName = "Chadwick",
         //            LastName = "Dickenson",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1999, 2, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 168,
         //            //StudentPersonId = 168,
         //            StateStudentIdentifier = "0610963168",
         //            FirstName = "Ursula",
         //            MiddleName = "Lael",
         //            LastName = "Aguilar",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 11, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 169,
         //            //StudentPersonId = 169,
         //            StateStudentIdentifier = "0302672169",
         //            FirstName = "Kibo",
         //            MiddleName = "Brennan",
         //            LastName = "Fitzpatrick",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 9, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 170,
         //            //StudentPersonId = 170,
         //            StateStudentIdentifier = "0950590170",
         //            FirstName = "Channing",
         //            MiddleName = "Plato",
         //            LastName = "Thornton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 11, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 171,
         //            //StudentPersonId = 171,
         //            StateStudentIdentifier = "0328078171",
         //            FirstName = "Troy",
         //            MiddleName = "Aidan",
         //            LastName = "Harris",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2005, 1, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 172,
         //            //StudentPersonId = 172,
         //            StateStudentIdentifier = "0936869172",
         //            FirstName = "Nelle",
         //            MiddleName = "Iris",
         //            LastName = "Hogan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 4, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 173,
         //            //StudentPersonId = 173,
         //            StateStudentIdentifier = "0200143173",
         //            FirstName = "Diana",
         //            MiddleName = "Dexter",
         //            LastName = "Griffith",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 2, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 174,
         //            //StudentPersonId = 174,
         //            StateStudentIdentifier = "0038310174",
         //            FirstName = "Carla",
         //            MiddleName = "Serina",
         //            LastName = "Stafford",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2004, 8, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 175,
         //            //StudentPersonId = 175,
         //            StateStudentIdentifier = "0720847175",
         //            FirstName = "Penelope",
         //            MiddleName = "Elizabeth",
         //            LastName = "Griffin",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 4, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 176,
         //            //StudentPersonId = 176,
         //            StateStudentIdentifier = "0258922176",
         //            FirstName = "Arsenio",
         //            MiddleName = "William",
         //            LastName = "Santiago",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2008, 11, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 177,
         //            //StudentPersonId = 177,
         //            StateStudentIdentifier = "0554653177",
         //            FirstName = "Robert",
         //            MiddleName = "Arsenio",
         //            LastName = "Kim",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1995, 4, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 178,
         //            //StudentPersonId = 178,
         //            StateStudentIdentifier = "0406424178",
         //            FirstName = "Micah",
         //            MiddleName = "Mike",
         //            LastName = "Golden",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2004, 6, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 179,
         //            //StudentPersonId = 179,
         //            StateStudentIdentifier = "0270874179",
         //            FirstName = "Mercedes",
         //            MiddleName = "Patience",
         //            LastName = "Church",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1999, 12, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 180,
         //            //StudentPersonId = 180,
         //            StateStudentIdentifier = "0248808180",
         //            FirstName = "Lawrence",
         //            MiddleName = "Cruz",
         //            LastName = "Nolan",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 8, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 181,
         //            //StudentPersonId = 181,
         //            StateStudentIdentifier = "0588847181",
         //            FirstName = "Reece",
         //            MiddleName = "Tobias",
         //            LastName = "Hansen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 2, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 182,
         //            //StudentPersonId = 182,
         //            StateStudentIdentifier = "0873069182",
         //            FirstName = "Ivory",
         //            MiddleName = "Wendy",
         //            LastName = "Bradshaw",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 7, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 183,
         //            //StudentPersonId = 183,
         //            StateStudentIdentifier = "0667290183",
         //            FirstName = "Destiny",
         //            MiddleName = "Wilma",
         //            LastName = "Hopper",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1997, 1, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 184,
         //            //StudentPersonId = 184,
         //            StateStudentIdentifier = "0760093184",
         //            FirstName = "Evelyn",
         //            MiddleName = "Yuli",
         //            LastName = "Garcia",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 6, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 185,
         //            //StudentPersonId = 185,
         //            StateStudentIdentifier = "0827060185",
         //            FirstName = "Armando",
         //            MiddleName = "Nasim",
         //            LastName = "Robertson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 10, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 186,
         //            //StudentPersonId = 186,
         //            StateStudentIdentifier = "0222186186",
         //            FirstName = "Kibo",
         //            MiddleName = "Magee",
         //            LastName = "Sheppard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 11, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 187,
         //            //StudentPersonId = 187,
         //            StateStudentIdentifier = "0561566187",
         //            FirstName = "Natalie",
         //            MiddleName = "Uriel",
         //            LastName = "Pearson",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 10, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 188,
         //            //StudentPersonId = 188,
         //            StateStudentIdentifier = "0090000188",
         //            FirstName = "Lesley",
         //            MiddleName = "Neve",
         //            LastName = "Workman",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2011, 8, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 189,
         //            //StudentPersonId = 189,
         //            StateStudentIdentifier = "0289594189",
         //            FirstName = "Adrienne",
         //            MiddleName = "Gail",
         //            LastName = "Black",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2009, 4, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 190,
         //            //StudentPersonId = 190,
         //            StateStudentIdentifier = "0900217190",
         //            FirstName = "Ima",
         //            MiddleName = "Abdul",
         //            LastName = "Trujillo",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2003, 1, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 191,
         //            //StudentPersonId = 191,
         //            StateStudentIdentifier = "0110969191",
         //            FirstName = "Zachery",
         //            MiddleName = "Stone",
         //            LastName = "Dodson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 3, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 192,
         //            //StudentPersonId = 192,
         //            StateStudentIdentifier = "0844783192",
         //            FirstName = "Hayes",
         //            MiddleName = "Randall",
         //            LastName = "Blake",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 3, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 193,
         //            //StudentPersonId = 193,
         //            StateStudentIdentifier = "0263254193",
         //            FirstName = "Blaze",
         //            MiddleName = "Luke",
         //            LastName = "Singleton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 8, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 194,
         //            //StudentPersonId = 194,
         //            StateStudentIdentifier = "0620654194",
         //            FirstName = "Eve",
         //            MiddleName = "Rebecca",
         //            LastName = "Melendez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 7, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 195,
         //            //StudentPersonId = 195,
         //            StateStudentIdentifier = "0998829195",
         //            FirstName = "Jena",
         //            MiddleName = "Nina",
         //            LastName = "Stevens",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 5, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 196,
         //            //StudentPersonId = 196,
         //            StateStudentIdentifier = "0456026196",
         //            FirstName = "Ann",
         //            MiddleName = "Hyacinth",
         //            LastName = "Golden",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 3, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 197,
         //            //StudentPersonId = 197,
         //            StateStudentIdentifier = "0140887197",
         //            FirstName = "Kareem",
         //            MiddleName = "Bruno",
         //            LastName = "Cleveland",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 8, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 198,
         //            //StudentPersonId = 198,
         //            StateStudentIdentifier = "0132226198",
         //            FirstName = "Plato",
         //            MiddleName = "Oren",
         //            LastName = "Lyons",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2006, 6, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 199,
         //            //StudentPersonId = 199,
         //            StateStudentIdentifier = "0693752199",
         //            FirstName = "Armando",
         //            MiddleName = "Levi",
         //            LastName = "Macdonald",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 6, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 200,
         //            //StudentPersonId = 200,
         //            StateStudentIdentifier = "0975901200",
         //            FirstName = "Harding",
         //            MiddleName = "Adrian",
         //            LastName = "Osborn",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2013, 12, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 201,
         //            //StudentPersonId = 201,
         //            StateStudentIdentifier = "0400833201",
         //            FirstName = "Quon",
         //            MiddleName = "Whilemina",
         //            LastName = "Gray",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2013, 6, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 202,
         //            //StudentPersonId = 202,
         //            StateStudentIdentifier = "0866958202",
         //            FirstName = "Clinton",
         //            MiddleName = "Abraham",
         //            LastName = "Tyler",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 1, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 203,
         //            //StudentPersonId = 203,
         //            StateStudentIdentifier = "0883716203",
         //            FirstName = "Dylan",
         //            MiddleName = "Garth",
         //            LastName = "Maxwell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 4, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 204,
         //            //StudentPersonId = 204,
         //            StateStudentIdentifier = "0812028204",
         //            FirstName = "Lewis",
         //            MiddleName = "Samuel",
         //            LastName = "Marquez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 6, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 205,
         //            //StudentPersonId = 205,
         //            StateStudentIdentifier = "0930427205",
         //            FirstName = "Nichole",
         //            MiddleName = "Halla",
         //            LastName = "Conley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 8, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 206,
         //            //StudentPersonId = 206,
         //            StateStudentIdentifier = "0462521206",
         //            FirstName = "Rigel",
         //            MiddleName = "Eric",
         //            LastName = "Greer",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(1997, 6, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 207,
         //            //StudentPersonId = 207,
         //            StateStudentIdentifier = "0795651207",
         //            FirstName = "Ignatius",
         //            MiddleName = "Mannix",
         //            LastName = "Gregory",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 12, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 208,
         //            //StudentPersonId = 208,
         //            StateStudentIdentifier = "0406576208",
         //            FirstName = "Bethany",
         //            MiddleName = "Mia",
         //            LastName = "Welch",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2002, 10, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 209,
         //            //StudentPersonId = 209,
         //            StateStudentIdentifier = "0754452209",
         //            FirstName = "Melodie",
         //            MiddleName = "Gisela",
         //            LastName = "Fletcher",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 8, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 210,
         //            //StudentPersonId = 210,
         //            StateStudentIdentifier = "0464842210",
         //            FirstName = "Benjamin",
         //            MiddleName = "Eaton",
         //            LastName = "Banks",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2015, 12, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 211,
         //            //StudentPersonId = 211,
         //            StateStudentIdentifier = "0030048211",
         //            FirstName = "Irene",
         //            MiddleName = "Moana",
         //            LastName = "Chase",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1996, 3, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 212,
         //            //StudentPersonId = 212,
         //            StateStudentIdentifier = "0119117212",
         //            FirstName = "Willow",
         //            MiddleName = "Daphne",
         //            LastName = "Cash",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2019, 2, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 213,
         //            //StudentPersonId = 213,
         //            StateStudentIdentifier = "0813663213",
         //            FirstName = "Lars",
         //            MiddleName = "Alec",
         //            LastName = "Rodriquez",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2006, 11, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 214,
         //            //StudentPersonId = 214,
         //            StateStudentIdentifier = "0273928214",
         //            FirstName = "Jamal",
         //            MiddleName = "Connor",
         //            LastName = "Winters",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 3, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 215,
         //            //StudentPersonId = 215,
         //            StateStudentIdentifier = "0349109215",
         //            FirstName = "Darius",
         //            MiddleName = "Gareth",
         //            LastName = "Sweet",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 12, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 216,
         //            //StudentPersonId = 216,
         //            StateStudentIdentifier = "0190726216",
         //            FirstName = "Timothy",
         //            MiddleName = "Tyler",
         //            LastName = "Guthrie",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 12, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 217,
         //            //StudentPersonId = 217,
         //            StateStudentIdentifier = "0545961217",
         //            FirstName = "Leilani",
         //            MiddleName = "Pavel",
         //            LastName = "Blankenship",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 12, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 218,
         //            //StudentPersonId = 218,
         //            StateStudentIdentifier = "0278031218",
         //            FirstName = "Conan",
         //            MiddleName = "Beau",
         //            LastName = "Bolton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 3, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 219,
         //            //StudentPersonId = 219,
         //            StateStudentIdentifier = "0259441219",
         //            FirstName = "Skyler",
         //            MiddleName = "Faith",
         //            LastName = "Sherman",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2006, 1, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 220,
         //            //StudentPersonId = 220,
         //            StateStudentIdentifier = "0422620220",
         //            FirstName = "Igor",
         //            MiddleName = "Jared",
         //            LastName = "Sears",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 11, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 221,
         //            //StudentPersonId = 221,
         //            StateStudentIdentifier = "0502866221",
         //            FirstName = "Jolene",
         //            MiddleName = "Travis",
         //            LastName = "Mcdaniel",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 2, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 222,
         //            //StudentPersonId = 222,
         //            StateStudentIdentifier = "0977206222",
         //            FirstName = "Keith",
         //            MiddleName = "Craig",
         //            LastName = "Irwin",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 10, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 223,
         //            //StudentPersonId = 223,
         //            StateStudentIdentifier = "0278240223",
         //            FirstName = "Carlos",
         //            MiddleName = "Rogan",
         //            LastName = "Harding",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 7, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 224,
         //            //StudentPersonId = 224,
         //            StateStudentIdentifier = "0521730224",
         //            FirstName = "Marsden",
         //            MiddleName = "Jesse",
         //            LastName = "Blankenship",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 7, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 225,
         //            //StudentPersonId = 225,
         //            StateStudentIdentifier = "0389487225",
         //            FirstName = "Lysandra",
         //            MiddleName = "Orla",
         //            LastName = "Olsen",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2016, 9, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 226,
         //            //StudentPersonId = 226,
         //            StateStudentIdentifier = "0750550226",
         //            FirstName = "Haley",
         //            MiddleName = "Melvin",
         //            LastName = "Carney",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 8, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 227,
         //            //StudentPersonId = 227,
         //            StateStudentIdentifier = "0136549227",
         //            FirstName = "Eugenia",
         //            MiddleName = "Ishmael",
         //            LastName = "Robinson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 8, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 228,
         //            //StudentPersonId = 228,
         //            StateStudentIdentifier = "0734434228",
         //            FirstName = "Kennan",
         //            MiddleName = "Cruz",
         //            LastName = "Reeves",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 8, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 229,
         //            //StudentPersonId = 229,
         //            StateStudentIdentifier = "0067248229",
         //            FirstName = "Winter",
         //            MiddleName = "Wynne",
         //            LastName = "Floyd",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 3, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 230,
         //            //StudentPersonId = 230,
         //            StateStudentIdentifier = "0461204230",
         //            FirstName = "Wynter",
         //            MiddleName = "Lucian",
         //            LastName = "Mills",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 8, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 231,
         //            //StudentPersonId = 231,
         //            StateStudentIdentifier = "0101292231",
         //            FirstName = "Lara",
         //            MiddleName = "Rylee",
         //            LastName = "Watson",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2009, 8, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 232,
         //            //StudentPersonId = 232,
         //            StateStudentIdentifier = "0927324232",
         //            FirstName = "Illana",
         //            MiddleName = "Octavia",
         //            LastName = "Flores",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 9, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 233,
         //            //StudentPersonId = 233,
         //            StateStudentIdentifier = "0425923233",
         //            FirstName = "Brody",
         //            MiddleName = "Adrian",
         //            LastName = "Holden",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 11, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 234,
         //            //StudentPersonId = 234,
         //            StateStudentIdentifier = "0875040234",
         //            FirstName = "Germaine",
         //            MiddleName = "Minerva",
         //            LastName = "Thornton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 10, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 235,
         //            //StudentPersonId = 235,
         //            StateStudentIdentifier = "0682250235",
         //            FirstName = "Alan",
         //            MiddleName = "Samson",
         //            LastName = "Estes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 7, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 236,
         //            //StudentPersonId = 236,
         //            StateStudentIdentifier = "0084547236",
         //            FirstName = "Nash",
         //            MiddleName = "Rashad",
         //            LastName = "Koch",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 8, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 237,
         //            //StudentPersonId = 237,
         //            StateStudentIdentifier = "0363804237",
         //            FirstName = "Joel",
         //            MiddleName = "Alexander",
         //            LastName = "Pierce",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 12, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 238,
         //            //StudentPersonId = 238,
         //            StateStudentIdentifier = "0720234238",
         //            FirstName = "Guy",
         //            MiddleName = "Driscoll",
         //            LastName = "Forbes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 6, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 239,
         //            //StudentPersonId = 239,
         //            StateStudentIdentifier = "0633844239",
         //            FirstName = "Owen",
         //            MiddleName = "Lev",
         //            LastName = "King",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 5, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 240,
         //            //StudentPersonId = 240,
         //            StateStudentIdentifier = "0327835240",
         //            FirstName = "Reese",
         //            MiddleName = "Henry",
         //            LastName = "Wright",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 2, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 241,
         //            //StudentPersonId = 241,
         //            StateStudentIdentifier = "0987476241",
         //            FirstName = "Tiger",
         //            MiddleName = "Carson",
         //            LastName = "Haynes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 2, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 242,
         //            //StudentPersonId = 242,
         //            StateStudentIdentifier = "0020881242",
         //            FirstName = "Rajeev",
         //            MiddleName = "Kareem",
         //            LastName = "Tran",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 11, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 243,
         //            //StudentPersonId = 243,
         //            StateStudentIdentifier = "0459419243",
         //            FirstName = "Ayanna",
         //            MiddleName = "Pascale",
         //            LastName = "Whitehead",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 7, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 244,
         //            //StudentPersonId = 244,
         //            StateStudentIdentifier = "0104210244",
         //            FirstName = "Wylie",
         //            MiddleName = "Armando",
         //            LastName = "Mathews",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 11, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 245,
         //            //StudentPersonId = 245,
         //            StateStudentIdentifier = "0576361245",
         //            FirstName = "Jerome",
         //            MiddleName = "Slade",
         //            LastName = "Eaton",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2009, 12, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 246,
         //            //StudentPersonId = 246,
         //            StateStudentIdentifier = "0321507246",
         //            FirstName = "Xyla",
         //            MiddleName = "Carissa",
         //            LastName = "Clemons",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 10, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 247,
         //            //StudentPersonId = 247,
         //            StateStudentIdentifier = "0643213247",
         //            FirstName = "Violet",
         //            MiddleName = "Giselle",
         //            LastName = "Potts",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2020, 1, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 248,
         //            //StudentPersonId = 248,
         //            StateStudentIdentifier = "0131123248",
         //            FirstName = "Rylee",
         //            MiddleName = "Kim",
         //            LastName = "Davidson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 11, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 249,
         //            //StudentPersonId = 249,
         //            StateStudentIdentifier = "0397878249",
         //            FirstName = "Inga",
         //            MiddleName = "Britanni",
         //            LastName = "Sexton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 6, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 250,
         //            //StudentPersonId = 250,
         //            StateStudentIdentifier = "0866206250",
         //            FirstName = "Eden",
         //            MiddleName = "Sharmila",
         //            LastName = "Conway",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 11, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 251,
         //            //StudentPersonId = 251,
         //            StateStudentIdentifier = "0387957251",
         //            FirstName = "Mari",
         //            MiddleName = "Illana",
         //            LastName = "Hurley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 7, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 252,
         //            //StudentPersonId = 252,
         //            StateStudentIdentifier = "0526483252",
         //            FirstName = "Aidan",
         //            MiddleName = "Cheyenne",
         //            LastName = "Farrell",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1996, 4, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 253,
         //            //StudentPersonId = 253,
         //            StateStudentIdentifier = "0316934253",
         //            FirstName = "Priscilla",
         //            MiddleName = "Melissa",
         //            LastName = "Ferrell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 12, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 254,
         //            //StudentPersonId = 254,
         //            StateStudentIdentifier = "0356833254",
         //            FirstName = "Daniel",
         //            MiddleName = "Veronica",
         //            LastName = "Golden",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 1, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 255,
         //            //StudentPersonId = 255,
         //            StateStudentIdentifier = "0402082255",
         //            FirstName = "David",
         //            MiddleName = "Aurelia",
         //            LastName = "Mercado",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 11, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 256,
         //            //StudentPersonId = 256,
         //            StateStudentIdentifier = "0992122256",
         //            FirstName = "Hayfa",
         //            MiddleName = "Germane",
         //            LastName = "Jenkins",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 10, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 257,
         //            //StudentPersonId = 257,
         //            StateStudentIdentifier = "0718387257",
         //            FirstName = "Justin",
         //            MiddleName = "Sylvester",
         //            LastName = "Fitzgerald",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1999, 4, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 258,
         //            //StudentPersonId = 258,
         //            StateStudentIdentifier = "0809130258",
         //            FirstName = "Jena",
         //            MiddleName = "Elvis",
         //            LastName = "Calhoun",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2008, 6, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 259,
         //            //StudentPersonId = 259,
         //            StateStudentIdentifier = "0931162259",
         //            FirstName = "Troy",
         //            MiddleName = "Damian",
         //            LastName = "Stevens",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 5, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 260,
         //            //StudentPersonId = 260,
         //            StateStudentIdentifier = "0360560260",
         //            FirstName = "Ima",
         //            MiddleName = "Fay",
         //            LastName = "Fowler",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2001, 1, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 261,
         //            //StudentPersonId = 261,
         //            StateStudentIdentifier = "0922022261",
         //            FirstName = "Willow",
         //            MiddleName = "Margaret",
         //            LastName = "Fisher",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 7, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 262,
         //            //StudentPersonId = 262,
         //            StateStudentIdentifier = "0643503262",
         //            FirstName = "Jameson",
         //            MiddleName = "Scott",
         //            LastName = "Booth",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 12, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 263,
         //            //StudentPersonId = 263,
         //            StateStudentIdentifier = "0915763263",
         //            FirstName = "Irene",
         //            MiddleName = "Anjolie",
         //            LastName = "Hewitt",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 10, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 264,
         //            //StudentPersonId = 264,
         //            StateStudentIdentifier = "0351252264",
         //            FirstName = "Quamar",
         //            MiddleName = "Keaton",
         //            LastName = "Franklin",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 7, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 265,
         //            //StudentPersonId = 265,
         //            StateStudentIdentifier = "0301606265",
         //            FirstName = "Shaine",
         //            MiddleName = "Guinevere",
         //            LastName = "Roberson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 12, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 266,
         //            //StudentPersonId = 266,
         //            StateStudentIdentifier = "0140772266",
         //            FirstName = "Emerson",
         //            MiddleName = "Tyrone",
         //            LastName = "Berg",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2011, 7, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 267,
         //            //StudentPersonId = 267,
         //            StateStudentIdentifier = "0030764267",
         //            FirstName = "Cody",
         //            MiddleName = "Xyla",
         //            LastName = "Floyd",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 9, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 268,
         //            //StudentPersonId = 268,
         //            StateStudentIdentifier = "0197916268",
         //            FirstName = "Kalia",
         //            MiddleName = "Dara",
         //            LastName = "Sanford",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 3, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 269,
         //            //StudentPersonId = 269,
         //            StateStudentIdentifier = "0299578269",
         //            FirstName = "Catherine",
         //            MiddleName = "Penelope",
         //            LastName = "Cash",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2010, 4, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 270,
         //            //StudentPersonId = 270,
         //            StateStudentIdentifier = "0684976270",
         //            FirstName = "Demetrius",
         //            MiddleName = "Edward",
         //            LastName = "Griffin",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2013, 2, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 271,
         //            //StudentPersonId = 271,
         //            StateStudentIdentifier = "0832299271",
         //            FirstName = "Cody",
         //            MiddleName = "Nehru",
         //            LastName = "York",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2008, 10, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 272,
         //            //StudentPersonId = 272,
         //            StateStudentIdentifier = "0376557272",
         //            FirstName = "Angelica",
         //            MiddleName = "Zoe",
         //            LastName = "Gutierrez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 3, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 273,
         //            //StudentPersonId = 273,
         //            StateStudentIdentifier = "0491703273",
         //            FirstName = "Zia",
         //            MiddleName = "Gay",
         //            LastName = "Cash",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 9, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 274,
         //            //StudentPersonId = 274,
         //            StateStudentIdentifier = "0186562274",
         //            FirstName = "Camilla",
         //            MiddleName = "Irene",
         //            LastName = "Hopper",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 7, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 275,
         //            //StudentPersonId = 275,
         //            StateStudentIdentifier = "0592575275",
         //            FirstName = "Gloria",
         //            MiddleName = "Doris",
         //            LastName = "Farrell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 6, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 276,
         //            //StudentPersonId = 276,
         //            StateStudentIdentifier = "0764608276",
         //            FirstName = "Zachery",
         //            MiddleName = "Henry",
         //            LastName = "Underwood",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 7, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 277,
         //            //StudentPersonId = 277,
         //            StateStudentIdentifier = "0714393277",
         //            FirstName = "Jane",
         //            MiddleName = "Sasha",
         //            LastName = "Sears",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 9, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 278,
         //            //StudentPersonId = 278,
         //            StateStudentIdentifier = "0888232278",
         //            FirstName = "Amery",
         //            MiddleName = "Douglas",
         //            LastName = "Osborn",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 8, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 279,
         //            //StudentPersonId = 279,
         //            StateStudentIdentifier = "0379707279",
         //            FirstName = "Conan",
         //            MiddleName = "Gary",
         //            LastName = "Davis",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 3, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 280,
         //            //StudentPersonId = 280,
         //            StateStudentIdentifier = "0708703280",
         //            FirstName = "Adam",
         //            MiddleName = "Alan",
         //            LastName = "Washington",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 2, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 281,
         //            //StudentPersonId = 281,
         //            StateStudentIdentifier = "0654302281",
         //            FirstName = "Mohammad",
         //            MiddleName = "Reuben",
         //            LastName = "Mercer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 5, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 282,
         //            //StudentPersonId = 282,
         //            StateStudentIdentifier = "0618135282",
         //            FirstName = "Brock",
         //            MiddleName = "Hayes",
         //            LastName = "Davis",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1999, 7, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 283,
         //            //StudentPersonId = 283,
         //            StateStudentIdentifier = "0034812283",
         //            FirstName = "Dana",
         //            MiddleName = "Renee",
         //            LastName = "Banks",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2006, 3, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 284,
         //            //StudentPersonId = 284,
         //            StateStudentIdentifier = "0848939284",
         //            FirstName = "Macey",
         //            MiddleName = "Jena",
         //            LastName = "Berg",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 7, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 285,
         //            //StudentPersonId = 285,
         //            StateStudentIdentifier = "0771656285",
         //            FirstName = "Arthur",
         //            MiddleName = "Omar",
         //            LastName = "Fitzgerald",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 5, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 286,
         //            //StudentPersonId = 286,
         //            StateStudentIdentifier = "0261941286",
         //            FirstName = "Paloma",
         //            MiddleName = "Dorothy",
         //            LastName = "Jarvis",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 6, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 287,
         //            //StudentPersonId = 287,
         //            StateStudentIdentifier = "0233960287",
         //            FirstName = "Jason",
         //            MiddleName = "Martin",
         //            LastName = "Moody",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1995, 3, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 288,
         //            //StudentPersonId = 288,
         //            StateStudentIdentifier = "0200725288",
         //            FirstName = "Iliana",
         //            MiddleName = "Dakota",
         //            LastName = "Jackson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 4, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 289,
         //            //StudentPersonId = 289,
         //            StateStudentIdentifier = "0121463289",
         //            FirstName = "Sumanth",
         //            MiddleName = "Quail",
         //            LastName = "Cash",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2001, 7, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 290,
         //            //StudentPersonId = 290,
         //            StateStudentIdentifier = "0507695290",
         //            FirstName = "Lucy",
         //            MiddleName = "Amaya",
         //            LastName = "Shaw",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 1, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 291,
         //            //StudentPersonId = 291,
         //            StateStudentIdentifier = "0080421291",
         //            FirstName = "Ebony",
         //            MiddleName = "Yoko",
         //            LastName = "Russo",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 6, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 292,
         //            //StudentPersonId = 292,
         //            StateStudentIdentifier = "0002211292",
         //            FirstName = "Dieter",
         //            MiddleName = "Barclay",
         //            LastName = "Rosario",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2001, 11, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 293,
         //            //StudentPersonId = 293,
         //            StateStudentIdentifier = "0284677293",
         //            FirstName = "Mohammad",
         //            MiddleName = "Vance",
         //            LastName = "Greer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 7, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 294,
         //            //StudentPersonId = 294,
         //            StateStudentIdentifier = "0811056294",
         //            FirstName = "Sasha",
         //            MiddleName = "Faith",
         //            LastName = "Hood",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 6, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 295,
         //            //StudentPersonId = 295,
         //            StateStudentIdentifier = "0767125295",
         //            FirstName = "August",
         //            MiddleName = "Lance",
         //            LastName = "Joseph",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 8, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 296,
         //            //StudentPersonId = 296,
         //            StateStudentIdentifier = "0162633296",
         //            FirstName = "Rudyard",
         //            MiddleName = "Ulysses",
         //            LastName = "Franco",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2016, 10, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 297,
         //            //StudentPersonId = 297,
         //            StateStudentIdentifier = "0487735297",
         //            FirstName = "Jamal",
         //            MiddleName = "Nero",
         //            LastName = "Nolan",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2007, 12, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 298,
         //            //StudentPersonId = 298,
         //            StateStudentIdentifier = "0769958298",
         //            FirstName = "Mira",
         //            MiddleName = "Rosalyn",
         //            LastName = "Conway",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 8, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 299,
         //            //StudentPersonId = 299,
         //            StateStudentIdentifier = "0534875299",
         //            FirstName = "Katell",
         //            MiddleName = "Zenia",
         //            LastName = "Keith",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2009, 12, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 300,
         //            //StudentPersonId = 300,
         //            StateStudentIdentifier = "0301080300",
         //            FirstName = "Sebastian",
         //            MiddleName = "Ocean",
         //            LastName = "Whitley",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2004, 5, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 301,
         //            //StudentPersonId = 301,
         //            StateStudentIdentifier = "0138266301",
         //            FirstName = "Michelle",
         //            MiddleName = "Gage",
         //            LastName = "Potter",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2008, 8, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 302,
         //            //StudentPersonId = 302,
         //            StateStudentIdentifier = "0117330302",
         //            FirstName = "Martina",
         //            MiddleName = "Erasmus",
         //            LastName = "Ochoa",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 6, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 303,
         //            //StudentPersonId = 303,
         //            StateStudentIdentifier = "0669489303",
         //            FirstName = "Idona",
         //            MiddleName = "Piper",
         //            LastName = "Park",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 12, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 304,
         //            //StudentPersonId = 304,
         //            StateStudentIdentifier = "0161072304",
         //            FirstName = "Kyle",
         //            MiddleName = "Jamal",
         //            LastName = "Alston",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 7, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 305,
         //            //StudentPersonId = 305,
         //            StateStudentIdentifier = "0020128305",
         //            FirstName = "Josiah",
         //            MiddleName = "Zephania",
         //            LastName = "Nicholson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 10, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 306,
         //            //StudentPersonId = 306,
         //            StateStudentIdentifier = "0617790306",
         //            FirstName = "Francesca",
         //            MiddleName = "Phoebe",
         //            LastName = "Hernandez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 5, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 307,
         //            //StudentPersonId = 307,
         //            StateStudentIdentifier = "0477597307",
         //            FirstName = "Kim",
         //            MiddleName = "Xyla",
         //            LastName = "Morales",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2007, 9, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 308,
         //            //StudentPersonId = 308,
         //            StateStudentIdentifier = "0596980308",
         //            FirstName = "Clinton",
         //            MiddleName = "Brent",
         //            LastName = "Odonnell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 5, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 309,
         //            //StudentPersonId = 309,
         //            StateStudentIdentifier = "0769059309",
         //            FirstName = "Mason",
         //            MiddleName = "Lamar",
         //            LastName = "Snow",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 3, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 310,
         //            //StudentPersonId = 310,
         //            StateStudentIdentifier = "0491473310",
         //            FirstName = "Inez",
         //            MiddleName = "Blair",
         //            LastName = "Massey",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2002, 9, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 311,
         //            //StudentPersonId = 311,
         //            StateStudentIdentifier = "0950285311",
         //            FirstName = "Fay",
         //            MiddleName = "Hilel",
         //            LastName = "Mack",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 8, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 312,
         //            //StudentPersonId = 312,
         //            StateStudentIdentifier = "0453781312",
         //            FirstName = "Vivien",
         //            MiddleName = "Alfreda",
         //            LastName = "Berg",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 6, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 313,
         //            //StudentPersonId = 313,
         //            StateStudentIdentifier = "0933058313",
         //            FirstName = "Sophia",
         //            MiddleName = "Brianna",
         //            LastName = "Henderson",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 10, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 314,
         //            //StudentPersonId = 314,
         //            StateStudentIdentifier = "0974963314",
         //            FirstName = "Ronan",
         //            MiddleName = "Allen",
         //            LastName = "Reyes",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2006, 4, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 315,
         //            //StudentPersonId = 315,
         //            StateStudentIdentifier = "0130157315",
         //            FirstName = "Chiquita",
         //            MiddleName = "Kay",
         //            LastName = "Marsh",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 7, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 316,
         //            //StudentPersonId = 316,
         //            StateStudentIdentifier = "0734688316",
         //            FirstName = "Hashim",
         //            MiddleName = "Cyrus",
         //            LastName = "Watson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 1, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 317,
         //            //StudentPersonId = 317,
         //            StateStudentIdentifier = "0756033317",
         //            FirstName = "Lisandra",
         //            MiddleName = "Tamekah",
         //            LastName = "Hendricks",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 10, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 318,
         //            //StudentPersonId = 318,
         //            StateStudentIdentifier = "0518647318",
         //            FirstName = "Amela",
         //            MiddleName = "Keely",
         //            LastName = "Hooper",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 12, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 319,
         //            //StudentPersonId = 319,
         //            StateStudentIdentifier = "0665371319",
         //            FirstName = "Octavia",
         //            MiddleName = "Louis",
         //            LastName = "Conley",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2001, 12, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 320,
         //            //StudentPersonId = 320,
         //            StateStudentIdentifier = "0601498320",
         //            FirstName = "Cooper",
         //            MiddleName = "Conan",
         //            LastName = "Bush",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 7, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 321,
         //            //StudentPersonId = 321,
         //            StateStudentIdentifier = "0332927321",
         //            FirstName = "September",
         //            MiddleName = "Aileen",
         //            LastName = "Dawson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 4, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 322,
         //            //StudentPersonId = 322,
         //            StateStudentIdentifier = "0508467322",
         //            FirstName = "Chancellor",
         //            MiddleName = "Aspen",
         //            LastName = "Robertson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 1, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 323,
         //            //StudentPersonId = 323,
         //            StateStudentIdentifier = "0835823323",
         //            FirstName = "Melyssa",
         //            MiddleName = "Roary",
         //            LastName = "Jensen",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1999, 7, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 324,
         //            //StudentPersonId = 324,
         //            StateStudentIdentifier = "0138439324",
         //            FirstName = "Marshall",
         //            MiddleName = "Akeem",
         //            LastName = "Golden",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 2, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 325,
         //            //StudentPersonId = 325,
         //            StateStudentIdentifier = "0494480325",
         //            FirstName = "Althea",
         //            MiddleName = "Hedley",
         //            LastName = "Petersen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 6, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 326,
         //            //StudentPersonId = 326,
         //            StateStudentIdentifier = "0639846326",
         //            FirstName = "Rajah",
         //            MiddleName = "Curran",
         //            LastName = "Hendricks",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 10, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 327,
         //            //StudentPersonId = 327,
         //            StateStudentIdentifier = "0283278327",
         //            FirstName = "Samuel",
         //            MiddleName = "Emery",
         //            LastName = "Turner",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2000, 9, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 328,
         //            //StudentPersonId = 328,
         //            StateStudentIdentifier = "0538893328",
         //            FirstName = "Emi",
         //            MiddleName = "Beatrice",
         //            LastName = "Fitzgerald",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 1, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 329,
         //            //StudentPersonId = 329,
         //            StateStudentIdentifier = "0317233329",
         //            FirstName = "Daniel",
         //            MiddleName = "Hayden",
         //            LastName = "Ryan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 2, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 330,
         //            //StudentPersonId = 330,
         //            StateStudentIdentifier = "0990340330",
         //            FirstName = "Rogan",
         //            MiddleName = "Kennan",
         //            LastName = "Black",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 3, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 331,
         //            //StudentPersonId = 331,
         //            StateStudentIdentifier = "0772788331",
         //            FirstName = "Shea",
         //            MiddleName = "Willow",
         //            LastName = "Sherman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 11, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 332,
         //            //StudentPersonId = 332,
         //            StateStudentIdentifier = "0815588332",
         //            FirstName = "Connor",
         //            MiddleName = "Erich",
         //            LastName = "Lee",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 10, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 333,
         //            //StudentPersonId = 333,
         //            StateStudentIdentifier = "0186988333",
         //            FirstName = "Fay",
         //            MiddleName = "Illana",
         //            LastName = "Mack",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 10, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 334,
         //            //StudentPersonId = 334,
         //            StateStudentIdentifier = "0030042334",
         //            FirstName = "Natalie",
         //            MiddleName = "Imogene",
         //            LastName = "Wilcox",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 8, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 335,
         //            //StudentPersonId = 335,
         //            StateStudentIdentifier = "0654127335",
         //            FirstName = "Carly",
         //            MiddleName = "Mariko",
         //            LastName = "Stokes",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1995, 10, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 336,
         //            //StudentPersonId = 336,
         //            StateStudentIdentifier = "0269493336",
         //            FirstName = "Jordan",
         //            MiddleName = "Scarlett",
         //            LastName = "Marsh",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 5, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 337,
         //            //StudentPersonId = 337,
         //            StateStudentIdentifier = "0756457337",
         //            FirstName = "Patrick",
         //            MiddleName = "Emmanuel",
         //            LastName = "Banks",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 6, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 338,
         //            //StudentPersonId = 338,
         //            StateStudentIdentifier = "0855187338",
         //            FirstName = "Baker",
         //            MiddleName = "Rhea",
         //            LastName = "Woods",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 8, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 339,
         //            //StudentPersonId = 339,
         //            StateStudentIdentifier = "0149654339",
         //            FirstName = "Robin",
         //            MiddleName = "Ezra",
         //            LastName = "Merritt",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 6, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 340,
         //            //StudentPersonId = 340,
         //            StateStudentIdentifier = "0609615340",
         //            FirstName = "Ginger",
         //            MiddleName = "Bertha",
         //            LastName = "Gay",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 9, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 341,
         //            //StudentPersonId = 341,
         //            StateStudentIdentifier = "0123535341",
         //            FirstName = "Cade",
         //            MiddleName = "Hiram",
         //            LastName = "Christensen",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1998, 8, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 342,
         //            //StudentPersonId = 342,
         //            StateStudentIdentifier = "0173030342",
         //            FirstName = "Keefe",
         //            MiddleName = "Macaulay",
         //            LastName = "Mcdaniel",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 11, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 343,
         //            //StudentPersonId = 343,
         //            StateStudentIdentifier = "0713658343",
         //            FirstName = "Fleur",
         //            MiddleName = "Cara",
         //            LastName = "Barlow",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1999, 8, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 344,
         //            //StudentPersonId = 344,
         //            StateStudentIdentifier = "0744162344",
         //            FirstName = "Caleb",
         //            MiddleName = "Tarik",
         //            LastName = "Mooney",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 12, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 345,
         //            //StudentPersonId = 345,
         //            StateStudentIdentifier = "0614679345",
         //            FirstName = "Macy",
         //            MiddleName = "Vielka",
         //            LastName = "Velazquez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 3, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 346,
         //            //StudentPersonId = 346,
         //            StateStudentIdentifier = "0036060346",
         //            FirstName = "Lilah",
         //            MiddleName = "Mari",
         //            LastName = "Walker",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 3, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 347,
         //            //StudentPersonId = 347,
         //            StateStudentIdentifier = "0362446347",
         //            FirstName = "Damian",
         //            MiddleName = "Deacon",
         //            LastName = "Pearson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 7, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 348,
         //            //StudentPersonId = 348,
         //            StateStudentIdentifier = "0068316348",
         //            FirstName = "Ezra",
         //            MiddleName = "Baxter",
         //            LastName = "Ferrell",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2016, 3, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 349,
         //            //StudentPersonId = 349,
         //            StateStudentIdentifier = "0742603349",
         //            FirstName = "Jessabelle",
         //            MiddleName = "Dora",
         //            LastName = "Michael",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2005, 7, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 350,
         //            //StudentPersonId = 350,
         //            StateStudentIdentifier = "0546190350",
         //            FirstName = "Raphael",
         //            MiddleName = "Yardley",
         //            LastName = "Stokes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 2, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 351,
         //            //StudentPersonId = 351,
         //            StateStudentIdentifier = "0468522351",
         //            FirstName = "Emi",
         //            MiddleName = "Carolyn",
         //            LastName = "Farrell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 11, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 352,
         //            //StudentPersonId = 352,
         //            StateStudentIdentifier = "0710113352",
         //            FirstName = "Talon",
         //            MiddleName = "Felix",
         //            LastName = "Stokes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 3, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 353,
         //            //StudentPersonId = 353,
         //            StateStudentIdentifier = "0492055353",
         //            FirstName = "Wyatt",
         //            MiddleName = "Reece",
         //            LastName = "Gutierrez",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2015, 10, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 354,
         //            //StudentPersonId = 354,
         //            StateStudentIdentifier = "0300141354",
         //            FirstName = "Caleb",
         //            MiddleName = "Hiram",
         //            LastName = "Moon",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2013, 6, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 355,
         //            //StudentPersonId = 355,
         //            StateStudentIdentifier = "0353297355",
         //            FirstName = "Willow",
         //            MiddleName = "Alea",
         //            LastName = "Booth",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1998, 12, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 356,
         //            //StudentPersonId = 356,
         //            StateStudentIdentifier = "0927342356",
         //            FirstName = "Hamilton",
         //            MiddleName = "Bevis",
         //            LastName = "Schwartz",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 4, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 357,
         //            //StudentPersonId = 357,
         //            StateStudentIdentifier = "0029161357",
         //            FirstName = "Ray",
         //            MiddleName = "Erasmus",
         //            LastName = "Forbes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 8, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 358,
         //            //StudentPersonId = 358,
         //            StateStudentIdentifier = "0842331358",
         //            FirstName = "Brent",
         //            MiddleName = "Lilah",
         //            LastName = "Briggs",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1999, 6, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 359,
         //            //StudentPersonId = 359,
         //            StateStudentIdentifier = "0559167359",
         //            FirstName = "Renee",
         //            MiddleName = "Quinn",
         //            LastName = "Guthrie",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 8, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 360,
         //            //StudentPersonId = 360,
         //            StateStudentIdentifier = "0979379360",
         //            FirstName = "Berk",
         //            MiddleName = "Xyla",
         //            LastName = "Simon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 11, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 361,
         //            //StudentPersonId = 361,
         //            StateStudentIdentifier = "0388995361",
         //            FirstName = "Craig",
         //            MiddleName = "Marvin",
         //            LastName = "Hernandez",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2015, 10, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 362,
         //            //StudentPersonId = 362,
         //            StateStudentIdentifier = "0677927362",
         //            FirstName = "Zephania",
         //            MiddleName = "Armando",
         //            LastName = "Craig",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 9, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 363,
         //            //StudentPersonId = 363,
         //            StateStudentIdentifier = "0948628363",
         //            FirstName = "Joshua",
         //            MiddleName = "Griffin",
         //            LastName = "Bass",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2018, 3, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 364,
         //            //StudentPersonId = 364,
         //            StateStudentIdentifier = "0890291364",
         //            FirstName = "Callum",
         //            MiddleName = "Lance",
         //            LastName = "Hess",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 8, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 365,
         //            //StudentPersonId = 365,
         //            StateStudentIdentifier = "0079424365",
         //            FirstName = "Charde",
         //            MiddleName = "Zenia",
         //            LastName = "Wise",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 7, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 366,
         //            //StudentPersonId = 366,
         //            StateStudentIdentifier = "0743825366",
         //            FirstName = "Cherokee",
         //            MiddleName = "Ivory",
         //            LastName = "Schneider",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(1997, 11, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 367,
         //            //StudentPersonId = 367,
         //            StateStudentIdentifier = "0764581367",
         //            FirstName = "Juliet",
         //            MiddleName = "Rinah",
         //            LastName = "Harris",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2013, 8, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 368,
         //            //StudentPersonId = 368,
         //            StateStudentIdentifier = "0996349368",
         //            FirstName = "Edward",
         //            MiddleName = "Macaulay",
         //            LastName = "Lott",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2016, 12, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 369,
         //            //StudentPersonId = 369,
         //            StateStudentIdentifier = "0494469369",
         //            FirstName = "William",
         //            MiddleName = "Paul",
         //            LastName = "Reynolds",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2016, 12, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 370,
         //            //StudentPersonId = 370,
         //            StateStudentIdentifier = "0253662370",
         //            FirstName = "Matthew",
         //            MiddleName = "Jarrod",
         //            LastName = "Guzman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 6, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 371,
         //            //StudentPersonId = 371,
         //            StateStudentIdentifier = "0534249371",
         //            FirstName = "Colby",
         //            MiddleName = "George",
         //            LastName = "Lane",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2002, 10, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 372,
         //            //StudentPersonId = 372,
         //            StateStudentIdentifier = "0911393372",
         //            FirstName = "Shaeleigh",
         //            MiddleName = "Bethany",
         //            LastName = "Paul",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2017, 9, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 373,
         //            //StudentPersonId = 373,
         //            StateStudentIdentifier = "0113112373",
         //            FirstName = "Tasha",
         //            MiddleName = "Adria",
         //            LastName = "Salazar",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 7, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 374,
         //            //StudentPersonId = 374,
         //            StateStudentIdentifier = "0448752374",
         //            FirstName = "Frances",
         //            MiddleName = "Dacey",
         //            LastName = "Marshall",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2006, 12, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 375,
         //            //StudentPersonId = 375,
         //            StateStudentIdentifier = "0602072375",
         //            FirstName = "Colin",
         //            MiddleName = "Enrique",
         //            LastName = "May",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2002, 11, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 376,
         //            //StudentPersonId = 376,
         //            StateStudentIdentifier = "0858607376",
         //            FirstName = "Julie",
         //            MiddleName = "Aspen",
         //            LastName = "Curtis",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 3, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 377,
         //            //StudentPersonId = 377,
         //            StateStudentIdentifier = "0621951377",
         //            FirstName = "Gray",
         //            MiddleName = "Erich",
         //            LastName = "Michael",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2000, 1, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 378,
         //            //StudentPersonId = 378,
         //            StateStudentIdentifier = "0694001378",
         //            FirstName = "Emerald",
         //            MiddleName = "Jillian",
         //            LastName = "Marsh",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2015, 3, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 379,
         //            //StudentPersonId = 379,
         //            StateStudentIdentifier = "0261168379",
         //            FirstName = "Aubrey",
         //            MiddleName = "Buckminster",
         //            LastName = "Orr",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 3, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 380,
         //            //StudentPersonId = 380,
         //            StateStudentIdentifier = "0217692380",
         //            FirstName = "Darrel",
         //            MiddleName = "Sharon",
         //            LastName = "Zamora",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 10, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 381,
         //            //StudentPersonId = 381,
         //            StateStudentIdentifier = "0115923381",
         //            FirstName = "Dexter",
         //            MiddleName = "Dara",
         //            LastName = "Mcgee",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 5, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 382,
         //            //StudentPersonId = 382,
         //            StateStudentIdentifier = "0000540382",
         //            FirstName = "Erin",
         //            MiddleName = "Katelyn",
         //            LastName = "Vinson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 1, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 383,
         //            //StudentPersonId = 383,
         //            StateStudentIdentifier = "0796693383",
         //            FirstName = "Preston",
         //            MiddleName = "Jelani",
         //            LastName = "Weaver",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 8, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 384,
         //            //StudentPersonId = 384,
         //            StateStudentIdentifier = "0555182384",
         //            FirstName = "Pearl",
         //            MiddleName = "Sara",
         //            LastName = "Britt",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 8, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 385,
         //            //StudentPersonId = 385,
         //            StateStudentIdentifier = "0950772385",
         //            FirstName = "Dale",
         //            MiddleName = "Emily",
         //            LastName = "Dickson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 6, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 386,
         //            //StudentPersonId = 386,
         //            StateStudentIdentifier = "0105169386",
         //            FirstName = "Germane",
         //            MiddleName = "Rhoda",
         //            LastName = "Mercer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 4, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 387,
         //            //StudentPersonId = 387,
         //            StateStudentIdentifier = "0287275387",
         //            FirstName = "Thane",
         //            MiddleName = "Zeph",
         //            LastName = "Park",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 12, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 388,
         //            //StudentPersonId = 388,
         //            StateStudentIdentifier = "0906482388",
         //            FirstName = "Michael",
         //            MiddleName = "Gregory",
         //            LastName = "Macdonald",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 7, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 389,
         //            //StudentPersonId = 389,
         //            StateStudentIdentifier = "0398763389",
         //            FirstName = "Ariel",
         //            MiddleName = "Hedy",
         //            LastName = "Yates",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2019, 5, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 390,
         //            //StudentPersonId = 390,
         //            StateStudentIdentifier = "0819804390",
         //            FirstName = "Burke",
         //            MiddleName = "Reese",
         //            LastName = "Burks",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 7, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 391,
         //            //StudentPersonId = 391,
         //            StateStudentIdentifier = "0411405391",
         //            FirstName = "Anthony",
         //            MiddleName = "Vivien",
         //            LastName = "Manning",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 11, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 392,
         //            //StudentPersonId = 392,
         //            StateStudentIdentifier = "0766223392",
         //            FirstName = "Rudyard",
         //            MiddleName = "Marny",
         //            LastName = "Price",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 3, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 393,
         //            //StudentPersonId = 393,
         //            StateStudentIdentifier = "0293685393",
         //            FirstName = "Kenneth",
         //            MiddleName = "Britanni",
         //            LastName = "Harding",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 9, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 394,
         //            //StudentPersonId = 394,
         //            StateStudentIdentifier = "0735325394",
         //            FirstName = "Derek",
         //            MiddleName = "Steven",
         //            LastName = "Hubbard",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2005, 11, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 395,
         //            //StudentPersonId = 395,
         //            StateStudentIdentifier = "0288511395",
         //            FirstName = "Nigel",
         //            MiddleName = "Rhea",
         //            LastName = "Henry",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 10, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 396,
         //            //StudentPersonId = 396,
         //            StateStudentIdentifier = "0929478396",
         //            FirstName = "Evangeline",
         //            MiddleName = "Nomlanga",
         //            LastName = "Blake",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2002, 6, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 397,
         //            //StudentPersonId = 397,
         //            StateStudentIdentifier = "0285195397",
         //            FirstName = "Clinton",
         //            MiddleName = "Lucian",
         //            LastName = "Ochoa",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2012, 1, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 398,
         //            //StudentPersonId = 398,
         //            StateStudentIdentifier = "0636079398",
         //            FirstName = "Luke",
         //            MiddleName = "Zahir",
         //            LastName = "Stuart",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 7, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 399,
         //            //StudentPersonId = 399,
         //            StateStudentIdentifier = "0560069399",
         //            FirstName = "Ray",
         //            MiddleName = "Kenyon",
         //            LastName = "Rocha",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2014, 10, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 400,
         //            //StudentPersonId = 400,
         //            StateStudentIdentifier = "0762822400",
         //            FirstName = "Molly",
         //            MiddleName = "Otto",
         //            LastName = "Alston",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 2, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 401,
         //            //StudentPersonId = 401,
         //            StateStudentIdentifier = "0954775401",
         //            FirstName = "Kennan",
         //            MiddleName = "Cairo",
         //            LastName = "Gutierrez",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 3, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 402,
         //            //StudentPersonId = 402,
         //            StateStudentIdentifier = "0918229402",
         //            FirstName = "Alana",
         //            MiddleName = "Charity",
         //            LastName = "Jones",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 1, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 403,
         //            //StudentPersonId = 403,
         //            StateStudentIdentifier = "0986451403",
         //            FirstName = "Axel",
         //            MiddleName = "Colorado",
         //            LastName = "Bryant",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 11, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 404,
         //            //StudentPersonId = 404,
         //            StateStudentIdentifier = "0116298404",
         //            FirstName = "Gay",
         //            MiddleName = "Bertha",
         //            LastName = "Reed",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 5, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 405,
         //            //StudentPersonId = 405,
         //            StateStudentIdentifier = "0848552405",
         //            FirstName = "Todd",
         //            MiddleName = "Hakeem",
         //            LastName = "Abbott",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 7, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 406,
         //            //StudentPersonId = 406,
         //            StateStudentIdentifier = "0805621406",
         //            FirstName = "Zeph",
         //            MiddleName = "Stephen",
         //            LastName = "David",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 5, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 407,
         //            //StudentPersonId = 407,
         //            StateStudentIdentifier = "0585788407",
         //            FirstName = "Alyssa",
         //            MiddleName = "Libby",
         //            LastName = "Mooney",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 8, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 408,
         //            //StudentPersonId = 408,
         //            StateStudentIdentifier = "0241761408",
         //            FirstName = "Britanni",
         //            MiddleName = "Chloe",
         //            LastName = "Holland",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 11, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 409,
         //            //StudentPersonId = 409,
         //            StateStudentIdentifier = "0435721409",
         //            FirstName = "Lois",
         //            MiddleName = "Amy",
         //            LastName = "Riddle",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 12, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 410,
         //            //StudentPersonId = 410,
         //            StateStudentIdentifier = "0022436410",
         //            FirstName = "Noelle",
         //            MiddleName = "Wesley",
         //            LastName = "Rodriguez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 9, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 411,
         //            //StudentPersonId = 411,
         //            StateStudentIdentifier = "0887829411",
         //            FirstName = "Ila",
         //            MiddleName = "Yoko",
         //            LastName = "Dawson",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2005, 6, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 412,
         //            //StudentPersonId = 412,
         //            StateStudentIdentifier = "0749726412",
         //            FirstName = "Rebecca",
         //            MiddleName = "Isaiah",
         //            LastName = "Randolph",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 8, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 413,
         //            //StudentPersonId = 413,
         //            StateStudentIdentifier = "0200791413",
         //            FirstName = "Dexter",
         //            MiddleName = "Xantha",
         //            LastName = "Stout",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2004, 2, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 414,
         //            //StudentPersonId = 414,
         //            StateStudentIdentifier = "0396319414",
         //            FirstName = "Otto",
         //            MiddleName = "Fitzgerald",
         //            LastName = "Graves",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 2, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 415,
         //            //StudentPersonId = 415,
         //            StateStudentIdentifier = "0886015415",
         //            FirstName = "Murphy",
         //            MiddleName = "Amery",
         //            LastName = "Bryan",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2016, 10, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 416,
         //            //StudentPersonId = 416,
         //            StateStudentIdentifier = "0995728416",
         //            FirstName = "Karina",
         //            MiddleName = "Courtney",
         //            LastName = "Barry",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 5, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 417,
         //            //StudentPersonId = 417,
         //            StateStudentIdentifier = "0135168417",
         //            FirstName = "Quamar",
         //            MiddleName = "Martin",
         //            LastName = "Leach",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 3, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 418,
         //            //StudentPersonId = 418,
         //            StateStudentIdentifier = "0113487418",
         //            FirstName = "Aidan",
         //            MiddleName = "Hector",
         //            LastName = "Bowman",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1996, 7, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 419,
         //            //StudentPersonId = 419,
         //            StateStudentIdentifier = "0346801419",
         //            FirstName = "Zenia",
         //            MiddleName = "Zoe",
         //            LastName = "Lowery",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 4, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 420,
         //            //StudentPersonId = 420,
         //            StateStudentIdentifier = "0001131420",
         //            FirstName = "Hiroko",
         //            MiddleName = "Rana",
         //            LastName = "Ballard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 6, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 421,
         //            //StudentPersonId = 421,
         //            StateStudentIdentifier = "0139596421",
         //            FirstName = "Xavier",
         //            MiddleName = "Cody",
         //            LastName = "Barlow",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 5, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 422,
         //            //StudentPersonId = 422,
         //            StateStudentIdentifier = "0500268422",
         //            FirstName = "Marshall",
         //            MiddleName = "Chava",
         //            LastName = "Mclean",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 3, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 423,
         //            //StudentPersonId = 423,
         //            StateStudentIdentifier = "0701593423",
         //            FirstName = "Lee",
         //            MiddleName = "Upton",
         //            LastName = "Mcgowan",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1999, 8, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 424,
         //            //StudentPersonId = 424,
         //            StateStudentIdentifier = "0022849424",
         //            FirstName = "Fallon",
         //            MiddleName = "Darrel",
         //            LastName = "Ratliff",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 3, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 425,
         //            //StudentPersonId = 425,
         //            StateStudentIdentifier = "0874047425",
         //            FirstName = "Lucius",
         //            MiddleName = "Jasper",
         //            LastName = "Workman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 4, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 426,
         //            //StudentPersonId = 426,
         //            StateStudentIdentifier = "0379008426",
         //            FirstName = "Mohammad",
         //            MiddleName = "Aristotle",
         //            LastName = "Mack",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2012, 5, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 427,
         //            //StudentPersonId = 427,
         //            StateStudentIdentifier = "0608104427",
         //            FirstName = "Cody",
         //            MiddleName = "Hilel",
         //            LastName = "Estes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 5, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 428,
         //            //StudentPersonId = 428,
         //            StateStudentIdentifier = "0350194428",
         //            FirstName = "Nora",
         //            MiddleName = "Lunea",
         //            LastName = "Gregory",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 7, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 429,
         //            //StudentPersonId = 429,
         //            StateStudentIdentifier = "0178673429",
         //            FirstName = "Dara",
         //            MiddleName = "Cailin",
         //            LastName = "Clay",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 1, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 430,
         //            //StudentPersonId = 430,
         //            StateStudentIdentifier = "0322594430",
         //            FirstName = "Gay",
         //            MiddleName = "Halla",
         //            LastName = "Whitaker",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 4, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 431,
         //            //StudentPersonId = 431,
         //            StateStudentIdentifier = "0752596431",
         //            FirstName = "Scott",
         //            MiddleName = "Myles",
         //            LastName = "Soto",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2007, 11, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 432,
         //            //StudentPersonId = 432,
         //            StateStudentIdentifier = "0748274432",
         //            FirstName = "Xanthus",
         //            MiddleName = "Michael",
         //            LastName = "Newton",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2011, 7, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 433,
         //            //StudentPersonId = 433,
         //            StateStudentIdentifier = "0580790433",
         //            FirstName = "Amber",
         //            MiddleName = "Jessica",
         //            LastName = "Harris",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2003, 6, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 434,
         //            //StudentPersonId = 434,
         //            StateStudentIdentifier = "0109049434",
         //            FirstName = "Dakota",
         //            MiddleName = "Kitra",
         //            LastName = "Sloan",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(1996, 3, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 435,
         //            //StudentPersonId = 435,
         //            StateStudentIdentifier = "0751217435",
         //            FirstName = "Mara",
         //            MiddleName = "Idola",
         //            LastName = "Cunningham",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 5, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 436,
         //            //StudentPersonId = 436,
         //            StateStudentIdentifier = "0158746436",
         //            FirstName = "Genevieve",
         //            MiddleName = "Olivia",
         //            LastName = "Mercado",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 12, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 437,
         //            //StudentPersonId = 437,
         //            StateStudentIdentifier = "0922503437",
         //            FirstName = "Bob",
         //            MiddleName = "Blake",
         //            LastName = "Deleon",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 5, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 438,
         //            //StudentPersonId = 438,
         //            StateStudentIdentifier = "0372898438",
         //            FirstName = "Laith",
         //            MiddleName = "Mariko",
         //            LastName = "Deleon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 4, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 439,
         //            //StudentPersonId = 439,
         //            StateStudentIdentifier = "0055719439",
         //            FirstName = "Unity",
         //            MiddleName = "Sydnee",
         //            LastName = "Valdez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 2, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 440,
         //            //StudentPersonId = 440,
         //            StateStudentIdentifier = "0396386440",
         //            FirstName = "Caldwell",
         //            MiddleName = "Hamish",
         //            LastName = "Henson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 7, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 441,
         //            //StudentPersonId = 441,
         //            StateStudentIdentifier = "0417689441",
         //            FirstName = "Donovan",
         //            MiddleName = "Chandler",
         //            LastName = "Meyers",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 4, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 442,
         //            //StudentPersonId = 442,
         //            StateStudentIdentifier = "0818924442",
         //            FirstName = "Elmo",
         //            MiddleName = "Erich",
         //            LastName = "Chan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 1, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 443,
         //            //StudentPersonId = 443,
         //            StateStudentIdentifier = "0100592443",
         //            FirstName = "Lionel",
         //            MiddleName = "Camden",
         //            LastName = "Snow",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 12, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 444,
         //            //StudentPersonId = 444,
         //            StateStudentIdentifier = "0594077444",
         //            FirstName = "Russell",
         //            MiddleName = "Stuart",
         //            LastName = "Pollard",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2017, 5, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 445,
         //            //StudentPersonId = 445,
         //            StateStudentIdentifier = "0625394445",
         //            FirstName = "Jackson",
         //            MiddleName = "Geoffrey",
         //            LastName = "Schneider",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2009, 2, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 446,
         //            //StudentPersonId = 446,
         //            StateStudentIdentifier = "0572316446",
         //            FirstName = "Karen",
         //            MiddleName = "Gabriel",
         //            LastName = "Avila",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 11, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 447,
         //            //StudentPersonId = 447,
         //            StateStudentIdentifier = "0241733447",
         //            FirstName = "Ebony",
         //            MiddleName = "Amethyst",
         //            LastName = "Macdonald",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 2, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 448,
         //            //StudentPersonId = 448,
         //            StateStudentIdentifier = "0720897448",
         //            FirstName = "Michael",
         //            MiddleName = "Abel",
         //            LastName = "Robertson",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2009, 4, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 449,
         //            //StudentPersonId = 449,
         //            StateStudentIdentifier = "0781319449",
         //            FirstName = "Lavinia",
         //            MiddleName = "Signe",
         //            LastName = "Burris",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 12, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 450,
         //            //StudentPersonId = 450,
         //            StateStudentIdentifier = "0835861450",
         //            FirstName = "Amaya",
         //            MiddleName = "Xantha",
         //            LastName = "Hogan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 4, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 451,
         //            //StudentPersonId = 451,
         //            StateStudentIdentifier = "0609720451",
         //            FirstName = "Sumanth",
         //            MiddleName = "Kermit",
         //            LastName = "Peterson",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2004, 5, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 452,
         //            //StudentPersonId = 452,
         //            StateStudentIdentifier = "0811366452",
         //            FirstName = "Drew",
         //            MiddleName = "Enrique",
         //            LastName = "Harris",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2007, 12, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 453,
         //            //StudentPersonId = 453,
         //            StateStudentIdentifier = "0439607453",
         //            FirstName = "Rhea",
         //            MiddleName = "April",
         //            LastName = "Petersen",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2018, 3, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 454,
         //            //StudentPersonId = 454,
         //            StateStudentIdentifier = "0477833454",
         //            FirstName = "Vernon",
         //            MiddleName = "Coby",
         //            LastName = "Watts",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2000, 2, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 455,
         //            //StudentPersonId = 455,
         //            StateStudentIdentifier = "0454185455",
         //            FirstName = "Jelani",
         //            MiddleName = "Dillon",
         //            LastName = "Patterson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 4, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 456,
         //            //StudentPersonId = 456,
         //            StateStudentIdentifier = "0660095456",
         //            FirstName = "Mariko",
         //            MiddleName = "Keiko",
         //            LastName = "Sandoval",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2000, 8, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 457,
         //            //StudentPersonId = 457,
         //            StateStudentIdentifier = "0133379457",
         //            FirstName = "Devin",
         //            MiddleName = "Trevor",
         //            LastName = "Bowman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 2, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 458,
         //            //StudentPersonId = 458,
         //            StateStudentIdentifier = "0716644458",
         //            FirstName = "Hilel",
         //            MiddleName = "Hiram",
         //            LastName = "Fowler",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 12, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 459,
         //            //StudentPersonId = 459,
         //            StateStudentIdentifier = "0213303459",
         //            FirstName = "Acton",
         //            MiddleName = "Henry",
         //            LastName = "Lawson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 8, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 460,
         //            //StudentPersonId = 460,
         //            StateStudentIdentifier = "0703788460",
         //            FirstName = "Francis",
         //            MiddleName = "Cody",
         //            LastName = "Hinton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 6, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 461,
         //            //StudentPersonId = 461,
         //            StateStudentIdentifier = "0171552461",
         //            FirstName = "Douglas",
         //            MiddleName = "Isaac",
         //            LastName = "Jordan",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2009, 4, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 462,
         //            //StudentPersonId = 462,
         //            StateStudentIdentifier = "0257176462",
         //            FirstName = "Barry",
         //            MiddleName = "Orson",
         //            LastName = "Sharp",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 12, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 463,
         //            //StudentPersonId = 463,
         //            StateStudentIdentifier = "0921937463",
         //            FirstName = "Hollee",
         //            MiddleName = "Clio",
         //            LastName = "Acevedo",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 5, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 464,
         //            //StudentPersonId = 464,
         //            StateStudentIdentifier = "0879582464",
         //            FirstName = "Maia",
         //            MiddleName = "Brooke",
         //            LastName = "Langley",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 4, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 465,
         //            //StudentPersonId = 465,
         //            StateStudentIdentifier = "0700615465",
         //            FirstName = "Fitzgerald",
         //            MiddleName = "Lane",
         //            LastName = "Meyers",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2003, 12, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 466,
         //            //StudentPersonId = 466,
         //            StateStudentIdentifier = "0389439466",
         //            FirstName = "Caleb",
         //            MiddleName = "Josiah",
         //            LastName = "Bright",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 10, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 467,
         //            //StudentPersonId = 467,
         //            StateStudentIdentifier = "0316423467",
         //            FirstName = "Yeo",
         //            MiddleName = "Coby",
         //            LastName = "Buchanan",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2009, 2, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 468,
         //            //StudentPersonId = 468,
         //            StateStudentIdentifier = "0145734468",
         //            FirstName = "Halla",
         //            MiddleName = "Seth",
         //            LastName = "Lee",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 6, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 469,
         //            //StudentPersonId = 469,
         //            StateStudentIdentifier = "0332373469",
         //            FirstName = "Rudyard",
         //            MiddleName = "Addison",
         //            LastName = "Forbes",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2005, 11, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 470,
         //            //StudentPersonId = 470,
         //            StateStudentIdentifier = "0735588470",
         //            FirstName = "Herman",
         //            MiddleName = "Allistair",
         //            LastName = "Bean",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2002, 1, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 471,
         //            //StudentPersonId = 471,
         //            StateStudentIdentifier = "0965977471",
         //            FirstName = "Tallulah",
         //            MiddleName = "Steven",
         //            LastName = "Gilliam",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 5, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 472,
         //            //StudentPersonId = 472,
         //            StateStudentIdentifier = "0269034472",
         //            FirstName = "Pearl",
         //            MiddleName = "McKenzie",
         //            LastName = "Blair",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2005, 1, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 473,
         //            //StudentPersonId = 473,
         //            StateStudentIdentifier = "0517334473",
         //            FirstName = "Sade",
         //            MiddleName = "Erin",
         //            LastName = "Elliott",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2010, 4, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 474,
         //            //StudentPersonId = 474,
         //            StateStudentIdentifier = "0263316474",
         //            FirstName = "Bobby",
         //            MiddleName = "Tiger",
         //            LastName = "Mayo",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 1, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 475,
         //            //StudentPersonId = 475,
         //            StateStudentIdentifier = "0659656475",
         //            FirstName = "Wesley",
         //            MiddleName = "Abraham",
         //            LastName = "Cleveland",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2011, 4, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 476,
         //            //StudentPersonId = 476,
         //            StateStudentIdentifier = "0809298476",
         //            FirstName = "Giselle",
         //            MiddleName = "Raya",
         //            LastName = "Oconnor",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2011, 3, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 477,
         //            //StudentPersonId = 477,
         //            StateStudentIdentifier = "0834387477",
         //            FirstName = "Serena",
         //            MiddleName = "Hayfa",
         //            LastName = "Sears",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 2, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 478,
         //            //StudentPersonId = 478,
         //            StateStudentIdentifier = "0619862478",
         //            FirstName = "Sasha",
         //            MiddleName = "Naida",
         //            LastName = "Romero",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1998, 1, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 479,
         //            //StudentPersonId = 479,
         //            StateStudentIdentifier = "0065938479",
         //            FirstName = "Jackson",
         //            MiddleName = "Damon",
         //            LastName = "Velazquez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 1, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 480,
         //            //StudentPersonId = 480,
         //            StateStudentIdentifier = "0272521480",
         //            FirstName = "Brooke",
         //            MiddleName = "Savannah",
         //            LastName = "Reyes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 5, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 481,
         //            //StudentPersonId = 481,
         //            StateStudentIdentifier = "0394369481",
         //            FirstName = "Callum",
         //            MiddleName = "Dalton",
         //            LastName = "Kramer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 10, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 482,
         //            //StudentPersonId = 482,
         //            StateStudentIdentifier = "0901625482",
         //            FirstName = "Kennan",
         //            MiddleName = "Elmo",
         //            LastName = "Schroeder",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 6, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 483,
         //            //StudentPersonId = 483,
         //            StateStudentIdentifier = "0698994483",
         //            FirstName = "Chase",
         //            MiddleName = "Camden",
         //            LastName = "Walters",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2009, 4, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 484,
         //            //StudentPersonId = 484,
         //            StateStudentIdentifier = "0772505484",
         //            FirstName = "Ali",
         //            MiddleName = "Isaiah",
         //            LastName = "Woods",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 8, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 485,
         //            //StudentPersonId = 485,
         //            StateStudentIdentifier = "0759764485",
         //            FirstName = "Lani",
         //            MiddleName = "Jane",
         //            LastName = "Russell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 10, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 486,
         //            //StudentPersonId = 486,
         //            StateStudentIdentifier = "0188101486",
         //            FirstName = "Derek",
         //            MiddleName = "Myra",
         //            LastName = "Mercado",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 5, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 487,
         //            //StudentPersonId = 487,
         //            StateStudentIdentifier = "0618968487",
         //            FirstName = "Imogene",
         //            MiddleName = "Gail",
         //            LastName = "Noel",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 5, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 488,
         //            //StudentPersonId = 488,
         //            StateStudentIdentifier = "0663740488",
         //            FirstName = "Illana",
         //            MiddleName = "Selma",
         //            LastName = "Roth",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1998, 8, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 489,
         //            //StudentPersonId = 489,
         //            StateStudentIdentifier = "0598066489",
         //            FirstName = "Holmes",
         //            MiddleName = "Luke",
         //            LastName = "Savage",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1999, 4, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 490,
         //            //StudentPersonId = 490,
         //            StateStudentIdentifier = "0654749490",
         //            FirstName = "Maggy",
         //            MiddleName = "Gretchen",
         //            LastName = "Caldwell",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 4, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 491,
         //            //StudentPersonId = 491,
         //            StateStudentIdentifier = "0739334491",
         //            FirstName = "Sage",
         //            MiddleName = "Jemima",
         //            LastName = "Walters",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 7, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 492,
         //            //StudentPersonId = 492,
         //            StateStudentIdentifier = "0466437492",
         //            FirstName = "Belle",
         //            MiddleName = "Erin",
         //            LastName = "Barnes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 11, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 493,
         //            //StudentPersonId = 493,
         //            StateStudentIdentifier = "0770954493",
         //            FirstName = "April",
         //            MiddleName = "Janna",
         //            LastName = "Beard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 3, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 494,
         //            //StudentPersonId = 494,
         //            StateStudentIdentifier = "0025095494",
         //            FirstName = "Carly",
         //            MiddleName = "Gretchen",
         //            LastName = "Ballard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 6, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 495,
         //            //StudentPersonId = 495,
         //            StateStudentIdentifier = "0414901495",
         //            FirstName = "Avram",
         //            MiddleName = "Hamilton",
         //            LastName = "Gibson",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2005, 7, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 496,
         //            //StudentPersonId = 496,
         //            StateStudentIdentifier = "0665711496",
         //            FirstName = "Mason",
         //            MiddleName = "Henry",
         //            LastName = "Hansen",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 2, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 497,
         //            //StudentPersonId = 497,
         //            StateStudentIdentifier = "0932201497",
         //            FirstName = "Camden",
         //            MiddleName = "Ferris",
         //            LastName = "Riggs",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 4, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 498,
         //            //StudentPersonId = 498,
         //            StateStudentIdentifier = "0004081498",
         //            FirstName = "Adrienne",
         //            MiddleName = "Quon",
         //            LastName = "Morris",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 8, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 499,
         //            //StudentPersonId = 499,
         //            StateStudentIdentifier = "0325484499",
         //            FirstName = "Mechelle",
         //            MiddleName = "Cara",
         //            LastName = "Park",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1999, 4, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 500,
         //            //StudentPersonId = 500,
         //            StateStudentIdentifier = "0896616500",
         //            FirstName = "Hollee",
         //            MiddleName = "Jemima",
         //            LastName = "Porter",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2013, 12, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 501,
         //            //StudentPersonId = 501,
         //            StateStudentIdentifier = "0069778501",
         //            FirstName = "Gil",
         //            MiddleName = "Enrique",
         //            LastName = "Vance",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(1999, 12, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 502,
         //            //StudentPersonId = 502,
         //            StateStudentIdentifier = "0737779502",
         //            FirstName = "Perry",
         //            MiddleName = "Erasmus",
         //            LastName = "Russell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 6, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 503,
         //            //StudentPersonId = 503,
         //            StateStudentIdentifier = "0143366503",
         //            FirstName = "Maryam",
         //            MiddleName = "Deborah",
         //            LastName = "Silva",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2006, 2, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 504,
         //            //StudentPersonId = 504,
         //            StateStudentIdentifier = "0760013504",
         //            FirstName = "Akeem",
         //            MiddleName = "Charles",
         //            LastName = "Hodges",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 9, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 505,
         //            //StudentPersonId = 505,
         //            StateStudentIdentifier = "0215656505",
         //            FirstName = "Bianca",
         //            MiddleName = "Gisela",
         //            LastName = "Stafford",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 8, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 506,
         //            //StudentPersonId = 506,
         //            StateStudentIdentifier = "0974763506",
         //            FirstName = "Olivia",
         //            MiddleName = "Amanda",
         //            LastName = "Galloway",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 7, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 507,
         //            //StudentPersonId = 507,
         //            StateStudentIdentifier = "0414185507",
         //            FirstName = "Keaton",
         //            MiddleName = "Mike",
         //            LastName = "Chaney",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 3, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 508,
         //            //StudentPersonId = 508,
         //            StateStudentIdentifier = "0054837508",
         //            FirstName = "Dora",
         //            MiddleName = "Michael",
         //            LastName = "Potts",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(1996, 1, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 509,
         //            //StudentPersonId = 509,
         //            StateStudentIdentifier = "0214030509",
         //            FirstName = "Clio",
         //            MiddleName = "Christen",
         //            LastName = "Barrett",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 11, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 510,
         //            //StudentPersonId = 510,
         //            StateStudentIdentifier = "0016808510",
         //            FirstName = "Haley",
         //            MiddleName = "Adam",
         //            LastName = "Dickerson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 4, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 511,
         //            //StudentPersonId = 511,
         //            StateStudentIdentifier = "0401190511",
         //            FirstName = "Gavin",
         //            MiddleName = "Ira",
         //            LastName = "Fletcher",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 4, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 512,
         //            //StudentPersonId = 512,
         //            StateStudentIdentifier = "0327119512",
         //            FirstName = "Wanda",
         //            MiddleName = "Sarah",
         //            LastName = "Warren",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 3, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 513,
         //            //StudentPersonId = 513,
         //            StateStudentIdentifier = "0395096513",
         //            FirstName = "Rina",
         //            MiddleName = "Tamara",
         //            LastName = "Hendrix",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 4, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 514,
         //            //StudentPersonId = 514,
         //            StateStudentIdentifier = "0496435514",
         //            FirstName = "Jane",
         //            MiddleName = "Keely",
         //            LastName = "Burgess",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 2, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 515,
         //            //StudentPersonId = 515,
         //            StateStudentIdentifier = "0321293515",
         //            FirstName = "Oren",
         //            MiddleName = "Kane",
         //            LastName = "Short",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1998, 2, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 516,
         //            //StudentPersonId = 516,
         //            StateStudentIdentifier = "0627409516",
         //            FirstName = "Jescie",
         //            MiddleName = "Amethyst",
         //            LastName = "Hurley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 11, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 517,
         //            //StudentPersonId = 517,
         //            StateStudentIdentifier = "0856231517",
         //            FirstName = "Abraham",
         //            MiddleName = "Amir",
         //            LastName = "Burgess",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 7, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 518,
         //            //StudentPersonId = 518,
         //            StateStudentIdentifier = "0688359518",
         //            FirstName = "Nathan",
         //            MiddleName = "Lane",
         //            LastName = "Guy",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 5, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 519,
         //            //StudentPersonId = 519,
         //            StateStudentIdentifier = "0885071519",
         //            FirstName = "Skyler",
         //            MiddleName = "Mona",
         //            LastName = "Haley",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 4, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 520,
         //            //StudentPersonId = 520,
         //            StateStudentIdentifier = "0443635520",
         //            FirstName = "Addison",
         //            MiddleName = "Gray",
         //            LastName = "Odonnell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 3, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 521,
         //            //StudentPersonId = 521,
         //            StateStudentIdentifier = "0049363521",
         //            FirstName = "Axel",
         //            MiddleName = "Kevin",
         //            LastName = "Brennan",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2016, 12, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 522,
         //            //StudentPersonId = 522,
         //            StateStudentIdentifier = "0961433522",
         //            FirstName = "Rhea",
         //            MiddleName = "Ingrid",
         //            LastName = "Glass",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 6, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 523,
         //            //StudentPersonId = 523,
         //            StateStudentIdentifier = "0042224523",
         //            FirstName = "Cooper",
         //            MiddleName = "Felix",
         //            LastName = "Flores",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2016, 4, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 524,
         //            //StudentPersonId = 524,
         //            StateStudentIdentifier = "0789669524",
         //            FirstName = "Ulric",
         //            MiddleName = "Cedric",
         //            LastName = "Espinoza",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 11, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 525,
         //            //StudentPersonId = 525,
         //            StateStudentIdentifier = "0674059525",
         //            FirstName = "Elton",
         //            MiddleName = "Levi",
         //            LastName = "Merritt",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 6, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 526,
         //            //StudentPersonId = 526,
         //            StateStudentIdentifier = "0737954526",
         //            FirstName = "Olivia",
         //            MiddleName = "Alisa",
         //            LastName = "Powell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 6, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 527,
         //            //StudentPersonId = 527,
         //            StateStudentIdentifier = "0245322527",
         //            FirstName = "Anika",
         //            MiddleName = "Juliet",
         //            LastName = "Mcgee",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 8, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 528,
         //            //StudentPersonId = 528,
         //            StateStudentIdentifier = "0774716528",
         //            FirstName = "Halee",
         //            MiddleName = "Angelica",
         //            LastName = "Hendricks",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2008, 11, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 529,
         //            //StudentPersonId = 529,
         //            StateStudentIdentifier = "0990594529",
         //            FirstName = "Yuli",
         //            MiddleName = "Gray",
         //            LastName = "Odonnell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 7, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 530,
         //            //StudentPersonId = 530,
         //            StateStudentIdentifier = "0559713530",
         //            FirstName = "Upton",
         //            MiddleName = "Ferris",
         //            LastName = "Kerr",
         //            Cohort = null,
         //            BirthDate = new DateTime(2020, 1, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 531,
         //            //StudentPersonId = 531,
         //            StateStudentIdentifier = "0349074531",
         //            FirstName = "Hollee",
         //            MiddleName = "Carolyn",
         //            LastName = "Patterson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 7, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 532,
         //            //StudentPersonId = 532,
         //            StateStudentIdentifier = "0301639532",
         //            FirstName = "Tate",
         //            MiddleName = "Emery",
         //            LastName = "Williams",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 4, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 533,
         //            //StudentPersonId = 533,
         //            StateStudentIdentifier = "0147185533",
         //            FirstName = "Leo",
         //            MiddleName = "Ali",
         //            LastName = "Parker",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 4, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 534,
         //            //StudentPersonId = 534,
         //            StateStudentIdentifier = "0241356534",
         //            FirstName = "Yael",
         //            MiddleName = "Amity",
         //            LastName = "Underwood",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2009, 11, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 535,
         //            //StudentPersonId = 535,
         //            StateStudentIdentifier = "0001225535",
         //            FirstName = "Amaya",
         //            MiddleName = "Unity",
         //            LastName = "Holcomb",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 5, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 536,
         //            //StudentPersonId = 536,
         //            StateStudentIdentifier = "0893745536",
         //            FirstName = "September",
         //            MiddleName = "Lesley",
         //            LastName = "Fitzpatrick",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2000, 2, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 537,
         //            //StudentPersonId = 537,
         //            StateStudentIdentifier = "0968266537",
         //            FirstName = "Slade",
         //            MiddleName = "Douglas",
         //            LastName = "Petersen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 5, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 538,
         //            //StudentPersonId = 538,
         //            StateStudentIdentifier = "0326706538",
         //            FirstName = "Ursa",
         //            MiddleName = "Cameran",
         //            LastName = "Haney",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 11, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 539,
         //            //StudentPersonId = 539,
         //            StateStudentIdentifier = "0848474539",
         //            FirstName = "Nichole",
         //            MiddleName = "Althea",
         //            LastName = "Hicks",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 12, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 540,
         //            //StudentPersonId = 540,
         //            StateStudentIdentifier = "0106292540",
         //            FirstName = "Jena",
         //            MiddleName = "Meghan",
         //            LastName = "Hunt",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 7, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 541,
         //            //StudentPersonId = 541,
         //            StateStudentIdentifier = "0912706541",
         //            FirstName = "Drake",
         //            MiddleName = "Chandler",
         //            LastName = "Norris",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 8, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 542,
         //            //StudentPersonId = 542,
         //            StateStudentIdentifier = "0113373542",
         //            FirstName = "Troy",
         //            MiddleName = "Mohammad",
         //            LastName = "Thornton",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2019, 2, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 543,
         //            //StudentPersonId = 543,
         //            StateStudentIdentifier = "0419028543",
         //            FirstName = "Gage",
         //            MiddleName = "Debra",
         //            LastName = "Branch",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 6, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 544,
         //            //StudentPersonId = 544,
         //            StateStudentIdentifier = "0762397544",
         //            FirstName = "Clark",
         //            MiddleName = "Damon",
         //            LastName = "Kirk",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2000, 8, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 545,
         //            //StudentPersonId = 545,
         //            StateStudentIdentifier = "0951217545",
         //            FirstName = "Buckminster",
         //            MiddleName = "Henry",
         //            LastName = "Williams",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 9, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 546,
         //            //StudentPersonId = 546,
         //            StateStudentIdentifier = "0601622546",
         //            FirstName = "Idona",
         //            MiddleName = "Alexis",
         //            LastName = "Mcdaniel",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 9, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 547,
         //            //StudentPersonId = 547,
         //            StateStudentIdentifier = "0648511547",
         //            FirstName = "Judith",
         //            MiddleName = "Justine",
         //            LastName = "Mcgowan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 11, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 548,
         //            //StudentPersonId = 548,
         //            StateStudentIdentifier = "0686179548",
         //            FirstName = "Alisa",
         //            MiddleName = "Wade",
         //            LastName = "Foreman",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 11, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 549,
         //            //StudentPersonId = 549,
         //            StateStudentIdentifier = "0084828549",
         //            FirstName = "Len",
         //            MiddleName = "Tarik",
         //            LastName = "Boyle",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 9, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 550,
         //            //StudentPersonId = 550,
         //            StateStudentIdentifier = "0353627550",
         //            FirstName = "Kelly",
         //            MiddleName = "Mallory",
         //            LastName = "Mccarthy",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2017, 10, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 551,
         //            //StudentPersonId = 551,
         //            StateStudentIdentifier = "0113644551",
         //            FirstName = "Igor",
         //            MiddleName = "Yasir",
         //            LastName = "Hatfield",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 4, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 552,
         //            //StudentPersonId = 552,
         //            StateStudentIdentifier = "0219092552",
         //            FirstName = "Kevin",
         //            MiddleName = "Ross",
         //            LastName = "Holcomb",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 8, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 553,
         //            //StudentPersonId = 553,
         //            StateStudentIdentifier = "0546221553",
         //            FirstName = "Ifeoma",
         //            MiddleName = "Gay",
         //            LastName = "Sutton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 4, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 554,
         //            //StudentPersonId = 554,
         //            StateStudentIdentifier = "0563830554",
         //            FirstName = "Vincent",
         //            MiddleName = "Abdul",
         //            LastName = "Montgomery",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 11, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 555,
         //            //StudentPersonId = 555,
         //            StateStudentIdentifier = "0384654555",
         //            FirstName = "Yael",
         //            MiddleName = "Ginger",
         //            LastName = "Norris",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 11, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 556,
         //            //StudentPersonId = 556,
         //            StateStudentIdentifier = "0293048556",
         //            FirstName = "Forrest",
         //            MiddleName = "Drake",
         //            LastName = "Clark",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 8, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 557,
         //            //StudentPersonId = 557,
         //            StateStudentIdentifier = "0159757557",
         //            FirstName = "Sawyer",
         //            MiddleName = "Myles",
         //            LastName = "Mayo",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2003, 5, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 558,
         //            //StudentPersonId = 558,
         //            StateStudentIdentifier = "0193029558",
         //            FirstName = "Slade",
         //            MiddleName = "Caleb",
         //            LastName = "Bell",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 4, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 559,
         //            //StudentPersonId = 559,
         //            StateStudentIdentifier = "0003411559",
         //            FirstName = "Nasim",
         //            MiddleName = "Jamalia",
         //            LastName = "Parrish",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2007, 8, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 560,
         //            //StudentPersonId = 560,
         //            StateStudentIdentifier = "0325010560",
         //            FirstName = "Ciaran",
         //            MiddleName = "Knox",
         //            LastName = "Dudley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 7, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 561,
         //            //StudentPersonId = 561,
         //            StateStudentIdentifier = "0874228561",
         //            FirstName = "Rama",
         //            MiddleName = "Ria",
         //            LastName = "Fox",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 10, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 562,
         //            //StudentPersonId = 562,
         //            StateStudentIdentifier = "0129551562",
         //            FirstName = "Jenna",
         //            MiddleName = "Hanae",
         //            LastName = "Banks",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2019, 8, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 563,
         //            //StudentPersonId = 563,
         //            StateStudentIdentifier = "0419057563",
         //            FirstName = "Upton",
         //            MiddleName = "Georgia",
         //            LastName = "Dodson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 8, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 564,
         //            //StudentPersonId = 564,
         //            StateStudentIdentifier = "0070434564",
         //            FirstName = "Aurelia",
         //            MiddleName = "Stella",
         //            LastName = "Beach",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 12, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 565,
         //            //StudentPersonId = 565,
         //            StateStudentIdentifier = "0518066565",
         //            FirstName = "Chandler",
         //            MiddleName = "Orlando",
         //            LastName = "Rutledge",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 5, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 566,
         //            //StudentPersonId = 566,
         //            StateStudentIdentifier = "0833763566",
         //            FirstName = "Mari",
         //            MiddleName = "Summer",
         //            LastName = "Hurst",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2011, 1, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 567,
         //            //StudentPersonId = 567,
         //            StateStudentIdentifier = "0364423567",
         //            FirstName = "Jasmin",
         //            MiddleName = "Emi",
         //            LastName = "Walton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 9, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 568,
         //            //StudentPersonId = 568,
         //            StateStudentIdentifier = "0849361568",
         //            FirstName = "Evangeline",
         //            MiddleName = "Colleen",
         //            LastName = "Harper",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 11, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 569,
         //            //StudentPersonId = 569,
         //            StateStudentIdentifier = "0293758569",
         //            FirstName = "Uriel",
         //            MiddleName = "Chase",
         //            LastName = "Morris",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 3, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 570,
         //            //StudentPersonId = 570,
         //            StateStudentIdentifier = "0396501570",
         //            FirstName = "Clinton",
         //            MiddleName = "Nolan",
         //            LastName = "Villarreal",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1997, 3, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 571,
         //            //StudentPersonId = 571,
         //            StateStudentIdentifier = "0484988571",
         //            FirstName = "Jessica",
         //            MiddleName = "Genevieve",
         //            LastName = "Hess",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 8, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 572,
         //            //StudentPersonId = 572,
         //            StateStudentIdentifier = "0373469572",
         //            FirstName = "Wang",
         //            MiddleName = "Keelie",
         //            LastName = "Ryan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 6, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 573,
         //            //StudentPersonId = 573,
         //            StateStudentIdentifier = "0174774573",
         //            FirstName = "Mary",
         //            MiddleName = "Carly",
         //            LastName = "Potter",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 4, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 574,
         //            //StudentPersonId = 574,
         //            StateStudentIdentifier = "0459795574",
         //            FirstName = "Leo",
         //            MiddleName = "Tobias",
         //            LastName = "Walters",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 11, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 575,
         //            //StudentPersonId = 575,
         //            StateStudentIdentifier = "0317225575",
         //            FirstName = "Wylie",
         //            MiddleName = "Wallace",
         //            LastName = "Berg",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1999, 1, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 576,
         //            //StudentPersonId = 576,
         //            StateStudentIdentifier = "0388364576",
         //            FirstName = "Griffith",
         //            MiddleName = "Kevin",
         //            LastName = "Mejia",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 10, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 577,
         //            //StudentPersonId = 577,
         //            StateStudentIdentifier = "0277987577",
         //            FirstName = "Tamara",
         //            MiddleName = "Renee",
         //            LastName = "Slater",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2018, 1, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 578,
         //            //StudentPersonId = 578,
         //            StateStudentIdentifier = "0815682578",
         //            FirstName = "Abdul",
         //            MiddleName = "Kermit",
         //            LastName = "Sears",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 9, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 579,
         //            //StudentPersonId = 579,
         //            StateStudentIdentifier = "0238269579",
         //            FirstName = "Oscar",
         //            MiddleName = "Finn",
         //            LastName = "Sexton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 5, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 580,
         //            //StudentPersonId = 580,
         //            StateStudentIdentifier = "0750423580",
         //            FirstName = "Hector",
         //            MiddleName = "Eagan",
         //            LastName = "Vega",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 11, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 581,
         //            //StudentPersonId = 581,
         //            StateStudentIdentifier = "0870440581",
         //            FirstName = "Giselle",
         //            MiddleName = "Linus",
         //            LastName = "Levy",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 2, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 582,
         //            //StudentPersonId = 582,
         //            StateStudentIdentifier = "0867920582",
         //            FirstName = "Frank",
         //            MiddleName = "Lance",
         //            LastName = "Winters",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2014, 12, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 583,
         //            //StudentPersonId = 583,
         //            StateStudentIdentifier = "0334157583",
         //            FirstName = "Mufutau",
         //            MiddleName = "Ignatius",
         //            LastName = "Gray",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2010, 7, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 584,
         //            //StudentPersonId = 584,
         //            StateStudentIdentifier = "0127576584",
         //            FirstName = "Abel",
         //            MiddleName = "Lane",
         //            LastName = "Orr",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1996, 12, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 585,
         //            //StudentPersonId = 585,
         //            StateStudentIdentifier = "0586064585",
         //            FirstName = "Jemima",
         //            MiddleName = "Phoebe",
         //            LastName = "Stephens",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 5, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 586,
         //            //StudentPersonId = 586,
         //            StateStudentIdentifier = "0682742586",
         //            FirstName = "Yardley",
         //            MiddleName = "Clark",
         //            LastName = "Chaney",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2009, 3, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 587,
         //            //StudentPersonId = 587,
         //            StateStudentIdentifier = "0528829587",
         //            FirstName = "Christopher",
         //            MiddleName = "Carlos",
         //            LastName = "Richard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 7, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 588,
         //            //StudentPersonId = 588,
         //            StateStudentIdentifier = "0190409588",
         //            FirstName = "Irene",
         //            MiddleName = "Oscar",
         //            LastName = "Jones",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 5, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 589,
         //            //StudentPersonId = 589,
         //            StateStudentIdentifier = "0421695589",
         //            FirstName = "Dakota",
         //            MiddleName = "Andrew",
         //            LastName = "Mclean",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 5, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 590,
         //            //StudentPersonId = 590,
         //            StateStudentIdentifier = "0734955590",
         //            FirstName = "Amela",
         //            MiddleName = "Wanda",
         //            LastName = "Marshall",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2011, 6, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 591,
         //            //StudentPersonId = 591,
         //            StateStudentIdentifier = "0044311591",
         //            FirstName = "Zorita",
         //            MiddleName = "Jorden",
         //            LastName = "Olsen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 12, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 592,
         //            //StudentPersonId = 592,
         //            StateStudentIdentifier = "0582371592",
         //            FirstName = "Rebecca",
         //            MiddleName = "Martin",
         //            LastName = "Faulkner",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 10, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 593,
         //            //StudentPersonId = 593,
         //            StateStudentIdentifier = "0718216593",
         //            FirstName = "Chandler",
         //            MiddleName = "Kyle",
         //            LastName = "Shaw",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 12, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 594,
         //            //StudentPersonId = 594,
         //            StateStudentIdentifier = "0958696594",
         //            FirstName = "Finn",
         //            MiddleName = "Dillon",
         //            LastName = "Walker",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 3, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 595,
         //            //StudentPersonId = 595,
         //            StateStudentIdentifier = "0094240595",
         //            FirstName = "Shelley",
         //            MiddleName = "Bell",
         //            LastName = "Conway",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2009, 1, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 596,
         //            //StudentPersonId = 596,
         //            StateStudentIdentifier = "0883941596",
         //            FirstName = "Acton",
         //            MiddleName = "Raja",
         //            LastName = "Howard",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2002, 1, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 597,
         //            //StudentPersonId = 597,
         //            StateStudentIdentifier = "0562015597",
         //            FirstName = "Lara",
         //            MiddleName = "Brooke",
         //            LastName = "Daniels",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 11, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 598,
         //            //StudentPersonId = 598,
         //            StateStudentIdentifier = "0441176598",
         //            FirstName = "Declan",
         //            MiddleName = "Abbot",
         //            LastName = "Pollard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 1, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 599,
         //            //StudentPersonId = 599,
         //            StateStudentIdentifier = "0547985599",
         //            FirstName = "Guinevere",
         //            MiddleName = "Paloma",
         //            LastName = "Stephens",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 8, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 600,
         //            //StudentPersonId = 600,
         //            StateStudentIdentifier = "0752879600",
         //            FirstName = "Lavinia",
         //            MiddleName = "Phyllis",
         //            LastName = "Warner",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 1, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 601,
         //            //StudentPersonId = 601,
         //            StateStudentIdentifier = "0060598601",
         //            FirstName = "Vivian",
         //            MiddleName = "Myra",
         //            LastName = "Acevedo",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 3, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 602,
         //            //StudentPersonId = 602,
         //            StateStudentIdentifier = "0075475602",
         //            FirstName = "Lacey",
         //            MiddleName = "Alyssa",
         //            LastName = "Donaldson",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1995, 5, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 603,
         //            //StudentPersonId = 603,
         //            StateStudentIdentifier = "0527715603",
         //            FirstName = "Rajah",
         //            MiddleName = "Cruz",
         //            LastName = "Luna",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 9, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 604,
         //            //StudentPersonId = 604,
         //            StateStudentIdentifier = "0971524604",
         //            FirstName = "Kevyn",
         //            MiddleName = "Blair",
         //            LastName = "Morris",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 3, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 605,
         //            //StudentPersonId = 605,
         //            StateStudentIdentifier = "0814030605",
         //            FirstName = "Genevieve",
         //            MiddleName = "Mira",
         //            LastName = "May",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2017, 12, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 606,
         //            //StudentPersonId = 606,
         //            StateStudentIdentifier = "0568714606",
         //            FirstName = "Hop",
         //            MiddleName = "Palmer",
         //            LastName = "Rocha",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 9, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 607,
         //            //StudentPersonId = 607,
         //            StateStudentIdentifier = "0439046607",
         //            FirstName = "Marvin",
         //            MiddleName = "Geoffrey",
         //            LastName = "Cash",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1998, 9, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 608,
         //            //StudentPersonId = 608,
         //            StateStudentIdentifier = "0898292608",
         //            FirstName = "Kylynn",
         //            MiddleName = "Meredith",
         //            LastName = "Hess",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 2, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 609,
         //            //StudentPersonId = 609,
         //            StateStudentIdentifier = "0827649609",
         //            FirstName = "Omar",
         //            MiddleName = "Vladimir",
         //            LastName = "Woodard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 4, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 610,
         //            //StudentPersonId = 610,
         //            StateStudentIdentifier = "0514033610",
         //            FirstName = "Aspen",
         //            MiddleName = "Gwendolyn",
         //            LastName = "Valdez",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2006, 10, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 611,
         //            //StudentPersonId = 611,
         //            StateStudentIdentifier = "0390098611",
         //            FirstName = "Cara",
         //            MiddleName = "Kitra",
         //            LastName = "Santiago",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2013, 12, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 612,
         //            //StudentPersonId = 612,
         //            StateStudentIdentifier = "0106549612",
         //            FirstName = "Sydney",
         //            MiddleName = "Brooke",
         //            LastName = "Pittman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 12, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 613,
         //            //StudentPersonId = 613,
         //            StateStudentIdentifier = "0180300613",
         //            FirstName = "Guinevere",
         //            MiddleName = "April",
         //            LastName = "Combs",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1995, 5, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 614,
         //            //StudentPersonId = 614,
         //            StateStudentIdentifier = "0193484614",
         //            FirstName = "Tatum",
         //            MiddleName = "Stacey",
         //            LastName = "Daugherty",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 11, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 615,
         //            //StudentPersonId = 615,
         //            StateStudentIdentifier = "0737834615",
         //            FirstName = "Maggy",
         //            MiddleName = "Jordan",
         //            LastName = "Watson",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1998, 2, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 616,
         //            //StudentPersonId = 616,
         //            StateStudentIdentifier = "0505083616",
         //            FirstName = "Sara",
         //            MiddleName = "Gretchen",
         //            LastName = "Black",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 1, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 617,
         //            //StudentPersonId = 617,
         //            StateStudentIdentifier = "0157148617",
         //            FirstName = "Dalton",
         //            MiddleName = "Paloma",
         //            LastName = "Davidson",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2010, 12, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 618,
         //            //StudentPersonId = 618,
         //            StateStudentIdentifier = "0486151618",
         //            FirstName = "Sarah",
         //            MiddleName = "Chantale",
         //            LastName = "Roman",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2008, 4, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 619,
         //            //StudentPersonId = 619,
         //            StateStudentIdentifier = "0122227619",
         //            FirstName = "Tanisha",
         //            MiddleName = "Madison",
         //            LastName = "Yates",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 6, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 620,
         //            //StudentPersonId = 620,
         //            StateStudentIdentifier = "0715165620",
         //            FirstName = "Holmes",
         //            MiddleName = "Cleo",
         //            LastName = "Henderson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 10, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 621,
         //            //StudentPersonId = 621,
         //            StateStudentIdentifier = "0427686621",
         //            FirstName = "Adena",
         //            MiddleName = "Emi",
         //            LastName = "Clemons",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2004, 8, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 622,
         //            //StudentPersonId = 622,
         //            StateStudentIdentifier = "0125147622",
         //            FirstName = "Rhona",
         //            MiddleName = "Shay",
         //            LastName = "Patterson",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1996, 5, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 623,
         //            //StudentPersonId = 623,
         //            StateStudentIdentifier = "0746319623",
         //            FirstName = "Gil",
         //            MiddleName = "Lucas",
         //            LastName = "Mayo",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2000, 6, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 624,
         //            //StudentPersonId = 624,
         //            StateStudentIdentifier = "0495413624",
         //            FirstName = "Hayes",
         //            MiddleName = "Christian",
         //            LastName = "Davis",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 12, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 625,
         //            //StudentPersonId = 625,
         //            StateStudentIdentifier = "0525083625",
         //            FirstName = "Michelle",
         //            MiddleName = "Cheryl",
         //            LastName = "Hardin",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2010, 8, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 626,
         //            //StudentPersonId = 626,
         //            StateStudentIdentifier = "0044839626",
         //            FirstName = "Dexter",
         //            MiddleName = "Zephania",
         //            LastName = "Griffin",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 3, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 627,
         //            //StudentPersonId = 627,
         //            StateStudentIdentifier = "0878908627",
         //            FirstName = "Jenna",
         //            MiddleName = "Orli",
         //            LastName = "Maynard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 7, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 628,
         //            //StudentPersonId = 628,
         //            StateStudentIdentifier = "0386358628",
         //            FirstName = "Amos",
         //            MiddleName = "Brenden",
         //            LastName = "Mullen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 4, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 629,
         //            //StudentPersonId = 629,
         //            StateStudentIdentifier = "0124777629",
         //            FirstName = "Sophia",
         //            MiddleName = "Martena",
         //            LastName = "Beck",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1996, 6, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 630,
         //            //StudentPersonId = 630,
         //            StateStudentIdentifier = "0083161630",
         //            FirstName = "Keaton",
         //            MiddleName = "Hakeem",
         //            LastName = "Deleon",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1999, 8, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 631,
         //            //StudentPersonId = 631,
         //            StateStudentIdentifier = "0433558631",
         //            FirstName = "Marcia",
         //            MiddleName = "Guinevere",
         //            LastName = "Parrish",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 9, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 632,
         //            //StudentPersonId = 632,
         //            StateStudentIdentifier = "0436617632",
         //            FirstName = "Aaron",
         //            MiddleName = "Jelani",
         //            LastName = "Clemons",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 11, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 633,
         //            //StudentPersonId = 633,
         //            StateStudentIdentifier = "0262837633",
         //            FirstName = "Leah",
         //            MiddleName = "Gretchen",
         //            LastName = "Townsend",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 3, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 634,
         //            //StudentPersonId = 634,
         //            StateStudentIdentifier = "0839372634",
         //            FirstName = "Ulric",
         //            MiddleName = "Peter",
         //            LastName = "Gutierrez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 3, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 635,
         //            //StudentPersonId = 635,
         //            StateStudentIdentifier = "0387170635",
         //            FirstName = "Simone",
         //            MiddleName = "Nora",
         //            LastName = "Lambert",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 4, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 636,
         //            //StudentPersonId = 636,
         //            StateStudentIdentifier = "0803885636",
         //            FirstName = "Rae",
         //            MiddleName = "Summer",
         //            LastName = "Irwin",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 3, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 637,
         //            //StudentPersonId = 637,
         //            StateStudentIdentifier = "0947713637",
         //            FirstName = "Jena",
         //            MiddleName = "Shannon",
         //            LastName = "Dickenson",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2009, 11, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 638,
         //            //StudentPersonId = 638,
         //            StateStudentIdentifier = "0920886638",
         //            FirstName = "Halla",
         //            MiddleName = "Dana",
         //            LastName = "Shaw",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1999, 2, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 639,
         //            //StudentPersonId = 639,
         //            StateStudentIdentifier = "0256536639",
         //            FirstName = "Tobias",
         //            MiddleName = "Amir",
         //            LastName = "Stokes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 11, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 640,
         //            //StudentPersonId = 640,
         //            StateStudentIdentifier = "0928384640",
         //            FirstName = "Anne",
         //            MiddleName = "Wynter",
         //            LastName = "Kirk",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2009, 3, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 641,
         //            //StudentPersonId = 641,
         //            StateStudentIdentifier = "0658863641",
         //            FirstName = "Michelle",
         //            MiddleName = "Dana",
         //            LastName = "Brennan",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2009, 5, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 642,
         //            //StudentPersonId = 642,
         //            StateStudentIdentifier = "0091984642",
         //            FirstName = "Lyle",
         //            MiddleName = "Kamal",
         //            LastName = "Black",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 10, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 643,
         //            //StudentPersonId = 643,
         //            StateStudentIdentifier = "0411512643",
         //            FirstName = "Ifeoma",
         //            MiddleName = "Deanna",
         //            LastName = "Barnes",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2002, 2, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 644,
         //            //StudentPersonId = 644,
         //            StateStudentIdentifier = "0449920644",
         //            FirstName = "Brody",
         //            MiddleName = "Deacon",
         //            LastName = "Dean",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2013, 2, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 645,
         //            //StudentPersonId = 645,
         //            StateStudentIdentifier = "0415558645",
         //            FirstName = "Deborah",
         //            MiddleName = "Nyssa",
         //            LastName = "Klein",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 7, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 646,
         //            //StudentPersonId = 646,
         //            StateStudentIdentifier = "0926213646",
         //            FirstName = "Griffith",
         //            MiddleName = "Leonard",
         //            LastName = "Holden",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 2, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 647,
         //            //StudentPersonId = 647,
         //            StateStudentIdentifier = "0830977647",
         //            FirstName = "Nevada",
         //            MiddleName = "Aileen",
         //            LastName = "Hansen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 1, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 648,
         //            //StudentPersonId = 648,
         //            StateStudentIdentifier = "0883209648",
         //            FirstName = "Marny",
         //            MiddleName = "Shaine",
         //            LastName = "Nolan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 5, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 649,
         //            //StudentPersonId = 649,
         //            StateStudentIdentifier = "0543841649",
         //            FirstName = "Marny",
         //            MiddleName = "Patricia",
         //            LastName = "Lancaster",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2011, 8, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 650,
         //            //StudentPersonId = 650,
         //            StateStudentIdentifier = "0228879650",
         //            FirstName = "Galena",
         //            MiddleName = "Constance",
         //            LastName = "Cross",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 4, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 651,
         //            //StudentPersonId = 651,
         //            StateStudentIdentifier = "0288558651",
         //            FirstName = "Natalie",
         //            MiddleName = "Aileen",
         //            LastName = "Mccormick",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 11, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 652,
         //            //StudentPersonId = 652,
         //            StateStudentIdentifier = "0492651652",
         //            FirstName = "Sheila",
         //            MiddleName = "Kevyn",
         //            LastName = "Mendez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 10, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 653,
         //            //StudentPersonId = 653,
         //            StateStudentIdentifier = "0667668653",
         //            FirstName = "Omar",
         //            MiddleName = "Zeph",
         //            LastName = "Knowles",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 9, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 654,
         //            //StudentPersonId = 654,
         //            StateStudentIdentifier = "0426718654",
         //            FirstName = "Orlando",
         //            MiddleName = "Honorato",
         //            LastName = "Meadows",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 5, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 655,
         //            //StudentPersonId = 655,
         //            StateStudentIdentifier = "0401592655",
         //            FirstName = "Malik",
         //            MiddleName = "Caesar",
         //            LastName = "Parrish",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2008, 12, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 656,
         //            //StudentPersonId = 656,
         //            StateStudentIdentifier = "0857277656",
         //            FirstName = "Lane",
         //            MiddleName = "Tiger",
         //            LastName = "Rodgers",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 1, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 657,
         //            //StudentPersonId = 657,
         //            StateStudentIdentifier = "0847593657",
         //            FirstName = "Perry",
         //            MiddleName = "Callum",
         //            LastName = "Baker",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 9, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 658,
         //            //StudentPersonId = 658,
         //            StateStudentIdentifier = "0731677658",
         //            FirstName = "Joy",
         //            MiddleName = "Gail",
         //            LastName = "Clark",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 9, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 659,
         //            //StudentPersonId = 659,
         //            StateStudentIdentifier = "0112554659",
         //            FirstName = "Lewis",
         //            MiddleName = "Graiden",
         //            LastName = "Camacho",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 1, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 660,
         //            //StudentPersonId = 660,
         //            StateStudentIdentifier = "0155019660",
         //            FirstName = "Bruce",
         //            MiddleName = "Deacon",
         //            LastName = "Oneill",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 3, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 661,
         //            //StudentPersonId = 661,
         //            StateStudentIdentifier = "0801253661",
         //            FirstName = "Wilma",
         //            MiddleName = "Josephine",
         //            LastName = "Lawson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 9, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 662,
         //            //StudentPersonId = 662,
         //            StateStudentIdentifier = "0482974662",
         //            FirstName = "Nicole",
         //            MiddleName = "Haviva",
         //            LastName = "Joyner",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 10, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 663,
         //            //StudentPersonId = 663,
         //            StateStudentIdentifier = "0883055663",
         //            FirstName = "Noah",
         //            MiddleName = "Leonard",
         //            LastName = "Mayer",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 6, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 664,
         //            //StudentPersonId = 664,
         //            StateStudentIdentifier = "0622474664",
         //            FirstName = "Clayton",
         //            MiddleName = "Leroy",
         //            LastName = "Ashley",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2014, 9, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 665,
         //            //StudentPersonId = 665,
         //            StateStudentIdentifier = "0978918665",
         //            FirstName = "Paul",
         //            MiddleName = "Rigel",
         //            LastName = "Golden",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2004, 6, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 666,
         //            //StudentPersonId = 666,
         //            StateStudentIdentifier = "0145886666",
         //            FirstName = "Kylynn",
         //            MiddleName = "Madonna",
         //            LastName = "Stevenson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 9, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 667,
         //            //StudentPersonId = 667,
         //            StateStudentIdentifier = "0556820667",
         //            FirstName = "Leilani",
         //            MiddleName = "Elizabeth",
         //            LastName = "Mejia",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 3, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 668,
         //            //StudentPersonId = 668,
         //            StateStudentIdentifier = "0902450668",
         //            FirstName = "Tatum",
         //            MiddleName = "Patience",
         //            LastName = "Hoover",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2016, 10, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 669,
         //            //StudentPersonId = 669,
         //            StateStudentIdentifier = "0503138669",
         //            FirstName = "Nicole",
         //            MiddleName = "Naida",
         //            LastName = "Cantu",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2015, 8, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 670,
         //            //StudentPersonId = 670,
         //            StateStudentIdentifier = "0745843670",
         //            FirstName = "Hammett",
         //            MiddleName = "Ryder",
         //            LastName = "Britt",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 12, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 671,
         //            //StudentPersonId = 671,
         //            StateStudentIdentifier = "0728080671",
         //            FirstName = "Risa",
         //            MiddleName = "Teagan",
         //            LastName = "Roth",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2009, 5, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 672,
         //            //StudentPersonId = 672,
         //            StateStudentIdentifier = "0434748672",
         //            FirstName = "Yael",
         //            MiddleName = "Simone",
         //            LastName = "Stephens",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 8, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 673,
         //            //StudentPersonId = 673,
         //            StateStudentIdentifier = "0372702673",
         //            FirstName = "Bert",
         //            MiddleName = "Bert",
         //            LastName = "Berg",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 6, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 674,
         //            //StudentPersonId = 674,
         //            StateStudentIdentifier = "0920060674",
         //            FirstName = "Emmanuel",
         //            MiddleName = "Gray",
         //            LastName = "Tillman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 7, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 675,
         //            //StudentPersonId = 675,
         //            StateStudentIdentifier = "0931732675",
         //            FirstName = "Nathaniel",
         //            MiddleName = "Darius",
         //            LastName = "Guy",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 7, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 676,
         //            //StudentPersonId = 676,
         //            StateStudentIdentifier = "0448089676",
         //            FirstName = "Brent",
         //            MiddleName = "Jasper",
         //            LastName = "Dixon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 11, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 677,
         //            //StudentPersonId = 677,
         //            StateStudentIdentifier = "0706120677",
         //            FirstName = "Finn",
         //            MiddleName = "August",
         //            LastName = "Emerson",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2005, 9, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 678,
         //            //StudentPersonId = 678,
         //            StateStudentIdentifier = "0103310678",
         //            FirstName = "Althea",
         //            MiddleName = "Brenna",
         //            LastName = "Tran",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2014, 5, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 679,
         //            //StudentPersonId = 679,
         //            StateStudentIdentifier = "0703556679",
         //            FirstName = "Cyrus",
         //            MiddleName = "Skyler",
         //            LastName = "Whitley",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2013, 2, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 680,
         //            //StudentPersonId = 680,
         //            StateStudentIdentifier = "0123100680",
         //            FirstName = "Paul",
         //            MiddleName = "Dieter",
         //            LastName = "Cohen",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2006, 5, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 681,
         //            //StudentPersonId = 681,
         //            StateStudentIdentifier = "0366603681",
         //            FirstName = "Aidan",
         //            MiddleName = "Norman",
         //            LastName = "Wade",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2011, 9, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 682,
         //            //StudentPersonId = 682,
         //            StateStudentIdentifier = "0194078682",
         //            FirstName = "Shelly",
         //            MiddleName = "Ayanna",
         //            LastName = "Padilla",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 8, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 683,
         //            //StudentPersonId = 683,
         //            StateStudentIdentifier = "0470871683",
         //            FirstName = "Ulla",
         //            MiddleName = "Vladimir",
         //            LastName = "Washington",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 10, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 684,
         //            //StudentPersonId = 684,
         //            StateStudentIdentifier = "0902608684",
         //            FirstName = "Vivian",
         //            MiddleName = "MacKenzie",
         //            LastName = "Mayer",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2015, 11, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 685,
         //            //StudentPersonId = 685,
         //            StateStudentIdentifier = "0909120685",
         //            FirstName = "Charlotte",
         //            MiddleName = "Clementine",
         //            LastName = "Salinas",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 3, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 686,
         //            //StudentPersonId = 686,
         //            StateStudentIdentifier = "0337611686",
         //            FirstName = "Mason",
         //            MiddleName = "Isaac",
         //            LastName = "Hanson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 11, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 687,
         //            //StudentPersonId = 687,
         //            StateStudentIdentifier = "0882553687",
         //            FirstName = "Cooper",
         //            MiddleName = "Christopher",
         //            LastName = "Cash",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2004, 8, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 688,
         //            //StudentPersonId = 688,
         //            StateStudentIdentifier = "0846202688",
         //            FirstName = "Martha",
         //            MiddleName = "Chiquita",
         //            LastName = "Riddle",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 10, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 689,
         //            //StudentPersonId = 689,
         //            StateStudentIdentifier = "0591834689",
         //            FirstName = "Alvin",
         //            MiddleName = "Raphael",
         //            LastName = "Hunt",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2017, 8, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 690,
         //            //StudentPersonId = 690,
         //            StateStudentIdentifier = "0805810690",
         //            FirstName = "Cullen",
         //            MiddleName = "Giacomo",
         //            LastName = "Weiss",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 1, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 691,
         //            //StudentPersonId = 691,
         //            StateStudentIdentifier = "0054352691",
         //            FirstName = "Veda",
         //            MiddleName = "Lani",
         //            LastName = "Keith",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2011, 3, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 692,
         //            //StudentPersonId = 692,
         //            StateStudentIdentifier = "0670854692",
         //            FirstName = "Ryan",
         //            MiddleName = "Shaine",
         //            LastName = "Benton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 7, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 693,
         //            //StudentPersonId = 693,
         //            StateStudentIdentifier = "0323026693",
         //            FirstName = "Henry",
         //            MiddleName = "Leonard",
         //            LastName = "Gilliam",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 3, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 694,
         //            //StudentPersonId = 694,
         //            StateStudentIdentifier = "0003354694",
         //            FirstName = "India",
         //            MiddleName = "Scarlet",
         //            LastName = "Soto",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 1, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 695,
         //            //StudentPersonId = 695,
         //            StateStudentIdentifier = "0146670695",
         //            FirstName = "Elijah",
         //            MiddleName = "Levi",
         //            LastName = "Stuart",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2005, 3, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 696,
         //            //StudentPersonId = 696,
         //            StateStudentIdentifier = "0180465696",
         //            FirstName = "Summer",
         //            MiddleName = "Hedwig",
         //            LastName = "Woods",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 10, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 697,
         //            //StudentPersonId = 697,
         //            StateStudentIdentifier = "0950335697",
         //            FirstName = "Daniel",
         //            MiddleName = "Axel",
         //            LastName = "Mcclain",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 12, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 698,
         //            //StudentPersonId = 698,
         //            StateStudentIdentifier = "0213955698",
         //            FirstName = "Anthony",
         //            MiddleName = "Cairo",
         //            LastName = "Schroeder",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 11, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 699,
         //            //StudentPersonId = 699,
         //            StateStudentIdentifier = "0147704699",
         //            FirstName = "Channing",
         //            MiddleName = "Travis",
         //            LastName = "Barlow",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2013, 1, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 700,
         //            //StudentPersonId = 700,
         //            StateStudentIdentifier = "0069054700",
         //            FirstName = "Ian",
         //            MiddleName = "Shafira",
         //            LastName = "Simon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 3, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 701,
         //            //StudentPersonId = 701,
         //            StateStudentIdentifier = "0283743701",
         //            FirstName = "Hannah",
         //            MiddleName = "Montana",
         //            LastName = "Jennings",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 6, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 702,
         //            //StudentPersonId = 702,
         //            StateStudentIdentifier = "0116550702",
         //            FirstName = "Lane",
         //            MiddleName = "Peter",
         //            LastName = "Durham",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 6, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 703,
         //            //StudentPersonId = 703,
         //            StateStudentIdentifier = "0341665703",
         //            FirstName = "Charlotte",
         //            MiddleName = "Ingrid",
         //            LastName = "Ballard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 1, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 704,
         //            //StudentPersonId = 704,
         //            StateStudentIdentifier = "0762450704",
         //            FirstName = "Thomas",
         //            MiddleName = "Christopher",
         //            LastName = "Franco",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 11, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 705,
         //            //StudentPersonId = 705,
         //            StateStudentIdentifier = "0133840705",
         //            FirstName = "Cadman",
         //            MiddleName = "Dorian",
         //            LastName = "Hurst",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2018, 10, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 706,
         //            //StudentPersonId = 706,
         //            StateStudentIdentifier = "0230370706",
         //            FirstName = "Pearl",
         //            MiddleName = "Paula",
         //            LastName = "Warren",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2016, 12, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 707,
         //            //StudentPersonId = 707,
         //            StateStudentIdentifier = "0790819707",
         //            FirstName = "Simone",
         //            MiddleName = "Tyler",
         //            LastName = "Nielsen",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(1998, 6, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 708,
         //            //StudentPersonId = 708,
         //            StateStudentIdentifier = "0121935708",
         //            FirstName = "Vivian",
         //            MiddleName = "Jaime",
         //            LastName = "Burke",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 5, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 709,
         //            //StudentPersonId = 709,
         //            StateStudentIdentifier = "0167342709",
         //            FirstName = "Valentine",
         //            MiddleName = "Xaviera",
         //            LastName = "Beach",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 6, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 710,
         //            //StudentPersonId = 710,
         //            StateStudentIdentifier = "0846721710",
         //            FirstName = "Grace",
         //            MiddleName = "Fallon",
         //            LastName = "Soto",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2017, 11, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 711,
         //            //StudentPersonId = 711,
         //            StateStudentIdentifier = "0353648711",
         //            FirstName = "Claire",
         //            MiddleName = "Fleur",
         //            LastName = "Giovanitti",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 8, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 712,
         //            //StudentPersonId = 712,
         //            StateStudentIdentifier = "0161920712",
         //            FirstName = "Sheila",
         //            MiddleName = "Rachel",
         //            LastName = "Dominguez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 11, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 713,
         //            //StudentPersonId = 713,
         //            StateStudentIdentifier = "0078068713",
         //            FirstName = "Camille",
         //            MiddleName = "Chandler",
         //            LastName = "Mercer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 3, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 714,
         //            //StudentPersonId = 714,
         //            StateStudentIdentifier = "0689983714",
         //            FirstName = "Erich",
         //            MiddleName = "Lev",
         //            LastName = "Kent",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2007, 7, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 715,
         //            //StudentPersonId = 715,
         //            StateStudentIdentifier = "0334766715",
         //            FirstName = "Jana",
         //            MiddleName = "Lesley",
         //            LastName = "Fox",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 5, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 716,
         //            //StudentPersonId = 716,
         //            StateStudentIdentifier = "0255789716",
         //            FirstName = "Zane",
         //            MiddleName = "Rooney",
         //            LastName = "Arnold",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 9, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 717,
         //            //StudentPersonId = 717,
         //            StateStudentIdentifier = "0886101717",
         //            FirstName = "Serena",
         //            MiddleName = "Amelia",
         //            LastName = "Cohen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 8, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 718,
         //            //StudentPersonId = 718,
         //            StateStudentIdentifier = "0471279718",
         //            FirstName = "Kessie",
         //            MiddleName = "Akeem",
         //            LastName = "Garcia",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 9, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 719,
         //            //StudentPersonId = 719,
         //            StateStudentIdentifier = "0802971719",
         //            FirstName = "Russell",
         //            MiddleName = "Philip",
         //            LastName = "Kim",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2003, 3, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 720,
         //            //StudentPersonId = 720,
         //            StateStudentIdentifier = "0831500720",
         //            FirstName = "Ursa",
         //            MiddleName = "Leah",
         //            LastName = "Fuentes",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2005, 9, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 721,
         //            //StudentPersonId = 721,
         //            StateStudentIdentifier = "0833397721",
         //            FirstName = "Bell",
         //            MiddleName = "Riley",
         //            LastName = "Hansen",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 5, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 722,
         //            //StudentPersonId = 722,
         //            StateStudentIdentifier = "0045145722",
         //            FirstName = "Tiger",
         //            MiddleName = "Gage",
         //            LastName = "Sweet",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 3, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 723,
         //            //StudentPersonId = 723,
         //            StateStudentIdentifier = "0530273723",
         //            FirstName = "Curran",
         //            MiddleName = "Drake",
         //            LastName = "Glass",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2006, 6, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 724,
         //            //StudentPersonId = 724,
         //            StateStudentIdentifier = "0193244724",
         //            FirstName = "Jeremy",
         //            MiddleName = "Lyle",
         //            LastName = "Mercado",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 11, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 725,
         //            //StudentPersonId = 725,
         //            StateStudentIdentifier = "0057424725",
         //            FirstName = "Myra",
         //            MiddleName = "Amena",
         //            LastName = "Lopez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 11, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 726,
         //            //StudentPersonId = 726,
         //            StateStudentIdentifier = "0133788726",
         //            FirstName = "Reece",
         //            MiddleName = "Orson",
         //            LastName = "Pate",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 12, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 727,
         //            //StudentPersonId = 727,
         //            StateStudentIdentifier = "0128820727",
         //            FirstName = "Alfonso",
         //            MiddleName = "August",
         //            LastName = "Baker",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 5, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 728,
         //            //StudentPersonId = 728,
         //            StateStudentIdentifier = "0643411728",
         //            FirstName = "Lois",
         //            MiddleName = "Zorita",
         //            LastName = "Snow",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 6, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 729,
         //            //StudentPersonId = 729,
         //            StateStudentIdentifier = "0911123729",
         //            FirstName = "Oprah",
         //            MiddleName = "Paloma",
         //            LastName = "Hernandez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 3, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 730,
         //            //StudentPersonId = 730,
         //            StateStudentIdentifier = "0051428730",
         //            FirstName = "Wynter",
         //            MiddleName = "Blaine",
         //            LastName = "Chaney",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 4, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 731,
         //            //StudentPersonId = 731,
         //            StateStudentIdentifier = "0657598731",
         //            FirstName = "Melvin",
         //            MiddleName = "Evan",
         //            LastName = "Harding",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 1, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 732,
         //            //StudentPersonId = 732,
         //            StateStudentIdentifier = "0790559732",
         //            FirstName = "Anika",
         //            MiddleName = "Violet",
         //            LastName = "Frazier",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2006, 4, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 733,
         //            //StudentPersonId = 733,
         //            StateStudentIdentifier = "0712870733",
         //            FirstName = "Brianna",
         //            MiddleName = "Ria",
         //            LastName = "Ingram",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 3, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 734,
         //            //StudentPersonId = 734,
         //            StateStudentIdentifier = "0244005734",
         //            FirstName = "Sarah",
         //            MiddleName = "April",
         //            LastName = "Guzman",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 7, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 735,
         //            //StudentPersonId = 735,
         //            StateStudentIdentifier = "0657179735",
         //            FirstName = "Patrick",
         //            MiddleName = "Malcolm",
         //            LastName = "Bailey",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 12, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 736,
         //            //StudentPersonId = 736,
         //            StateStudentIdentifier = "0217012736",
         //            FirstName = "Gabriel",
         //            MiddleName = "Preston",
         //            LastName = "Thomas",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 11, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 737,
         //            //StudentPersonId = 737,
         //            StateStudentIdentifier = "0800572737",
         //            FirstName = "Nada",
         //            MiddleName = "Gail",
         //            LastName = "Woods",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 8, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 738,
         //            //StudentPersonId = 738,
         //            StateStudentIdentifier = "0186666738",
         //            FirstName = "Aretha",
         //            MiddleName = "Cheryl",
         //            LastName = "Hull",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 3, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 739,
         //            //StudentPersonId = 739,
         //            StateStudentIdentifier = "0233041739",
         //            FirstName = "Reece",
         //            MiddleName = "Bert",
         //            LastName = "Barlow",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 12, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 740,
         //            //StudentPersonId = 740,
         //            StateStudentIdentifier = "0434484740",
         //            FirstName = "Caesar",
         //            MiddleName = "Colby",
         //            LastName = "Huber",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2004, 6, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 741,
         //            //StudentPersonId = 741,
         //            StateStudentIdentifier = "0692955741",
         //            FirstName = "Debra",
         //            MiddleName = "McKenzie",
         //            LastName = "Cote",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 6, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 742,
         //            //StudentPersonId = 742,
         //            StateStudentIdentifier = "0145215742",
         //            FirstName = "Ocean",
         //            MiddleName = "Lois",
         //            LastName = "Marshall",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1998, 6, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 743,
         //            //StudentPersonId = 743,
         //            StateStudentIdentifier = "0607743743",
         //            FirstName = "Faith",
         //            MiddleName = "Meghan",
         //            LastName = "Mooney",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 12, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 744,
         //            //StudentPersonId = 744,
         //            StateStudentIdentifier = "0011629744",
         //            FirstName = "Mariam",
         //            MiddleName = "Medge",
         //            LastName = "Boyle",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2007, 3, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 745,
         //            //StudentPersonId = 745,
         //            StateStudentIdentifier = "0002737745",
         //            FirstName = "Daphne",
         //            MiddleName = "Oprah",
         //            LastName = "Clark",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 9, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 746,
         //            //StudentPersonId = 746,
         //            StateStudentIdentifier = "0474144746",
         //            FirstName = "Aurora",
         //            MiddleName = "Lara",
         //            LastName = "Marshall",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1999, 3, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 747,
         //            //StudentPersonId = 747,
         //            StateStudentIdentifier = "0404353747",
         //            FirstName = "Melyssa",
         //            MiddleName = "Cameron",
         //            LastName = "Rhodes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 8, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 748,
         //            //StudentPersonId = 748,
         //            StateStudentIdentifier = "0660468748",
         //            FirstName = "Chiquita",
         //            MiddleName = "Lance",
         //            LastName = "Sampson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 5, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 749,
         //            //StudentPersonId = 749,
         //            StateStudentIdentifier = "0138356749",
         //            FirstName = "Oscar",
         //            MiddleName = "Thaddeus",
         //            LastName = "Maynard",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 2, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 750,
         //            //StudentPersonId = 750,
         //            StateStudentIdentifier = "0615878750",
         //            FirstName = "Regan",
         //            MiddleName = "Emily",
         //            LastName = "Huff",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2011, 3, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 751,
         //            //StudentPersonId = 751,
         //            StateStudentIdentifier = "0607941751",
         //            FirstName = "Willow",
         //            MiddleName = "Willa",
         //            LastName = "Huff",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2017, 3, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 752,
         //            //StudentPersonId = 752,
         //            StateStudentIdentifier = "0445804752",
         //            FirstName = "Alan",
         //            MiddleName = "Demetrius",
         //            LastName = "Stout",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 12, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 753,
         //            //StudentPersonId = 753,
         //            StateStudentIdentifier = "0238406753",
         //            FirstName = "Victor",
         //            MiddleName = "Arsenio",
         //            LastName = "Camacho",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 9, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 754,
         //            //StudentPersonId = 754,
         //            StateStudentIdentifier = "0541406754",
         //            FirstName = "Abbot",
         //            MiddleName = "Fuller",
         //            LastName = "Hebert",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 8, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 755,
         //            //StudentPersonId = 755,
         //            StateStudentIdentifier = "0388184755",
         //            FirstName = "Xaviera",
         //            MiddleName = "Jasmin",
         //            LastName = "Kelly",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 9, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 756,
         //            //StudentPersonId = 756,
         //            StateStudentIdentifier = "0966910756",
         //            FirstName = "Acton",
         //            MiddleName = "Barry",
         //            LastName = "Sutton",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2016, 1, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 757,
         //            //StudentPersonId = 757,
         //            StateStudentIdentifier = "0969341757",
         //            FirstName = "Daryl",
         //            MiddleName = "Sacha",
         //            LastName = "Nicholson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 2, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 758,
         //            //StudentPersonId = 758,
         //            StateStudentIdentifier = "0841439758",
         //            FirstName = "Halla",
         //            MiddleName = "Gillian",
         //            LastName = "Kramer",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2016, 3, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 759,
         //            //StudentPersonId = 759,
         //            StateStudentIdentifier = "0533272759",
         //            FirstName = "Palmer",
         //            MiddleName = "Ronan",
         //            LastName = "Underwood",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 6, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 760,
         //            //StudentPersonId = 760,
         //            StateStudentIdentifier = "0942220760",
         //            FirstName = "Jennifer",
         //            MiddleName = "Juliet",
         //            LastName = "Chase",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 4, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 761,
         //            //StudentPersonId = 761,
         //            StateStudentIdentifier = "0244544761",
         //            FirstName = "Lacota",
         //            MiddleName = "Aubrey",
         //            LastName = "Parrish",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 12, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 762,
         //            //StudentPersonId = 762,
         //            StateStudentIdentifier = "0384305762",
         //            FirstName = "Amery",
         //            MiddleName = "Jared",
         //            LastName = "Harrington",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 9, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 763,
         //            //StudentPersonId = 763,
         //            StateStudentIdentifier = "0188524763",
         //            FirstName = "Bradley",
         //            MiddleName = "Vaughan",
         //            LastName = "Stevens",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 8, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 764,
         //            //StudentPersonId = 764,
         //            StateStudentIdentifier = "0672067764",
         //            FirstName = "Lynn",
         //            MiddleName = "Montana",
         //            LastName = "Oliver",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 12, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 765,
         //            //StudentPersonId = 765,
         //            StateStudentIdentifier = "0042245765",
         //            FirstName = "Hilel",
         //            MiddleName = "Finn",
         //            LastName = "Roberson",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2011, 10, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 766,
         //            //StudentPersonId = 766,
         //            StateStudentIdentifier = "0983142766",
         //            FirstName = "Griffith",
         //            MiddleName = "Emily",
         //            LastName = "Knowles",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 7, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 767,
         //            //StudentPersonId = 767,
         //            StateStudentIdentifier = "0506250767",
         //            FirstName = "Hedley",
         //            MiddleName = "Daphne",
         //            LastName = "Webster",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 6, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 768,
         //            //StudentPersonId = 768,
         //            StateStudentIdentifier = "0550130768",
         //            FirstName = "Velma",
         //            MiddleName = "Sharmila",
         //            LastName = "Rojas",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 7, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 769,
         //            //StudentPersonId = 769,
         //            StateStudentIdentifier = "0125378769",
         //            FirstName = "Clinton",
         //            MiddleName = "Aidan",
         //            LastName = "Burt",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 2, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 770,
         //            //StudentPersonId = 770,
         //            StateStudentIdentifier = "0262292770",
         //            FirstName = "Bob",
         //            MiddleName = "Brent",
         //            LastName = "Petersen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 10, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 771,
         //            //StudentPersonId = 771,
         //            StateStudentIdentifier = "0717473771",
         //            FirstName = "Bethany",
         //            MiddleName = "Ella",
         //            LastName = "Bruce",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2011, 8, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 772,
         //            //StudentPersonId = 772,
         //            StateStudentIdentifier = "0796306772",
         //            FirstName = "Armand",
         //            MiddleName = "Ignatius",
         //            LastName = "Weeks",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2012, 3, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 773,
         //            //StudentPersonId = 773,
         //            StateStudentIdentifier = "0603461773",
         //            FirstName = "Sonya",
         //            MiddleName = "Flavia",
         //            LastName = "Sexton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 2, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 774,
         //            //StudentPersonId = 774,
         //            StateStudentIdentifier = "0295275774",
         //            FirstName = "Ivana",
         //            MiddleName = "Dale",
         //            LastName = "Barnes",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2008, 3, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 775,
         //            //StudentPersonId = 775,
         //            StateStudentIdentifier = "0511170775",
         //            FirstName = "Owen",
         //            MiddleName = "Tyrone",
         //            LastName = "Hunter",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 8, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 776,
         //            //StudentPersonId = 776,
         //            StateStudentIdentifier = "0705724776",
         //            FirstName = "Jocelyn",
         //            MiddleName = "Upasana",
         //            LastName = "Calhoun",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 1, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 777,
         //            //StudentPersonId = 777,
         //            StateStudentIdentifier = "0972990777",
         //            FirstName = "Xavier",
         //            MiddleName = "Odysseus",
         //            LastName = "Pierce",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 3, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 778,
         //            //StudentPersonId = 778,
         //            StateStudentIdentifier = "0606297778",
         //            FirstName = "Ria",
         //            MiddleName = "Rinah",
         //            LastName = "Good",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2002, 2, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 779,
         //            //StudentPersonId = 779,
         //            StateStudentIdentifier = "0383126779",
         //            FirstName = "Meghan",
         //            MiddleName = "Iris",
         //            LastName = "Combs",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 7, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 780,
         //            //StudentPersonId = 780,
         //            StateStudentIdentifier = "0979561780",
         //            FirstName = "Chase",
         //            MiddleName = "Garrett",
         //            LastName = "Jordan",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2006, 10, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 781,
         //            //StudentPersonId = 781,
         //            StateStudentIdentifier = "0358209781",
         //            FirstName = "Duncan",
         //            MiddleName = "Michael",
         //            LastName = "Meyer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 4, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 782,
         //            //StudentPersonId = 782,
         //            StateStudentIdentifier = "0032717782",
         //            FirstName = "Bob",
         //            MiddleName = "Keane",
         //            LastName = "Hicks",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 1, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 783,
         //            //StudentPersonId = 783,
         //            StateStudentIdentifier = "0780168783",
         //            FirstName = "Macaulay",
         //            MiddleName = "Jaden",
         //            LastName = "Acosta",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 7, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 784,
         //            //StudentPersonId = 784,
         //            StateStudentIdentifier = "0556152784",
         //            FirstName = "Hashim",
         //            MiddleName = "Lawrence",
         //            LastName = "Fry",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 4, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 785,
         //            //StudentPersonId = 785,
         //            StateStudentIdentifier = "0867886785",
         //            FirstName = "Shay",
         //            MiddleName = "Jarrod",
         //            LastName = "Mccormick",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 12, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 786,
         //            //StudentPersonId = 786,
         //            StateStudentIdentifier = "0452734786",
         //            FirstName = "Orla",
         //            MiddleName = "Fleur",
         //            LastName = "Roman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 9, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 787,
         //            //StudentPersonId = 787,
         //            StateStudentIdentifier = "0201616787",
         //            FirstName = "Uta",
         //            MiddleName = "Katelyn",
         //            LastName = "Stout",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 1, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 788,
         //            //StudentPersonId = 788,
         //            StateStudentIdentifier = "0289675788",
         //            FirstName = "Orlando",
         //            MiddleName = "Harper",
         //            LastName = "Phelps",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 2, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 789,
         //            //StudentPersonId = 789,
         //            StateStudentIdentifier = "0950727789",
         //            FirstName = "Anjolie",
         //            MiddleName = "Maggy",
         //            LastName = "Espinoza",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 3, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 790,
         //            //StudentPersonId = 790,
         //            StateStudentIdentifier = "0663968790",
         //            FirstName = "Cade",
         //            MiddleName = "Rajeev",
         //            LastName = "Good",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2010, 4, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 791,
         //            //StudentPersonId = 791,
         //            StateStudentIdentifier = "0599071791",
         //            FirstName = "Rogan",
         //            MiddleName = "Burke",
         //            LastName = "Reyes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 12, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 792,
         //            //StudentPersonId = 792,
         //            StateStudentIdentifier = "0282193792",
         //            FirstName = "Ria",
         //            MiddleName = "Oprah",
         //            LastName = "Black",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 8, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 793,
         //            //StudentPersonId = 793,
         //            StateStudentIdentifier = "0727923793",
         //            FirstName = "Aaron",
         //            MiddleName = "Malcolm",
         //            LastName = "Mcmahon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 6, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 794,
         //            //StudentPersonId = 794,
         //            StateStudentIdentifier = "0106837794",
         //            FirstName = "Amethyst",
         //            MiddleName = "Nina",
         //            LastName = "Daniels",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 11, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 795,
         //            //StudentPersonId = 795,
         //            StateStudentIdentifier = "0287744795",
         //            FirstName = "Teegan",
         //            MiddleName = "Shelly",
         //            LastName = "Holloway",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 11, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 796,
         //            //StudentPersonId = 796,
         //            StateStudentIdentifier = "0536618796",
         //            FirstName = "Fritz",
         //            MiddleName = "Jacob",
         //            LastName = "Pugh",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 5, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 797,
         //            //StudentPersonId = 797,
         //            StateStudentIdentifier = "0244858797",
         //            FirstName = "Alfreda",
         //            MiddleName = "Colette",
         //            LastName = "Bowman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 2, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 798,
         //            //StudentPersonId = 798,
         //            StateStudentIdentifier = "0623889798",
         //            FirstName = "Wynne",
         //            MiddleName = "Dai",
         //            LastName = "Carter",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 1, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 799,
         //            //StudentPersonId = 799,
         //            StateStudentIdentifier = "0043631799",
         //            FirstName = "Gillian",
         //            MiddleName = "Dacey",
         //            LastName = "Lynch",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 8, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 800,
         //            //StudentPersonId = 800,
         //            StateStudentIdentifier = "0043952800",
         //            FirstName = "Merritt",
         //            MiddleName = "Talon",
         //            LastName = "Petersen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 8, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 801,
         //            //StudentPersonId = 801,
         //            StateStudentIdentifier = "0137178801",
         //            FirstName = "Chandler",
         //            MiddleName = "Daniel",
         //            LastName = "Chan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 10, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 802,
         //            //StudentPersonId = 802,
         //            StateStudentIdentifier = "0249744802",
         //            FirstName = "Blake",
         //            MiddleName = "Dorian",
         //            LastName = "Schwartz",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 4, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 803,
         //            //StudentPersonId = 803,
         //            StateStudentIdentifier = "0223400803",
         //            FirstName = "Amelia",
         //            MiddleName = "Maxine",
         //            LastName = "Blair",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 8, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 804,
         //            //StudentPersonId = 804,
         //            StateStudentIdentifier = "0708091804",
         //            FirstName = "Dakota",
         //            MiddleName = "Gareth",
         //            LastName = "Slater",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 11, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 805,
         //            //StudentPersonId = 805,
         //            StateStudentIdentifier = "0474746805",
         //            FirstName = "Bell",
         //            MiddleName = "Cherokee",
         //            LastName = "Bruce",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 6, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 806,
         //            //StudentPersonId = 806,
         //            StateStudentIdentifier = "0752129806",
         //            FirstName = "Sigourney",
         //            MiddleName = "Orla",
         //            LastName = "Mercado",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2006, 9, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 807,
         //            //StudentPersonId = 807,
         //            StateStudentIdentifier = "0673252807",
         //            FirstName = "Todd",
         //            MiddleName = "Jameson",
         //            LastName = "Roberson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 8, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 808,
         //            //StudentPersonId = 808,
         //            StateStudentIdentifier = "0038518808",
         //            FirstName = "Kalia",
         //            MiddleName = "Joelle",
         //            LastName = "Navarro",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 5, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 809,
         //            //StudentPersonId = 809,
         //            StateStudentIdentifier = "0087885809",
         //            FirstName = "Xaviera",
         //            MiddleName = "Althea",
         //            LastName = "Hoover",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 1, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 810,
         //            //StudentPersonId = 810,
         //            StateStudentIdentifier = "0949142810",
         //            FirstName = "Josephine",
         //            MiddleName = "Griffin",
         //            LastName = "Carey",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2015, 7, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 811,
         //            //StudentPersonId = 811,
         //            StateStudentIdentifier = "0664452811",
         //            FirstName = "Conan",
         //            MiddleName = "Colby",
         //            LastName = "Jones",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 8, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 812,
         //            //StudentPersonId = 812,
         //            StateStudentIdentifier = "0590262812",
         //            FirstName = "Solomon",
         //            MiddleName = "Reese",
         //            LastName = "Dejesus",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 12, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 813,
         //            //StudentPersonId = 813,
         //            StateStudentIdentifier = "0170583813",
         //            FirstName = "Quintessa",
         //            MiddleName = "Kelsey",
         //            LastName = "Jenkins",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1997, 10, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 814,
         //            //StudentPersonId = 814,
         //            StateStudentIdentifier = "0939074814",
         //            FirstName = "Kareem",
         //            MiddleName = "Gavin",
         //            LastName = "Holcomb",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 4, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 815,
         //            //StudentPersonId = 815,
         //            StateStudentIdentifier = "0323395815",
         //            FirstName = "Illiana",
         //            MiddleName = "Casey",
         //            LastName = "Tran",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 11, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 816,
         //            //StudentPersonId = 816,
         //            StateStudentIdentifier = "0108271816",
         //            FirstName = "Kareem",
         //            MiddleName = "Steel",
         //            LastName = "Powell",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 8, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 817,
         //            //StudentPersonId = 817,
         //            StateStudentIdentifier = "0844081817",
         //            FirstName = "Edan",
         //            MiddleName = "Tanner",
         //            LastName = "Jenkins",
         //            Cohort = null,
         //            BirthDate = new DateTime(2020, 1, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 818,
         //            //StudentPersonId = 818,
         //            StateStudentIdentifier = "0345451818",
         //            FirstName = "Donovan",
         //            MiddleName = "James",
         //            LastName = "Mckinney",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 2, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 819,
         //            //StudentPersonId = 819,
         //            StateStudentIdentifier = "0211745819",
         //            FirstName = "Cassandra",
         //            MiddleName = "Maxine",
         //            LastName = "Osborn",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 11, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 820,
         //            //StudentPersonId = 820,
         //            StateStudentIdentifier = "0148494820",
         //            FirstName = "Giselle",
         //            MiddleName = "Jayme",
         //            LastName = "Joyce",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 8, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 821,
         //            //StudentPersonId = 821,
         //            StateStudentIdentifier = "0387115821",
         //            FirstName = "Anjolie",
         //            MiddleName = "Tashya",
         //            LastName = "Bell",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 8, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 822,
         //            //StudentPersonId = 822,
         //            StateStudentIdentifier = "0098116822",
         //            FirstName = "Garrison",
         //            MiddleName = "Oren",
         //            LastName = "Ortiz",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 1, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 823,
         //            //StudentPersonId = 823,
         //            StateStudentIdentifier = "0240238823",
         //            FirstName = "Emma",
         //            MiddleName = "Nevada",
         //            LastName = "Solomon",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2015, 6, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 824,
         //            //StudentPersonId = 824,
         //            StateStudentIdentifier = "0097992824",
         //            FirstName = "Cedric",
         //            MiddleName = "Abdul",
         //            LastName = "Lynch",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 5, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 825,
         //            //StudentPersonId = 825,
         //            StateStudentIdentifier = "0677435825",
         //            FirstName = "Cassady",
         //            MiddleName = "Penelope",
         //            LastName = "Guy",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 7, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 826,
         //            //StudentPersonId = 826,
         //            StateStudentIdentifier = "0259171826",
         //            FirstName = "Ross",
         //            MiddleName = "Palmer",
         //            LastName = "Sheppard",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2004, 11, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 827,
         //            //StudentPersonId = 827,
         //            StateStudentIdentifier = "0786121827",
         //            FirstName = "Delilah",
         //            MiddleName = "Orli",
         //            LastName = "Fuentes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 6, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 828,
         //            //StudentPersonId = 828,
         //            StateStudentIdentifier = "0806585828",
         //            FirstName = "Lois",
         //            MiddleName = "Lesley",
         //            LastName = "Hobbs",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1998, 1, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 829,
         //            //StudentPersonId = 829,
         //            StateStudentIdentifier = "0611301829",
         //            FirstName = "Orlando",
         //            MiddleName = "Logan",
         //            LastName = "Gibson",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2016, 11, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 830,
         //            //StudentPersonId = 830,
         //            StateStudentIdentifier = "0919495830",
         //            FirstName = "Dorian",
         //            MiddleName = "Norman",
         //            LastName = "Holden",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1999, 4, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 831,
         //            //StudentPersonId = 831,
         //            StateStudentIdentifier = "0634893831",
         //            FirstName = "Kermit",
         //            MiddleName = "Hammett",
         //            LastName = "Ferguson",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2001, 9, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 832,
         //            //StudentPersonId = 832,
         //            StateStudentIdentifier = "0848243832",
         //            FirstName = "Ali",
         //            MiddleName = "Kamal",
         //            LastName = "Mcgowan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 12, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 833,
         //            //StudentPersonId = 833,
         //            StateStudentIdentifier = "0384613833",
         //            FirstName = "Ocean",
         //            MiddleName = "Darryl",
         //            LastName = "Sherman",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 2, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 834,
         //            //StudentPersonId = 834,
         //            StateStudentIdentifier = "0370143834",
         //            FirstName = "Kiara",
         //            MiddleName = "Amy",
         //            LastName = "Franks",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 1, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 835,
         //            //StudentPersonId = 835,
         //            StateStudentIdentifier = "0211384835",
         //            FirstName = "Nash",
         //            MiddleName = "Xander",
         //            LastName = "Pugh",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 1, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 836,
         //            //StudentPersonId = 836,
         //            StateStudentIdentifier = "0268380836",
         //            FirstName = "Kenneth",
         //            MiddleName = "Paki",
         //            LastName = "Guthrie",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 9, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 837,
         //            //StudentPersonId = 837,
         //            StateStudentIdentifier = "0835557837",
         //            FirstName = "Tarik",
         //            MiddleName = "Hashim",
         //            LastName = "Wolfe",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1995, 5, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 838,
         //            //StudentPersonId = 838,
         //            StateStudentIdentifier = "0416615838",
         //            FirstName = "Debra",
         //            MiddleName = "Aurelia",
         //            LastName = "Pugh",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 10, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 839,
         //            //StudentPersonId = 839,
         //            StateStudentIdentifier = "0826066839",
         //            FirstName = "Linus",
         //            MiddleName = "Sebastian",
         //            LastName = "Reynolds",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1999, 6, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 840,
         //            //StudentPersonId = 840,
         //            StateStudentIdentifier = "0841689840",
         //            FirstName = "Brenna",
         //            MiddleName = "Alfreda",
         //            LastName = "Holt",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1996, 2, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 841,
         //            //StudentPersonId = 841,
         //            StateStudentIdentifier = "0303723841",
         //            FirstName = "Hanna",
         //            MiddleName = "Libby",
         //            LastName = "Holcomb",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 8, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 842,
         //            //StudentPersonId = 842,
         //            StateStudentIdentifier = "0551868842",
         //            FirstName = "Colin",
         //            MiddleName = "Armando",
         //            LastName = "Navarro",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 11, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 843,
         //            //StudentPersonId = 843,
         //            StateStudentIdentifier = "0548517843",
         //            FirstName = "Yvette",
         //            MiddleName = "Holly",
         //            LastName = "Fletcher",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 1, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 844,
         //            //StudentPersonId = 844,
         //            StateStudentIdentifier = "0951713844",
         //            FirstName = "Willow",
         //            MiddleName = "Faith",
         //            LastName = "Morales",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 7, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 845,
         //            //StudentPersonId = 845,
         //            StateStudentIdentifier = "0539556845",
         //            FirstName = "Ralph",
         //            MiddleName = "Kyle",
         //            LastName = "Jackson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 11, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 846,
         //            //StudentPersonId = 846,
         //            StateStudentIdentifier = "0399869846",
         //            FirstName = "Tad",
         //            MiddleName = "Rashad",
         //            LastName = "Wilson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 11, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 847,
         //            //StudentPersonId = 847,
         //            StateStudentIdentifier = "0287411847",
         //            FirstName = "Sydnee",
         //            MiddleName = "Veda",
         //            LastName = "Ward",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 1, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 848,
         //            //StudentPersonId = 848,
         //            StateStudentIdentifier = "0813324848",
         //            FirstName = "Noelle",
         //            MiddleName = "Wilma",
         //            LastName = "Hanson",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2018, 4, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 849,
         //            //StudentPersonId = 849,
         //            StateStudentIdentifier = "0285835849",
         //            FirstName = "Paki",
         //            MiddleName = "Austin",
         //            LastName = "Carpenter",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2016, 7, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 850,
         //            //StudentPersonId = 850,
         //            StateStudentIdentifier = "0919966850",
         //            FirstName = "Cruz",
         //            MiddleName = "Tucker",
         //            LastName = "Stanley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 1, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 851,
         //            //StudentPersonId = 851,
         //            StateStudentIdentifier = "0876999851",
         //            FirstName = "Cedric",
         //            MiddleName = "Donovan",
         //            LastName = "Velazquez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 5, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 852,
         //            //StudentPersonId = 852,
         //            StateStudentIdentifier = "0067644852",
         //            FirstName = "Callum",
         //            MiddleName = "Lucas",
         //            LastName = "Rutledge",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 6, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 853,
         //            //StudentPersonId = 853,
         //            StateStudentIdentifier = "0759095853",
         //            FirstName = "Malik",
         //            MiddleName = "Kasimir",
         //            LastName = "Robinson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 2, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 854,
         //            //StudentPersonId = 854,
         //            StateStudentIdentifier = "0824307854",
         //            FirstName = "Juliet",
         //            MiddleName = "Hayley",
         //            LastName = "Hunter",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 12, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 855,
         //            //StudentPersonId = 855,
         //            StateStudentIdentifier = "0026310855",
         //            FirstName = "Eve",
         //            MiddleName = "September",
         //            LastName = "Mckee",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2014, 9, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 856,
         //            //StudentPersonId = 856,
         //            StateStudentIdentifier = "0138271856",
         //            FirstName = "Tatiana",
         //            MiddleName = "Bradley",
         //            LastName = "Mckinney",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 3, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 857,
         //            //StudentPersonId = 857,
         //            StateStudentIdentifier = "0886427857",
         //            FirstName = "Gage",
         //            MiddleName = "Boris",
         //            LastName = "Patterson",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 4, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 858,
         //            //StudentPersonId = 858,
         //            StateStudentIdentifier = "0146721858",
         //            FirstName = "Martha",
         //            MiddleName = "Cecilia",
         //            LastName = "Barrett",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 2, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 859,
         //            //StudentPersonId = 859,
         //            StateStudentIdentifier = "0326771859",
         //            FirstName = "Porter",
         //            MiddleName = "Mannix",
         //            LastName = "Roman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 1, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 860,
         //            //StudentPersonId = 860,
         //            StateStudentIdentifier = "0652567860",
         //            FirstName = "Pavel",
         //            MiddleName = "Cruz",
         //            LastName = "Hess",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 1, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 861,
         //            //StudentPersonId = 861,
         //            StateStudentIdentifier = "0728169861",
         //            FirstName = "Aimee",
         //            MiddleName = "Aurora",
         //            LastName = "Irwin",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 5, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 862,
         //            //StudentPersonId = 862,
         //            StateStudentIdentifier = "0769661862",
         //            FirstName = "Eagan",
         //            MiddleName = "Aladdin",
         //            LastName = "Good",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 10, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 863,
         //            //StudentPersonId = 863,
         //            StateStudentIdentifier = "0360201863",
         //            FirstName = "Dennis",
         //            MiddleName = "Ciaran",
         //            LastName = "Marsh",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2001, 11, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 864,
         //            //StudentPersonId = 864,
         //            StateStudentIdentifier = "0826879864",
         //            FirstName = "Maia",
         //            MiddleName = "Charlotte",
         //            LastName = "Haney",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 9, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 865,
         //            //StudentPersonId = 865,
         //            StateStudentIdentifier = "0694971865",
         //            FirstName = "Anthony",
         //            MiddleName = "Dolan",
         //            LastName = "Nolan",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 8, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 866,
         //            //StudentPersonId = 866,
         //            StateStudentIdentifier = "0395215866",
         //            FirstName = "Jasper",
         //            MiddleName = "Bernard",
         //            LastName = "Ratliff",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 4, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 867,
         //            //StudentPersonId = 867,
         //            StateStudentIdentifier = "0381897867",
         //            FirstName = "Ethan",
         //            MiddleName = "Connor",
         //            LastName = "Knox",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 10, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 868,
         //            //StudentPersonId = 868,
         //            StateStudentIdentifier = "0319066868",
         //            FirstName = "Kaitlin",
         //            MiddleName = "Chantale",
         //            LastName = "Bolton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 8, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 869,
         //            //StudentPersonId = 869,
         //            StateStudentIdentifier = "0915392869",
         //            FirstName = "Chaim",
         //            MiddleName = "Elliott",
         //            LastName = "Ortiz",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 1, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 870,
         //            //StudentPersonId = 870,
         //            StateStudentIdentifier = "0179454870",
         //            FirstName = "Yvonne",
         //            MiddleName = "Alea",
         //            LastName = "Schwartz",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 1, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 871,
         //            //StudentPersonId = 871,
         //            StateStudentIdentifier = "0684152871",
         //            FirstName = "Fay",
         //            MiddleName = "Halee",
         //            LastName = "Gould",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 10, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 872,
         //            //StudentPersonId = 872,
         //            StateStudentIdentifier = "0352153872",
         //            FirstName = "Jayme",
         //            MiddleName = "Quail",
         //            LastName = "Avila",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 4, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 873,
         //            //StudentPersonId = 873,
         //            StateStudentIdentifier = "0280013873",
         //            FirstName = "Laith",
         //            MiddleName = "Branden",
         //            LastName = "Huber",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2000, 12, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 874,
         //            //StudentPersonId = 874,
         //            StateStudentIdentifier = "0170804874",
         //            FirstName = "Tatiana",
         //            MiddleName = "Bo",
         //            LastName = "Simon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 9, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 875,
         //            //StudentPersonId = 875,
         //            StateStudentIdentifier = "0890155875",
         //            FirstName = "Adara",
         //            MiddleName = "Robin",
         //            LastName = "Dixon",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2010, 1, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 876,
         //            //StudentPersonId = 876,
         //            StateStudentIdentifier = "0102684876",
         //            FirstName = "Hunter",
         //            MiddleName = "Jonah",
         //            LastName = "Castillo",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 3, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 877,
         //            //StudentPersonId = 877,
         //            StateStudentIdentifier = "0797306877",
         //            FirstName = "Aspen",
         //            MiddleName = "Haley",
         //            LastName = "Gaines",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 6, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 878,
         //            //StudentPersonId = 878,
         //            StateStudentIdentifier = "0524473878",
         //            FirstName = "Scott",
         //            MiddleName = "Zachery",
         //            LastName = "Salas",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2010, 6, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 879,
         //            //StudentPersonId = 879,
         //            StateStudentIdentifier = "0173791879",
         //            FirstName = "Felicia",
         //            MiddleName = "Tamekah",
         //            LastName = "Rasmussen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 3, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 880,
         //            //StudentPersonId = 880,
         //            StateStudentIdentifier = "0937378880",
         //            FirstName = "Erin",
         //            MiddleName = "Charity",
         //            LastName = "Bennett",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2013, 9, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 881,
         //            //StudentPersonId = 881,
         //            StateStudentIdentifier = "0029105881",
         //            FirstName = "Jonah",
         //            MiddleName = "Victor",
         //            LastName = "Mcdaniel",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 3, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 882,
         //            //StudentPersonId = 882,
         //            StateStudentIdentifier = "0410778882",
         //            FirstName = "Daniel",
         //            MiddleName = "Kyle",
         //            LastName = "Harper",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 12, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 883,
         //            //StudentPersonId = 883,
         //            StateStudentIdentifier = "0070571883",
         //            FirstName = "Russell",
         //            MiddleName = "Ignatius",
         //            LastName = "Phelps",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2018, 7, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 884,
         //            //StudentPersonId = 884,
         //            StateStudentIdentifier = "0323217884",
         //            FirstName = "Uta",
         //            MiddleName = "Cassidy",
         //            LastName = "Wagner",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 6, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 885,
         //            //StudentPersonId = 885,
         //            StateStudentIdentifier = "0208908885",
         //            FirstName = "Reese",
         //            MiddleName = "Ezra",
         //            LastName = "Burt",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 12, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 886,
         //            //StudentPersonId = 886,
         //            StateStudentIdentifier = "0749392886",
         //            FirstName = "Dexter",
         //            MiddleName = "Lucian",
         //            LastName = "Lynn",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2011, 4, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 887,
         //            //StudentPersonId = 887,
         //            StateStudentIdentifier = "0717337887",
         //            FirstName = "Elaine",
         //            MiddleName = "Ariana",
         //            LastName = "Greer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 1, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 888,
         //            //StudentPersonId = 888,
         //            StateStudentIdentifier = "0031475888",
         //            FirstName = "Tyler",
         //            MiddleName = "Vladimir",
         //            LastName = "Bell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 5, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 889,
         //            //StudentPersonId = 889,
         //            StateStudentIdentifier = "0910099889",
         //            FirstName = "Callie",
         //            MiddleName = "Kitra",
         //            LastName = "Fuentes",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 11, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 890,
         //            //StudentPersonId = 890,
         //            StateStudentIdentifier = "0826722890",
         //            FirstName = "Clementine",
         //            MiddleName = "Erin",
         //            LastName = "Randall",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 1, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 891,
         //            //StudentPersonId = 891,
         //            StateStudentIdentifier = "0746225891",
         //            FirstName = "Gray",
         //            MiddleName = "Jeremy",
         //            LastName = "Gibson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 6, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 892,
         //            //StudentPersonId = 892,
         //            StateStudentIdentifier = "0878514892",
         //            FirstName = "Kyla",
         //            MiddleName = "Maile",
         //            LastName = "Powers",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 11, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 893,
         //            //StudentPersonId = 893,
         //            StateStudentIdentifier = "0510746893",
         //            FirstName = "Tobias",
         //            MiddleName = "Hall",
         //            LastName = "Camacho",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 5, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 894,
         //            //StudentPersonId = 894,
         //            StateStudentIdentifier = "0401738894",
         //            FirstName = "Graiden",
         //            MiddleName = "Timon",
         //            LastName = "Wagner",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 10, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 895,
         //            //StudentPersonId = 895,
         //            StateStudentIdentifier = "0432352895",
         //            FirstName = "Zeph",
         //            MiddleName = "Elton",
         //            LastName = "Boyle",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2009, 6, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 896,
         //            //StudentPersonId = 896,
         //            StateStudentIdentifier = "0639936896",
         //            FirstName = "George",
         //            MiddleName = "Bruce",
         //            LastName = "Whitehead",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2016, 9, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 897,
         //            //StudentPersonId = 897,
         //            StateStudentIdentifier = "0981987897",
         //            FirstName = "Elliott",
         //            MiddleName = "Troy",
         //            LastName = "Turner",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 8, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 898,
         //            //StudentPersonId = 898,
         //            StateStudentIdentifier = "0627502898",
         //            FirstName = "Roanna",
         //            MiddleName = "Illiana",
         //            LastName = "Bryant",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 10, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 899,
         //            //StudentPersonId = 899,
         //            StateStudentIdentifier = "0112365899",
         //            FirstName = "Ryan",
         //            MiddleName = "Logan",
         //            LastName = "Rodgers",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 10, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 900,
         //            //StudentPersonId = 900,
         //            StateStudentIdentifier = "0043347900",
         //            FirstName = "Darrel",
         //            MiddleName = "Adrienne",
         //            LastName = "Klein",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 6, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 901,
         //            //StudentPersonId = 901,
         //            StateStudentIdentifier = "0697008901",
         //            FirstName = "Madeline",
         //            MiddleName = "Hanae",
         //            LastName = "Cameron",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 10, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 902,
         //            //StudentPersonId = 902,
         //            StateStudentIdentifier = "0723316902",
         //            FirstName = "Ursula",
         //            MiddleName = "Audrey",
         //            LastName = "Savage",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 8, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 903,
         //            //StudentPersonId = 903,
         //            StateStudentIdentifier = "0799090903",
         //            FirstName = "Cally",
         //            MiddleName = "Nicole",
         //            LastName = "Merritt",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 8, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 904,
         //            //StudentPersonId = 904,
         //            StateStudentIdentifier = "0194134904",
         //            FirstName = "Kaitlin",
         //            MiddleName = "Sybil",
         //            LastName = "Bennett",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 5, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 905,
         //            //StudentPersonId = 905,
         //            StateStudentIdentifier = "0666394905",
         //            FirstName = "Ava",
         //            MiddleName = "Belle",
         //            LastName = "Cabrera",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 10, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 906,
         //            //StudentPersonId = 906,
         //            StateStudentIdentifier = "0479299906",
         //            FirstName = "Rafael",
         //            MiddleName = "Macon",
         //            LastName = "Thomas",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2009, 6, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 907,
         //            //StudentPersonId = 907,
         //            StateStudentIdentifier = "0228615907",
         //            FirstName = "Evan",
         //            MiddleName = "Justin",
         //            LastName = "Bass",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 3, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 908,
         //            //StudentPersonId = 908,
         //            StateStudentIdentifier = "0783403908",
         //            FirstName = "Maryam",
         //            MiddleName = "Gwendolyn",
         //            LastName = "Ballard",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2005, 9, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 909,
         //            //StudentPersonId = 909,
         //            StateStudentIdentifier = "0306230909",
         //            FirstName = "Willa",
         //            MiddleName = "Dora",
         //            LastName = "Schneider",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 9, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 910,
         //            //StudentPersonId = 910,
         //            StateStudentIdentifier = "0931492910",
         //            FirstName = "Caleb",
         //            MiddleName = "Stone",
         //            LastName = "Molina",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 7, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 911,
         //            //StudentPersonId = 911,
         //            StateStudentIdentifier = "0038241911",
         //            FirstName = "Richard",
         //            MiddleName = "Garrett",
         //            LastName = "Winters",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2017, 9, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 912,
         //            //StudentPersonId = 912,
         //            StateStudentIdentifier = "0385382912",
         //            FirstName = "Quinlan",
         //            MiddleName = "Cedric",
         //            LastName = "Navarro",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1997, 11, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 913,
         //            //StudentPersonId = 913,
         //            StateStudentIdentifier = "0723669913",
         //            FirstName = "Macey",
         //            MiddleName = "Angelica",
         //            LastName = "Acevedo",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 6, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 914,
         //            //StudentPersonId = 914,
         //            StateStudentIdentifier = "0352467914",
         //            FirstName = "Owen",
         //            MiddleName = "Maisie",
         //            LastName = "Ware",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2002, 6, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 915,
         //            //StudentPersonId = 915,
         //            StateStudentIdentifier = "0595282915",
         //            FirstName = "Patience",
         //            MiddleName = "Nehru",
         //            LastName = "Barnett",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1997, 8, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 916,
         //            //StudentPersonId = 916,
         //            StateStudentIdentifier = "0245210916",
         //            FirstName = "Carter",
         //            MiddleName = "Sade",
         //            LastName = "Gaines",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 9, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 917,
         //            //StudentPersonId = 917,
         //            StateStudentIdentifier = "0643299917",
         //            FirstName = "Oprah",
         //            MiddleName = "Caldwell",
         //            LastName = "Luna",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 6, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 918,
         //            //StudentPersonId = 918,
         //            StateStudentIdentifier = "0957099918",
         //            FirstName = "Bethany",
         //            MiddleName = "Jenna",
         //            LastName = "Chandler",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1996, 6, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 919,
         //            //StudentPersonId = 919,
         //            StateStudentIdentifier = "0272111919",
         //            FirstName = "Abbot",
         //            MiddleName = "Randall",
         //            LastName = "Robertson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 8, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 920,
         //            //StudentPersonId = 920,
         //            StateStudentIdentifier = "0691911920",
         //            FirstName = "Julie",
         //            MiddleName = "Amanda",
         //            LastName = "Winters",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 10, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 921,
         //            //StudentPersonId = 921,
         //            StateStudentIdentifier = "0904831921",
         //            FirstName = "Mufutau",
         //            MiddleName = "Wyatt",
         //            LastName = "Chambers",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 9, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 922,
         //            //StudentPersonId = 922,
         //            StateStudentIdentifier = "0824542922",
         //            FirstName = "Lillian",
         //            MiddleName = "Doug",
         //            LastName = "Conrad",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 11, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 923,
         //            //StudentPersonId = 923,
         //            StateStudentIdentifier = "0667979923",
         //            FirstName = "Gay",
         //            MiddleName = "Stacy",
         //            LastName = "Rutledge",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 1, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 924,
         //            //StudentPersonId = 924,
         //            StateStudentIdentifier = "0354435924",
         //            FirstName = "Giselle",
         //            MiddleName = "Carol",
         //            LastName = "Joseph",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2006, 12, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 925,
         //            //StudentPersonId = 925,
         //            StateStudentIdentifier = "0143694925",
         //            FirstName = "Mara",
         //            MiddleName = "Freya",
         //            LastName = "Macias",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2016, 11, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 926,
         //            //StudentPersonId = 926,
         //            StateStudentIdentifier = "0031056926",
         //            FirstName = "Lucius",
         //            MiddleName = "Palmer",
         //            LastName = "Fowler",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2010, 3, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 927,
         //            //StudentPersonId = 927,
         //            StateStudentIdentifier = "0666202927",
         //            FirstName = "Inga",
         //            MiddleName = "Summer",
         //            LastName = "Mills",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 12, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 928,
         //            //StudentPersonId = 928,
         //            StateStudentIdentifier = "0101818928",
         //            FirstName = "Julie",
         //            MiddleName = "Austin",
         //            LastName = "Pratt",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 2, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 929,
         //            //StudentPersonId = 929,
         //            StateStudentIdentifier = "0943796929",
         //            FirstName = "Emi",
         //            MiddleName = "Sybil",
         //            LastName = "Leonard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 7, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 930,
         //            //StudentPersonId = 930,
         //            StateStudentIdentifier = "0247033930",
         //            FirstName = "Avram",
         //            MiddleName = "Xanthus",
         //            LastName = "Goodman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 7, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 931,
         //            //StudentPersonId = 931,
         //            StateStudentIdentifier = "0508577931",
         //            FirstName = "Maxwell",
         //            MiddleName = "Melvin",
         //            LastName = "Jefferson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 5, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 932,
         //            //StudentPersonId = 932,
         //            StateStudentIdentifier = "0866318932",
         //            FirstName = "Ramona",
         //            MiddleName = "Quyn",
         //            LastName = "Bird",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2017, 2, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 933,
         //            //StudentPersonId = 933,
         //            StateStudentIdentifier = "0863660933",
         //            FirstName = "Elvis",
         //            MiddleName = "Orlando",
         //            LastName = "Church",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2004, 6, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 934,
         //            //StudentPersonId = 934,
         //            StateStudentIdentifier = "0287894934",
         //            FirstName = "Dillon",
         //            MiddleName = "Joel",
         //            LastName = "Hooper",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 4, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 935,
         //            //StudentPersonId = 935,
         //            StateStudentIdentifier = "0610713935",
         //            FirstName = "Hilel",
         //            MiddleName = "August",
         //            LastName = "Obrien",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 9, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 936,
         //            //StudentPersonId = 936,
         //            StateStudentIdentifier = "0180263936",
         //            FirstName = "Flynn",
         //            MiddleName = "Sebastian",
         //            LastName = "Fernandez",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 9, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 937,
         //            //StudentPersonId = 937,
         //            StateStudentIdentifier = "0381768937",
         //            FirstName = "Erasmus",
         //            MiddleName = "Abbot",
         //            LastName = "Gonzales",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 6, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 938,
         //            //StudentPersonId = 938,
         //            StateStudentIdentifier = "0716005938",
         //            FirstName = "Price",
         //            MiddleName = "Dillon",
         //            LastName = "Dudley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 8, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 939,
         //            //StudentPersonId = 939,
         //            StateStudentIdentifier = "0344460939",
         //            FirstName = "Lillith",
         //            MiddleName = "Aphrodite",
         //            LastName = "Holcomb",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1997, 1, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 940,
         //            //StudentPersonId = 940,
         //            StateStudentIdentifier = "0180411940",
         //            FirstName = "Darius",
         //            MiddleName = "Merritt",
         //            LastName = "Huber",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2019, 11, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 941,
         //            //StudentPersonId = 941,
         //            StateStudentIdentifier = "0193071941",
         //            FirstName = "Fiona",
         //            MiddleName = "Beverly",
         //            LastName = "Blanchard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 8, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 942,
         //            //StudentPersonId = 942,
         //            StateStudentIdentifier = "0925165942",
         //            FirstName = "Kato",
         //            MiddleName = "Thaddeus",
         //            LastName = "Ewing",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2000, 10, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 943,
         //            //StudentPersonId = 943,
         //            StateStudentIdentifier = "0291101943",
         //            FirstName = "Aaron",
         //            MiddleName = "Wade",
         //            LastName = "Branch",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 9, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 944,
         //            //StudentPersonId = 944,
         //            StateStudentIdentifier = "0561774944",
         //            FirstName = "Ariana",
         //            MiddleName = "MacKensie",
         //            LastName = "Hurst",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2014, 2, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 945,
         //            //StudentPersonId = 945,
         //            StateStudentIdentifier = "0451829945",
         //            FirstName = "Diana",
         //            MiddleName = "Sopoline",
         //            LastName = "Griffin",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1997, 11, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 946,
         //            //StudentPersonId = 946,
         //            StateStudentIdentifier = "0346112946",
         //            FirstName = "Damon",
         //            MiddleName = "Oprah",
         //            LastName = "Haney",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 4, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 947,
         //            //StudentPersonId = 947,
         //            StateStudentIdentifier = "0082310947",
         //            FirstName = "Courtney",
         //            MiddleName = "Kimberley",
         //            LastName = "Barry",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 9, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 948,
         //            //StudentPersonId = 948,
         //            StateStudentIdentifier = "0122930948",
         //            FirstName = "Devin",
         //            MiddleName = "Hall",
         //            LastName = "Mullen",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 2, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 949,
         //            //StudentPersonId = 949,
         //            StateStudentIdentifier = "0269887949",
         //            FirstName = "Russell",
         //            MiddleName = "Oleg",
         //            LastName = "James",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 5, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 950,
         //            //StudentPersonId = 950,
         //            StateStudentIdentifier = "0077002950",
         //            FirstName = "Barry",
         //            MiddleName = "Gareth",
         //            LastName = "Nash",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 2, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 951,
         //            //StudentPersonId = 951,
         //            StateStudentIdentifier = "0778153951",
         //            FirstName = "Xaviera",
         //            MiddleName = "Ariel",
         //            LastName = "Dudley",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2013, 4, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 952,
         //            //StudentPersonId = 952,
         //            StateStudentIdentifier = "0458616952",
         //            FirstName = "Ferris",
         //            MiddleName = "Alexander",
         //            LastName = "Schroeder",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 12, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 953,
         //            //StudentPersonId = 953,
         //            StateStudentIdentifier = "0891001953",
         //            FirstName = "Quail",
         //            MiddleName = "Mannix",
         //            LastName = "Joseph",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2008, 5, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 954,
         //            //StudentPersonId = 954,
         //            StateStudentIdentifier = "0164303954",
         //            FirstName = "Quamar",
         //            MiddleName = "Aquila",
         //            LastName = "Jarvis",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2009, 5, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 955,
         //            //StudentPersonId = 955,
         //            StateStudentIdentifier = "0240694955",
         //            FirstName = "Abel",
         //            MiddleName = "Geoffrey",
         //            LastName = "Stephens",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 5, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 956,
         //            //StudentPersonId = 956,
         //            StateStudentIdentifier = "0899103956",
         //            FirstName = "Frances",
         //            MiddleName = "Autumn",
         //            LastName = "Blake",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1999, 11, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 957,
         //            //StudentPersonId = 957,
         //            StateStudentIdentifier = "0305026957",
         //            FirstName = "Declan",
         //            MiddleName = "Isaac",
         //            LastName = "Booth",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 5, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 958,
         //            //StudentPersonId = 958,
         //            StateStudentIdentifier = "0622506958",
         //            FirstName = "Amethyst",
         //            MiddleName = "Penelope",
         //            LastName = "James",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 8, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 959,
         //            //StudentPersonId = 959,
         //            StateStudentIdentifier = "0864961959",
         //            FirstName = "Dalton",
         //            MiddleName = "Rudyard",
         //            LastName = "Parsons",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 2, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 960,
         //            //StudentPersonId = 960,
         //            StateStudentIdentifier = "0662342960",
         //            FirstName = "Keith",
         //            MiddleName = "Fitzgerald",
         //            LastName = "Lancaster",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2019, 7, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 961,
         //            //StudentPersonId = 961,
         //            StateStudentIdentifier = "0263808961",
         //            FirstName = "Lois",
         //            MiddleName = "Vivian",
         //            LastName = "Mack",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 6, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 962,
         //            //StudentPersonId = 962,
         //            StateStudentIdentifier = "0642418962",
         //            FirstName = "Jordan",
         //            MiddleName = "Dai",
         //            LastName = "Holloway",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 11, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 963,
         //            //StudentPersonId = 963,
         //            StateStudentIdentifier = "0754750963",
         //            FirstName = "Cole",
         //            MiddleName = "Sawyer",
         //            LastName = "Padilla",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 4, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 964,
         //            //StudentPersonId = 964,
         //            StateStudentIdentifier = "0741370964",
         //            FirstName = "Sarah",
         //            MiddleName = "Joy",
         //            LastName = "Franco",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 9, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 965,
         //            //StudentPersonId = 965,
         //            StateStudentIdentifier = "0540591965",
         //            FirstName = "Evelyn",
         //            MiddleName = "Russell",
         //            LastName = "Burke",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2005, 11, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 966,
         //            //StudentPersonId = 966,
         //            StateStudentIdentifier = "0286324966",
         //            FirstName = "Reagan",
         //            MiddleName = "Macy",
         //            LastName = "Deleon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 1, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 967,
         //            //StudentPersonId = 967,
         //            StateStudentIdentifier = "0922124967",
         //            FirstName = "Ian",
         //            MiddleName = "Omar",
         //            LastName = "Pratt",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 2, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 968,
         //            //StudentPersonId = 968,
         //            StateStudentIdentifier = "0065059968",
         //            FirstName = "Jane",
         //            MiddleName = "Eric",
         //            LastName = "Paul",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 6, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 969,
         //            //StudentPersonId = 969,
         //            StateStudentIdentifier = "0293929969",
         //            FirstName = "Lila",
         //            MiddleName = "Grace",
         //            LastName = "Carroll",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 10, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 970,
         //            //StudentPersonId = 970,
         //            StateStudentIdentifier = "0461430970",
         //            FirstName = "Simon",
         //            MiddleName = "Demetrius",
         //            LastName = "Mercer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 9, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 971,
         //            //StudentPersonId = 971,
         //            StateStudentIdentifier = "0670904971",
         //            FirstName = "Demetria",
         //            MiddleName = "Igor",
         //            LastName = "Lott",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2019, 2, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 972,
         //            //StudentPersonId = 972,
         //            StateStudentIdentifier = "0713084972",
         //            FirstName = "Bruce",
         //            MiddleName = "Caldwell",
         //            LastName = "Hobbs",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 5, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 973,
         //            //StudentPersonId = 973,
         //            StateStudentIdentifier = "0909976973",
         //            FirstName = "Erasmus",
         //            MiddleName = "Ferdinand",
         //            LastName = "Nash",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2012, 6, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 974,
         //            //StudentPersonId = 974,
         //            StateStudentIdentifier = "0244687974",
         //            FirstName = "Camille",
         //            MiddleName = "Jaquelyn",
         //            LastName = "Blanchard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 7, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 975,
         //            //StudentPersonId = 975,
         //            StateStudentIdentifier = "0083057975",
         //            FirstName = "Jamalia",
         //            MiddleName = "Adena",
         //            LastName = "Mckay",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 4, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 976,
         //            //StudentPersonId = 976,
         //            StateStudentIdentifier = "0920868976",
         //            FirstName = "Ursula",
         //            MiddleName = "Jessica",
         //            LastName = "Morrison",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 1, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 977,
         //            //StudentPersonId = 977,
         //            StateStudentIdentifier = "0588213977",
         //            FirstName = "Gisela",
         //            MiddleName = "Melyssa",
         //            LastName = "Dodson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 5, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 978,
         //            //StudentPersonId = 978,
         //            StateStudentIdentifier = "0040357978",
         //            FirstName = "Ulysses",
         //            MiddleName = "Odysseus",
         //            LastName = "Case",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 4, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 979,
         //            //StudentPersonId = 979,
         //            StateStudentIdentifier = "0167266979",
         //            FirstName = "Amir",
         //            MiddleName = "Colette",
         //            LastName = "Salazar",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 4, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 980,
         //            //StudentPersonId = 980,
         //            StateStudentIdentifier = "0973867980",
         //            FirstName = "Herrod",
         //            MiddleName = "Cooper",
         //            LastName = "Molina",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 12, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 981,
         //            //StudentPersonId = 981,
         //            StateStudentIdentifier = "0446561981",
         //            FirstName = "Hunter",
         //            MiddleName = "Bruno",
         //            LastName = "Singleton",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(1995, 4, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 982,
         //            //StudentPersonId = 982,
         //            StateStudentIdentifier = "0375347982",
         //            FirstName = "Ina",
         //            MiddleName = "Samantha",
         //            LastName = "Byrd",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2010, 3, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 983,
         //            //StudentPersonId = 983,
         //            StateStudentIdentifier = "0659559983",
         //            FirstName = "Vernon",
         //            MiddleName = "Nissim",
         //            LastName = "Whitaker",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2004, 7, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 984,
         //            //StudentPersonId = 984,
         //            StateStudentIdentifier = "0569331984",
         //            FirstName = "Hector",
         //            MiddleName = "Nigel",
         //            LastName = "Stevenson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 2, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 985,
         //            //StudentPersonId = 985,
         //            StateStudentIdentifier = "0629027985",
         //            FirstName = "Hiroko",
         //            MiddleName = "Yael",
         //            LastName = "Mueller",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1997, 9, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 986,
         //            //StudentPersonId = 986,
         //            StateStudentIdentifier = "0767036986",
         //            FirstName = "Elizabeth",
         //            MiddleName = "Harriet",
         //            LastName = "Reed",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2014, 6, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 987,
         //            //StudentPersonId = 987,
         //            StateStudentIdentifier = "0691868987",
         //            FirstName = "Igor",
         //            MiddleName = "Berk",
         //            LastName = "Gutierrez",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 12, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 988,
         //            //StudentPersonId = 988,
         //            StateStudentIdentifier = "0198859988",
         //            FirstName = "Philip",
         //            MiddleName = "Buckminster",
         //            LastName = "Cotton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 3, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 989,
         //            //StudentPersonId = 989,
         //            StateStudentIdentifier = "0559885989",
         //            FirstName = "Erica",
         //            MiddleName = "Guinevere",
         //            LastName = "Melendez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 5, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 990,
         //            //StudentPersonId = 990,
         //            StateStudentIdentifier = "0111125990",
         //            FirstName = "Victoria",
         //            MiddleName = "Clark",
         //            LastName = "Mcgee",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 8, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 991,
         //            //StudentPersonId = 991,
         //            StateStudentIdentifier = "0366380991",
         //            FirstName = "Kyle",
         //            MiddleName = "Macaulay",
         //            LastName = "Hopkins",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1996, 4, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 992,
         //            //StudentPersonId = 992,
         //            StateStudentIdentifier = "0134364992",
         //            FirstName = "Renee",
         //            MiddleName = "Alea",
         //            LastName = "Bruce",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 1, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 993,
         //            //StudentPersonId = 993,
         //            StateStudentIdentifier = "0727717993",
         //            FirstName = "Octavia",
         //            MiddleName = "MacKensie",
         //            LastName = "Mcgowan",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 12, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 994,
         //            //StudentPersonId = 994,
         //            StateStudentIdentifier = "0602847994",
         //            FirstName = "Freya",
         //            MiddleName = "Francis",
         //            LastName = "Gallagher",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 12, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 995,
         //            //StudentPersonId = 995,
         //            StateStudentIdentifier = "0153688995",
         //            FirstName = "Lee",
         //            MiddleName = "Joel",
         //            LastName = "Leonard",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 9, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 996,
         //            //StudentPersonId = 996,
         //            StateStudentIdentifier = "0700528996",
         //            FirstName = "Janna",
         //            MiddleName = "Prescott",
         //            LastName = "Wright",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 6, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 997,
         //            //StudentPersonId = 997,
         //            StateStudentIdentifier = "0414228997",
         //            FirstName = "Keiko",
         //            MiddleName = "Amelia",
         //            LastName = "Lee",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 5, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 998,
         //            //StudentPersonId = 998,
         //            StateStudentIdentifier = "0503961998",
         //            FirstName = "Nina",
         //            MiddleName = "Aubrey",
         //            LastName = "Dudley",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2019, 4, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 999,
         //            //StudentPersonId = 999,
         //            StateStudentIdentifier = "0260246999",
         //            FirstName = "Dane",
         //            MiddleName = "Leroy",
         //            LastName = "Graves",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 4, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1000,
         //            //StudentPersonId = 1000,
         //            StateStudentIdentifier = "5512431000",
         //            FirstName = "Cody",
         //            MiddleName = "Barry",
         //            LastName = "Stevens",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2005, 3, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1001,
         //            //StudentPersonId = 1001,
         //            StateStudentIdentifier = "3993071001",
         //            FirstName = "Summer",
         //            MiddleName = "Debra",
         //            LastName = "Meyers",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2008, 8, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1002,
         //            //StudentPersonId = 1002,
         //            StateStudentIdentifier = "1933521002",
         //            FirstName = "Keelie",
         //            MiddleName = "Farrah",
         //            LastName = "Stanley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 8, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1003,
         //            //StudentPersonId = 1003,
         //            StateStudentIdentifier = "6415211003",
         //            FirstName = "Carissa",
         //            MiddleName = "Paki",
         //            LastName = "Warren",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 11, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1004,
         //            //StudentPersonId = 1004,
         //            StateStudentIdentifier = "5448361004",
         //            FirstName = "Deacon",
         //            MiddleName = "Edan",
         //            LastName = "Shepherd",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 8, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1005,
         //            //StudentPersonId = 1005,
         //            StateStudentIdentifier = "5512641005",
         //            FirstName = "Dakota",
         //            MiddleName = "Evangeline",
         //            LastName = "Kline",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2019, 1, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1006,
         //            //StudentPersonId = 1006,
         //            StateStudentIdentifier = "6215351006",
         //            FirstName = "Odysseus",
         //            MiddleName = "Sharmila",
         //            LastName = "Oliver",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 7, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1007,
         //            //StudentPersonId = 1007,
         //            StateStudentIdentifier = "9834571007",
         //            FirstName = "Ross",
         //            MiddleName = "Kieran",
         //            LastName = "Arnold",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 6, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1008,
         //            //StudentPersonId = 1008,
         //            StateStudentIdentifier = "6676771008",
         //            FirstName = "Nada",
         //            MiddleName = "Tatiana",
         //            LastName = "Moreno",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 10, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1009,
         //            //StudentPersonId = 1009,
         //            StateStudentIdentifier = "5650521009",
         //            FirstName = "Kaitlin",
         //            MiddleName = "Susan",
         //            LastName = "Rice",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2005, 1, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1010,
         //            //StudentPersonId = 1010,
         //            StateStudentIdentifier = "8971101010",
         //            FirstName = "Odette",
         //            MiddleName = "Catherine",
         //            LastName = "Jordan",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2006, 7, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1011,
         //            //StudentPersonId = 1011,
         //            StateStudentIdentifier = "9620251011",
         //            FirstName = "Alan",
         //            MiddleName = "Reed",
         //            LastName = "Horn",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1995, 4, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1012,
         //            //StudentPersonId = 1012,
         //            StateStudentIdentifier = "1933021012",
         //            FirstName = "Aiko",
         //            MiddleName = "Hanna",
         //            LastName = "Watson",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 6, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1013,
         //            //StudentPersonId = 1013,
         //            StateStudentIdentifier = "4440941013",
         //            FirstName = "Reuben",
         //            MiddleName = "Graiden",
         //            LastName = "Johns",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 4, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1014,
         //            //StudentPersonId = 1014,
         //            StateStudentIdentifier = "2358191014",
         //            FirstName = "Joseph",
         //            MiddleName = "Dylan",
         //            LastName = "Huber",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 8, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1015,
         //            //StudentPersonId = 1015,
         //            StateStudentIdentifier = "0136591015",
         //            FirstName = "Hector",
         //            MiddleName = "Raymond",
         //            LastName = "Mccormick",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 12, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1016,
         //            //StudentPersonId = 1016,
         //            StateStudentIdentifier = "4951561016",
         //            FirstName = "Kessie",
         //            MiddleName = "Dorothy",
         //            LastName = "Burris",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2002, 5, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1017,
         //            //StudentPersonId = 1017,
         //            StateStudentIdentifier = "2986471017",
         //            FirstName = "Whoopi",
         //            MiddleName = "Quail",
         //            LastName = "Blankenship",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 4, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1018,
         //            //StudentPersonId = 1018,
         //            StateStudentIdentifier = "5013961018",
         //            FirstName = "Reed",
         //            MiddleName = "Destiny",
         //            LastName = "Colon",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2017, 2, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1019,
         //            //StudentPersonId = 1019,
         //            StateStudentIdentifier = "1591861019",
         //            FirstName = "Ciaran",
         //            MiddleName = "Blaze",
         //            LastName = "Briggs",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 9, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1020,
         //            //StudentPersonId = 1020,
         //            StateStudentIdentifier = "0528831020",
         //            FirstName = "Victoria",
         //            MiddleName = "Sharon",
         //            LastName = "Gilmore",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 1, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1021,
         //            //StudentPersonId = 1021,
         //            StateStudentIdentifier = "4567941021",
         //            FirstName = "Uriel",
         //            MiddleName = "Leo",
         //            LastName = "Kerr",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 5, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1022,
         //            //StudentPersonId = 1022,
         //            StateStudentIdentifier = "0621511022",
         //            FirstName = "Joelle",
         //            MiddleName = "Madeson",
         //            LastName = "Wooten",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 4, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1023,
         //            //StudentPersonId = 1023,
         //            StateStudentIdentifier = "9669271023",
         //            FirstName = "Micah",
         //            MiddleName = "Serena",
         //            LastName = "Key",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1998, 8, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1024,
         //            //StudentPersonId = 1024,
         //            StateStudentIdentifier = "0337061024",
         //            FirstName = "Keefe",
         //            MiddleName = "Oscar",
         //            LastName = "Townsend",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 7, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1025,
         //            //StudentPersonId = 1025,
         //            StateStudentIdentifier = "3467571025",
         //            FirstName = "Beau",
         //            MiddleName = "Todd",
         //            LastName = "Underwood",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2011, 3, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1026,
         //            //StudentPersonId = 1026,
         //            StateStudentIdentifier = "3557111026",
         //            FirstName = "Claudia",
         //            MiddleName = "Lillian",
         //            LastName = "Thomas",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 1, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1027,
         //            //StudentPersonId = 1027,
         //            StateStudentIdentifier = "9669331027",
         //            FirstName = "Bruno",
         //            MiddleName = "Hamish",
         //            LastName = "Hernandez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 8, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1028,
         //            //StudentPersonId = 1028,
         //            StateStudentIdentifier = "2606041028",
         //            FirstName = "Jack",
         //            MiddleName = "Erasmus",
         //            LastName = "Hernandez",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 3, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1029,
         //            //StudentPersonId = 1029,
         //            StateStudentIdentifier = "4663101029",
         //            FirstName = "Cecilia",
         //            MiddleName = "Martha",
         //            LastName = "Aguirre",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 4, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1030,
         //            //StudentPersonId = 1030,
         //            StateStudentIdentifier = "2113881030",
         //            FirstName = "Sylvester",
         //            MiddleName = "Rhiannon",
         //            LastName = "Barry",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2008, 9, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1031,
         //            //StudentPersonId = 1031,
         //            StateStudentIdentifier = "9397501031",
         //            FirstName = "Wylie",
         //            MiddleName = "Noble",
         //            LastName = "Ferguson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 9, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1032,
         //            //StudentPersonId = 1032,
         //            StateStudentIdentifier = "5683311032",
         //            FirstName = "Ross",
         //            MiddleName = "Christen",
         //            LastName = "Wright",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 1, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1033,
         //            //StudentPersonId = 1033,
         //            StateStudentIdentifier = "2287561033",
         //            FirstName = "Yael",
         //            MiddleName = "Mikayla",
         //            LastName = "Allison",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 6, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1034,
         //            //StudentPersonId = 1034,
         //            StateStudentIdentifier = "3590361034",
         //            FirstName = "Kevin",
         //            MiddleName = "Drake",
         //            LastName = "Bruce",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 8, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1035,
         //            //StudentPersonId = 1035,
         //            StateStudentIdentifier = "6098411035",
         //            FirstName = "Dana",
         //            MiddleName = "Judith",
         //            LastName = "Pugh",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1997, 4, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1036,
         //            //StudentPersonId = 1036,
         //            StateStudentIdentifier = "4114611036",
         //            FirstName = "Catherine",
         //            MiddleName = "Walter",
         //            LastName = "Moon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 4, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1037,
         //            //StudentPersonId = 1037,
         //            StateStudentIdentifier = "9989741037",
         //            FirstName = "Solomon",
         //            MiddleName = "Callum",
         //            LastName = "Mcmahon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 6, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1038,
         //            //StudentPersonId = 1038,
         //            StateStudentIdentifier = "1928181038",
         //            FirstName = "August",
         //            MiddleName = "Dorian",
         //            LastName = "Clark",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 3, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1039,
         //            //StudentPersonId = 1039,
         //            StateStudentIdentifier = "6828241039",
         //            FirstName = "Ina",
         //            MiddleName = "Hedwig",
         //            LastName = "Roach",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 11, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1040,
         //            //StudentPersonId = 1040,
         //            StateStudentIdentifier = "6160111040",
         //            FirstName = "Neville",
         //            MiddleName = "Ray",
         //            LastName = "Davidson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 6, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1041,
         //            //StudentPersonId = 1041,
         //            StateStudentIdentifier = "8504021041",
         //            FirstName = "Cherokee",
         //            MiddleName = "Kai",
         //            LastName = "Erickson",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 10, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1042,
         //            //StudentPersonId = 1042,
         //            StateStudentIdentifier = "0127801042",
         //            FirstName = "Tashya",
         //            MiddleName = "Echo",
         //            LastName = "Sweet",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2006, 2, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1043,
         //            //StudentPersonId = 1043,
         //            StateStudentIdentifier = "5566391043",
         //            FirstName = "Isaiah",
         //            MiddleName = "Murphy",
         //            LastName = "Stuart",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 1, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1044,
         //            //StudentPersonId = 1044,
         //            StateStudentIdentifier = "6331341044",
         //            FirstName = "Taylor",
         //            MiddleName = "Illiana",
         //            LastName = "Ware",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2009, 2, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1045,
         //            //StudentPersonId = 1045,
         //            StateStudentIdentifier = "7821141045",
         //            FirstName = "Ferris",
         //            MiddleName = "Orli",
         //            LastName = "Roach",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 12, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1046,
         //            //StudentPersonId = 1046,
         //            StateStudentIdentifier = "7851331046",
         //            FirstName = "Justin",
         //            MiddleName = "Jesse",
         //            LastName = "Tanner",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2018, 10, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1047,
         //            //StudentPersonId = 1047,
         //            StateStudentIdentifier = "0029471047",
         //            FirstName = "Alyssa",
         //            MiddleName = "Gay",
         //            LastName = "Craft",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 8, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1048,
         //            //StudentPersonId = 1048,
         //            StateStudentIdentifier = "4892051048",
         //            FirstName = "Arsenio",
         //            MiddleName = "Eagan",
         //            LastName = "Burgess",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 6, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1049,
         //            //StudentPersonId = 1049,
         //            StateStudentIdentifier = "6984241049",
         //            FirstName = "Kay",
         //            MiddleName = "Nayda",
         //            LastName = "Gordon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 8, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1050,
         //            //StudentPersonId = 1050,
         //            StateStudentIdentifier = "8816701050",
         //            FirstName = "Demetrius",
         //            MiddleName = "Hollee",
         //            LastName = "Powell",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 7, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1051,
         //            //StudentPersonId = 1051,
         //            StateStudentIdentifier = "7095701051",
         //            FirstName = "Burton",
         //            MiddleName = "Irene",
         //            LastName = "Dalton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 12, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1052,
         //            //StudentPersonId = 1052,
         //            StateStudentIdentifier = "5231171052",
         //            FirstName = "Dean",
         //            MiddleName = "Sawyer",
         //            LastName = "Johnson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 6, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1053,
         //            //StudentPersonId = 1053,
         //            StateStudentIdentifier = "4365701053",
         //            FirstName = "Lucas",
         //            MiddleName = "Murphy",
         //            LastName = "Ashley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 9, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1054,
         //            //StudentPersonId = 1054,
         //            StateStudentIdentifier = "5072781054",
         //            FirstName = "Venus",
         //            MiddleName = "Kylynn",
         //            LastName = "Rutledge",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2000, 6, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1055,
         //            //StudentPersonId = 1055,
         //            StateStudentIdentifier = "4112631055",
         //            FirstName = "Xena",
         //            MiddleName = "Wynne",
         //            LastName = "Silva",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2012, 2, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1056,
         //            //StudentPersonId = 1056,
         //            StateStudentIdentifier = "2258721056",
         //            FirstName = "Kane",
         //            MiddleName = "Hadley",
         //            LastName = "Lawson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 12, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1057,
         //            //StudentPersonId = 1057,
         //            StateStudentIdentifier = "3085861057",
         //            FirstName = "Daphne",
         //            MiddleName = "Rachel",
         //            LastName = "Dale",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 7, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1058,
         //            //StudentPersonId = 1058,
         //            StateStudentIdentifier = "3796871058",
         //            FirstName = "Baker",
         //            MiddleName = "Laith",
         //            LastName = "Camacho",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2019, 6, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1059,
         //            //StudentPersonId = 1059,
         //            StateStudentIdentifier = "8331891059",
         //            FirstName = "Walter",
         //            MiddleName = "Malik",
         //            LastName = "Potts",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2010, 3, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1060,
         //            //StudentPersonId = 1060,
         //            StateStudentIdentifier = "8448121060",
         //            FirstName = "Harrison",
         //            MiddleName = "Iona",
         //            LastName = "Reed",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 5, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1061,
         //            //StudentPersonId = 1061,
         //            StateStudentIdentifier = "9164501061",
         //            FirstName = "Luke",
         //            MiddleName = "Hu",
         //            LastName = "Frazier",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1999, 6, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1062,
         //            //StudentPersonId = 1062,
         //            StateStudentIdentifier = "8021431062",
         //            FirstName = "Troy",
         //            MiddleName = "Carl",
         //            LastName = "Koch",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 11, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1063,
         //            //StudentPersonId = 1063,
         //            StateStudentIdentifier = "8461091063",
         //            FirstName = "Cole",
         //            MiddleName = "Kevin",
         //            LastName = "Warren",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 8, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1064,
         //            //StudentPersonId = 1064,
         //            StateStudentIdentifier = "1685051064",
         //            FirstName = "Lester",
         //            MiddleName = "Hakeem",
         //            LastName = "Lopez",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2011, 4, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1065,
         //            //StudentPersonId = 1065,
         //            StateStudentIdentifier = "5359031065",
         //            FirstName = "Jerome",
         //            MiddleName = "Henry",
         //            LastName = "Barlow",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1996, 5, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1066,
         //            //StudentPersonId = 1066,
         //            StateStudentIdentifier = "0885641066",
         //            FirstName = "Vladimir",
         //            MiddleName = "Dorian",
         //            LastName = "Bennett",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 11, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1067,
         //            //StudentPersonId = 1067,
         //            StateStudentIdentifier = "2664841067",
         //            FirstName = "Martena",
         //            MiddleName = "Kareem",
         //            LastName = "Howard",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2006, 10, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1068,
         //            //StudentPersonId = 1068,
         //            StateStudentIdentifier = "8215191068",
         //            FirstName = "Jelani",
         //            MiddleName = "Richard",
         //            LastName = "Snider",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2003, 10, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1069,
         //            //StudentPersonId = 1069,
         //            StateStudentIdentifier = "2776461069",
         //            FirstName = "Dorian",
         //            MiddleName = "James",
         //            LastName = "Delaney",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2005, 5, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1070,
         //            //StudentPersonId = 1070,
         //            StateStudentIdentifier = "8242381070",
         //            FirstName = "Ginger",
         //            MiddleName = "Yael",
         //            LastName = "Clay",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 6, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1071,
         //            //StudentPersonId = 1071,
         //            StateStudentIdentifier = "0761991071",
         //            FirstName = "Naomi",
         //            MiddleName = "Leila",
         //            LastName = "Joyner",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2007, 9, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1072,
         //            //StudentPersonId = 1072,
         //            StateStudentIdentifier = "8524561072",
         //            FirstName = "Emery",
         //            MiddleName = "Macon",
         //            LastName = "Ford",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 2, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1073,
         //            //StudentPersonId = 1073,
         //            StateStudentIdentifier = "3627501073",
         //            FirstName = "Cheryl",
         //            MiddleName = "Victoria",
         //            LastName = "Lindsey",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2008, 11, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1074,
         //            //StudentPersonId = 1074,
         //            StateStudentIdentifier = "9982471074",
         //            FirstName = "Alyssa",
         //            MiddleName = "Samantha",
         //            LastName = "Randall",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 3, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1075,
         //            //StudentPersonId = 1075,
         //            StateStudentIdentifier = "4528181075",
         //            FirstName = "Cecilia",
         //            MiddleName = "Kirby",
         //            LastName = "Norris",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1998, 10, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1076,
         //            //StudentPersonId = 1076,
         //            StateStudentIdentifier = "9980711076",
         //            FirstName = "Elvis",
         //            MiddleName = "Jakeem",
         //            LastName = "Ramirez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 6, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1077,
         //            //StudentPersonId = 1077,
         //            StateStudentIdentifier = "3253391077",
         //            FirstName = "Brandon",
         //            MiddleName = "Aristotle",
         //            LastName = "Lane",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 11, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1078,
         //            //StudentPersonId = 1078,
         //            StateStudentIdentifier = "7872271078",
         //            FirstName = "Drew",
         //            MiddleName = "Keane",
         //            LastName = "Nielsen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 5, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1079,
         //            //StudentPersonId = 1079,
         //            StateStudentIdentifier = "1907471079",
         //            FirstName = "Ava",
         //            MiddleName = "Lila",
         //            LastName = "Levy",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 8, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1080,
         //            //StudentPersonId = 1080,
         //            StateStudentIdentifier = "1225951080",
         //            FirstName = "Oscar",
         //            MiddleName = "Jerry",
         //            LastName = "Brady",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 6, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1081,
         //            //StudentPersonId = 1081,
         //            StateStudentIdentifier = "2180491081",
         //            FirstName = "Latifah",
         //            MiddleName = "Germane",
         //            LastName = "Wright",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 8, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1082,
         //            //StudentPersonId = 1082,
         //            StateStudentIdentifier = "5631111082",
         //            FirstName = "Anthony",
         //            MiddleName = "Phillip",
         //            LastName = "Medina",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 12, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1083,
         //            //StudentPersonId = 1083,
         //            StateStudentIdentifier = "0525601083",
         //            FirstName = "Macaulay",
         //            MiddleName = "Alvin",
         //            LastName = "Stevenson",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2003, 6, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1084,
         //            //StudentPersonId = 1084,
         //            StateStudentIdentifier = "0835581084",
         //            FirstName = "Driscoll",
         //            MiddleName = "Jerome",
         //            LastName = "Davidson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 6, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1085,
         //            //StudentPersonId = 1085,
         //            StateStudentIdentifier = "0610081085",
         //            FirstName = "Mechelle",
         //            MiddleName = "Shelley",
         //            LastName = "Price",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 3, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1086,
         //            //StudentPersonId = 1086,
         //            StateStudentIdentifier = "2485111086",
         //            FirstName = "Shay",
         //            MiddleName = "Glenna",
         //            LastName = "Mccarthy",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2013, 8, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1087,
         //            //StudentPersonId = 1087,
         //            StateStudentIdentifier = "5240561087",
         //            FirstName = "Price",
         //            MiddleName = "Alec",
         //            LastName = "Berger",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 8, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1088,
         //            //StudentPersonId = 1088,
         //            StateStudentIdentifier = "9046691088",
         //            FirstName = "Emerson",
         //            MiddleName = "Garrison",
         //            LastName = "Mendez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 3, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1089,
         //            //StudentPersonId = 1089,
         //            StateStudentIdentifier = "3256321089",
         //            FirstName = "Ashton",
         //            MiddleName = "Ezra",
         //            LastName = "Nolan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 7, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1090,
         //            //StudentPersonId = 1090,
         //            StateStudentIdentifier = "2838281090",
         //            FirstName = "Melissa",
         //            MiddleName = "Priscilla",
         //            LastName = "Merritt",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 12, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1091,
         //            //StudentPersonId = 1091,
         //            StateStudentIdentifier = "1216981091",
         //            FirstName = "Shelby",
         //            MiddleName = "Ann",
         //            LastName = "Lang",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 9, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1092,
         //            //StudentPersonId = 1092,
         //            StateStudentIdentifier = "2137981092",
         //            FirstName = "Naomi",
         //            MiddleName = "Joan",
         //            LastName = "Holcomb",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 1, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1093,
         //            //StudentPersonId = 1093,
         //            StateStudentIdentifier = "4221461093",
         //            FirstName = "Colleen",
         //            MiddleName = "Madeline",
         //            LastName = "Ferguson",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2013, 6, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1094,
         //            //StudentPersonId = 1094,
         //            StateStudentIdentifier = "1299021094",
         //            FirstName = "Tarik",
         //            MiddleName = "Drake",
         //            LastName = "Fletcher",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 5, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1095,
         //            //StudentPersonId = 1095,
         //            StateStudentIdentifier = "2748381095",
         //            FirstName = "Jorden",
         //            MiddleName = "Hadley",
         //            LastName = "Miles",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 8, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1096,
         //            //StudentPersonId = 1096,
         //            StateStudentIdentifier = "6085821096",
         //            FirstName = "Scarlett",
         //            MiddleName = "Alana",
         //            LastName = "Meadows",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 3, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1097,
         //            //StudentPersonId = 1097,
         //            StateStudentIdentifier = "3092541097",
         //            FirstName = "Keith",
         //            MiddleName = "Amir",
         //            LastName = "Patrick",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 6, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1098,
         //            //StudentPersonId = 1098,
         //            StateStudentIdentifier = "3964451098",
         //            FirstName = "Aristotle",
         //            MiddleName = "Madonna",
         //            LastName = "Harris",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 4, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1099,
         //            //StudentPersonId = 1099,
         //            StateStudentIdentifier = "2957281099",
         //            FirstName = "Quynn",
         //            MiddleName = "Melyssa",
         //            LastName = "Tanner",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 3, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1100,
         //            //StudentPersonId = 1100,
         //            StateStudentIdentifier = "2232931100",
         //            FirstName = "Rosalyn",
         //            MiddleName = "Sarah",
         //            LastName = "Holcomb",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 7, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1101,
         //            //StudentPersonId = 1101,
         //            StateStudentIdentifier = "1692081101",
         //            FirstName = "Dexter",
         //            MiddleName = "Jonah",
         //            LastName = "Frank",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 6, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1102,
         //            //StudentPersonId = 1102,
         //            StateStudentIdentifier = "3643901102",
         //            FirstName = "Preston",
         //            MiddleName = "Isaiah",
         //            LastName = "Gutierrez",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2005, 10, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1103,
         //            //StudentPersonId = 1103,
         //            StateStudentIdentifier = "8091871103",
         //            FirstName = "Colin",
         //            MiddleName = "Ferdinand",
         //            LastName = "Montgomery",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 3, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1104,
         //            //StudentPersonId = 1104,
         //            StateStudentIdentifier = "9627691104",
         //            FirstName = "Bernard",
         //            MiddleName = "Price",
         //            LastName = "Woods",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2004, 2, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1105,
         //            //StudentPersonId = 1105,
         //            StateStudentIdentifier = "4476921105",
         //            FirstName = "Emery",
         //            MiddleName = "Murphy",
         //            LastName = "Bernard",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 6, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1106,
         //            //StudentPersonId = 1106,
         //            StateStudentIdentifier = "3948961106",
         //            FirstName = "Phyllis",
         //            MiddleName = "Karly",
         //            LastName = "Bolton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 2, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1107,
         //            //StudentPersonId = 1107,
         //            StateStudentIdentifier = "4401871107",
         //            FirstName = "Kieran",
         //            MiddleName = "Dale",
         //            LastName = "Trujillo",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 7, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1108,
         //            //StudentPersonId = 1108,
         //            StateStudentIdentifier = "4074911108",
         //            FirstName = "Leslie",
         //            MiddleName = "Deanna",
         //            LastName = "Beach",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 10, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1109,
         //            //StudentPersonId = 1109,
         //            StateStudentIdentifier = "1837211109",
         //            FirstName = "Reese",
         //            MiddleName = "Jin",
         //            LastName = "Mullen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 7, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1110,
         //            //StudentPersonId = 1110,
         //            StateStudentIdentifier = "5749161110",
         //            FirstName = "Candice",
         //            MiddleName = "Doug",
         //            LastName = "Ferrell",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2014, 8, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1111,
         //            //StudentPersonId = 1111,
         //            StateStudentIdentifier = "2840421111",
         //            FirstName = "Tamekah",
         //            MiddleName = "Mari",
         //            LastName = "Bruce",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1999, 12, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1112,
         //            //StudentPersonId = 1112,
         //            StateStudentIdentifier = "4872561112",
         //            FirstName = "Grant",
         //            MiddleName = "Yeo",
         //            LastName = "Rodriquez",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 6, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1113,
         //            //StudentPersonId = 1113,
         //            StateStudentIdentifier = "3585001113",
         //            FirstName = "Kuame",
         //            MiddleName = "Clayton",
         //            LastName = "Ware",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 12, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1114,
         //            //StudentPersonId = 1114,
         //            StateStudentIdentifier = "7639861114",
         //            FirstName = "Francesca",
         //            MiddleName = "Madaline",
         //            LastName = "Manning",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 3, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1115,
         //            //StudentPersonId = 1115,
         //            StateStudentIdentifier = "9138051115",
         //            FirstName = "Declan",
         //            MiddleName = "Chandler",
         //            LastName = "Conley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 10, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1116,
         //            //StudentPersonId = 1116,
         //            StateStudentIdentifier = "3699081116",
         //            FirstName = "Odysseus",
         //            MiddleName = "Murphy",
         //            LastName = "Kelly",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 6, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1117,
         //            //StudentPersonId = 1117,
         //            StateStudentIdentifier = "1034431117",
         //            FirstName = "Armando",
         //            MiddleName = "Walter",
         //            LastName = "Mcmillan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 8, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1118,
         //            //StudentPersonId = 1118,
         //            StateStudentIdentifier = "4214761118",
         //            FirstName = "Alexandra",
         //            MiddleName = "Noelle",
         //            LastName = "Hendrix",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 1, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1119,
         //            //StudentPersonId = 1119,
         //            StateStudentIdentifier = "5731491119",
         //            FirstName = "Alexander",
         //            MiddleName = "Lewis",
         //            LastName = "Mckee",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 2, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1120,
         //            //StudentPersonId = 1120,
         //            StateStudentIdentifier = "2457981120",
         //            FirstName = "Clio",
         //            MiddleName = "Amela",
         //            LastName = "French",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 5, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1121,
         //            //StudentPersonId = 1121,
         //            StateStudentIdentifier = "7752491121",
         //            FirstName = "Beatrice",
         //            MiddleName = "Kim",
         //            LastName = "Banks",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 5, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1122,
         //            //StudentPersonId = 1122,
         //            StateStudentIdentifier = "4741881122",
         //            FirstName = "Astra",
         //            MiddleName = "Mallory",
         //            LastName = "Holman",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(1995, 4, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1123,
         //            //StudentPersonId = 1123,
         //            StateStudentIdentifier = "9279081123",
         //            FirstName = "Alexander",
         //            MiddleName = "Tyrone",
         //            LastName = "Winters",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 4, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1124,
         //            //StudentPersonId = 1124,
         //            StateStudentIdentifier = "3789601124",
         //            FirstName = "Cairo",
         //            MiddleName = "Fritz",
         //            LastName = "Lambert",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 4, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1125,
         //            //StudentPersonId = 1125,
         //            StateStudentIdentifier = "0319761125",
         //            FirstName = "Robin",
         //            MiddleName = "Harper",
         //            LastName = "Mcclain",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 10, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1126,
         //            //StudentPersonId = 1126,
         //            StateStudentIdentifier = "0625711126",
         //            FirstName = "Shelby",
         //            MiddleName = "Kaitlin",
         //            LastName = "Chaney",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 6, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1127,
         //            //StudentPersonId = 1127,
         //            StateStudentIdentifier = "9168161127",
         //            FirstName = "Berk",
         //            MiddleName = "Dominic",
         //            LastName = "Paul",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2009, 10, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1128,
         //            //StudentPersonId = 1128,
         //            StateStudentIdentifier = "8558781128",
         //            FirstName = "Anjolie",
         //            MiddleName = "Angelica",
         //            LastName = "Mckee",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2009, 6, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1129,
         //            //StudentPersonId = 1129,
         //            StateStudentIdentifier = "2343571129",
         //            FirstName = "Wade",
         //            MiddleName = "Peter",
         //            LastName = "Page",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 11, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1130,
         //            //StudentPersonId = 1130,
         //            StateStudentIdentifier = "8457731130",
         //            FirstName = "Holmes",
         //            MiddleName = "Phillip",
         //            LastName = "Leonard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 3, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1131,
         //            //StudentPersonId = 1131,
         //            StateStudentIdentifier = "8969891131",
         //            FirstName = "Morgan",
         //            MiddleName = "Sylvia",
         //            LastName = "Rojas",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 10, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1132,
         //            //StudentPersonId = 1132,
         //            StateStudentIdentifier = "0186161132",
         //            FirstName = "Geraldine",
         //            MiddleName = "Giselle",
         //            LastName = "Gilmore",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2013, 6, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1133,
         //            //StudentPersonId = 1133,
         //            StateStudentIdentifier = "2377021133",
         //            FirstName = "Reece",
         //            MiddleName = "Rudyard",
         //            LastName = "Carpenter",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2006, 11, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1134,
         //            //StudentPersonId = 1134,
         //            StateStudentIdentifier = "3110591134",
         //            FirstName = "Jolene",
         //            MiddleName = "Naomi",
         //            LastName = "Santos",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2013, 11, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1135,
         //            //StudentPersonId = 1135,
         //            StateStudentIdentifier = "8343911135",
         //            FirstName = "Sharon",
         //            MiddleName = "Michelle",
         //            LastName = "Sellers",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 11, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1136,
         //            //StudentPersonId = 1136,
         //            StateStudentIdentifier = "5837091136",
         //            FirstName = "Chelsea",
         //            MiddleName = "Hanna",
         //            LastName = "Daugherty",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 12, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1137,
         //            //StudentPersonId = 1137,
         //            StateStudentIdentifier = "4645111137",
         //            FirstName = "Fatima",
         //            MiddleName = "Lavinia",
         //            LastName = "Cantu",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 8, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1138,
         //            //StudentPersonId = 1138,
         //            StateStudentIdentifier = "6059351138",
         //            FirstName = "Christopher",
         //            MiddleName = "Xavier",
         //            LastName = "Pratt",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2006, 3, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1139,
         //            //StudentPersonId = 1139,
         //            StateStudentIdentifier = "1632181139",
         //            FirstName = "Gillian",
         //            MiddleName = "Beverly",
         //            LastName = "Britt",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2001, 7, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1140,
         //            //StudentPersonId = 1140,
         //            StateStudentIdentifier = "4694361140",
         //            FirstName = "Latifah",
         //            MiddleName = "Scarlet",
         //            LastName = "Church",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2000, 12, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1141,
         //            //StudentPersonId = 1141,
         //            StateStudentIdentifier = "2119251141",
         //            FirstName = "Natalie",
         //            MiddleName = "Natalie",
         //            LastName = "Buchanan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 3, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1142,
         //            //StudentPersonId = 1142,
         //            StateStudentIdentifier = "4026261142",
         //            FirstName = "Shaine",
         //            MiddleName = "Cailin",
         //            LastName = "Knox",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 6, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1143,
         //            //StudentPersonId = 1143,
         //            StateStudentIdentifier = "6846521143",
         //            FirstName = "Hadassah",
         //            MiddleName = "Jocelyn",
         //            LastName = "Forbes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 8, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1144,
         //            //StudentPersonId = 1144,
         //            StateStudentIdentifier = "9062341144",
         //            FirstName = "Rylee",
         //            MiddleName = "Sacha",
         //            LastName = "Rice",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 8, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1145,
         //            //StudentPersonId = 1145,
         //            StateStudentIdentifier = "2875601145",
         //            FirstName = "Kerry",
         //            MiddleName = "Adena",
         //            LastName = "Mooney",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2000, 4, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1146,
         //            //StudentPersonId = 1146,
         //            StateStudentIdentifier = "9271201146",
         //            FirstName = "Tanisha",
         //            MiddleName = "Leah",
         //            LastName = "Bass",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2014, 5, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1147,
         //            //StudentPersonId = 1147,
         //            StateStudentIdentifier = "4502871147",
         //            FirstName = "Courtney",
         //            MiddleName = "Melissa",
         //            LastName = "Mills",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 10, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1148,
         //            //StudentPersonId = 1148,
         //            StateStudentIdentifier = "4479751148",
         //            FirstName = "Riley",
         //            MiddleName = "Dakota",
         //            LastName = "Caldwell",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2010, 4, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1149,
         //            //StudentPersonId = 1149,
         //            StateStudentIdentifier = "4979241149",
         //            FirstName = "Maxine",
         //            MiddleName = "Galena",
         //            LastName = "Walker",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 4, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1150,
         //            //StudentPersonId = 1150,
         //            StateStudentIdentifier = "7162551150",
         //            FirstName = "Guy",
         //            MiddleName = "Elvis",
         //            LastName = "Kramer",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 7, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1151,
         //            //StudentPersonId = 1151,
         //            StateStudentIdentifier = "1518141151",
         //            FirstName = "Hop",
         //            MiddleName = "Xanthus",
         //            LastName = "Pugh",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2001, 7, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1152,
         //            //StudentPersonId = 1152,
         //            StateStudentIdentifier = "6333271152",
         //            FirstName = "Kirk",
         //            MiddleName = "Kuame",
         //            LastName = "Tate",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2019, 12, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1153,
         //            //StudentPersonId = 1153,
         //            StateStudentIdentifier = "1465051153",
         //            FirstName = "Brenden",
         //            MiddleName = "Vaughan",
         //            LastName = "Hunt",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 12, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1154,
         //            //StudentPersonId = 1154,
         //            StateStudentIdentifier = "0433541154",
         //            FirstName = "Hall",
         //            MiddleName = "Slade",
         //            LastName = "Newton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 7, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1155,
         //            //StudentPersonId = 1155,
         //            StateStudentIdentifier = "1066941155",
         //            FirstName = "Iris",
         //            MiddleName = "Emerald",
         //            LastName = "Vaughn",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2014, 9, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1156,
         //            //StudentPersonId = 1156,
         //            StateStudentIdentifier = "0164261156",
         //            FirstName = "Mike",
         //            MiddleName = "Tate",
         //            LastName = "Bond",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 11, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1157,
         //            //StudentPersonId = 1157,
         //            StateStudentIdentifier = "5916061157",
         //            FirstName = "Vladimir",
         //            MiddleName = "Basia",
         //            LastName = "Mosley",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2013, 7, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1158,
         //            //StudentPersonId = 1158,
         //            StateStudentIdentifier = "8516801158",
         //            FirstName = "Hector",
         //            MiddleName = "Octavius",
         //            LastName = "Horn",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2014, 7, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1159,
         //            //StudentPersonId = 1159,
         //            StateStudentIdentifier = "1307871159",
         //            FirstName = "Plato",
         //            MiddleName = "Carter",
         //            LastName = "Barlow",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 7, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1160,
         //            //StudentPersonId = 1160,
         //            StateStudentIdentifier = "9166711160",
         //            FirstName = "Len",
         //            MiddleName = "Ethan",
         //            LastName = "Blankenship",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2016, 4, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1161,
         //            //StudentPersonId = 1161,
         //            StateStudentIdentifier = "0435941161",
         //            FirstName = "Aidan",
         //            MiddleName = "Arthur",
         //            LastName = "Hancock",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 2, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1162,
         //            //StudentPersonId = 1162,
         //            StateStudentIdentifier = "1833271162",
         //            FirstName = "Roth",
         //            MiddleName = "Farrah",
         //            LastName = "Berger",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2000, 12, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1163,
         //            //StudentPersonId = 1163,
         //            StateStudentIdentifier = "1509571163",
         //            FirstName = "Aileen",
         //            MiddleName = "Camille",
         //            LastName = "Carroll",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 1, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1164,
         //            //StudentPersonId = 1164,
         //            StateStudentIdentifier = "9331721164",
         //            FirstName = "Candice",
         //            MiddleName = "Whoopi",
         //            LastName = "Turner",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 5, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1165,
         //            //StudentPersonId = 1165,
         //            StateStudentIdentifier = "9205271165",
         //            FirstName = "Rudyard",
         //            MiddleName = "Charles",
         //            LastName = "Quinn",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 10, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1166,
         //            //StudentPersonId = 1166,
         //            StateStudentIdentifier = "5229141166",
         //            FirstName = "Nayda",
         //            MiddleName = "Veronica",
         //            LastName = "Parker",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 5, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1167,
         //            //StudentPersonId = 1167,
         //            StateStudentIdentifier = "0930751167",
         //            FirstName = "Gloria",
         //            MiddleName = "Idona",
         //            LastName = "Hopper",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 6, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1168,
         //            //StudentPersonId = 1168,
         //            StateStudentIdentifier = "5892831168",
         //            FirstName = "Thaddeus",
         //            MiddleName = "Ignatius",
         //            LastName = "Mcmahon",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 4, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1169,
         //            //StudentPersonId = 1169,
         //            StateStudentIdentifier = "9004251169",
         //            FirstName = "Duncan",
         //            MiddleName = "Quinlan",
         //            LastName = "Robertson",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2008, 10, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1170,
         //            //StudentPersonId = 1170,
         //            StateStudentIdentifier = "9847541170",
         //            FirstName = "Noelani",
         //            MiddleName = "Amber",
         //            LastName = "Rodriguez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 8, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1171,
         //            //StudentPersonId = 1171,
         //            StateStudentIdentifier = "9440451171",
         //            FirstName = "Nita",
         //            MiddleName = "Simone",
         //            LastName = "Blake",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 4, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1172,
         //            //StudentPersonId = 1172,
         //            StateStudentIdentifier = "5478881172",
         //            FirstName = "Hanae",
         //            MiddleName = "Hakeem",
         //            LastName = "Mitchell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 2, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1173,
         //            //StudentPersonId = 1173,
         //            StateStudentIdentifier = "7466881173",
         //            FirstName = "Emerald",
         //            MiddleName = "Leandra",
         //            LastName = "Nash",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 10, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1174,
         //            //StudentPersonId = 1174,
         //            StateStudentIdentifier = "1222671174",
         //            FirstName = "Shellie",
         //            MiddleName = "Hanna",
         //            LastName = "Burns",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 7, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1175,
         //            //StudentPersonId = 1175,
         //            StateStudentIdentifier = "0010131175",
         //            FirstName = "Xandra",
         //            MiddleName = "Catherine",
         //            LastName = "Ball",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 12, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1176,
         //            //StudentPersonId = 1176,
         //            StateStudentIdentifier = "9956281176",
         //            FirstName = "Lydia",
         //            MiddleName = "Diana",
         //            LastName = "Gordon",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 9, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1177,
         //            //StudentPersonId = 1177,
         //            StateStudentIdentifier = "7034441177",
         //            FirstName = "Cameron",
         //            MiddleName = "Madison",
         //            LastName = "Franks",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(1999, 6, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1178,
         //            //StudentPersonId = 1178,
         //            StateStudentIdentifier = "7108311178",
         //            FirstName = "Jared",
         //            MiddleName = "Daquan",
         //            LastName = "Bright",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1996, 8, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1179,
         //            //StudentPersonId = 1179,
         //            StateStudentIdentifier = "1593951179",
         //            FirstName = "Macon",
         //            MiddleName = "Mufutau",
         //            LastName = "Meadows",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 12, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1180,
         //            //StudentPersonId = 1180,
         //            StateStudentIdentifier = "9807071180",
         //            FirstName = "Brandon",
         //            MiddleName = "Rogan",
         //            LastName = "Guzman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 7, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1181,
         //            //StudentPersonId = 1181,
         //            StateStudentIdentifier = "1734361181",
         //            FirstName = "Gloria",
         //            MiddleName = "Katelyn",
         //            LastName = "French",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 11, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1182,
         //            //StudentPersonId = 1182,
         //            StateStudentIdentifier = "6779061182",
         //            FirstName = "Meghan",
         //            MiddleName = "Joelle",
         //            LastName = "Holloway",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 6, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1183,
         //            //StudentPersonId = 1183,
         //            StateStudentIdentifier = "9199371183",
         //            FirstName = "Cade",
         //            MiddleName = "Barrett",
         //            LastName = "Oneill",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 8, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1184,
         //            //StudentPersonId = 1184,
         //            StateStudentIdentifier = "5809441184",
         //            FirstName = "Bradley",
         //            MiddleName = "Jelani",
         //            LastName = "Chaney",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 1, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1185,
         //            //StudentPersonId = 1185,
         //            StateStudentIdentifier = "4920141185",
         //            FirstName = "Harper",
         //            MiddleName = "Thane",
         //            LastName = "Oneal",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 11, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1186,
         //            //StudentPersonId = 1186,
         //            StateStudentIdentifier = "8613821186",
         //            FirstName = "Nina",
         //            MiddleName = "Ingrid",
         //            LastName = "Dennis",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 4, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1187,
         //            //StudentPersonId = 1187,
         //            StateStudentIdentifier = "6887381187",
         //            FirstName = "George",
         //            MiddleName = "Kasimir",
         //            LastName = "Burris",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 2, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1188,
         //            //StudentPersonId = 1188,
         //            StateStudentIdentifier = "2157411188",
         //            FirstName = "Sean",
         //            MiddleName = "Bradley",
         //            LastName = "Durham",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2015, 2, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1189,
         //            //StudentPersonId = 1189,
         //            StateStudentIdentifier = "2281341189",
         //            FirstName = "Chandler",
         //            MiddleName = "Malachi",
         //            LastName = "Porter",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1998, 10, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1190,
         //            //StudentPersonId = 1190,
         //            StateStudentIdentifier = "0165031190",
         //            FirstName = "Dustin",
         //            MiddleName = "Amos",
         //            LastName = "Stephens",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2016, 3, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1191,
         //            //StudentPersonId = 1191,
         //            StateStudentIdentifier = "2564321191",
         //            FirstName = "Gillian",
         //            MiddleName = "Darryl",
         //            LastName = "Morse",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 11, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1192,
         //            //StudentPersonId = 1192,
         //            StateStudentIdentifier = "9352841192",
         //            FirstName = "Calvin",
         //            MiddleName = "Nissim",
         //            LastName = "Pugh",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 8, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1193,
         //            //StudentPersonId = 1193,
         //            StateStudentIdentifier = "5133821193",
         //            FirstName = "Tobias",
         //            MiddleName = "Russell",
         //            LastName = "Cotton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 7, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1194,
         //            //StudentPersonId = 1194,
         //            StateStudentIdentifier = "9794061194",
         //            FirstName = "Igor",
         //            MiddleName = "Cole",
         //            LastName = "Faulkner",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 1, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1195,
         //            //StudentPersonId = 1195,
         //            StateStudentIdentifier = "2961941195",
         //            FirstName = "Aileen",
         //            MiddleName = "Kellie",
         //            LastName = "Cantu",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 5, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1196,
         //            //StudentPersonId = 1196,
         //            StateStudentIdentifier = "9794021196",
         //            FirstName = "Reese",
         //            MiddleName = "Colt",
         //            LastName = "Hebert",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 3, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1197,
         //            //StudentPersonId = 1197,
         //            StateStudentIdentifier = "3120531197",
         //            FirstName = "Flynn",
         //            MiddleName = "Josiah",
         //            LastName = "Huber",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(1998, 5, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1198,
         //            //StudentPersonId = 1198,
         //            StateStudentIdentifier = "8312381198",
         //            FirstName = "Adrienne",
         //            MiddleName = "Jamalia",
         //            LastName = "Quinn",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 11, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1199,
         //            //StudentPersonId = 1199,
         //            StateStudentIdentifier = "9071221199",
         //            FirstName = "Dominique",
         //            MiddleName = "Steven",
         //            LastName = "Joyce",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 9, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1200,
         //            //StudentPersonId = 1200,
         //            StateStudentIdentifier = "5845291200",
         //            FirstName = "Guy",
         //            MiddleName = "Ciaran",
         //            LastName = "Welch",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 12, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1201,
         //            //StudentPersonId = 1201,
         //            StateStudentIdentifier = "6636111201",
         //            FirstName = "Ifeoma",
         //            MiddleName = "Libby",
         //            LastName = "Haney",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2000, 1, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1202,
         //            //StudentPersonId = 1202,
         //            StateStudentIdentifier = "1014591202",
         //            FirstName = "Felix",
         //            MiddleName = "Yoshio",
         //            LastName = "Manning",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 3, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1203,
         //            //StudentPersonId = 1203,
         //            StateStudentIdentifier = "1938441203",
         //            FirstName = "Mechelle",
         //            MiddleName = "Karina",
         //            LastName = "Bruce",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1996, 1, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1204,
         //            //StudentPersonId = 1204,
         //            StateStudentIdentifier = "2187131204",
         //            FirstName = "Randall",
         //            MiddleName = "Kennedy",
         //            LastName = "Bass",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 10, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1205,
         //            //StudentPersonId = 1205,
         //            StateStudentIdentifier = "7599001205",
         //            FirstName = "Shafira",
         //            MiddleName = "Genevieve",
         //            LastName = "Holloway",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 9, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1206,
         //            //StudentPersonId = 1206,
         //            StateStudentIdentifier = "5194031206",
         //            FirstName = "Sopoline",
         //            MiddleName = "Hayfa",
         //            LastName = "Tanner",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 2, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1207,
         //            //StudentPersonId = 1207,
         //            StateStudentIdentifier = "0761121207",
         //            FirstName = "Claudia",
         //            MiddleName = "Alana",
         //            LastName = "Rivas",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2001, 4, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1208,
         //            //StudentPersonId = 1208,
         //            StateStudentIdentifier = "0456261208",
         //            FirstName = "Allistair",
         //            MiddleName = "Lavinia",
         //            LastName = "Huff",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 9, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1209,
         //            //StudentPersonId = 1209,
         //            StateStudentIdentifier = "8400361209",
         //            FirstName = "Geraldine",
         //            MiddleName = "Maile",
         //            LastName = "Massey",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 10, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1210,
         //            //StudentPersonId = 1210,
         //            StateStudentIdentifier = "2973441210",
         //            FirstName = "Norman",
         //            MiddleName = "Lucius",
         //            LastName = "Fry",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 2, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1211,
         //            //StudentPersonId = 1211,
         //            StateStudentIdentifier = "4378591211",
         //            FirstName = "Clarke",
         //            MiddleName = "Amos",
         //            LastName = "Farmer",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2004, 1, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1212,
         //            //StudentPersonId = 1212,
         //            StateStudentIdentifier = "6684841212",
         //            FirstName = "Travis",
         //            MiddleName = "Grant",
         //            LastName = "Bartlett",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 1, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1213,
         //            //StudentPersonId = 1213,
         //            StateStudentIdentifier = "2369221213",
         //            FirstName = "Melodie",
         //            MiddleName = "Rachel",
         //            LastName = "Hancock",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2005, 10, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1214,
         //            //StudentPersonId = 1214,
         //            StateStudentIdentifier = "2439221214",
         //            FirstName = "Chantale",
         //            MiddleName = "Dominique",
         //            LastName = "Ellison",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 10, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1215,
         //            //StudentPersonId = 1215,
         //            StateStudentIdentifier = "7623821215",
         //            FirstName = "Brennan",
         //            MiddleName = "Amos",
         //            LastName = "Fuentes",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2019, 11, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1216,
         //            //StudentPersonId = 1216,
         //            StateStudentIdentifier = "6217341216",
         //            FirstName = "Macon",
         //            MiddleName = "Bernard",
         //            LastName = "Hubbard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 3, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1217,
         //            //StudentPersonId = 1217,
         //            StateStudentIdentifier = "1390161217",
         //            FirstName = "Amanda",
         //            MiddleName = "Ebony",
         //            LastName = "Oneal",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 7, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1218,
         //            //StudentPersonId = 1218,
         //            StateStudentIdentifier = "5485401218",
         //            FirstName = "Yoshio",
         //            MiddleName = "Alyssa",
         //            LastName = "Berger",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 12, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1219,
         //            //StudentPersonId = 1219,
         //            StateStudentIdentifier = "9287411219",
         //            FirstName = "Berk",
         //            MiddleName = "Uriel",
         //            LastName = "Gonzales",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 6, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1220,
         //            //StudentPersonId = 1220,
         //            StateStudentIdentifier = "3056531220",
         //            FirstName = "Nichole",
         //            MiddleName = "Xantha",
         //            LastName = "Aguirre",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2011, 1, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1221,
         //            //StudentPersonId = 1221,
         //            StateStudentIdentifier = "1630601221",
         //            FirstName = "Tatyana",
         //            MiddleName = "Dalton",
         //            LastName = "Underwood",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2018, 4, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1222,
         //            //StudentPersonId = 1222,
         //            StateStudentIdentifier = "6915301222",
         //            FirstName = "Cara",
         //            MiddleName = "Carol",
         //            LastName = "Rasmussen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 3, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1223,
         //            //StudentPersonId = 1223,
         //            StateStudentIdentifier = "8473871223",
         //            FirstName = "Chancellor",
         //            MiddleName = "Harding",
         //            LastName = "Matthews",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 3, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1224,
         //            //StudentPersonId = 1224,
         //            StateStudentIdentifier = "6430721224",
         //            FirstName = "Skyler",
         //            MiddleName = "Rhona",
         //            LastName = "Nixon",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 5, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1225,
         //            //StudentPersonId = 1225,
         //            StateStudentIdentifier = "3299131225",
         //            FirstName = "Palmer",
         //            MiddleName = "Nasim",
         //            LastName = "Hancock",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 2, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1226,
         //            //StudentPersonId = 1226,
         //            StateStudentIdentifier = "4399571226",
         //            FirstName = "Derek",
         //            MiddleName = "Tanner",
         //            LastName = "Stephens",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 5, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1227,
         //            //StudentPersonId = 1227,
         //            StateStudentIdentifier = "4993381227",
         //            FirstName = "Kerry",
         //            MiddleName = "Vera",
         //            LastName = "Rivas",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2013, 12, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1228,
         //            //StudentPersonId = 1228,
         //            StateStudentIdentifier = "9894711228",
         //            FirstName = "Blaine",
         //            MiddleName = "Amethyst",
         //            LastName = "Joseph",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 3, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1229,
         //            //StudentPersonId = 1229,
         //            StateStudentIdentifier = "8858821229",
         //            FirstName = "Curran",
         //            MiddleName = "Fitzgerald",
         //            LastName = "Welch",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1999, 10, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1230,
         //            //StudentPersonId = 1230,
         //            StateStudentIdentifier = "9462311230",
         //            FirstName = "Colin",
         //            MiddleName = "Hector",
         //            LastName = "Schneider",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2006, 12, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1231,
         //            //StudentPersonId = 1231,
         //            StateStudentIdentifier = "0859451231",
         //            FirstName = "Stone",
         //            MiddleName = "Yardley",
         //            LastName = "Dejesus",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 8, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1232,
         //            //StudentPersonId = 1232,
         //            StateStudentIdentifier = "7427111232",
         //            FirstName = "Tad",
         //            MiddleName = "Tarik",
         //            LastName = "Cameron",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2001, 2, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1233,
         //            //StudentPersonId = 1233,
         //            StateStudentIdentifier = "5741141233",
         //            FirstName = "Sylvester",
         //            MiddleName = "Thor",
         //            LastName = "Nicholson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 12, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1234,
         //            //StudentPersonId = 1234,
         //            StateStudentIdentifier = "4555051234",
         //            FirstName = "Lavinia",
         //            MiddleName = "Daphne",
         //            LastName = "Ellison",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 5, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1235,
         //            //StudentPersonId = 1235,
         //            StateStudentIdentifier = "2040941235",
         //            FirstName = "Sybil",
         //            MiddleName = "Hiroko",
         //            LastName = "Gay",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 6, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1236,
         //            //StudentPersonId = 1236,
         //            StateStudentIdentifier = "1475781236",
         //            FirstName = "Yuli",
         //            MiddleName = "Conan",
         //            LastName = "Robertson",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 1, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1237,
         //            //StudentPersonId = 1237,
         //            StateStudentIdentifier = "4072961237",
         //            FirstName = "Garrison",
         //            MiddleName = "Griffin",
         //            LastName = "Soto",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 9, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1238,
         //            //StudentPersonId = 1238,
         //            StateStudentIdentifier = "1677911238",
         //            FirstName = "Christopher",
         //            MiddleName = "Elijah",
         //            LastName = "Hopper",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 10, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1239,
         //            //StudentPersonId = 1239,
         //            StateStudentIdentifier = "7490231239",
         //            FirstName = "Ulric",
         //            MiddleName = "Keegan",
         //            LastName = "Patel",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 10, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1240,
         //            //StudentPersonId = 1240,
         //            StateStudentIdentifier = "3510981240",
         //            FirstName = "Stella",
         //            MiddleName = "Ulla",
         //            LastName = "Eaton",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2014, 6, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1241,
         //            //StudentPersonId = 1241,
         //            StateStudentIdentifier = "9667241241",
         //            FirstName = "Willow",
         //            MiddleName = "Idola",
         //            LastName = "Summers",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2005, 12, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1242,
         //            //StudentPersonId = 1242,
         //            StateStudentIdentifier = "4901341242",
         //            FirstName = "Cruz",
         //            MiddleName = "Tate",
         //            LastName = "Mendez",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2009, 8, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1243,
         //            //StudentPersonId = 1243,
         //            StateStudentIdentifier = "5414971243",
         //            FirstName = "Britanni",
         //            MiddleName = "Iris",
         //            LastName = "Fitzgerald",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 11, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1244,
         //            //StudentPersonId = 1244,
         //            StateStudentIdentifier = "1376021244",
         //            FirstName = "Belle",
         //            MiddleName = "Yeo",
         //            LastName = "Mann",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 10, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1245,
         //            //StudentPersonId = 1245,
         //            StateStudentIdentifier = "3313041245",
         //            FirstName = "Penelope",
         //            MiddleName = "Camille",
         //            LastName = "Williams",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 9, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1246,
         //            //StudentPersonId = 1246,
         //            StateStudentIdentifier = "6967371246",
         //            FirstName = "Rebecca",
         //            MiddleName = "Alexa",
         //            LastName = "Lyons",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 8, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1247,
         //            //StudentPersonId = 1247,
         //            StateStudentIdentifier = "7878571247",
         //            FirstName = "Ezekiel",
         //            MiddleName = "Price",
         //            LastName = "Elliott",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 2, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1248,
         //            //StudentPersonId = 1248,
         //            StateStudentIdentifier = "8161091248",
         //            FirstName = "Karen",
         //            MiddleName = "Blaine",
         //            LastName = "Wood",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2016, 2, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1249,
         //            //StudentPersonId = 1249,
         //            StateStudentIdentifier = "5154081249",
         //            FirstName = "Wilma",
         //            MiddleName = "Inez",
         //            LastName = "Blair",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 12, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1250,
         //            //StudentPersonId = 1250,
         //            StateStudentIdentifier = "2918061250",
         //            FirstName = "Simon",
         //            MiddleName = "Fitzgerald",
         //            LastName = "Watts",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2016, 10, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1251,
         //            //StudentPersonId = 1251,
         //            StateStudentIdentifier = "1785361251",
         //            FirstName = "Chancellor",
         //            MiddleName = "Uriel",
         //            LastName = "Noel",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 4, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1252,
         //            //StudentPersonId = 1252,
         //            StateStudentIdentifier = "2613581252",
         //            FirstName = "Phyllis",
         //            MiddleName = "Grace",
         //            LastName = "Waters",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 9, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1253,
         //            //StudentPersonId = 1253,
         //            StateStudentIdentifier = "2362421253",
         //            FirstName = "Oscar",
         //            MiddleName = "Armand",
         //            LastName = "Burch",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 10, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1254,
         //            //StudentPersonId = 1254,
         //            StateStudentIdentifier = "3033361254",
         //            FirstName = "Nicole",
         //            MiddleName = "Debra",
         //            LastName = "Ayers",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 4, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1255,
         //            //StudentPersonId = 1255,
         //            StateStudentIdentifier = "3320721255",
         //            FirstName = "Tanisha",
         //            MiddleName = "Darryl",
         //            LastName = "Lindsay",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2009, 2, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1256,
         //            //StudentPersonId = 1256,
         //            StateStudentIdentifier = "8276191256",
         //            FirstName = "Nina",
         //            MiddleName = "Ramona",
         //            LastName = "Burns",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 8, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1257,
         //            //StudentPersonId = 1257,
         //            StateStudentIdentifier = "7176391257",
         //            FirstName = "Jaquelyn",
         //            MiddleName = "Yvette",
         //            LastName = "Knowles",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2004, 2, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1258,
         //            //StudentPersonId = 1258,
         //            StateStudentIdentifier = "5711271258",
         //            FirstName = "Bert",
         //            MiddleName = "Penelope",
         //            LastName = "Gay",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2011, 4, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1259,
         //            //StudentPersonId = 1259,
         //            StateStudentIdentifier = "5717551259",
         //            FirstName = "Preston",
         //            MiddleName = "Barclay",
         //            LastName = "Nunez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 9, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1260,
         //            //StudentPersonId = 1260,
         //            StateStudentIdentifier = "7653831260",
         //            FirstName = "Uta",
         //            MiddleName = "Malachi",
         //            LastName = "England",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2000, 8, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1261,
         //            //StudentPersonId = 1261,
         //            StateStudentIdentifier = "1270621261",
         //            FirstName = "Sebastian",
         //            MiddleName = "Marshall",
         //            LastName = "Hicks",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 3, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1262,
         //            //StudentPersonId = 1262,
         //            StateStudentIdentifier = "6200211262",
         //            FirstName = "Evelyn",
         //            MiddleName = "Leigh",
         //            LastName = "Griffith",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 11, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1263,
         //            //StudentPersonId = 1263,
         //            StateStudentIdentifier = "5540921263",
         //            FirstName = "Ava",
         //            MiddleName = "Idola",
         //            LastName = "Figueroa",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 10, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1264,
         //            //StudentPersonId = 1264,
         //            StateStudentIdentifier = "6729821264",
         //            FirstName = "Mona",
         //            MiddleName = "Imogene",
         //            LastName = "Nielsen",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 3, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1265,
         //            //StudentPersonId = 1265,
         //            StateStudentIdentifier = "0480081265",
         //            FirstName = "Charity",
         //            MiddleName = "Alfonso",
         //            LastName = "Lee",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 9, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1266,
         //            //StudentPersonId = 1266,
         //            StateStudentIdentifier = "3626041266",
         //            FirstName = "Kevin",
         //            MiddleName = "Sebastian",
         //            LastName = "Fisher",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2017, 6, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1267,
         //            //StudentPersonId = 1267,
         //            StateStudentIdentifier = "2344521267",
         //            FirstName = "Halla",
         //            MiddleName = "Sybil",
         //            LastName = "Mcgee",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 3, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1268,
         //            //StudentPersonId = 1268,
         //            StateStudentIdentifier = "2126431268",
         //            FirstName = "Chiquita",
         //            MiddleName = "April",
         //            LastName = "Dominguez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 5, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1269,
         //            //StudentPersonId = 1269,
         //            StateStudentIdentifier = "6389131269",
         //            FirstName = "Lucius",
         //            MiddleName = "Jelani",
         //            LastName = "Sharpe",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 8, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1270,
         //            //StudentPersonId = 1270,
         //            StateStudentIdentifier = "8113641270",
         //            FirstName = "Giacomo",
         //            MiddleName = "Kamal",
         //            LastName = "Oneill",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 6, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1271,
         //            //StudentPersonId = 1271,
         //            StateStudentIdentifier = "8487291271",
         //            FirstName = "Fredericka",
         //            MiddleName = "Nero",
         //            LastName = "Mccormick",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2002, 7, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1272,
         //            //StudentPersonId = 1272,
         //            StateStudentIdentifier = "5210861272",
         //            FirstName = "Kane",
         //            MiddleName = "Patrick",
         //            LastName = "Gonzales",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 12, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1273,
         //            //StudentPersonId = 1273,
         //            StateStudentIdentifier = "8516381273",
         //            FirstName = "Wilma",
         //            MiddleName = "Ima",
         //            LastName = "Nixon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 12, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1274,
         //            //StudentPersonId = 1274,
         //            StateStudentIdentifier = "0901041274",
         //            FirstName = "Plato",
         //            MiddleName = "Chadwick",
         //            LastName = "Greer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 3, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1275,
         //            //StudentPersonId = 1275,
         //            StateStudentIdentifier = "0186691275",
         //            FirstName = "Galena",
         //            MiddleName = "Germane",
         //            LastName = "Lang",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 1, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1276,
         //            //StudentPersonId = 1276,
         //            StateStudentIdentifier = "2558191276",
         //            FirstName = "Quinlan",
         //            MiddleName = "Wade",
         //            LastName = "Byrd",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 10, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1277,
         //            //StudentPersonId = 1277,
         //            StateStudentIdentifier = "8286971277",
         //            FirstName = "Warren",
         //            MiddleName = "Jacob",
         //            LastName = "Williamson",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 12, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1278,
         //            //StudentPersonId = 1278,
         //            StateStudentIdentifier = "9983271278",
         //            FirstName = "Kadeem",
         //            MiddleName = "Marvin",
         //            LastName = "Nixon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 9, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1279,
         //            //StudentPersonId = 1279,
         //            StateStudentIdentifier = "1968441279",
         //            FirstName = "Melodie",
         //            MiddleName = "Deborah",
         //            LastName = "Schneider",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 11, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1280,
         //            //StudentPersonId = 1280,
         //            StateStudentIdentifier = "1187001280",
         //            FirstName = "Bernard",
         //            MiddleName = "Finn",
         //            LastName = "Ryan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 11, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1281,
         //            //StudentPersonId = 1281,
         //            StateStudentIdentifier = "3233861281",
         //            FirstName = "Murphy",
         //            MiddleName = "Elmo",
         //            LastName = "Buchanan",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2002, 11, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1282,
         //            //StudentPersonId = 1282,
         //            StateStudentIdentifier = "5857281282",
         //            FirstName = "Cara",
         //            MiddleName = "Wilma",
         //            LastName = "Pugh",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 11, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1283,
         //            //StudentPersonId = 1283,
         //            StateStudentIdentifier = "9576821283",
         //            FirstName = "Quamar",
         //            MiddleName = "Coby",
         //            LastName = "Conley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 9, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1284,
         //            //StudentPersonId = 1284,
         //            StateStudentIdentifier = "9098191284",
         //            FirstName = "Judah",
         //            MiddleName = "Josiah",
         //            LastName = "Gaines",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 11, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1285,
         //            //StudentPersonId = 1285,
         //            StateStudentIdentifier = "1658211285",
         //            FirstName = "Thaddeus",
         //            MiddleName = "Karina",
         //            LastName = "Bryan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 7, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1286,
         //            //StudentPersonId = 1286,
         //            StateStudentIdentifier = "9156731286",
         //            FirstName = "Basia",
         //            MiddleName = "Camilla",
         //            LastName = "Mercado",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2000, 7, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1287,
         //            //StudentPersonId = 1287,
         //            StateStudentIdentifier = "4983211287",
         //            FirstName = "Isaac",
         //            MiddleName = "Adam",
         //            LastName = "Hodges",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 1, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1288,
         //            //StudentPersonId = 1288,
         //            StateStudentIdentifier = "4328991288",
         //            FirstName = "Colt",
         //            MiddleName = "Mason",
         //            LastName = "Newton",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2015, 10, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1289,
         //            //StudentPersonId = 1289,
         //            StateStudentIdentifier = "4538171289",
         //            FirstName = "Kimberley",
         //            MiddleName = "Tiger",
         //            LastName = "Cotton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 5, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1290,
         //            //StudentPersonId = 1290,
         //            StateStudentIdentifier = "3345111290",
         //            FirstName = "Hoyt",
         //            MiddleName = "Brian",
         //            LastName = "Mercado",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 5, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1291,
         //            //StudentPersonId = 1291,
         //            StateStudentIdentifier = "5293611291",
         //            FirstName = "Hakeem",
         //            MiddleName = "Amal",
         //            LastName = "Slater",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 5, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1292,
         //            //StudentPersonId = 1292,
         //            StateStudentIdentifier = "4433101292",
         //            FirstName = "Hamish",
         //            MiddleName = "Hakeem",
         //            LastName = "Gonzales",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 8, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1293,
         //            //StudentPersonId = 1293,
         //            StateStudentIdentifier = "3743401293",
         //            FirstName = "Grace",
         //            MiddleName = "Roanna",
         //            LastName = "Best",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2018, 3, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1294,
         //            //StudentPersonId = 1294,
         //            StateStudentIdentifier = "4602251294",
         //            FirstName = "Demetrius",
         //            MiddleName = "Hedley",
         //            LastName = "Peters",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2005, 11, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1295,
         //            //StudentPersonId = 1295,
         //            StateStudentIdentifier = "5601951295",
         //            FirstName = "Jelani",
         //            MiddleName = "Jacob",
         //            LastName = "Bean",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 12, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1296,
         //            //StudentPersonId = 1296,
         //            StateStudentIdentifier = "3907401296",
         //            FirstName = "Kim",
         //            MiddleName = "Constance",
         //            LastName = "Mercado",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 5, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1297,
         //            //StudentPersonId = 1297,
         //            StateStudentIdentifier = "0194681297",
         //            FirstName = "Hedley",
         //            MiddleName = "Stuart",
         //            LastName = "Boyd",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2007, 2, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1298,
         //            //StudentPersonId = 1298,
         //            StateStudentIdentifier = "2801711298",
         //            FirstName = "Keith",
         //            MiddleName = "Allen",
         //            LastName = "Castro",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 3, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1299,
         //            //StudentPersonId = 1299,
         //            StateStudentIdentifier = "0420381299",
         //            FirstName = "Willa",
         //            MiddleName = "Aubrey",
         //            LastName = "Wade",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 11, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1300,
         //            //StudentPersonId = 1300,
         //            StateStudentIdentifier = "0149431300",
         //            FirstName = "Gloria",
         //            MiddleName = "Shannon",
         //            LastName = "Mooney",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 8, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1301,
         //            //StudentPersonId = 1301,
         //            StateStudentIdentifier = "6699821301",
         //            FirstName = "Alice",
         //            MiddleName = "Signe",
         //            LastName = "James",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2012, 11, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1302,
         //            //StudentPersonId = 1302,
         //            StateStudentIdentifier = "7662571302",
         //            FirstName = "Hadley",
         //            MiddleName = "Bianca",
         //            LastName = "Gutierrez",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2000, 9, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1303,
         //            //StudentPersonId = 1303,
         //            StateStudentIdentifier = "4576721303",
         //            FirstName = "Amery",
         //            MiddleName = "Thaddeus",
         //            LastName = "Randolph",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2013, 10, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1304,
         //            //StudentPersonId = 1304,
         //            StateStudentIdentifier = "3637751304",
         //            FirstName = "Buckminster",
         //            MiddleName = "Cairo",
         //            LastName = "Brewer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 7, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1305,
         //            //StudentPersonId = 1305,
         //            StateStudentIdentifier = "6044831305",
         //            FirstName = "Davis",
         //            MiddleName = "Alfonso",
         //            LastName = "Davidson",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2003, 1, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1306,
         //            //StudentPersonId = 1306,
         //            StateStudentIdentifier = "1020501306",
         //            FirstName = "Stella",
         //            MiddleName = "Guinevere",
         //            LastName = "Bush",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1995, 11, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1307,
         //            //StudentPersonId = 1307,
         //            StateStudentIdentifier = "4504471307",
         //            FirstName = "Noah",
         //            MiddleName = "Joshua",
         //            LastName = "Vincent",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 6, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1308,
         //            //StudentPersonId = 1308,
         //            StateStudentIdentifier = "0881781308",
         //            FirstName = "India",
         //            MiddleName = "Amethyst",
         //            LastName = "Bradshaw",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 3, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1309,
         //            //StudentPersonId = 1309,
         //            StateStudentIdentifier = "0016071309",
         //            FirstName = "Pearl",
         //            MiddleName = "Urielle",
         //            LastName = "Stafford",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1998, 8, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1310,
         //            //StudentPersonId = 1310,
         //            StateStudentIdentifier = "2812831310",
         //            FirstName = "Dean",
         //            MiddleName = "Donovan",
         //            LastName = "Knox",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 7, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1311,
         //            //StudentPersonId = 1311,
         //            StateStudentIdentifier = "9526501311",
         //            FirstName = "Fletcher",
         //            MiddleName = "Garth",
         //            LastName = "Joseph",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 11, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1312,
         //            //StudentPersonId = 1312,
         //            StateStudentIdentifier = "1146201312",
         //            FirstName = "Hashim",
         //            MiddleName = "Vance",
         //            LastName = "Peters",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 11, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1313,
         //            //StudentPersonId = 1313,
         //            StateStudentIdentifier = "2598201313",
         //            FirstName = "Levi",
         //            MiddleName = "Rashad",
         //            LastName = "Hodges",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2018, 4, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1314,
         //            //StudentPersonId = 1314,
         //            StateStudentIdentifier = "4752011314",
         //            FirstName = "Shad",
         //            MiddleName = "Ferris",
         //            LastName = "Collins",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 11, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1315,
         //            //StudentPersonId = 1315,
         //            StateStudentIdentifier = "8269931315",
         //            FirstName = "Caldwell",
         //            MiddleName = "Nero",
         //            LastName = "Collins",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 6, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1316,
         //            //StudentPersonId = 1316,
         //            StateStudentIdentifier = "4609901316",
         //            FirstName = "Grady",
         //            MiddleName = "Sebastian",
         //            LastName = "Macdonald",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 7, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1317,
         //            //StudentPersonId = 1317,
         //            StateStudentIdentifier = "8267541317",
         //            FirstName = "Delilah",
         //            MiddleName = "Fatima",
         //            LastName = "Bowman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 1, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1318,
         //            //StudentPersonId = 1318,
         //            StateStudentIdentifier = "3899761318",
         //            FirstName = "Cullen",
         //            MiddleName = "Erich",
         //            LastName = "Valencia",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 3, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1319,
         //            //StudentPersonId = 1319,
         //            StateStudentIdentifier = "9340481319",
         //            FirstName = "Kyle",
         //            MiddleName = "Lucian",
         //            LastName = "Acosta",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2007, 9, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1320,
         //            //StudentPersonId = 1320,
         //            StateStudentIdentifier = "2339931320",
         //            FirstName = "Patience",
         //            MiddleName = "Courtney",
         //            LastName = "Stokes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 9, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1321,
         //            //StudentPersonId = 1321,
         //            StateStudentIdentifier = "6902101321",
         //            FirstName = "Flynn",
         //            MiddleName = "Christopher",
         //            LastName = "Berger",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1995, 11, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1322,
         //            //StudentPersonId = 1322,
         //            StateStudentIdentifier = "6337371322",
         //            FirstName = "Odysseus",
         //            MiddleName = "Paula",
         //            LastName = "Beard",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1999, 3, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1323,
         //            //StudentPersonId = 1323,
         //            StateStudentIdentifier = "6383101323",
         //            FirstName = "Stuart",
         //            MiddleName = "Solomon",
         //            LastName = "Joyner",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 12, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1324,
         //            //StudentPersonId = 1324,
         //            StateStudentIdentifier = "4972781324",
         //            FirstName = "Amber",
         //            MiddleName = "Simone",
         //            LastName = "Whitley",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2012, 2, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1325,
         //            //StudentPersonId = 1325,
         //            StateStudentIdentifier = "9306681325",
         //            FirstName = "Orli",
         //            MiddleName = "Alfreda",
         //            LastName = "Becker",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 11, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1326,
         //            //StudentPersonId = 1326,
         //            StateStudentIdentifier = "5693621326",
         //            FirstName = "Gage",
         //            MiddleName = "Mia",
         //            LastName = "Lambert",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2004, 11, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1327,
         //            //StudentPersonId = 1327,
         //            StateStudentIdentifier = "9128771327",
         //            FirstName = "Ivor",
         //            MiddleName = "Joshua",
         //            LastName = "Lynn",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 2, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1328,
         //            //StudentPersonId = 1328,
         //            StateStudentIdentifier = "9939051328",
         //            FirstName = "Justin",
         //            MiddleName = "Amery",
         //            LastName = "Blanchard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 11, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1329,
         //            //StudentPersonId = 1329,
         //            StateStudentIdentifier = "8618601329",
         //            FirstName = "Caryn",
         //            MiddleName = "Forrest",
         //            LastName = "Peters",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 1, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1330,
         //            //StudentPersonId = 1330,
         //            StateStudentIdentifier = "9061941330",
         //            FirstName = "Palmer",
         //            MiddleName = "Cairo",
         //            LastName = "Vinson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 5, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1331,
         //            //StudentPersonId = 1331,
         //            StateStudentIdentifier = "3741501331",
         //            FirstName = "Jenna",
         //            MiddleName = "Rana",
         //            LastName = "Paul",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 10, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1332,
         //            //StudentPersonId = 1332,
         //            StateStudentIdentifier = "4453741332",
         //            FirstName = "Sophia",
         //            MiddleName = "Alexis",
         //            LastName = "Webster",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 3, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1333,
         //            //StudentPersonId = 1333,
         //            StateStudentIdentifier = "7409381333",
         //            FirstName = "Wynne",
         //            MiddleName = "Vance",
         //            LastName = "Pena",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 8, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1334,
         //            //StudentPersonId = 1334,
         //            StateStudentIdentifier = "4190541334",
         //            FirstName = "Dana",
         //            MiddleName = "Marny",
         //            LastName = "Faulkner",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 5, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1335,
         //            //StudentPersonId = 1335,
         //            StateStudentIdentifier = "3375271335",
         //            FirstName = "Quinlan",
         //            MiddleName = "Sean",
         //            LastName = "Mccormick",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 8, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1336,
         //            //StudentPersonId = 1336,
         //            StateStudentIdentifier = "5763321336",
         //            FirstName = "Orlando",
         //            MiddleName = "Stuart",
         //            LastName = "Bradley",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2007, 4, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1337,
         //            //StudentPersonId = 1337,
         //            StateStudentIdentifier = "8250421337",
         //            FirstName = "Hayes",
         //            MiddleName = "Seth",
         //            LastName = "Mosley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 6, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1338,
         //            //StudentPersonId = 1338,
         //            StateStudentIdentifier = "0462761338",
         //            FirstName = "Alexa",
         //            MiddleName = "Jesse",
         //            LastName = "Kline",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 7, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1339,
         //            //StudentPersonId = 1339,
         //            StateStudentIdentifier = "0863931339",
         //            FirstName = "Leila",
         //            MiddleName = "Daryl",
         //            LastName = "Compton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 6, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1340,
         //            //StudentPersonId = 1340,
         //            StateStudentIdentifier = "4887061340",
         //            FirstName = "Scarlett",
         //            MiddleName = "Joan",
         //            LastName = "Ratliff",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 8, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1341,
         //            //StudentPersonId = 1341,
         //            StateStudentIdentifier = "2411671341",
         //            FirstName = "Zenaida",
         //            MiddleName = "Mara",
         //            LastName = "Haney",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 1, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1342,
         //            //StudentPersonId = 1342,
         //            StateStudentIdentifier = "9485611342",
         //            FirstName = "Alexis",
         //            MiddleName = "Yael",
         //            LastName = "Chan",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 10, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1343,
         //            //StudentPersonId = 1343,
         //            StateStudentIdentifier = "1427581343",
         //            FirstName = "Ian",
         //            MiddleName = "Mark",
         //            LastName = "Massey",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 8, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1344,
         //            //StudentPersonId = 1344,
         //            StateStudentIdentifier = "6136961344",
         //            FirstName = "Hayfa",
         //            MiddleName = "Blair",
         //            LastName = "Franks",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1995, 9, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1345,
         //            //StudentPersonId = 1345,
         //            StateStudentIdentifier = "2264591345",
         //            FirstName = "Plato",
         //            MiddleName = "Zeus",
         //            LastName = "Case",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2015, 12, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1346,
         //            //StudentPersonId = 1346,
         //            StateStudentIdentifier = "4508421346",
         //            FirstName = "Warren",
         //            MiddleName = "Brianna",
         //            LastName = "Bender",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 5, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1347,
         //            //StudentPersonId = 1347,
         //            StateStudentIdentifier = "2016051347",
         //            FirstName = "Delilah",
         //            MiddleName = "Colleen",
         //            LastName = "Wolfe",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 12, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1348,
         //            //StudentPersonId = 1348,
         //            StateStudentIdentifier = "2843641348",
         //            FirstName = "Teegan",
         //            MiddleName = "Shaine",
         //            LastName = "Camacho",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 11, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1349,
         //            //StudentPersonId = 1349,
         //            StateStudentIdentifier = "3429701349",
         //            FirstName = "Hayfa",
         //            MiddleName = "Abra",
         //            LastName = "Greer",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2015, 10, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1350,
         //            //StudentPersonId = 1350,
         //            StateStudentIdentifier = "9772241350",
         //            FirstName = "Iris",
         //            MiddleName = "Eleanor",
         //            LastName = "Roy",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 7, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1351,
         //            //StudentPersonId = 1351,
         //            StateStudentIdentifier = "2027391351",
         //            FirstName = "Pavel",
         //            MiddleName = "Keith",
         //            LastName = "Harding",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 3, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1352,
         //            //StudentPersonId = 1352,
         //            StateStudentIdentifier = "5049321352",
         //            FirstName = "Zelenia",
         //            MiddleName = "Sharon",
         //            LastName = "Wilcox",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 6, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1353,
         //            //StudentPersonId = 1353,
         //            StateStudentIdentifier = "5783381353",
         //            FirstName = "Signe",
         //            MiddleName = "Wanda",
         //            LastName = "Warren",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 5, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1354,
         //            //StudentPersonId = 1354,
         //            StateStudentIdentifier = "2290141354",
         //            FirstName = "James",
         //            MiddleName = "Asher",
         //            LastName = "Baker",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 7, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1355,
         //            //StudentPersonId = 1355,
         //            StateStudentIdentifier = "0236811355",
         //            FirstName = "Madonna",
         //            MiddleName = "Teegan",
         //            LastName = "Ryan",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1999, 1, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1356,
         //            //StudentPersonId = 1356,
         //            StateStudentIdentifier = "4070111356",
         //            FirstName = "Keegan",
         //            MiddleName = "Murphy",
         //            LastName = "Perry",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 5, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1357,
         //            //StudentPersonId = 1357,
         //            StateStudentIdentifier = "0772611357",
         //            FirstName = "Velma",
         //            MiddleName = "Nero",
         //            LastName = "Daniels",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 10, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1358,
         //            //StudentPersonId = 1358,
         //            StateStudentIdentifier = "6600631358",
         //            FirstName = "Carlos",
         //            MiddleName = "Orla",
         //            LastName = "Franco",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 10, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1359,
         //            //StudentPersonId = 1359,
         //            StateStudentIdentifier = "5134581359",
         //            FirstName = "Nehru",
         //            MiddleName = "Rogan",
         //            LastName = "Armstrong",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 12, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1360,
         //            //StudentPersonId = 1360,
         //            StateStudentIdentifier = "1266831360",
         //            FirstName = "Quail",
         //            MiddleName = "Cameron",
         //            LastName = "Hess",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 8, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1361,
         //            //StudentPersonId = 1361,
         //            StateStudentIdentifier = "7202901361",
         //            FirstName = "Jocelyn",
         //            MiddleName = "Hector",
         //            LastName = "Finley",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 8, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1362,
         //            //StudentPersonId = 1362,
         //            StateStudentIdentifier = "0065171362",
         //            FirstName = "Adrienne",
         //            MiddleName = "Erica",
         //            LastName = "Lambert",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 12, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1363,
         //            //StudentPersonId = 1363,
         //            StateStudentIdentifier = "2433501363",
         //            FirstName = "Joshua",
         //            MiddleName = "Daniel",
         //            LastName = "Lee",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 10, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1364,
         //            //StudentPersonId = 1364,
         //            StateStudentIdentifier = "8157301364",
         //            FirstName = "Isaac",
         //            MiddleName = "Sumanth",
         //            LastName = "Osborn",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1999, 5, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1365,
         //            //StudentPersonId = 1365,
         //            StateStudentIdentifier = "0099491365",
         //            FirstName = "Stone",
         //            MiddleName = "Gary",
         //            LastName = "Soto",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 4, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1366,
         //            //StudentPersonId = 1366,
         //            StateStudentIdentifier = "4338391366",
         //            FirstName = "Idona",
         //            MiddleName = "Bianca",
         //            LastName = "Whitley",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2016, 2, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1367,
         //            //StudentPersonId = 1367,
         //            StateStudentIdentifier = "4763831367",
         //            FirstName = "Brett",
         //            MiddleName = "Griffith",
         //            LastName = "Stout",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 2, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1368,
         //            //StudentPersonId = 1368,
         //            StateStudentIdentifier = "7034511368",
         //            FirstName = "Carter",
         //            MiddleName = "Odysseus",
         //            LastName = "Dickerson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 10, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1369,
         //            //StudentPersonId = 1369,
         //            StateStudentIdentifier = "5843401369",
         //            FirstName = "Judah",
         //            MiddleName = "Abbot",
         //            LastName = "Erickson",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2014, 7, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1370,
         //            //StudentPersonId = 1370,
         //            StateStudentIdentifier = "6319231370",
         //            FirstName = "Sigourney",
         //            MiddleName = "Dana",
         //            LastName = "May",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2001, 5, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1371,
         //            //StudentPersonId = 1371,
         //            StateStudentIdentifier = "0259011371",
         //            FirstName = "Mohammad",
         //            MiddleName = "Rooney",
         //            LastName = "Castro",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2004, 10, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1372,
         //            //StudentPersonId = 1372,
         //            StateStudentIdentifier = "5345861372",
         //            FirstName = "Hadassah",
         //            MiddleName = "Lara",
         //            LastName = "Giovanitti",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 9, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1373,
         //            //StudentPersonId = 1373,
         //            StateStudentIdentifier = "0968031373",
         //            FirstName = "Carter",
         //            MiddleName = "Reed",
         //            LastName = "Stevenson",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2002, 9, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1374,
         //            //StudentPersonId = 1374,
         //            StateStudentIdentifier = "6123651374",
         //            FirstName = "Lane",
         //            MiddleName = "Curran",
         //            LastName = "Peters",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2004, 12, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1375,
         //            //StudentPersonId = 1375,
         //            StateStudentIdentifier = "3012421375",
         //            FirstName = "Curran",
         //            MiddleName = "Fuller",
         //            LastName = "Fry",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 6, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1376,
         //            //StudentPersonId = 1376,
         //            StateStudentIdentifier = "5255861376",
         //            FirstName = "Allistair",
         //            MiddleName = "Cadman",
         //            LastName = "Stevens",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(1996, 10, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1377,
         //            //StudentPersonId = 1377,
         //            StateStudentIdentifier = "1389071377",
         //            FirstName = "Anne",
         //            MiddleName = "Jennifer",
         //            LastName = "Bradley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 11, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1378,
         //            //StudentPersonId = 1378,
         //            StateStudentIdentifier = "1576011378",
         //            FirstName = "Patricia",
         //            MiddleName = "Tamekah",
         //            LastName = "Salinas",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 1, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1379,
         //            //StudentPersonId = 1379,
         //            StateStudentIdentifier = "1727681379",
         //            FirstName = "Lynn",
         //            MiddleName = "Hyacinth",
         //            LastName = "Hubbard",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1998, 8, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1380,
         //            //StudentPersonId = 1380,
         //            StateStudentIdentifier = "7992701380",
         //            FirstName = "Dora",
         //            MiddleName = "Nolan",
         //            LastName = "Herrera",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 10, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1381,
         //            //StudentPersonId = 1381,
         //            StateStudentIdentifier = "1855591381",
         //            FirstName = "Yardley",
         //            MiddleName = "Nathaniel",
         //            LastName = "Dudley",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 7, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1382,
         //            //StudentPersonId = 1382,
         //            StateStudentIdentifier = "6047871382",
         //            FirstName = "Amela",
         //            MiddleName = "Gwendolyn",
         //            LastName = "Hendrix",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 1, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1383,
         //            //StudentPersonId = 1383,
         //            StateStudentIdentifier = "0073131383",
         //            FirstName = "Graham",
         //            MiddleName = "Josiah",
         //            LastName = "Watts",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 1, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1384,
         //            //StudentPersonId = 1384,
         //            StateStudentIdentifier = "5260731384",
         //            FirstName = "Paula",
         //            MiddleName = "Patience",
         //            LastName = "Shelton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 11, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1385,
         //            //StudentPersonId = 1385,
         //            StateStudentIdentifier = "6270801385",
         //            FirstName = "Randall",
         //            MiddleName = "Simon",
         //            LastName = "Estes",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 7, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1386,
         //            //StudentPersonId = 1386,
         //            StateStudentIdentifier = "8340141386",
         //            FirstName = "Brent",
         //            MiddleName = "Daquan",
         //            LastName = "Potts",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 4, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1387,
         //            //StudentPersonId = 1387,
         //            StateStudentIdentifier = "8083481387",
         //            FirstName = "Kennedy",
         //            MiddleName = "Hyatt",
         //            LastName = "Salinas",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 3, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1388,
         //            //StudentPersonId = 1388,
         //            StateStudentIdentifier = "5265021388",
         //            FirstName = "Sierra",
         //            MiddleName = "Molly",
         //            LastName = "Heath",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 2, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1389,
         //            //StudentPersonId = 1389,
         //            StateStudentIdentifier = "6550571389",
         //            FirstName = "Jordan",
         //            MiddleName = "Dominic",
         //            LastName = "Deleon",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2003, 4, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1390,
         //            //StudentPersonId = 1390,
         //            StateStudentIdentifier = "6484041390",
         //            FirstName = "Barclay",
         //            MiddleName = "Timothy",
         //            LastName = "Ingram",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 5, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1391,
         //            //StudentPersonId = 1391,
         //            StateStudentIdentifier = "2421781391",
         //            FirstName = "Rogan",
         //            MiddleName = "Howard",
         //            LastName = "Head",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2012, 5, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1392,
         //            //StudentPersonId = 1392,
         //            StateStudentIdentifier = "1444231392",
         //            FirstName = "Ciaran",
         //            MiddleName = "Dorian",
         //            LastName = "Fletcher",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 11, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1393,
         //            //StudentPersonId = 1393,
         //            StateStudentIdentifier = "6130231393",
         //            FirstName = "Cassidy",
         //            MiddleName = "Christen",
         //            LastName = "Walsh",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 8, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1394,
         //            //StudentPersonId = 1394,
         //            StateStudentIdentifier = "5967831394",
         //            FirstName = "Quyn",
         //            MiddleName = "Quintessa",
         //            LastName = "Blackburn",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 11, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1395,
         //            //StudentPersonId = 1395,
         //            StateStudentIdentifier = "8378651395",
         //            FirstName = "Zane",
         //            MiddleName = "Adam",
         //            LastName = "Rosales",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 2, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1396,
         //            //StudentPersonId = 1396,
         //            StateStudentIdentifier = "3648621396",
         //            FirstName = "Elmo",
         //            MiddleName = "Hakeem",
         //            LastName = "Morrison",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2016, 6, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1397,
         //            //StudentPersonId = 1397,
         //            StateStudentIdentifier = "8228231397",
         //            FirstName = "Rina",
         //            MiddleName = "Alfreda",
         //            LastName = "Huff",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 6, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1398,
         //            //StudentPersonId = 1398,
         //            StateStudentIdentifier = "8998851398",
         //            FirstName = "Nina",
         //            MiddleName = "Melyssa",
         //            LastName = "Camacho",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 12, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1399,
         //            //StudentPersonId = 1399,
         //            StateStudentIdentifier = "8916881399",
         //            FirstName = "Beverly",
         //            MiddleName = "Anne",
         //            LastName = "Gentry",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 1, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1400,
         //            //StudentPersonId = 1400,
         //            StateStudentIdentifier = "9146481400",
         //            FirstName = "MacKensie",
         //            MiddleName = "Meredith",
         //            LastName = "Obrien",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 9, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1401,
         //            //StudentPersonId = 1401,
         //            StateStudentIdentifier = "5102101401",
         //            FirstName = "Ima",
         //            MiddleName = "Hunter",
         //            LastName = "Richardson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 7, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1402,
         //            //StudentPersonId = 1402,
         //            StateStudentIdentifier = "3988021402",
         //            FirstName = "Aphrodite",
         //            MiddleName = "Mechelle",
         //            LastName = "Griffin",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 10, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1403,
         //            //StudentPersonId = 1403,
         //            StateStudentIdentifier = "2942411403",
         //            FirstName = "Casey",
         //            MiddleName = "Madeline",
         //            LastName = "Soto",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 4, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1404,
         //            //StudentPersonId = 1404,
         //            StateStudentIdentifier = "2607461404",
         //            FirstName = "Emerald",
         //            MiddleName = "Nelle",
         //            LastName = "Odonnell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 9, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1405,
         //            //StudentPersonId = 1405,
         //            StateStudentIdentifier = "0092841405",
         //            FirstName = "Lenore",
         //            MiddleName = "Roanna",
         //            LastName = "Eaton",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2016, 11, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1406,
         //            //StudentPersonId = 1406,
         //            StateStudentIdentifier = "1369691406",
         //            FirstName = "Aristotle",
         //            MiddleName = "Chandler",
         //            LastName = "Bowman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 4, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1407,
         //            //StudentPersonId = 1407,
         //            StateStudentIdentifier = "3284841407",
         //            FirstName = "Hoyt",
         //            MiddleName = "Dolan",
         //            LastName = "Hansen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 7, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1408,
         //            //StudentPersonId = 1408,
         //            StateStudentIdentifier = "7184301408",
         //            FirstName = "Blaine",
         //            MiddleName = "Alfreda",
         //            LastName = "Graham",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2001, 3, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1409,
         //            //StudentPersonId = 1409,
         //            StateStudentIdentifier = "1160891409",
         //            FirstName = "Sebastian",
         //            MiddleName = "Kenyon",
         //            LastName = "Blackburn",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1998, 11, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1410,
         //            //StudentPersonId = 1410,
         //            StateStudentIdentifier = "2514641410",
         //            FirstName = "Latifah",
         //            MiddleName = "Leilani",
         //            LastName = "Erickson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 6, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1411,
         //            //StudentPersonId = 1411,
         //            StateStudentIdentifier = "9445921411",
         //            FirstName = "Velma",
         //            MiddleName = "Miranda",
         //            LastName = "Barrett",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1997, 9, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1412,
         //            //StudentPersonId = 1412,
         //            StateStudentIdentifier = "1332681412",
         //            FirstName = "Fritz",
         //            MiddleName = "Erich",
         //            LastName = "Strickland",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2018, 10, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1413,
         //            //StudentPersonId = 1413,
         //            StateStudentIdentifier = "4512031413",
         //            FirstName = "Emma",
         //            MiddleName = "Dara",
         //            LastName = "Lyons",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 5, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1414,
         //            //StudentPersonId = 1414,
         //            StateStudentIdentifier = "4797911414",
         //            FirstName = "Blair",
         //            MiddleName = "Katell",
         //            LastName = "Conrad",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 3, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1415,
         //            //StudentPersonId = 1415,
         //            StateStudentIdentifier = "6020701415",
         //            FirstName = "Cally",
         //            MiddleName = "Georgia",
         //            LastName = "Conway",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1997, 6, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1416,
         //            //StudentPersonId = 1416,
         //            StateStudentIdentifier = "0863221416",
         //            FirstName = "Camille",
         //            MiddleName = "Upasana",
         //            LastName = "Peters",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 4, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1417,
         //            //StudentPersonId = 1417,
         //            StateStudentIdentifier = "3571711417",
         //            FirstName = "Yuli",
         //            MiddleName = "Inga",
         //            LastName = "Bullock",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 9, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1418,
         //            //StudentPersonId = 1418,
         //            StateStudentIdentifier = "3664891418",
         //            FirstName = "Steel",
         //            MiddleName = "Burton",
         //            LastName = "Wise",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 11, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1419,
         //            //StudentPersonId = 1419,
         //            StateStudentIdentifier = "8008631419",
         //            FirstName = "Brielle",
         //            MiddleName = "Ella",
         //            LastName = "Gutierrez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 8, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1420,
         //            //StudentPersonId = 1420,
         //            StateStudentIdentifier = "1110761420",
         //            FirstName = "Lillian",
         //            MiddleName = "Geoffrey",
         //            LastName = "Noel",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2012, 12, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1421,
         //            //StudentPersonId = 1421,
         //            StateStudentIdentifier = "7834181421",
         //            FirstName = "Justin",
         //            MiddleName = "Kennedy",
         //            LastName = "Burns",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 11, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1422,
         //            //StudentPersonId = 1422,
         //            StateStudentIdentifier = "5980061422",
         //            FirstName = "Kermit",
         //            MiddleName = "Burton",
         //            LastName = "Norris",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2008, 11, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1423,
         //            //StudentPersonId = 1423,
         //            StateStudentIdentifier = "3431101423",
         //            FirstName = "Halee",
         //            MiddleName = "Dominic",
         //            LastName = "Atkinson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 5, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1424,
         //            //StudentPersonId = 1424,
         //            StateStudentIdentifier = "7817571424",
         //            FirstName = "Selma",
         //            MiddleName = "Jolene",
         //            LastName = "Booth",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2018, 7, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1425,
         //            //StudentPersonId = 1425,
         //            StateStudentIdentifier = "3148501425",
         //            FirstName = "Drew",
         //            MiddleName = "Beck",
         //            LastName = "Duran",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 10, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1426,
         //            //StudentPersonId = 1426,
         //            StateStudentIdentifier = "5499671426",
         //            FirstName = "Beau",
         //            MiddleName = "Kevin",
         //            LastName = "Lopez",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 9, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1427,
         //            //StudentPersonId = 1427,
         //            StateStudentIdentifier = "6077841427",
         //            FirstName = "Megan",
         //            MiddleName = "Risa",
         //            LastName = "Lambert",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 11, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1428,
         //            //StudentPersonId = 1428,
         //            StateStudentIdentifier = "5874061428",
         //            FirstName = "Malcolm",
         //            MiddleName = "Mannix",
         //            LastName = "Macdonald",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 8, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1429,
         //            //StudentPersonId = 1429,
         //            StateStudentIdentifier = "3827751429",
         //            FirstName = "Nomlanga",
         //            MiddleName = "Paloma",
         //            LastName = "Dean",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 5, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1430,
         //            //StudentPersonId = 1430,
         //            StateStudentIdentifier = "1455611430",
         //            FirstName = "Jonas",
         //            MiddleName = "Henry",
         //            LastName = "Klein",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 3, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1431,
         //            //StudentPersonId = 1431,
         //            StateStudentIdentifier = "4860011431",
         //            FirstName = "Lyle",
         //            MiddleName = "Joel",
         //            LastName = "Holloway",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 5, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1432,
         //            //StudentPersonId = 1432,
         //            StateStudentIdentifier = "2563881432",
         //            FirstName = "Walter",
         //            MiddleName = "Cruz",
         //            LastName = "Valencia",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 12, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1433,
         //            //StudentPersonId = 1433,
         //            StateStudentIdentifier = "8545581433",
         //            FirstName = "Carissa",
         //            MiddleName = "Whoopi",
         //            LastName = "Cross",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 7, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1434,
         //            //StudentPersonId = 1434,
         //            StateStudentIdentifier = "8456321434",
         //            FirstName = "Venus",
         //            MiddleName = "Allen",
         //            LastName = "Wagner",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 5, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1435,
         //            //StudentPersonId = 1435,
         //            StateStudentIdentifier = "8021501435",
         //            FirstName = "Fallon",
         //            MiddleName = "Katelyn",
         //            LastName = "Howard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 8, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1436,
         //            //StudentPersonId = 1436,
         //            StateStudentIdentifier = "7427411436",
         //            FirstName = "Kyla",
         //            MiddleName = "MacKensie",
         //            LastName = "Davidson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 6, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1437,
         //            //StudentPersonId = 1437,
         //            StateStudentIdentifier = "9845081437",
         //            FirstName = "Craig",
         //            MiddleName = "Gray",
         //            LastName = "Powers",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 8, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1438,
         //            //StudentPersonId = 1438,
         //            StateStudentIdentifier = "7419451438",
         //            FirstName = "Kelly",
         //            MiddleName = "Kellie",
         //            LastName = "Griffin",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 3, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1439,
         //            //StudentPersonId = 1439,
         //            StateStudentIdentifier = "7642401439",
         //            FirstName = "Flavia",
         //            MiddleName = "Megan",
         //            LastName = "Haney",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 12, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1440,
         //            //StudentPersonId = 1440,
         //            StateStudentIdentifier = "9036951440",
         //            FirstName = "Colette",
         //            MiddleName = "Cassady",
         //            LastName = "Sparks",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2009, 9, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1441,
         //            //StudentPersonId = 1441,
         //            StateStudentIdentifier = "6171641441",
         //            FirstName = "Justine",
         //            MiddleName = "Michelle",
         //            LastName = "Bailey",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 8, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1442,
         //            //StudentPersonId = 1442,
         //            StateStudentIdentifier = "1355331442",
         //            FirstName = "Karyn",
         //            MiddleName = "Imelda",
         //            LastName = "Mckay",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 4, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1443,
         //            //StudentPersonId = 1443,
         //            StateStudentIdentifier = "9092251443",
         //            FirstName = "Xaviera",
         //            MiddleName = "Moana",
         //            LastName = "Good",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 1, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1444,
         //            //StudentPersonId = 1444,
         //            StateStudentIdentifier = "9774061444",
         //            FirstName = "Honorato",
         //            MiddleName = "Keith",
         //            LastName = "Mooney",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2000, 8, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1445,
         //            //StudentPersonId = 1445,
         //            StateStudentIdentifier = "8992981445",
         //            FirstName = "Tate",
         //            MiddleName = "Plato",
         //            LastName = "Fox",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2014, 2, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1446,
         //            //StudentPersonId = 1446,
         //            StateStudentIdentifier = "2003691446",
         //            FirstName = "Stewart",
         //            MiddleName = "John",
         //            LastName = "Stevens",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 5, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1447,
         //            //StudentPersonId = 1447,
         //            StateStudentIdentifier = "1069281447",
         //            FirstName = "Wing",
         //            MiddleName = "Leo",
         //            LastName = "Heath",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 12, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1448,
         //            //StudentPersonId = 1448,
         //            StateStudentIdentifier = "7624501448",
         //            FirstName = "Erich",
         //            MiddleName = "Lisandra",
         //            LastName = "Dale",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 1, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1449,
         //            //StudentPersonId = 1449,
         //            StateStudentIdentifier = "8468651449",
         //            FirstName = "Amber",
         //            MiddleName = "Cherokee",
         //            LastName = "Mayer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 6, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1450,
         //            //StudentPersonId = 1450,
         //            StateStudentIdentifier = "2626771450",
         //            FirstName = "Carter",
         //            MiddleName = "Otto",
         //            LastName = "Daniel",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 10, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1451,
         //            //StudentPersonId = 1451,
         //            StateStudentIdentifier = "6479161451",
         //            FirstName = "Damon",
         //            MiddleName = "Salvador",
         //            LastName = "Wooten",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2015, 4, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1452,
         //            //StudentPersonId = 1452,
         //            StateStudentIdentifier = "1491581452",
         //            FirstName = "Timothy",
         //            MiddleName = "Jermaine",
         //            LastName = "Moody",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 11, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1453,
         //            //StudentPersonId = 1453,
         //            StateStudentIdentifier = "3202701453",
         //            FirstName = "Regan",
         //            MiddleName = "Nichole",
         //            LastName = "Greer",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1997, 7, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1454,
         //            //StudentPersonId = 1454,
         //            StateStudentIdentifier = "5634371454",
         //            FirstName = "Clarke",
         //            MiddleName = "Phoebe",
         //            LastName = "Waters",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2007, 5, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1455,
         //            //StudentPersonId = 1455,
         //            StateStudentIdentifier = "3236011455",
         //            FirstName = "Prescott",
         //            MiddleName = "Forrest",
         //            LastName = "Patrick",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2018, 4, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1456,
         //            //StudentPersonId = 1456,
         //            StateStudentIdentifier = "0388901456",
         //            FirstName = "Wylie",
         //            MiddleName = "Alvin",
         //            LastName = "Mathews",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 10, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1457,
         //            //StudentPersonId = 1457,
         //            StateStudentIdentifier = "6266951457",
         //            FirstName = "Garrison",
         //            MiddleName = "Russell",
         //            LastName = "Lopez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 11, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1458,
         //            //StudentPersonId = 1458,
         //            StateStudentIdentifier = "6266151458",
         //            FirstName = "Kane",
         //            MiddleName = "Zorita",
         //            LastName = "Briggs",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 4, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1459,
         //            //StudentPersonId = 1459,
         //            StateStudentIdentifier = "8455751459",
         //            FirstName = "Maxwell",
         //            MiddleName = "George",
         //            LastName = "Tran",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 1, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1460,
         //            //StudentPersonId = 1460,
         //            StateStudentIdentifier = "6600321460",
         //            FirstName = "Lani",
         //            MiddleName = "Nelle",
         //            LastName = "Franks",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 12, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1461,
         //            //StudentPersonId = 1461,
         //            StateStudentIdentifier = "3962811461",
         //            FirstName = "Ivana",
         //            MiddleName = "Ciaran",
         //            LastName = "Hunter",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2007, 5, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1462,
         //            //StudentPersonId = 1462,
         //            StateStudentIdentifier = "8841361462",
         //            FirstName = "Callum",
         //            MiddleName = "Wing",
         //            LastName = "Hardy",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2000, 12, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1463,
         //            //StudentPersonId = 1463,
         //            StateStudentIdentifier = "3291811463",
         //            FirstName = "Evangeline",
         //            MiddleName = "Rebecca",
         //            LastName = "Wright",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 10, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1464,
         //            //StudentPersonId = 1464,
         //            StateStudentIdentifier = "1590141464",
         //            FirstName = "Reece",
         //            MiddleName = "Kato",
         //            LastName = "Greer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 2, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1465,
         //            //StudentPersonId = 1465,
         //            StateStudentIdentifier = "3973741465",
         //            FirstName = "Charlotte",
         //            MiddleName = "Renee",
         //            LastName = "Sellers",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 6, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1466,
         //            //StudentPersonId = 1466,
         //            StateStudentIdentifier = "1096661466",
         //            FirstName = "Bobby",
         //            MiddleName = "Kato",
         //            LastName = "Vega",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 7, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1467,
         //            //StudentPersonId = 1467,
         //            StateStudentIdentifier = "4376741467",
         //            FirstName = "Justina",
         //            MiddleName = "Calvin",
         //            LastName = "Craig",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 5, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1468,
         //            //StudentPersonId = 1468,
         //            StateStudentIdentifier = "6593861468",
         //            FirstName = "Ronan",
         //            MiddleName = "Palmer",
         //            LastName = "Shaw",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2000, 10, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1469,
         //            //StudentPersonId = 1469,
         //            StateStudentIdentifier = "4839891469",
         //            FirstName = "Merrill",
         //            MiddleName = "Tucker",
         //            LastName = "Mack",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2010, 1, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1470,
         //            //StudentPersonId = 1470,
         //            StateStudentIdentifier = "4423911470",
         //            FirstName = "Alexandra",
         //            MiddleName = "Aspen",
         //            LastName = "Dickson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 5, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1471,
         //            //StudentPersonId = 1471,
         //            StateStudentIdentifier = "2965851471",
         //            FirstName = "Chantale",
         //            MiddleName = "Fiona",
         //            LastName = "Savage",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 9, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1472,
         //            //StudentPersonId = 1472,
         //            StateStudentIdentifier = "4828091472",
         //            FirstName = "Carlos",
         //            MiddleName = "Calvin",
         //            LastName = "Roy",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2001, 4, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1473,
         //            //StudentPersonId = 1473,
         //            StateStudentIdentifier = "5010271473",
         //            FirstName = "Noah",
         //            MiddleName = "Chandler",
         //            LastName = "Reyes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 7, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1474,
         //            //StudentPersonId = 1474,
         //            StateStudentIdentifier = "2298881474",
         //            FirstName = "Griffin",
         //            MiddleName = "Macy",
         //            LastName = "Rojas",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 12, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1475,
         //            //StudentPersonId = 1475,
         //            StateStudentIdentifier = "4315191475",
         //            FirstName = "Quin",
         //            MiddleName = "Clementine",
         //            LastName = "Mckee",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 8, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1476,
         //            //StudentPersonId = 1476,
         //            StateStudentIdentifier = "5392151476",
         //            FirstName = "Mona",
         //            MiddleName = "Bianca",
         //            LastName = "Vinson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2020, 1, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1477,
         //            //StudentPersonId = 1477,
         //            StateStudentIdentifier = "3186851477",
         //            FirstName = "Ezekiel",
         //            MiddleName = "Vivian",
         //            LastName = "Burns",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 10, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1478,
         //            //StudentPersonId = 1478,
         //            StateStudentIdentifier = "1823461478",
         //            FirstName = "Myra",
         //            MiddleName = "Sopoline",
         //            LastName = "Short",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 4, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1479,
         //            //StudentPersonId = 1479,
         //            StateStudentIdentifier = "9280291479",
         //            FirstName = "Tanek",
         //            MiddleName = "Melvin",
         //            LastName = "Nunez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 2, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1480,
         //            //StudentPersonId = 1480,
         //            StateStudentIdentifier = "6229901480",
         //            FirstName = "Yvonne",
         //            MiddleName = "Aretha",
         //            LastName = "Langley",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 9, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1481,
         //            //StudentPersonId = 1481,
         //            StateStudentIdentifier = "9281221481",
         //            FirstName = "Jamalia",
         //            MiddleName = "Martena",
         //            LastName = "Watson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 10, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1482,
         //            //StudentPersonId = 1482,
         //            StateStudentIdentifier = "0213291482",
         //            FirstName = "Allistair",
         //            MiddleName = "Cade",
         //            LastName = "Valentine",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2007, 8, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1483,
         //            //StudentPersonId = 1483,
         //            StateStudentIdentifier = "7297561483",
         //            FirstName = "Tiger",
         //            MiddleName = "Mannix",
         //            LastName = "Potter",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 12, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1484,
         //            //StudentPersonId = 1484,
         //            StateStudentIdentifier = "7520591484",
         //            FirstName = "Sheila",
         //            MiddleName = "Demetria",
         //            LastName = "Cameron",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 2, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1485,
         //            //StudentPersonId = 1485,
         //            StateStudentIdentifier = "9288601485",
         //            FirstName = "Ramona",
         //            MiddleName = "Belle",
         //            LastName = "Marquez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 5, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1486,
         //            //StudentPersonId = 1486,
         //            StateStudentIdentifier = "7735531486",
         //            FirstName = "Aladdin",
         //            MiddleName = "Abdul",
         //            LastName = "Cabrera",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 5, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1487,
         //            //StudentPersonId = 1487,
         //            StateStudentIdentifier = "4732341487",
         //            FirstName = "Jasmin",
         //            MiddleName = "Kyla",
         //            LastName = "Peterson",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2011, 2, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1488,
         //            //StudentPersonId = 1488,
         //            StateStudentIdentifier = "1658551488",
         //            FirstName = "Beatrice",
         //            MiddleName = "Meghan",
         //            LastName = "Baker",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 11, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1489,
         //            //StudentPersonId = 1489,
         //            StateStudentIdentifier = "7173821489",
         //            FirstName = "Madonna",
         //            MiddleName = "Zena",
         //            LastName = "Jenkins",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 12, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1490,
         //            //StudentPersonId = 1490,
         //            StateStudentIdentifier = "7184141490",
         //            FirstName = "Murphy",
         //            MiddleName = "Nasim",
         //            LastName = "Marquez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 6, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1491,
         //            //StudentPersonId = 1491,
         //            StateStudentIdentifier = "4869031491",
         //            FirstName = "Galena",
         //            MiddleName = "Nina",
         //            LastName = "Burch",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2006, 3, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1492,
         //            //StudentPersonId = 1492,
         //            StateStudentIdentifier = "6405691492",
         //            FirstName = "Mike",
         //            MiddleName = "Griffith",
         //            LastName = "Garrett",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 3, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1493,
         //            //StudentPersonId = 1493,
         //            StateStudentIdentifier = "3561541493",
         //            FirstName = "Fitzgerald",
         //            MiddleName = "Jacob",
         //            LastName = "Schroeder",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2015, 1, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1494,
         //            //StudentPersonId = 1494,
         //            StateStudentIdentifier = "5465421494",
         //            FirstName = "Dylan",
         //            MiddleName = "Uriel",
         //            LastName = "Tillman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 1, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1495,
         //            //StudentPersonId = 1495,
         //            StateStudentIdentifier = "1787201495",
         //            FirstName = "Zachery",
         //            MiddleName = "Damon",
         //            LastName = "Fernandez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 9, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1496,
         //            //StudentPersonId = 1496,
         //            StateStudentIdentifier = "8956941496",
         //            FirstName = "Tucker",
         //            MiddleName = "Tyrone",
         //            LastName = "Ryan",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 5, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1497,
         //            //StudentPersonId = 1497,
         //            StateStudentIdentifier = "6190891497",
         //            FirstName = "Ramona",
         //            MiddleName = "Tasha",
         //            LastName = "Reyes",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 1, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1498,
         //            //StudentPersonId = 1498,
         //            StateStudentIdentifier = "0724091498",
         //            FirstName = "Quamar",
         //            MiddleName = "Buckminster",
         //            LastName = "Britt",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2000, 1, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1499,
         //            //StudentPersonId = 1499,
         //            StateStudentIdentifier = "8032621499",
         //            FirstName = "Melodie",
         //            MiddleName = "Olivia",
         //            LastName = "Hansen",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2001, 10, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1500,
         //            //StudentPersonId = 1500,
         //            StateStudentIdentifier = "6907091500",
         //            FirstName = "Abdul",
         //            MiddleName = "Erasmus",
         //            LastName = "Boyle",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 7, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1501,
         //            //StudentPersonId = 1501,
         //            StateStudentIdentifier = "7261381501",
         //            FirstName = "Miriam",
         //            MiddleName = "Justine",
         //            LastName = "Roberts",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 3, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1502,
         //            //StudentPersonId = 1502,
         //            StateStudentIdentifier = "6277071502",
         //            FirstName = "Pearl",
         //            MiddleName = "Quon",
         //            LastName = "Bean",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 4, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1503,
         //            //StudentPersonId = 1503,
         //            StateStudentIdentifier = "5390921503",
         //            FirstName = "Tatyana",
         //            MiddleName = "Clio",
         //            LastName = "Foster",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 10, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1504,
         //            //StudentPersonId = 1504,
         //            StateStudentIdentifier = "2853991504",
         //            FirstName = "Daniel",
         //            MiddleName = "Barrett",
         //            LastName = "Stuart",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 6, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1505,
         //            //StudentPersonId = 1505,
         //            StateStudentIdentifier = "1216441505",
         //            FirstName = "Aphrodite",
         //            MiddleName = "Jescie",
         //            LastName = "Banks",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 6, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1506,
         //            //StudentPersonId = 1506,
         //            StateStudentIdentifier = "8473891506",
         //            FirstName = "Sage",
         //            MiddleName = "Kellie",
         //            LastName = "Burch",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 8, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1507,
         //            //StudentPersonId = 1507,
         //            StateStudentIdentifier = "9228081507",
         //            FirstName = "Cruz",
         //            MiddleName = "Barclay",
         //            LastName = "Snider",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2013, 4, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1508,
         //            //StudentPersonId = 1508,
         //            StateStudentIdentifier = "9004661508",
         //            FirstName = "Lev",
         //            MiddleName = "Ginger",
         //            LastName = "Byrd",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 3, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1509,
         //            //StudentPersonId = 1509,
         //            StateStudentIdentifier = "0201621509",
         //            FirstName = "Colby",
         //            MiddleName = "Edan",
         //            LastName = "Hebert",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 8, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1510,
         //            //StudentPersonId = 1510,
         //            StateStudentIdentifier = "2574871510",
         //            FirstName = "Jakeem",
         //            MiddleName = "Enrique",
         //            LastName = "Bass",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(1996, 1, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1511,
         //            //StudentPersonId = 1511,
         //            StateStudentIdentifier = "9564141511",
         //            FirstName = "Jillian",
         //            MiddleName = "Lacota",
         //            LastName = "Cooke",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2004, 11, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1512,
         //            //StudentPersonId = 1512,
         //            StateStudentIdentifier = "4979501512",
         //            FirstName = "Nadine",
         //            MiddleName = "Guinevere",
         //            LastName = "Griffith",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2015, 9, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1513,
         //            //StudentPersonId = 1513,
         //            StateStudentIdentifier = "4224411513",
         //            FirstName = "Henry",
         //            MiddleName = "Elvis",
         //            LastName = "Delaney",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2017, 2, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1514,
         //            //StudentPersonId = 1514,
         //            StateStudentIdentifier = "8019941514",
         //            FirstName = "Echo",
         //            MiddleName = "Delilah",
         //            LastName = "Vance",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 8, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1515,
         //            //StudentPersonId = 1515,
         //            StateStudentIdentifier = "0853451515",
         //            FirstName = "Dana",
         //            MiddleName = "Yoko",
         //            LastName = "Melendez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 4, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1516,
         //            //StudentPersonId = 1516,
         //            StateStudentIdentifier = "5301591516",
         //            FirstName = "Cara",
         //            MiddleName = "Morgan",
         //            LastName = "Fox",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1996, 11, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1517,
         //            //StudentPersonId = 1517,
         //            StateStudentIdentifier = "0672851517",
         //            FirstName = "McKenzie",
         //            MiddleName = "Suki",
         //            LastName = "Stuart",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 7, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1518,
         //            //StudentPersonId = 1518,
         //            StateStudentIdentifier = "6004921518",
         //            FirstName = "Walker",
         //            MiddleName = "Selma",
         //            LastName = "Carney",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2020, 1, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1519,
         //            //StudentPersonId = 1519,
         //            StateStudentIdentifier = "8279731519",
         //            FirstName = "Irma",
         //            MiddleName = "Eugenia",
         //            LastName = "Pittman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 11, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1520,
         //            //StudentPersonId = 1520,
         //            StateStudentIdentifier = "2982061520",
         //            FirstName = "Ayanna",
         //            MiddleName = "Charles",
         //            LastName = "Hess",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 7, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1521,
         //            //StudentPersonId = 1521,
         //            StateStudentIdentifier = "8401111521",
         //            FirstName = "Dahlia",
         //            MiddleName = "Halee",
         //            LastName = "Cohen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 11, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1522,
         //            //StudentPersonId = 1522,
         //            StateStudentIdentifier = "6809091522",
         //            FirstName = "Jasmin",
         //            MiddleName = "Colton",
         //            LastName = "Arnold",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 11, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1523,
         //            //StudentPersonId = 1523,
         //            StateStudentIdentifier = "3618581523",
         //            FirstName = "Salvador",
         //            MiddleName = "Mohammad",
         //            LastName = "Michael",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2007, 9, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1524,
         //            //StudentPersonId = 1524,
         //            StateStudentIdentifier = "4317861524",
         //            FirstName = "Enrique",
         //            MiddleName = "Rhoda",
         //            LastName = "Erickson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 11, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1525,
         //            //StudentPersonId = 1525,
         //            StateStudentIdentifier = "0239801525",
         //            FirstName = "Aretha",
         //            MiddleName = "Hyacinth",
         //            LastName = "Hendrix",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2013, 3, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1526,
         //            //StudentPersonId = 1526,
         //            StateStudentIdentifier = "1689561526",
         //            FirstName = "Hector",
         //            MiddleName = "Nolan",
         //            LastName = "Pate",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 4, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1527,
         //            //StudentPersonId = 1527,
         //            StateStudentIdentifier = "4476811527",
         //            FirstName = "Cheryl",
         //            MiddleName = "Fiona",
         //            LastName = "Weaver",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2011, 12, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1528,
         //            //StudentPersonId = 1528,
         //            StateStudentIdentifier = "8754161528",
         //            FirstName = "Keely",
         //            MiddleName = "Illiana",
         //            LastName = "Mendez",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 11, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1529,
         //            //StudentPersonId = 1529,
         //            StateStudentIdentifier = "9929591529",
         //            FirstName = "Alec",
         //            MiddleName = "Hayes",
         //            LastName = "Holloway",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 1, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1530,
         //            //StudentPersonId = 1530,
         //            StateStudentIdentifier = "6921821530",
         //            FirstName = "Beck",
         //            MiddleName = "Graham",
         //            LastName = "Robinson",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2006, 2, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1531,
         //            //StudentPersonId = 1531,
         //            StateStudentIdentifier = "5340751531",
         //            FirstName = "Winter",
         //            MiddleName = "Tatyana",
         //            LastName = "Best",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2003, 8, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1532,
         //            //StudentPersonId = 1532,
         //            StateStudentIdentifier = "2096191532",
         //            FirstName = "Robert",
         //            MiddleName = "Fritz",
         //            LastName = "Potter",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2006, 1, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1533,
         //            //StudentPersonId = 1533,
         //            StateStudentIdentifier = "0282481533",
         //            FirstName = "Barrett",
         //            MiddleName = "Debra",
         //            LastName = "Gonzales",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 3, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1534,
         //            //StudentPersonId = 1534,
         //            StateStudentIdentifier = "1394921534",
         //            FirstName = "Fallon",
         //            MiddleName = "Nomlanga",
         //            LastName = "Hoover",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 2, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1535,
         //            //StudentPersonId = 1535,
         //            StateStudentIdentifier = "2094581535",
         //            FirstName = "Mikayla",
         //            MiddleName = "Julie",
         //            LastName = "Gallagher",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 7, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1536,
         //            //StudentPersonId = 1536,
         //            StateStudentIdentifier = "1805221536",
         //            FirstName = "Kaseem",
         //            MiddleName = "Garrison",
         //            LastName = "Hinton",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2009, 5, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1537,
         //            //StudentPersonId = 1537,
         //            StateStudentIdentifier = "8997711537",
         //            FirstName = "Indigo",
         //            MiddleName = "Alexandra",
         //            LastName = "Nash",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1998, 4, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1538,
         //            //StudentPersonId = 1538,
         //            StateStudentIdentifier = "6937181538",
         //            FirstName = "Madaline",
         //            MiddleName = "Zenaida",
         //            LastName = "Maynard",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2010, 9, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1539,
         //            //StudentPersonId = 1539,
         //            StateStudentIdentifier = "1334191539",
         //            FirstName = "Brian",
         //            MiddleName = "Drew",
         //            LastName = "Sykes",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 2, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1540,
         //            //StudentPersonId = 1540,
         //            StateStudentIdentifier = "3353581540",
         //            FirstName = "Emily",
         //            MiddleName = "Willow",
         //            LastName = "Montgomery",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1999, 12, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1541,
         //            //StudentPersonId = 1541,
         //            StateStudentIdentifier = "1239401541",
         //            FirstName = "Kennedy",
         //            MiddleName = "Hedy",
         //            LastName = "Whitfield",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2005, 8, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1542,
         //            //StudentPersonId = 1542,
         //            StateStudentIdentifier = "8568351542",
         //            FirstName = "Jerome",
         //            MiddleName = "Jonah",
         //            LastName = "Ferguson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 4, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1543,
         //            //StudentPersonId = 1543,
         //            StateStudentIdentifier = "7328581543",
         //            FirstName = "Ana",
         //            MiddleName = "Gretchen",
         //            LastName = "Dawson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 1, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1544,
         //            //StudentPersonId = 1544,
         //            StateStudentIdentifier = "2285841544",
         //            FirstName = "Dieter",
         //            MiddleName = "Levi",
         //            LastName = "Romero",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2001, 3, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1545,
         //            //StudentPersonId = 1545,
         //            StateStudentIdentifier = "6311871545",
         //            FirstName = "Bianca",
         //            MiddleName = "Inga",
         //            LastName = "Blanchard",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 4, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1546,
         //            //StudentPersonId = 1546,
         //            StateStudentIdentifier = "1455611546",
         //            FirstName = "Dane",
         //            MiddleName = "Carson",
         //            LastName = "Warren",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 5, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1547,
         //            //StudentPersonId = 1547,
         //            StateStudentIdentifier = "2879631547",
         //            FirstName = "Cruz",
         //            MiddleName = "Ivan",
         //            LastName = "Tanner",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 4, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1548,
         //            //StudentPersonId = 1548,
         //            StateStudentIdentifier = "7977581548",
         //            FirstName = "Aurora",
         //            MiddleName = "Sydnee",
         //            LastName = "Reed",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 5, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1549,
         //            //StudentPersonId = 1549,
         //            StateStudentIdentifier = "2623991549",
         //            FirstName = "Brett",
         //            MiddleName = "Griffin",
         //            LastName = "Stout",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 12, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1550,
         //            //StudentPersonId = 1550,
         //            StateStudentIdentifier = "9126391550",
         //            FirstName = "Zelenia",
         //            MiddleName = "Dorothy",
         //            LastName = "Dodson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 3, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1551,
         //            //StudentPersonId = 1551,
         //            StateStudentIdentifier = "8660101551",
         //            FirstName = "Gage",
         //            MiddleName = "Odysseus",
         //            LastName = "Fitzgerald",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2014, 10, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1552,
         //            //StudentPersonId = 1552,
         //            StateStudentIdentifier = "3189141552",
         //            FirstName = "Louis",
         //            MiddleName = "Caesar",
         //            LastName = "Cote",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 10, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1553,
         //            //StudentPersonId = 1553,
         //            StateStudentIdentifier = "2911751553",
         //            FirstName = "Yvonne",
         //            MiddleName = "McKenzie",
         //            LastName = "Ferguson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 12, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1554,
         //            //StudentPersonId = 1554,
         //            StateStudentIdentifier = "6254541554",
         //            FirstName = "Russell",
         //            MiddleName = "Chadwick",
         //            LastName = "Hebert",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1996, 1, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1555,
         //            //StudentPersonId = 1555,
         //            StateStudentIdentifier = "1722601555",
         //            FirstName = "Elliott",
         //            MiddleName = "Daniel",
         //            LastName = "Valentine",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 6, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1556,
         //            //StudentPersonId = 1556,
         //            StateStudentIdentifier = "5333231556",
         //            FirstName = "Aline",
         //            MiddleName = "Serena",
         //            LastName = "Sloan",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 11, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1557,
         //            //StudentPersonId = 1557,
         //            StateStudentIdentifier = "0093901557",
         //            FirstName = "Oliver",
         //            MiddleName = "Eagan",
         //            LastName = "Hancock",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 9, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1558,
         //            //StudentPersonId = 1558,
         //            StateStudentIdentifier = "9022391558",
         //            FirstName = "Bob",
         //            MiddleName = "Harlan",
         //            LastName = "Holt",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 11, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1559,
         //            //StudentPersonId = 1559,
         //            StateStudentIdentifier = "7858531559",
         //            FirstName = "Quynn",
         //            MiddleName = "Dylan",
         //            LastName = "Brady",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2014, 6, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1560,
         //            //StudentPersonId = 1560,
         //            StateStudentIdentifier = "6678341560",
         //            FirstName = "Rae",
         //            MiddleName = "Yolanda",
         //            LastName = "Figueroa",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 5, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1561,
         //            //StudentPersonId = 1561,
         //            StateStudentIdentifier = "7146771561",
         //            FirstName = "Cally",
         //            MiddleName = "Medge",
         //            LastName = "Phelps",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 10, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1562,
         //            //StudentPersonId = 1562,
         //            StateStudentIdentifier = "9713951562",
         //            FirstName = "Mechelle",
         //            MiddleName = "Kay",
         //            LastName = "Reeves",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 12, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1563,
         //            //StudentPersonId = 1563,
         //            StateStudentIdentifier = "8014891563",
         //            FirstName = "Wing",
         //            MiddleName = "Lawrence",
         //            LastName = "Castro",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 2, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1564,
         //            //StudentPersonId = 1564,
         //            StateStudentIdentifier = "8330061564",
         //            FirstName = "Alden",
         //            MiddleName = "Thane",
         //            LastName = "Kent",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 8, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1565,
         //            //StudentPersonId = 1565,
         //            StateStudentIdentifier = "5707131565",
         //            FirstName = "Galena",
         //            MiddleName = "Macy",
         //            LastName = "Macdonald",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2004, 8, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1566,
         //            //StudentPersonId = 1566,
         //            StateStudentIdentifier = "4368461566",
         //            FirstName = "Jemima",
         //            MiddleName = "Montana",
         //            LastName = "Hendricks",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 11, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1567,
         //            //StudentPersonId = 1567,
         //            StateStudentIdentifier = "4412801567",
         //            FirstName = "Ivor",
         //            MiddleName = "Len",
         //            LastName = "Riggs",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2018, 1, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1568,
         //            //StudentPersonId = 1568,
         //            StateStudentIdentifier = "3085321568",
         //            FirstName = "Quail",
         //            MiddleName = "Medge",
         //            LastName = "Hess",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 11, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1569,
         //            //StudentPersonId = 1569,
         //            StateStudentIdentifier = "1164661569",
         //            FirstName = "Destiny",
         //            MiddleName = "Larissa",
         //            LastName = "Gonzales",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 6, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1570,
         //            //StudentPersonId = 1570,
         //            StateStudentIdentifier = "6685761570",
         //            FirstName = "Armand",
         //            MiddleName = "Elliott",
         //            LastName = "Osborn",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 1, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1571,
         //            //StudentPersonId = 1571,
         //            StateStudentIdentifier = "2359201571",
         //            FirstName = "Blake",
         //            MiddleName = "Chester",
         //            LastName = "Rosales",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 2, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1572,
         //            //StudentPersonId = 1572,
         //            StateStudentIdentifier = "7898641572",
         //            FirstName = "Haley",
         //            MiddleName = "Rosalyn",
         //            LastName = "Goodman",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1997, 7, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1573,
         //            //StudentPersonId = 1573,
         //            StateStudentIdentifier = "4215501573",
         //            FirstName = "Adena",
         //            MiddleName = "Graham",
         //            LastName = "Wooten",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 10, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1574,
         //            //StudentPersonId = 1574,
         //            StateStudentIdentifier = "5583531574",
         //            FirstName = "Britanni",
         //            MiddleName = "Carissa",
         //            LastName = "Schroeder",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 9, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1575,
         //            //StudentPersonId = 1575,
         //            StateStudentIdentifier = "1099781575",
         //            FirstName = "Joel",
         //            MiddleName = "Ashton",
         //            LastName = "Mcintosh",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 6, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1576,
         //            //StudentPersonId = 1576,
         //            StateStudentIdentifier = "2082901576",
         //            FirstName = "Sheila",
         //            MiddleName = "Sopoline",
         //            LastName = "Barlow",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 9, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1577,
         //            //StudentPersonId = 1577,
         //            StateStudentIdentifier = "6749741577",
         //            FirstName = "Preston",
         //            MiddleName = "Bradley",
         //            LastName = "Tyson",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2014, 6, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1578,
         //            //StudentPersonId = 1578,
         //            StateStudentIdentifier = "5405731578",
         //            FirstName = "Carol",
         //            MiddleName = "Eve",
         //            LastName = "Reynolds",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2011, 1, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1579,
         //            //StudentPersonId = 1579,
         //            StateStudentIdentifier = "3729681579",
         //            FirstName = "Martena",
         //            MiddleName = "Sharon",
         //            LastName = "Gregory",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2009, 10, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1580,
         //            //StudentPersonId = 1580,
         //            StateStudentIdentifier = "2197091580",
         //            FirstName = "Linus",
         //            MiddleName = "Ian",
         //            LastName = "Mayer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 7, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1581,
         //            //StudentPersonId = 1581,
         //            StateStudentIdentifier = "9143601581",
         //            FirstName = "Imogene",
         //            MiddleName = "Karyn",
         //            LastName = "Salinas",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 2, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1582,
         //            //StudentPersonId = 1582,
         //            StateStudentIdentifier = "3910281582",
         //            FirstName = "Asher",
         //            MiddleName = "Paki",
         //            LastName = "Bird",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 5, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1583,
         //            //StudentPersonId = 1583,
         //            StateStudentIdentifier = "5272681583",
         //            FirstName = "Jordan",
         //            MiddleName = "Magee",
         //            LastName = "Shelton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 12, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1584,
         //            //StudentPersonId = 1584,
         //            StateStudentIdentifier = "5285771584",
         //            FirstName = "Thane",
         //            MiddleName = "Brennan",
         //            LastName = "Barnett",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 1, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1585,
         //            //StudentPersonId = 1585,
         //            StateStudentIdentifier = "8781201585",
         //            FirstName = "Holly",
         //            MiddleName = "Imogene",
         //            LastName = "Black",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2006, 4, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1586,
         //            //StudentPersonId = 1586,
         //            StateStudentIdentifier = "2011041586",
         //            FirstName = "Xantha",
         //            MiddleName = "Ezra",
         //            LastName = "Roth",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2010, 1, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1587,
         //            //StudentPersonId = 1587,
         //            StateStudentIdentifier = "2817741587",
         //            FirstName = "Virginia",
         //            MiddleName = "Kay",
         //            LastName = "Carey",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 3, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1588,
         //            //StudentPersonId = 1588,
         //            StateStudentIdentifier = "0772901588",
         //            FirstName = "Elaine",
         //            MiddleName = "Blaine",
         //            LastName = "Gould",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 6, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1589,
         //            //StudentPersonId = 1589,
         //            StateStudentIdentifier = "8471681589",
         //            FirstName = "Boris",
         //            MiddleName = "Callie",
         //            LastName = "Morrison",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 3, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1590,
         //            //StudentPersonId = 1590,
         //            StateStudentIdentifier = "0668211590",
         //            FirstName = "Demetrius",
         //            MiddleName = "Macon",
         //            LastName = "Mueller",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 12, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1591,
         //            //StudentPersonId = 1591,
         //            StateStudentIdentifier = "8203831591",
         //            FirstName = "Alfonso",
         //            MiddleName = "Colby",
         //            LastName = "Cain",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 9, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1592,
         //            //StudentPersonId = 1592,
         //            StateStudentIdentifier = "8817671592",
         //            FirstName = "Gil",
         //            MiddleName = "Dale",
         //            LastName = "Nielsen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 8, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1593,
         //            //StudentPersonId = 1593,
         //            StateStudentIdentifier = "2883651593",
         //            FirstName = "Harriet",
         //            MiddleName = "Winifred",
         //            LastName = "Jordan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 6, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1594,
         //            //StudentPersonId = 1594,
         //            StateStudentIdentifier = "4385141594",
         //            FirstName = "India",
         //            MiddleName = "Xantha",
         //            LastName = "Shepherd",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 2, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1595,
         //            //StudentPersonId = 1595,
         //            StateStudentIdentifier = "9496101595",
         //            FirstName = "Robin",
         //            MiddleName = "Ashton",
         //            LastName = "Ball",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 2, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1596,
         //            //StudentPersonId = 1596,
         //            StateStudentIdentifier = "9250571596",
         //            FirstName = "Philip",
         //            MiddleName = "Rogan",
         //            LastName = "Blanchard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 6, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1597,
         //            //StudentPersonId = 1597,
         //            StateStudentIdentifier = "4436721597",
         //            FirstName = "Shoshana",
         //            MiddleName = "Mikayla",
         //            LastName = "Holden",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2005, 12, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1598,
         //            //StudentPersonId = 1598,
         //            StateStudentIdentifier = "9966881598",
         //            FirstName = "Cole",
         //            MiddleName = "Elton",
         //            LastName = "Farrell",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1999, 9, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1599,
         //            //StudentPersonId = 1599,
         //            StateStudentIdentifier = "8395231599",
         //            FirstName = "Ursula",
         //            MiddleName = "Kim",
         //            LastName = "Dejesus",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 6, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1600,
         //            //StudentPersonId = 1600,
         //            StateStudentIdentifier = "3687621600",
         //            FirstName = "Russell",
         //            MiddleName = "Nasim",
         //            LastName = "Spencer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 12, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1601,
         //            //StudentPersonId = 1601,
         //            StateStudentIdentifier = "8877831601",
         //            FirstName = "Clementine",
         //            MiddleName = "Lael",
         //            LastName = "Hopper",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 9, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1602,
         //            //StudentPersonId = 1602,
         //            StateStudentIdentifier = "6504921602",
         //            FirstName = "Brent",
         //            MiddleName = "Camden",
         //            LastName = "Sykes",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1997, 1, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1603,
         //            //StudentPersonId = 1603,
         //            StateStudentIdentifier = "9841161603",
         //            FirstName = "Chloe",
         //            MiddleName = "Lynn",
         //            LastName = "Tate",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 12, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1604,
         //            //StudentPersonId = 1604,
         //            StateStudentIdentifier = "7794481604",
         //            FirstName = "Roth",
         //            MiddleName = "Malik",
         //            LastName = "Bell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 12, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1605,
         //            //StudentPersonId = 1605,
         //            StateStudentIdentifier = "2375551605",
         //            FirstName = "Sumanth",
         //            MiddleName = "Gabriel",
         //            LastName = "Foster",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 8, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1606,
         //            //StudentPersonId = 1606,
         //            StateStudentIdentifier = "7649131606",
         //            FirstName = "Alec",
         //            MiddleName = "Alfonso",
         //            LastName = "Holcomb",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 7, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1607,
         //            //StudentPersonId = 1607,
         //            StateStudentIdentifier = "4579121607",
         //            FirstName = "Walker",
         //            MiddleName = "Acton",
         //            LastName = "Garrett",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2006, 8, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1608,
         //            //StudentPersonId = 1608,
         //            StateStudentIdentifier = "8650121608",
         //            FirstName = "Chloe",
         //            MiddleName = "Rosalyn",
         //            LastName = "Hull",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2013, 5, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1609,
         //            //StudentPersonId = 1609,
         //            StateStudentIdentifier = "0954031609",
         //            FirstName = "Rudyard",
         //            MiddleName = "Tobias",
         //            LastName = "Griffin",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 11, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1610,
         //            //StudentPersonId = 1610,
         //            StateStudentIdentifier = "9128581610",
         //            FirstName = "Dominic",
         //            MiddleName = "Calvin",
         //            LastName = "Stafford",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2014, 6, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1611,
         //            //StudentPersonId = 1611,
         //            StateStudentIdentifier = "3021911611",
         //            FirstName = "Salvador",
         //            MiddleName = "Craig",
         //            LastName = "Delaney",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 7, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1612,
         //            //StudentPersonId = 1612,
         //            StateStudentIdentifier = "7374841612",
         //            FirstName = "Kato",
         //            MiddleName = "Yasir",
         //            LastName = "Barry",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 12, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1613,
         //            //StudentPersonId = 1613,
         //            StateStudentIdentifier = "0206591613",
         //            FirstName = "Cooper",
         //            MiddleName = "Xander",
         //            LastName = "Alston",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 5, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1614,
         //            //StudentPersonId = 1614,
         //            StateStudentIdentifier = "7756081614",
         //            FirstName = "Leah",
         //            MiddleName = "Jocelyn",
         //            LastName = "Mclean",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 12, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1615,
         //            //StudentPersonId = 1615,
         //            StateStudentIdentifier = "2142991615",
         //            FirstName = "Aristotle",
         //            MiddleName = "Jerry",
         //            LastName = "Franco",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 1, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1616,
         //            //StudentPersonId = 1616,
         //            StateStudentIdentifier = "0234671616",
         //            FirstName = "Brent",
         //            MiddleName = "Igor",
         //            LastName = "Stanley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 11, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1617,
         //            //StudentPersonId = 1617,
         //            StateStudentIdentifier = "3364561617",
         //            FirstName = "Pascale",
         //            MiddleName = "Leslie",
         //            LastName = "Schneider",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 5, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1618,
         //            //StudentPersonId = 1618,
         //            StateStudentIdentifier = "6209021618",
         //            FirstName = "Hanna",
         //            MiddleName = "Ariel",
         //            LastName = "Finley",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2001, 9, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1619,
         //            //StudentPersonId = 1619,
         //            StateStudentIdentifier = "1739831619",
         //            FirstName = "Maxwell",
         //            MiddleName = "Harlan",
         //            LastName = "Mays",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2014, 12, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1620,
         //            //StudentPersonId = 1620,
         //            StateStudentIdentifier = "4883111620",
         //            FirstName = "Nora",
         //            MiddleName = "Sonia",
         //            LastName = "Johnson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 7, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1621,
         //            //StudentPersonId = 1621,
         //            StateStudentIdentifier = "3527521621",
         //            FirstName = "Cameran",
         //            MiddleName = "Brenna",
         //            LastName = "Galloway",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 6, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1622,
         //            //StudentPersonId = 1622,
         //            StateStudentIdentifier = "2588801622",
         //            FirstName = "Kyla",
         //            MiddleName = "Cadman",
         //            LastName = "Mullen",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2002, 6, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1623,
         //            //StudentPersonId = 1623,
         //            StateStudentIdentifier = "1059191623",
         //            FirstName = "Xander",
         //            MiddleName = "Tanner",
         //            LastName = "Estes",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 10, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1624,
         //            //StudentPersonId = 1624,
         //            StateStudentIdentifier = "1656911624",
         //            FirstName = "Jack",
         //            MiddleName = "Duncan",
         //            LastName = "Robertson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 1, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1625,
         //            //StudentPersonId = 1625,
         //            StateStudentIdentifier = "7715461625",
         //            FirstName = "Myra",
         //            MiddleName = "Kai",
         //            LastName = "Brewer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 4, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1626,
         //            //StudentPersonId = 1626,
         //            StateStudentIdentifier = "5110971626",
         //            FirstName = "Kai",
         //            MiddleName = "Bob",
         //            LastName = "Hart",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 2, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1627,
         //            //StudentPersonId = 1627,
         //            StateStudentIdentifier = "4093841627",
         //            FirstName = "Tanner",
         //            MiddleName = "Duncan",
         //            LastName = "Sparks",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2005, 7, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1628,
         //            //StudentPersonId = 1628,
         //            StateStudentIdentifier = "7548951628",
         //            FirstName = "Felix",
         //            MiddleName = "Deacon",
         //            LastName = "Woods",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 3, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1629,
         //            //StudentPersonId = 1629,
         //            StateStudentIdentifier = "8836491629",
         //            FirstName = "Kato",
         //            MiddleName = "Julian",
         //            LastName = "Burton",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2007, 7, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1630,
         //            //StudentPersonId = 1630,
         //            StateStudentIdentifier = "7304361630",
         //            FirstName = "Chandler",
         //            MiddleName = "Christian",
         //            LastName = "Hinton",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1996, 3, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1631,
         //            //StudentPersonId = 1631,
         //            StateStudentIdentifier = "5715661631",
         //            FirstName = "Rajeev",
         //            MiddleName = "Garrison",
         //            LastName = "Huff",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 9, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1632,
         //            //StudentPersonId = 1632,
         //            StateStudentIdentifier = "8045921632",
         //            FirstName = "Lucas",
         //            MiddleName = "Acton",
         //            LastName = "Glass",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 1, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1633,
         //            //StudentPersonId = 1633,
         //            StateStudentIdentifier = "2226321633",
         //            FirstName = "Yvonne",
         //            MiddleName = "Renee",
         //            LastName = "Carpenter",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 2, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1634,
         //            //StudentPersonId = 1634,
         //            StateStudentIdentifier = "2818291634",
         //            FirstName = "Daquan",
         //            MiddleName = "Armando",
         //            LastName = "Clark",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1999, 5, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1635,
         //            //StudentPersonId = 1635,
         //            StateStudentIdentifier = "5219351635",
         //            FirstName = "Libby",
         //            MiddleName = "Justina",
         //            LastName = "Clemons",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2014, 7, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1636,
         //            //StudentPersonId = 1636,
         //            StateStudentIdentifier = "4250011636",
         //            FirstName = "Marny",
         //            MiddleName = "Leilani",
         //            LastName = "Baker",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2014, 2, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1637,
         //            //StudentPersonId = 1637,
         //            StateStudentIdentifier = "8403491637",
         //            FirstName = "Destiny",
         //            MiddleName = "Blair",
         //            LastName = "Maxwell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 8, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1638,
         //            //StudentPersonId = 1638,
         //            StateStudentIdentifier = "4545151638",
         //            FirstName = "Justine",
         //            MiddleName = "Scott",
         //            LastName = "Garrett",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 8, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1639,
         //            //StudentPersonId = 1639,
         //            StateStudentIdentifier = "9572001639",
         //            FirstName = "Quinlan",
         //            MiddleName = "Colorado",
         //            LastName = "Carter",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2010, 10, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1640,
         //            //StudentPersonId = 1640,
         //            StateStudentIdentifier = "3657171640",
         //            FirstName = "Nash",
         //            MiddleName = "Axel",
         //            LastName = "Graves",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 11, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1641,
         //            //StudentPersonId = 1641,
         //            StateStudentIdentifier = "7821761641",
         //            FirstName = "August",
         //            MiddleName = "Linus",
         //            LastName = "Ballard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 7, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1642,
         //            //StudentPersonId = 1642,
         //            StateStudentIdentifier = "7373431642",
         //            FirstName = "Sophia",
         //            MiddleName = "Maggy",
         //            LastName = "Lyons",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 12, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1643,
         //            //StudentPersonId = 1643,
         //            StateStudentIdentifier = "6545361643",
         //            FirstName = "Grace",
         //            MiddleName = "Stacey",
         //            LastName = "Moreno",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2001, 11, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1644,
         //            //StudentPersonId = 1644,
         //            StateStudentIdentifier = "8831341644",
         //            FirstName = "Wynne",
         //            MiddleName = "Adara",
         //            LastName = "Carter",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2006, 12, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1645,
         //            //StudentPersonId = 1645,
         //            StateStudentIdentifier = "9869281645",
         //            FirstName = "Ariana",
         //            MiddleName = "Zorita",
         //            LastName = "Soto",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 5, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1646,
         //            //StudentPersonId = 1646,
         //            StateStudentIdentifier = "1703631646",
         //            FirstName = "Kirby",
         //            MiddleName = "Zena",
         //            LastName = "Roach",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 8, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1647,
         //            //StudentPersonId = 1647,
         //            StateStudentIdentifier = "4738961647",
         //            FirstName = "Kevyn",
         //            MiddleName = "Sigourney",
         //            LastName = "Wright",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2004, 6, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1648,
         //            //StudentPersonId = 1648,
         //            StateStudentIdentifier = "7121621648",
         //            FirstName = "Daniel",
         //            MiddleName = "Britanni",
         //            LastName = "Rivers",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 12, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1649,
         //            //StudentPersonId = 1649,
         //            StateStudentIdentifier = "5396871649",
         //            FirstName = "Eleanor",
         //            MiddleName = "Isabelle",
         //            LastName = "Arnold",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 2, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1650,
         //            //StudentPersonId = 1650,
         //            StateStudentIdentifier = "7934881650",
         //            FirstName = "Adena",
         //            MiddleName = "Miranda",
         //            LastName = "Banks",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 10, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1651,
         //            //StudentPersonId = 1651,
         //            StateStudentIdentifier = "9793131651",
         //            FirstName = "Lev",
         //            MiddleName = "Lucius",
         //            LastName = "Burris",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 11, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1652,
         //            //StudentPersonId = 1652,
         //            StateStudentIdentifier = "9555711652",
         //            FirstName = "Elliott",
         //            MiddleName = "Sawyer",
         //            LastName = "Nunez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 10, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1653,
         //            //StudentPersonId = 1653,
         //            StateStudentIdentifier = "5152841653",
         //            FirstName = "Octavius",
         //            MiddleName = "Valentine",
         //            LastName = "Dixon",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2001, 8, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1654,
         //            //StudentPersonId = 1654,
         //            StateStudentIdentifier = "4517641654",
         //            FirstName = "Cody",
         //            MiddleName = "Salvador",
         //            LastName = "Beck",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2008, 9, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1655,
         //            //StudentPersonId = 1655,
         //            StateStudentIdentifier = "6292291655",
         //            FirstName = "Aimee",
         //            MiddleName = "Summer",
         //            LastName = "Gregory",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1997, 1, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1656,
         //            //StudentPersonId = 1656,
         //            StateStudentIdentifier = "3996911656",
         //            FirstName = "Rooney",
         //            MiddleName = "Malcolm",
         //            LastName = "Ashley",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1996, 12, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1657,
         //            //StudentPersonId = 1657,
         //            StateStudentIdentifier = "6317181657",
         //            FirstName = "Blaine",
         //            MiddleName = "Priscilla",
         //            LastName = "Vaughn",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2017, 6, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1658,
         //            //StudentPersonId = 1658,
         //            StateStudentIdentifier = "3679211658",
         //            FirstName = "Shelly",
         //            MiddleName = "Marny",
         //            LastName = "Jarvis",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 12, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1659,
         //            //StudentPersonId = 1659,
         //            StateStudentIdentifier = "7691571659",
         //            FirstName = "Mariam",
         //            MiddleName = "Sylvia",
         //            LastName = "Mack",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 7, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1660,
         //            //StudentPersonId = 1660,
         //            StateStudentIdentifier = "9816941660",
         //            FirstName = "Magee",
         //            MiddleName = "Chancellor",
         //            LastName = "Ewing",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 1, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1661,
         //            //StudentPersonId = 1661,
         //            StateStudentIdentifier = "8607401661",
         //            FirstName = "Odysseus",
         //            MiddleName = "Hector",
         //            LastName = "Cunningham",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 5, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1662,
         //            //StudentPersonId = 1662,
         //            StateStudentIdentifier = "4837181662",
         //            FirstName = "Macaulay",
         //            MiddleName = "Colin",
         //            LastName = "Daugherty",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 12, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1663,
         //            //StudentPersonId = 1663,
         //            StateStudentIdentifier = "7242301663",
         //            FirstName = "Wendy",
         //            MiddleName = "Keely",
         //            LastName = "Dodson",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1998, 11, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1664,
         //            //StudentPersonId = 1664,
         //            StateStudentIdentifier = "0933731664",
         //            FirstName = "Rajeev",
         //            MiddleName = "Martin",
         //            LastName = "Rodriguez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 5, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1665,
         //            //StudentPersonId = 1665,
         //            StateStudentIdentifier = "6462611665",
         //            FirstName = "Jaime",
         //            MiddleName = "Illana",
         //            LastName = "Dickson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 7, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1666,
         //            //StudentPersonId = 1666,
         //            StateStudentIdentifier = "1739471666",
         //            FirstName = "Nicholas",
         //            MiddleName = "Dylan",
         //            LastName = "Bell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 10, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1667,
         //            //StudentPersonId = 1667,
         //            StateStudentIdentifier = "2217801667",
         //            FirstName = "Doug",
         //            MiddleName = "Rogan",
         //            LastName = "Dejesus",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 11, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1668,
         //            //StudentPersonId = 1668,
         //            StateStudentIdentifier = "0375031668",
         //            FirstName = "Joseph",
         //            MiddleName = "Lamar",
         //            LastName = "Mcintosh",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 9, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1669,
         //            //StudentPersonId = 1669,
         //            StateStudentIdentifier = "8806421669",
         //            FirstName = "Maggy",
         //            MiddleName = "Francesca",
         //            LastName = "Joyce",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 9, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1670,
         //            //StudentPersonId = 1670,
         //            StateStudentIdentifier = "9856321670",
         //            FirstName = "Lawrence",
         //            MiddleName = "Dominic",
         //            LastName = "Mccormick",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 10, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1671,
         //            //StudentPersonId = 1671,
         //            StateStudentIdentifier = "8810301671",
         //            FirstName = "Alea",
         //            MiddleName = "Sierra",
         //            LastName = "Bryant",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 12, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1672,
         //            //StudentPersonId = 1672,
         //            StateStudentIdentifier = "2010981672",
         //            FirstName = "Adrian",
         //            MiddleName = "Allen",
         //            LastName = "Zamora",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2012, 3, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1673,
         //            //StudentPersonId = 1673,
         //            StateStudentIdentifier = "6528491673",
         //            FirstName = "Felix",
         //            MiddleName = "Nissim",
         //            LastName = "Donaldson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 5, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1674,
         //            //StudentPersonId = 1674,
         //            StateStudentIdentifier = "7002901674",
         //            FirstName = "Lars",
         //            MiddleName = "Tanner",
         //            LastName = "Reed",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 11, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1675,
         //            //StudentPersonId = 1675,
         //            StateStudentIdentifier = "3153331675",
         //            FirstName = "Allistair",
         //            MiddleName = "Aimee",
         //            LastName = "Graves",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2010, 4, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1676,
         //            //StudentPersonId = 1676,
         //            StateStudentIdentifier = "2278681676",
         //            FirstName = "Nash",
         //            MiddleName = "Victor",
         //            LastName = "Mcintosh",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2004, 10, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1677,
         //            //StudentPersonId = 1677,
         //            StateStudentIdentifier = "3395851677",
         //            FirstName = "Tatyana",
         //            MiddleName = "Ima",
         //            LastName = "Hewitt",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2006, 7, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1678,
         //            //StudentPersonId = 1678,
         //            StateStudentIdentifier = "8589411678",
         //            FirstName = "Emi",
         //            MiddleName = "Kelsey",
         //            LastName = "Jarvis",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 7, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1679,
         //            //StudentPersonId = 1679,
         //            StateStudentIdentifier = "6023321679",
         //            FirstName = "Clementine",
         //            MiddleName = "Clementine",
         //            LastName = "Graham",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 3, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1680,
         //            //StudentPersonId = 1680,
         //            StateStudentIdentifier = "0251041680",
         //            FirstName = "Gillian",
         //            MiddleName = "Montana",
         //            LastName = "Mooney",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2004, 11, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1681,
         //            //StudentPersonId = 1681,
         //            StateStudentIdentifier = "6450751681",
         //            FirstName = "Alana",
         //            MiddleName = "Cleo",
         //            LastName = "Cooke",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 3, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1682,
         //            //StudentPersonId = 1682,
         //            StateStudentIdentifier = "7361841682",
         //            FirstName = "Phyllis",
         //            MiddleName = "Darryl",
         //            LastName = "Peterson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 12, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1683,
         //            //StudentPersonId = 1683,
         //            StateStudentIdentifier = "1077561683",
         //            FirstName = "Reuben",
         //            MiddleName = "Xanthus",
         //            LastName = "Mcgee",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 9, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1684,
         //            //StudentPersonId = 1684,
         //            StateStudentIdentifier = "5827471684",
         //            FirstName = "Hedley",
         //            MiddleName = "Magee",
         //            LastName = "York",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2017, 12, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1685,
         //            //StudentPersonId = 1685,
         //            StateStudentIdentifier = "9939591685",
         //            FirstName = "Octavia",
         //            MiddleName = "Jorden",
         //            LastName = "Brennan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 2, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1686,
         //            //StudentPersonId = 1686,
         //            StateStudentIdentifier = "7624861686",
         //            FirstName = "Tatiana",
         //            MiddleName = "Kelsey",
         //            LastName = "Battle",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 9, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1687,
         //            //StudentPersonId = 1687,
         //            StateStudentIdentifier = "3005861687",
         //            FirstName = "Bell",
         //            MiddleName = "Willow",
         //            LastName = "Booth",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2019, 2, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1688,
         //            //StudentPersonId = 1688,
         //            StateStudentIdentifier = "1305231688",
         //            FirstName = "Brett",
         //            MiddleName = "Kamal",
         //            LastName = "Greer",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1996, 6, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1689,
         //            //StudentPersonId = 1689,
         //            StateStudentIdentifier = "0693171689",
         //            FirstName = "Kuame",
         //            MiddleName = "Vernon",
         //            LastName = "Warren",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2019, 10, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1690,
         //            //StudentPersonId = 1690,
         //            StateStudentIdentifier = "4923301690",
         //            FirstName = "Craig",
         //            MiddleName = "Hu",
         //            LastName = "Rice",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 11, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1691,
         //            //StudentPersonId = 1691,
         //            StateStudentIdentifier = "4431011691",
         //            FirstName = "Rylee",
         //            MiddleName = "Eugenia",
         //            LastName = "Goodman",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1996, 6, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1692,
         //            //StudentPersonId = 1692,
         //            StateStudentIdentifier = "9656561692",
         //            FirstName = "Tobias",
         //            MiddleName = "Elijah",
         //            LastName = "Carpenter",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2004, 2, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1693,
         //            //StudentPersonId = 1693,
         //            StateStudentIdentifier = "0004781693",
         //            FirstName = "Ainsley",
         //            MiddleName = "Madonna",
         //            LastName = "Norris",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 11, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1694,
         //            //StudentPersonId = 1694,
         //            StateStudentIdentifier = "8862731694",
         //            FirstName = "Steel",
         //            MiddleName = "Noble",
         //            LastName = "Garrett",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 6, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1695,
         //            //StudentPersonId = 1695,
         //            StateStudentIdentifier = "1059191695",
         //            FirstName = "Kiara",
         //            MiddleName = "Lacota",
         //            LastName = "Valentine",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2011, 10, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1696,
         //            //StudentPersonId = 1696,
         //            StateStudentIdentifier = "6376781696",
         //            FirstName = "Raja",
         //            MiddleName = "Gage",
         //            LastName = "Cote",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 12, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1697,
         //            //StudentPersonId = 1697,
         //            StateStudentIdentifier = "5834431697",
         //            FirstName = "Haviva",
         //            MiddleName = "Zena",
         //            LastName = "Collins",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 9, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1698,
         //            //StudentPersonId = 1698,
         //            StateStudentIdentifier = "9273831698",
         //            FirstName = "Emma",
         //            MiddleName = "Rhea",
         //            LastName = "Jordan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 10, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1699,
         //            //StudentPersonId = 1699,
         //            StateStudentIdentifier = "5702551699",
         //            FirstName = "Lilah",
         //            MiddleName = "Heather",
         //            LastName = "Juarez",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 2, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1700,
         //            //StudentPersonId = 1700,
         //            StateStudentIdentifier = "5445761700",
         //            FirstName = "Neve",
         //            MiddleName = "Stacey",
         //            LastName = "Knox",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 10, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1701,
         //            //StudentPersonId = 1701,
         //            StateStudentIdentifier = "9076471701",
         //            FirstName = "Hadassah",
         //            MiddleName = "Shelby",
         //            LastName = "Avery",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2011, 11, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1702,
         //            //StudentPersonId = 1702,
         //            StateStudentIdentifier = "8687801702",
         //            FirstName = "Dennis",
         //            MiddleName = "Laith",
         //            LastName = "Wright",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 8, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1703,
         //            //StudentPersonId = 1703,
         //            StateStudentIdentifier = "7058371703",
         //            FirstName = "Leonard",
         //            MiddleName = "Cruz",
         //            LastName = "Haynes",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2015, 4, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1704,
         //            //StudentPersonId = 1704,
         //            StateStudentIdentifier = "6827471704",
         //            FirstName = "Vivian",
         //            MiddleName = "Sydnee",
         //            LastName = "Phelps",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 10, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1705,
         //            //StudentPersonId = 1705,
         //            StateStudentIdentifier = "7260441705",
         //            FirstName = "Kenyon",
         //            MiddleName = "Rudyard",
         //            LastName = "Boyd",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 6, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1706,
         //            //StudentPersonId = 1706,
         //            StateStudentIdentifier = "0313561706",
         //            FirstName = "Lyle",
         //            MiddleName = "Quentin",
         //            LastName = "Branch",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 4, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1707,
         //            //StudentPersonId = 1707,
         //            StateStudentIdentifier = "5348451707",
         //            FirstName = "Eaton",
         //            MiddleName = "Justin",
         //            LastName = "Hart",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2015, 2, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1708,
         //            //StudentPersonId = 1708,
         //            StateStudentIdentifier = "4619851708",
         //            FirstName = "Germaine",
         //            MiddleName = "Cara",
         //            LastName = "Rodgers",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 5, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1709,
         //            //StudentPersonId = 1709,
         //            StateStudentIdentifier = "8327701709",
         //            FirstName = "Marvin",
         //            MiddleName = "Abraham",
         //            LastName = "Castillo",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 9, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1710,
         //            //StudentPersonId = 1710,
         //            StateStudentIdentifier = "0345911710",
         //            FirstName = "Neve",
         //            MiddleName = "Ella",
         //            LastName = "Barnett",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2010, 1, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1711,
         //            //StudentPersonId = 1711,
         //            StateStudentIdentifier = "1722441711",
         //            FirstName = "Kane",
         //            MiddleName = "Jack",
         //            LastName = "Klein",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2013, 9, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1712,
         //            //StudentPersonId = 1712,
         //            StateStudentIdentifier = "3239241712",
         //            FirstName = "Logan",
         //            MiddleName = "Jin",
         //            LastName = "Fowler",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2010, 11, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1713,
         //            //StudentPersonId = 1713,
         //            StateStudentIdentifier = "5377681713",
         //            FirstName = "Lilah",
         //            MiddleName = "Galena",
         //            LastName = "Bell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 1, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1714,
         //            //StudentPersonId = 1714,
         //            StateStudentIdentifier = "2651801714",
         //            FirstName = "Quintessa",
         //            MiddleName = "Wilma",
         //            LastName = "Clay",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 6, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1715,
         //            //StudentPersonId = 1715,
         //            StateStudentIdentifier = "6247351715",
         //            FirstName = "Zelda",
         //            MiddleName = "Chloe",
         //            LastName = "Chan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 10, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1716,
         //            //StudentPersonId = 1716,
         //            StateStudentIdentifier = "8143231716",
         //            FirstName = "Nero",
         //            MiddleName = "Maxwell",
         //            LastName = "Dudley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 4, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1717,
         //            //StudentPersonId = 1717,
         //            StateStudentIdentifier = "1113441717",
         //            FirstName = "Xyla",
         //            MiddleName = "Amber",
         //            LastName = "Olsen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 11, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1718,
         //            //StudentPersonId = 1718,
         //            StateStudentIdentifier = "0659981718",
         //            FirstName = "Paul",
         //            MiddleName = "Miriam",
         //            LastName = "James",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1996, 1, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1719,
         //            //StudentPersonId = 1719,
         //            StateStudentIdentifier = "8013881719",
         //            FirstName = "Vivien",
         //            MiddleName = "Iris",
         //            LastName = "Buchanan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 10, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1720,
         //            //StudentPersonId = 1720,
         //            StateStudentIdentifier = "1703121720",
         //            FirstName = "Dominique",
         //            MiddleName = "Hedy",
         //            LastName = "Camacho",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2004, 3, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1721,
         //            //StudentPersonId = 1721,
         //            StateStudentIdentifier = "2650881721",
         //            FirstName = "Fatima",
         //            MiddleName = "Gabriel",
         //            LastName = "Porter",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1999, 4, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1722,
         //            //StudentPersonId = 1722,
         //            StateStudentIdentifier = "1694991722",
         //            FirstName = "Kenyon",
         //            MiddleName = "Guy",
         //            LastName = "Burns",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 5, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1723,
         //            //StudentPersonId = 1723,
         //            StateStudentIdentifier = "6121871723",
         //            FirstName = "Jade",
         //            MiddleName = "Brenden",
         //            LastName = "Ratliff",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 9, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1724,
         //            //StudentPersonId = 1724,
         //            StateStudentIdentifier = "7582331724",
         //            FirstName = "Hiram",
         //            MiddleName = "Talon",
         //            LastName = "Burgess",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2018, 12, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1725,
         //            //StudentPersonId = 1725,
         //            StateStudentIdentifier = "4869891725",
         //            FirstName = "Haviva",
         //            MiddleName = "Nomlanga",
         //            LastName = "Blackburn",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2011, 3, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1726,
         //            //StudentPersonId = 1726,
         //            StateStudentIdentifier = "5634711726",
         //            FirstName = "Holmes",
         //            MiddleName = "Curran",
         //            LastName = "Bruce",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 8, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1727,
         //            //StudentPersonId = 1727,
         //            StateStudentIdentifier = "7754811727",
         //            FirstName = "Ingrid",
         //            MiddleName = "Ginger",
         //            LastName = "Bernard",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1996, 9, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1728,
         //            //StudentPersonId = 1728,
         //            StateStudentIdentifier = "4154651728",
         //            FirstName = "Finn",
         //            MiddleName = "Noble",
         //            LastName = "Wooten",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 2, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1729,
         //            //StudentPersonId = 1729,
         //            StateStudentIdentifier = "9048801729",
         //            FirstName = "Emi",
         //            MiddleName = "Wyoming",
         //            LastName = "Daniels",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 5, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1730,
         //            //StudentPersonId = 1730,
         //            StateStudentIdentifier = "5411421730",
         //            FirstName = "Amy",
         //            MiddleName = "Graham",
         //            LastName = "Brewer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 12, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1731,
         //            //StudentPersonId = 1731,
         //            StateStudentIdentifier = "7680211731",
         //            FirstName = "Sarah",
         //            MiddleName = "Beverly",
         //            LastName = "Lynch",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 6, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1732,
         //            //StudentPersonId = 1732,
         //            StateStudentIdentifier = "1601061732",
         //            FirstName = "Josiah",
         //            MiddleName = "Hiram",
         //            LastName = "Franks",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 5, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1733,
         //            //StudentPersonId = 1733,
         //            StateStudentIdentifier = "2978351733",
         //            FirstName = "Nissim",
         //            MiddleName = "Xavier",
         //            LastName = "Vega",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1999, 1, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1734,
         //            //StudentPersonId = 1734,
         //            StateStudentIdentifier = "6035871734",
         //            FirstName = "Moses",
         //            MiddleName = "Jonas",
         //            LastName = "Church",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 12, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1735,
         //            //StudentPersonId = 1735,
         //            StateStudentIdentifier = "4996711735",
         //            FirstName = "Regan",
         //            MiddleName = "Samantha",
         //            LastName = "Beach",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2009, 8, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1736,
         //            //StudentPersonId = 1736,
         //            StateStudentIdentifier = "9420711736",
         //            FirstName = "Virginia",
         //            MiddleName = "Breanna",
         //            LastName = "Sharp",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 4, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1737,
         //            //StudentPersonId = 1737,
         //            StateStudentIdentifier = "1037031737",
         //            FirstName = "Eleanor",
         //            MiddleName = "Yvonne",
         //            LastName = "Allison",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2019, 6, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1738,
         //            //StudentPersonId = 1738,
         //            StateStudentIdentifier = "3952601738",
         //            FirstName = "Nehru",
         //            MiddleName = "Palmer",
         //            LastName = "Valdez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 12, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1739,
         //            //StudentPersonId = 1739,
         //            StateStudentIdentifier = "4872731739",
         //            FirstName = "Jaquelyn",
         //            MiddleName = "Veda",
         //            LastName = "Mays",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 2, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1740,
         //            //StudentPersonId = 1740,
         //            StateStudentIdentifier = "8289341740",
         //            FirstName = "Destiny",
         //            MiddleName = "Dora",
         //            LastName = "Rodgers",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 3, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1741,
         //            //StudentPersonId = 1741,
         //            StateStudentIdentifier = "1137041741",
         //            FirstName = "Vernon",
         //            MiddleName = "Russell",
         //            LastName = "Cohen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 1, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1742,
         //            //StudentPersonId = 1742,
         //            StateStudentIdentifier = "1796901742",
         //            FirstName = "Nolan",
         //            MiddleName = "Kyla",
         //            LastName = "Morales",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 1, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1743,
         //            //StudentPersonId = 1743,
         //            StateStudentIdentifier = "5005131743",
         //            FirstName = "Lunea",
         //            MiddleName = "Karen",
         //            LastName = "Stevens",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2008, 2, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1744,
         //            //StudentPersonId = 1744,
         //            StateStudentIdentifier = "1420881744",
         //            FirstName = "Mason",
         //            MiddleName = "Xenos",
         //            LastName = "Gibson",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 3, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1745,
         //            //StudentPersonId = 1745,
         //            StateStudentIdentifier = "2992281745",
         //            FirstName = "Caleb",
         //            MiddleName = "Gabriel",
         //            LastName = "Merritt",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 10, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1746,
         //            //StudentPersonId = 1746,
         //            StateStudentIdentifier = "7733471746",
         //            FirstName = "Mia",
         //            MiddleName = "Dai",
         //            LastName = "Meyers",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 1, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1747,
         //            //StudentPersonId = 1747,
         //            StateStudentIdentifier = "6636631747",
         //            FirstName = "Jayme",
         //            MiddleName = "Kalia",
         //            LastName = "Gutierrez",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1998, 1, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1748,
         //            //StudentPersonId = 1748,
         //            StateStudentIdentifier = "0078281748",
         //            FirstName = "Jacob",
         //            MiddleName = "Kirk",
         //            LastName = "Conway",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 1, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1749,
         //            //StudentPersonId = 1749,
         //            StateStudentIdentifier = "5172901749",
         //            FirstName = "Urielle",
         //            MiddleName = "Iliana",
         //            LastName = "Bailey",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 6, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1750,
         //            //StudentPersonId = 1750,
         //            StateStudentIdentifier = "7632551750",
         //            FirstName = "August",
         //            MiddleName = "Dexter",
         //            LastName = "Finley",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2009, 1, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1751,
         //            //StudentPersonId = 1751,
         //            StateStudentIdentifier = "5483211751",
         //            FirstName = "Hu",
         //            MiddleName = "John",
         //            LastName = "Brady",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2018, 12, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1752,
         //            //StudentPersonId = 1752,
         //            StateStudentIdentifier = "3062181752",
         //            FirstName = "Eliana",
         //            MiddleName = "Nada",
         //            LastName = "Spencer",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2010, 6, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1753,
         //            //StudentPersonId = 1753,
         //            StateStudentIdentifier = "8461611753",
         //            FirstName = "Jemima",
         //            MiddleName = "Nomlanga",
         //            LastName = "Reynolds",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 11, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1754,
         //            //StudentPersonId = 1754,
         //            StateStudentIdentifier = "7196561754",
         //            FirstName = "Timothy",
         //            MiddleName = "Adrian",
         //            LastName = "Hodges",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 8, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1755,
         //            //StudentPersonId = 1755,
         //            StateStudentIdentifier = "6660101755",
         //            FirstName = "Ian",
         //            MiddleName = "Holmes",
         //            LastName = "Hebert",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 9, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1756,
         //            //StudentPersonId = 1756,
         //            StateStudentIdentifier = "2185711756",
         //            FirstName = "Xenos",
         //            MiddleName = "Josiah",
         //            LastName = "Riggs",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1999, 9, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1757,
         //            //StudentPersonId = 1757,
         //            StateStudentIdentifier = "7302221757",
         //            FirstName = "Damian",
         //            MiddleName = "Bevis",
         //            LastName = "Dennis",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 10, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1758,
         //            //StudentPersonId = 1758,
         //            StateStudentIdentifier = "2784471758",
         //            FirstName = "Cassady",
         //            MiddleName = "Laurel",
         //            LastName = "Whitehead",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 11, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1759,
         //            //StudentPersonId = 1759,
         //            StateStudentIdentifier = "8315271759",
         //            FirstName = "Barry",
         //            MiddleName = "Cedric",
         //            LastName = "Guthrie",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 11, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1760,
         //            //StudentPersonId = 1760,
         //            StateStudentIdentifier = "9533521760",
         //            FirstName = "Clarke",
         //            MiddleName = "Driscoll",
         //            LastName = "Griffith",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 4, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1761,
         //            //StudentPersonId = 1761,
         //            StateStudentIdentifier = "2683901761",
         //            FirstName = "Nada",
         //            MiddleName = "Latifah",
         //            LastName = "Holt",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1999, 7, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1762,
         //            //StudentPersonId = 1762,
         //            StateStudentIdentifier = "5979761762",
         //            FirstName = "Ivan",
         //            MiddleName = "Nissim",
         //            LastName = "Bird",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 11, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1763,
         //            //StudentPersonId = 1763,
         //            StateStudentIdentifier = "1730811763",
         //            FirstName = "Isadora",
         //            MiddleName = "Wendy",
         //            LastName = "Silva",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 6, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1764,
         //            //StudentPersonId = 1764,
         //            StateStudentIdentifier = "3360301764",
         //            FirstName = "Acton",
         //            MiddleName = "John",
         //            LastName = "Banks",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1995, 6, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1765,
         //            //StudentPersonId = 1765,
         //            StateStudentIdentifier = "1521631765",
         //            FirstName = "Finn",
         //            MiddleName = "Holmes",
         //            LastName = "Ewing",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1997, 8, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1766,
         //            //StudentPersonId = 1766,
         //            StateStudentIdentifier = "2291611766",
         //            FirstName = "Alec",
         //            MiddleName = "Kaseem",
         //            LastName = "Kirk",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 4, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1767,
         //            //StudentPersonId = 1767,
         //            StateStudentIdentifier = "1067621767",
         //            FirstName = "Oliver",
         //            MiddleName = "Carl",
         //            LastName = "Fisher",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 9, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1768,
         //            //StudentPersonId = 1768,
         //            StateStudentIdentifier = "8672051768",
         //            FirstName = "Anil",
         //            MiddleName = "Simon",
         //            LastName = "Sandoval",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 9, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1769,
         //            //StudentPersonId = 1769,
         //            StateStudentIdentifier = "4844271769",
         //            FirstName = "Nicole",
         //            MiddleName = "Adena",
         //            LastName = "Horn",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 7, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1770,
         //            //StudentPersonId = 1770,
         //            StateStudentIdentifier = "1946891770",
         //            FirstName = "Sade",
         //            MiddleName = "Marcia",
         //            LastName = "Cleveland",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 10, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1771,
         //            //StudentPersonId = 1771,
         //            StateStudentIdentifier = "4942531771",
         //            FirstName = "Callum",
         //            MiddleName = "Michael",
         //            LastName = "Chaney",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 12, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1772,
         //            //StudentPersonId = 1772,
         //            StateStudentIdentifier = "8756401772",
         //            FirstName = "Lucius",
         //            MiddleName = "Benjamin",
         //            LastName = "Powell",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 8, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1773,
         //            //StudentPersonId = 1773,
         //            StateStudentIdentifier = "1165001773",
         //            FirstName = "Sage",
         //            MiddleName = "Unity",
         //            LastName = "Hopkins",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 9, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1774,
         //            //StudentPersonId = 1774,
         //            StateStudentIdentifier = "2094061774",
         //            FirstName = "Marny",
         //            MiddleName = "Dana",
         //            LastName = "Aguirre",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2005, 1, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1775,
         //            //StudentPersonId = 1775,
         //            StateStudentIdentifier = "5875331775",
         //            FirstName = "Wallace",
         //            MiddleName = "Alec",
         //            LastName = "Patel",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 7, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1776,
         //            //StudentPersonId = 1776,
         //            StateStudentIdentifier = "2613941776",
         //            FirstName = "Genevieve",
         //            MiddleName = "Cally",
         //            LastName = "Dorsey",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(1995, 7, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1777,
         //            //StudentPersonId = 1777,
         //            StateStudentIdentifier = "7006151777",
         //            FirstName = "Amos",
         //            MiddleName = "Benjamin",
         //            LastName = "Holloway",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 3, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1778,
         //            //StudentPersonId = 1778,
         //            StateStudentIdentifier = "7764581778",
         //            FirstName = "Kylan",
         //            MiddleName = "Isadora",
         //            LastName = "Rivers",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2014, 12, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1779,
         //            //StudentPersonId = 1779,
         //            StateStudentIdentifier = "1894271779",
         //            FirstName = "Seth",
         //            MiddleName = "Nero",
         //            LastName = "Juarez",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2004, 2, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1780,
         //            //StudentPersonId = 1780,
         //            StateStudentIdentifier = "3456281780",
         //            FirstName = "Oscar",
         //            MiddleName = "Knox",
         //            LastName = "Sims",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 2, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1781,
         //            //StudentPersonId = 1781,
         //            StateStudentIdentifier = "3304981781",
         //            FirstName = "Zeus",
         //            MiddleName = "Eaton",
         //            LastName = "Townsend",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2004, 1, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1782,
         //            //StudentPersonId = 1782,
         //            StateStudentIdentifier = "7409531782",
         //            FirstName = "Kalia",
         //            MiddleName = "Nyssa",
         //            LastName = "Gilliam",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 9, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1783,
         //            //StudentPersonId = 1783,
         //            StateStudentIdentifier = "8437891783",
         //            FirstName = "Dale",
         //            MiddleName = "Ulric",
         //            LastName = "Velasquez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 2, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1784,
         //            //StudentPersonId = 1784,
         //            StateStudentIdentifier = "3536801784",
         //            FirstName = "Jaquelyn",
         //            MiddleName = "Bethany",
         //            LastName = "Lopez",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2000, 12, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1785,
         //            //StudentPersonId = 1785,
         //            StateStudentIdentifier = "5728351785",
         //            FirstName = "Hanna",
         //            MiddleName = "Randall",
         //            LastName = "Curtis",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(1999, 2, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1786,
         //            //StudentPersonId = 1786,
         //            StateStudentIdentifier = "1928351786",
         //            FirstName = "Cherokee",
         //            MiddleName = "Dorothy",
         //            LastName = "Elliott",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 11, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1787,
         //            //StudentPersonId = 1787,
         //            StateStudentIdentifier = "9565061787",
         //            FirstName = "Kimberley",
         //            MiddleName = "Hyacinth",
         //            LastName = "Cleveland",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 7, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1788,
         //            //StudentPersonId = 1788,
         //            StateStudentIdentifier = "8976491788",
         //            FirstName = "Justine",
         //            MiddleName = "Aubrey",
         //            LastName = "Roth",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2019, 9, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1789,
         //            //StudentPersonId = 1789,
         //            StateStudentIdentifier = "1862001789",
         //            FirstName = "Jayme",
         //            MiddleName = "Shoshana",
         //            LastName = "Cohen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 12, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1790,
         //            //StudentPersonId = 1790,
         //            StateStudentIdentifier = "4490161790",
         //            FirstName = "Dominique",
         //            MiddleName = "Willow",
         //            LastName = "Yates",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 1, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1791,
         //            //StudentPersonId = 1791,
         //            StateStudentIdentifier = "4073561791",
         //            FirstName = "Maisie",
         //            MiddleName = "Brenna",
         //            LastName = "Slater",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 6, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1792,
         //            //StudentPersonId = 1792,
         //            StateStudentIdentifier = "9306501792",
         //            FirstName = "Larissa",
         //            MiddleName = "Noelani",
         //            LastName = "Castillo",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 2, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1793,
         //            //StudentPersonId = 1793,
         //            StateStudentIdentifier = "7575511793",
         //            FirstName = "Jakeem",
         //            MiddleName = "Gavin",
         //            LastName = "Justice",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 12, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1794,
         //            //StudentPersonId = 1794,
         //            StateStudentIdentifier = "2163811794",
         //            FirstName = "Guinevere",
         //            MiddleName = "Rina",
         //            LastName = "Lambert",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 11, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1795,
         //            //StudentPersonId = 1795,
         //            StateStudentIdentifier = "6143921795",
         //            FirstName = "Lilah",
         //            MiddleName = "Phoebe",
         //            LastName = "Townsend",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2018, 4, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1796,
         //            //StudentPersonId = 1796,
         //            StateStudentIdentifier = "1163671796",
         //            FirstName = "Armando",
         //            MiddleName = "Quinlan",
         //            LastName = "Curtis",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 12, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1797,
         //            //StudentPersonId = 1797,
         //            StateStudentIdentifier = "2283561797",
         //            FirstName = "Bethany",
         //            MiddleName = "Ayanna",
         //            LastName = "Reed",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2018, 4, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1798,
         //            //StudentPersonId = 1798,
         //            StateStudentIdentifier = "4642931798",
         //            FirstName = "Vivian",
         //            MiddleName = "Noelle",
         //            LastName = "Richmond",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 8, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1799,
         //            //StudentPersonId = 1799,
         //            StateStudentIdentifier = "2293221799",
         //            FirstName = "Sybil",
         //            MiddleName = "Daphne",
         //            LastName = "Lott",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 5, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1800,
         //            //StudentPersonId = 1800,
         //            StateStudentIdentifier = "8072831800",
         //            FirstName = "Isabelle",
         //            MiddleName = "Blaine",
         //            LastName = "Jefferson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 2, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1801,
         //            //StudentPersonId = 1801,
         //            StateStudentIdentifier = "4021311801",
         //            FirstName = "Mason",
         //            MiddleName = "Elijah",
         //            LastName = "Gregory",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 12, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1802,
         //            //StudentPersonId = 1802,
         //            StateStudentIdentifier = "4779891802",
         //            FirstName = "Owen",
         //            MiddleName = "Xavier",
         //            LastName = "Sutton",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2001, 4, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1803,
         //            //StudentPersonId = 1803,
         //            StateStudentIdentifier = "9010371803",
         //            FirstName = "Jerome",
         //            MiddleName = "Zane",
         //            LastName = "Shelton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 3, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1804,
         //            //StudentPersonId = 1804,
         //            StateStudentIdentifier = "3337131804",
         //            FirstName = "Willow",
         //            MiddleName = "Sara",
         //            LastName = "Manning",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2002, 3, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1805,
         //            //StudentPersonId = 1805,
         //            StateStudentIdentifier = "4981371805",
         //            FirstName = "Denise",
         //            MiddleName = "Charde",
         //            LastName = "Castro",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 9, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1806,
         //            //StudentPersonId = 1806,
         //            StateStudentIdentifier = "0071851806",
         //            FirstName = "Addison",
         //            MiddleName = "Raja",
         //            LastName = "Head",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 12, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1807,
         //            //StudentPersonId = 1807,
         //            StateStudentIdentifier = "6157481807",
         //            FirstName = "Devin",
         //            MiddleName = "Xanthus",
         //            LastName = "Nielsen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 8, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1808,
         //            //StudentPersonId = 1808,
         //            StateStudentIdentifier = "9222251808",
         //            FirstName = "Isadora",
         //            MiddleName = "Shaine",
         //            LastName = "Nielsen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 1, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1809,
         //            //StudentPersonId = 1809,
         //            StateStudentIdentifier = "1607091809",
         //            FirstName = "Hoyt",
         //            MiddleName = "Graham",
         //            LastName = "Newton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 3, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1810,
         //            //StudentPersonId = 1810,
         //            StateStudentIdentifier = "5400621810",
         //            FirstName = "Jackson",
         //            MiddleName = "Tad",
         //            LastName = "Strickland",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 5, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1811,
         //            //StudentPersonId = 1811,
         //            StateStudentIdentifier = "8865311811",
         //            FirstName = "Douglas",
         //            MiddleName = "Solomon",
         //            LastName = "Warner",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 9, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1812,
         //            //StudentPersonId = 1812,
         //            StateStudentIdentifier = "5246561812",
         //            FirstName = "Holly",
         //            MiddleName = "Lacota",
         //            LastName = "Gonzales",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1997, 4, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1813,
         //            //StudentPersonId = 1813,
         //            StateStudentIdentifier = "5798811813",
         //            FirstName = "April",
         //            MiddleName = "Sierra",
         //            LastName = "Ryan",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 2, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1814,
         //            //StudentPersonId = 1814,
         //            StateStudentIdentifier = "5988321814",
         //            FirstName = "Mikayla",
         //            MiddleName = "Ifeoma",
         //            LastName = "Hart",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 1, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1815,
         //            //StudentPersonId = 1815,
         //            StateStudentIdentifier = "3026111815",
         //            FirstName = "Ezekiel",
         //            MiddleName = "Alexander",
         //            LastName = "Phelps",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2014, 4, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1816,
         //            //StudentPersonId = 1816,
         //            StateStudentIdentifier = "6316991816",
         //            FirstName = "Margaret",
         //            MiddleName = "Hilel",
         //            LastName = "Golden",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 9, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1817,
         //            //StudentPersonId = 1817,
         //            StateStudentIdentifier = "5655751817",
         //            FirstName = "Erica",
         //            MiddleName = "Maggie",
         //            LastName = "Beach",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 10, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1818,
         //            //StudentPersonId = 1818,
         //            StateStudentIdentifier = "8495601818",
         //            FirstName = "Ryder",
         //            MiddleName = "Mufutau",
         //            LastName = "Carter",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 12, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1819,
         //            //StudentPersonId = 1819,
         //            StateStudentIdentifier = "0084331819",
         //            FirstName = "August",
         //            MiddleName = "Lane",
         //            LastName = "Jensen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 4, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1820,
         //            //StudentPersonId = 1820,
         //            StateStudentIdentifier = "3360911820",
         //            FirstName = "Germane",
         //            MiddleName = "Rhea",
         //            LastName = "Carter",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 9, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1821,
         //            //StudentPersonId = 1821,
         //            StateStudentIdentifier = "1257001821",
         //            FirstName = "Molly",
         //            MiddleName = "Pandora",
         //            LastName = "Deleon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 5, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1822,
         //            //StudentPersonId = 1822,
         //            StateStudentIdentifier = "8373691822",
         //            FirstName = "Yoko",
         //            MiddleName = "Dai",
         //            LastName = "Mann",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2007, 6, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1823,
         //            //StudentPersonId = 1823,
         //            StateStudentIdentifier = "4009201823",
         //            FirstName = "Uta",
         //            MiddleName = "Adena",
         //            LastName = "Hoover",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2007, 11, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1824,
         //            //StudentPersonId = 1824,
         //            StateStudentIdentifier = "0794581824",
         //            FirstName = "Dennis",
         //            MiddleName = "Colin",
         //            LastName = "Frazier",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2017, 5, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1825,
         //            //StudentPersonId = 1825,
         //            StateStudentIdentifier = "3756131825",
         //            FirstName = "Raja",
         //            MiddleName = "Shad",
         //            LastName = "Shepherd",
         //            Cohort = null,
         //            BirthDate = new DateTime(2003, 12, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1826,
         //            //StudentPersonId = 1826,
         //            StateStudentIdentifier = "4864871826",
         //            FirstName = "Candice",
         //            MiddleName = "Yvette",
         //            LastName = "Molina",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 12, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1827,
         //            //StudentPersonId = 1827,
         //            StateStudentIdentifier = "4208991827",
         //            FirstName = "Hamish",
         //            MiddleName = "Arden",
         //            LastName = "Glass",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 12, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1828,
         //            //StudentPersonId = 1828,
         //            StateStudentIdentifier = "2762011828",
         //            FirstName = "Galvin",
         //            MiddleName = "Vincent",
         //            LastName = "Little",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2007, 2, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1829,
         //            //StudentPersonId = 1829,
         //            StateStudentIdentifier = "0443681829",
         //            FirstName = "Shay",
         //            MiddleName = "Carla",
         //            LastName = "Chandler",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 3, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1830,
         //            //StudentPersonId = 1830,
         //            StateStudentIdentifier = "5754451830",
         //            FirstName = "Whoopi",
         //            MiddleName = "Mechelle",
         //            LastName = "Fry",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 8, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1831,
         //            //StudentPersonId = 1831,
         //            StateStudentIdentifier = "5022431831",
         //            FirstName = "Guy",
         //            MiddleName = "Leo",
         //            LastName = "Collins",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 2, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1832,
         //            //StudentPersonId = 1832,
         //            StateStudentIdentifier = "8949341832",
         //            FirstName = "Finn",
         //            MiddleName = "Hoyt",
         //            LastName = "Fisher",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2002, 12, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1833,
         //            //StudentPersonId = 1833,
         //            StateStudentIdentifier = "8448561833",
         //            FirstName = "Drake",
         //            MiddleName = "Beck",
         //            LastName = "Randall",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2016, 4, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1834,
         //            //StudentPersonId = 1834,
         //            StateStudentIdentifier = "3376771834",
         //            FirstName = "Wyoming",
         //            MiddleName = "Maggie",
         //            LastName = "Daniel",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1996, 10, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1835,
         //            //StudentPersonId = 1835,
         //            StateStudentIdentifier = "9083201835",
         //            FirstName = "Maia",
         //            MiddleName = "Dean",
         //            LastName = "Cain",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 9, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1836,
         //            //StudentPersonId = 1836,
         //            StateStudentIdentifier = "0176581836",
         //            FirstName = "Travis",
         //            MiddleName = "Cole",
         //            LastName = "Chandler",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 8, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1837,
         //            //StudentPersonId = 1837,
         //            StateStudentIdentifier = "8055561837",
         //            FirstName = "Brianna",
         //            MiddleName = "Stella",
         //            LastName = "Edwards",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2003, 9, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1838,
         //            //StudentPersonId = 1838,
         //            StateStudentIdentifier = "1237081838",
         //            FirstName = "Dolan",
         //            MiddleName = "Vincent",
         //            LastName = "Dejesus",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 10, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1839,
         //            //StudentPersonId = 1839,
         //            StateStudentIdentifier = "2649421839",
         //            FirstName = "Brock",
         //            MiddleName = "Leroy",
         //            LastName = "Clemons",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 9, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1840,
         //            //StudentPersonId = 1840,
         //            StateStudentIdentifier = "8305221840",
         //            FirstName = "Kenneth",
         //            MiddleName = "Scarlett",
         //            LastName = "Mays",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 5, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1841,
         //            //StudentPersonId = 1841,
         //            StateStudentIdentifier = "0851021841",
         //            FirstName = "Madaline",
         //            MiddleName = "Charlotte",
         //            LastName = "Carroll",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 9, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1842,
         //            //StudentPersonId = 1842,
         //            StateStudentIdentifier = "5982371842",
         //            FirstName = "Evangeline",
         //            MiddleName = "Kaitlin",
         //            LastName = "Gossling",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2007, 11, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1843,
         //            //StudentPersonId = 1843,
         //            StateStudentIdentifier = "4789581843",
         //            FirstName = "Joelle",
         //            MiddleName = "Ana",
         //            LastName = "Woodard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 6, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1844,
         //            //StudentPersonId = 1844,
         //            StateStudentIdentifier = "0402001844",
         //            FirstName = "Jakeem",
         //            MiddleName = "Francis",
         //            LastName = "Mann",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 1, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1845,
         //            //StudentPersonId = 1845,
         //            StateStudentIdentifier = "3067051845",
         //            FirstName = "Jordan",
         //            MiddleName = "Garth",
         //            LastName = "Romero",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 4, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1846,
         //            //StudentPersonId = 1846,
         //            StateStudentIdentifier = "9470471846",
         //            FirstName = "Hadley",
         //            MiddleName = "Inez",
         //            LastName = "Pollard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 3, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1847,
         //            //StudentPersonId = 1847,
         //            StateStudentIdentifier = "3529381847",
         //            FirstName = "Mason",
         //            MiddleName = "Kevin",
         //            LastName = "Trujillo",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 3, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1848,
         //            //StudentPersonId = 1848,
         //            StateStudentIdentifier = "0499551848",
         //            FirstName = "Edan",
         //            MiddleName = "Zeph",
         //            LastName = "Berg",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 12, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1849,
         //            //StudentPersonId = 1849,
         //            StateStudentIdentifier = "4000231849",
         //            FirstName = "Natalie",
         //            MiddleName = "Fleur",
         //            LastName = "Brown",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2010, 12, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1850,
         //            //StudentPersonId = 1850,
         //            StateStudentIdentifier = "6243761850",
         //            FirstName = "Lee",
         //            MiddleName = "Dale",
         //            LastName = "Warner",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 12, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1851,
         //            //StudentPersonId = 1851,
         //            StateStudentIdentifier = "7158491851",
         //            FirstName = "Jessica",
         //            MiddleName = "Kiona",
         //            LastName = "Gilmore",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 9, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1852,
         //            //StudentPersonId = 1852,
         //            StateStudentIdentifier = "9533771852",
         //            FirstName = "Nadine",
         //            MiddleName = "Shoshana",
         //            LastName = "Hansen",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 12, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1853,
         //            //StudentPersonId = 1853,
         //            StateStudentIdentifier = "5190141853",
         //            FirstName = "Kiara",
         //            MiddleName = "Lucy",
         //            LastName = "Bird",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 10, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1854,
         //            //StudentPersonId = 1854,
         //            StateStudentIdentifier = "7470091854",
         //            FirstName = "Harrison",
         //            MiddleName = "William",
         //            LastName = "Chang",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 6, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1855,
         //            //StudentPersonId = 1855,
         //            StateStudentIdentifier = "3719461855",
         //            FirstName = "Indigo",
         //            MiddleName = "Anne",
         //            LastName = "Riggs",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2005, 1, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1856,
         //            //StudentPersonId = 1856,
         //            StateStudentIdentifier = "9649411856",
         //            FirstName = "Zeph",
         //            MiddleName = "Hyatt",
         //            LastName = "Sparks",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 7, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1857,
         //            //StudentPersonId = 1857,
         //            StateStudentIdentifier = "7924841857",
         //            FirstName = "Robert",
         //            MiddleName = "Austin",
         //            LastName = "Pena",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 8, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1858,
         //            //StudentPersonId = 1858,
         //            StateStudentIdentifier = "9740171858",
         //            FirstName = "Evan",
         //            MiddleName = "Alyssa",
         //            LastName = "Delacruz",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 12, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1859,
         //            //StudentPersonId = 1859,
         //            StateStudentIdentifier = "0122591859",
         //            FirstName = "Sumanth",
         //            MiddleName = "Benedict",
         //            LastName = "Hanson",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2012, 6, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1860,
         //            //StudentPersonId = 1860,
         //            StateStudentIdentifier = "7377801860",
         //            FirstName = "Madeline",
         //            MiddleName = "Quinlan",
         //            LastName = "Burton",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2005, 7, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1861,
         //            //StudentPersonId = 1861,
         //            StateStudentIdentifier = "9741051861",
         //            FirstName = "Orli",
         //            MiddleName = "Malik",
         //            LastName = "Gentry",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 3, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1862,
         //            //StudentPersonId = 1862,
         //            StateStudentIdentifier = "6952691862",
         //            FirstName = "Drake",
         //            MiddleName = "Doug",
         //            LastName = "Bennett",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 11, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1863,
         //            //StudentPersonId = 1863,
         //            StateStudentIdentifier = "9263711863",
         //            FirstName = "MacKensie",
         //            MiddleName = "Sigourney",
         //            LastName = "Arnold",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 5, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1864,
         //            //StudentPersonId = 1864,
         //            StateStudentIdentifier = "3980151864",
         //            FirstName = "Dorian",
         //            MiddleName = "Jared",
         //            LastName = "Nieves",
         //            Cohort = null,
         //            BirthDate = new DateTime(2019, 2, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1865,
         //            //StudentPersonId = 1865,
         //            StateStudentIdentifier = "3699411865",
         //            FirstName = "Cally",
         //            MiddleName = "Farrah",
         //            LastName = "Petersen",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2009, 8, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1866,
         //            //StudentPersonId = 1866,
         //            StateStudentIdentifier = "4063471866",
         //            FirstName = "Hollee",
         //            MiddleName = "Pavel",
         //            LastName = "Gaines",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 1, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1867,
         //            //StudentPersonId = 1867,
         //            StateStudentIdentifier = "5868791867",
         //            FirstName = "Miranda",
         //            MiddleName = "Shelly",
         //            LastName = "Burch",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 3, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1868,
         //            //StudentPersonId = 1868,
         //            StateStudentIdentifier = "2905851868",
         //            FirstName = "Keaton",
         //            MiddleName = "Amery",
         //            LastName = "Collins",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 7, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1869,
         //            //StudentPersonId = 1869,
         //            StateStudentIdentifier = "0722761869",
         //            FirstName = "Lenore",
         //            MiddleName = "Mercedes",
         //            LastName = "Church",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 3, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1870,
         //            //StudentPersonId = 1870,
         //            StateStudentIdentifier = "1430301870",
         //            FirstName = "Kathleen",
         //            MiddleName = "Illana",
         //            LastName = "Aguirre",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 1, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1871,
         //            //StudentPersonId = 1871,
         //            StateStudentIdentifier = "7035301871",
         //            FirstName = "Randall",
         //            MiddleName = "Doug",
         //            LastName = "Meyers",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2004, 9, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1872,
         //            //StudentPersonId = 1872,
         //            StateStudentIdentifier = "2011701872",
         //            FirstName = "Alec",
         //            MiddleName = "Berk",
         //            LastName = "Arnold",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 4, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1873,
         //            //StudentPersonId = 1873,
         //            StateStudentIdentifier = "8876321873",
         //            FirstName = "Amelia",
         //            MiddleName = "Echo",
         //            LastName = "Colon",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2011, 12, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1874,
         //            //StudentPersonId = 1874,
         //            StateStudentIdentifier = "2611931874",
         //            FirstName = "Amery",
         //            MiddleName = "Noah",
         //            LastName = "Edwards",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 7, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1875,
         //            //StudentPersonId = 1875,
         //            StateStudentIdentifier = "6093221875",
         //            FirstName = "Meredith",
         //            MiddleName = "Deacon",
         //            LastName = "Valencia",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 11, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1876,
         //            //StudentPersonId = 1876,
         //            StateStudentIdentifier = "4207731876",
         //            FirstName = "Carla",
         //            MiddleName = "Karen",
         //            LastName = "Patel",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 3, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1877,
         //            //StudentPersonId = 1877,
         //            StateStudentIdentifier = "1544611877",
         //            FirstName = "Holmes",
         //            MiddleName = "Avram",
         //            LastName = "Castro",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 6, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1878,
         //            //StudentPersonId = 1878,
         //            StateStudentIdentifier = "2300141878",
         //            FirstName = "Jolie",
         //            MiddleName = "Madison",
         //            LastName = "Oneal",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 11, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1879,
         //            //StudentPersonId = 1879,
         //            StateStudentIdentifier = "5842151879",
         //            FirstName = "Baker",
         //            MiddleName = "Ronan",
         //            LastName = "Mayo",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 8, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1880,
         //            //StudentPersonId = 1880,
         //            StateStudentIdentifier = "3922721880",
         //            FirstName = "Ina",
         //            MiddleName = "Ariel",
         //            LastName = "Price",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 1, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1881,
         //            //StudentPersonId = 1881,
         //            StateStudentIdentifier = "7223801881",
         //            FirstName = "Perry",
         //            MiddleName = "Drew",
         //            LastName = "Lott",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 8, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1882,
         //            //StudentPersonId = 1882,
         //            StateStudentIdentifier = "5385591882",
         //            FirstName = "Hunter",
         //            MiddleName = "Rajeev",
         //            LastName = "Montgomery",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 7, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1883,
         //            //StudentPersonId = 1883,
         //            StateStudentIdentifier = "5345011883",
         //            FirstName = "Anne",
         //            MiddleName = "Alec",
         //            LastName = "Acosta",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 7, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1884,
         //            //StudentPersonId = 1884,
         //            StateStudentIdentifier = "9968831884",
         //            FirstName = "Oprah",
         //            MiddleName = "Reagan",
         //            LastName = "Sellers",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 4, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1885,
         //            //StudentPersonId = 1885,
         //            StateStudentIdentifier = "7289141885",
         //            FirstName = "Carl",
         //            MiddleName = "Yasir",
         //            LastName = "Stevens",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 7, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1886,
         //            //StudentPersonId = 1886,
         //            StateStudentIdentifier = "0512061886",
         //            FirstName = "Warren",
         //            MiddleName = "Stuart",
         //            LastName = "Salinas",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 1, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1887,
         //            //StudentPersonId = 1887,
         //            StateStudentIdentifier = "8615841887",
         //            FirstName = "Tatum",
         //            MiddleName = "Fritz",
         //            LastName = "Lindsay",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 12, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1888,
         //            //StudentPersonId = 1888,
         //            StateStudentIdentifier = "7540511888",
         //            FirstName = "Zephania",
         //            MiddleName = "Dean",
         //            LastName = "Pollard",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 9, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1889,
         //            //StudentPersonId = 1889,
         //            StateStudentIdentifier = "2254711889",
         //            FirstName = "Alexander",
         //            MiddleName = "Ian",
         //            LastName = "Clark",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 12, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1890,
         //            //StudentPersonId = 1890,
         //            StateStudentIdentifier = "8346911890",
         //            FirstName = "Cheyenne",
         //            MiddleName = "Moana",
         //            LastName = "Chang",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 11, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1891,
         //            //StudentPersonId = 1891,
         //            StateStudentIdentifier = "5930701891",
         //            FirstName = "Gary",
         //            MiddleName = "Elmo",
         //            LastName = "Bell",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1998, 9, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1892,
         //            //StudentPersonId = 1892,
         //            StateStudentIdentifier = "7953741892",
         //            FirstName = "Tate",
         //            MiddleName = "Hyatt",
         //            LastName = "Johns",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 10, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1893,
         //            //StudentPersonId = 1893,
         //            StateStudentIdentifier = "8049101893",
         //            FirstName = "Sawyer",
         //            MiddleName = "Griffin",
         //            LastName = "Whitfield",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 11, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1894,
         //            //StudentPersonId = 1894,
         //            StateStudentIdentifier = "4261351894",
         //            FirstName = "Zenaida",
         //            MiddleName = "Kiona",
         //            LastName = "Sharpe",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1997, 9, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1895,
         //            //StudentPersonId = 1895,
         //            StateStudentIdentifier = "1146541895",
         //            FirstName = "Ferdinand",
         //            MiddleName = "Mufutau",
         //            LastName = "Brady",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 8, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1896,
         //            //StudentPersonId = 1896,
         //            StateStudentIdentifier = "0082721896",
         //            FirstName = "Fulton",
         //            MiddleName = "Flynn",
         //            LastName = "Williamson",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2009, 5, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1897,
         //            //StudentPersonId = 1897,
         //            StateStudentIdentifier = "3685911897",
         //            FirstName = "Eden",
         //            MiddleName = "Macy",
         //            LastName = "Hanson",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2000, 7, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1898,
         //            //StudentPersonId = 1898,
         //            StateStudentIdentifier = "8972721898",
         //            FirstName = "Josiah",
         //            MiddleName = "Minerva",
         //            LastName = "Oneal",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1996, 6, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1899,
         //            //StudentPersonId = 1899,
         //            StateStudentIdentifier = "3233061899",
         //            FirstName = "Aurora",
         //            MiddleName = "Tana",
         //            LastName = "Compton",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 6, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1900,
         //            //StudentPersonId = 1900,
         //            StateStudentIdentifier = "9728461900",
         //            FirstName = "Perry",
         //            MiddleName = "Cairo",
         //            LastName = "Finley",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 9, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1901,
         //            //StudentPersonId = 1901,
         //            StateStudentIdentifier = "2427491901",
         //            FirstName = "Walker",
         //            MiddleName = "Kaseem",
         //            LastName = "Knowles",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2013, 4, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1902,
         //            //StudentPersonId = 1902,
         //            StateStudentIdentifier = "2521271902",
         //            FirstName = "Kalia",
         //            MiddleName = "Upasana",
         //            LastName = "Hurst",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2015, 9, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1903,
         //            //StudentPersonId = 1903,
         //            StateStudentIdentifier = "1173601903",
         //            FirstName = "Shea",
         //            MiddleName = "Andrew",
         //            LastName = "Moon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 6, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1904,
         //            //StudentPersonId = 1904,
         //            StateStudentIdentifier = "2667821904",
         //            FirstName = "Renee",
         //            MiddleName = "Robin",
         //            LastName = "Bruce",
         //            Cohort = null,
         //            BirthDate = new DateTime(2012, 10, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1905,
         //            //StudentPersonId = 1905,
         //            StateStudentIdentifier = "2579681905",
         //            FirstName = "Blaze",
         //            MiddleName = "Caesar",
         //            LastName = "Becker",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 10, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1906,
         //            //StudentPersonId = 1906,
         //            StateStudentIdentifier = "8511661906",
         //            FirstName = "Nathan",
         //            MiddleName = "Austin",
         //            LastName = "Bender",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2001, 11, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1907,
         //            //StudentPersonId = 1907,
         //            StateStudentIdentifier = "4970691907",
         //            FirstName = "Bobby",
         //            MiddleName = "Basil",
         //            LastName = "Justice",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 1, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1908,
         //            //StudentPersonId = 1908,
         //            StateStudentIdentifier = "8027121908",
         //            FirstName = "Cullen",
         //            MiddleName = "Nicholas",
         //            LastName = "Montgomery",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2008, 2, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1909,
         //            //StudentPersonId = 1909,
         //            StateStudentIdentifier = "4776931909",
         //            FirstName = "Cairo",
         //            MiddleName = "Garth",
         //            LastName = "Weaver",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 7, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1910,
         //            //StudentPersonId = 1910,
         //            StateStudentIdentifier = "4057831910",
         //            FirstName = "Leah",
         //            MiddleName = "Hadassah",
         //            LastName = "Schroeder",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 2, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1911,
         //            //StudentPersonId = 1911,
         //            StateStudentIdentifier = "6048701911",
         //            FirstName = "Medge",
         //            MiddleName = "Jorden",
         //            LastName = "Valencia",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 1, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1912,
         //            //StudentPersonId = 1912,
         //            StateStudentIdentifier = "2824071912",
         //            FirstName = "Keefe",
         //            MiddleName = "Gil",
         //            LastName = "Franklin",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 5, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1913,
         //            //StudentPersonId = 1913,
         //            StateStudentIdentifier = "0619491913",
         //            FirstName = "Finn",
         //            MiddleName = "Kato",
         //            LastName = "Leach",
         //            Cohort = null,
         //            BirthDate = new DateTime(1995, 7, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1914,
         //            //StudentPersonId = 1914,
         //            StateStudentIdentifier = "2806071914",
         //            FirstName = "Blair",
         //            MiddleName = "Delilah",
         //            LastName = "Merritt",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(1998, 5, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1915,
         //            //StudentPersonId = 1915,
         //            StateStudentIdentifier = "4000001915",
         //            FirstName = "Morgan",
         //            MiddleName = "Carly",
         //            LastName = "Gray",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 2, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1916,
         //            //StudentPersonId = 1916,
         //            StateStudentIdentifier = "4382861916",
         //            FirstName = "Lavinia",
         //            MiddleName = "Nadine",
         //            LastName = "Blackwell",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 1, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1917,
         //            //StudentPersonId = 1917,
         //            StateStudentIdentifier = "6527491917",
         //            FirstName = "Dexter",
         //            MiddleName = "Nehru",
         //            LastName = "Santiago",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 5, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1918,
         //            //StudentPersonId = 1918,
         //            StateStudentIdentifier = "1767251918",
         //            FirstName = "Xena",
         //            MiddleName = "Rama",
         //            LastName = "Dorsey",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1995, 10, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1919,
         //            //StudentPersonId = 1919,
         //            StateStudentIdentifier = "1568641919",
         //            FirstName = "Erin",
         //            MiddleName = "Hyacinth",
         //            LastName = "Britt",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1998, 5, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1920,
         //            //StudentPersonId = 1920,
         //            StateStudentIdentifier = "6094511920",
         //            FirstName = "Cairo",
         //            MiddleName = "Amir",
         //            LastName = "Cleveland",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1999, 8, 10),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1921,
         //            //StudentPersonId = 1921,
         //            StateStudentIdentifier = "6213481921",
         //            FirstName = "April",
         //            MiddleName = "Zelda",
         //            LastName = "Boyd",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(1997, 5, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1922,
         //            //StudentPersonId = 1922,
         //            StateStudentIdentifier = "2063431922",
         //            FirstName = "Ignatius",
         //            MiddleName = "Harding",
         //            LastName = "Riggs",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 10, 27),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1923,
         //            //StudentPersonId = 1923,
         //            StateStudentIdentifier = "2866841923",
         //            FirstName = "Thaddeus",
         //            MiddleName = "Laurel",
         //            LastName = "Rojas",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 8, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1924,
         //            //StudentPersonId = 1924,
         //            StateStudentIdentifier = "9354681924",
         //            FirstName = "Colette",
         //            MiddleName = "Joan",
         //            LastName = "Brewer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 7, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1925,
         //            //StudentPersonId = 1925,
         //            StateStudentIdentifier = "9671331925",
         //            FirstName = "Dennis",
         //            MiddleName = "Carson",
         //            LastName = "Mckee",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 8, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1926,
         //            //StudentPersonId = 1926,
         //            StateStudentIdentifier = "6488321926",
         //            FirstName = "Benedict",
         //            MiddleName = "Allistair",
         //            LastName = "Molina",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 9, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1927,
         //            //StudentPersonId = 1927,
         //            StateStudentIdentifier = "7405061927",
         //            FirstName = "Jarrod",
         //            MiddleName = "Duncan",
         //            LastName = "Tyson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 9, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1928,
         //            //StudentPersonId = 1928,
         //            StateStudentIdentifier = "3174761928",
         //            FirstName = "Jackson",
         //            MiddleName = "Herman",
         //            LastName = "Ball",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 10, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1929,
         //            //StudentPersonId = 1929,
         //            StateStudentIdentifier = "0851661929",
         //            FirstName = "Elizabeth",
         //            MiddleName = "Orli",
         //            LastName = "Lindsay",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 9, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1930,
         //            //StudentPersonId = 1930,
         //            StateStudentIdentifier = "5132531930",
         //            FirstName = "Herman",
         //            MiddleName = "Griffith",
         //            LastName = "Whitfield",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 5, 30),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1931,
         //            //StudentPersonId = 1931,
         //            StateStudentIdentifier = "1320371931",
         //            FirstName = "Sloane",
         //            MiddleName = "Lani",
         //            LastName = "Mosley",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2002, 4, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1932,
         //            //StudentPersonId = 1932,
         //            StateStudentIdentifier = "5171231932",
         //            FirstName = "Germane",
         //            MiddleName = "Fredericka",
         //            LastName = "Roman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 3, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1933,
         //            //StudentPersonId = 1933,
         //            StateStudentIdentifier = "9189061933",
         //            FirstName = "Shafira",
         //            MiddleName = "Giselle",
         //            LastName = "Blankenship",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 8, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1934,
         //            //StudentPersonId = 1934,
         //            StateStudentIdentifier = "4317841934",
         //            FirstName = "Jelani",
         //            MiddleName = "Vladimir",
         //            LastName = "Pierce",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2014, 10, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1935,
         //            //StudentPersonId = 1935,
         //            StateStudentIdentifier = "1727011935",
         //            FirstName = "Isabelle",
         //            MiddleName = "Stephanie",
         //            LastName = "Case",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 11, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1936,
         //            //StudentPersonId = 1936,
         //            StateStudentIdentifier = "1527431936",
         //            FirstName = "Herrod",
         //            MiddleName = "Graham",
         //            LastName = "Lindsay",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 9, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1937,
         //            //StudentPersonId = 1937,
         //            StateStudentIdentifier = "4338231937",
         //            FirstName = "Janna",
         //            MiddleName = "Emery",
         //            LastName = "Hardy",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 4, 8),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1938,
         //            //StudentPersonId = 1938,
         //            StateStudentIdentifier = "5695871938",
         //            FirstName = "Noel",
         //            MiddleName = "Stacey",
         //            LastName = "Fitzgerald",
         //            Cohort = null,
         //            BirthDate = new DateTime(2004, 1, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1939,
         //            //StudentPersonId = 1939,
         //            StateStudentIdentifier = "7235811939",
         //            FirstName = "Mechelle",
         //            MiddleName = "Kelly",
         //            LastName = "Fitzgerald",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 3, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1940,
         //            //StudentPersonId = 1940,
         //            StateStudentIdentifier = "4622721940",
         //            FirstName = "Alvin",
         //            MiddleName = "Christopher",
         //            LastName = "Mcmahon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 12, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1941,
         //            //StudentPersonId = 1941,
         //            StateStudentIdentifier = "9313651941",
         //            FirstName = "Galena",
         //            MiddleName = "Cally",
         //            LastName = "Molina",
         //            Cohort = null,
         //            BirthDate = new DateTime(2011, 11, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1942,
         //            //StudentPersonId = 1942,
         //            StateStudentIdentifier = "7275961942",
         //            FirstName = "Fatima",
         //            MiddleName = "Clarke",
         //            LastName = "Rosales",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2010, 6, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1943,
         //            //StudentPersonId = 1943,
         //            StateStudentIdentifier = "3221051943",
         //            FirstName = "Brett",
         //            MiddleName = "Sophia",
         //            LastName = "Valdez",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 5, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1944,
         //            //StudentPersonId = 1944,
         //            StateStudentIdentifier = "8368471944",
         //            FirstName = "Madaline",
         //            MiddleName = "Althea",
         //            LastName = "Miles",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 7, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1945,
         //            //StudentPersonId = 1945,
         //            StateStudentIdentifier = "0318911945",
         //            FirstName = "Laith",
         //            MiddleName = "Harper",
         //            LastName = "Rosales",
         //            Cohort = null,
         //            BirthDate = new DateTime(1998, 2, 5),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1946,
         //            //StudentPersonId = 1946,
         //            StateStudentIdentifier = "5387941946",
         //            FirstName = "Alyssa",
         //            MiddleName = "Tanner",
         //            LastName = "Page",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 9, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1947,
         //            //StudentPersonId = 1947,
         //            StateStudentIdentifier = "0425181947",
         //            FirstName = "Tiger",
         //            MiddleName = "Garrison",
         //            LastName = "Gonzales",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2015, 2, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1948,
         //            //StudentPersonId = 1948,
         //            StateStudentIdentifier = "1410551948",
         //            FirstName = "Francesca",
         //            MiddleName = "Quynn",
         //            LastName = "Dixon",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 3, 19),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1949,
         //            //StudentPersonId = 1949,
         //            StateStudentIdentifier = "8284391949",
         //            FirstName = "Sarah",
         //            MiddleName = "Yael",
         //            LastName = "Graham",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 2, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1950,
         //            //StudentPersonId = 1950,
         //            StateStudentIdentifier = "7125911950",
         //            FirstName = "Damon",
         //            MiddleName = "Tarik",
         //            LastName = "Gray",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(1997, 6, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1951,
         //            //StudentPersonId = 1951,
         //            StateStudentIdentifier = "2328721951",
         //            FirstName = "Quintessa",
         //            MiddleName = "Kaseem",
         //            LastName = "Roach",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 2, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1952,
         //            //StudentPersonId = 1952,
         //            StateStudentIdentifier = "4143551952",
         //            FirstName = "Perry",
         //            MiddleName = "Jameson",
         //            LastName = "Thomas",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2011, 3, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1953,
         //            //StudentPersonId = 1953,
         //            StateStudentIdentifier = "5201991953",
         //            FirstName = "Karen",
         //            MiddleName = "Susan",
         //            LastName = "Horn",
         //            Cohort = null,
         //            BirthDate = new DateTime(2018, 4, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1954,
         //            //StudentPersonId = 1954,
         //            StateStudentIdentifier = "3753401954",
         //            FirstName = "Samantha",
         //            MiddleName = "Alexis",
         //            LastName = "Watson",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2011, 6, 20),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1955,
         //            //StudentPersonId = 1955,
         //            StateStudentIdentifier = "9312321955",
         //            FirstName = "Erich",
         //            MiddleName = "Amir",
         //            LastName = "Michael",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 2, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1956,
         //            //StudentPersonId = 1956,
         //            StateStudentIdentifier = "6338051956",
         //            FirstName = "Daniel",
         //            MiddleName = "Carter",
         //            LastName = "Franco",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2005, 3, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1957,
         //            //StudentPersonId = 1957,
         //            StateStudentIdentifier = "6523831957",
         //            FirstName = "Peter",
         //            MiddleName = "Harper",
         //            LastName = "Mercer",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 5, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1958,
         //            //StudentPersonId = 1958,
         //            StateStudentIdentifier = "7069301958",
         //            FirstName = "Delilah",
         //            MiddleName = "Neve",
         //            LastName = "Harrington",
         //            Cohort = null,
         //            BirthDate = new DateTime(2009, 3, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1959,
         //            //StudentPersonId = 1959,
         //            StateStudentIdentifier = "2105161959",
         //            FirstName = "Sylvester",
         //            MiddleName = "Quamar",
         //            LastName = "Beach",
         //            Cohort = null,
         //            BirthDate = new DateTime(2016, 5, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1960,
         //            //StudentPersonId = 1960,
         //            StateStudentIdentifier = "2894191960",
         //            FirstName = "Clinton",
         //            MiddleName = "Jamal",
         //            LastName = "Porter",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(1996, 7, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1961,
         //            //StudentPersonId = 1961,
         //            StateStudentIdentifier = "0974401961",
         //            FirstName = "Alea",
         //            MiddleName = "Davis",
         //            LastName = "Olsen",
         //            Cohort = "2017-2021",
         //            BirthDate = new DateTime(2019, 5, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1962,
         //            //StudentPersonId = 1962,
         //            StateStudentIdentifier = "1721051962",
         //            FirstName = "Hop",
         //            MiddleName = "Raphael",
         //            LastName = "Mcgee",
         //            Cohort = null,
         //            BirthDate = new DateTime(2010, 1, 29),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1963,
         //            //StudentPersonId = 1963,
         //            StateStudentIdentifier = "3092921963",
         //            FirstName = "Dacey",
         //            MiddleName = "Brianna",
         //            LastName = "Battle",
         //            Cohort = null,
         //            BirthDate = new DateTime(2006, 10, 28),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1964,
         //            //StudentPersonId = 1964,
         //            StateStudentIdentifier = "2048801964",
         //            FirstName = "McKenzie",
         //            MiddleName = "Dorothy",
         //            LastName = "Sellers",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1995, 12, 13),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1965,
         //            //StudentPersonId = 1965,
         //            StateStudentIdentifier = "1453461965",
         //            FirstName = "Lillian",
         //            MiddleName = "Cheryl",
         //            LastName = "Washington",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 7, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1966,
         //            //StudentPersonId = 1966,
         //            StateStudentIdentifier = "4093611966",
         //            FirstName = "Upasana",
         //            MiddleName = "Justina",
         //            LastName = "Reeves",
         //            Cohort = "-",
         //            BirthDate = new DateTime(1998, 10, 21),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1967,
         //            //StudentPersonId = 1967,
         //            StateStudentIdentifier = "9316811967",
         //            FirstName = "Justina",
         //            MiddleName = "Sophia",
         //            LastName = "Guzman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 2, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1968,
         //            //StudentPersonId = 1968,
         //            StateStudentIdentifier = "4186841968",
         //            FirstName = "Noelani",
         //            MiddleName = "Rhea",
         //            LastName = "Bond",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2013, 7, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1969,
         //            //StudentPersonId = 1969,
         //            StateStudentIdentifier = "8075551969",
         //            FirstName = "Ariana",
         //            MiddleName = "Josephine",
         //            LastName = "Holloway",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 7, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1970,
         //            //StudentPersonId = 1970,
         //            StateStudentIdentifier = "6071791970",
         //            FirstName = "Sonya",
         //            MiddleName = "Haviva",
         //            LastName = "Henderson",
         //            Cohort = null,
         //            BirthDate = new DateTime(2005, 7, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1971,
         //            //StudentPersonId = 1971,
         //            StateStudentIdentifier = "5325811971",
         //            FirstName = "Fitzgerald",
         //            MiddleName = "Aquila",
         //            LastName = "Williams",
         //            Cohort = null,
         //            BirthDate = new DateTime(2013, 3, 12),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1972,
         //            //StudentPersonId = 1972,
         //            StateStudentIdentifier = "0292431972",
         //            FirstName = "Octavia",
         //            MiddleName = "Phyllis",
         //            LastName = "England",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 12, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1973,
         //            //StudentPersonId = 1973,
         //            StateStudentIdentifier = "3538701973",
         //            FirstName = "Lillith",
         //            MiddleName = "Raya",
         //            LastName = "Goodman",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 1, 4),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1974,
         //            //StudentPersonId = 1974,
         //            StateStudentIdentifier = "7308191974",
         //            FirstName = "Ian",
         //            MiddleName = "Todd",
         //            LastName = "Alston",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 4, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1975,
         //            //StudentPersonId = 1975,
         //            StateStudentIdentifier = "0358341975",
         //            FirstName = "Tatiana",
         //            MiddleName = "Ivana",
         //            LastName = "Burris",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2019, 2, 16),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1976,
         //            //StudentPersonId = 1976,
         //            StateStudentIdentifier = "7817611976",
         //            FirstName = "Ila",
         //            MiddleName = "Isadora",
         //            LastName = "Mcgee",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2016, 5, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1977,
         //            //StudentPersonId = 1977,
         //            StateStudentIdentifier = "5273731977",
         //            FirstName = "Martha",
         //            MiddleName = "Aimee",
         //            LastName = "Rosario",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 10, 6),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1978,
         //            //StudentPersonId = 1978,
         //            StateStudentIdentifier = "8022921978",
         //            FirstName = "Jonas",
         //            MiddleName = "Rigel",
         //            LastName = "Cash",
         //            Cohort = null,
         //            BirthDate = new DateTime(2001, 4, 9),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1979,
         //            //StudentPersonId = 1979,
         //            StateStudentIdentifier = "0643811979",
         //            FirstName = "Germane",
         //            MiddleName = "Charity",
         //            LastName = "Black",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 6, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1980,
         //            //StudentPersonId = 1980,
         //            StateStudentIdentifier = "1805841980",
         //            FirstName = "Conan",
         //            MiddleName = "Elvis",
         //            LastName = "Sutton",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 11, 23),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1981,
         //            //StudentPersonId = 1981,
         //            StateStudentIdentifier = "1583561981",
         //            FirstName = "Kuame",
         //            MiddleName = "Harper",
         //            LastName = "Macdonald",
         //            Cohort = null,
         //            BirthDate = new DateTime(2014, 9, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1982,
         //            //StudentPersonId = 1982,
         //            StateStudentIdentifier = "7982431982",
         //            FirstName = "Rahim",
         //            MiddleName = "Jonah",
         //            LastName = "Hunt",
         //            Cohort = null,
         //            BirthDate = new DateTime(2002, 2, 3),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1983,
         //            //StudentPersonId = 1983,
         //            StateStudentIdentifier = "7079001983",
         //            FirstName = "Paula",
         //            MiddleName = "Yael",
         //            LastName = "Cross",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 5, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1984,
         //            //StudentPersonId = 1984,
         //            StateStudentIdentifier = "3773221984",
         //            FirstName = "Yael",
         //            MiddleName = "Cleo",
         //            LastName = "Stout",
         //            Cohort = null,
         //            BirthDate = new DateTime(2015, 5, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1985,
         //            //StudentPersonId = 1985,
         //            StateStudentIdentifier = "4418371985",
         //            FirstName = "Camille",
         //            MiddleName = "Sonia",
         //            LastName = "Lott",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 11, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1986,
         //            //StudentPersonId = 1986,
         //            StateStudentIdentifier = "6703721986",
         //            FirstName = "Eaton",
         //            MiddleName = "Ferdinand",
         //            LastName = "Underwood",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 4, 26),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1987,
         //            //StudentPersonId = 1987,
         //            StateStudentIdentifier = "0284061987",
         //            FirstName = "Noah",
         //            MiddleName = "Eric",
         //            LastName = "Espinoza",
         //            Cohort = "2018-2022",
         //            BirthDate = new DateTime(2016, 3, 31),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1988,
         //            //StudentPersonId = 1988,
         //            StateStudentIdentifier = "6124651988",
         //            FirstName = "Perry",
         //            MiddleName = "Quentin",
         //            LastName = "Walton",
         //            Cohort = null,
         //            BirthDate = new DateTime(1997, 2, 14),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1989,
         //            //StudentPersonId = 1989,
         //            StateStudentIdentifier = "6620781989",
         //            FirstName = "Paula",
         //            MiddleName = "Yoko",
         //            LastName = "Berg",
         //            Cohort = null,
         //            BirthDate = new DateTime(1999, 2, 24),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1990,
         //            //StudentPersonId = 1990,
         //            StateStudentIdentifier = "0967371990",
         //            FirstName = "Ulysses",
         //            MiddleName = "Sasha",
         //            LastName = "Richmond",
         //            Cohort = null,
         //            BirthDate = new DateTime(1996, 6, 2),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1991,
         //            //StudentPersonId = 1991,
         //            StateStudentIdentifier = "7228861991",
         //            FirstName = "Darryl",
         //            MiddleName = "Emily",
         //            LastName = "Joyce",
         //            Cohort = null,
         //            BirthDate = new DateTime(2008, 1, 1),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1992,
         //            //StudentPersonId = 1992,
         //            StateStudentIdentifier = "8840741992",
         //            FirstName = "Hiram",
         //            MiddleName = "Rashad",
         //            LastName = "Stephens",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2002, 8, 7),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1993,
         //            //StudentPersonId = 1993,
         //            StateStudentIdentifier = "5033771993",
         //            FirstName = "Ulric",
         //            MiddleName = "Cain",
         //            LastName = "Savage",
         //            Cohort = "-",
         //            BirthDate = new DateTime(2010, 3, 25),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1994,
         //            //StudentPersonId = 1994,
         //            StateStudentIdentifier = "9898971994",
         //            FirstName = "Sylvester",
         //            MiddleName = "Galvin",
         //            LastName = "Cleveland",
         //            Cohort = "2013-2017",
         //            BirthDate = new DateTime(2016, 8, 22),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1995,
         //            //StudentPersonId = 1995,
         //            StateStudentIdentifier = "4734201995",
         //            FirstName = "Abdul",
         //            MiddleName = "Ila",
         //            LastName = "Lynn",
         //            Cohort = null,
         //            BirthDate = new DateTime(2007, 8, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1996,
         //            //StudentPersonId = 1996,
         //            StateStudentIdentifier = "0959961996",
         //            FirstName = "Arthur",
         //            MiddleName = "Lev",
         //            LastName = "Hull",
         //            Cohort = "2015-2019",
         //            BirthDate = new DateTime(2017, 1, 17),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1997,
         //            //StudentPersonId = 1997,
         //            StateStudentIdentifier = "2265041997",
         //            FirstName = "Nayda",
         //            MiddleName = "Catherine",
         //            LastName = "Washington",
         //            Cohort = "2016-2020",
         //            BirthDate = new DateTime(2019, 9, 18),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1998,
         //            //StudentPersonId = 1998,
         //            StateStudentIdentifier = "1203041998",
         //            FirstName = "Frances",
         //            MiddleName = "Zia",
         //            LastName = "Kerr",
         //            Cohort = null,
         //            BirthDate = new DateTime(2017, 3, 11),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 1999,
         //            //StudentPersonId = 1999,
         //            StateStudentIdentifier = "4394011999",
         //            FirstName = "Lev",
         //            MiddleName = "Jermaine",
         //            LastName = "Nieves",
         //            Cohort = null,
         //            BirthDate = new DateTime(2000, 8, 15),

         //        },
         //        new generate.core.Models.RDS.DimK12Student()
         //        {
         //            DimStudentId = 2000,
         //            //StudentPersonId = 2000,
         //            StateStudentIdentifier = "6878012000",
         //            FirstName = "Jack",
         //            MiddleName = "Aladdin",
         //            LastName = "Short",
         //            Cohort = "2014-2018",
         //            BirthDate = new DateTime(2008, 3, 15),

         //        }
         //    },

         //};

         return testData;
     }
 }
}

