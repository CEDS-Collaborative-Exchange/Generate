using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Abstractions;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.shared.Utilities
{
    public static class FileUtilities
    {
        // Overwriting a file that's currently loaded/locked by a running process (e.g. this
        // app's own assembly DLLs during a self-update) fails with IOException/
        // UnauthorizedAccessException. Windows allows renaming an in-use file even though it
        // disallows overwriting its contents, so on that failure we rename the locked file aside
        // (the running process keeps working off its already-open handle to it) and copy the new
        // file in under the original name, ready for the next start.
        public static void SafeCopyFile(IFileSystem fileSystem, string sourceFile, string destFile)
        {
            try
            {
                fileSystem.File.Copy(sourceFile, destFile, true);
                return;
            }
            catch (Exception ex) when (ex is IOException || ex is UnauthorizedAccessException)
            {
                if (!fileSystem.File.Exists(destFile))
                {
                    throw;
                }
            }

            string oldFile = destFile + "." + DateTime.UtcNow.Ticks + ".old";
            fileSystem.File.Move(destFile, oldFile);
            fileSystem.File.Copy(sourceFile, destFile, true);
        }

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
                SafeCopyFile(fileSystem, file, temppath);
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
