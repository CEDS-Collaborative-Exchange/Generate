using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefExitOrWithdrawalTypeHelper
    {
        public static List<RefExitOrWithdrawalType> GetData()
        {
            /*
             select 'data.Add(new RefExitOrWithdrawalType() { 
            RefExitOrWithdrawalTypeId = ' + convert(varchar(20), RefExitOrWithdrawalTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefExitOrWithdrawalType
            */

            var data = new List<RefExitOrWithdrawalType>();

            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 1,
                Code = "01907",
                Description = "Student is in a different public school in the same local education agency"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 2,
                Code = "01908",
                Description = "Transferred to a public school in a different local education agency in the same state"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 3,
                Code = "01909",
                Description = "Transferred to a public school in a different state"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 4,
                Code = "01910",
                Description = "Transferred to a private, non-religiously-affiliated school in the same local education agency"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 5,
                Code = "01911",
                Description = "Transferred to a private, non-religiously-affiliated school in a different LEA in the same state"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 6,
                Code = "01912",
                Description = "Transferred to a private, non-religiously-affiliated school in a different state"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 7,
                Code = "01913",
                Description = "Transferred to a private, religiously-affiliated school in the same local education agency"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 8,
                Code = "01914",
                Description = "Transferred to a private, religiously-affiliated school in a different LEA in the same state"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 9,
                Code = "01915",
                Description = "Transferred to a private, religiously-affiliated school in a different state"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 10,
                Code = "01916",
                Description = "Transferred to a school outside of the country"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 11,
                Code = "01917",
                Description = "Transferred to an institution"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 12,
                Code = "01918",
                Description = "Transferred to home schooling"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 13,
                Code = "01919",
                Description = "Transferred to a charter school"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 14,
                Code = "01921",
                Description = "Graduated with regular, advanced, International Baccalaureate, or other type of diploma"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 15,
                Code = "01922",
                Description = "Completed school with other credentials"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 16,
                Code = "01923",
                Description = "Died or is permanently incapacitated"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 17,
                Code = "01924",
                Description = "Withdrawn due to illness"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 18,
                Code = "01925",
                Description = "Expelled or involuntarily withdrawn"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 19,
                Code = "01926",
                Description = "Reached maximum age for services"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 20,
                Code = "01927",
                Description = "Discontinued schooling"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 21,
                Code = "01928",
                Description = "Completed grade 12, but did not meet all graduation requirements"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 22,
                Code = "01930",
                Description = "Enrolled in a postsecondary early admission program, eligible to return"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 23,
                Code = "01931",
                Description = "Not enrolled, unknown status"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 24,
                Code = "03499",
                Description = "Student is in the same LEA, receiving education services, but is not assigned to a particular school"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 25,
                Code = "03502",
                Description = "Not enrolled, eligible to return"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 26,
                Code = "03503",
                Description = "Enrolled in a foreign exchange program, eligible to return"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 27,
                Code = "03504",
                Description = "Withdrawn from school, under the age for compulsory attendance; eligible to return"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 28,
                Code = "03505",
                Description = "Exited"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 29,
                Code = "03508",
                Description = "Student is in a charter school managed by the same local education agency"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 30,
                Code = "03509",
                Description = "Completed with a state-recognized equivalency certificate"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 31,
                Code = "09999",
                Description = "Other"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 32,
                Code = "73060",
                Description = "Officially withdrew and enrolled in ABE, adult secondary education, or adult ESL program"
            });
            data.Add(new RefExitOrWithdrawalType()
            {
                RefExitOrWithdrawalTypeId = 33,
                Code = "73061",
                Description = "Officially withdrew and enrolled in a workforce training program"
            });

            return data;
        }
    }
}
