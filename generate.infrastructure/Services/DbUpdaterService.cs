using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//using System.Data.SqlClient;
using Microsoft.Data.SqlClient;
using generate.infrastructure.Contexts;
using generate.core.Config;
using generate.core.Interfaces.Services;
using generate.core.Models.App;
using System.Diagnostics.CodeAnalysis;
using generate.core.Interfaces.Repositories.App;

namespace generate.infrastructure.Services
{

    /// <summary>
    /// Database updater service
    /// </summary>
    public class DbUpdaterService : IDbUpdaterService
    {
        private readonly AppDbContext _context;
        private readonly IOptions<AppSettings> _appSettings;
        private readonly ILogger<DbUpdaterService> _logger;
        private readonly IAppRepository _appRepository;

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="appSettings"></param>
        /// <param name="context"></param>
        /// <param name="logger"></param>
        /// <param name="appRepository"></param>
        public DbUpdaterService(
            IOptions<AppSettings> appSettings, 
            AppDbContext context, 
            ILogger<DbUpdaterService> logger,
            IAppRepository appRepository
            )
        {
            _appSettings = appSettings;
            _context = context;
            _logger = logger;
            _appRepository = appRepository;
        }

        /// <summary>
        /// Update Database
        /// </summary>
        public void Update(bool performUpdate, string basePath)
        {

            // Check if database exists
            try
            {
                _context.Set<GenerateConfiguration>().Count();
            }
            catch (Exception)
            {
                throw new InvalidOperationException("ERROR - Generate database does not exist or is too old.  Please restore using the RestoreDatabase.sql script.");
            }

            // Check if database is too old (this new update process requires a baseline version of 2.4)
            string currentDatabaseVersion = "";
            GenerateConfiguration databaseVersionConfiguration = _appRepository.Find<GenerateConfiguration>(c => c.GenerateConfigurationKey == "DatabaseVersion", 0, 0).FirstOrDefault();
            if (databaseVersionConfiguration != null)
            {
                currentDatabaseVersion = databaseVersionConfiguration.GenerateConfigurationValue;
            }
            float currentDatabaseVersionValue = 0;
            float.TryParse(currentDatabaseVersion.Replace("_prerelease", ""), out currentDatabaseVersionValue);
            
            if (currentDatabaseVersionValue < 2.4)
            {
                throw new InvalidOperationException("ERROR - Generate database does not exist or is too old.  Please restore using the RestoreDatabase.sql script.");
            }

            //if (performUpdate)
            //{
            //    _logger.LogInformation("Database update check / environment = " + _appSettings.Value.Environment);
            //    Console.WriteLine("Database update check / environment = " + _appSettings.Value.Environment);

            //    // Get available versions
            //    List<string> versionsAvailable = new List<string>();
            //    DirectoryInfo dirInfo = new DirectoryInfo(basePath + "\\DatabaseScripts\\VersionUpdates");
            //    foreach (var d in dirInfo.GetDirectories("*", SearchOption.TopDirectoryOnly))
            //    {
            //        var releaseName = d.Name;

            //        if (releaseName.ToLower().Contains("_prerelease"))
            //        {
            //            if (_appSettings.Value.Environment != "production")
            //            {
            //                versionsAvailable.Add(releaseName);
            //            }
            //        }
            //        else
            //        {
            //            versionsAvailable.Add(releaseName);
            //        }
            //    }

            //    foreach (var version in versionsAvailable)
            //    {
            //        _logger.LogInformation("Checking version " + version);
            //        Console.WriteLine("Checking version " + version);

            //        bool isVersionUpdateSuccessful = false;
            //        isVersionUpdateSuccessful = UpdateVersion(basePath, version, currentDatabaseVersion);

            //        if (isVersionUpdateSuccessful)
            //        {
            //            _logger.LogInformation("- version " + version + " check successful");
            //            Console.WriteLine("- version " + version + " check successful");
            //        }
            //        else
            //        {
            //            throw new InvalidOperationException("ERROR - version " + version + " update was unsuccessful");
            //        }

            //    }

            //    _logger.LogInformation("Database update check - complete");
            //    Console.WriteLine("Database update check - complete");

            //}
        }

