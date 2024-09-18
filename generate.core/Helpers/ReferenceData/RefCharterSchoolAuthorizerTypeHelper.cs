using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefCharterSchoolAuthorizerTypeHelper
    {

        public static List<RefCharterSchoolAuthorizerType> GetData()
        {
            /*
            select 'data.Add(new RefCharterSchoolAuthorizerType() { 
            RefCharterSchoolAuthorizerTypeId = ' + convert(varchar(20), RefCharterSchoolAuthorizerTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefCharterSchoolAuthorizerType
            */

            var data = new List<RefCharterSchoolAuthorizerType>();

            data.Add(new RefCharterSchoolAuthorizerType()
            {
                RefCharterSchoolAuthorizerTypeId = 5,
                Code = "SEA",
                Description = ""
            });
            data.Add(new RefCharterSchoolAuthorizerType()
            {
                RefCharterSchoolAuthorizerTypeId = 6,
                Code = "SBE",
                Description = ""
            });
            data.Add(new RefCharterSchoolAuthorizerType()
            {
                RefCharterSchoolAuthorizerTypeId = 7,
                Code = "PCSB",
                Description = ""
            });
            data.Add(new RefCharterSchoolAuthorizerType()
            {
                RefCharterSchoolAuthorizerTypeId = 8,
                Code = "LEA",
                Description = ""
            });
            data.Add(new RefCharterSchoolAuthorizerType()
            {
                RefCharterSchoolAuthorizerTypeId = 9,
                Code = "UNI",
                Description = ""
            });
            data.Add(new RefCharterSchoolAuthorizerType()
            {
                RefCharterSchoolAuthorizerTypeId = 10,
                Code = "CC",
                Description = ""
            });
            data.Add(new RefCharterSchoolAuthorizerType()
            {
                RefCharterSchoolAuthorizerTypeId = 11,
                Code = "NONPROFIT",
                Description = ""
            });
            data.Add(new RefCharterSchoolAuthorizerType()
            {
                RefCharterSchoolAuthorizerTypeId = 12,
                Code = "GOVTENT",
                Description = ""
            });
            data.Add(new RefCharterSchoolAuthorizerType()
            {
                RefCharterSchoolAuthorizerTypeId = 13,
                Code = "OTH",
                Description = ""
            });

            return data;
        }
    }
}
