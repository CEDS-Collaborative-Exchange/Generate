using generate.core.Config;
using generate.core.Dtos.App;
using generate.core.Interfaces.Helpers;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Services;
using generate.core.Models.App;
using generate.shared.Utilities;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections.Generic;
using System.IO.Abstractions;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace generate.infrastructure.Services
{
    public class AppUpdateService : IAppUpdateService
    {
        private readonly IFileSystem _fileSystem;
        private readonly ILogger<AppUpdateService> _logger;
        private readonly IAppRepository _appRepository;
        private readonly IOptions<AppSettings> _appSettings;
        private readonly IZipFileHelper _zipFileHelper;

        public AppUpdateService(
            IFileSystem fileSystem,
            IAppRepository appRepository,
            ILogger<AppUpdateService> logger,
            IOptions<AppSettings> appSettings,
            IZipFileHelper zipFileHelper
            )
        {
            _fileSystem = fileSystem ?? throw new ArgumentNullException(nameof(fileSystem));
            _appRepository = appRepository ?? throw new ArgumentNullException(nameof(appRepository));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            _appSettings = appSettings ?? throw new ArgumentNullException(nameof(appSettings));
            _zipFileHelper = zipFileHelper ?? throw new ArgumentNullException(nameof(zipFileHelper));
        }

        public string GetCurrentVersion()
        {
            // Get current version
            GenerateConfiguration configVersion = _appRepository.FindReadOnly<GenerateConfiguration>(x =>
            x.GenerateConfigurationCategory == "Database" &&
            x.GenerateConfigurationKey == "DatabaseVersion")
            .FirstOrDefault();

            if (configVersion == null)
            {
                throw new InvalidOperationException("Cannot determine current app version");
            }

            return configVersion.GenerateConfigurationValue;
        }

        public string GetUpdateUrl()
        {
            // Get update url
            string updateUrlKey = "ProdUrl";
            if (_appSettings.Value.Environment == "development")
            {
                updateUrlKey = "DevUrl";
            }
            else if (_appSettings.Value.Environment == "test")
            {
                updateUrlKey = "TestUrl";
            }
            else if (_appSettings.Value.Environment == "stage")
            {
                updateUrlKey = "StageUrl";
            }

            GenerateConfiguration configUpdateUrl = _appRepository.FindReadOnly<GenerateConfiguration>(x =>
            x.GenerateConfigurationCategory == "AppUpdate" &&
            x.GenerateConfigurationKey == updateUrlKey)
            .FirstOrDefault();

            if (configUpdateUrl == null)
            {
                throw new InvalidOperationException("Cannot determine update URL");
            }

            return configUpdateUrl.GenerateConfigurationValue;
        }


        public UpdateStatusDto GetUpdateStatus()
        {
            GenerateConfiguration configUpdateStatus = _appRepository.FindReadOnly<GenerateConfiguration>(x =>
            x.GenerateConfigurationCategory == "AppUpdate" &&
            x.GenerateConfigurationKey == "Status")
            .FirstOrDefault();

            UpdateStatusDto updateStatusDto = new UpdateStatusDto()
            {
                Status = "OK"
            };

            if (configUpdateStatus == null)
            {
                return updateStatusDto;
            }
            else
            {
                updateStatusDto.Status = configUpdateStatus.GenerateConfigurationValue;
            }

            return updateStatusDto;
        }

        public List<UpdatePackageDto> CheckForPendingUpdates()
        {
            // Get current version
            string currentVersion = this.GetCurrentVersion();
            string updateUrl = this.GetUpdateUrl();

            var client = new RestClient(new RestClientOptions(new Uri(updateUrl + "/api/update/" + currentVersion)));
            var request = new RestRequest("", Method.Get);
            var response = client.Execute(request);
            List<UpdatePackageDto> pendingUpdates = JsonConvert.DeserializeObject<List<UpdatePackageDto>>(response.Content);

            return pendingUpdates;
        }


        public List<UpdatePackageDto> GetPendingUpdates(string contentRootPath, int currentMajorVersion = 0, int currentMinorVersion = 0)
        {
            List<UpdatePackageDto> availableUpdates = new List<UpdatePackageDto>();
            var updatePath = contentRootPath + "\\Updates";
            foreach (var fileWithFullPath in _fileSystem.Directory.GetFiles(updatePath, "*.zip", System.IO.SearchOption.TopDirectoryOnly))
            {
                var fileName = _fileSystem.FileInfo.FromFileName(fileWithFullPath).Name;

                if (fileName.Contains("_"))
                {
                    var fileNameArray = fileName.Split("_");

                    var fileNameWithoutExtension = fileNameArray[1].Replace(".zip", "");

                    if (fileNameArray.Length == 2 && fileNameWithoutExtension.Contains("."))
                    {
                        var versionArray = fileNameWithoutExtension.Split(".");

                        if (versionArray.Length == 2)
                        {
                            int majorVersion = 0;
                            int minorVersion = 0;

                            int.TryParse(versionArray[0], out majorVersion);
                            int.TryParse(versionArray[1], out minorVersion);

                            if (majorVersion > currentMajorVersion || (majorVersion == currentMajorVersion && minorVersion > currentMinorVersion))
                            {
                                var UpdatePackageDtoJsonFile = fileWithFullPath.Replace(".zip", ".json");

                                if (_fileSystem.File.Exists(UpdatePackageDtoJsonFile))
                                {
                                    var UpdatePackageDtoJson = _fileSystem.File.ReadAllText(UpdatePackageDtoJsonFile);

                                    var UpdatePackageDto = JsonConvert.DeserializeObject<UpdatePackageDto>(UpdatePackageDtoJson);

                                    availableUpdates.Add(UpdatePackageDto);
                                }

                            }
                        }

                    }
                }

            }

            if (availableUpdates.Any())
            {
                // Sort
                availableUpdates = availableUpdates.OrderBy(x => x.MajorVersion).ThenBy(x => x.MinorVersion).ToList();
            }

            return availableUpdates;
        }


        public List<UpdatePackageDto> GetDownloadedUpdates(string appPath)
        {
            var updatePath = _fileSystem.Path.Combine(appPath, "Updates");
            List<UpdatePackageDto> availableUpdates = new List<UpdatePackageDto>();
            foreach (var d in _fileSystem.Directory.GetFiles(updatePath, "*.zip", System.IO.SearchOption.TopDirectoryOnly))
            {
                var fileName = _fileSystem.FileInfo.FromFileName(d).Name;
                var filePath = _fileSystem.Path.Combine(updatePath, fileName);
                var UpdatePackageDtoJsonFile = filePath.Replace(".zip", ".json");

                if (_fileSystem.File.Exists(UpdatePackageDtoJsonFile))
                {
                    var UpdatePackageDtoJson = _fileSystem.File.ReadAllText(UpdatePackageDtoJsonFile);

                    var UpdatePackageDto = JsonConvert.DeserializeObject<UpdatePackageDto>(UpdatePackageDtoJson);

                    availableUpdates.Add(UpdatePackageDto);
                }

            }

            return availableUpdates;
        }

        public void DownloadUpdates(string appPath)
        {

            // Get current version
            string currentVersion = this.GetCurrentVersion();
            string updateUrl = this.GetUpdateUrl();


            // Download updates

            var client = new RestClient(new RestClientOptions(new Uri(updateUrl)));
            var request = new RestRequest("/api/update/" + currentVersion, Method.Get);
            var response = client.Execute(request);
            List<UpdatePackageDto> pendingUpdates = JsonConvert.DeserializeObject<List<UpdatePackageDto>>(response.Content);

            var updatePath = _fileSystem.Path.Combine(appPath, "Updates");

            if (pendingUpdates != null && pendingUpdates.Count > 0)
            {
 
                // Only download the next version (we can only apply one update at a time)

                foreach (var update in pendingUpdates.OrderBy(x => x.MajorVersion).ThenBy(x => x.MinorVersion).Take(1))
                {
                    // Download zip file
                    var zipRequest = new RestRequest("/Updates/" + update.FileName, Method.Get);
                    byte[] updateResponse = client.DownloadData(zipRequest);
                    _fileSystem.File.WriteAllBytes(updatePath + "/" + update.FileName, updateResponse);

                    // Download json file
                    var jsonRequest = new RestRequest("/Updates/" + update.FileName.Replace(".zip", ".json"), Method.Get);
                    var jsonResponse = client.DownloadData(jsonRequest);
                    _fileSystem.File.WriteAllBytes(updatePath + "/" + update.FileName.Replace(".zip", ".json"), jsonResponse);

                }
            }

        }

        public void ClearUpdates(string appPath)
        {
            var updatePath = _fileSystem.Path.Combine(appPath, "Updates");

            foreach (var d in _fileSystem.Directory.GetFiles(updatePath, "*.zip", System.IO.SearchOption.TopDirectoryOnly))
            {
                // Delete zip file
                var fileName = _fileSystem.FileInfo.FromFileName(d).Name;
                var filePath = _fileSystem.Path.Combine(updatePath, fileName);
                _fileSystem.File.Delete(filePath);

                // Delete json file
                var jsonName = fileName.Replace(".zip", ".json");
                var jsonPath = _fileSystem.Path.Combine(updatePath, jsonName);
                _fileSystem.File.Delete(jsonPath);

                // Delete extracted package (if exists)
                var packageDirectory = jsonPath.Replace(".json", "");
                if (_fileSystem.Directory.Exists(packageDirectory))
                {
                    _fileSystem.Directory.Delete(packageDirectory, true);
                }

            }
        }

        public bool IsValidUpdatePackageDto(string updatePath, string packagePath, string packageFileName)
        {

            bool isValid = true;

            string webDirectory = _fileSystem.Path.Combine(packagePath, "web");
            string databaseDirectory = _fileSystem.Path.Combine(packagePath, "database");
            string backgroundDirectory = _fileSystem.Path.Combine(packagePath, "background");

            if (!_fileSystem.Directory.Exists(webDirectory))
            {
                _logger.LogError("Update " + packageFileName + " is invalid - missing web directory");
                isValid = false;
            }
            if (!_fileSystem.Directory.Exists(databaseDirectory))
            {
                _logger.LogError("Update " + packageFileName + " is invalid - missing database directory");
                isValid = false;
            }
            if (!_fileSystem.Directory.Exists(backgroundDirectory))
            {
                _logger.LogError("Update " + packageFileName + " is invalid - missing background directory");
                isValid = false;
            }

            string webToDelete = _fileSystem.Path.Combine(packagePath, "web_todelete.csv");

            if (!_fileSystem.File.Exists(webToDelete))
            {
                _logger.LogError("Update " + packageFileName + " is invalid - missing web_todelete.csv");
                isValid = false;
            }

            string backgroundToDelete = _fileSystem.Path.Combine(packagePath, "background_todelete.csv");

            if (!_fileSystem.File.Exists(backgroundToDelete))
            {
                _logger.LogError("Update " + packageFileName + " is invalid - missing background_todelete.csv");
                isValid = false;
            }

            string UpdatePackageDtoJsonFile = _fileSystem.Path.Combine(updatePath, packageFileName.Replace(".zip", ".json"));

            if (!_fileSystem.File.Exists(UpdatePackageDtoJsonFile))
            {
                _logger.LogError("Update " + packageFileName + " is invalid - missing json file");
                isValid = false;
            }
           
            return isValid;

        }

        /// <summary>
        /// Inspect JSON file for valid prerequisite
        /// </summary>
        /// <param name="UpdatePackageDtoJsonFile"></param>
        /// <returns></returns>
        public bool IsValidPrerequisite(string UpdatePackageDtoJsonFile)
        {
            bool isValid = true;

            // Check prerequisite version

            var UpdatePackageDtoJson = _fileSystem.File.ReadAllText(UpdatePackageDtoJsonFile);
            var UpdatePackageDto = JsonConvert.DeserializeObject<UpdatePackageDto>(UpdatePackageDtoJson);
            var prerequisiteVersion = UpdatePackageDto.PrerequisiteVersion;

            GenerateConfiguration generateConfiguration = _appRepository.FindReadOnly<GenerateConfiguration>(x =>
            x.GenerateConfigurationCategory == "Database" &&
            x.GenerateConfigurationKey == "DatabaseVersion")
            .FirstOrDefault();

            if (generateConfiguration == null || generateConfiguration.GenerateConfigurationValue != prerequisiteVersion)
            {
                isValid = false;
            }

            return isValid;
        }

        public void ExecuteSiteUpdate(string sourcePath, string destinationPath)
        {
            // Reset update status to OK

            GenerateConfiguration configUpdateStatus = _appRepository.Find<GenerateConfiguration>(x =>
                x.GenerateConfigurationCategory == "AppUpdate" &&
                x.GenerateConfigurationKey == "Status")
                .Single();

            configUpdateStatus.GenerateConfigurationValue = "OK";
            _appRepository.Update<GenerateConfiguration>(configUpdateStatus);
            _appRepository.Save();

            string updatePath = _fileSystem.Path.Combine(sourcePath, "Updates");

            try
            {

                // Get Update packages
                List<string> packagesAvailable = this.ExtractAndValidateUpdatePackageDtos(updatePath);

                if (packagesAvailable.Any())
                {
                    _logger.LogInformation("Update - Executing Updates");

                    // Take site offline
                    this.TakeSiteOffline(updatePath, destinationPath);

                    // Pause to give time for site to shutdown
                    Thread.Sleep(500);

                    // Backup Site
                    this.BackupSite(updatePath, destinationPath);

                    // Apply updates
                    this.ApplyUpdates(packagesAvailable, updatePath, destinationPath);

                    // Bring site back online
                    this.BringSiteOnline(destinationPath);

                }

            }
            catch (Exception ex)
            {
                configUpdateStatus.GenerateConfigurationValue = "FAILED - " + ex.Message;
                _appRepository.Update<GenerateConfiguration>(configUpdateStatus);
                _appRepository.Save();

                _logger.LogError(ex, "Update of Generate failed");
                // If exception occurs, bring site back online
                this.BringSiteOnline(destinationPath);
                throw;
            }

        }

        public void ApplyUpdates(List<string> packagesAvailable, string updatePath, string destinationPath)
        {

            bool isWebUpdate = true;

            if (destinationPath.Contains("generate.background"))
            {
                isWebUpdate = false;
            }

            try
            {

                foreach (var packageFileName in packagesAvailable)
                {
                    if (isWebUpdate)
                    {
                        _logger.LogInformation("Update - Applying generate.web update - " + packageFileName);
                    }
                    else
                    {
                        _logger.LogInformation("Update - Applying generate.background update - " + packageFileName);
                    }

                    string UpdatePackageDtoJsonFile = _fileSystem.Path.Combine(updatePath, packageFileName.Replace(".zip", ".json"));

                    if (!this.IsValidPrerequisite(UpdatePackageDtoJsonFile))
                    {
                        _logger.LogError("Update " + packageFileName + " is invalid - prerequisite is not met");
                        throw new InvalidOperationException("Update " + packageFileName + " is invalid - prerequisite is not met");
                    }
                    else
                    {


                        // Extract Update
                        var packageFileAndPath = _fileSystem.Path.Combine(updatePath, packageFileName);
                        _zipFileHelper.UncompressFile(packageFileAndPath, updatePath);
                        var packagePath = _fileSystem.Path.Combine(updatePath, packageFileAndPath.Replace(".zip", ""));

                        var updateSourcePath = packagePath;
                        var toDeleteFileName = "todelete.csv";

                        if (isWebUpdate)
                        {
                            updateSourcePath = _fileSystem.Path.Combine(packagePath, "web");
                            toDeleteFileName = "web_todelete.csv";
                        }
                        else
                        {
                            updateSourcePath = _fileSystem.Path.Combine(packagePath, "background");
                            toDeleteFileName = "background_todelete.csv";
                        }



                        // Delete files found in csv
                        _logger.LogInformation("Update - Starting - Delete Obsolete files");

                        this.DeleteObsoleteFiles(packagePath, toDeleteFileName, destinationPath);

                        _logger.LogInformation("Update - Completed - Delete Obsolete files");


                        // Copy/replace files

                        _logger.LogInformation("Update - Starting - Copy/Replace files");

                        foreach (var updateFileName in _fileSystem.Directory.GetFiles(updateSourcePath, "*.*", System.IO.SearchOption.TopDirectoryOnly))
                        {

                            var updateFileNameAndPath = _fileSystem.Path.Combine(packagePath, updateFileName);
                            var destFile = _fileSystem.Path.Combine(destinationPath, updateFileName.Replace(updateSourcePath + "\\", ""));

                            if (updateFileNameAndPath.ToLower().EndsWith("index.html") ||
                                updateFileNameAndPath.ToLower().EndsWith("web.config") ||
                                updateFileNameAndPath.ToLower().EndsWith("appsettings.json") ||
                                updateFileNameAndPath.ToLower().EndsWith("appsettings.development.json") ||
                                updateFileNameAndPath.ToLower().EndsWith("appsettings.test.json") ||
                                updateFileNameAndPath.ToLower().EndsWith("appsettings.stage.json") ||
                                updateFileNameAndPath.ToLower().EndsWith("appsettings.production.json") ||
                                updateFileNameAndPath.ToLower().EndsWith("config.dev.json") ||
                                updateFileNameAndPath.ToLower().EndsWith("config.prod.json") 
                                )
                            {
                                _logger.LogInformation("Update - Skipping - " + updateFileNameAndPath + " / " + destFile);
                            }
                            else
                            {
                                _logger.LogInformation("Update - Copying file - " + updateFileNameAndPath + " / " + destFile);
                                _fileSystem.File.Copy(updateFileNameAndPath, destFile, true);
                            }

                        }

                        _logger.LogInformation("Update - Completed - Copy/Replace files");


                        // Copy/replace directories

                        _logger.LogInformation("Update - Starting - Copy/Replace directories");

                        foreach (var updateDirectory in _fileSystem.Directory.GetDirectories(updateSourcePath))
                        {
                            var updateDirectoryAndPath = _fileSystem.Path.Combine(packagePath, updateDirectory);
                            var destDirectory = _fileSystem.Path.Combine(destinationPath, updateDirectoryAndPath.Replace(updateSourcePath + "\\", ""));

                            if (updateDirectoryAndPath.ToLower().EndsWith("config") ||
                                updateDirectoryAndPath.ToLower().EndsWith("logs")
                                )
                            {
                                _logger.LogInformation("Update - Skipping - " + updateDirectoryAndPath);
                            }
                            else
                            {
                                _logger.LogInformation("Update - Copying directory - " + updateDirectoryAndPath + " / " + destDirectory);
                                FileUtilities.DirectoryCopy(_fileSystem, updateDirectoryAndPath, destDirectory, true);
                            }

                        }

                        _logger.LogInformation("Update - Completed - Copy/Replace directories");



                        if (isWebUpdate)
                        {
                            // Database - Execute sql scripts
                            var databasePath = _fileSystem.Path.Combine(packagePath, "database");
                            this.ExecuteDatabaseUpdate(databasePath);

                            _logger.LogInformation("Update - Completed Database SQL scripts");
                        }



                        // Delete update package
                        this.DeleteUpdatePackageDto(packagePath);
                    }


                }

            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Update of Generate failed");
                // If exception occurs during copy, revert to backup
                this.RestoreBackup(updatePath, destinationPath);

                throw;
            }
        }

        public void BackupSite(string updatePath, string pathToBackup)
        {
            _logger.LogInformation("Update - Backup site / updatePath = " + updatePath + " / pathToBackup = " + pathToBackup);

            string backupName = "generate.web_backup";

            if (pathToBackup.Contains("generate.background"))
            {
                backupName = "generate.background_backup";
            }

            string backupPath = _fileSystem.Path.Combine(updatePath, "Backups");
            string backupDirectory = _fileSystem.Path.Combine(backupPath, backupName);
            FileUtilities.DirectoryCopy(_fileSystem, pathToBackup, backupDirectory, true, updatePath);
            string backupZipFile = _fileSystem.Path.Combine(backupPath, backupName + ".zip");
            if (_fileSystem.File.Exists(backupZipFile))
            {
                _fileSystem.File.Delete(backupZipFile);
            }
            _zipFileHelper.CompressDirectory(backupDirectory, backupZipFile);
            _fileSystem.Directory.Delete(backupDirectory, true);
        }

        public void RestoreBackup(string updatePath, string targetPath)
        {

            _logger.LogInformation("Update - Restore backup / updatePath = " + updatePath + " / targetPath = " + targetPath);

            string backupName = "generate.web_backup";

            if (targetPath.Contains("generate.background"))
            {
                backupName = "generate.background_backup";
            }

            string backupPath = _fileSystem.Path.Combine(updatePath, "Backups");
            string backupDirectory = _fileSystem.Path.Combine(backupPath, backupName);
            string backupZipFile = _fileSystem.Path.Combine(backupPath, backupName + ".zip");

            // Extract Backup
            _zipFileHelper.UncompressFile(backupZipFile, backupDirectory);

            // Copy backup to target path
            FileUtilities.DirectoryCopy(_fileSystem, backupDirectory, targetPath, true);

            // Delete extracted files
            _fileSystem.Directory.Delete(backupDirectory, true);

        }

        public void TakeSiteOffline(string updatePath, string targetPath)
        {
            _logger.LogInformation("Update - Take site offline / updatePath = " + updatePath + " / targetPath = " + targetPath);

            string offlineFileSource = _fileSystem.Path.Combine(updatePath, "app_offline.htm");
            string offlineFileDest = _fileSystem.Path.Combine(targetPath, "app_offline.htm");
            _fileSystem.File.Copy(offlineFileSource, offlineFileDest, true);

        }

        public void BringSiteOnline(string targetPath)
        {
            _logger.LogInformation("Update - Bring site online / targetPath = " + targetPath);

            string offlineFile = _fileSystem.Path.Combine(targetPath, "app_offline.htm");
            if (_fileSystem.File.Exists(offlineFile))
            {
                _fileSystem.File.Delete(offlineFile);
            }
        }
        public List<string> ExtractAndValidateUpdatePackageDtos(string updatePath)
        {

            _logger.LogInformation("Update - Extract and validate update package / updatePath = " + updatePath);

            // Get Update packages

            List<string> packagesAvailable = new List<string>();
            foreach (var packageFileName in _fileSystem.Directory.GetFiles(updatePath, "*.zip", System.IO.SearchOption.TopDirectoryOnly))
            {
                // Extract Update
                var packageFileNameWithPath = _fileSystem.Path.Combine(updatePath, packageFileName);
                _zipFileHelper.UncompressFile(packageFileNameWithPath, updatePath);
                var packagePath = _fileSystem.Path.Combine(updatePath, packageFileName.Replace(".zip", ""));

                // Validate Update

                if (this.IsValidUpdatePackageDto(updatePath, packagePath, packageFileName))
                {
                    packagesAvailable.Add(packageFileName);
                }
                else
                {
                    // Delete invalid update package
                    this.DeleteUpdatePackageDto(packagePath);
                }

            }

            // Ensure packages are ordered by version number
            return packagesAvailable.OrderBy(x => x).ToList();

        }

        public void DeleteUpdatePackageDto(string packagePath)
        {
            _logger.LogInformation("Update - Delete update package / packagePath = " + packagePath);

            // Delete extracted Update files
            _fileSystem.Directory.Delete(packagePath, true);

            // Delete Update package zip file
            _fileSystem.File.Delete(packagePath + ".zip");

            // Delete Update package json file
            _fileSystem.File.Delete(packagePath + ".json");
        }

        public void ExecuteDatabaseUpdate(string databasePath)
        {
            _logger.LogInformation("Update - Execute database update / databasePath = " + databasePath);

            // Get version scripts
            string fileName = _fileSystem.Path.Combine(databasePath, "UpdateScripts.csv");
            string versionCsv = _fileSystem.File.ReadAllText(fileName);

            string[] rows = versionCsv.Split('\n');

            foreach (string row in rows)
            {
                if (row == "\r")
                    continue;

                if (!string.IsNullOrEmpty(row))
                {
                    this.ExecuteDatabaseScript(databasePath, row);
                }
            }

        }

        public void ExecuteDatabaseScript(string scriptPath, string scriptFile)
        {
            _logger.LogInformation("Update - Script file name - " + scriptFile);

            string fileName = _fileSystem.Path.Combine(scriptPath, scriptFile).Trim().Replace("\n", "").Replace("\r", "");

            _logger.LogInformation("Update - Script path - " + fileName);

            string script = _fileSystem.File.ReadAllText(fileName);

            if (script.Contains('{'))
            {
                script = script.Replace("{", "{{");
            }
            if (script.Contains('}'))
            {
                script = script.Replace("}", "}}");
            }

            _logger.LogInformation("Update - Executing " + fileName);


            _appRepository.ExecuteSql(script);

        }

        public void DeleteObsoleteFiles(string packagePath, string listFileName, string destinationPath)
        {
            // Get list of files
            var fileName = _fileSystem.Path.Combine(packagePath, listFileName);
            string filesCsv = _fileSystem.File.ReadAllText(fileName);

            string[] rows = filesCsv.Split('\n');

            foreach (string row in rows)
            {

                _logger.LogInformation("Update - DeleteObsoleteFiles - Row = [" + row + "]");

                if (row == "\r")
                    continue;

                if (!string.IsNullOrEmpty(row))
                {
                    var rowValue = row.Trim().Replace("\n", "").Replace("\r", "");

                    if (rowValue == "*.*")
                    {
                        // Delete all files

                        _logger.LogInformation("Update - Deleting All Files");

                        var filesToDelete = _fileSystem.Directory.GetFiles(destinationPath);

                        foreach (string fileToDelete in filesToDelete)
                        {
                            if (fileToDelete.ToLower().EndsWith("index.html") ||
                                fileToDelete.ToLower().EndsWith("web.config") ||
                                fileToDelete.ToLower().EndsWith("appsettings.json") ||
                                fileToDelete.ToLower().EndsWith("appsettings.development.json") ||
                                fileToDelete.ToLower().EndsWith("appsettings.test.json") ||
                                fileToDelete.ToLower().EndsWith("appsettings.stage.json") ||
                                fileToDelete.ToLower().EndsWith("appsettings.production.json") ||
                                fileToDelete.ToLower().EndsWith("app_offline.htm") ||
                                fileToDelete.ToLower().EndsWith("config.dev.json") ||
                                fileToDelete.ToLower().EndsWith("config.prod.json")
                                )
                            { 
                                _logger.LogInformation("Update - Skipping -" + fileToDelete);
                            }
                            else
                            {
                                _logger.LogInformation("Update - Deleting file -" + fileToDelete);
                                _fileSystem.File.Delete(fileToDelete);
                            }
                        }

                        var directoriesToDelete = _fileSystem.Directory.GetDirectories(destinationPath);

                        foreach (string directoryToDelete in directoriesToDelete)
                        {
                            if (directoryToDelete.ToLower().EndsWith("config"))
                            {
                                _logger.LogInformation("Update - Skipping - " + directoryToDelete);
                            }
                            else
                            {
                                _logger.LogInformation("Update - Removing directory - " + directoryToDelete);
                                _fileSystem.Directory.Delete(directoryToDelete, true);
                            }
                        }

                        break;
                    }
                    else
                    {
                        // Delete specific files

                        var fileToDelete = _fileSystem.Path.Combine(destinationPath, rowValue);

                        if (_fileSystem.File.Exists(fileToDelete))
                        {
                            _logger.LogInformation("Update - Deleting file - " + fileToDelete);
                            _fileSystem.File.Delete(fileToDelete);
                        }
                        else
                        {
                            _logger.LogInformation("Update - File to delete does not exist - " + fileToDelete);
                        }
                    }

                }
            }
        }

    }
}
