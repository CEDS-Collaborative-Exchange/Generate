using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using generate.core.Models.RDS;

namespace generate.core.Helpers.TestDataHelper.Rds
{
 public static partial class RdsTestDataHelper
 {
     public static RdsTestDataObject GetRdsTestData_FactCustomCounts()
     {
         // SeedValue = 50000

         var testData = new RdsTestDataObject();


         testData = new RdsTestDataObject()
         {
             TestDataSection = "FactCustomCounts",
             TestDataSectionDescription = "FactCustomCounts Data",
         };

         return testData;
     }
 }
}

