using generate.core.Config;
using generate.core.Dtos.App;
using generate.core.Interfaces.Helpers;
using generate.core.Interfaces.Repositories.App;
using generate.core.Models.App;
using generate.infrastructure.Contexts;
using generate.infrastructure.Repositories.App;
using generate.infrastructure.Services;
using generate.test.Infrastructure.Fixtures;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Moq;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.IO.Abstractions.TestingHelpers;
using System.Linq;
using System.Net;
using Xunit;

namespace generate.test.Infrastructure.Services
{
    public class AppUpdateServiceShould
    {
        #region FileSystem


        private MockFileSystem SetupFileSystem_Empty()
        {

            var fileSystem = new MockFileSystem(new Dictionary<string, MockFileData> { });
            fileSystem.Directory.CreateDirectory(@"c:\generate.web");
            fileSystem.Directory.CreateDirectory(@"c:\generate.web\Updates");

            return fileSystem;
        }

        private MockFileSystem SetupFileSystem_MultipleFiles()
        {
            var updatePackage = new UpdatePackageDto()
            {
                FileName = "generate_3.0.zip",
                Description = "Minor Release",
                MajorVersion = 3,
                MinorVersion = 0,
                PrerequisiteVersion = "2.9",
                ReleaseDate = new DateTime(2019, 1, 15),
                DatabaseBackupSuggested = false,
                ReleaseNotesUrl = "https://ciidta.grads360.org/#communities/pdc/documents/17671"
            };

            var fileSystem = new MockFileSystem(new Dictionary<string, MockFileData>
            {
                // Invalid Files
                { @"c:\generate.web\Updates\nonzipfile.txt", new MockFileData("test content") },
                { @"c:\generate.web\Updates\zipfile_extra_underscores.zip", new MockFileData("test content") },
                { @"c:\generate.web\Updates\zipfilenounderscores.zip", new MockFileData("test content") },
                { @"c:\generate.web\Updates\zipfileshortversion_2.zip", new MockFileData("test content") },
                { @"c:\generate.web\Updates\zipfilelongversion_2.3.3.zip", new MockFileData("test content") },

                // Valid Files
                { @"c:\generate.web\Updates\generate_3.0.zip", new MockFileData("test content") },
                { @"c:\generate.web\Updates\generate_3.0.json", new MockFileData(JsonConvert.SerializeObject(updatePackage)) },

                { @"c:\generate.web\Updates\generate_3.1.zip", new MockFileData("test content") },
                { @"c:\generate.web\Updates\generate_3.1.json", new MockFileData(JsonConvert.SerializeObject(updatePackage)) },

                { @"c:\generate.web\Updates\generate_4.0.zip", new MockFileData("test content") },
                { @"c:\generate.web\Updates\generate_4.0.json", new MockFileData(JsonConvert.SerializeObject(updatePackage)) },

                { @"c:\generate.web\Updates\generate_4.1.zip", new MockFileData("test content") },
                { @"c:\generate.web\Updates\generate_4.1.json", new MockFileData(JsonConvert.SerializeObject(updatePackage)) },

                { @"c:\generate.web\Updates\generate_4.2.zip", new MockFileData("test content") },

            });

            return fileSystem;
        }

        private MockFileSystem SetupFileSystem_SingleValidUpdate()
        {
            var updatePackage = new UpdatePackageDto()
            {
                FileName = "generate_3.0.zip",
                Description = "Minor Release",
                MajorVersion = 3,
                MinorVersion = 0,
                PrerequisiteVersion = "2.9",
                ReleaseDate = new DateTime(2019, 1, 15),
                DatabaseBackupSuggested = false,
                ReleaseNotesUrl = "https://ciidta.grads360.org/#communities/pdc/documents/17671"
            };

            var fileSystem = new MockFileSystem(new Dictionary<string, MockFileData>
            {
                // Valid Files
                { @"c:\generate.web\Updates\generate_3.0.zip", new MockFileData("test content") },
                { @"c:\generate.web\Updates\generate_3.0.json", new MockFileData(JsonConvert.SerializeObject(updatePackage)) },
                { @"c:\generate.web\Updates\app_offline.htm", new MockFileData("offline") }
        });

            return fileSystem;
        }

        private MockFileSystem SetupFileSystem_SingleValidUpdate_WrongPrerequisite()
        {
            var updatePackage = new UpdatePackageDto()
            {
                FileName = "generate_4.0.zip",
                Description = "Minor Release",
                MajorVersion = 4,
                MinorVersion = 0,
                PrerequisiteVersion = "3.0",
                ReleaseDate = new DateTime(2019, 1, 15),
                DatabaseBackupSuggested = false,
                ReleaseNotesUrl = "https://ciidta.grads360.org/#communities/pdc/documents/17671"
            };

            var fileSystem = new MockFileSystem(new Dictionary<string, MockFileData>
            {
                // Valid Files
                { @"c:\generate.web\Updates\generate_4.0.zip", new MockFileData("test content") },
                { @"c:\generate.web\Updates\generate_4.0.json", new MockFileData(JsonConvert.SerializeObject(updatePackage)) },
            });

            return fileSystem;
        }

        private MockFileSystem SetupFileSystem_SingleWithSqlScript()
        {

            var testsql = "select '{' as test1, '}' as test2 from app.GenerateConfigurations;";
            var testsql2 = "select 'x' as test1 from app.GenerateConfigurations;";
            var updateScripts = "testscript.sql\n\ntestscript2.sql\n\r";

            var fileSystem = new MockFileSystem(new Dictionary<string, MockFileData>
            {
                // Valid Files
                { @"c:\generate.web\Updates\generate_3.0\database\testscript.sql", new MockFileData(testsql) },
                { @"c:\generate.web\Updates\generate_3.0\database\testscript2.sql", new MockFileData(testsql2) },
                { @"c:\generate.web\Updates\generate_3.0\database\UpdateScripts.csv", new MockFileData(updateScripts) }
            });

            return fileSystem;
        }

        private MockFileSystem SetupFileSystem_WebFilesToBeDeleted()
        {
            var fileSystem = this.SetupFileSystem_SingleValidUpdate();

            this.MockUncompressValidUpdatePackage(fileSystem, @"c:\generate.web\Updates\generate_3.0.zip", @"c:\generate.web\Updates");

            // Add file to be deleted
            MockFileData fileToBeDeleted = new MockFileData("html content");
            fileSystem.AddFile(@"c:\generate.web\test.html", fileToBeDeleted);


            // Replace empty file with file containing contents
            fileSystem.RemoveFile(@"c:\generate.web\Updates\generate_3.0\web_tobedeleted.csv");
            MockFileData filesToBeDeleted = new MockFileData("test.html\n\nfileDoesNotExist.html\n\r");
            fileSystem.AddFile(@"c:\generate.web\Updates\generate_3.0\web_tobedeleted.csv", filesToBeDeleted);
            
            return fileSystem;
        }


