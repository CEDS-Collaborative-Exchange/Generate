import { Component, Input, AfterViewInit, OnInit, OnChanges, SimpleChange, ViewChild, ViewChildren, QueryList, ElementRef, NgZone, OnDestroy } from '@angular/core';
import { Router, ActivatedRoute, NavigationExtras } from '@angular/router';
import { Observable } from 'rxjs';

import { DataMigrationService } from '../../services/app/dataMigration.service';
import { DataMigrationHistoryService } from '../../services/app/dataMigrationHistory.service';
import { UserService } from '../../services/app/user.service';
import { MigrationMessageService } from '../../services/app/migrationmessage.service';
import { DimSchoolYearDto } from '../../models/app/schoolYear';
import { DimSchoolYearDataMigrationType } from '../../models/app/schoolYear';
import { DataMigrationTask } from '../../models/app/migrationtasks';
import { GenerateReport } from '../../models/app/migrationtasks';
import { GenerateReportType } from '../../models/app/migrationtasks';
import { DataMigrationHistory } from '../../models/app/dataMigrationHistory';
import { StagingValidationResult } from '../../models/app/stagingValidationResult';
import { FactType } from '../../models/app/factType';
import { GuiColumn, GuiPaging, GuiPagingDisplay, GuiRowColoring, GuiRowStyle } from '@generic-ui/ngx-grid';

import { forkJoin } from 'rxjs';
declare let componentHandler: any;
declare let moment: any;
@Component({
    selector: 'generate-app-reportmigration',
    templateUrl: './reportmigration.component.html',
    styleUrls: ['./reportmigration.component.scss'],
    providers: [DataMigrationService, UserService, MigrationMessageService, DataMigrationHistoryService]
})
export class ReportMigationComponent implements OnDestroy {

    public reportType: string;
    selectedIndex: number;
    selectedFactTypeCode: string;
    selectedFactTypeIndex: number;
    refreshInterval: any;
    lastTriggerTime: Date;
    errorMessage: string;
    resultMessage: string;

    reportMigrationIsAvailable: boolean;
    reportMigrationIsProcessing: boolean;
    cancelIsAvailable: boolean;
    isCanceling: boolean;

    showReportMigrateStatus: boolean;
    showReportMigrateProgress: boolean;
    showReportMigrateTimeRemaining: boolean;
    showRDSMigrateStatus: boolean;
    flag: boolean;
    reportMessage: string;
    estimatedReportCompletionTime: string;
    public userService: UserService;
    public migrationMessageService: MigrationMessageService;
    @ViewChild('comboReportYear', { static: false }) comboReportYear: any;
    @ViewChild('comboFactType', { static: false }) comboFactType: any;
    @ViewChild('reportGrid', { static: false }) reportGrid: any;
    @ViewChildren('reportGrid') reportGrids: QueryList<any>;

    gridColumns: Array<GuiColumn> = [
        {
            header: 'Migration Date',
            field: 'dataMigrationHistoryDate',
            type: 'string',
            width: 200
        },
        {
            header: 'Message',
            field: 'dataMigrationHistoryMessage',
            type: 'string',
            width: 900
        }
    ];

    validationGridColumns: Array<GuiColumn> = [
        {
            header: 'Fact Type',
            field: 'factTypeOrReportCode',
            type: 'string',
            width: 100
        },
        {
            header: 'Table Name',
            field: 'stagingTableName',
            type: 'string',
            width: 300
        },
        {
            header: 'Column',
            field: 'columnName',
            type: 'string',
            width: 250
        },
        {
            header: 'Validation Message',
            field: 'validationMessage',
            type: 'string',
            width: 800
        },
        {
            header: 'Severity',
            field: 'severity',
            type: 'string',
            width: 100
        }
    ];

    paging: GuiPaging = {
        enabled: true,
        page: 1,
        pageSize: 10,
        pageSizes: [5, 10, 25],
        pagerTop: true,
        pagerBottom: true,
        display: GuiPagingDisplay.ADVANCED
    };

    rowColoring: GuiRowColoring = GuiRowColoring.EVEN;

    rowStyle: GuiRowStyle = {
        styleFunction: (data: any, index: number) => {
            if ((data.dataMigrationHistoryMessage.toLowerCase().indexOf("exception") > -1) || (data.dataMigrationHistoryMessage.toLowerCase().indexOf("error") > -1)) {
                return 'background: #FFF3E0';
            }
        }
    };

