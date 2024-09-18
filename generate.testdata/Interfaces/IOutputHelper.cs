using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.testdata.Interfaces
{
    public interface IOutputHelper
    {
        void DeleteExistingFiles(string testDataType, string filePath = ".");
        StringBuilder AppendOutputIfNotEmpty(StringBuilder output, string textToAdd);
        void WriteOutput(StringBuilder output, string testDataType, string formatType, string outputType, string filePath, string sectionName = null);
        


        string GetTestDataValuesSql(object[] collection, Type objectType, string collectionName, string schema, bool usesIdentity);
        string GetPropertyOutputSqlFields(Type type);
        string GetPropertyOutputSqlValues(object obj, Type type);
        string GetTestDataValuesCSharp(object[] collection, Type objectType, string collectionName, string commaText);
        string GetPropertyOutputCSharp(object obj, Type type);


        StringBuilder CreateStartOutput(string sectionName, int quantity, string formatType, int seed, string testDataType);
        StringBuilder AddSqlDeletesToOutput(StringBuilder output, string testDataType);
        StringBuilder AddRepopulationOfSourceSystemReferenceData(StringBuilder output, string testDataType, int schoolYear, Boolean isStartingSY);
        StringBuilder AddEndToOutput(StringBuilder output, string formatType);
        StringBuilder CreateSqlPowershellScript(List<string> scriptsToExecute);
        StringBuilder UpdateCEDSValuesToNonCEDS(StringBuilder output);
    }
}