        private MockFileSystem SetupFileSystem_AllFilesToBeDeleted()
        {
            var fileSystem = this.SetupFileSystem_SingleValidUpdate();

            this.MockUncompressValidUpdatePackage(fileSystem, @"c:\generate.web\Updates\generate_3.0.zip", @"c:\generate.web\Updates");

            // Add file to be deleted
            MockFileData fileToBeDeleted = new MockFileData("html content");
            fileSystem.AddFile(@"c:\generate.web\test.html", fileToBeDeleted);


            // Replace empty file with file containing contents
            fileSystem.RemoveFile(@"c:\generate.web\Updates\generate_3.0\web_tobedeleted.csv");
            MockFileData filesToBeDeleted = new MockFileData("*.*\n\r");
            fileSystem.AddFile(@"c:\generate.web\Updates\generate_3.0\web_tobedeleted.csv", filesToBeDeleted);

            return fileSystem;
        }

        private MockFileSystem SetupFileSystem_BackgroundUpdate()
        {
            var updatePackage = new UpdatePackageDto()
            {
                FileName = "generate_3.0.zip",
                Description = "Minor Release",
                MajorVersion = 3,
                MinorVersion = 0,
                PrerequisiteVersion = "2.9",
                ReleaseDate = new DateTime(2019, 1, 15),
                DatabaseBackupSuggested = false,
                ReleaseNotesUrl = "https://ciidta.grads360.org/#communities/pdc/documents/17671"
            };


            var fileSystem = new MockFileSystem(new Dictionary<string, MockFileData>
            {
                // Valid Files
                { @"c:\generate.web\Updates\generate_3.0.zip", new MockFileData("test content") },
                { @"c:\generate.web\Updates\generate_3.0.json", new MockFileData(JsonConvert.SerializeObject(updatePackage)) },
                { @"c:\generate.web\Updates\generate_3.0\background\test.htm", new MockFileData("test") }
            });

            fileSystem.Directory.CreateDirectory(@"c:\generate.background");

            return fileSystem;
        }

        #endregion

        #region Context
        private AppDbContext GetContext()
        {

            var options = new DbContextOptionsBuilder<infrastructure.Contexts.AppDbContext>()
                              .UseInMemoryDatabase(Guid.NewGuid().ToString())
                              .Options;

            var logger = Mock.Of<ILogger<AppDbContext>>();

            var appSettings = Mock.Of<IOptions<AppSettings>>();

            var context = new AppDbContext(options, logger, appSettings);

            return context;
        }

        private AppDbContext GetContextWithData()
        {

            var context = this.GetContext();
            var repository = new AppRepository(context);

            GenerateConfiguration configVersion = new GenerateConfiguration()
            {
                GenerateConfigurationId = 1,
                GenerateConfigurationCategory = "Database",
                GenerateConfigurationKey = "DatabaseVersion",
                GenerateConfigurationValue = "2.9"
            };
            repository.Create<GenerateConfiguration>(configVersion);

            GenerateConfiguration configDevUrl = new GenerateConfiguration()
            {
                GenerateConfigurationId = 2,
                GenerateConfigurationCategory = "AppUpdate",
                GenerateConfigurationKey = "DevUrl",
                GenerateConfigurationValue = "https://generate-update-dev.aem-tx.com"
            };
            repository.Create<GenerateConfiguration>(configDevUrl);

            GenerateConfiguration configTestUrl = new GenerateConfiguration()
            {
                GenerateConfigurationId = 3,
                GenerateConfigurationCategory = "AppUpdate",
                GenerateConfigurationKey = "TestUrl",
                GenerateConfigurationValue = "https://generate-update-test.aem-tx.com"
            };
            repository.Create<GenerateConfiguration>(configTestUrl);

            GenerateConfiguration configStageUrl = new GenerateConfiguration()
            {
                GenerateConfigurationId = 4,
                GenerateConfigurationCategory = "AppUpdate",
                GenerateConfigurationKey = "StageUrl",
                GenerateConfigurationValue = "https://generate-update-stage.aem-tx.com"
            };
            repository.Create<GenerateConfiguration>(configStageUrl);

            GenerateConfiguration configProdUrl = new GenerateConfiguration()
            {
                GenerateConfigurationId = 5,
                GenerateConfigurationCategory = "AppUpdate",
                GenerateConfigurationKey = "ProdUrl",
                GenerateConfigurationValue = "https://generate-update.aem-tx.com"
            };
            repository.Create<GenerateConfiguration>(configProdUrl);

            GenerateConfiguration configStatus = new GenerateConfiguration()
            {
                GenerateConfigurationId = 6,
                GenerateConfigurationCategory = "AppUpdate",
                GenerateConfigurationKey = "Status",
                GenerateConfigurationValue = "OK"
            };
            repository.Create<GenerateConfiguration>(configStatus);

            repository.SaveAsync();

            return context;
        }

        #endregion

        #region Mock Methods

        private void MockUncompressValidUpdatePackage(MockFileSystem mockFileSystem, string fileNameWithPath, string targetPath)
        {
            var updatePackageName = mockFileSystem.Path.GetFileName(fileNameWithPath).Replace(".zip", "");
            var updatePackageDirectory = mockFileSystem.Path.Combine(targetPath, updatePackageName);
            mockFileSystem.Directory.CreateDirectory(updatePackageDirectory);
            mockFileSystem.Directory.CreateDirectory(mockFileSystem.Path.Combine(updatePackageDirectory, "web"));
            mockFileSystem.File.CreateText(mockFileSystem.Path.Combine(updatePackageDirectory, "web", "newfile.htm"));
            mockFileSystem.Directory.CreateDirectory(mockFileSystem.Path.Combine(updatePackageDirectory, "database"));
            mockFileSystem.File.CreateText(mockFileSystem.Path.Combine(updatePackageDirectory, "database", "UpdateScripts.csv"));
            mockFileSystem.Directory.CreateDirectory(mockFileSystem.Path.Combine(updatePackageDirectory, "background"));
            mockFileSystem.File.CreateText(mockFileSystem.Path.Combine(updatePackageDirectory, "web_todelete.csv"));
            mockFileSystem.File.CreateText(mockFileSystem.Path.Combine(updatePackageDirectory, "background_todelete.csv"));
        }

