using generate.core.Helpers.TestDataHelper;
using generate.core.Models.IDS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.testdata.Interfaces
{
    public interface IIdsTestDataGenerator
    {
        IdsTestDataObject GetFreshTestDataObject(int seaOrganizationId = 0);
        IdsTestDataObject CreateGenerateOrganization(Random rnd, IdsTestDataObject testData, out int generateOrganizationId);
        IdsTestDataObject CreateRoles(IdsTestDataObject testData, int generateOrganizationId);
        IdsTestDataObject CreateOrganizations(Random rnd, int quantityInBatch, int seaOrganizationId, RefState refState);
        IdsTestDataObject CreateSea(Random rnd, IdsTestDataObject testData, out int seaOrganizationId, out RefState refState);
        IdsTestDataObject CreatePersons(Random rnd, int quantityInBatch, int seaOrganizationId, RefState refState);

        void GenerateTestData(int seed, int quantityOfStudents, int schoolYear, string formatType, string outputType, string filePath);
    }
}