        [SuppressMessage("Microsoft.Design", "EF1000")]
        private bool UpdateVersion(string basePath, string versionToUpdate, string currentVersion)
        {
            bool isUpdateSuccessful = true;
            bool isPrerelease = false;

            if (versionToUpdate.Contains("_prerelease"))
            {
                isPrerelease = true;
            }

            float versionToUpdateValue = 0;
            float.TryParse(versionToUpdate.Replace("_prerelease", "").Replace("_hotfix", ""), out versionToUpdateValue);
            
            float currentVersionValue = 0;
            float.TryParse(currentVersion.Replace("_prerelease", "").Replace("_hotfix", ""), out currentVersionValue);

            FileInfo fileInfo = null;
            
            // Get version scripts
            fileInfo = new FileInfo(basePath + "\\DatabaseScripts\\VersionUpdates\\" + versionToUpdate + "\\VersionScripts.csv");
            string versionCsv = "";
            using (StreamReader sr = fileInfo.OpenText())
            {
                versionCsv = sr.ReadToEnd();
            }
            
            // Execute each script
            int executionCount = 0;
            string[] rows = versionCsv.Split('\n');

            foreach (string row in rows)
            {
                if (row == "\r")
                    continue;

                if (!string.IsNullOrEmpty(row))
                {
                    var cells = row.Split(',');

                    string forceUpdate = cells[2];
                    int forceUpdateValue = 0;
                    int.TryParse(forceUpdate, out forceUpdateValue);


                    bool runScript = false;

                    if (versionToUpdateValue > currentVersionValue)
                    {
                        runScript = true;
                    }

                    if (versionToUpdateValue == currentVersionValue && (isPrerelease || forceUpdateValue == 1))
                    {
                        runScript = true;
                    }


                    if (runScript)
                    {

                        bool isScriptSuccessful = ExecuteScript(basePath + "\\DatabaseScripts\\" + cells[0], cells[1]);

                        if (!isScriptSuccessful)
                        {
                            isUpdateSuccessful = false;
                            break;
                        }
                        else
                        {
                            executionCount++;
                        }
                    }

                }
            }

            if (executionCount == 0)
            {
                _logger.LogInformation("- no updates required");
                Console.WriteLine("- no updates required");
            }
            else
            {
                _logger.LogInformation("- " + executionCount + " updates applied");
                Console.WriteLine("- " + executionCount + " updates applied");
            }

            return isUpdateSuccessful;
        }

        [SuppressMessage("Microsoft.Design", "EF1000")]
        private bool ExecuteScript(string scriptPath, string scriptFile, List<SqlParameter> parameters = null)
        {
            
            _logger.LogInformation("- Executing - " + scriptFile);
            Console.WriteLine("- Executing - " + scriptFile);

            string filePath = scriptPath + "\\" + scriptFile;            

            FileInfo fileInfo = new FileInfo(filePath);

            string script = "";
            using (StreamReader sr = fileInfo.OpenText())
            {
                script = sr.ReadToEnd();
            }

            if ( script.Contains('{'))
            {
                script = script.Replace("{", "{{");
            }
            if (script.Contains('}'))
            {
                script = script.Replace("}", "}}");
            }

            int? oldTimeout = _context.Database.GetCommandTimeout();
            _context.Database.SetCommandTimeout(8000);

            try
            {
                if (parameters == null)
                {
                    _context.Database.ExecuteSqlRaw(script);
                }
                else
                {
                    _context.Database.ExecuteSqlRaw(script, parameters.ToArray());
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex.Message, "Execution of " + scriptFile + " failed");
                Console.WriteLine("Execution of " + scriptFile + " failed - " + ex.Message);
                _context.Database.SetCommandTimeout(oldTimeout);
                return false;
            }

            _context.Database.SetCommandTimeout(oldTimeout);
            
            return true;

        }

    }
}
