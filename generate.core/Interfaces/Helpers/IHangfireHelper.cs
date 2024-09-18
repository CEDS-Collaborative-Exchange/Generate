using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Helpers
{
    public interface IHangfireHelper
    {
        void TriggerOdsTestData();
        string TriggerStagingTestData(int? schoolYear);
        void TriggerSqlBasedMigration(string dataMigrationTypeCode, string parentJobId);
        void TriggerReportMigrationByYearLevelAndCategorySet(string reportCode, string reportYear, string reportLevel, string categorySetCode);
        void TriggerRdsMigrationByYear(string taskName, string reportYear);

        void CancelMigration(string dataMigrationTypeCode);

        void TriggerSiteUpdate(string sourcePath, string destinationPath);

        void StartFSRecurringJobs(bool _useWSforFSMetaUpd, string _fsWSURL, string _fsMetaFileLoc, string _fsMetaESSDetailFileName, string _fsMetaCHRDetailFileName, string _fsMetaESSLayoutFileName, string _fsMetaCHRLayoutFileName, string _bkfsMetaFileLoc, bool _reloadFromBackUp, string cronExpr);

        void fsMetaRefresh(bool _useWSforFSMetaUpd, string _fsWSURL, string _fsMetaFileLoc, string _fsMetaESSDetailFileName, string _fsMetaCHRDetailFileName, string _fsMetaESSLayoutFileName, string _fsMetaCHRLayoutFileName, string _bkfsMetaFileLoc, bool _reloadFromBackUp);

    }
}
