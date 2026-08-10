using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefLanguageUseTypeHelper
    {

        public static List<RefLanguageUseType> GetData()
        {
            /*
            select 'data.Add(new RefLanguageUseType() { 
            RefLanguageUseTypeId = ' + convert(varchar(20), RefLanguageUseTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefLanguageUseType
            */

            var data = new List<RefLanguageUseType>();

            data.Add(new RefLanguageUseType() { RefLanguageUseTypeId = 1, Code = "Correspondence", Description = "Correspondence language" });
            data.Add(new RefLanguageUseType() { RefLanguageUseTypeId = 2, Code = "Dominant", Description = "Dominant language" });
            data.Add(new RefLanguageUseType() { RefLanguageUseTypeId = 3, Code = "Home", Description = "Home language" });
            data.Add(new RefLanguageUseType() { RefLanguageUseTypeId = 4, Code = "Native", Description = "Native language" });
            data.Add(new RefLanguageUseType() { RefLanguageUseTypeId = 5, Code = "OtherLanguageProficiency", Description = "Other language proficiency" });
            data.Add(new RefLanguageUseType() { RefLanguageUseTypeId = 6, Code = "Other", Description = "Other" });


            return data;
        }
    }
}
