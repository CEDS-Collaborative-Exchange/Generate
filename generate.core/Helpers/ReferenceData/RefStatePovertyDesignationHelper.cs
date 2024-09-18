using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefStatePovertyDesignationHelper
    {

        public static List<RefStatePovertyDesignation> GetData()
        {
            /*
            select 'data.Add(new RefStatePovertyDesignation() { 
            RefStatePovertyDesignationId = ' + convert(varchar(20), RefStatePovertyDesignationId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefStatePovertyDesignation
            */

            var data = new List<RefStatePovertyDesignation>();

            data.Add(new RefStatePovertyDesignation() { RefStatePovertyDesignationId = 1, Code = "HighQuartile", Description = " High poverty quartile school" });
            data.Add(new RefStatePovertyDesignation() { RefStatePovertyDesignationId = 2, Code = "LowQuartile", Description = "Low poverty quartile school" });
            data.Add(new RefStatePovertyDesignation() { RefStatePovertyDesignationId = 3, Code = "Neither", Description = "Neither high nor low poverty quartile school" });

            return data;
        }
    }
}