        private void MockUncompressInvalidUpdatePackage(MockFileSystem mockFileSystem, string fileNameWithPath, string targetPath)
        {
            var updatePackageName = mockFileSystem.Path.GetFileName(fileNameWithPath).Replace(".zip", "");
            var updatePackageDirectory = mockFileSystem.Path.Combine(targetPath, updatePackageName);
            mockFileSystem.Directory.CreateDirectory(updatePackageDirectory);
            mockFileSystem.Directory.CreateDirectory(mockFileSystem.Path.Combine(updatePackageDirectory, "web"));
            mockFileSystem.File.CreateText(mockFileSystem.Path.Combine(updatePackageDirectory, "web", "newfile.htm"));
            mockFileSystem.Directory.CreateDirectory(mockFileSystem.Path.Combine(updatePackageDirectory, "database"));
            mockFileSystem.File.CreateText(mockFileSystem.Path.Combine(updatePackageDirectory, "database", "UpdateScripts.csv"));
            mockFileSystem.Directory.CreateDirectory(mockFileSystem.Path.Combine(updatePackageDirectory, "background"));
            mockFileSystem.File.CreateText(mockFileSystem.Path.Combine(updatePackageDirectory, "web_todelete.csv"));
            // Invalid because it is missing this file
            //mockFileSystem.File.CreateText(mockFileSystem.Path.Combine(updatePackageDirectory, "background_todelete.csv"));
        }


        private void MockCompressSite(MockFileSystem mockFileSystem, string backupDirectory, string backupZipFile)
        {
            mockFileSystem.File.Create(mockFileSystem.Path.Combine(backupDirectory, backupZipFile));
        }


        private void MockUncompressBackup(MockFileSystem mockFileSystem, string backupZipFile, string backupDirectory)
        {
            mockFileSystem.Directory.CreateDirectory(mockFileSystem.Path.Combine(backupDirectory, "generate.web_backup"));

            MockFileData updatedFile = new MockFileData("html content updated");

            if (backupZipFile.Contains("background"))
            {
                mockFileSystem.AddFile(@"c:\generate.background\test.html", updatedFile);
            }
            else
            {
                mockFileSystem.AddFile(@"c:\generate.web\test.html", updatedFile);
            }

        }

        #endregion

        #region Tests


        [Fact]
        public void GetCurrentVersion()
        {
            using (var context = GetContextWithData())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

                // Act
                var currentVersion = service.GetCurrentVersion();

                // Assert
                Assert.Equal("2.9", currentVersion);

            }
        }


        [Fact]
        public void GetStatus()
        {
            using (var context = GetContextWithData())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = new Mock<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings.Object, zipFileHelper);

                // Act

                var currentStatus = service.GetUpdateStatus();

