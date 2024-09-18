using generate.shared.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;
using System.IO.Abstractions;
using System.IO.Abstractions.TestingHelpers;

namespace generate.test.Core.Utilities
{
    public class FileUtilitiesShould
    {


        private MockFileSystem SetupFileSystem()
        {
            var fileSystem = new MockFileSystem(new Dictionary<string, MockFileData>
            {
                { @"c:\generate.web\test1.txt", new MockFileData("test content") },
                { @"c:\generate.web\test2.txt", new MockFileData("test content") },
                { @"c:\generate.web\Updates\test3.txt", new MockFileData("test content") },
                { @"c:\generate.web\Updates\generate.web_3.0\test4.txt", new MockFileData("test content") }
            });

            return fileSystem;
        }


        [Fact]
        public void DirectoryCopy()
        {
            // Arrange
            var fileSystem = SetupFileSystem();

            var sourceDirName = @"C:\generate.web";
            var destDirName = @"C:\destination";

            Assert.False(fileSystem.Directory.Exists(destDirName));

            // Act
            FileUtilities.DirectoryCopy(fileSystem, sourceDirName, destDirName, true);

            // Assert

            Assert.True(fileSystem.Directory.Exists(destDirName));
            Assert.True(fileSystem.FileExists(@"C:\destination\test1.txt"));
            Assert.True(fileSystem.FileExists(@"C:\destination\test2.txt"));
            Assert.True(fileSystem.FileExists(@"C:\destination\Updates\test3.txt"));
            Assert.True(fileSystem.FileExists(@"C:\destination\Updates\generate.web_3.0\test4.txt"));
        }


        [Fact]
        public void DirectoryCopy_ExcludeDir()
        {
            // Arrange
            var fileSystem = SetupFileSystem();

            var sourceDirName = @"C:\generate.web";
            var destDirName = @"C:\destination";

            Assert.False(fileSystem.Directory.Exists(destDirName));

            // Act
            FileUtilities.DirectoryCopy(fileSystem, sourceDirName, destDirName, true, @"C:\generate.web\Updates\generate.web_3.0");

            // Assert

            Assert.True(fileSystem.Directory.Exists(destDirName));
            Assert.True(fileSystem.FileExists(@"C:\destination\test1.txt"));
            Assert.True(fileSystem.FileExists(@"C:\destination\test2.txt"));
            Assert.True(fileSystem.FileExists(@"C:\destination\Updates\test3.txt"));
            Assert.False(fileSystem.FileExists(@"C:\destination\Updates\generate.web_3.0\test4.txt"));
        }

        [Fact]
        public void DirectoryCopy_NoSubDirs()
        {
            // Arrange
            var fileSystem = SetupFileSystem();

            var sourceDirName = @"C:\generate.web";
            var destDirName = @"C:\destination";

            Assert.False(fileSystem.Directory.Exists(destDirName));

            // Act
            FileUtilities.DirectoryCopy(fileSystem, sourceDirName, destDirName, false);

            // Assert

            Assert.True(fileSystem.Directory.Exists(destDirName));
            Assert.True(fileSystem.FileExists(@"C:\destination\test1.txt"));
            Assert.True(fileSystem.FileExists(@"C:\destination\test2.txt"));
            Assert.False(fileSystem.FileExists(@"C:\destination\Updates\test3.txt"));
            Assert.False(fileSystem.FileExists(@"C:\destination\Updates\generate.web_3.0\test4.txt"));
        }




        [Fact]
        public void DirectoryCopy_DestinationAlreadyExists()
        {
            // Arrange
            var fileSystem = SetupFileSystem();

            fileSystem.Directory.CreateDirectory(@"C:\destination");

            var sourceDirName = @"C:\generate.web";
            var destDirName = @"C:\destination";

            Assert.True(fileSystem.Directory.Exists(destDirName));

            // Act
            FileUtilities.DirectoryCopy(fileSystem, sourceDirName, destDirName, true);

            // Assert

            Assert.True(fileSystem.Directory.Exists(destDirName));
            Assert.True(fileSystem.FileExists(@"C:\destination\test1.txt"));
            Assert.True(fileSystem.FileExists(@"C:\destination\test2.txt"));
            Assert.True(fileSystem.FileExists(@"C:\destination\Updates\test3.txt"));
            Assert.True(fileSystem.FileExists(@"C:\destination\Updates\generate.web_3.0\test4.txt"));
        }


        [Fact]
        public void DirectoryCopy_SourceDoesNotExist()
        {
            // Arrange
            var fileSystem = SetupFileSystem();

            fileSystem.Directory.CreateDirectory(@"C:\destination");

            var sourceDirName = @"C:\source";
            var destDirName = @"C:\destination";

            Assert.False(fileSystem.Directory.Exists(sourceDirName));

            // Act
            Exception ex = Assert.Throws<InvalidOperationException>(() => FileUtilities.DirectoryCopy(fileSystem, sourceDirName, destDirName, true));

            // Assert 

            Assert.Equal(@"Source directory does not exist or could not be found: C:\source", ex.Message);
        }

    }
}
