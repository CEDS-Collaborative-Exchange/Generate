using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Helpers
{
    public interface IZipFileHelper
    {
        void UncompressFile(string fileNameWithPath, string targetPath);
        void CompressDirectory(string sourceDirectory, string targetFileName);
    }
}