                // Assert
                Assert.Equal("OK", currentStatus.Status);

            }
        }



        [Fact]
        public void GetStatus_KeyMissing()
        {
            using (var context = GetContextWithData())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = new Mock<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();


                GenerateConfiguration configStatus = context.GenerateConfigurations.Single(x => x.GenerateConfigurationCategory == "AppUpdate" && x.GenerateConfigurationKey == "Status");
                context.GenerateConfigurations.Remove(configStatus);
                context.SaveChanges();

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings.Object, zipFileHelper);

                // Act

                var currentStatus = service.GetUpdateStatus();

                // Assert
                Assert.Equal("OK", currentStatus.Status);

            }
        }

        [Fact]
        public void GetUpdateUrl_Dev()
        {
            using (var context = GetContextWithData())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = new Mock<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();


                appSettings.Setup(x => x.Value).Returns(new AppSettings()
                {
                    Environment = "development"
                });

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings.Object, zipFileHelper);

                // Act

                var currentUrl = service.GetUpdateUrl();

                // Assert
                Assert.Equal("https://generate-update-dev.aem-tx.com", currentUrl);

            }
        }


        [Fact]
        public void GetUpdateUrl_Test()
        {
            using (var context = GetContextWithData())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = new Mock<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();


                appSettings.Setup(x => x.Value).Returns(new AppSettings()
                {
                    Environment = "test"
                });

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings.Object, zipFileHelper);

                // Act

                var currentUrl = service.GetUpdateUrl();

                // Assert
                Assert.Equal("https://generate-update-test.aem-tx.com", currentUrl);

            }
        }


        [Fact]
        public void GetUpdateUrl_Stage()
        {
            using (var context = GetContextWithData())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = new Mock<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();


                appSettings.Setup(x => x.Value).Returns(new AppSettings()
                {
                    Environment = "stage"
                });

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings.Object, zipFileHelper);

                // Act

                var currentUrl = service.GetUpdateUrl();

                // Assert
                Assert.Equal("https://generate-update-stage.aem-tx.com", currentUrl);

            }
        }



        [Fact]
        public void GetUpdateUrl_Prod()
        {
            using (var context = GetContextWithData())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = new Mock<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();


                appSettings.Setup(x => x.Value).Returns(new AppSettings()
                {
                    Environment = "production"
                });

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings.Object, zipFileHelper);

                // Act

                var currentUrl = service.GetUpdateUrl();

                // Assert
                Assert.Equal("https://generate-update.aem-tx.com", currentUrl);

            }
        }


        [Fact]
        public void GetUpdateUrl_Invalid()
        {
            using (var context = GetContext())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = new Mock<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();


                appSettings.Setup(x => x.Value).Returns(new AppSettings()
                {
                    Environment = "production"
                });

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings.Object, zipFileHelper);
                
                // Act
                Exception ex = Assert.Throws<InvalidOperationException>(() => service.GetUpdateUrl());

                // Assert 

                Assert.Equal("Cannot determine update URL", ex.Message);

            }
        }

        [Fact]
        public void GetCurrentVersion_NoVersion()
        {
            using (var context = GetContext())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();


                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

                // Act
                Exception ex = Assert.Throws<InvalidOperationException>(() => service.GetCurrentVersion());

                // Assert 

                Assert.Equal("Cannot determine current app version", ex.Message);
            }
        }

        [Fact]
        public void GetPendingUpdates_NoVersion()
        {

            // Arrange
            var fileSystem = SetupFileSystem_MultipleFiles();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelper = Mock.Of<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();

            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

            // Act
            var results = service.GetPendingUpdates(@"c:\generate.web\");

            // Assert
            Assert.NotEmpty(results);
            Assert.Equal(4, results.Count);

        }

        [Fact]
        public void GetPendingUpdates_LowVersion()
        {

            // Arrange
            var fileSystem = SetupFileSystem_MultipleFiles();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelper = Mock.Of<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();

            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

            // Act
            var results = service.GetPendingUpdates(@"c:\generate.web\", 2, 9);

            // Assert
            Assert.NotEmpty(results);
            Assert.Equal(4, results.Count);

        }

        [Fact]
        public void GetPendingUpdates_MiddleVersion()
        {

            // Arrange
            var fileSystem = SetupFileSystem_MultipleFiles();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelper = Mock.Of<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();

            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

            // Act
            var results = service.GetPendingUpdates(@"c:\generate.web\", 3, 2);

            // Assert
            Assert.NotEmpty(results);
            Assert.Equal(2, results.Count);

        }

        [Fact]
        public void GetPendingUpdates_HighVersion()
        {

            // Arrange
            var fileSystem = SetupFileSystem_MultipleFiles();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelper = Mock.Of<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();

            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

            // Act
            var results = service.GetPendingUpdates(@"c:\generate.web\", 4, 2);

            // Assert
            Assert.Empty(results);
 
        }


        //[Fact]
        //public void CheckForPendingUpdates()
        //{
        //    using (var context = GetContextWithData())
        //    {
        //        // Arrange
        //        var fileSystem = SetupFileSystem_MultipleFiles();
        //        var logger = Mock.Of<ILogger<AppUpdateService>>();
        //        var appRepository = new AppRepository(context);
        //        var appSettings = new Mock<IOptions<AppSettings>>();
        //        var zipFileHelper = Mock.Of<IZipFileHelper>();

        //        appSettings.Setup(x => x.Value).Returns(new AppSettings()
        //        {
        //            Environment = "development"
        //        });

        //        var updatePackage = new UpdatePackageDto()
        //        {
        //            FileName = "generate_3.0.zip",
        //            Description = "Minor Release",
        //            MajorVersion = 3,
        //            MinorVersion = 0,
        //            PrerequisiteVersion = "2.9",
        //            ReleaseDate = new DateTime(2019, 1, 15),
        //            DatabaseBackupSuggested = false,
        //            ReleaseNotesUrl = "https://ciidta.grads360.org/#communities/pdc/documents/17671"
        //        };

        //        var data = new List<UpdatePackageDto>();
        //        data.Add(updatePackage);

        //        var responseMock = new Mock<RestResponse<List<UpdatePackageDto>>>();
        //        responseMock.Setup(x => x.StatusCode).Returns(HttpStatusCode.OK);
        //        responseMock.Setup(x => x.Content).Returns(JsonConvert.SerializeObject(data));

        //        var restClientMock = new Mock<RestClient>();
        //        restClientMock
        //          .Setup(x => x.Execute(It.IsAny<RestRequest>()))
        //          .Returns(responseMock.Object);

        //        var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings.Object, zipFileHelperMock.Object);

        //        // Act
        //        var results = service.CheckForPendingUpdates();

        //        // Assert
        //        Assert.NotEmpty(results);
        //        Assert.Single(results);
        //    }
        //}



        //[Fact]
        //public void DownloadUpdates()
        //{
        //    using (var context = GetContextWithData())
        //    {
        //        // Arrange
        //        var fileSystem = SetupFileSystem_Empty();
        //        var logger = Mock.Of<ILogger<AppUpdateService>>();
        //        var appRepository = new AppRepository(context);
        //        var appSettings = new Mock<IOptions<AppSettings>>();
        //        var zipFileHelper = Mock.Of<IZipFileHelper>();

        //        appSettings.Setup(x => x.Value).Returns(new AppSettings()
        //        {
        //            Environment = "development"
        //        });

        //        var updatePackage = new UpdatePackageDto()
        //        {
        //            FileName = "generate_3.0.zip",
        //            Description = "Minor Release",
        //            MajorVersion = 3,
        //            MinorVersion = 0,
        //            PrerequisiteVersion = "2.9",
        //            ReleaseDate = new DateTime(2019, 1, 15),
        //            DatabaseBackupSuggested = false,
        //            ReleaseNotesUrl = "https://ciidta.grads360.org/#communities/pdc/documents/17671"
        //        };

        //        var data = new List<UpdatePackageDto>();
        //        data.Add(updatePackage);

        //        var responseMock = new Mock<RestResponse<List<UpdatePackageDto>>>();
        //        responseMock.Setup(x => x.StatusCode).Returns(HttpStatusCode.OK);
        //        responseMock.Setup(x => x.Content).Returns(JsonConvert.SerializeObject(data));

        //        var restClientMock = new Mock<RestClient>();


        //        byte[] updateResponse = new byte[1];

        //        restClientMock
        //          .Setup(x => x.DownloadData(It.IsAny<RestRequest>()))
        //          .Returns(updateResponse);

        //        //restClientMock
        //        //  .Setup(x => x.Execute(It.IsAny<RestRequest>()))
        //        //  .Returns(responseMock.Object);

        //        //var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings.Object, zipFileHelperMock.Object);

        //        //// Act
        //        //service.DownloadUpdates(@"c:\generate.web");

        //        //// Assert
        //        //Assert.True(fileSystem.FileExists(@"c:\generate.web\Updates\generate_3.0.zip"));
        //        //Assert.True(fileSystem.FileExists(@"c:\generate.web\Updates\generate_3.0.json"));
        //    }
        //}


        //[Fact]
        //public void DownloadUpdates_NonePending()
        //{
        //    using (var context = GetContextWithData())
        //    {
        //        // Arrange
        //        var fileSystem = SetupFileSystem_Empty();
        //        var logger = Mock.Of<ILogger<AppUpdateService>>();
        //        var appRepository = new AppRepository(context);
        //        var appSettings = new Mock<IOptions<AppSettings>>();
        //        var zipFileHelper = Mock.Of<IZipFileHelper>();

        //        appSettings.Setup(x => x.Value).Returns(new AppSettings()
        //        {
        //            Environment = "development"
        //        });
                
        //        var data = new List<UpdatePackageDto>();

        //        var responseMock = new Mock<RestResponse<List<UpdatePackageDto>>>();
        //        responseMock.Setup(x => x.StatusCode).Returns(HttpStatusCode.OK);
        //        responseMock.Setup(x => x.Content).Returns(JsonConvert.SerializeObject(data));

        //        var restClientMock = new Mock<RestClient>();


        //        byte[] updateResponse = new byte[1];

        //        restClientMock
        //          .Setup(x => x.DownloadData(It.IsAny<RestRequest>()))
        //          .Returns(updateResponse);

        //        //restClientMock
        //        //  .Setup(x => x.Execute(It.IsAny<RestRequest>()))
        //        //  .Returns(responseMock.Object);

        //        //var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings.Object, zipFileHelperMock.Object);

        //        //// Act
        //        //service.DownloadUpdates(@"c:\generate.web");

        //        //// Assert
        //        //Assert.False(fileSystem.FileExists(@"c:\generate.web\Updates\generate_3.0.zip"));
        //        //Assert.False(fileSystem.FileExists(@"c:\generate.web\Updates\generate_3.0.json"));
        //    }
        //}

        [Fact]
        public void GetDownloadedUpdates()
        {

            // Arrange
            var fileSystem = SetupFileSystem_MultipleFiles();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelper = Mock.Of<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();

            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

            // Act
            var results = service.GetDownloadedUpdates(@"c:\generate.web\");

            // Assert
            Assert.NotEmpty(results);
            Assert.Equal(4, results.Count);

        }


        [Fact]
        public void ClearUpdates()
        {

            // Arrange
            var fileSystem = SetupFileSystem_SingleValidUpdate();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelper = Mock.Of<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();

            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

            // Act
            service.ClearUpdates(@"c:\generate.web\");

            // Assert
            Assert.NotEmpty(fileSystem.AllFiles);
            Assert.Single(fileSystem.AllFiles);

            var zipFiles = fileSystem.AllFiles.Where(x => x.EndsWith(".zip"));
            Assert.Empty(zipFiles);

            var jsonFiles = fileSystem.AllFiles.Where(x => x.EndsWith(".json"));
            Assert.Empty(jsonFiles);


        }


        [Fact]
        public void ClearUpdates_PackagePathExists()
        {

            // Arrange
            var fileSystem = SetupFileSystem_SingleValidUpdate();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelper = Mock.Of<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();

            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

            fileSystem.AddDirectory(@"c:\generate.web\Updates\generate_3.0");

            // Act
            service.ClearUpdates(@"c:\generate.web\");

            // Assert
            Assert.NotEmpty(fileSystem.AllFiles);
            Assert.Single(fileSystem.AllFiles);

            var zipFiles = fileSystem.AllFiles.Where(x => x.EndsWith(".zip"));
            Assert.Empty(zipFiles);

            var jsonFiles = fileSystem.AllFiles.Where(x => x.EndsWith(".json"));
            Assert.Empty(jsonFiles);


        }


        [Fact]
        public void IsValidUpdatePackageDto_Valid()
        {
            using (var context = GetContextWithData())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();


                this.MockUncompressValidUpdatePackage(fileSystem, @"c:\generate.web\Updates\generate_3.0.zip", @"c:\generate.web\Updates\");

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

                // Act
                bool isValidPackage = service.IsValidUpdatePackageDto(@"c:\generate.web\Updates", @"c:\generate.web\Updates\generate_3.0", "generate_3.0.zip");

                // Assert
                Assert.True(isValidPackage);

            }
        }


        [Fact]
        public void IsValidUpdatePackageDto_Invalid_MissingWeb()
        {
            using (var context = GetContextWithData())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();


                this.MockUncompressValidUpdatePackage(fileSystem, @"c:\generate.web\Updates\generate_3.0.zip", @"c:\generate.web\Updates\");
                fileSystem.Directory.Delete(@"c:\generate.web\Updates\generate_3.0\web", true);

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

                // Act
                bool isValidPackage = service.IsValidUpdatePackageDto(@"c:\generate.web\Updates", @"c:\generate.web\Updates\generate_3.0", "generate_3.0.zip");

                // Assert
                Assert.False(isValidPackage);

            }
        }


        [Fact]
        public void IsValidUpdatePackageDto_Invalid_MissingDatabase()
        {
            using (var context = GetContextWithData())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();


                this.MockUncompressValidUpdatePackage(fileSystem, @"c:\generate.web\Updates\generate_3.0.zip", @"c:\generate.web\Updates\");
                fileSystem.Directory.Delete(@"c:\generate.web\Updates\generate_3.0\database", true);

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

                // Act
                bool isValidPackage = service.IsValidUpdatePackageDto(@"c:\generate.web\Updates", @"c:\generate.web\Updates\generate_3.0", "generate_3.0.zip");

                // Assert
                Assert.False(isValidPackage);

            }
        }


        [Fact]
        public void IsValidUpdatePackageDto_Invalid_MissingBackground()
        {
            using (var context = GetContextWithData())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();


                this.MockUncompressValidUpdatePackage(fileSystem, @"c:\generate.web\Updates\generate_3.0.zip", @"c:\generate.web\Updates\");
                fileSystem.Directory.Delete(@"c:\generate.web\Updates\generate_3.0\background");

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

                // Act
                bool isValidPackage = service.IsValidUpdatePackageDto(@"c:\generate.web\Updates", @"c:\generate.web\Updates\generate_3.0", "generate_3.0.zip");

                // Assert
                Assert.False(isValidPackage);

            }
        }



        [Fact]
        public void IsValidUpdatePackageDto_Invalid_MissingWebToDelete()
        {
            using (var context = GetContextWithData())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();


                this.MockUncompressValidUpdatePackage(fileSystem, @"c:\generate.web\Updates\generate_3.0.zip", @"c:\generate.web\Updates\");
                fileSystem.File.Delete(@"c:\generate.web\Updates\generate_3.0\web_todelete.csv");

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

                // Act
                bool isValidPackage = service.IsValidUpdatePackageDto(@"c:\generate.web\Updates", @"c:\generate.web\Updates\generate_3.0", "generate_3.0.zip");

                // Assert
                Assert.False(isValidPackage);

            }
        }


        [Fact]
        public void IsValidUpdatePackageDto_Invalid_MissingBackgroundToDelete()
        {
            using (var context = GetContextWithData())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();


                this.MockUncompressValidUpdatePackage(fileSystem, @"c:\generate.web\Updates\generate_3.0.zip", @"c:\generate.web\Updates\");
                fileSystem.File.Delete(@"c:\generate.web\Updates\generate_3.0\background_todelete.csv");

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

                // Act
                bool isValidPackage = service.IsValidUpdatePackageDto(@"c:\generate.web\Updates", @"c:\generate.web\Updates\generate_3.0", "generate_3.0.zip");

                // Assert
                Assert.False(isValidPackage);

            }
        }



        [Fact]
        public void IsValidUpdatePackageDto_Invalid_MissingJson()
        {
            using (var context = GetContextWithData())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();


                this.MockUncompressValidUpdatePackage(fileSystem, @"c:\generate.web\Updates\generate_3.0.zip", @"c:\generate.web\Updates\");
                fileSystem.File.Delete(@"c:\generate.web\Updates\generate_3.0.json");

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

                // Act
                bool isValidPackage = service.IsValidUpdatePackageDto(@"c:\generate.web\Updates", @"c:\generate.web\Updates\generate_3.0", "generate_3.0.zip");

                // Assert
                Assert.False(isValidPackage);

            }
        }


        [Fact]
        public void IsValidPrerequisite_Valid()
        {
            using (var context = GetContextWithData())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();


                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

                // Act
                bool isValidPrerequisite = service.IsValidPrerequisite(@"c:\generate.web\Updates\generate_3.0.json");

                // Assert
                Assert.True(isValidPrerequisite);
            }
        }

        [Fact]
        public void IsValidPrerequisite_Invalid()
        {
            using (var context = GetContextWithData())
            {
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate_WrongPrerequisite();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelper = Mock.Of<IZipFileHelper>();


                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

                // Act
                bool isValidPrerequisite = service.IsValidPrerequisite(@"c:\generate.web\Updates\generate_4.0.json");

                // Assert
                Assert.False(isValidPrerequisite);

            }
        }

        [Fact]
        public void ExtractandValidatePackage()
        {
            using (var context = GetContextWithData())
            {
                
                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelperMock = new Mock<IZipFileHelper>();


                zipFileHelperMock.Setup(x => x.UncompressFile(It.IsAny<string>(), It.IsAny<string>())).Callback<string, string>((p, q) => this.MockUncompressValidUpdatePackage(fileSystem, p, q));

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelperMock.Object);

                // Act
                List<string> updatePackages = service.ExtractAndValidateUpdatePackageDtos(@"c:\generate.web\Updates");

                // Assert
                Assert.Single<string>(updatePackages);

            }
        }


        [Fact]
        public void ExtractandValidatePackage_InvalidPackage()
        {
            using (var context = GetContextWithData())
            {

                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelperMock = new Mock<IZipFileHelper>();


                zipFileHelperMock.Setup(x => x.UncompressFile(It.IsAny<string>(), It.IsAny<string>())).Callback<string, string>((p, q) => this.MockUncompressInvalidUpdatePackage(fileSystem, p, q));

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelperMock.Object);

                // Act
                List<string> updatePackages = service.ExtractAndValidateUpdatePackageDtos(@"c:\generate.web\Updates");

                // Assert
                Assert.Empty(updatePackages);
                Assert.False(fileSystem.Directory.Exists(@"c:\\generate.web\\Updates\\generate_4.0"));
                Assert.False(fileSystem.FileExists(@"c:\\generate.web\\Updates\\generate_4.0.json"));
                Assert.False(fileSystem.FileExists(@"c:\\generate.web\\Updates\\generate_4.0.zip"));
            }
        }



        [Fact]
        public void ApplyUpdates()
        {
            using (var context = GetContextWithData())
            {

                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelperMock = new Mock<IZipFileHelper>();


                zipFileHelperMock.Setup(x => x.UncompressFile(It.IsAny<string>(), It.IsAny<string>())).Callback<string, string>((p, q) => this.MockUncompressValidUpdatePackage(fileSystem, p, q));

                var updatePackages = new List<string>();
                updatePackages.Add("generate_3.0.zip");

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelperMock.Object);

                Assert.False(fileSystem.FileExists(@"c:\generate.web\newfile.htm"));

                // Act
                service.ApplyUpdates(updatePackages, @"c:\generate.web\Updates", @"c:\generate.web");

                // Assert
                Assert.True(fileSystem.FileExists(@"c:\generate.web\newfile.htm"));
            }
        }

        [Fact]
        public void ApplyUpdates_BackgroundUpdate()
        {
            using (var context = GetContextWithData())
            {

                // Arrange
                var fileSystem = SetupFileSystem_BackgroundUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelperMock = new Mock<IZipFileHelper>();


                zipFileHelperMock.Setup(x => x.UncompressFile(It.IsAny<string>(), It.IsAny<string>())).Callback<string, string>((p, q) => this.MockUncompressValidUpdatePackage(fileSystem, p, q));

                var updatePackages = new List<string>();
                updatePackages.Add("generate_3.0.zip");

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelperMock.Object);

                Assert.False(fileSystem.FileExists(@"c:\generate.background\test.htm"));

                // Act
                service.ApplyUpdates(updatePackages, @"c:\generate.web\Updates", @"c:\generate.background");

                // Assert
                Assert.True(fileSystem.FileExists(@"c:\generate.background\test.htm"));
            }
        }

        [Fact]
        public void ApplyUpdates_Exception()
        {
            using (var context = GetContextWithData())
            {

                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelperMock = new Mock<IZipFileHelper>();


                zipFileHelperMock.Setup(x => x.UncompressFile(It.IsAny<string>(), It.IsAny<string>())).Callback<string, string>((p, q) => this.MockUncompressInvalidUpdatePackage(fileSystem, p, q));

                var updatePackages = new List<string>();
                updatePackages.Add("generate_3.0.zip");

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelperMock.Object);

                // Act

                Exception ex = Assert.Throws<System.IO.DirectoryNotFoundException>(() => service.ApplyUpdates(updatePackages, @"c:\generate.web\Updates", @"c:\generate_web"));

                // Assert 

                Assert.Equal("Could not find a part of the path 'c:\\generate_web\\newfile.htm'.", ex.Message);


            }
        }


        [Fact]
        public void ApplyUpdates_InvalidPrerequisite()
        {
            using (var context = GetContextWithData())
            {

                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate_WrongPrerequisite();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelperMock = new Mock<IZipFileHelper>();


                zipFileHelperMock.Setup(x => x.UncompressFile(It.IsAny<string>(), It.IsAny<string>())).Callback<string, string>((p, q) => this.MockUncompressValidUpdatePackage(fileSystem, p, q));

                var updatePackages = new List<string>();
                updatePackages.Add("generate_4.0.zip");

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelperMock.Object);

                // Act

                Exception ex = Assert.Throws<InvalidOperationException>(() => service.ApplyUpdates(updatePackages, @"c:\generate.web\Updates", @"c:\generate_web"));

                // Assert 

                Assert.Equal("Update generate_4.0.zip is invalid - prerequisite is not met", ex.Message);


            }
        }

        [Fact]
        public void ExecuteSiteUpdate()
        {
            using (var context = GetContextWithData())
            {

                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelperMock = new Mock<IZipFileHelper>();


                zipFileHelperMock.Setup(x => x.UncompressFile(It.IsAny<string>(), It.IsAny<string>())).Callback<string, string>((p, q) => this.MockUncompressValidUpdatePackage(fileSystem, p, q));

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelperMock.Object);

                Assert.False(fileSystem.FileExists(@"c:\generate.web\newfile.htm"));

                // Act
                service.ExecuteSiteUpdate(@"c:\generate.web", @"c:\generate.web");

                // Assert
                Assert.True(fileSystem.FileExists(@"c:\generate.web\newfile.htm"));


            }
        }

        [Fact]
        public void ExecuteSiteUpdate_NoUpdatesAvailable()
        {
            using (var context = GetContextWithData())
            {

                // Arrange
                var fileSystem = SetupFileSystem_Empty();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelperMock = new Mock<IZipFileHelper>();


                zipFileHelperMock.Setup(x => x.UncompressFile(It.IsAny<string>(), It.IsAny<string>())).Callback<string, string>((p, q) => this.MockUncompressValidUpdatePackage(fileSystem, p, q));

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelperMock.Object);

                // Act
                service.ExecuteSiteUpdate(@"c:\generate.web", @"c:\generate.web");

                // Assert
                Assert.False(fileSystem.FileExists(@"c:\generate.web\newfile.htm"));
                
            }
        }

        [Fact]
        public void ExecuteSiteUpdate_Exception()
        {
            using (var context = GetContextWithData())
            {

                // Arrange
                var fileSystem = SetupFileSystem_SingleValidUpdate();
                var logger = Mock.Of<ILogger<AppUpdateService>>();
                var appRepository = new AppRepository(context);
                var appSettings = Mock.Of<IOptions<AppSettings>>();
                var zipFileHelperMock = new Mock<IZipFileHelper>();


                zipFileHelperMock.Setup(x => x.UncompressFile(It.IsAny<string>(), It.IsAny<string>())).Callback<string, string>((p, q) => this.MockUncompressValidUpdatePackage(fileSystem, p, q));

                var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelperMock.Object);


                // Act
                Exception ex = Assert.Throws<System.IO.DirectoryNotFoundException>(() => service.ExecuteSiteUpdate(@"c:\generate.web", @"c:\generate_web"));

                // Assert 

                Assert.Equal("Could not find a part of the path 'c:\\generate_web\\app_offline.htm'.", ex.Message);


            }
        }



        [Fact]
        public void DeleteUpdatePackage()
        {

            // Arrange
            var fileSystem = SetupFileSystem_SingleValidUpdate();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelper = Mock.Of<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();

            this.MockUncompressValidUpdatePackage(fileSystem, @"c:\generate.web\Updates\generate_3.0.zip", @"c:\generate.web\Updates\");

            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

            // Act
            service.DeleteUpdatePackageDto(@"c:\generate.web\Updates\generate_3.0");

            // Assert
            Assert.True(!fileSystem.Directory.Exists(@"c:\generate.web\Updates\generate_3.0"));
            Assert.True(!fileSystem.FileExists(@"c:\generate.web\Updates\generate_3.0.zip"));
            Assert.True(!fileSystem.FileExists(@"c:\generate.web\Updates\generate_3.0.json"));

        }


        [Fact]
        public void TakeSiteOffline()
        {

            // Arrange
            var fileSystem = SetupFileSystem_SingleValidUpdate();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelper = Mock.Of<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();

            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

            Assert.True(!fileSystem.FileExists(@"c:\generate.web\app_offline.htm"));

            // Act
            service.TakeSiteOffline(@"c:\generate.web\Updates", @"c:\generate.web");

            // Assert
            Assert.True(fileSystem.FileExists(@"c:\generate.web\app_offline.htm"));

        }



        [Fact]
        public void BringSiteOnline()
        {

            // Arrange
            var fileSystem = SetupFileSystem_SingleValidUpdate();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelper = Mock.Of<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();

            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

            fileSystem.File.CreateText(@"c:\generate.web\app_offline.htm");

            Assert.True(fileSystem.FileExists(@"c:\generate.web\app_offline.htm"));

            // Act
            service.BringSiteOnline(@"c:\generate.web");

            // Assert
            Assert.True(!fileSystem.FileExists(@"c:\generate.web\app_offline.htm"));

        }


        [Fact]
        public void BringSiteOnline_SiteAlreadyOnline()
        {

            // Arrange
            var fileSystem = SetupFileSystem_SingleValidUpdate();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelper = Mock.Of<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();

            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

            // Act
            service.BringSiteOnline(@"c:\generate.web");

            // Assert
            Assert.True(!fileSystem.FileExists(@"c:\generate.web\app_offline.htm"));

        }



        [Fact]
        public void BackupSite_Web()
        {

            // Arrange
            var fileSystem = SetupFileSystem_SingleValidUpdate();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelperMock = new Mock<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();

            // Add a web file
            fileSystem.File.CreateText(@"c:\generate.web\index.htm");


            zipFileHelperMock.Setup(x => x.CompressDirectory(It.IsAny<string>(), It.IsAny<string>())).Callback<string, string>((p, q) => this.MockCompressSite(fileSystem, p, q));

            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelperMock.Object);

            // Act
            service.BackupSite(@"c:\generate.web\Updates", @"c:\generate.web");

            // Assert
            Assert.True(fileSystem.FileExists(@"c:\generate.web\Updates\Backups\generate.web_backup.zip"));
            Assert.False(fileSystem.Directory.Exists(@"c:\generate.web\Updates\Backups\generate.web_backup"));

        }


        [Fact]
        public void BackupSite_Background()
        {

            // Arrange
            var fileSystem = SetupFileSystem_BackgroundUpdate();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelperMock = new Mock<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();

            // Add a web file
            fileSystem.File.CreateText(@"c:\generate.background\index.htm");


            zipFileHelperMock.Setup(x => x.CompressDirectory(It.IsAny<string>(), It.IsAny<string>())).Callback<string, string>((p, q) => this.MockCompressSite(fileSystem, p, q));

            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelperMock.Object);

            // Act
            service.BackupSite(@"c:\generate.web\Updates", @"c:\generate.background");

            // Assert
            Assert.True(fileSystem.FileExists(@"c:\generate.web\Updates\Backups\generate.background_backup.zip"));
            Assert.False(fileSystem.Directory.Exists(@"c:\generate.web\Updates\Backups\generate.background_backup"));

        }


        [Fact]
        public void BackupSite_BackupAlreadyExists()
        {

            // Arrange
            var fileSystem = SetupFileSystem_SingleValidUpdate();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelperMock = new Mock<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();

            // Add a web file
            fileSystem.File.CreateText(@"c:\generate.web\index.htm");

            // Add a backup
            fileSystem.Directory.CreateDirectory(@"c:\generate.web\Updates\Backups");
            fileSystem.File.Create(@"c:\generate.web\Updates\Backups\generate.web_backup.zip");

            zipFileHelperMock.Setup(x => x.CompressDirectory(It.IsAny<string>(), It.IsAny<string>())).Callback<string, string>((p, q) => this.MockCompressSite(fileSystem, p, q));

            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelperMock.Object);

            // Act
            service.BackupSite(@"c:\generate.web\Updates", @"c:\generate.web");

            // Assert
            Assert.True(fileSystem.FileExists(@"c:\generate.web\Updates\Backups\generate.web_backup.zip"));
            Assert.False(fileSystem.Directory.Exists(@"c:\generate.web\Updates\Backups\generate.web_backup"));

        }



        [Fact]
        public void RestoreBackup_Web()
        {

            // Arrange
            var fileSystem = SetupFileSystem_SingleValidUpdate();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelperMock = new Mock<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();

            zipFileHelperMock.Setup(x => x.UncompressFile(It.IsAny<string>(), It.IsAny<string>())).Callback<string, string>((p, q) => this.MockUncompressBackup(fileSystem, p, q));

            // Add a backup
            fileSystem.Directory.CreateDirectory(@"c:\generate.web\Updates\Backups");
            fileSystem.File.Create(@"c:\generate.web\Updates\Backups\generate.web_backup.zip");

            // Add a web file
            MockFileData initialFile = new MockFileData("html content");
            fileSystem.AddFile(@"c:\generate.web\test.html", initialFile);

            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelperMock.Object);

            // Act
            service.RestoreBackup(@"c:\generate.web\Updates", @"c:\generate.web");

            // Assert
            Assert.False(fileSystem.Directory.Exists(@"c:\generate.web\Updates\Backups\generate.web_backup"));
            var updatedFileContents = fileSystem.File.OpenText(@"c:\generate.web\test.html").ReadToEnd();
            Assert.Equal("html content updated", updatedFileContents);
        }


        [Fact]
        public void RestoreBackup_Background()
        {

            // Arrange
            var fileSystem = SetupFileSystem_BackgroundUpdate();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelperMock = new Mock<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();

            zipFileHelperMock.Setup(x => x.UncompressFile(It.IsAny<string>(), It.IsAny<string>())).Callback<string, string>((p, q) => this.MockUncompressBackup(fileSystem, p, q));

            // Add a backup
            fileSystem.Directory.CreateDirectory(@"c:\generate.web\Updates\Backups");
            fileSystem.File.Create(@"c:\generate.web\Updates\Backups\generate.background_backup.zip");

            // Add a web file
            MockFileData initialFile = new MockFileData("html content");
            fileSystem.AddFile(@"c:\generate.background\test.html", initialFile);

            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelperMock.Object);

            // Act
            service.RestoreBackup(@"c:\generate.web\Updates", @"c:\generate.background");

            // Assert
            Assert.False(fileSystem.Directory.Exists(@"c:\generate.web\Updates\Backups\generate.background_backup"));
            var updatedFileContents = fileSystem.File.OpenText(@"c:\generate.background\test.html").ReadToEnd();
            Assert.Equal("html content updated", updatedFileContents);
        }


        [Fact]
        public void ExecuteDatabaseUpdate()
        {

            // Arrange
            var fileSystem = SetupFileSystem_SingleWithSqlScript();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelper = Mock.Of<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();


            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

            // Act
            service.ExecuteDatabaseUpdate(@"c:\generate.web\Updates\generate_3.0\database");

            // Assert

            // No need to assert conditions -- we are just making sure that no exception occurs

        }

        [Fact]
        public void ExecuteDatabaseScript()
        {

            // Arrange
            var fileSystem = SetupFileSystem_SingleWithSqlScript();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelper = Mock.Of<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();


            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

            // Act
            service.ExecuteDatabaseScript(@"c:\generate.web\Updates\generate_3.0\database", "testscript.sql");
            service.ExecuteDatabaseScript(@"c:\generate.web\Updates\generate_3.0\database", "testscript2.sql");

            // Assert

            // No need to assert conditions -- we are just making sure that no exception occurs

        }



        [Fact]
        public void DeleteObsoleteFiles()
        {

            // Arrange
            var fileSystem = SetupFileSystem_WebFilesToBeDeleted();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelper = Mock.Of<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();


            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

            Assert.True(fileSystem.FileExists(@"c:\generate.web\test.html"));

            // Act
            service.DeleteObsoleteFiles(@"c:\generate.web\Updates\generate_3.0", "web_tobedeleted.csv", @"c:\generate.web\");

            // Assert
            Assert.False(fileSystem.FileExists(@"c:\generate.web\test.html"));
            
        }


        [Fact]
        public void DeleteAllFiles()
        {

            // Arrange
            var fileSystem = SetupFileSystem_AllFilesToBeDeleted();
            var logger = Mock.Of<ILogger<AppUpdateService>>();
            var appRepository = Mock.Of<IAppRepository>();
            var appSettings = Mock.Of<IOptions<AppSettings>>();
            var zipFileHelper = Mock.Of<IZipFileHelper>();
            var restClient = Mock.Of<RestClient>();


            var service = new AppUpdateService(fileSystem, appRepository, logger, appSettings, zipFileHelper);

            Assert.True(fileSystem.FileExists(@"c:\generate.web\test.html"));

            // Act
            service.DeleteObsoleteFiles(@"c:\generate.web\Updates\generate_3.0", "web_tobedeleted.csv", @"c:\generate.web\");

            // Assert
            Assert.False(fileSystem.FileExists(@"c:\generate.web\test.html"));

        }

        #endregion

    }
}
