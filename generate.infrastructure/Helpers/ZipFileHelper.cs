using generate.core.Interfaces.Helpers;
using System;
using System.Collections.Generic;
using System.IO.Compression;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.infrastructure.Utilities
{
    public class ZipFileHelper : IZipFileHelper
    {
        public void UncompressFile(string fileNameWithPath, string targetPath)
        {
            ZipFile.ExtractToDirectory(fileNameWithPath, targetPath, null, true);
        }

        public void CompressDirectory(string sourceDirectory, string targetFileName)
        {
            ZipFile.CreateFromDirectory(sourceDirectory, targetFileName);
        }
    }
}