    public reportYears: DimSchoolYearDto[];
    public factTypes: FactType[];
    public lastRunFactType: FactType = null;
    public selectedyear: DimSchoolYearDto;
    private dimSchoolYearDataMigrationTypes: DimSchoolYearDataMigrationType[];
    private dimSchoolYearDataMigrationType: DimSchoolYearDataMigrationType;
    private checkedYear: DimSchoolYearDto;
    private myReports: DimSchoolYearDto[];
    private checkedMigrationTask1: DataMigrationTask[];
    public migrationTasks: GenerateReport[];
    private checkedMigrationTasks: GenerateReport[];
    public dateId: number;
    public isSelected: boolean;
    public isRunning: boolean;        
    public migrationId: number;
    public cvData: any;
    public cvDataYear: any;
    public cvFactTypes: any;
    public isLoading: boolean = false;
    public selectedReports: GenerateReport[];
    public generateReportTypes: GenerateReportType[];
    public updatedYear: DimSchoolYearDataMigrationType[];
    private yearsNew: DimSchoolYearDataMigrationType[];
    public migrationHistoryList: DataMigrationHistory[];
    public stagingValidationResultList: StagingValidationResult[];
    public tabIndex: number;

    ngOnInit() {
        let self = this;
        this.isLoading = true;
        this.isRunning = false;
        this.tabIndex = 0;
        this.initializeReportPage();
        
    }

    initializeReportPage() {
        this.yearsNew = [];
        forkJoin(
            this._dataMigrationService.getYears('report'),
            this._dataMigrationService.getFactTypes(),
            this._dataMigrationService.generateReportList(),
            this._dataMigrationService.generateReportType(),
            this._dataMigrationService.getLastRunFactType(),
            this._dataMigrationHistoryService.getStagingValidationResults()
        ).subscribe(data => {
            this.isLoading = false;
            this.reportYears = data[0];
            this.factTypes = data[1];
            this.migrationTasks = data[2];
            this.selectedReports = data[2];
            this.generateReportTypes = data[3];
            this.lastRunFactType = data[4];
            this.stagingValidationResultList = data[5];
            //if (this.stagingValidationResultList.length > 0) { this.tabIndex = 2; }
            if (this.lastRunFactType !== null) {
                this.selectedFactTypeCode = this.lastRunFactType.factTypeCode;

            }
            this.reportYears.forEach((item, index) => {
                if (item.isSelected) {
                    this.selectedyear = item;
                    this.selectedIndex = index;
                }
                this.dimSchoolYearDataMigrationType = {
                    dimSchoolYearId: item.dimSchoolYearId,
                    dataMigrationTypeId: item.dataMigrationTypeId,
                    isSelected: item.isSelected
                };
                this.yearsNew.push(this.dimSchoolYearDataMigrationType);

            });
            this.migrationTasks.forEach(b => {
                this.generateReportTypes.forEach(c => {
                    if (c.generateReportTypeId === b.generateReportTypeId) {
                        b.reportType = c.reportTypeName;
                    }
                });
            });

            //this.directoryCheck();

            if (this.selectedFactTypeCode !== undefined && this.selectedFactTypeCode !== null && this.selectedFactTypeCode.length > 0) {
                let selectedFactTypeId = this.factTypes.filter(t => t.factTypeCode === this.selectedFactTypeCode)[0].dimFactTypeId;
                this.setFactType(selectedFactTypeId);
                this.cvData = this.selectedReports.filter(t => t.generateReport_FactTypes.map(t => t.factTypeId).includes(selectedFactTypeId));
            } else {
                this.cvData = this.migrationTasks;
            }

            this.cvDataYear = this.reportYears;
            this.cvFactTypes = this.factTypes;
        });
    }

    ngOnDestroy() {
        if (this.refreshInterval) {
            clearInterval(this.refreshInterval);
        }
    }

    initGrid(s, e) {
           let self = this;
            s.columnHeaders.setCellData(0, 0, "");
           s.rows.defaultSize = 24;
            s.columnHeaders.rows.defaultSize = 24;
            s.cellEditEnded.addHandler(function (s, e) {
                    if (e.col == 0) {
                            let item = s.rows[e.row].dataItem;
                            let generateReportId = parseInt(item.generateReportId);            
                        self.selectedReports.forEach(a => {
                            if (a.generateReportId === generateReportId) {
                                a.isLocked = item.isLocked;
                            }
                        });
                    }
        });
        s.beginningEdit.addHandler(function (s, e) {
            if (s.columns[e.col].binding == 'reportCode' || s.columns[e.col].binding == 'reportName' || s.columns[e.col].binding == 'reportType' || s.columns[e.col].binding == 'description') {
                e.cancel = true;
            }
        });
    }

