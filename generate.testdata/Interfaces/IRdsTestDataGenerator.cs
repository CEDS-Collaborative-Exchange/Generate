using generate.core.Helpers.TestDataHelper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.testdata.Interfaces
{
    public interface IRdsTestDataGenerator
    {
        StringBuilder GenerateTestData(int seed, int quantityOfStudents, string formatType, string outputType, string filePath);
    }
}
