using generate.core.Config;
using generate.core.Dtos.App;
using generate.core.Interfaces.Helpers;
using generate.core.Interfaces.Repositories.App;
using generate.core.Interfaces.Services;
using generate.core.Models.App;
using generate.core.Models.IDS;
using generate.infrastructure.Contexts;
using generate.infrastructure.Repositories.App;
using generate.shared.Utilities;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Conventions;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.VisualBasic.FileIO;
using Newtonsoft.Json;
using RestSharp;
using System;
using System.Collections;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Drawing;
using System.IO;
using System.IO.Abstractions;
using System.Linq;
using System.Linq.Expressions;
using System.Security.Cryptography;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Xml.Linq;
using static Azure.Core.HttpHeader;
using static System.Net.Mime.MediaTypeNames;
using static System.Reflection.Metadata.BlobBuilder;

namespace generate.infrastructure.Services
{
    public class MetadataUpdateService : IFSMetadataUpdateService
    {
        private readonly AppDbContext _appDbContext;
        private readonly IAppRepository _appRepository;
        private readonly ILogger<AppUpdateService> _logger;

        bool _useWSforFSMetaUpd = true;
        string _fsMetaFileLoc;
        string _fsWSURL;
        string _fsMetaESSDetailFileName;
        string _fsMetaCHRDetailFileName;
        string _fsMetaESSLayoutFileName;
        string _fsMetaCHRLayoutFileName;
        string _bkfsMetaFileLoc;

        string initSubdir = "DataSetYearVersionByAllAbbrv";
        string detailSubdir = "DataSetYearVersionDetailsByAllAbbrv";
        string layoutSubdir = "DataSetYearVersionFSLayoutDetailsByAllAbbrv";
        string configurationCategory = "Metadata";
        string essKey = "ESSMetadata";
        string chrKey = "CHRTRMetadata";
        string splitKey = "||";
        string dataMigrationStatusName = "Processing";
        string dataMigrationTypeName = "Report Warehouse";
        string bkESSflname = "ESS.json";
        string bkCHRflname = "CHRTR.json";
        string bkESSflnameFLay = "ESSFLay.json";
        string bkCHRflnameFLay = "CHRTRFLay.json";
        string bkESSFLay = string.Empty;
        string bkCHRFLay = string.Empty;
        bool _reloadFromBackUp = false;
        string FSMetalogKey = "MetaLastRunLog";
        string FSMetasStaKey = "metaStatus";
        string FSMetastausok = "OK";
        string FSMetastausFail = "FAILED";
        string FSMetastausProcessing = "PROCESSING";
        const string pub = "Published";
        const string strRep1 = "{\"DataSetYearVersionDetails\":";
        string collectName = "EDFACTS";
        string charterDSName = "Charter Collections";
        string essDSName = "EDFacts Submission System";
        string charterDSNameAbbrv = "CHRTR";
        string essDSNameAbbrv = "ESS";
        string _selSYr = string.Empty;

        Dictionary<string, string> newCatInfo = new Dictionary<string, string>();