    reportSelected(s, e) {
        let self = this;
        let generateReportId = parseInt(s.selectedIds[0]);
        self.selectedReports.forEach(a => {
            if (s.selectedIds.find((item) => item == a.generateReportId.toString()) !== undefined) {
                a.isLocked = true;
            }
            else {
                a.isLocked = false;
            }
        });
    }

    refreshData(s, e) {
        this.cvData.refresh();
    }

    onReportYearUpdate(ev, control) {
        this.checkedYear = control.selectedItem;
        this.yearsNew.forEach((item, index) => {
            if (item.dimSchoolYearId === this.checkedYear.dimSchoolYearId) {
                item.isSelected = true;
                this.selectedIndex = index;
            }
            else {
                item.isSelected = false;
            }
        });
    }

    onFactTypeUpdate(ev, control) {
        let selectedFactTypeId = control.selectedItem.dimFactTypeId;
        this.setFactType(selectedFactTypeId);
        /*control.selectedItem = this.factTypes.filter(t => t.dimFactTypeId === selectedFactTypeId)[0];*/
        this.selectedFactTypeCode = control.selectedItem.factTypeCode;
        this.cvData = this.selectedReports.filter(t => t.generateReport_FactTypes.map(t => t.factTypeId).includes(selectedFactTypeId));
      }

    setFactType(selectedFactTypeId) {
        this.factTypes.forEach((item, index) => {
            if (item.dimFactTypeId === selectedFactTypeId) {
                this.selectedFactTypeIndex = index;
            }
        });
    }

