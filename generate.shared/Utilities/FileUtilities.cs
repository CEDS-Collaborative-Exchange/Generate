using System;
using System.Collections.Generic;
using System.IO.Abstractions;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.shared.Utilities
{
    public static class FileUtilities
    {
        public static void DirectoryCopy(IFileSystem fileSystem, string sourceDirName, string destDirName, bool copySubDirs, string excludeSubDir = null)
        {

            if (!fileSystem.Directory.Exists(sourceDirName))
            {
                throw new InvalidOperationException(
                    "Source directory does not exist or could not be found: "
                    + sourceDirName);
            }

            // Check if does not yet exist
            if (!fileSystem.Directory.Exists(destDirName))
            {
                fileSystem.Directory.CreateDirectory(destDirName);
            }

            // Get the files in the directory and copy them to the new location.
            foreach (var file in fileSystem.Directory.GetFiles(sourceDirName, "*.*", System.IO.SearchOption.TopDirectoryOnly))
            {
                string temppath = fileSystem.Path.Combine(destDirName, fileSystem.Path.GetFileName(file));
                fileSystem.File.Copy(file, temppath, true);
            }


            // If copying subdirectories, copy them and their contents to new location.
            if (copySubDirs)
            {
                var dirs = fileSystem.Directory.GetDirectories(sourceDirName);

                foreach (var subdir in dirs)
                {
                    // Exclude subdir if equals destination directory
                    if (excludeSubDir == null || !subdir.ToLower().StartsWith(excludeSubDir.ToLower()))
                    {
                        string temppath = fileSystem.Path.Combine(destDirName, subdir.Substring(subdir.LastIndexOf(fileSystem.Path.DirectorySeparatorChar) + 1));
                        DirectoryCopy(fileSystem, subdir, temppath, copySubDirs, excludeSubDir);
                    }
                }
            }
        }

    }
}
