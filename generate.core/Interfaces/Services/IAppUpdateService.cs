using generate.core.Dtos.App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Services
{
    public interface IAppUpdateService
    {
        string GetCurrentVersion();
        string GetUpdateUrl();
        UpdateStatusDto GetUpdateStatus();
        List<UpdatePackageDto> CheckForPendingUpdates();
        List<UpdatePackageDto> GetPendingUpdates(string contentRootPath, int currentMajorVersion = 0, int currentMinorVersion = 0);
        List<UpdatePackageDto> GetDownloadedUpdates(string appPath);
        void DownloadUpdates(string appPath);
        void ClearUpdates(string appPath);

        bool IsValidUpdatePackageDto(string updatePath, string packagePath, string packageFileName);
        bool IsValidPrerequisite(string UpdatePackageDtoJsonFile);

        /// <summary>
        /// Deploys the given app's own part (appFolderName is "web" or "background") of any
        /// pending update package(s) found under {sourcePath}\Updates. Uses Azure Blob Storage +
        /// WEBSITE_RUN_FROM_PACKAGE when AppSettings:EnableAzureDeployment is true - in that mode
        /// the app always deploys itself via its own App Service's Managed Identity, so it never
        /// touches the other app's package or App Service resource/filesystem. Otherwise falls
        /// back to the legacy in-place file-copy mechanism (backup/offline/copy/restore), which -
        /// because it writes directly to disk rather than through each app's own deployment
        /// identity - targets legacyDestinationPath (the *other* app's content root) instead of
        /// sourcePath: a running process can never overwrite its own currently-loaded binaries,
        /// so each app applies the legacy update to its counterpart's files, and vice versa.
        /// </summary>
        void ExecuteSiteUpdate(string sourcePath, string appFolderName, string legacyDestinationPath = null);

        void ApplyUpdates(List<string> packagesAvailable, string updatePath, string destinationPath, string appFolderName);

        void BackupSite(string updatePath, string pathToBackup);
        void RestoreBackup(string updatePath, string targetPath);

        void TakeSiteOffline(string updatePath, string targetPath);
        void BringSiteOnline(string targetPath);

        List<string> ExtractAndValidateUpdatePackageDtos(string updatePath);
        void DeleteUpdatePackageDto(string packagePath);

        void ExecuteDatabaseUpdate(string databasePath);
        void ExecuteDatabaseScript(string scriptPath, string scriptFile);
        void DeleteObsoleteFiles(string packagePath, string listFileName, string destinationPath);

    }
}
