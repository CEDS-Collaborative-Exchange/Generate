using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Helpers.ReferenceData
{
    public static class RefTitleIiilanguageInstructionProgramTypeHelper
    {

        public static List<RefTitleIiilanguageInstructionProgramType> GetData()
        {
            /*
            select 'data.Add(new RefTitleIiilanguageInstructionProgramType() { 
            RefTitleIiilanguageInstructionProgramTypeId = ' + convert(varchar(20), RefTitleIiilanguageInstructionProgramTypeId) + ',
            Code = "' + Code + '",
            Description = "' + [Description] + '"
            });'
            from dbo.RefTitleIiilanguageInstructionProgramType
            */

            var data = new List<RefTitleIiilanguageInstructionProgramType>();

            data.Add(new RefTitleIiilanguageInstructionProgramType() { RefTitleIiilanguageInstructionProgramTypeId = 1, Code = "DualLanguage", Description = "Dual language" });
            data.Add(new RefTitleIiilanguageInstructionProgramType() { RefTitleIiilanguageInstructionProgramTypeId = 2, Code = "TwoWayImmersion", Description = "Two-way immersion" });
            data.Add(new RefTitleIiilanguageInstructionProgramType() { RefTitleIiilanguageInstructionProgramTypeId = 3, Code = "TransitionalBilingual", Description = "Transitional bilingual" });
            data.Add(new RefTitleIiilanguageInstructionProgramType() { RefTitleIiilanguageInstructionProgramTypeId = 4, Code = "DevelopmentalBilingual", Description = "Developmental bilingual" });
            data.Add(new RefTitleIiilanguageInstructionProgramType() { RefTitleIiilanguageInstructionProgramTypeId = 5, Code = "HeritageLanguage", Description = "Heritage language" });
            data.Add(new RefTitleIiilanguageInstructionProgramType() { RefTitleIiilanguageInstructionProgramTypeId = 6, Code = "ShelteredEnglishInstruction", Description = "Sheltered English instruction" });
            data.Add(new RefTitleIiilanguageInstructionProgramType() { RefTitleIiilanguageInstructionProgramTypeId = 7, Code = "StructuredEnglishImmersion", Description = "Structured English immersion" });
            data.Add(new RefTitleIiilanguageInstructionProgramType() { RefTitleIiilanguageInstructionProgramTypeId = 8, Code = "SDAIE", Description = "Specially designed academic instruction delivered in English (SDAIE)" });
            data.Add(new RefTitleIiilanguageInstructionProgramType() { RefTitleIiilanguageInstructionProgramTypeId = 9, Code = "ContentBasedESL", Description = "Content-based ESL" });
            data.Add(new RefTitleIiilanguageInstructionProgramType() { RefTitleIiilanguageInstructionProgramTypeId = 10, Code = "PullOutESL", Description = "Pull-out ESL" });
            data.Add(new RefTitleIiilanguageInstructionProgramType() { RefTitleIiilanguageInstructionProgramTypeId = 11, Code = "NewcomerPrograms", Description = "Newcomer Programs" });
            data.Add(new RefTitleIiilanguageInstructionProgramType() { RefTitleIiilanguageInstructionProgramTypeId = 12, Code = "Other", Description = "Other" });

            return data;
        }
    }
}
