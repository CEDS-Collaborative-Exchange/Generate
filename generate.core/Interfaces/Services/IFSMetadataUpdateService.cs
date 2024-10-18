using generate.core.Dtos.App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.core.Interfaces.Services
{
    public interface IFSMetadataUpdateService
    {

        bool useWSforFSMetaUpd { get; set; }
        string fsWSURL { get; set; }
        string fsMetaFileLoc { get; set; }
        string fsMetaESSDetailFileName { get; set; }
        string fsMetaCHRDetailFileName { get; set; }
        string fsMetaESSLayoutFileName { get; set; }
        string fsMetaCHRLayoutFileName { get; set; }
        string bkfsMetaFileLoc { get; set; }
        bool reloadFromBackUp { get; set; }
        string callInitFSmetaServc();

        void populateCatInfoData(string collectionAbbrv, string dataSetAbbrv, string versionNum, string fqYrName, List<DataSetYearVersionDetailsByAllAbbrv> DSYVrdetail);

        void DeleteExistingCatInfobyYearandDS(string collectionAbbrv, string dataSetAbbrv, string versionNum, string fqYrName, string yearAbbrv, List<DataSetYearVersionDetailsByAllAbbrv> DSYVrdetail);

        void DelandPopulateFSLayoutdata(string collectionAbbrv, string dataSetAbbrv, string versionNum, string fqYrName);

        void DeleteFSLayoutInfo(string year1, List<DataSetYearVersionFSLayoutDetailsByAllAbbrv> DSYVrFSLay);

        void populateFSLayout(List<DataSetYearVersionFSLayoutDetailsByAllAbbrv> DSYVrFSLay);

        public bool checkBackupFilesExists();

        public void UpdateKeyinGenConfig(string key, string log);

    }
}