    itemsSourceChanged(s, e) {

        let d = new Date();
        let n = d.getMilliseconds();
        setTimeout(function () {
            if (s.hostElement != null) {

                let row = s.columnHeaders.rows[0];
                row.wordWrap = true;
                s.autoSizeRow(0, true);
            }
        });
    }


    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }


    constructor(
        private _router: Router,
        private _dataMigrationService: DataMigrationService,
        private _userService: UserService,
        private _migrationMessageService: MigrationMessageService,
        private _dataMigrationHistoryService: DataMigrationHistoryService
    ) {

        this.userService = _userService;
        this.migrationMessageService = _migrationMessageService;
        this.reportMessage = 'Migration Pending';

        this.reportMigrationIsAvailable = false;
        this.reportMigrationIsProcessing = false;
        this.cancelIsAvailable = false;
        this.isCanceling = false;

        this.showReportMigrateStatus = false;
        this.showReportMigrateProgress = false;
        this.showReportMigrateTimeRemaining = false;
        this.reportType = 'report';
        this.updateStatus();



        this.refreshInterval = setInterval(
            () => {

                let currentUtcTime = moment.utc();
                let elapsedSeconds = 0;

                if (this.lastTriggerTime != null) {
                    let durationSinceTrigger = moment.duration(currentUtcTime.diff(this.lastTriggerTime));
                    elapsedSeconds = durationSinceTrigger.asSeconds();
                }

                if (elapsedSeconds >= 15 || this.lastTriggerTime == null) {
                    this.updateStatus();
                }

            }, 10000);

    }
    updateStatus() {

        let lastFactType = this.lastRunFactType;
        this._dataMigrationService.getLastRunFactType().subscribe(resp => {
            this.lastRunFactType = resp;
            if (this.selectedReports !== undefined && (this.lastRunFactType !== null) && this.lastRunFactType.factTypeCode !== ((lastFactType !== null) ? lastFactType.factTypeCode : null)) {
                //this.selectedFactTypeCode = this.lastRunFactType.factTypeCode;
                //this.setFactType(this.lastRunFactType.dimFactTypeId);
                this.cvData = this.selectedReports.filter(t => t.generateReport_FactTypes.map(t => t.factTypeId).includes(this.lastRunFactType.dimFactTypeId));
            }
           
        })

        this._dataMigrationService.currentMigrationStatus()
            .subscribe(
                resp => {
                    let data = resp;
                    let factTypeMessage = (this.lastRunFactType !== null) ? (' for ' + this.lastRunFactType.factTypeCode) : '';
                    let userName = (data.userName !== null) ? (' by ' + data.userName) : '';

                    if (data.reportMigrationStatusCode === 'initial') {
                        this.reportMigrationIsAvailable = true;
                        this.reportMigrationIsProcessing = false;
                        this.cancelIsAvailable = false;
                        this.isCanceling = false;

                        this.showReportMigrateProgress = false;
                        this.showReportMigrateStatus = false;
                        this.showReportMigrateTimeRemaining = false;

                        //this.directoryCheck();


                    } else if (data.reportMigrationStatusCode === 'success') {
                        this.reportMigrationIsAvailable = true;
                        this.reportMigrationIsProcessing = false;
                        this.cancelIsAvailable = false;
                        this.isCanceling = false;

                        this.showReportMigrateProgress = false;
                        this.showReportMigrateStatus = true;
                        this.showReportMigrateTimeRemaining = false;
                        this.reportMessage = this.migrationMessageService.getStatusMessage(data.reportLastMigrationTriggerDate, data.reportLastMigrationDurationInSeconds, userName, factTypeMessage);

                        if (this.flag === true) {
                            this.migrationTasks.forEach(b => {
                                b.isLocked = false;
                            });
                            /*this.cvData = this.migrationTasks;*/
                            
                        }

                        this.flag = false;
                        //this.directoryCheck();

                    } else if (data.reportMigrationStatusCode === 'error') {

                        let durationSinceError;
                        let elapsedSecondsSinceError = 0;
                        if (data.reportLastMigrationHistoryDate != null) {
                            let currentUtcTime = moment.utc();
                            let lastUtcTime = moment.utc(data.reportLastMigrationHistoryDate).toDate();

                            durationSinceError = moment.duration(currentUtcTime.diff(lastUtcTime));
                            elapsedSecondsSinceError = durationSinceError.asSeconds();
                        } else {
                            elapsedSecondsSinceError = 0;
                        }

                        let timeRemaining = Math.round(120 - elapsedSecondsSinceError);
                        

                        // Do not make migration available again until at least 2 minutes after cancel/error
                        if (elapsedSecondsSinceError > 120 || data.reportLastMigrationHistoryDate == null) {
                            this.reportMigrationIsAvailable = true;
                            this.reportMessage = 'Last migration was initiated ' + userName + factTypeMessage + ' and was either cancelled or resulted in an error. If the migration failed, check the Data Migration Log tab on this page or click <a href="https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/migration/troubleshooting" target="_blank">here</a> for documentation on possible migration issues.';
                            //this.reportMessage = 'Last migration was initiated ' + userName + factTypeMessage + ' and was either cancelled or resulted in an error. Please check <a href="https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/migration/troubleshooting">here</a>.';
                            this.isCanceling = false;
                        }
                        else {
                            this.reportMigrationIsAvailable = false;
                            this.reportMessage = 'Last Migration was initiated ' + userName + factTypeMessage + ' and was either cancelled or resulted in an error - please wait for tasks to finish (approximately ' + timeRemaining + ' seconds). If the migration failed, check the Data Migration Log tab on this page or click <a href="https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/migration/troubleshooting" target="_blank">here</a> for documentation on possible migration issues.';
                            this.isCanceling = true;
                        }

                        this.reportMigrationIsProcessing = false;
                        this.cancelIsAvailable = false;
                        this.isCanceling = false;

                        this.showReportMigrateProgress = false;
                        this.showReportMigrateStatus = true;
                        this.showReportMigrateTimeRemaining = false;
                        this.reportMigrationIsAvailable = true;


                    } else if (data.reportMigrationStatusCode === 'pending' || data.reportMigrationStatusCode === 'processing') {

                        this.reportMigrationIsAvailable = true;
                        this.reportMigrationIsProcessing = true;
                        this.showReportMigrateStatus = true;

                        if (data.reportLastMigrationDurationInSeconds != null) {

                            if (data.reportLastMigrationHistoryMessage != 'Migration starting ...' && data.reportLastMigrationHistoryMessage != 'Migration Pending') {
                                this.cancelIsAvailable = true;
                            }

                            if (this.isCanceling) {
                                data.reportLastMigrationHistoryMessage = 'Cancelling migration';
                            }


                            if (data.reportLastMigrationHistoryDate != null) {
                                let lastMigrationHistoryDateUtc = moment.utc(data.reportLastMigrationHistoryDate).toDate();
                                let lastMigrationHistoryDateLocal = moment(lastMigrationHistoryDateUtc).format('MM/DD/YYYY, h:mm:ss a');
                                this.reportMessage = moment(lastMigrationHistoryDateUtc).format('MM/DD/YYYY, h:mm:ss a') + ' - ' + data.reportLastMigrationHistoryMessage;
                            }
                            else {
                                this.reportMessage = data.reportLastMigrationHistoryMessage;
                            }

                        }
                        else {
                            this.reportMessage = 'Migration Pending';
                        }

                        if (data.reportLastMigrationDurationInSeconds != null && data.reportLastMigrationTriggerDate != null) {
                            this.setProgress(data.reportLastMigrationDurationInSeconds, data.reportLastMigrationTriggerDate, userName, '#reportMigrationStatus');
                            this.showReportMigrateProgress = true;
                            this.showReportMigrateTimeRemaining = true;
                        }
                        else {
                            this.showReportMigrateProgress = false;
                            this.showReportMigrateTimeRemaining = false;
                        }
                    }

                },
                error => this.errorMessage = <any>error);

    }

    setProgress(totalduration: number, lasttriggerdate: Date, username: string, progressControlid) {

        let progress;
        let elapsedSeconds;
        let remainingMinutes;
        let duration;

        if (lasttriggerdate != null) {
            let currentUtcTime = moment.utc();
            let triggerUtcTime = moment.utc(lasttriggerdate).toDate();

            duration = moment.duration(currentUtcTime.diff(triggerUtcTime));
            elapsedSeconds = duration.asSeconds();
        } else {
            elapsedSeconds = 0;
        }
        remainingMinutes = (totalduration - elapsedSeconds) / 60;
        progress = (elapsedSeconds / totalduration) * 100;

        remainingMinutes = parseInt(remainingMinutes);

        let etaMessage = '';

        if (remainingMinutes > 1) {
            etaMessage = 'Approximately ' + remainingMinutes + ' minutes remaining';
        } else if (Math.abs(remainingMinutes) <= 1) {
            etaMessage = 'Migration will finish momentarily';
        } else {
            etaMessage = 'Migration has exceeded previous duration by ' + Math.abs(remainingMinutes) + ' minutes';
        }

        this.estimatedReportCompletionTime = etaMessage;

        if (progress >= 100) {
            progress = 100;
        }

        let progressBar = document.querySelector(progressControlid);
        if (progressBar != null) {
            progressBar['MaterialProgress'].setProgress(parseInt(progress));
        }

    }

    executeReportMigration() {

        this.reportMigrationIsProcessing = true;

        this.reportMessage = "Migration starting ...";
        this.showReportMigrateStatus = true;

        this.lastTriggerTime = moment.utc();
        this.flag = true;

        this._dataMigrationService.migrateReport(this.yearsNew, this.selectedReports, this._userService.getUserLoginName())
            .subscribe(result => {
                this.resultMessage = <any>result;
                this._dataMigrationService.getYears('ods')
                    .subscribe(data => {
                        this.reportYears = data;
                    });
            },
                error => this.errorMessage = <any>error);

    }

    triggerReportMigration(dlg: any) {
        if (dlg) {
            dlg.hide();
        }

        this.executeReportMigration();

        return false;
    }

    migrateDirectory() {
        this.selectedFactTypeCode = 'directory';
        this.setFactType(this.factTypes.filter(t => t.factTypeCode === this.selectedFactTypeCode)[0].dimFactTypeId);

        this.selectedReports.forEach(t => {

            if (t.reportCode === '029') { t.isLocked = true }
            else { t.isLocked = false }
        });

        this.executeReportMigration();

    }

    showDialog(dlg: any, dialogId: number) {
        dlg.modal = true;
        dlg.show();


    }

    discardDialog(dlg: any) {
        this.errorMessage = '';
        dlg.hide();
    }

    showConfirmReportDialog(dlg: any) {
        if (dlg) {
            dlg.modal = true;
            dlg.show();
        }
    };

    showConfirmCancellationDialog(dlg: any) {
        if (dlg) {
            dlg.modal = true;
            dlg.show();
        }
    };



    cancelMigration(dlg: any) {

        if (dlg) {
            dlg.hide();
        }

        this.isCanceling = true;
        this._dataMigrationService.cancelMigration("report")
            .subscribe(result => {
                this.resultMessage = <any>result;
                this.updateStatus();
            },
                error => this.errorMessage = <any>error
            );

        return false;
    }



    gotoDataStore() {
        this._router.navigateByUrl('/reports/edfacts');
        return false;
    }

    directoryCheck() {
        if (this.selectedyear !== undefined && this.selectedyear.dimSchoolYearId > 0) {
            this._dataMigrationService.checkIfDirectoryDataExists(this.selectedyear.dimSchoolYearId)
                .subscribe(result => {
                    if (!this.reportMigrationIsProcessing) {
                        this.reportMigrationIsAvailable = result;
                        if (!result) {
                            this.reportMessage = "Please run Directory migration before running other migrations.";
                        }
                    }

                });
        }
    }

    getTabContent(tabIndex) {
        if (tabIndex === 0) {
            this.updateStatus();
        }
        if (tabIndex === 1) {
            this._dataMigrationHistoryService.getMigrationHistory('report')
                .subscribe(resp => { this.migrationHistoryList = resp });
        } else if (tabIndex === 2) {
            this._dataMigrationHistoryService.getStagingValidationResults()
                .subscribe(resp => { this.stagingValidationResultList = resp });
        }
    }
}
