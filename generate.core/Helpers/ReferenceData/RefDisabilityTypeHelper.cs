using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefDisabilityTypeHelper
    {

        public static List<RefDisabilityType> GetData()
        {
            /*
            select 'data.Add(new RefDisabilityType() { 
            RefDisabilityTypeId = ' + convert(varchar(20), RefDisabilityTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefDisabilityType
            */

            var data = new List<RefDisabilityType>();

            data.Add(new RefDisabilityType()
            {
                RefDisabilityTypeId = 1,
                Code = "AUT",
                Description = "Autism"
            });
            data.Add(new RefDisabilityType()
            {
                RefDisabilityTypeId = 2,
                Code = "DB",
                Description = "Deaf-blindness"
            });
            data.Add(new RefDisabilityType()
            {
                RefDisabilityTypeId = 3,
                Code = "DD",
                Description = "Developmental delay"
            });
            data.Add(new RefDisabilityType()
            {
                RefDisabilityTypeId = 4,
                Code = "EMN",
                Description = "Emotional disturbance"
            });
            data.Add(new RefDisabilityType()
            {
                RefDisabilityTypeId = 5,
                Code = "HI",
                Description = "Hearing impairment"
            });
            data.Add(new RefDisabilityType()
            {
                RefDisabilityTypeId = 6,
                Code = "ID",
                Description = "Intellectual Disability"
            });
            data.Add(new RefDisabilityType()
            {
                RefDisabilityTypeId = 7,
                Code = "MD",
                Description = "Multiple disabilities"
            });
            data.Add(new RefDisabilityType()
            {
                RefDisabilityTypeId = 8,
                Code = "OI",
                Description = "Orthopedic impairment"
            });
            data.Add(new RefDisabilityType()
            {
                RefDisabilityTypeId = 9,
                Code = "OHI",
                Description = "Other health impairment"
            });
            data.Add(new RefDisabilityType()
            {
                RefDisabilityTypeId = 10,
                Code = "SLD",
                Description = "Specific learning disability"
            });
            data.Add(new RefDisabilityType()
            {
                RefDisabilityTypeId = 11,
                Code = "SLI",
                Description = "Speech or language impairment"
            });
            data.Add(new RefDisabilityType()
            {
                RefDisabilityTypeId = 12,
                Code = "TBI",
                Description = "Traumatic brain injury"
            });
            data.Add(new RefDisabilityType()
            {
                RefDisabilityTypeId = 13,
                Code = "VI",
                Description = "Visual impairment"
            });

            return data;
        }
    }
}