        bool IFSMetadataUpdateService.useWSforFSMetaUpd { get { return _useWSforFSMetaUpd; } set { _useWSforFSMetaUpd = value; } }
        string IFSMetadataUpdateService.fsWSURL { get { return _fsWSURL; } set { _fsWSURL = value; } }
        string IFSMetadataUpdateService.fsMetaFileLoc { get { return _fsMetaFileLoc; } set { _fsMetaFileLoc = value; } }
        string IFSMetadataUpdateService.fsMetaESSDetailFileName { get { return _fsMetaESSDetailFileName; } set { _fsMetaESSDetailFileName = value; } }
        string IFSMetadataUpdateService.fsMetaCHRDetailFileName { get { return _fsMetaCHRDetailFileName; } set { _fsMetaCHRDetailFileName = value; } }
        string IFSMetadataUpdateService.fsMetaESSLayoutFileName { get { return _fsMetaESSLayoutFileName; } set { _fsMetaESSLayoutFileName = value; } }
        string IFSMetadataUpdateService.fsMetaCHRLayoutFileName { get { return _fsMetaCHRLayoutFileName; } set { _fsMetaCHRLayoutFileName = value; } }
        string IFSMetadataUpdateService.bkfsMetaFileLoc { get { return _bkfsMetaFileLoc; } set { _bkfsMetaFileLoc = value; } }
        bool IFSMetadataUpdateService.reloadFromBackUp { get { return _reloadFromBackUp; } set { _reloadFromBackUp = value; } }
        string IFSMetadataUpdateService.selSchYr { get { return _selSYr; } set { _selSYr = value; } }
        public MetadataUpdateService(AppDbContext appDbContext, IAppRepository appRepository, ILogger<AppUpdateService> logger)
        {
            _appDbContext = appDbContext ?? throw new ArgumentNullException(nameof(appDbContext));
            _appRepository = appRepository ?? throw new ArgumentNullException(nameof(appRepository));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public string callInitFSmetaServc()
        {

        //startFS_Processing:

            //var collectName = "EDFACTS";
            //var charterDSName = "Charter Collections";
            //var essDSName = "EDFacts Submission System";
            //var charterDSNameAbbrv = "CHRTR";
            //var essDSNameAbbrv = "ESS";
            bool skipESSPop = false;
            bool skipCHRPop = false;


            var cont = string.Empty;

            List<DataSetYearVersionByAllAbbrv> initDSYVr = null;
            int maxSubmissionYear = 0;
            int maxVersionNumber = 0;
            int nxtYear = 0;
            string fqYrName = string.Empty;

            try
            {

                #region checkDataMigration

                if (!checkDataMigration(dataMigrationStatusName, dataMigrationTypeName)) { return "Data Migration is in progress. Please retry in 1 hour."; }

                #endregion

                #region Init Web Service call

                UpdateKeyinGenConfig(FSMetalogKey, "The metadata is currently being processed.");
                UpdateKeyinGenConfig(FSMetasStaKey, FSMetastausProcessing);

                if (_useWSforFSMetaUpd)
                {

                    string initCallUrl = _fsWSURL + initSubdir;
                    var client = new RestClient(new RestClientOptions(new Uri(initCallUrl)));
                    var request = new RestRequest("", Method.Get);
                    var response = client.Execute(request);

                    cont = response.Content;
                    cont = cont.Replace("{\"DataSetYearVersions\":", "").Replace("]}", "]");

                    initDSYVr = JsonConvert.DeserializeObject<List<DataSetYearVersionByAllAbbrv>>(cont);

                }
                else
                {
                    /*
                     *      Manual file load not needed here

                    var fileloc = _fsMetaFileLoc + "\\" + _fsMetaParentFileName;
                    using (StreamReader r = new StreamReader(fileloc))
                    {
                        cont = r.ReadToEnd();
                        cont = cont.Replace("{\"DataSetYearVersions\":", "");
                        cont = cont.Replace("]}", "]");
                    }

                    initDSYVr = JsonConvert.DeserializeObject<List<DataSetYearVersionByAllAbbrv>>(cont);
                    maxSubmissionYear = int.Parse(initDSYVr.Where(n => n.DataSetName == essDSName && n.VersionStatusDesc == "Published").Max(d => d.YearName).Replace("SY ", "").Substring(0, 4));
                    maxVersionNumber = initDSYVr.Where(n => n.DataSetName == essDSName && n.VersionStatusDesc == "Published" && n.YearName.Contains("SY " + maxSubmissionYear.ToString())).Max(a => a.VersionNumber);
                    nxtYear = maxSubmissionYear + 1;
                    fqYrName = maxSubmissionYear.ToString() + "-" + nxtYear.ToString();

                    */
                }

                #endregion

                #region ESS Population

                List<DataSetYearVersionDetailsByAllAbbrv> DSYVrdetail = null;
                var edfacts = string.Empty;
                if (_useWSforFSMetaUpd)
                {
                    UpdateKeyinGenConfig(FSMetalogKey, "The metadata is currently being processed.");
                    UpdateKeyinGenConfig(FSMetasStaKey, FSMetastausProcessing);
                    maxSubmissionYear = int.Parse(initDSYVr.Where(n => n.DataSetName == essDSName && n.VersionStatusDesc == pub).Max(d => d.YearName).Replace("SY ", "").Substring(0, 4));
                    if (!string.IsNullOrEmpty(_selSYr)) { maxSubmissionYear = Convert.ToInt32(_selSYr); } 
                    maxVersionNumber = initDSYVr.Where(n => n.DataSetName == essDSName && n.VersionStatusDesc == pub && n.YearName.Contains("SY " + maxSubmissionYear.ToString())).Max(a => a.VersionNumber);
                    nxtYear = maxSubmissionYear + 1;
                    fqYrName = maxSubmissionYear.ToString() + "-" + nxtYear.ToString();

                    bool checkPrevFSPop = checkPrevPopFSMetaYrandVers(true, maxSubmissionYear.ToString(), maxVersionNumber);
                    if (!checkPrevFSPop) { skipESSPop = true; goto skipESSPopulation; }

                    //string detailUrl = "https://edfacts.ed.gov/generate/DataSetYearVersionDetailsByAllAbbrv?collectionAbbrv={0}&dataSetAbbrv={1}&versionNum={2}&yearAbbrv={3}";
                    string detailUrl = _fsWSURL + detailSubdir + "?collectionAbbrv={0}&dataSetAbbrv={1}&versionNum={2}&yearAbbrv={3}";
                    detailUrl = string.Format(detailUrl, collectName, essDSNameAbbrv, maxVersionNumber.ToString(), fqYrName);

                    var client1 = new RestClient(new RestClientOptions(new Uri(detailUrl)));
                    var request1 = new RestRequest("", Method.Get);
                    var response1 = client1.Execute(request1);

                    edfacts = response1.Content;
                    edfacts = edfacts.Replace(strRep1, "").Replace("]}", "]");
                    DSYVrdetail = JsonConvert.DeserializeObject<List<DataSetYearVersionDetailsByAllAbbrv>>(edfacts);
                }
                else
                {

                    var fileloc = _fsMetaFileLoc + "\\" + _fsMetaESSDetailFileName;
                    using (StreamReader r = new StreamReader(fileloc))
                    {
                        edfacts = r.ReadToEnd();
                        edfacts = edfacts.Replace(strRep1, "").Replace("]}", "]");
                    }

                    DSYVrdetail = JsonConvert.DeserializeObject<List<DataSetYearVersionDetailsByAllAbbrv>>(edfacts);
                    //DSYVrdetail = (List<DataSetYearVersionDetailsByAllAbbrv>)DSYVrdetail.Where(a => a.DSAbbrv == essDSNameAbbrv).Select(a => a);

                    if (DSYVrdetail.Select(A => A.YearValue).FirstOrDefault().HasValue)
                    {
                        if ((int?)DSYVrdetail.Select(A => A.YearValue).FirstOrDefault() != null)
                        {
                            maxSubmissionYear = (int)DSYVrdetail.Select(A => A.YearValue).FirstOrDefault();
                        }
                    }

                    if (DSYVrdetail.Select(A => A.VersionNum).FirstOrDefault().HasValue)
                    {
                        if ((int?)DSYVrdetail.Select(A => A.VersionNum).FirstOrDefault() != null) {
                            maxVersionNumber = (int)DSYVrdetail.Select(A => A.VersionNum).FirstOrDefault();
                        }
                    }
                    nxtYear = maxSubmissionYear + 1;
                    fqYrName = maxSubmissionYear.ToString() + "-" + nxtYear.ToString();

                    bool checkPrevFSPop = checkPrevPopFSMetaYrandVers(true, maxSubmissionYear.ToString(), maxVersionNumber);
                    if (!checkPrevFSPop) { skipESSPop = true; goto skipESSPopulation; }

                }

                _appRepository.MigrateMetadata("ESS", maxSubmissionYear, true);

                var time1 = DateTime.Now;
                DeleteExistingCatInfobyYearandDS(collectName, essDSNameAbbrv, maxVersionNumber.ToString(), fqYrName, maxSubmissionYear.ToString(), DSYVrdetail);
                var time2 = DateTime.Now;
                populateCatInfoData(collectName, essDSNameAbbrv, maxVersionNumber.ToString(), fqYrName, DSYVrdetail);
                var time3 = DateTime.Now;

                var t1 = time2.Subtract(time1).TotalMinutes;
                var t2 = time3.Subtract(time2).TotalMinutes;

                /* *** Populate ESS FSLayout data *** */
                DelandPopulateFSLayoutdata(collectName, essDSNameAbbrv, maxVersionNumber.ToString(), fqYrName);

                UpdPopFSMetaYrandVersinGenConfig(true, maxSubmissionYear.ToString(), maxVersionNumber);

                _appRepository.UpdateViewDefinitions();

            skipESSPopulation:

                #endregion

                #region CHARTER Population

                maxSubmissionYear = 0;
                maxVersionNumber = 0;
                nxtYear = 0;
                fqYrName = string.Empty;
                var chrtr = string.Empty;
                int year = 0;
                string maxVersNum = string.Empty;

                if (_useWSforFSMetaUpd)
                {

                    var charterQuery1 = from n in initDSYVr
                                        where n.DataSetName == charterDSName
                                        select new { Year = n.YearName.Replace("SY ", "").Substring(0, 4) };

                    var charterQuery2 = from n in charterQuery1
                                        orderby n.Year descending
                                        select n;

                    var charterQuery3 = charterQuery2.FirstOrDefault();

                    var charterQuery4 = from n in initDSYVr
                                        where n.DataSetName == charterDSName && n.VersionStatusDesc == pub && n.YearName.Contains("SY " + charterQuery3.Year)
                                        orderby n.VersionNumber descending
                                        select new { Year = n.YearName.Replace("SY ", "").Substring(0, 4), versNum = n.VersionNumber.ToString() };

                    maxSubmissionYear = int.Parse(initDSYVr.Where(n => n.DataSetName == charterDSName && n.VersionStatusDesc == pub).Max(d => d.YearName).Replace("SY ", "").Substring(0, 4));
                    if (!string.IsNullOrEmpty(_selSYr)) { maxSubmissionYear = Convert.ToInt32(_selSYr); }
                    maxVersionNumber = initDSYVr.Where(n => n.DataSetName == charterDSName && n.VersionStatusDesc == pub && n.YearName.Contains("SY " + maxSubmissionYear.ToString())).Max(a => a.VersionNumber);
                    nxtYear = maxSubmissionYear + 1;
                    fqYrName = maxSubmissionYear.ToString() + "-" + nxtYear.ToString();
                    //year = charterQuery4 is null  ? 0 : int.Parse(charterQuery4.FirstOrDefault().Year);
                    year = maxSubmissionYear;
                    if (charterQuery4.FirstOrDefault() is not null)
                    {
                        maxVersNum = charterQuery4 is null ? "" : charterQuery4.FirstOrDefault().versNum;
                    }


                    bool checkPrevFSPop = checkPrevPopFSMetaYrandVers(false, maxSubmissionYear.ToString(), maxVersionNumber);
                    if (!checkPrevFSPop) { skipCHRPop = true; goto skipCHRPopulation; }

                    
                    string detailUrl = _fsWSURL + detailSubdir + "?collectionAbbrv={0}&dataSetAbbrv={1}&versionNum={2}&yearAbbrv={3}";
                    detailUrl = string.Format(detailUrl, collectName, charterDSNameAbbrv, maxVersionNumber.ToString(), fqYrName);

                    var client1 = new RestClient(new RestClientOptions(new Uri(detailUrl)));
                    var request1 = new RestRequest("", Method.Get);
                    var response1 = client1.Execute(request1);

                    chrtr = response1.Content;
                    chrtr = chrtr.Replace(strRep1, "").Replace("]}", "]");
                    DSYVrdetail = JsonConvert.DeserializeObject<List<DataSetYearVersionDetailsByAllAbbrv>>(chrtr);

                }
                else
                {

                    var fileloc = _fsMetaFileLoc + "\\" + _fsMetaCHRDetailFileName;
                    using (StreamReader r = new StreamReader(fileloc))
                    {
                        chrtr = r.ReadToEnd();
                        chrtr = chrtr.Replace(strRep1, "").Replace("]}", "]");
                    }

                    DSYVrdetail = JsonConvert.DeserializeObject<List<DataSetYearVersionDetailsByAllAbbrv>>(chrtr);
                    //DSYVrdetail = (List<DataSetYearVersionDetailsByAllAbbrv>)DSYVrdetail.Where(a => a.DSAbbrv == essDSNameAbbrv).Select(a => a);
                    if ((int?)DSYVrdetail.Select(A => A.YearValue).FirstOrDefault() != null)
                    {
                        maxSubmissionYear = (int)DSYVrdetail.Select(A => A.YearValue).FirstOrDefault();
                    }

                    if ((int?)DSYVrdetail.Select(A => A.VersionNum).FirstOrDefault() != null)
                    {
                        maxVersionNumber = (int)DSYVrdetail.Select(A => A.VersionNum).FirstOrDefault();
                    }

                    nxtYear = maxSubmissionYear + 1;
                    fqYrName = maxSubmissionYear.ToString() + "-" + nxtYear.ToString();

                    // check later if need to removed : SA Check
                    year = maxSubmissionYear;
                    maxVersNum = maxVersionNumber.ToString();

                    bool checkPrevFSPop = checkPrevPopFSMetaYrandVers(false, maxSubmissionYear.ToString(), maxVersionNumber);
                    if (!checkPrevFSPop) { skipCHRPop = true; goto skipCHRPopulation; }

                }

                //DSYVrdetail = JsonConvert.DeserializeObject<List<DataSetYearVersionDetailsByAllAbbrv>>(edfacts);

                _appRepository.MigrateMetadata("CHARTER", maxSubmissionYear, true);

                DeleteExistingCatInfobyYearandDS(collectName, charterDSNameAbbrv, maxVersNum, fqYrName, year.ToString(), DSYVrdetail);

                populateCatInfoData(collectName, charterDSNameAbbrv, maxVersNum, fqYrName, DSYVrdetail);

                /* ==== Populate CHARTER FSLayout data ==== */
                DelandPopulateFSLayoutdata(collectName, charterDSNameAbbrv, maxVersNum.ToString(), fqYrName);

                UpdPopFSMetaYrandVersinGenConfig(false, maxSubmissionYear.ToString(), maxVersionNumber);

                _appRepository.UpdateViewDefinitions();

            skipCHRPopulation:

                #endregion

                if (newCatInfo.Count > 0)
                {

                    var logid = Guid.NewGuid().ToString();
                    _logger.LogCritical("");
                    _logger.LogCritical("Log ID: " + logid);
                    _logger.LogCritical("New Categories were inserted");
                    foreach (var item in newCatInfo)
                    {
                        _logger.LogCritical("New Category Name : " + item.Key + ", Abbreviation : " + item.Value + ".");
                    }
                    _logger.LogCritical("----- END -----");
                    _logger.LogCritical("");

                    var time = DateTime.Now;
                    var status = "The metadata was successfully updated on " + time.ToString() + ". New Categories were added. Please see Log ID: " + logid + ".";
                    UpdateKeyinGenConfig(FSMetalogKey, status);
                    UpdateKeyinGenConfig(FSMetasStaKey, FSMetastausok);
                    return status;

                }
                else if (skipESSPop && skipCHRPop)
                {
                    var time = DateTime.Now;
                    var status = "There were no updates made to the metadata. It was last checked on " + time.ToString() + " and is up to date";
                    UpdateKeyinGenConfig(FSMetalogKey, status);
                    UpdateKeyinGenConfig(FSMetasStaKey, FSMetastausok);
                    return status;
                }
                else
                {

                    //if (!string.IsNullOrEmpty(_bkfsMetaFileLoc) && _reloadFromBackUp)
                    //{
                    //    if (!Directory.Exists(_bkfsMetaFileLoc)) Directory.CreateDirectory(_bkfsMetaFileLoc);

                    //    File.WriteAllText(_bkfsMetaFileLoc + @"\" + bkESSflname, edfacts);
                    //    File.WriteAllText(_bkfsMetaFileLoc + @"\" + bkCHRflname, chrtr);
                    //    File.WriteAllText(_bkfsMetaFileLoc + @"\" + bkESSflnameFLay, bkESSFLay);
                    //    File.WriteAllText(_bkfsMetaFileLoc + @"\" + bkCHRflnameFLay, bkCHRFLay);
                    //}

                    var time = DateTime.Now;
                    var status = "The metadata was successfully updated on " + time.ToString() + ".";
                    UpdateKeyinGenConfig(FSMetalogKey, status);
                    UpdateKeyinGenConfig(FSMetasStaKey, FSMetastausok);
                    return status;
                }



            }
            catch (Exception e)
            {
                var x = e.Message;
                var y = e.InnerException;
                var time = DateTime.Now;
                var logid = Guid.NewGuid().ToString();

                string err2 = "Log ID: " + logid;
                string err3 = "----- Error in FS Metadata population-----";
                string err4 = "Time : " + time.ToString();
                string err5 = "Error Message : " + x;
                string err6 = "InnerException : " + y;
                string err7 = "----- END -----";

                _logger.LogCritical("");
                _logger.LogCritical(err2);
                _logger.LogCritical(err3);
                _logger.LogCritical(err4);
                _logger.LogCritical(err5);
                _logger.LogCritical(err6);
                _logger.LogCritical(err7);
                _logger.LogCritical("");

                var status = "The Metadata Update failed. The last attempt was on " + time.ToString() + ". Please see Log ID: " + logid + ". To retrieve the metadata file and manually process it, navigate to the File Storage page in GitBook at https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/installation/upgrade/generate-file-storage";
       
                UpdateKeyinGenConfig(FSMetalogKey, status);
                UpdateKeyinGenConfig(FSMetasStaKey, FSMetastausFail);

                _appRepository.MigrateMetadata("ESS", maxSubmissionYear, false);
                _appRepository.MigrateMetadata("CHARTER", maxSubmissionYear, false);


                return "FS Metadata population FAILED. Log ID: " + logid + ". Please contact your admin.";
            }

        }

        public void DeleteExistingCatInfobyYearandDS_NC(string collectionAbbrv, string dataSetAbbrv, string versionNum, string fqYrName, string yearAbbrv, List<DataSetYearVersionDetailsByAllAbbrv> DSYVrdetail)
        {

            var distFSinDS = DSYVrdetail.Where(ds => ds.YearAbbrv == fqYrName).Select(a => a.FileSpecNum).Distinct().ToList();

            IQueryable<CategorySet> categorySetsToDelete = _appDbContext.CategorySets.Where(cs => distFSinDS.Contains(cs.GenerateReport.ReportCode.Substring(1)) && cs.SubmissionYear == fqYrName.Substring(5)).Include("CategorySet_Categories").Include("CategorySet_Categories.Category").Include("CategorySet_Categories.Category.CategoryOptions");


            foreach (var categorySetToDelete in categorySetsToDelete)
            {
                foreach (var categorySet_CategoryToDelete in categorySetToDelete.CategorySet_Categories)
                {
                    _appDbContext.CategoryOptions.RemoveRange(categorySet_CategoryToDelete.Category.CategoryOptions);
                    _appDbContext.Categories.Remove(categorySet_CategoryToDelete.Category);
                    _appDbContext.CategorySet_Categories.Remove(categorySet_CategoryToDelete);
                }

                _appDbContext.CategorySets.Remove(categorySetToDelete);
            }
            _appDbContext.SaveChanges();

        }

        public void DeleteExistingCatInfobyYearandDS(string collectionAbbrv, string dataSetAbbrv, string versionNum, string fqYrName, string yearAbbrv, List<DataSetYearVersionDetailsByAllAbbrv> DSYVrdetail)
        {
            /*
            IQueryable<CategorySet> catsetbyYr = _appDbContext.CategorySets.Where(cs => cs.SubmissionYear == yearAbbrv && (cs.CategorySetId == 169454 || cs.CategorySetId == 169455)).Include(x => x.CategorySet_Categories).ThenInclude(a => a.Category).Take(10);

            IQueryable<CategorySet> catsetbyYrrr = _appDbContext.CategorySets
                .Where(cs => cs.SubmissionYear != yearAbbrv && cs.CategorySet_Categories.Any(c=>c.CategoryId==358) )
                .Include(x => x.CategorySet_Categories)
                .ThenInclude(a => a.Category)
                .Take(10);
            */

            var qry1 = from d in DSYVrdetail
                       select new
                       {
                           d.FileSpecName,
                           d.FileSpecNum,
                           d.FileType,
                       };

            var distFSinDS = qry1.Distinct().Select(a => a.FileSpecNum).ToList();

            IQueryable<GenerateReport> genRep = _appDbContext.GenerateReports;
            var repInfo = from x in genRep
                          where distFSinDS.Contains(x.ReportCode.Replace("c", ""))
                          select new { x.GenerateReportId, x.ReportCode, x.ReportName, x.ReportSequence, x.ReportShortName };

            var FSrepID = repInfo.Select(xx => xx.GenerateReportId).Distinct().ToList();

            IQueryable<CategorySet> catsetbyYr = _appDbContext.CategorySets
                                                .Where(cs => cs.SubmissionYear == yearAbbrv && FSrepID.Contains(cs.GenerateReportId))
                                                .Include(x => x.CategorySet_Categories);

            //.ThenInclude(a => a.Category)
            //.Take(100); // Remove take later

            //.Take(5);

            var allCatsinYr = from a in catsetbyYr
                              from b in a.CategorySet_Categories
                              select new { b.CategoryId, a.CategorySetId };

            var distCSInfobyYear = allCatsinYr.Distinct().ToList();
            var distCatbyYear = allCatsinYr.Select(A => A.CategoryId).Distinct().ToList();

            // Cats associated w FS used in diff year
            IQueryable<CategorySet> catinOtherYrs = _appDbContext.CategorySets
                                                    .Include(x => x.CategorySet_Categories)
                                                    .Where(a => a.SubmissionYear != yearAbbrv && a.CategorySet_Categories.Any(a => distCatbyYear.Contains(a.CategoryId)));

            // Cats associated w diff FS used in same year
            IQueryable<CategorySet> catsetbyYrinDiffsetofFSs = _appDbContext.CategorySets
                                                               .Where(cs => cs.SubmissionYear == yearAbbrv && !FSrepID.Contains(cs.GenerateReportId))
                                                               .Include(x => x.CategorySet_Categories);

            List<CategorySet_Category> delListCSC = new List<CategorySet_Category>();
            List<CategorySet> delListCS = new List<CategorySet>();
            List<Category> delListCat = new List<Category>();
            List<CategoryOption> delListCO = new List<CategoryOption>();

            foreach (var csInfo in distCSInfobyYear)
            {

                var catsetidd = csInfo.CategorySetId;

                var catcheck = from a in catinOtherYrs
                               where a.CategorySet_Categories.Any(c => c.CategoryId == csInfo.CategoryId)
                               select a;

                var isCatinDiffFSsetofsameYr = from a in catsetbyYrinDiffsetofFSs
                                               where a.CategorySet_Categories.Any(c => c.CategoryId == csInfo.CategoryId)
                                               select a;

                var cnt = catcheck.Count();
                var cnt1 = isCatinDiffFSsetofsameYr.Count();

                if (catcheck.Count() > 0 || isCatinDiffFSsetofsameYr.Count() > 0)
                {
                    // if Category associated in Other years than only delete the link in CategorySet_Category table
                    CategorySet_Category csc = _appDbContext.CategorySet_Categories.Where(a => a.CategorySetId == csInfo.CategorySetId && a.CategoryId == csInfo.CategoryId).FirstOrDefault();
                    delListCSC.Add(csc);

                    IQueryable<CategoryOption> colist = _appDbContext.CategoryOptions.Where(a => a.CategorySetId == csInfo.CategorySetId && a.CategoryId == csInfo.CategoryId);
                    foreach (var co in colist)
                    {
                        delListCO.Add(co);
                    }
                }
                else
                {
                    // if Category associated in only current Year than only delete the link in CategorySet, CategorySet option, CategorySet_Category table
                    IQueryable<CategoryOption> colist = _appDbContext.CategoryOptions.Where(a => a.CategorySetId == csInfo.CategorySetId);
                    foreach (var co in colist)
                    {
                        delListCO.Add(co);
                    }
                    //CategoryOption co = _appDbContext.CategoryOptions.Where(a => a.CategoryId == catInf.CategoryId).FirstOrDefault();
                    //delListCO.Add(co);


                    Category CAT = _appDbContext.Categories.Where(a => a.CategoryId == csInfo.CategoryId).FirstOrDefault();
                    delListCat.Add(CAT);


                    CategorySet_Category csc = _appDbContext.CategorySet_Categories.Where(a => a.CategorySetId == csInfo.CategorySetId && a.CategoryId == csInfo.CategoryId).FirstOrDefault();
                    delListCSC.Add(csc);

                }

                if (delListCS.Where(p => p.CategorySetId == csInfo.CategorySetId).Count() == 0)
                {
                    CategorySet cs = _appDbContext.CategorySets.Where(a => a.CategorySetId == csInfo.CategorySetId).FirstOrDefault();
                    delListCS.Add(cs);

                }

            }

            var allCatSetList = catsetbyYr.Select(a => a.CategorySetId).Distinct().ToList();
            var limCatSetList = allCatsinYr.Select(a => a.CategorySetId).Distinct().ToList();
            var exceptList = allCatSetList.Except(limCatSetList).ToList();

            foreach (var catset in exceptList)
            {
                CategorySet cs = _appDbContext.CategorySets.Where(a => a.CategorySetId == catset).FirstOrDefault();
                delListCS.Add(cs);
            }

            var cscCount = delListCSC.Count();
            var csCount = delListCS.Count();
            var catCount = delListCat.Count();
            var coCount = delListCO.Count();


            if (coCount > 0)
            {
                _appDbContext.CategoryOptions.RemoveRange(delListCO);
                _appDbContext.SaveChanges();
            }

            if (cscCount > 0)
            {
                _appDbContext.CategorySet_Categories.RemoveRange(delListCSC);
                _appDbContext.SaveChanges();
            }

            // Categories not to be deleted.
            //if (catCount > 0)
            //{
            //    _appDbContext.Categories.RemoveRange(delListCat);
            //    _appDbContext.SaveChanges();
            //}

            if (csCount > 0)
            {
                _appDbContext.CategorySets.RemoveRange(delListCS);
                _appDbContext.SaveChanges();
            }

        }

        public void callCatServnStore_NC(string collectionAbbrv, string dataSetAbbrv, string versionNum, string fqYrName, List<DataSetYearVersionDetailsByAllAbbrv> DSYVrdetail)
        {

            IQueryable<GenerateReport> genRep = _appDbContext.GenerateReports;
            var repInfo = (from x in genRep
                           select new { x.GenerateReportId, x.ReportCode, x.ReportName, x.ReportSequence, x.ReportShortName }).ToList();

            var newGenerateReports = DSYVrdetail.Where(d => repInfo.Count(r => r.ReportCode.ToLower() == d.FileSpecNum) == 0).Distinct().ToList();
            var newGenerateReportsFinal = new List<GenerateReport>();

            foreach (var newGenerateReport in newGenerateReports.Select(gr => new {
                gr.FileSpecNum,
                gr.FileSpecName,
                gr.ElectronicFileDesc
            }).Distinct())
            {

                var generateReport = new GenerateReport()
                {
                    GenerateReportControlTypeId = 2,
                    GenerateReportTypeId = 3,
                    IsActive = true,
                    ReportCode = newGenerateReport.FileSpecNum,
                    ReportName = string.Concat(newGenerateReport.FileSpecNum, ": ", newGenerateReport.FileSpecName),
                    ReportShortName = newGenerateReport.FileSpecNum,
                    ReportTypeAbbreviation = newGenerateReport.ElectronicFileDesc,
                    ShowCategorySetControl = true,
                    ShowData = true,
                    ShowFilterControl = false,
                    ShowGraph = false,
                    ShowSubFilterControl = false,
                    IsLocked = false,
                    UseLegacyReportMigration = true
                };

                newGenerateReportsFinal.Add(generateReport);
                repInfo.Add(new { generateReport.GenerateReportId, generateReport.ReportCode, generateReport.ReportName, generateReport.ReportSequence, generateReport.ReportShortName });
            }
            _appDbContext.AddRange(newGenerateReportsFinal.Distinct());
            _appDbContext.SaveChanges();


            #region Category Sets w Categories & PVs

            var qry1 = from d in DSYVrdetail
                       where d.CSA != null
                       select new
                       {
                           d.CollectionAbbrv,
                           d.FileSpecName,
                           d.FileSpecNum,
                           d.FileType,
                           d.ElectronicFileDesc,
                           d.DGComment,
                           d.DGDefinition,
                           d.DGEDID,
                           d.DGName,
                           d.DGScopeComment,
                           d.DEAbbr,
                           d.DEMask,
                           d.DEName,
                           d.DEOrderNum,
                           d.DETypeDesc,
                           d.DETypeID,
                           d.DETypeName,
                           d.CategoryAbbr,
                           d.CategoryDefinition,
                           d.CategoryName,
                           d.CategoryOrderNum,
                           d.PVAbbr,
                           d.PVBusinessAbbr,
                           d.PVDescription,
                           d.PVDisplayorder,
                           d.PVName,
                           d.PVTypeAbbr,
                           d.PVTypeDesc,
                           d.IsDatacollEnabledLEA,
                           d.IsDatacollEnabledSCH,
                           d.IsDatacollEnabledSEA,
                           d.TableName,
                           d.YearAbbrv,
                           d.YearName,
                           d.YearValue
                       };


            var qry2 = from d in qry1
                       select new
                       {
                           d.FileSpecName,
                           d.FileSpecNum,
                           d.ElectronicFileDesc,
                           d.DGEDID,
                           d.DGName,
                           d.DEAbbr,
                           d.DEMask,
                           d.DEName,
                           d.DEOrderNum,
                           d.DETypeDesc,
                           d.DETypeID,
                           d.DETypeName,
                           d.CategoryAbbr,
                           d.CategoryDefinition,
                           d.CategoryName,
                           d.CategoryOrderNum,
                           d.IsDatacollEnabledLEA,
                           d.IsDatacollEnabledSCH,
                           d.IsDatacollEnabledSEA,
                           d.YearValue,
                           d.TableName
                       };


            var qry3 = qry2.Distinct().OrderBy(a => a.FileSpecNum).ThenBy(a => a.DGEDID).ThenBy(a => a.DEOrderNum).ThenBy(a => a.CategoryOrderNum).ToList();


            // Insert Cat Set Info into [App].[CategorySets] Table
            var catSetInfo = qry3
                        .Select
                        (
                        a => new {
                            a.FileSpecNum,
                            a.FileSpecName,
                            a.ElectronicFileDesc,
                            a.DEName,
                            a.DEAbbr,
                            a.DEOrderNum,
                            a.YearValue,
                            a.TableName,
                            a.DGName,
                            a.IsDatacollEnabledLEA,
                            a.IsDatacollEnabledSCH,
                            a.IsDatacollEnabledSEA
                        }
                        )
                        .Distinct().ToList();


            var cnt = catSetInfo.Count();

            var generateReports = new ConcurrentBag<GenerateReport>(_appDbContext.GenerateReports.AsTracking());
            var generateReportsToAdd = new ConcurrentBag<GenerateReport>();
            var tableTypes = new ConcurrentBag<TableType>(_appDbContext.TableTypes.ToList());
            var categories = new ConcurrentBag<Category>(_appDbContext.Categories.ToList());

            //catSetInfo.AsParallel().ForAll(csi =>
            foreach (var csi in catSetInfo)
            {
                int subtotalNumber = 0;
                var cscode = string.Empty;
                var csName = string.Empty;

                if (csi.DEAbbr == "EUT") // This is a Total category set
                {
                    cscode = "TOT";
                    //csName = "TOTAL OF THE EDUCATION UNIT";
                    csName = "Total of the Education Unit";
                }
                else if (int.TryParse(csi.DEAbbr, out subtotalNumber)) // This is a subtotal category set
                {
                    cscode = string.Concat("ST", subtotalNumber);
                    csName = string.Concat("Subtotal ", subtotalNumber);
                }
                else
                {
                    cscode = string.Concat("CS", csi.DEAbbr); // This is a normal category set
                    csName = string.Concat("Category Set ", csi.DEAbbr);
                }
                //var cscode = csi.DEName + " - " + csi.DEAbbr;
                //cscode = cscode.Length > 50 ? csi.DEName.Substring(0, 50-(csi.DEAbbr.Length+2)) + "-" + csi.DEAbbr : cscode;
                //cscode = genReportId == 0 ? cscode + " - " + csi.FileSpecNum + "- NOgenReportId" : cscode;
                //genReportId = genReportId == 0 ? 114 : genReportId;
                var genReport = generateReports.Where(a => a.ReportCode.ToLower() == csi.FileSpecNum).FirstOrDefault();
                    

                if (genReport == null)
                {
                    genReport = new GenerateReport()
                    {
                        GenerateReportControlTypeId = 2,
                        GenerateReportTypeId = 3,
                        IsActive = true,
                        ReportCode = csi.FileSpecNum,
                        ReportName = string.Concat(csi.FileSpecNum, ": ", csi.FileSpecName),
                        ReportShortName = csi.FileSpecNum,
                        ReportTypeAbbreviation = csi.ElectronicFileDesc,
                        ShowCategorySetControl = true,
                        ShowData = true,
                        ShowFilterControl = false,
                        ShowGraph = false,
                        ShowSubFilterControl = false,
                        IsLocked = false,
                        UseLegacyReportMigration = true
                    };
                }

                var tableType = tableTypes.FirstOrDefault(tt => tt.TableTypeAbbrv == csi.TableName);

                if (tableType == null)
                {
                    // EdFactsTableTypeId isn't in the JSON package, autoincrementing to next based on existing max
                    tableType = new TableType()
                    {
                        TableTypeAbbrv = csi.TableName,
                        TableTypeName = csi.DGName,
                        EdFactsTableTypeId = _appDbContext.TableTypes.Max(m => m.EdFactsTableTypeId) + 1
                    };
                }

                if (genReport.CategorySets == null)
                {
                    genReport.CategorySets = new List<CategorySet>();
                }

                if (csi.IsDatacollEnabledSEA == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = csName;
                    cs.CategorySetSequence = csi.DEOrderNum;
                    cs.OrganizationLevelId = 1;
                    cs.SubmissionYear = (csi.YearValue + 1).ToString();
                    cs.TableType = tableType;
                    genReport.CategorySets.Add(cs);
                }

                if (csi.IsDatacollEnabledLEA == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = csName;
                    cs.CategorySetSequence = csi.DEOrderNum;
                    cs.OrganizationLevelId = 2;
                    cs.SubmissionYear = (csi.YearValue + 1).ToString();
                    cs.TableType = tableType;
                    genReport.CategorySets.Add(cs);
                }

                if (csi.IsDatacollEnabledSCH == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = csName;
                    cs.CategorySetSequence = csi.DEOrderNum;
                    cs.OrganizationLevelId = 3;
                    cs.SubmissionYear = (csi.YearValue + 1).ToString();
                    cs.TableType = tableType;
                    genReport.CategorySets.Add(cs);
                }

                // Insert Cateory Info into [App].[Category] Table
                var categories1 = DSYVrdetail.Where(d => d.FileSpecNum == genReport.ReportCode && d.DEAbbr == csi.DEAbbr).Select(a => new { a.CategoryAbbr, a.CategoryName, a.PVName, a.PVAbbr, a.PVBusinessAbbr, a.PVDescription, a.PVDisplayorder }).ToList();

                foreach (var categorySet in genReport.CategorySets)
                {
                    foreach (var category in categories1.Select(c => new { c.CategoryAbbr, c.CategoryName }).Distinct())
                    {
                        var newCategory = new Category()
                        {
                            CategoryCode = category.CategoryAbbr is null ? "NOABBRV" : category.CategoryAbbr.ToString(),
                            CategoryName = category.CategoryName
                        };

                        foreach (var permittedValue in categories1.Select(co => new { co.PVDescription, co.PVAbbr, co.PVBusinessAbbr, co.PVDisplayorder, co.PVName }).Distinct())
                        {
                            var newPermittedValue = new CategoryOption()
                            {
                                Category = newCategory,
                                CategorySet = categorySet,
                                CategoryOptionCode = permittedValue.PVBusinessAbbr,
                                CategoryOptionName = permittedValue.PVName,
                                CategoryOptionSequence = permittedValue.PVDisplayorder
                            };

                            newCategory.CategoryOptions.Add(newPermittedValue);
                        }

                        var csc = new CategorySet_Category()
                        {
                            Category = newCategory,
                            CategorySet = categorySet
                        };

                        categorySet.CategorySet_Categories.Add(csc);
                    }
                }

                generateReportsToAdd.Add(genReport);
            }//);

            foreach (var report in generateReportsToAdd)
            {
                // Check if the report already exists in the database
                if (report.GenerateReportId == 0)
                {
                    // If the report doesn't exist, add it to the context
                    _appDbContext.GenerateReports.Add(report);
                }
                else
                {
                    _appDbContext.GenerateReports.Update(report);
                }
            }
            _appDbContext.SaveChanges();


            #endregion


            #region NO CSA w NO EUT

            /*
                ******************************************
                ***   FSs which have NO CATEGORY SETS & NO EUT ***
                ******************************************
            */

            var listFSswNoCSswEUT = from d in DSYVrdetail
                                    where d.CSA is null && d.DEAbbr == "EUT"
                                    select new
                                    {
                                        d.FileSpecNum
                                    };

            var dist_listFSswNoCSswEUT = listFSswNoCSswEUT.Distinct().Select(a => a.FileSpecNum).ToList<string>();

            var qry_noCSFSpecs = from d in DSYVrdetail
                                     //where d.CSA is null && d.DEAbbr != "EUT"
                                 where d.CSA is null && !dist_listFSswNoCSswEUT.Contains(d.FileSpecNum.ToString())
                                 select new
                                 {
                                     d.CollectionAbbrv,
                                     d.FileSpecName,
                                     d.FileSpecNum,
                                     d.DEName,
                                     d.IsDatacollEnabledLEA,
                                     d.IsDatacollEnabledSCH,
                                     d.IsDatacollEnabledSEA,
                                     d.TableName,
                                     d.YearAbbrv,
                                     d.YearName,
                                     d.YearValue,
                                     d.DGName,
                                     d.ElectronicFileDesc
                                 };

            var qry_noCSFSpecs_dist = qry_noCSFSpecs.Select(a => new
            {
                a.FileSpecName,
                a.FileSpecNum,
                a.YearValue,
                a.IsDatacollEnabledLEA,
                a.IsDatacollEnabledSCH,
                a.IsDatacollEnabledSEA,
                //a.TableName,
                //a.DGName,
                a.ElectronicFileDesc
            }).Distinct().ToList();


            foreach (var csi in qry_noCSFSpecs_dist)
            {

                var cscode = "CSA";
                var deName = "Category Set A";
                //cscode = cscode.Length > 50 ? csi.DEName.Substring(0, 50-(csi.DEAbbr.Length+2)) + "-" + csi.DEAbbr : cscode;
                var genReportId = repInfo.Where(a => a.ReportCode == csi.FileSpecNum).Select(a => a.GenerateReportId).FirstOrDefault();
                //deName = genReportId == 0 ? deName+" - "+csi.FileSpecNum : deName;
                //cscode = genReportId == 0 ? cscode + " - " + csi.FileSpecNum + "-NOgenReportId" : cscode;
                //genReportId = genReportId == 0 ? 116 : genReportId;


                /////////

                if (genReportId == 0)
                {
                    var generateReport = new GenerateReport()
                    {
                        GenerateReportControlTypeId = 2,
                        GenerateReportTypeId = 3,
                        IsActive = true,
                        ReportCode = csi.FileSpecNum,
                        ReportName = string.Concat(csi.FileSpecNum, ": ", csi.FileSpecName),
                        ReportShortName = csi.FileSpecNum,
                        ReportTypeAbbreviation = csi.ElectronicFileDesc,
                        ShowCategorySetControl = true,
                        ShowData = true,
                        ShowFilterControl = false,
                        ShowGraph = false,
                        ShowSubFilterControl = false,
                        IsLocked = false,
                        UseLegacyReportMigration = true
                    };

                    _appDbContext.GenerateReports.Add(generateReport);
                    _appDbContext.SaveChanges();

                    genReportId = generateReport.GenerateReportId;
                }

                /*
                 * 
                var tableType = tableTypes.FirstOrDefault(tt => tt.TableTypeAbbrv == csi.TableName);

                if (tableType == null)
                {
                    // EdFactsTableTypeId isn't in the JSON package, autoincrementing to next based on existing max
                    tableType = new TableType()
                    {
                        TableTypeAbbrv = csi.TableName,
                        TableTypeName = csi.DGName,
                        EdFactsTableTypeId = _appDbContext.TableTypes.Max(m => m.EdFactsTableTypeId) + 1
                    };

                    _appDbContext.TableTypes.Add(tableType);
                    _appDbContext.SaveChanges();
                }

                */

                /////////

                if (csi.FileSpecNum == "190")
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1112;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    return;
                }

                if (csi.FileSpecNum == "196")
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1182;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    return;
                }

                if (csi.IsDatacollEnabledSEA == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

                if (csi.IsDatacollEnabledLEA == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode; // Change after talkig to Team
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 2;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId; // Defaulted to 21. Check with Team.
                    _appDbContext.CategorySets.Add(cs);

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

                if (csi.IsDatacollEnabledSCH == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode; // Change after talkig to Team
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 3;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }


            }

            _appDbContext.SaveChanges();


            #endregion


            #region NO CSA w EUT.. Insert only CSA info


            var qry_noCSFSpecs0 = from d in DSYVrdetail
                                      //where d.CSA is null && d.DEAbbr != "EUT"
                                  where d.CSA is null && dist_listFSswNoCSswEUT.Contains(d.FileSpecNum.ToString()) && d.DEAbbr != "EUT"
                                  select new
                                  {
                                      d.CollectionAbbrv,
                                      d.FileSpecName,
                                      d.FileSpecNum,
                                      d.DEName,
                                      d.IsDatacollEnabledLEA,
                                      d.IsDatacollEnabledSCH,
                                      d.IsDatacollEnabledSEA,
                                      d.TableName,
                                      d.YearAbbrv,
                                      d.YearName,
                                      d.YearValue,
                                      d.DGName,
                                      d.ElectronicFileDesc
                                  };

            var qry_noCSFSpecs_dist0 = qry_noCSFSpecs0.Select(a => new
            {
                a.FileSpecName,
                a.FileSpecNum,
                a.YearValue,
                a.IsDatacollEnabledLEA,
                a.IsDatacollEnabledSCH,
                a.IsDatacollEnabledSEA,
                a.TableName,
                a.DGName,
                a.ElectronicFileDesc
            }).Distinct().ToList();


            foreach (var csi in qry_noCSFSpecs_dist0)
            {

                var cscode = "CSA";
                var deName = "Category Set A";
                //cscode = cscode.Length > 50 ? csi.DEName.Substring(0, 50-(csi.DEAbbr.Length+2)) + "-" + csi.DEAbbr : cscode;
                var genReportId = repInfo.Where(a => a.ReportCode == csi.FileSpecNum).Select(a => a.GenerateReportId).FirstOrDefault();
                //deName = genReportId == 0 ? deName+" - "+csi.FileSpecNum : deName;
                //cscode = genReportId == 0 ? cscode + " - " + csi.FileSpecNum + "-NOgenReportId" : cscode;
                //genReportId = genReportId == 0 ? 116 : genReportId;


                /////////

                if (genReportId == 0)
                {
                    var generateReport = new GenerateReport()
                    {
                        GenerateReportControlTypeId = 2,
                        GenerateReportTypeId = 3,
                        IsActive = true,
                        ReportCode = csi.FileSpecNum,
                        ReportName = string.Concat(csi.FileSpecNum, ": ", csi.FileSpecName),
                        ReportShortName = csi.FileSpecNum,
                        ReportTypeAbbreviation = csi.ElectronicFileDesc,
                        ShowCategorySetControl = true,
                        ShowData = true,
                        ShowFilterControl = false,
                        ShowGraph = false,
                        ShowSubFilterControl = false,
                        IsLocked = false,
                        UseLegacyReportMigration = true
                    };

                    _appDbContext.GenerateReports.Add(generateReport);
                    _appDbContext.SaveChanges();

                    genReportId = generateReport.GenerateReportId;
                }

                var tableType = tableTypes.FirstOrDefault(tt => tt.TableTypeAbbrv == csi.TableName);

                if (tableType == null)
                {
                    // EdFactsTableTypeId isn't in the JSON package, autoincrementing to next based on existing max
                    tableType = new TableType()
                    {
                        TableTypeAbbrv = csi.TableName,
                        TableTypeName = csi.DGName,
                        EdFactsTableTypeId = _appDbContext.TableTypes.Max(m => m.EdFactsTableTypeId) + 1
                    };

                    _appDbContext.TableTypes.Add(tableType);
                    _appDbContext.SaveChanges();
                }

                /////////

                if (csi.FileSpecNum == "190")
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1112;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    return;
                }

                if (csi.FileSpecNum == "196")
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1182;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    return;
                }

                if (csi.IsDatacollEnabledSEA == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

                if (csi.IsDatacollEnabledLEA == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode; // Change after talkig to Team
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 2;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId; // Defaulted to 21. Check with Team.
                    _appDbContext.CategorySets.Add(cs);

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

                if (csi.IsDatacollEnabledSCH == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode; // Change after talkig to Team
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 3;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

            }

            _appDbContext.SaveChanges();

            #endregion


            #region No CSA w EUT.. Insert only EUT

            var qry_noCSFSpecs1 = from d in DSYVrdetail
                                      //where d.CSA is null && d.DEAbbr == "EUT"
                                  where d.CSA is null && dist_listFSswNoCSswEUT.Contains(d.FileSpecNum.ToString()) && d.DEAbbr == "EUT"
                                  select new
                                  {
                                      d.CollectionAbbrv,
                                      d.FileSpecName,
                                      d.FileSpecNum,
                                      d.DEName,
                                      d.IsDatacollEnabledLEA,
                                      d.IsDatacollEnabledSCH,
                                      d.IsDatacollEnabledSEA,
                                      d.TableName,
                                      d.YearAbbrv,
                                      d.YearName,
                                      d.YearValue,
                                      d.DGName,
                                      d.ElectronicFileDesc
                                  };

            var qry_noCSFSpecs_dist1 = qry_noCSFSpecs1.Select(a => new
            {
                a.FileSpecName,
                a.FileSpecNum,
                a.YearValue,
                a.IsDatacollEnabledLEA,
                a.IsDatacollEnabledSCH,
                a.IsDatacollEnabledSEA,
                a.TableName,
                a.DGName,
                a.ElectronicFileDesc
            }).Distinct().ToList();


            foreach (var csi in qry_noCSFSpecs_dist1)
            {

                //var cscode = "CSA";
                //var deName = "Category Set A";
                var cscode = "TOT";
                var deName = "Total of the Education Unit";
                //cscode = cscode.Length > 50 ? csi.DEName.Substring(0, 50-(csi.DEAbbr.Length+2)) + "-" + csi.DEAbbr : cscode;
                var genReportId = repInfo.Where(a => a.ReportCode == csi.FileSpecNum).Select(a => a.GenerateReportId).FirstOrDefault();
                //deName = genReportId == 0 ? deName+" - "+csi.FileSpecNum : deName;
                //cscode = genReportId == 0 ? cscode + " - " + csi.FileSpecNum + "-NOgenReportId" : cscode;
                //genReportId = genReportId == 0 ? 116 : genReportId;


                /////////

                if (genReportId == 0)
                {
                    var generateReport = new GenerateReport()
                    {
                        GenerateReportControlTypeId = 2,
                        GenerateReportTypeId = 3,
                        IsActive = true,
                        ReportCode = csi.FileSpecNum,
                        ReportName = string.Concat(csi.FileSpecNum, ": ", csi.FileSpecName),
                        ReportShortName = csi.FileSpecNum,
                        ReportTypeAbbreviation = csi.ElectronicFileDesc,
                        ShowCategorySetControl = true,
                        ShowData = true,
                        ShowFilterControl = false,
                        ShowGraph = false,
                        ShowSubFilterControl = false,
                        IsLocked = false,
                        UseLegacyReportMigration = true
                    };

                    _appDbContext.GenerateReports.Add(generateReport);
                    _appDbContext.SaveChanges();

                    genReportId = generateReport.GenerateReportId;
                }

                var tableType = tableTypes.FirstOrDefault(tt => tt.TableTypeAbbrv == csi.TableName);

                if (tableType == null)
                {
                    // EdFactsTableTypeId isn't in the JSON package, autoincrementing to next based on existing max
                    tableType = new TableType()
                    {
                        TableTypeAbbrv = csi.TableName,
                        TableTypeName = csi.DGName,
                        EdFactsTableTypeId = _appDbContext.TableTypes.Max(m => m.EdFactsTableTypeId) + 1
                    };

                    _appDbContext.TableTypes.Add(tableType);
                    _appDbContext.SaveChanges();
                }

                /////////

                if (csi.FileSpecNum == "190")
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1112;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    return;
                }

                if (csi.FileSpecNum == "196")
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1182;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    return;
                }

                if (csi.IsDatacollEnabledSEA == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

                if (csi.IsDatacollEnabledLEA == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode; // Change after talkig to Team
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 2;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId; // Defaulted to 21. Check with Team.
                    _appDbContext.CategorySets.Add(cs);

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

                if (csi.IsDatacollEnabledSCH == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode; // Change after talkig to Team
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 3;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

            }

            _appDbContext.SaveChanges();

            #endregion

        }

        public void populateCatInfoData(string collectionAbbrv, string dataSetAbbrv, string versionNum, string fqYrName, List<DataSetYearVersionDetailsByAllAbbrv> DSYVrdetail)
        {

            IQueryable<GenerateReport> genRep = _appDbContext.GenerateReports;
            var repInfo = from x in genRep
                          select new { x.GenerateReportId, x.ReportCode, x.ReportName, x.ReportSequence, x.ReportShortName };

            //string detailUrl = "https://edfacts.ed.gov/generate/DataSetYearVersionDetailsByAllAbbrv?collectionAbbrv={0}&dataSetAbbrv={1}&versionNum={2}&yearAbbrv={3}";
            //detailUrl = string.Format(detailUrl, collectionAbbrv, dataSetAbbrv, versionNum, fqYrName);


            //var client1 = new RestClient(new RestClientOptions(new Uri(detailUrl)));
            //var request1 = new RestRequest("", Method.Get);
            //var response1 = client1.Execute(request1);


            //var cont = response1.Content;
            //cont = cont.Replace("{\"DataSetYearVersionDetails\":", "").Replace("]}", "]");

            //List<DataSetYearVersionDetailsByAllAbbrv> DSYVrdetail = JsonConvert.DeserializeObject<List<DataSetYearVersionDetailsByAllAbbrv>>(cont);

            #region Category Sets w Categories & PVs

            var qry1 = from d in DSYVrdetail
                       where d.CSA != null
                       select new
                       {
                           d.CollectionAbbrv,
                           d.FileSpecName,
                           d.FileSpecNum,
                           d.FileType,
                           d.ElectronicFileDesc,
                           d.DGComment,
                           d.DGDefinition,
                           d.DGEDID,
                           d.DGName,
                           d.DGScopeComment,
                           d.DEAbbr,
                           d.DEMask,
                           d.DEName,
                           d.DEOrderNum,
                           d.DETypeDesc,
                           d.DETypeID,
                           d.DETypeName,
                           d.CategoryAbbr,
                           d.CategoryDefinition,
                           d.CategoryName,
                           d.CategoryOrderNum,
                           d.PVAbbr,
                           d.PVBusinessAbbr,
                           d.PVDescription,
                           d.PVDisplayorder,
                           d.PVName,
                           d.PVTypeAbbr,
                           d.PVTypeDesc,
                           d.IsDatacollEnabledLEA,
                           d.IsDatacollEnabledSCH,
                           d.IsDatacollEnabledSEA,
                           d.TableName,
                           d.YearAbbrv,
                           d.YearName,
                           d.YearValue
                       };


            var qry2 = from d in qry1
                       select new
                       {
                           d.FileSpecName,
                           d.FileSpecNum,
                           d.ElectronicFileDesc,
                           d.DGEDID,
                           d.DGName,
                           d.DEAbbr,
                           d.DEMask,
                           d.DEName,
                           d.DEOrderNum,
                           d.DETypeDesc,
                           d.DETypeID,
                           d.DETypeName,
                           d.CategoryAbbr,
                           d.CategoryDefinition,
                           d.CategoryName,
                           d.CategoryOrderNum,
                           d.IsDatacollEnabledLEA,
                           d.IsDatacollEnabledSCH,
                           d.IsDatacollEnabledSEA,
                           d.YearValue,
                           d.TableName
                       };


            var qry3 = qry2.Distinct().OrderBy(a => a.FileSpecNum).ThenBy(a => a.DGEDID).ThenBy(a => a.DEOrderNum).ThenBy(a => a.CategoryOrderNum).ToList();


            // Insert Cat Set Info into [App].[CategorySets] Table
            var catSetInfo = qry3
                        .Select
                        (
                        a => new {
                            a.FileSpecNum,
                            a.FileSpecName,
                            a.ElectronicFileDesc,
                            a.DEName,
                            a.DEAbbr,
                            a.DEOrderNum,
                            a.YearValue,
                            a.TableName,
                            a.DGName,
                            a.IsDatacollEnabledLEA,
                            a.IsDatacollEnabledSCH,
                            a.IsDatacollEnabledSEA
                        }
                        )
                        .Distinct().ToList();


            var cnt = catSetInfo.Count();


            List<KeyValuePair<string, int>> catSetDBInfo = new List<KeyValuePair<string, int>>();

            var tableTypes = _appDbContext.TableTypes.ToList();

            foreach (var csi in catSetInfo)
            {
                int subtotalNumber = 0;
                var cscode = string.Empty;
                var csName = string.Empty;

                if (csi.DEAbbr == "EUT") // This is a Total category set
                {
                    cscode = "TOT";
                    //csName = "TOTAL OF THE EDUCATION UNIT";
                    csName = "Total of the Education Unit";
                }
                else if (int.TryParse(csi.DEAbbr, out subtotalNumber)) // This is a subtotal category set
                {
                    cscode = string.Concat("ST", subtotalNumber);
                    csName = string.Concat("Subtotal ", subtotalNumber);
                }
                else
                {
                    cscode = string.Concat("CS", csi.DEAbbr); // This is a normal category set
                    csName = string.Concat("Category Set ", csi.DEAbbr);
                }
                //var cscode = csi.DEName + " - " + csi.DEAbbr;
                //cscode = cscode.Length > 50 ? csi.DEName.Substring(0, 50-(csi.DEAbbr.Length+2)) + "-" + csi.DEAbbr : cscode;
                var genReportId = repInfo.Where(a => a.ReportCode == csi.FileSpecNum).Select(a => a.GenerateReportId).FirstOrDefault();
                //cscode = genReportId == 0 ? cscode + " - " + csi.FileSpecNum + "- NOgenReportId" : cscode;
                //genReportId = genReportId == 0 ? 114 : genReportId;

                if (genReportId == 0)
                {
                    var generateReport = new GenerateReport()
                    {
                        GenerateReportControlTypeId = 2,
                        GenerateReportTypeId = 3,
                        IsActive = true,
                        ReportCode = csi.FileSpecNum,
                        ReportName = string.Concat(csi.FileSpecNum, ": ", csi.FileSpecName),
                        ReportShortName = csi.FileSpecNum,
                        ReportTypeAbbreviation = csi.ElectronicFileDesc,
                        ShowCategorySetControl = true,
                        ShowData = true,
                        ShowFilterControl = false,
                        ShowGraph = false,
                        ShowSubFilterControl = false,
                        IsLocked = false,
                        UseLegacyReportMigration = true
                    };

                    _appDbContext.GenerateReports.Add(generateReport);
                    _appDbContext.SaveChanges();

                    genReportId = generateReport.GenerateReportId;
                }

                var tableType = tableTypes.FirstOrDefault(tt => tt.TableTypeAbbrv == csi.TableName);

                if (tableType == null)
                {
                    // EdFactsTableTypeId isn't in the JSON package, autoincrementing to next based on existing max
                    tableType = new TableType()
                    {
                        TableTypeAbbrv = csi.TableName,
                        TableTypeName = csi.DGName,
                        EdFactsTableTypeId = _appDbContext.TableTypes.Max(m => m.EdFactsTableTypeId) + 1
                    };

                    _appDbContext.TableTypes.Add(tableType);
                    _appDbContext.SaveChanges();
                }


                if (csi.IsDatacollEnabledSEA == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = csName;
                    cs.CategorySetSequence = csi.DEOrderNum;
                    cs.OrganizationLevelId = 1;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    cs.GenerateReportId = genReportId;
                    cs.TableTypeId = tableType.TableTypeId;
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;

                    KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    catSetDBInfo.Add(deID);
                }

                if (csi.IsDatacollEnabledLEA == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = csName;
                    cs.CategorySetSequence = csi.DEOrderNum;
                    cs.OrganizationLevelId = 2;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;

                    KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    catSetDBInfo.Add(deID);
                }

                if (csi.IsDatacollEnabledSCH == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = csName;
                    cs.CategorySetSequence = csi.DEOrderNum;
                    cs.OrganizationLevelId = 3;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;

                    KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    catSetDBInfo.Add(deID);
                }

            }

            // Insert Category Info into [App].[Category] Table
            var categoryInfo = qry3.Where(A => A.CategoryName is not null).Select(a => new { a.CategoryAbbr, a.CategoryName, }).Distinct().ToList();
            Dictionary<string, int> catDBInfo = new Dictionary<string, int>();
            foreach (var cat in categoryInfo)
            {

                Category dbCAT = _appDbContext.Categories.Where(a => a.CategoryCode == cat.CategoryAbbr).OrderBy(a => a.CategoryId).FirstOrDefault();

                if (dbCAT != null)
                {
                    catDBInfo.Add(cat.CategoryName, dbCAT.CategoryId);
                }
                else
                {

                    //*Code to Insert New Category
                    //*Commented out as this will be done Manually

                    if (cat.CategoryAbbr is not null)
                    {

                        Category addcat = new Category();
                        addcat.CategoryName = cat.CategoryName;
                        addcat.CategoryCode = cat.CategoryAbbr;
                        addcat.EdFactsCategoryId = 0;
                        _appDbContext.Categories.Add(addcat);
                        _appDbContext.SaveChanges();
                        Int32 id = addcat.CategoryId;

                        catDBInfo.Add(cat.CategoryName, id);

                        newCatInfo.Add(cat.CategoryName, cat.CategoryAbbr);
                    }

                }

            }

            var catSet_cat = qry2.Where(A => A.CategoryName is not null).Select(a => new { a.DEName, a.CategoryName }).Distinct().ToList();
            //var catOpt = qry1.Select(a => new { a.CategoryName, a.PVName, a.PVAbbr, a.PVBusinessAbbr, a.PVDescription, a.PVDisplayorder,  a.PVTypeAbbr, a.PVTypeDesc }).Distinct().ToList();
            var catOpt = qry1.Select(a => new { a.CategoryName, a.PVName, a.PVAbbr, a.PVBusinessAbbr, a.PVDescription, a.PVDisplayorder }).Distinct().ToList();


            string CatName = string.Empty;

            foreach (var cat in catSet_cat)
            {

                var pvList = from x in catOpt
                             where x.CategoryName == cat.CategoryName
                             select x;

                int catID = catDBInfo.Where(a => a.Key == cat.CategoryName).Select(b => b.Value).FirstOrDefault();
                if (catID == 0) { continue; }

                IEnumerable<int> csID = catSetDBInfo.Where(a => a.Key == cat.DEName).Select(b => b.Value);

                foreach (var cs_id in csID)
                {

                    CategorySet_Category csc = new CategorySet_Category();
                    csc.CategorySetId = cs_id;
                    csc.CategoryId = catID;
                    _appDbContext.CategorySet_Categories.Add(csc);
                    _appDbContext.SaveChanges();

                    foreach (var pv in pvList)
                    {

                        CategoryOption _catOpt = new CategoryOption();
                        _catOpt.CategoryId = catID;
                        _catOpt.CategorySetId = cs_id;
                        _catOpt.CategoryOptionCode = pv.PVBusinessAbbr;
                        _catOpt.CategoryOptionName = pv.PVName;
                        _catOpt.CategoryOptionSequence = pv.PVDisplayorder;
                        _appDbContext.CategoryOptions.Add(_catOpt);
                        _appDbContext.SaveChanges();
                        Int32 id = _catOpt.CategoryId;

                    }

                }

            }

            #endregion


            #region NO CSA w NO EUT

            /*
                ******************************************
                ***   FSs which have NO CATEGORY SETS & NO EUT ***
                ******************************************
            */

            var listFSswNoCSswEUT = from d in DSYVrdetail
                                    where d.CSA is null && d.DEAbbr == "EUT"
                                    select new
                                    {
                                        d.FileSpecNum
                                    };

            var dist_listFSswNoCSswEUT = listFSswNoCSswEUT.Distinct().Select(a => a.FileSpecNum).ToList<string>();

            var qry_noCSFSpecs = from d in DSYVrdetail
                                     //where d.CSA is null && d.DEAbbr != "EUT"
                                 where d.CSA is null && !dist_listFSswNoCSswEUT.Contains(d.FileSpecNum.ToString())
                                 select new
                                 {
                                     d.CollectionAbbrv,
                                     d.FileSpecName,
                                     d.FileSpecNum,
                                     d.DEName,
                                     d.IsDatacollEnabledLEA,
                                     d.IsDatacollEnabledSCH,
                                     d.IsDatacollEnabledSEA,
                                     d.TableName,
                                     d.YearAbbrv,
                                     d.YearName,
                                     d.YearValue,
                                     d.DGName,
                                     d.ElectronicFileDesc
                                 };

            var qry_noCSFSpecs_dist = qry_noCSFSpecs.Select(a => new
            {
                a.FileSpecName,
                a.FileSpecNum,
                a.YearValue,
                a.IsDatacollEnabledLEA,
                a.IsDatacollEnabledSCH,
                a.IsDatacollEnabledSEA,
                //a.TableName,
                //a.DGName,
                a.ElectronicFileDesc
            }).Distinct().ToList();


            foreach (var csi in qry_noCSFSpecs_dist)
            {

                var cscode = "CSA";
                var deName = "Category Set A";
                //cscode = cscode.Length > 50 ? csi.DEName.Substring(0, 50-(csi.DEAbbr.Length+2)) + "-" + csi.DEAbbr : cscode;
                var genReportId = repInfo.Where(a => a.ReportCode == csi.FileSpecNum).Select(a => a.GenerateReportId).FirstOrDefault();
                //deName = genReportId == 0 ? deName+" - "+csi.FileSpecNum : deName;
                //cscode = genReportId == 0 ? cscode + " - " + csi.FileSpecNum + "-NOgenReportId" : cscode;
                //genReportId = genReportId == 0 ? 116 : genReportId;


                /////////

                if (genReportId == 0)
                {
                    var generateReport = new GenerateReport()
                    {
                        GenerateReportControlTypeId = 2,
                        GenerateReportTypeId = 3,
                        IsActive = true,
                        ReportCode = csi.FileSpecNum,
                        ReportName = string.Concat(csi.FileSpecNum, ": ", csi.FileSpecName),
                        ReportShortName = csi.FileSpecNum,
                        ReportTypeAbbreviation = csi.ElectronicFileDesc,
                        ShowCategorySetControl = true,
                        ShowData = true,
                        ShowFilterControl = false,
                        ShowGraph = false,
                        ShowSubFilterControl = false,
                        IsLocked = false,
                        UseLegacyReportMigration = true
                    };

                    _appDbContext.GenerateReports.Add(generateReport);
                    _appDbContext.SaveChanges();

                    genReportId = generateReport.GenerateReportId;
                }

                /*
                 * 
                var tableType = tableTypes.FirstOrDefault(tt => tt.TableTypeAbbrv == csi.TableName);

                if (tableType == null)
                {
                    // EdFactsTableTypeId isn't in the JSON package, autoincrementing to next based on existing max
                    tableType = new TableType()
                    {
                        TableTypeAbbrv = csi.TableName,
                        TableTypeName = csi.DGName,
                        EdFactsTableTypeId = _appDbContext.TableTypes.Max(m => m.EdFactsTableTypeId) + 1
                    };

                    _appDbContext.TableTypes.Add(tableType);
                    _appDbContext.SaveChanges();
                }

                */

                /////////

                if (csi.FileSpecNum == "190")
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1112;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;
                    continue;
                }

                if (csi.FileSpecNum == "196")
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1182;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;
                    continue;
                }

                if (csi.IsDatacollEnabledSEA == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

                if (csi.IsDatacollEnabledLEA == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode; // Change after talkig to Team
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 2;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId; // Defaulted to 21. Check with Team.
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

                if (csi.IsDatacollEnabledSCH == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode; // Change after talkig to Team
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 3;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

            }

            #endregion


            #region NO CSA w EUT.. Insert only CSA info


            var qry_noCSFSpecs0 = from d in DSYVrdetail
                                      //where d.CSA is null && d.DEAbbr != "EUT"
                                  where d.CSA is null && dist_listFSswNoCSswEUT.Contains(d.FileSpecNum.ToString()) && d.DEAbbr != "EUT"
                                  select new
                                  {
                                      d.CollectionAbbrv,
                                      d.FileSpecName,
                                      d.FileSpecNum,
                                      d.DEName,
                                      d.IsDatacollEnabledLEA,
                                      d.IsDatacollEnabledSCH,
                                      d.IsDatacollEnabledSEA,
                                      d.TableName,
                                      d.YearAbbrv,
                                      d.YearName,
                                      d.YearValue,
                                      d.DGName,
                                      d.ElectronicFileDesc
                                  };

            var qry_noCSFSpecs_dist0 = qry_noCSFSpecs0.Select(a => new
            {
                a.FileSpecName,
                a.FileSpecNum,
                a.YearValue,
                a.IsDatacollEnabledLEA,
                a.IsDatacollEnabledSCH,
                a.IsDatacollEnabledSEA,
                a.TableName,
                a.DGName,
                a.ElectronicFileDesc
            }).Distinct().ToList();


            foreach (var csi in qry_noCSFSpecs_dist0)
            {

                var cscode = "CSA";
                var deName = "Category Set A";
                //cscode = cscode.Length > 50 ? csi.DEName.Substring(0, 50-(csi.DEAbbr.Length+2)) + "-" + csi.DEAbbr : cscode;
                var genReportId = repInfo.Where(a => a.ReportCode == csi.FileSpecNum).Select(a => a.GenerateReportId).FirstOrDefault();
                //deName = genReportId == 0 ? deName+" - "+csi.FileSpecNum : deName;
                //cscode = genReportId == 0 ? cscode + " - " + csi.FileSpecNum + "-NOgenReportId" : cscode;
                //genReportId = genReportId == 0 ? 116 : genReportId;


                /////////

                if (genReportId == 0)
                {
                    var generateReport = new GenerateReport()
                    {
                        GenerateReportControlTypeId = 2,
                        GenerateReportTypeId = 3,
                        IsActive = true,
                        ReportCode = csi.FileSpecNum,
                        ReportName = string.Concat(csi.FileSpecNum, ": ", csi.FileSpecName),
                        ReportShortName = csi.FileSpecNum,
                        ReportTypeAbbreviation = csi.ElectronicFileDesc,
                        ShowCategorySetControl = true,
                        ShowData = true,
                        ShowFilterControl = false,
                        ShowGraph = false,
                        ShowSubFilterControl = false,
                        IsLocked = false,
                        UseLegacyReportMigration = true
                    };

                    _appDbContext.GenerateReports.Add(generateReport);
                    _appDbContext.SaveChanges();

                    genReportId = generateReport.GenerateReportId;
                }

                var tableType = tableTypes.FirstOrDefault(tt => tt.TableTypeAbbrv == csi.TableName);

                if (tableType == null)
                {
                    // EdFactsTableTypeId isn't in the JSON package, autoincrementing to next based on existing max
                    tableType = new TableType()
                    {
                        TableTypeAbbrv = csi.TableName,
                        TableTypeName = csi.DGName,
                        EdFactsTableTypeId = _appDbContext.TableTypes.Max(m => m.EdFactsTableTypeId) + 1
                    };

                    _appDbContext.TableTypes.Add(tableType);
                    _appDbContext.SaveChanges();
                }

                /////////

                if (csi.FileSpecNum == "190")
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1112;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;
                    continue;
                }

                if (csi.FileSpecNum == "196")
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1182;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;
                    continue;
                }

                if (csi.IsDatacollEnabledSEA == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

                if (csi.IsDatacollEnabledLEA == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode; // Change after talkig to Team
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 2;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId; // Defaulted to 21. Check with Team.
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

                if (csi.IsDatacollEnabledSCH == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode; // Change after talkig to Team
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 3;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    //cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

            }


            #endregion


            #region No CSA w EUT.. Insert only EUT

            var qry_noCSFSpecs1 = from d in DSYVrdetail
                                      //where d.CSA is null && d.DEAbbr == "EUT"
                                  where d.CSA is null && dist_listFSswNoCSswEUT.Contains(d.FileSpecNum.ToString()) && d.DEAbbr == "EUT"
                                  select new
                                  {
                                      d.CollectionAbbrv,
                                      d.FileSpecName,
                                      d.FileSpecNum,
                                      d.DEName,
                                      d.IsDatacollEnabledLEA,
                                      d.IsDatacollEnabledSCH,
                                      d.IsDatacollEnabledSEA,
                                      d.TableName,
                                      d.YearAbbrv,
                                      d.YearName,
                                      d.YearValue,
                                      d.DGName,
                                      d.ElectronicFileDesc
                                  };

            var qry_noCSFSpecs_dist1 = qry_noCSFSpecs1.Select(a => new
            {
                a.FileSpecName,
                a.FileSpecNum,
                a.YearValue,
                a.IsDatacollEnabledLEA,
                a.IsDatacollEnabledSCH,
                a.IsDatacollEnabledSEA,
                a.TableName,
                a.DGName,
                a.ElectronicFileDesc
            }).Distinct().ToList();


            foreach (var csi in qry_noCSFSpecs_dist1)
            {

                //var cscode = "CSA";
                //var deName = "Category Set A";
                var cscode = "TOT";
                var deName = "Total of the Education Unit";
                //cscode = cscode.Length > 50 ? csi.DEName.Substring(0, 50-(csi.DEAbbr.Length+2)) + "-" + csi.DEAbbr : cscode;
                var genReportId = repInfo.Where(a => a.ReportCode == csi.FileSpecNum).Select(a => a.GenerateReportId).FirstOrDefault();
                //deName = genReportId == 0 ? deName+" - "+csi.FileSpecNum : deName;
                //cscode = genReportId == 0 ? cscode + " - " + csi.FileSpecNum + "-NOgenReportId" : cscode;
                //genReportId = genReportId == 0 ? 116 : genReportId;


                /////////

                if (genReportId == 0)
                {
                    var generateReport = new GenerateReport()
                    {
                        GenerateReportControlTypeId = 2,
                        GenerateReportTypeId = 3,
                        IsActive = true,
                        ReportCode = csi.FileSpecNum,
                        ReportName = string.Concat(csi.FileSpecNum, ": ", csi.FileSpecName),
                        ReportShortName = csi.FileSpecNum,
                        ReportTypeAbbreviation = csi.ElectronicFileDesc,
                        ShowCategorySetControl = true,
                        ShowData = true,
                        ShowFilterControl = false,
                        ShowGraph = false,
                        ShowSubFilterControl = false,
                        IsLocked = false,
                        UseLegacyReportMigration = true
                    };

                    _appDbContext.GenerateReports.Add(generateReport);
                    _appDbContext.SaveChanges();

                    genReportId = generateReport.GenerateReportId;
                }

                var tableType = tableTypes.FirstOrDefault(tt => tt.TableTypeAbbrv == csi.TableName);

                if (tableType == null)
                {
                    // EdFactsTableTypeId isn't in the JSON package, autoincrementing to next based on existing max
                    tableType = new TableType()
                    {
                        TableTypeAbbrv = csi.TableName,
                        TableTypeName = csi.DGName,
                        EdFactsTableTypeId = _appDbContext.TableTypes.Max(m => m.EdFactsTableTypeId) + 1
                    };

                    _appDbContext.TableTypes.Add(tableType);
                    _appDbContext.SaveChanges();
                }

                /////////

                if (csi.FileSpecNum == "190")
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1112;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;
                    continue;
                }

                if (csi.FileSpecNum == "196")
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1182;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;
                    continue;
                }

                if (csi.IsDatacollEnabledSEA == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode;
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 1;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

                if (csi.IsDatacollEnabledLEA == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode; // Change after talkig to Team
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 2;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId; // Defaulted to 21. Check with Team.
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

                if (csi.IsDatacollEnabledSCH == 1)
                {
                    CategorySet cs = new CategorySet();
                    cs.CategorySetCode = cscode; // Change after talkig to Team
                    cs.CategorySetName = deName;
                    cs.CategorySetSequence = null;
                    cs.OrganizationLevelId = 3;
                    cs.SubmissionYear = csi.YearValue.ToString();
                    cs.TableTypeId = tableType.TableTypeId;
                    cs.GenerateReportId = genReportId;
                    _appDbContext.CategorySets.Add(cs);
                    _appDbContext.SaveChanges();
                    Int32 id = cs.CategorySetId;

                    //KeyValuePair<string, int> deID = new KeyValuePair<string, int>(csi.DEName, id);
                    //catSetDBInfo.Add(deID);
                    ////catSetDBInfo.Add(csi.DEName, id);
                }

            }

            #endregion

        }

        public void DelandPopulateFSLayoutdata(string collectionAbbrv, string dataSetAbbrv, string versionNum, string fqYrName)
        {

            var edfacts1 = string.Empty;
            if (_useWSforFSMetaUpd)
            {

                //_fsLayoutURL = "https://edfacts.ed.gov/generate/DataSetYearVersionFSLayoutDetailsByAllAbbrv"; // Remove later
                string fsLayoutURL = _fsWSURL + layoutSubdir + "?collectionAbbrv={0}&dataSetAbbrv={1}&versionNum={2}&yearAbbrv={3}";
                fsLayoutURL = string.Format(fsLayoutURL, collectionAbbrv, dataSetAbbrv, versionNum.ToString(), fqYrName);

                //fsLayoutURL = "https://edfacts.ed.gov/generate/DataSetYearVersionFSLayoutDetailsByAllAbbrv?collectionAbbrv=EDFACTS&dataSetAbbrv=ESS&versionNum=13&yearAbbrv=2022-2023";
                //fqYrName = "2022";

                var client1 = new RestClient(new RestClientOptions(new Uri(fsLayoutURL)));
                var request1 = new RestRequest("", Method.Get);
                var response1 = client1.Execute(request1);

                edfacts1 = response1.Content;
                edfacts1 = edfacts1.Replace("{\"DataSetYearVersionFSLayoutDetails\":", "").Replace("]}", "]");

            }
            else
            {

                var filename = dataSetAbbrv == "ESS" ? _fsMetaESSLayoutFileName : dataSetAbbrv == "CHRTR" ? _fsMetaCHRLayoutFileName : "";
                var fileloc = _fsMetaFileLoc + "\\" + filename; //_fsMetaCHRDetailFileName;

                using (StreamReader r = new StreamReader(fileloc))
                {
                    edfacts1 = r.ReadToEnd();
                    edfacts1 = edfacts1.Replace("{\"DataSetYearVersionFSLayoutDetails\":", "").Replace("]}", "]");
                }

            }

            List<DataSetYearVersionFSLayoutDetailsByAllAbbrv> DSYVrFSLay = JsonConvert.DeserializeObject<List<DataSetYearVersionFSLayoutDetailsByAllAbbrv>>(edfacts1);


            /* ****** Basic Year Check ****** */
            string fsLayYear = DSYVrFSLay.Select(a => a.YearName.Replace("SY ", "").Substring(0, 4)).FirstOrDefault();
            if (fsLayYear != fqYrName.Substring(0, 4))
            {
                var err = " FSLayout Year does not match FS Metadata Year for {0} DataSet. FSLayoutYear : {1} ; FSMetaYear : {2} .";
                err = string.Format(err, dataSetAbbrv, fsLayYear, fqYrName.Substring(0, 4));
                throw new Exception(err);
            }

            // delete FS data in specific Year
            DeleteFSLayoutInfo(fqYrName.Substring(0, 4), DSYVrFSLay);
            populateFSLayout(DSYVrFSLay);
            // Populate FS data in specific Year

            if (dataSetAbbrv == "ESS") { bkESSFLay = edfacts1; }
            else if (dataSetAbbrv == "CHRTR") { bkCHRFLay = edfacts1; }

        }

        public void DeleteFSLayoutInfo(string year1, List<DataSetYearVersionFSLayoutDetailsByAllAbbrv> DSYVrFSLay)
        {

            //DSYVrFSLay = JsonConvert.DeserializeObject<List<DataSetYearVersionFSLayoutDetailsByAllAbbrv>>(edfacts);

            var FSNum = from a in DSYVrFSLay
                        select a.FileSpecNum;

            var distFSNum = FSNum.Distinct().ToList();

            IQueryable<GenerateReport> genRep = _appDbContext.GenerateReports;
            var repInfo = from x in genRep
                          where distFSNum.Contains(x.ReportCode.Replace("c", ""))
                          select new { x.GenerateReportId, x.ReportCode, x.ReportName, x.ReportSequence, x.ReportShortName };

            List<int> genid = repInfo.Select(a => a.GenerateReportId).Distinct().ToList();

            IQueryable<FileSubmission> fileSubmisson = _appDbContext.FileSubmissions
                                                        //.Where(cs => cs.SubmissionYear == fqYrName && genid.Contains((int)cs.GenerateReportId))
                                                        .Include(x => x.FileSubmission_FileColumns)
                                                        .Include("FileSubmission_FileColumns.FileColumn");


            /*fs layout tables data in current year & FSs in current returned DS*/
            var allfsinCYr = from fs in fileSubmisson
                             where fs.SubmissionYear == year1 && genid.Contains((int)(fs.GenerateReportId))
                             select fs;

            var _fsfc = from fs in allfsinCYr
                        from a in fs.FileSubmission_FileColumns
                        select new { a.FileSubmissionId, a.FileColumnId };

            /*all filecolumnsIDs in current year */
            var fcIDsinCYr = _fsfc.Select(a => a.FileColumnId).Distinct().ToList();

            List<FileColumn> delListFileCol = new List<FileColumn>();
            List<FileSubmission_FileColumn> delListFsFc = new List<FileSubmission_FileColumn>();

            foreach (var currfcID in fcIDsinCYr)
            {
                /*check if currfcID in used in diff FS in CYR*/
                var a = from fs in fileSubmisson
                        where fs.SubmissionYear == year1 && !genid.Contains((int)(fs.GenerateReportId))
                        from fsfc in fs.FileSubmission_FileColumns
                        where fsfc.FileColumnId == currfcID //&& fs.FileSubmission_FileColumns.Where(a => a.FileColumnId.Equals(1))
                        select new { SY = fs.SubmissionYear, FCID = fsfc.FileColumnId };

                var b = from x in a
                        where x.FCID.Equals(currfcID)
                        select x;

                /* check if currfcID is in other years than CYR */
                var c = from fs in fileSubmisson
                        where fs.SubmissionYear != year1 //&& !genid.Contains((int)(fs.GenerateReportId))
                        from fsfc in fs.FileSubmission_FileColumns
                        where fsfc.FileColumnId == currfcID //&& fs.FileSubmission_FileColumns.Where(a => a.FileColumnId.Equals(1))
                        select new { SY = fs.SubmissionYear, FCID = fsfc.FileColumnId };

                var d = from x in c
                        where x.FCID.Equals(currfcID)
                        select x;

                var fcidinCurrYr = b.Count();
                var fcidinOthYr = d.Count();

                if (fcidinCurrYr > 0 || fcidinOthYr > 0)
                {
                    /* Only delete FileSubmission_FileColumns data used in CYR and in DataSet FSs */
                    var __fsID = _fsfc.Where(a => a.FileColumnId == Convert.ToInt32(currfcID)).Select(a => a.FileSubmissionId);

                    foreach (var item in __fsID)
                    {
                        IQueryable<FileSubmission_FileColumn> fsfc = _appDbContext.FileSubmission_FileColumns.Where(a => a.FileSubmissionId == item && a.FileColumnId == currfcID);
                        foreach (var item1 in fsfc)
                        {
                            delListFsFc.Add(item1);
                        }
                    }

                }
                else
                {
                    /* delete FileSubmission_FileColumns & FileColumns*/

                    /* delete FileSubmission_FileColumns*/
                    var __fsID = _fsfc.Where(a => a.FileColumnId == Convert.ToInt32(currfcID)).Select(a => a.FileSubmissionId);
                    foreach (var item in __fsID)
                    {
                        IQueryable<FileSubmission_FileColumn> fsfc = _appDbContext.FileSubmission_FileColumns.Where(a => a.FileSubmissionId == item && a.FileColumnId == currfcID);
                        foreach (var item1 in fsfc)
                        {
                            delListFsFc.Add(item1);
                        }
                    }

                    /* delete FileColumns*/

                    IQueryable<FileColumn> FileCol = _appDbContext.FileColumns.Where(a => a.FileColumnId == Convert.ToInt32(currfcID));//.Where(a => a.FileColumnId == currfcID);
                    foreach (var _fc in FileCol)
                    {
                        delListFileCol.Add(_fc);
                    }

                }

            }


            if (delListFsFc.Count() > 0)
            {
                _appDbContext.FileSubmission_FileColumns.RemoveRange(delListFsFc);
                _appDbContext.SaveChanges();
            }

            if (delListFileCol.Count() > 0)
            {
                _appDbContext.FileColumns.RemoveRange(delListFileCol);
                _appDbContext.SaveChanges();
            }

            _appDbContext.FileSubmissions.RemoveRange(allfsinCYr);
            _appDbContext.SaveChanges();

        }

        public void populateFSLayout(List<DataSetYearVersionFSLayoutDetailsByAllAbbrv> DSYVrFSLay)
        {

            var fsLay = DSYVrFSLay.Select(a => new {
                a.IsDatacollEnabledLEA,
                a.IsDatacollEnabledSCH,
                a.IsDatacollEnabledSEA,
                a.FileSpecNum,
                a.FileType,
                a.EULevelAbbr,
                a.YearName,
                a.ColLen,
                a.ColName,
                a.ColDataTypeAbbr,
                a.ColDisplayName,
                a.ColTypeAbbr,
                a.ColEndPos,
                a.ColOptionalityAbbr,
                a.ColSeqNum,
                a.ColStartPos
            });

            var distFS = DSYVrFSLay.OrderBy(x => x.FileSpecNum).Select(a => a.FileSpecNum).Distinct().ToList();//.Take(10);
            var year = DSYVrFSLay.Select(a => new { Year = a.YearName.Replace("SY ", "").Substring(0, 4) }).FirstOrDefault();

            IQueryable<GenerateReport> genRep = _appDbContext.GenerateReports;

            OrganizationLevel sea = _appRepository.Find<OrganizationLevel>(f => f.LevelCode == "SEA").FirstOrDefault();
            OrganizationLevel lea = _appRepository.Find<OrganizationLevel>(f => f.LevelCode == "LEA").FirstOrDefault();
            OrganizationLevel sch = _appRepository.Find<OrganizationLevel>(f => f.LevelCode == "SCH").FirstOrDefault();
            OrganizationLevel cao = _appRepository.Find<OrganizationLevel>(f => f.LevelCode == "CAO").FirstOrDefault();
            OrganizationLevel cmo = _appRepository.Find<OrganizationLevel>(f => f.LevelCode == "CMO").FirstOrDefault();

            IQueryable<FileColumn> fileCol = _appDbContext.FileColumns;

            foreach (var fs in distFS)
            {

                var genid = genRep.Where(a => a.ReportCode == fs).Select(a => a.GenerateReportId).FirstOrDefault();
                var euLevel = fsLay.Where(a => a.FileSpecNum == fs).Select(a => new { a.IsDatacollEnabledLEA, a.IsDatacollEnabledSEA, a.IsDatacollEnabledSCH, a.FileType }).FirstOrDefault();

                FileSubmission _fs;
                int fs_seaid;
                int fs_leaid;
                int fs_schid;

                #region SEA

                if (euLevel.IsDatacollEnabledSEA == 1)
                {
                    _fs = new FileSubmission();
                    //_fs.OrganizationLevel = sea;
                    _fs.OrganizationLevel = (fs == "190" ? cao : fs == "196" ? cmo : sea);
                    _fs.SubmissionYear = year.Year.ToString();
                    _fs.GenerateReportId = genid;
                    _fs.FileSubmissionDescription = "SEA " + euLevel.FileType;
                    _appDbContext.FileSubmissions.Add(_fs);
                    _appDbContext.SaveChanges();
                    fs_seaid = _fs.FileSubmissionId;

                    var fsLaySEA = fsLay.Where(a => a.FileSpecNum == fs && a.EULevelAbbr == "STA" && a.ColTypeAbbr != "HDR")  //HDR = HEADER
                        .Select(x => new
                        {
                            x.ColLen,
                            x.ColName,
                            x.ColDataTypeAbbr,
                            x.ColDisplayName,
                            x.ColEndPos,
                            x.ColOptionalityAbbr,
                            x.ColSeqNum,
                            x.ColStartPos
                        }).OrderBy(a => a.ColSeqNum);

                    int i = 0;
                    foreach (var item in fsLaySEA)
                    {

                        // check if file col exists

                        int filecolid = fileCol.
                        Where(a => a.ColumnLength == item.ColLen && a.ColumnName == item.ColName
                        && a.DataType == (item.ColDataTypeAbbr == "Decimal - 2 places" ? "Decimal2" : item.ColDataTypeAbbr)
                        && a.DisplayName == (string.IsNullOrEmpty(item.ColDisplayName) ? "" : item.ColDisplayName)
                        ).OrderBy(a => a.FileColumnId).
                        Select(a => a.FileColumnId).FirstOrDefault();

                        if (filecolid == 0)
                        {

                            FileColumn _fc = new FileColumn();
                            _fc.ColumnLength = (int)item.ColLen;
                            _fc.ColumnName = item.ColName;
                            _fc.DataType = item.ColDataTypeAbbr == "Decimal - 2 places" ? "Decimal2" : item.ColDataTypeAbbr;
                            _fc.DisplayName = item.ColDisplayName;
                            // _fc.DimensionId =

                            _appDbContext.FileColumns.Add(_fc);
                            _appDbContext.SaveChanges();
                            filecolid = _fc.FileColumnId;

                        }

                        FileSubmission_FileColumn fsfc = new FileSubmission_FileColumn();
                        fsfc.FileSubmissionId = fs_seaid;
                        fsfc.FileColumnId = filecolid;
                        fsfc.EndPosition = (int)item.ColEndPos;
                        fsfc.IsOptional = item.ColOptionalityAbbr == "M" ? true : false;
                        fsfc.SequenceNumber = (int)item.ColSeqNum;
                        fsfc.StartPosition = (int)item.ColStartPos;

                        _appDbContext.FileSubmission_FileColumns.Add(fsfc);
                        _appDbContext.SaveChanges();
                        //filecolid = fsfc.FileColumnId;
                        i++;
                    }

                }

                #endregion

                #region LEA

                if (euLevel.IsDatacollEnabledLEA == 1)
                {
                    _fs = new FileSubmission();
                    _fs.OrganizationLevel = lea;
                    _fs.SubmissionYear = year.Year.ToString();
                    _fs.GenerateReportId = genid;
                    _fs.FileSubmissionDescription = "LEA " + euLevel.FileType;
                    _appDbContext.FileSubmissions.Add(_fs);
                    _appDbContext.SaveChanges();
                    fs_leaid = _fs.FileSubmissionId;


                    var fsLayLEA = fsLay.Where(a => a.FileSpecNum == fs && a.EULevelAbbr == "LEA" && a.ColTypeAbbr != "HDR")
                    .Select(x => new
                    {
                        x.ColLen,
                        x.ColName,
                        x.ColDataTypeAbbr,
                        x.ColDisplayName,
                        x.ColEndPos,
                        x.ColOptionalityAbbr,
                        x.ColSeqNum,
                        x.ColStartPos
                    }).OrderBy(a => a.ColSeqNum);


                    foreach (var item in fsLayLEA)
                    {

                        // check if file col exists

                        int filecolid = fileCol.
                        Where(a => a.ColumnLength == item.ColLen && a.ColumnName == item.ColName
                        && a.DataType == (item.ColDataTypeAbbr == "Decimal - 2 places" ? "Decimal2" : item.ColDataTypeAbbr)
                        && a.DisplayName == (string.IsNullOrEmpty(item.ColDisplayName) ? "" : item.ColDisplayName)
                        ).OrderBy(a => a.FileColumnId).
                        Select(a => a.FileColumnId).FirstOrDefault();

                        if (filecolid == 0)
                        {

                            FileColumn _fc = new FileColumn();
                            _fc.ColumnLength = (int)item.ColLen;
                            _fc.ColumnName = item.ColName;
                            _fc.DataType = item.ColDataTypeAbbr == "Decimal - 2 places" ? "Decimal2" : item.ColDataTypeAbbr;
                            _fc.DisplayName = item.ColDisplayName;
                            // _fc.DimensionId =

                            _appDbContext.FileColumns.Add(_fc);
                            _appDbContext.SaveChanges();
                            filecolid = _fc.FileColumnId;

                        }

                        FileSubmission_FileColumn fsfc = new FileSubmission_FileColumn();
                        fsfc.FileSubmissionId = fs_leaid;
                        fsfc.FileColumnId = filecolid;
                        fsfc.EndPosition = (int)item.ColEndPos;
                        fsfc.IsOptional = item.ColOptionalityAbbr == "M" ? true : false;
                        fsfc.SequenceNumber = (int)item.ColSeqNum;
                        fsfc.StartPosition = (int)item.ColStartPos;


                        _appDbContext.FileSubmission_FileColumns.Add(fsfc);
                        _appDbContext.SaveChanges();
                        //filecolid = fsfc.FileColumnId;


                    }

                }

                #endregion

                #region SCH

                if (euLevel.IsDatacollEnabledSCH == 1)
                {
                    _fs = new FileSubmission();
                    _fs.OrganizationLevel = sch;
                    _fs.SubmissionYear = year.Year.ToString();
                    _fs.GenerateReportId = genid;
                    _fs.FileSubmissionDescription = "SCHOOL " + euLevel.FileType;
                    _appDbContext.FileSubmissions.Add(_fs);
                    _appDbContext.SaveChanges();
                    fs_schid = _fs.FileSubmissionId;

                    var fsLaySCH = fsLay.Where(a => a.FileSpecNum == fs && a.EULevelAbbr == "SCH" && a.ColTypeAbbr != "HDR")
                    .Select(x => new
                    {
                        x.ColLen,
                        x.ColName,
                        x.ColDataTypeAbbr,
                        x.ColDisplayName,
                        x.ColEndPos,
                        x.ColOptionalityAbbr,
                        x.ColSeqNum,
                        x.ColStartPos
                    }).OrderBy(a => a.ColSeqNum);


                    foreach (var item in fsLaySCH)
                    {

                        // check if file col exists

                        int filecolid = fileCol.
                        Where(a => a.ColumnLength == item.ColLen && a.ColumnName == item.ColName
                        && a.DataType == (item.ColDataTypeAbbr == "Decimal - 2 places" ? "Decimal2" : item.ColDataTypeAbbr)
                        && a.DisplayName == (string.IsNullOrEmpty(item.ColDisplayName) ? "" : item.ColDisplayName)
                        ).OrderBy(a => a.FileColumnId).
                        Select(a => a.FileColumnId).FirstOrDefault();

                        if (filecolid == 0)
                        {

                            FileColumn _fc = new FileColumn();
                            _fc.ColumnLength = (int)item.ColLen;
                            _fc.ColumnName = item.ColName;
                            _fc.DataType = item.ColDataTypeAbbr == "Decimal - 2 places" ? "Decimal2" : item.ColDataTypeAbbr;
                            _fc.DisplayName = item.ColDisplayName;
                            // _fc.DimensionId =

                            _appDbContext.FileColumns.Add(_fc);
                            _appDbContext.SaveChanges();
                            filecolid = _fc.FileColumnId;

                        }

                        FileSubmission_FileColumn fsfc = new FileSubmission_FileColumn();
                        fsfc.FileSubmissionId = fs_schid;
                        fsfc.FileColumnId = filecolid;
                        fsfc.EndPosition = (int)item.ColEndPos;
                        fsfc.IsOptional = item.ColOptionalityAbbr == "M" ? true : false;
                        fsfc.SequenceNumber = (int)item.ColSeqNum;
                        fsfc.StartPosition = (int)item.ColStartPos;

                        _appDbContext.FileSubmission_FileColumns.Add(fsfc);
                        _appDbContext.SaveChanges();
                        //filecolid = fsfc.FileColumnId;

                    }

                }

                #endregion

            }

        }

        public bool checkPrevPopFSMetaYrandVers(bool IsESSDS, string year, int vers)
        {

            IQueryable<GenerateConfiguration> gc = _appDbContext.GenerateConfigurations
                                                   .Where(gc => gc.GenerateConfigurationCategory == configurationCategory);

            if (gc is null || gc.Count() == 0)
            {
                return true; //continue;
            }
            else if (IsESSDS)
            {
                string genConfigVal = gc.Where(a => a.GenerateConfigurationKey == essKey).Select(a => a.GenerateConfigurationValue).FirstOrDefault();

                if (string.IsNullOrEmpty(genConfigVal))
                {
                    return true;
                }
                else
                {
                    var arrConfigVal = genConfigVal.ToString().Split(splitKey);
                    if (arrConfigVal.Length > 0 && arrConfigVal[0] == year && Convert.ToInt32(arrConfigVal[1]) == vers)
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    }
                }
            }
            else
            {

                string genConfigVal = gc.Where(a => a.GenerateConfigurationKey == chrKey).Select(a => a.GenerateConfigurationValue).FirstOrDefault();

                if (string.IsNullOrEmpty(genConfigVal))
                {
                    return true;
                }
                else
                {
                    var arrConfigVal = genConfigVal.ToString().Split(splitKey);
                    if (arrConfigVal.Length > 0 && arrConfigVal[0] == year && Convert.ToInt32(arrConfigVal[1]) == vers)
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    }
                }

            }
        }

        public void UpdPopFSMetaYrandVersinGenConfig(bool IsESSDS, string year, int vers)
        {

            IQueryable<GenerateConfiguration> gc = _appDbContext.GenerateConfigurations
                                                   .Where(q => q.GenerateConfigurationCategory == configurationCategory && q.GenerateConfigurationKey == (IsESSDS ? essKey : chrKey));

            if (gc is null || gc.Count() == 0)
            {
                GenerateConfiguration _gc = new GenerateConfiguration();
                _gc.GenerateConfigurationCategory = configurationCategory;
                _gc.GenerateConfigurationKey = IsESSDS ? essKey : chrKey;
                _gc.GenerateConfigurationValue = year + splitKey + vers;
                _appDbContext.GenerateConfigurations.Add(_gc);
                _appDbContext.SaveChanges();
            }
            else
            {
                GenerateConfiguration _gc = (GenerateConfiguration)gc.Where(a => a.GenerateConfigurationKey == (IsESSDS ? essKey : chrKey)).FirstOrDefault();
                if (_gc is not null)
                {
                    _gc.GenerateConfigurationValue = year + splitKey + vers;
                    _appDbContext.GenerateConfigurations.Update(_gc);
                    _appDbContext.SaveChanges(); 
                }
            }

        }

        public bool checkDataMigration(string dataMigrationStatusName, string dataMigrationTypeName)
        {

            IQueryable<DataMigration> dm = _appDbContext.DataMigrations.Include("DataMigrationStatus").Include("DataMigrationType");

            var checkProcessing = dm.Where(a => a.DataMigrationStatus.DataMigrationStatusName == dataMigrationStatusName &&
                                  a.DataMigrationType.DataMigrationTypeName == dataMigrationTypeName)
                                  .Count();

            return (checkProcessing > 0 ? false : true);

        }

        public bool checkBackupFilesExists()
        {
            // All backup files must exist for back up to work

            var file1 = File.Exists(_bkfsMetaFileLoc + @"\" + bkESSflname);
            var file2 = File.Exists(_bkfsMetaFileLoc + @"\" + bkCHRflname);
            var file3 = File.Exists(_bkfsMetaFileLoc + @"\" + bkESSflnameFLay);
            var file4 = File.Exists(_bkfsMetaFileLoc + @"\" + bkCHRflnameFLay);

            if (file1 && file2 && file3 && file4) { return true; }
            else { return false; }

        }

        public void UpdateKeyinGenConfig(string key, string log)
        {

            IQueryable<GenerateConfiguration> gc = _appDbContext.GenerateConfigurations
                                                   .Where(q => q.GenerateConfigurationCategory == configurationCategory && q.GenerateConfigurationKey == key);

            if (gc is null || gc.Count() == 0)
            {
                GenerateConfiguration _gc = new GenerateConfiguration();
                _gc.GenerateConfigurationCategory = configurationCategory;
                _gc.GenerateConfigurationKey = key;
                _gc.GenerateConfigurationValue = log;
                _appDbContext.GenerateConfigurations.Add(_gc);
                _appDbContext.SaveChanges();
            }
            else
            {
                GenerateConfiguration _gc = (GenerateConfiguration)gc.Where(a => a.GenerateConfigurationKey == key).FirstOrDefault();
                if (_gc is not null)
                {
                    _gc.GenerateConfigurationValue = log;
                    _appDbContext.GenerateConfigurations.Update(_gc);
                    _appDbContext.SaveChanges(); 
                }
            }

        }

        public string GetLatestSYs() 
        {

            var cont = string.Empty;
            List<DataSetYearVersionByAllAbbrv> initDSYVr = null;
            int maxESSSubmissionYear = 0;
            int maxCHRSubmissionYear = 0;
            int maxSubmissionYear = 0;
            string initCallUrl = _fsWSURL + initSubdir;
            var client = new RestClient(new RestClientOptions(new Uri(initCallUrl)));
            var request = new RestRequest("", Method.Get);
            var response = client.Execute(request);

            cont = response.Content;
            cont = cont.Replace("{\"DataSetYearVersions\":", "").Replace("]}", "]");

            initDSYVr = JsonConvert.DeserializeObject<List<DataSetYearVersionByAllAbbrv>>(cont);
            maxESSSubmissionYear = int.Parse(initDSYVr.Where(n => n.DataSetName == essDSName && n.VersionStatusDesc == pub).Max(d => d.YearName).Replace("SY ", "").Substring(0, 4));
            maxCHRSubmissionYear = int.Parse(initDSYVr.Where(n => n.DataSetName == charterDSName && n.VersionStatusDesc == pub).Max(d => d.YearName).Replace("SY ", "").Substring(0, 4));
            maxSubmissionYear = maxESSSubmissionYear > maxCHRSubmissionYear ? maxESSSubmissionYear : maxCHRSubmissionYear;

            var ddlstring = "[" + maxSubmissionYear.ToString() + "," + (maxSubmissionYear - 1).ToString() + "," + (maxSubmissionYear - 2).ToString() + "]";
            //var ddlstring = "[2025,2024]";
            return ddlstring;
        }


    }
}
