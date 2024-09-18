using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using generate.core.Models.RDS;

namespace generate.core.Helpers.TestDataHelper.Rds
{
 public static partial class RdsTestDataHelper
 {
     public static RdsTestDataObject GetRdsTestData_DimPersonnel()
     {
         // SeedValue = 50000

         var testData = new RdsTestDataObject();


         //testData = new RdsTestDataObject()
         //{
         //    TestDataSection = "DimPersonnel",
         //    TestDataSectionDescription = "DimPersonnel Data",
         //    DimPersonnel = new List<generate.core.Models.RDS.DimK12Staff> ()
         //    {
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 1,
         //            ////PersonnelPersonId = 2001,
         //            StatePersonnelIdentifier = "0000000531",
         //            FirstName = "Ingrid",
         //            MiddleName = "Noel",
         //            LastName = "Sutton",
         //            BirthDate = new DateTime(2004, 9, 23),
         //            Title = "CSSO",
         //            Telephone = "543-630-468",
         //            Email = "Ingrid.Sutton@BMS.edu",
         //            PersonnelRole = "Chief State School Officer",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 2,
         //            ////PersonnelPersonId = 2002,
         //            StatePersonnelIdentifier = "0000000692",
         //            FirstName = "Maisie",
         //            MiddleName = "Robin",
         //            LastName = "Chandler",
         //            BirthDate = new DateTime(2018, 6, 7),
         //            Title = null,
         //            Telephone = "560-451-406",
         //            Email = "Maisie.Chandler@WE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 3,
         //            ////PersonnelPersonId = 2003,
         //            StatePersonnelIdentifier = "0000000523",
         //            FirstName = "Dean",
         //            MiddleName = "Hu",
         //            LastName = "Freeman",
         //            BirthDate = new DateTime(2014, 10, 8),
         //            Title = null,
         //            Telephone = "588-596-287",
         //            Email = "Dean.Freeman@TE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 4,
         //            ////PersonnelPersonId = 2004,
         //            StatePersonnelIdentifier = "0000000894",
         //            FirstName = "Enrique",
         //            MiddleName = "Hasad",
         //            LastName = "Guthrie",
         //            BirthDate = new DateTime(2018, 1, 29),
         //            Title = null,
         //            Telephone = "648-588-141",
         //            Email = "Enrique.Guthrie@AJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 5,
         //            ////PersonnelPersonId = 2005,
         //            StatePersonnelIdentifier = "0000000165",
         //            FirstName = "Amela",
         //            MiddleName = "Ulla",
         //            LastName = "Lang",
         //            BirthDate = new DateTime(2008, 3, 19),
         //            Title = null,
         //            Telephone = "297-477-498",
         //            Email = "Amela.Lang@ENHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 6,
         //            ////PersonnelPersonId = 2006,
         //            StatePersonnelIdentifier = "0000000566",
         //            FirstName = "Hamish",
         //            MiddleName = "Beck",
         //            LastName = "Pierce",
         //            BirthDate = new DateTime(2013, 1, 10),
         //            Title = null,
         //            Telephone = "271-198-625",
         //            Email = "Hamish.Pierce@CLMS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 7,
         //            ////PersonnelPersonId = 2007,
         //            StatePersonnelIdentifier = "0000000547",
         //            FirstName = "Irene",
         //            MiddleName = "Molly",
         //            LastName = "Watts",
         //            BirthDate = new DateTime(2014, 8, 25),
         //            Title = null,
         //            Telephone = "379-294-661",
         //            Email = "Irene.Watts@CMS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 8,
         //            ////PersonnelPersonId = 2008,
         //            StatePersonnelIdentifier = "0000000328",
         //            FirstName = "Dominic",
         //            MiddleName = "Driscoll",
         //            LastName = "Perry",
         //            BirthDate = new DateTime(1999, 12, 31),
         //            Title = null,
         //            Telephone = "438-493-499",
         //            Email = "Dominic.Perry@MHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 9,
         //            ////PersonnelPersonId = 2009,
         //            StatePersonnelIdentifier = "0000000319",
         //            FirstName = "Charles",
         //            MiddleName = "Beau",
         //            LastName = "Mann",
         //            BirthDate = new DateTime(2010, 4, 25),
         //            Title = null,
         //            Telephone = "127-225-517",
         //            Email = "Charles.Mann@RJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 10,
         //            ////PersonnelPersonId = 2010,
         //            StatePersonnelIdentifier = "0000003510",
         //            FirstName = "Fulton",
         //            MiddleName = "Samson",
         //            LastName = "Rasmussen",
         //            BirthDate = new DateTime(2012, 7, 9),
         //            Title = null,
         //            Telephone = "207-134-632",
         //            Email = "Fulton.Rasmussen@TPJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 11,
         //            ////PersonnelPersonId = 2011,
         //            StatePersonnelIdentifier = "0000001711",
         //            FirstName = "Keegan",
         //            MiddleName = "Wyatt",
         //            LastName = "Roberts",
         //            BirthDate = new DateTime(1995, 2, 22),
         //            Title = null,
         //            Telephone = "660-340-482",
         //            Email = "Keegan.Roberts@MA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 12,
         //            ////PersonnelPersonId = 2012,
         //            StatePersonnelIdentifier = "0000001712",
         //            FirstName = "Thor",
         //            MiddleName = "Nicholas",
         //            LastName = "Rivas",
         //            BirthDate = new DateTime(2007, 8, 22),
         //            Title = null,
         //            Telephone = "129-500-390",
         //            Email = "Thor.Rivas@PHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 13,
         //            ////PersonnelPersonId = 2013,
         //            StatePersonnelIdentifier = "0000006613",
         //            FirstName = "Richard",
         //            MiddleName = "Wang",
         //            LastName = "Gallagher",
         //            BirthDate = new DateTime(1998, 8, 24),
         //            Title = null,
         //            Telephone = "464-164-371",
         //            Email = "Richard.Gallagher@GJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 14,
         //            ////PersonnelPersonId = 2014,
         //            StatePersonnelIdentifier = "0000002514",
         //            FirstName = "Eugenia",
         //            MiddleName = "Dana",
         //            LastName = "Aguilar",
         //            BirthDate = new DateTime(2004, 7, 22),
         //            Title = null,
         //            Telephone = "392-558-624",
         //            Email = "Eugenia.Aguilar@EA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 15,
         //            ////PersonnelPersonId = 2015,
         //            StatePersonnelIdentifier = "0000000215",
         //            FirstName = "Maile",
         //            MiddleName = "Flavia",
         //            LastName = "Henson",
         //            BirthDate = new DateTime(2008, 12, 19),
         //            Title = null,
         //            Telephone = "280-143-667",
         //            Email = "Maile.Henson@AJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 16,
         //            ////PersonnelPersonId = 2016,
         //            StatePersonnelIdentifier = "0000001516",
         //            FirstName = "Chaim",
         //            MiddleName = "Oleg",
         //            LastName = "Mejia",
         //            BirthDate = new DateTime(2001, 7, 19),
         //            Title = null,
         //            Telephone = "437-334-182",
         //            Email = "Chaim.Mejia@GCJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 17,
         //            ////PersonnelPersonId = 2017,
         //            StatePersonnelIdentifier = "0000009917",
         //            FirstName = "Cooper",
         //            MiddleName = "Boris",
         //            LastName = "Battle",
         //            BirthDate = new DateTime(2002, 4, 25),
         //            Title = null,
         //            Telephone = "513-109-669",
         //            Email = "Cooper.Battle@HAA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 18,
         //            ////PersonnelPersonId = 2018,
         //            StatePersonnelIdentifier = "0000003218",
         //            FirstName = "Ezra",
         //            MiddleName = "Jaime",
         //            LastName = "Powell",
         //            BirthDate = new DateTime(1998, 10, 12),
         //            Title = null,
         //            Telephone = "583-328-531",
         //            Email = "Ezra.Powell@SA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 19,
         //            ////PersonnelPersonId = 2019,
         //            StatePersonnelIdentifier = "0000007619",
         //            FirstName = "Alexandra",
         //            MiddleName = "Eve",
         //            LastName = "Rivas",
         //            BirthDate = new DateTime(1998, 9, 5),
         //            Title = null,
         //            Telephone = "220-390-171",
         //            Email = "Alexandra.Rivas@AJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 20,
         //            ////PersonnelPersonId = 2020,
         //            StatePersonnelIdentifier = "0000005220",
         //            FirstName = "Giselle",
         //            MiddleName = "Jescie",
         //            LastName = "Edwards",
         //            BirthDate = new DateTime(2014, 8, 25),
         //            Title = null,
         //            Telephone = "303-565-217",
         //            Email = "Giselle.Edwards@NBJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 21,
         //            ////PersonnelPersonId = 2021,
         //            StatePersonnelIdentifier = "0000005121",
         //            FirstName = "Lacota",
         //            MiddleName = "Rinah",
         //            LastName = "Knowles",
         //            BirthDate = new DateTime(2009, 9, 16),
         //            Title = null,
         //            Telephone = "362-235-358",
         //            Email = "Lacota.Knowles@ESJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 22,
         //            ////PersonnelPersonId = 2022,
         //            StatePersonnelIdentifier = "0000007422",
         //            FirstName = "Jerome",
         //            MiddleName = "Vance",
         //            LastName = "Cain",
         //            BirthDate = new DateTime(2015, 6, 7),
         //            Title = null,
         //            Telephone = "627-173-654",
         //            Email = "Jerome.Cain@BHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 23,
         //            ////PersonnelPersonId = 2023,
         //            StatePersonnelIdentifier = "0000002223",
         //            FirstName = "Mona",
         //            MiddleName = "Ella",
         //            LastName = "Lowery",
         //            BirthDate = new DateTime(2010, 1, 6),
         //            Title = null,
         //            Telephone = "691-381-615",
         //            Email = "Mona.Lowery@PHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 24,
         //            ////PersonnelPersonId = 2024,
         //            StatePersonnelIdentifier = "0000003224",
         //            FirstName = "Leo",
         //            MiddleName = "Phelan",
         //            LastName = "Osborn",
         //            BirthDate = new DateTime(2017, 7, 14),
         //            Title = null,
         //            Telephone = "299-109-411",
         //            Email = "Leo.Osborn@CJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 25,
         //            ////PersonnelPersonId = 2025,
         //            StatePersonnelIdentifier = "0000001725",
         //            FirstName = "Nehru",
         //            MiddleName = "Alexandra",
         //            LastName = "Ellison",
         //            BirthDate = new DateTime(2018, 3, 25),
         //            Title = null,
         //            Telephone = "677-538-488",
         //            Email = "Nehru.Ellison@EE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 26,
         //            ////PersonnelPersonId = 2026,
         //            StatePersonnelIdentifier = "0000002626",
         //            FirstName = "Wesley",
         //            MiddleName = "Thomas",
         //            LastName = "Barrett",
         //            BirthDate = new DateTime(1999, 1, 18),
         //            Title = null,
         //            Telephone = "243-677-492",
         //            Email = "Wesley.Barrett@HJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 27,
         //            ////PersonnelPersonId = 2027,
         //            StatePersonnelIdentifier = "0000005527",
         //            FirstName = "Giselle",
         //            MiddleName = "Idona",
         //            LastName = "Burt",
         //            BirthDate = new DateTime(2009, 4, 2),
         //            Title = null,
         //            Telephone = "573-644-234",
         //            Email = "Giselle.Burt@FA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 28,
         //            ////PersonnelPersonId = 2028,
         //            StatePersonnelIdentifier = "0000005528",
         //            FirstName = "Kelly",
         //            MiddleName = "Bradley",
         //            LastName = "Giles",
         //            BirthDate = new DateTime(2018, 4, 13),
         //            Title = null,
         //            Telephone = "404-177-444",
         //            Email = "Kelly.Giles@BLHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 29,
         //            ////PersonnelPersonId = 2029,
         //            StatePersonnelIdentifier = "0000005629",
         //            FirstName = "Samantha",
         //            MiddleName = "Rina",
         //            LastName = "Snow",
         //            BirthDate = new DateTime(2000, 3, 12),
         //            Title = null,
         //            Telephone = "566-434-505",
         //            Email = "Samantha.Snow@ESJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 30,
         //            ////PersonnelPersonId = 2030,
         //            StatePersonnelIdentifier = "0000007330",
         //            FirstName = "Tanner",
         //            MiddleName = "Delilah",
         //            LastName = "Mcmahon",
         //            BirthDate = new DateTime(2015, 11, 16),
         //            Title = null,
         //            Telephone = "197-178-330",
         //            Email = "Tanner.Mcmahon@ESE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 31,
         //            ////PersonnelPersonId = 2031,
         //            StatePersonnelIdentifier = "0000005231",
         //            FirstName = "Callum",
         //            MiddleName = "Virginia",
         //            LastName = "Mills",
         //            BirthDate = new DateTime(2019, 7, 16),
         //            Title = null,
         //            Telephone = "492-373-372",
         //            Email = "Callum.Mills@FHA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 32,
         //            ////PersonnelPersonId = 2032,
         //            StatePersonnelIdentifier = "0000006632",
         //            FirstName = "Yuli",
         //            MiddleName = "Evan",
         //            LastName = "Marshall",
         //            BirthDate = new DateTime(2003, 8, 12),
         //            Title = null,
         //            Telephone = "286-122-178",
         //            Email = "Yuli.Marshall@GJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 33,
         //            ////PersonnelPersonId = 2033,
         //            StatePersonnelIdentifier = "0000004433",
         //            FirstName = "Tate",
         //            MiddleName = "Lyle",
         //            LastName = "Moon",
         //            BirthDate = new DateTime(2013, 7, 27),
         //            Title = null,
         //            Telephone = "670-502-679",
         //            Email = "Tate.Moon@PHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 34,
         //            ////PersonnelPersonId = 2034,
         //            StatePersonnelIdentifier = "0000001534",
         //            FirstName = "Tasha",
         //            MiddleName = "Shay",
         //            LastName = "Castillo",
         //            BirthDate = new DateTime(2017, 2, 14),
         //            Title = null,
         //            Telephone = "158-292-161",
         //            Email = "Tasha.Castillo@OHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 35,
         //            ////PersonnelPersonId = 2035,
         //            StatePersonnelIdentifier = "0000003435",
         //            FirstName = "Edward",
         //            MiddleName = "Talon",
         //            LastName = "Mejia",
         //            BirthDate = new DateTime(2001, 8, 3),
         //            Title = null,
         //            Telephone = "396-374-591",
         //            Email = "Edward.Mejia@FGA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 36,
         //            ////PersonnelPersonId = 2036,
         //            StatePersonnelIdentifier = "0000002536",
         //            FirstName = "Josiah",
         //            MiddleName = "Elliott",
         //            LastName = "Golden",
         //            BirthDate = new DateTime(1997, 3, 6),
         //            Title = null,
         //            Telephone = "403-569-434",
         //            Email = "Josiah.Golden@PHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 37,
         //            ////PersonnelPersonId = 2037,
         //            StatePersonnelIdentifier = "0000007337",
         //            FirstName = "Hector",
         //            MiddleName = "Odysseus",
         //            LastName = "Cochran",
         //            BirthDate = new DateTime(2015, 9, 6),
         //            Title = null,
         //            Telephone = "664-585-438",
         //            Email = "Hector.Cochran@GCJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 38,
         //            ////PersonnelPersonId = 2038,
         //            StatePersonnelIdentifier = "0000004538",
         //            FirstName = "Brenden",
         //            MiddleName = "Armand",
         //            LastName = "Ortiz",
         //            BirthDate = new DateTime(1999, 7, 9),
         //            Title = null,
         //            Telephone = "473-596-532",
         //            Email = "Brenden.Ortiz@CLMS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 39,
         //            ////PersonnelPersonId = 2039,
         //            StatePersonnelIdentifier = "0000007439",
         //            FirstName = "Joseph",
         //            MiddleName = "Drake",
         //            LastName = "Riggs",
         //            BirthDate = new DateTime(2015, 6, 21),
         //            Title = null,
         //            Telephone = "455-471-405",
         //            Email = "Joseph.Riggs@PHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 40,
         //            ////PersonnelPersonId = 2040,
         //            StatePersonnelIdentifier = "0000001640",
         //            FirstName = "Geraldine",
         //            MiddleName = "McKenzie",
         //            LastName = "Sweet",
         //            BirthDate = new DateTime(2005, 3, 16),
         //            Title = null,
         //            Telephone = "530-377-692",
         //            Email = "Geraldine.Sweet@HBA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 41,
         //            ////PersonnelPersonId = 2041,
         //            StatePersonnelIdentifier = "0000004341",
         //            FirstName = "September",
         //            MiddleName = "Mallory",
         //            LastName = "Beard",
         //            BirthDate = new DateTime(2010, 10, 27),
         //            Title = null,
         //            Telephone = "672-577-545",
         //            Email = "September.Beard@AHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 42,
         //            ////PersonnelPersonId = 2042,
         //            StatePersonnelIdentifier = "0000002442",
         //            FirstName = "Cheryl",
         //            MiddleName = "Zenia",
         //            LastName = "Dixon",
         //            BirthDate = new DateTime(1998, 8, 6),
         //            Title = null,
         //            Telephone = "488-378-561",
         //            Email = "Cheryl.Dixon@GCJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 43,
         //            ////PersonnelPersonId = 2043,
         //            StatePersonnelIdentifier = "0000003443",
         //            FirstName = "Pearl",
         //            MiddleName = "Janna",
         //            LastName = "Vega",
         //            BirthDate = new DateTime(2013, 7, 7),
         //            Title = null,
         //            Telephone = "283-506-343",
         //            Email = "Pearl.Vega@GE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 44,
         //            ////PersonnelPersonId = 2044,
         //            StatePersonnelIdentifier = "0000003444",
         //            FirstName = "Judah",
         //            MiddleName = "Zachery",
         //            LastName = "Parker",
         //            BirthDate = new DateTime(2014, 11, 29),
         //            Title = null,
         //            Telephone = "142-157-680",
         //            Email = "Judah.Parker@CMS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 45,
         //            ////PersonnelPersonId = 2045,
         //            StatePersonnelIdentifier = "0000007345",
         //            FirstName = "Kaitlin",
         //            MiddleName = "Giselle",
         //            LastName = "Beck",
         //            BirthDate = new DateTime(2007, 12, 4),
         //            Title = null,
         //            Telephone = "211-109-500",
         //            Email = "Kaitlin.Beck@JMS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 46,
         //            ////PersonnelPersonId = 2046,
         //            StatePersonnelIdentifier = "0000009946",
         //            FirstName = "Alisa",
         //            MiddleName = "Anjolie",
         //            LastName = "Kerr",
         //            BirthDate = new DateTime(1998, 6, 2),
         //            Title = null,
         //            Telephone = "628-273-503",
         //            Email = "Alisa.Kerr@SHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 47,
         //            ////PersonnelPersonId = 2047,
         //            StatePersonnelIdentifier = "0000001947",
         //            FirstName = "Wallace",
         //            MiddleName = "Marvin",
         //            LastName = "Cotton",
         //            BirthDate = new DateTime(1999, 7, 19),
         //            Title = null,
         //            Telephone = "639-418-385",
         //            Email = "Wallace.Cotton@SA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 48,
         //            ////PersonnelPersonId = 2048,
         //            StatePersonnelIdentifier = "0000000948",
         //            FirstName = "Eliana",
         //            MiddleName = "Charity",
         //            LastName = "Price",
         //            BirthDate = new DateTime(1999, 1, 6),
         //            Title = null,
         //            Telephone = "296-684-322",
         //            Email = "Eliana.Price@SE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 49,
         //            ////PersonnelPersonId = 2049,
         //            StatePersonnelIdentifier = "0000007249",
         //            FirstName = "Lisandra",
         //            MiddleName = "Wynne",
         //            LastName = "Foster",
         //            BirthDate = new DateTime(2006, 9, 23),
         //            Title = null,
         //            Telephone = "435-583-665",
         //            Email = "Lisandra.Foster@WMS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 50,
         //            ////PersonnelPersonId = 2050,
         //            StatePersonnelIdentifier = "0000007950",
         //            FirstName = "Yvette",
         //            MiddleName = "Sheila",
         //            LastName = "Melendez",
         //            BirthDate = new DateTime(2016, 2, 9),
         //            Title = null,
         //            Telephone = "352-221-645",
         //            Email = "Yvette.Melendez@APE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 51,
         //            ////PersonnelPersonId = 2051,
         //            StatePersonnelIdentifier = "0000009051",
         //            FirstName = "Bruce",
         //            MiddleName = "Brent",
         //            LastName = "Cohen",
         //            BirthDate = new DateTime(2011, 10, 23),
         //            Title = null,
         //            Telephone = "235-612-492",
         //            Email = "Bruce.Cohen@AJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 52,
         //            ////PersonnelPersonId = 2052,
         //            StatePersonnelIdentifier = "0000006052",
         //            FirstName = "Kuame",
         //            MiddleName = "Armand",
         //            LastName = "Kirk",
         //            BirthDate = new DateTime(2010, 11, 5),
         //            Title = null,
         //            Telephone = "292-216-189",
         //            Email = "Kuame.Kirk@AJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 53,
         //            ////PersonnelPersonId = 2053,
         //            StatePersonnelIdentifier = "0000000853",
         //            FirstName = "Nicholas",
         //            MiddleName = "Brent",
         //            LastName = "Potter",
         //            BirthDate = new DateTime(2011, 11, 17),
         //            Title = null,
         //            Telephone = "612-529-690",
         //            Email = "Nicholas.Potter@MHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 54,
         //            ////PersonnelPersonId = 2054,
         //            StatePersonnelIdentifier = "0000002254",
         //            FirstName = "Fulton",
         //            MiddleName = "Brian",
         //            LastName = "Harding",
         //            BirthDate = new DateTime(2007, 7, 28),
         //            Title = null,
         //            Telephone = "643-154-273",
         //            Email = "Fulton.Harding@LTMS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 55,
         //            ////PersonnelPersonId = 2055,
         //            StatePersonnelIdentifier = "0000009555",
         //            FirstName = "Timothy",
         //            MiddleName = "Keegan",
         //            LastName = "Mcgowan",
         //            BirthDate = new DateTime(2006, 11, 14),
         //            Title = null,
         //            Telephone = "537-639-342",
         //            Email = "Timothy.Mcgowan@OHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 56,
         //            ////PersonnelPersonId = 2056,
         //            StatePersonnelIdentifier = "0000007456",
         //            FirstName = "Jacob",
         //            MiddleName = "Cedric",
         //            LastName = "Macdonald",
         //            BirthDate = new DateTime(1996, 5, 30),
         //            Title = null,
         //            Telephone = "475-106-579",
         //            Email = "Jacob.Macdonald@BLHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 57,
         //            ////PersonnelPersonId = 2057,
         //            StatePersonnelIdentifier = "0000008857",
         //            FirstName = "Uriel",
         //            MiddleName = "Mufutau",
         //            LastName = "Tillman",
         //            BirthDate = new DateTime(2012, 7, 21),
         //            Title = null,
         //            Telephone = "631-351-218",
         //            Email = "Uriel.Tillman@APE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 58,
         //            ////PersonnelPersonId = 2058,
         //            StatePersonnelIdentifier = "0000001858",
         //            FirstName = "Emerald",
         //            MiddleName = "Dorothy",
         //            LastName = "Mcgowan",
         //            BirthDate = new DateTime(2003, 12, 2),
         //            Title = null,
         //            Telephone = "650-625-598",
         //            Email = "Emerald.Mcgowan@BHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 59,
         //            //PersonnelPersonId = 2059,
         //            StatePersonnelIdentifier = "0000008359",
         //            FirstName = "Abel",
         //            MiddleName = "Brody",
         //            LastName = "Goodman",
         //            BirthDate = new DateTime(1996, 1, 17),
         //            Title = null,
         //            Telephone = "461-404-367",
         //            Email = "Abel.Goodman@AJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 60,
         //            //PersonnelPersonId = 2060,
         //            StatePersonnelIdentifier = "0000005360",
         //            FirstName = "Larissa",
         //            MiddleName = "Nita",
         //            LastName = "Sexton",
         //            BirthDate = new DateTime(2000, 1, 29),
         //            Title = null,
         //            Telephone = "143-173-553",
         //            Email = "Larissa.Sexton@ESJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 61,
         //            //PersonnelPersonId = 2061,
         //            StatePersonnelIdentifier = "0000009961",
         //            FirstName = "Roary",
         //            MiddleName = "Phoebe",
         //            LastName = "Barlow",
         //            BirthDate = new DateTime(2011, 7, 7),
         //            Title = null,
         //            Telephone = "594-580-356",
         //            Email = "Roary.Barlow@BHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 62,
         //            //PersonnelPersonId = 2062,
         //            StatePersonnelIdentifier = "0000003162",
         //            FirstName = "Isadora",
         //            MiddleName = "Natalie",
         //            LastName = "Goodman",
         //            BirthDate = new DateTime(2010, 4, 23),
         //            Title = null,
         //            Telephone = "589-514-365",
         //            Email = "Isadora.Goodman@HJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 63,
         //            //PersonnelPersonId = 2063,
         //            StatePersonnelIdentifier = "0000004263",
         //            FirstName = "Nathaniel",
         //            MiddleName = "Thaddeus",
         //            LastName = "Lane",
         //            BirthDate = new DateTime(2012, 7, 27),
         //            Title = null,
         //            Telephone = "581-525-356",
         //            Email = "Nathaniel.Lane@WE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 64,
         //            //PersonnelPersonId = 2064,
         //            StatePersonnelIdentifier = "0000004264",
         //            FirstName = "Dale",
         //            MiddleName = "Keith",
         //            LastName = "Mathews",
         //            BirthDate = new DateTime(2016, 4, 26),
         //            Title = null,
         //            Telephone = "107-360-631",
         //            Email = "Dale.Mathews@AJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 65,
         //            //PersonnelPersonId = 2065,
         //            StatePersonnelIdentifier = "0000008165",
         //            FirstName = "Sawyer",
         //            MiddleName = "Burke",
         //            LastName = "Keith",
         //            BirthDate = new DateTime(2002, 9, 23),
         //            Title = null,
         //            Telephone = "155-118-636",
         //            Email = "Sawyer.Keith@BMS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 66,
         //            //PersonnelPersonId = 2066,
         //            StatePersonnelIdentifier = "0000005466",
         //            FirstName = "Aristotle",
         //            MiddleName = "Dieter",
         //            LastName = "Byrd",
         //            BirthDate = new DateTime(2000, 1, 27),
         //            Title = null,
         //            Telephone = "698-530-441",
         //            Email = "Aristotle.Byrd@SHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 67,
         //            //PersonnelPersonId = 2067,
         //            StatePersonnelIdentifier = "0000004267",
         //            FirstName = "Hollee",
         //            MiddleName = "Adena",
         //            LastName = "Dominguez",
         //            BirthDate = new DateTime(2016, 1, 30),
         //            Title = null,
         //            Telephone = "281-155-295",
         //            Email = "Hollee.Dominguez@BHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 68,
         //            //PersonnelPersonId = 2068,
         //            StatePersonnelIdentifier = "0000005068",
         //            FirstName = "Sierra",
         //            MiddleName = "Aimee",
         //            LastName = "Franco",
         //            BirthDate = new DateTime(2005, 3, 2),
         //            Title = null,
         //            Telephone = "300-475-550",
         //            Email = "Sierra.Franco@CJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 69,
         //            //PersonnelPersonId = 2069,
         //            StatePersonnelIdentifier = "0000008069",
         //            FirstName = "Oprah",
         //            MiddleName = "Hannah",
         //            LastName = "Goodman",
         //            BirthDate = new DateTime(2006, 1, 6),
         //            Title = null,
         //            Telephone = "611-112-683",
         //            Email = "Oprah.Goodman@RJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 70,
         //            //PersonnelPersonId = 2070,
         //            StatePersonnelIdentifier = "0000005270",
         //            FirstName = "Macy",
         //            MiddleName = "Aline",
         //            LastName = "Berg",
         //            BirthDate = new DateTime(2000, 9, 21),
         //            Title = null,
         //            Telephone = "537-581-394",
         //            Email = "Macy.Berg@BJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 71,
         //            //PersonnelPersonId = 2071,
         //            StatePersonnelIdentifier = "0000004071",
         //            FirstName = "Jarrod",
         //            MiddleName = "Ebony",
         //            LastName = "Goodman",
         //            BirthDate = new DateTime(2011, 5, 1),
         //            Title = null,
         //            Telephone = "288-224-226",
         //            Email = "Jarrod.Goodman@MA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 72,
         //            //PersonnelPersonId = 2072,
         //            StatePersonnelIdentifier = "0000001272",
         //            FirstName = "Holmes",
         //            MiddleName = "Reece",
         //            LastName = "Burns",
         //            BirthDate = new DateTime(2008, 10, 28),
         //            Title = null,
         //            Telephone = "492-194-442",
         //            Email = "Holmes.Burns@AHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 73,
         //            //PersonnelPersonId = 2073,
         //            StatePersonnelIdentifier = "0000009473",
         //            FirstName = "Julie",
         //            MiddleName = "Armando",
         //            LastName = "Dejesus",
         //            BirthDate = new DateTime(2015, 6, 13),
         //            Title = null,
         //            Telephone = "181-182-638",
         //            Email = "Julie.Dejesus@TPJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 74,
         //            //PersonnelPersonId = 2074,
         //            StatePersonnelIdentifier = "0000005674",
         //            FirstName = "Colette",
         //            MiddleName = "Bree",
         //            LastName = "York",
         //            BirthDate = new DateTime(2012, 7, 20),
         //            Title = null,
         //            Telephone = "612-486-585",
         //            Email = "Colette.York@ESJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 75,
         //            //PersonnelPersonId = 2075,
         //            StatePersonnelIdentifier = "0000007675",
         //            FirstName = "Althea",
         //            MiddleName = "Elaine",
         //            LastName = "Briggs",
         //            BirthDate = new DateTime(2011, 3, 29),
         //            Title = null,
         //            Telephone = "188-300-673",
         //            Email = "Althea.Briggs@BLHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 76,
         //            //PersonnelPersonId = 2076,
         //            StatePersonnelIdentifier = "0000003076",
         //            FirstName = "Jane",
         //            MiddleName = "Suki",
         //            LastName = "Whitfield",
         //            BirthDate = new DateTime(1996, 11, 17),
         //            Title = null,
         //            Telephone = "405-391-411",
         //            Email = "Jane.Whitfield@BMS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 77,
         //            //PersonnelPersonId = 2077,
         //            StatePersonnelIdentifier = "0000007477",
         //            FirstName = "Kamal",
         //            MiddleName = "Daniel",
         //            LastName = "Turner",
         //            BirthDate = new DateTime(2002, 8, 27),
         //            Title = null,
         //            Telephone = "287-312-306",
         //            Email = "Kamal.Turner@GCJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 78,
         //            //PersonnelPersonId = 2078,
         //            StatePersonnelIdentifier = "0000002278",
         //            FirstName = "Alfonso",
         //            MiddleName = "Ivor",
         //            LastName = "Burns",
         //            BirthDate = new DateTime(2015, 2, 2),
         //            Title = null,
         //            Telephone = "588-633-621",
         //            Email = "Alfonso.Burns@JMS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 79,
         //            //PersonnelPersonId = 2079,
         //            StatePersonnelIdentifier = "0000006379",
         //            FirstName = "Tad",
         //            MiddleName = "Keith",
         //            LastName = "Price",
         //            BirthDate = new DateTime(1996, 7, 1),
         //            Title = null,
         //            Telephone = "561-348-237",
         //            Email = "Tad.Price@TE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 80,
         //            //PersonnelPersonId = 2080,
         //            StatePersonnelIdentifier = "0000000980",
         //            FirstName = "Doris",
         //            MiddleName = "Alisa",
         //            LastName = "Ballard",
         //            BirthDate = new DateTime(2006, 6, 9),
         //            Title = null,
         //            Telephone = "425-444-643",
         //            Email = "Doris.Ballard@WMS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 81,
         //            //PersonnelPersonId = 2081,
         //            StatePersonnelIdentifier = "0000007881",
         //            FirstName = "Avram",
         //            MiddleName = "Dacey",
         //            LastName = "Harding",
         //            BirthDate = new DateTime(2012, 3, 23),
         //            Title = null,
         //            Telephone = "391-648-548",
         //            Email = "Avram.Harding@ESE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 82,
         //            //PersonnelPersonId = 2082,
         //            StatePersonnelIdentifier = "0000001082",
         //            FirstName = "Willow",
         //            MiddleName = "Ashton",
         //            LastName = "Hewitt",
         //            BirthDate = new DateTime(2003, 11, 26),
         //            Title = null,
         //            Telephone = "278-374-684",
         //            Email = "Willow.Hewitt@CMS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 83,
         //            //PersonnelPersonId = 2083,
         //            StatePersonnelIdentifier = "0000001083",
         //            FirstName = "George",
         //            MiddleName = "Lamar",
         //            LastName = "Mack",
         //            BirthDate = new DateTime(2011, 3, 18),
         //            Title = null,
         //            Telephone = "361-640-509",
         //            Email = "George.Mack@BLHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 84,
         //            //PersonnelPersonId = 2084,
         //            StatePersonnelIdentifier = "0000003084",
         //            FirstName = "Lara",
         //            MiddleName = "Catherine",
         //            LastName = "Obrien",
         //            BirthDate = new DateTime(2000, 2, 12),
         //            Title = null,
         //            Telephone = "656-288-632",
         //            Email = "Lara.Obrien@GCJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 85,
         //            //PersonnelPersonId = 2085,
         //            StatePersonnelIdentifier = "0000004185",
         //            FirstName = "Margaret",
         //            MiddleName = "Naida",
         //            LastName = "Stokes",
         //            BirthDate = new DateTime(2011, 11, 19),
         //            Title = null,
         //            Telephone = "459-583-422",
         //            Email = "Margaret.Stokes@HAA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 86,
         //            //PersonnelPersonId = 2086,
         //            StatePersonnelIdentifier = "0000002586",
         //            FirstName = "Cameran",
         //            MiddleName = "Courtney",
         //            LastName = "Patrick",
         //            BirthDate = new DateTime(2007, 1, 13),
         //            Title = null,
         //            Telephone = "163-559-462",
         //            Email = "Cameran.Patrick@ESE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 87,
         //            //PersonnelPersonId = 2087,
         //            StatePersonnelIdentifier = "0000000587",
         //            FirstName = "Levi",
         //            MiddleName = "Dante",
         //            LastName = "Beard",
         //            BirthDate = new DateTime(1999, 5, 25),
         //            Title = null,
         //            Telephone = "443-486-205",
         //            Email = "Levi.Beard@GE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 88,
         //            //PersonnelPersonId = 2088,
         //            StatePersonnelIdentifier = "0000009788",
         //            FirstName = "Leslie",
         //            MiddleName = "Demetria",
         //            LastName = "Mckee",
         //            BirthDate = new DateTime(2007, 9, 30),
         //            Title = null,
         //            Telephone = "244-453-365",
         //            Email = "Leslie.Mckee@CMS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 89,
         //            //PersonnelPersonId = 2089,
         //            StatePersonnelIdentifier = "0000009489",
         //            FirstName = "Caesar",
         //            MiddleName = "Karina",
         //            LastName = "Davis",
         //            BirthDate = new DateTime(2015, 12, 25),
         //            Title = null,
         //            Telephone = "216-373-664",
         //            Email = "Caesar.Davis@DA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 90,
         //            //PersonnelPersonId = 2090,
         //            StatePersonnelIdentifier = "0000007290",
         //            FirstName = "Amena",
         //            MiddleName = "Shaine",
         //            LastName = "Lynch",
         //            BirthDate = new DateTime(2010, 11, 25),
         //            Title = null,
         //            Telephone = "606-368-105",
         //            Email = "Amena.Lynch@DQA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 91,
         //            //PersonnelPersonId = 2091,
         //            StatePersonnelIdentifier = "0000004491",
         //            FirstName = "Tucker",
         //            MiddleName = "Leonard",
         //            LastName = "Kirk",
         //            BirthDate = new DateTime(2001, 7, 28),
         //            Title = null,
         //            Telephone = "109-594-325",
         //            Email = "Tucker.Kirk@DA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 92,
         //            //PersonnelPersonId = 2092,
         //            StatePersonnelIdentifier = "0000002492",
         //            FirstName = "Vladimir",
         //            MiddleName = "Grady",
         //            LastName = "Lee",
         //            BirthDate = new DateTime(2006, 5, 12),
         //            Title = null,
         //            Telephone = "170-343-600",
         //            Email = "Vladimir.Lee@FJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 93,
         //            //PersonnelPersonId = 2093,
         //            StatePersonnelIdentifier = "0000005693",
         //            FirstName = "Wilma",
         //            MiddleName = "Victoria",
         //            LastName = "Walton",
         //            BirthDate = new DateTime(2013, 9, 9),
         //            Title = null,
         //            Telephone = "677-197-281",
         //            Email = "Wilma.Walton@BCA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 94,
         //            //PersonnelPersonId = 2094,
         //            StatePersonnelIdentifier = "0000006494",
         //            FirstName = "Michael",
         //            MiddleName = "Chase",
         //            LastName = "Trevino",
         //            BirthDate = new DateTime(2018, 6, 2),
         //            Title = null,
         //            Telephone = "390-107-283",
         //            Email = "Michael.Trevino@WE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 95,
         //            //PersonnelPersonId = 2095,
         //            StatePersonnelIdentifier = "0000004395",
         //            FirstName = "Geraldine",
         //            MiddleName = "Zoe",
         //            LastName = "Fitzgerald",
         //            BirthDate = new DateTime(2010, 4, 16),
         //            Title = null,
         //            Telephone = "298-308-596",
         //            Email = "Geraldine.Fitzgerald@WE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 96,
         //            //PersonnelPersonId = 2096,
         //            StatePersonnelIdentifier = "0000004896",
         //            FirstName = "Asher",
         //            MiddleName = "Austin",
         //            LastName = "Hansen",
         //            BirthDate = new DateTime(2007, 3, 12),
         //            Title = null,
         //            Telephone = "627-555-289",
         //            Email = "Asher.Hansen@HJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 97,
         //            //PersonnelPersonId = 2097,
         //            StatePersonnelIdentifier = "0000002497",
         //            FirstName = "Dara",
         //            MiddleName = "Kai",
         //            LastName = "Hull",
         //            BirthDate = new DateTime(2014, 3, 10),
         //            Title = null,
         //            Telephone = "626-174-536",
         //            Email = "Dara.Hull@HAA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 98,
         //            //PersonnelPersonId = 2098,
         //            StatePersonnelIdentifier = "0000008998",
         //            FirstName = "Nada",
         //            MiddleName = "Lenore",
         //            LastName = "Wagner",
         //            BirthDate = new DateTime(2000, 11, 12),
         //            Title = null,
         //            Telephone = "152-690-668",
         //            Email = "Nada.Wagner@GMS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 99,
         //            //PersonnelPersonId = 2099,
         //            StatePersonnelIdentifier = "0000002399",
         //            FirstName = "Berk",
         //            MiddleName = "Joel",
         //            LastName = "Porter",
         //            BirthDate = new DateTime(2014, 4, 5),
         //            Title = null,
         //            Telephone = "321-343-219",
         //            Email = "Berk.Porter@BHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 100,
         //            //PersonnelPersonId = 2100,
         //            StatePersonnelIdentifier = "0000064100",
         //            FirstName = "Steven",
         //            MiddleName = "Kenneth",
         //            LastName = "Randolph",
         //            BirthDate = new DateTime(2009, 1, 23),
         //            Title = null,
         //            Telephone = "444-611-114",
         //            Email = "Steven.Randolph@MLJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 101,
         //            //PersonnelPersonId = 2101,
         //            StatePersonnelIdentifier = "0000060101",
         //            FirstName = "Vivien",
         //            MiddleName = "Lacota",
         //            LastName = "Barlow",
         //            BirthDate = new DateTime(2005, 2, 15),
         //            Title = null,
         //            Telephone = "591-478-345",
         //            Email = "Vivien.Barlow@EA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 102,
         //            //PersonnelPersonId = 2102,
         //            StatePersonnelIdentifier = "0000015102",
         //            FirstName = "Casey",
         //            MiddleName = "Hedwig",
         //            LastName = "Elliott",
         //            BirthDate = new DateTime(2017, 1, 19),
         //            Title = null,
         //            Telephone = "240-559-645",
         //            Email = "Casey.Elliott@APE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 103,
         //            //PersonnelPersonId = 2103,
         //            StatePersonnelIdentifier = "0000071103",
         //            FirstName = "Hanae",
         //            MiddleName = "Jasmin",
         //            LastName = "Gibson",
         //            BirthDate = new DateTime(2003, 1, 13),
         //            Title = null,
         //            Telephone = "602-491-531",
         //            Email = "Hanae.Gibson@AHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 104,
         //            //PersonnelPersonId = 2104,
         //            StatePersonnelIdentifier = "0000092104",
         //            FirstName = "Erasmus",
         //            MiddleName = "Abbot",
         //            LastName = "Blackwell",
         //            BirthDate = new DateTime(2005, 5, 21),
         //            Title = null,
         //            Telephone = "692-271-528",
         //            Email = "Erasmus.Blackwell@EA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 105,
         //            //PersonnelPersonId = 2105,
         //            StatePersonnelIdentifier = "0000017105",
         //            FirstName = "Gillian",
         //            MiddleName = "Xyla",
         //            LastName = "Hansen",
         //            BirthDate = new DateTime(2005, 5, 12),
         //            Title = null,
         //            Telephone = "641-620-642",
         //            Email = "Gillian.Hansen@MLJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 106,
         //            //PersonnelPersonId = 2106,
         //            StatePersonnelIdentifier = "0000053106",
         //            FirstName = "Katelyn",
         //            MiddleName = "Germaine",
         //            LastName = "Hunt",
         //            BirthDate = new DateTime(2014, 5, 26),
         //            Title = null,
         //            Telephone = "665-601-368",
         //            Email = "Katelyn.Hunt@CLMS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 107,
         //            //PersonnelPersonId = 2107,
         //            StatePersonnelIdentifier = "0000001107",
         //            FirstName = "Charity",
         //            MiddleName = "Heather",
         //            LastName = "Roberson",
         //            BirthDate = new DateTime(1999, 4, 23),
         //            Title = null,
         //            Telephone = "486-568-190",
         //            Email = "Charity.Roberson@ESJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 108,
         //            //PersonnelPersonId = 2108,
         //            StatePersonnelIdentifier = "0000094108",
         //            FirstName = "Jorden",
         //            MiddleName = "Doris",
         //            LastName = "Briggs",
         //            BirthDate = new DateTime(2015, 6, 22),
         //            Title = null,
         //            Telephone = "652-561-102",
         //            Email = "Jorden.Briggs@ESE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 109,
         //            //PersonnelPersonId = 2109,
         //            StatePersonnelIdentifier = "0000043109",
         //            FirstName = "Lacy",
         //            MiddleName = "Kiona",
         //            LastName = "Craig",
         //            BirthDate = new DateTime(2019, 7, 2),
         //            Title = null,
         //            Telephone = "677-534-697",
         //            Email = "Lacy.Craig@CJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 110,
         //            //PersonnelPersonId = 2110,
         //            StatePersonnelIdentifier = "0000031110",
         //            FirstName = "Brandon",
         //            MiddleName = "Nash",
         //            LastName = "Carpenter",
         //            BirthDate = new DateTime(2008, 4, 3),
         //            Title = null,
         //            Telephone = "644-512-345",
         //            Email = "Brandon.Carpenter@AJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 111,
         //            //PersonnelPersonId = 2111,
         //            StatePersonnelIdentifier = "0000042111",
         //            FirstName = "Ryder",
         //            MiddleName = "Ahmed",
         //            LastName = "Melendez",
         //            BirthDate = new DateTime(2010, 5, 18),
         //            Title = null,
         //            Telephone = "422-516-575",
         //            Email = "Ryder.Melendez@AJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 112,
         //            //PersonnelPersonId = 2112,
         //            StatePersonnelIdentifier = "0000054112",
         //            FirstName = "Geraldine",
         //            MiddleName = "James",
         //            LastName = "Holt",
         //            BirthDate = new DateTime(2015, 3, 5),
         //            Title = null,
         //            Telephone = "131-310-104",
         //            Email = "Geraldine.Holt@HBA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 113,
         //            //PersonnelPersonId = 2113,
         //            StatePersonnelIdentifier = "0000051113",
         //            FirstName = "Mike",
         //            MiddleName = "Brett",
         //            LastName = "Rivera",
         //            BirthDate = new DateTime(2001, 2, 21),
         //            Title = null,
         //            Telephone = "122-509-410",
         //            Email = "Mike.Rivera@TLJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 114,
         //            //PersonnelPersonId = 2114,
         //            StatePersonnelIdentifier = "0000083114",
         //            FirstName = "Cara",
         //            MiddleName = "Halee",
         //            LastName = "Gordon",
         //            BirthDate = new DateTime(1997, 11, 26),
         //            Title = null,
         //            Telephone = "636-129-374",
         //            Email = "Cara.Gordon@TLJH.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 115,
         //            //PersonnelPersonId = 2115,
         //            StatePersonnelIdentifier = "0000027115",
         //            FirstName = "Basia",
         //            MiddleName = "Quinn",
         //            LastName = "Bryant",
         //            BirthDate = new DateTime(2010, 12, 13),
         //            Title = null,
         //            Telephone = "281-662-463",
         //            Email = "Basia.Bryant@SA.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 116,
         //            //PersonnelPersonId = 2116,
         //            StatePersonnelIdentifier = "0000004116",
         //            FirstName = "Shelley",
         //            MiddleName = "Genevieve",
         //            LastName = "Booth",
         //            BirthDate = new DateTime(2011, 7, 5),
         //            Title = null,
         //            Telephone = "645-365-455",
         //            Email = "Shelley.Booth@DCE.edu",
         //            PersonnelRole = "K12 Personnel",

         //        },
         //        new generate.core.Models.RDS.DimK12Staff()
         //        {
         //            DimPersonnelId = 117,
         //            //PersonnelPersonId = 2117,
         //            StatePersonnelIdentifier = "0000007117",
         //            FirstName = "Nasim",
         //            MiddleName = "Cullen",
         //            LastName = "Manning",
         //            BirthDate = new DateTime(2011, 5, 14),
         //            Title = null,
         //            Telephone = "421-101-408",
         //            Email = "Nasim.Manning@SHS.edu",
         //            PersonnelRole = "K12 Personnel",

         //        }
         //    },

         //};

         return testData;
     }
 }
}

