using System.Collections.Generic;
using System.Threading.Tasks;


namespace generate.core.Interfaces.Services
{
    /// <summary>
    /// Database Updater Service interface
    /// </summary>
    public interface IDbUpdaterService
    {
        /// <summary>
        /// Update Database
        /// </summary>
        /// <param name="basePath"></param>
        void Update(bool performUpdate, string basePath);
        
    }
}