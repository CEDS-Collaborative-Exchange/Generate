import { Component, Input, AfterViewInit, OnInit, OnChanges, SimpleChange, ViewChild, ViewChildren, QueryList, ElementRef, NgZone, OnDestroy } from '@angular/core';
import { Router, ActivatedRoute, NavigationExtras } from '@angular/router';
import { Observable } from 'rxjs';
import { forkJoin } from 'rxjs'

import { DataMigrationService } from '../../services/app/dataMigration.service';
import { DataMigrationHistoryService } from '../../services/app/dataMigrationHistory.service';
import { UserService } from '../../services/app/user.service';
import { MigrationMessageService } from '../../services/app/migrationmessage.service';
import { DimSchoolYearDto } from '../../models/app/schoolYear';
import { DimSchoolYearDataMigrationType } from '../../models/app/schoolYear';
import { DataMigrationTask } from '../../models/app/migrationtasks';
import { DataMigrationHistory } from '../../models/app/dataMigrationHistory';
import { GuiColumn, GuiPaging, GuiPagingDisplay, GuiRowColoring, GuiRowStyle } from '@generic-ui/ngx-grid';


declare let componentHandler: any;
declare let moment: any;

@Component({
    selector: 'generate-app-odsmigration',
    templateUrl: './odsmigration.component.html',
    styleUrls: ['./odsmigration.component.scss'],
    providers: [DataMigrationService, UserService, MigrationMessageService, DataMigrationHistoryService]
})
export class ODSMigationComponent implements OnInit, AfterViewInit, OnDestroy {
    public cvData: any;
    public cvDataYear: any;
    private reportYears: DimSchoolYearDto[];
    private dimSchoolYearDataMigrationTypes: DimSchoolYearDataMigrationType[];
    private dimSchoolYearDataMigrationType: DimSchoolYearDataMigrationType;
    private checkedReports: DimSchoolYearDto[];
    private myReports: DimSchoolYearDto[];
    private checkedMigrationTask1: DataMigrationTask[];
    private migrationTasks: DataMigrationTask[];
    private migrationTaskLists: DataMigrationTask[];
    public reportType: string;
    public dateId: number;
    public isSelected: boolean;
    public migrationId: number;
    refreshInterval: any;
    public isLoading: boolean = false;
    public selectedTasks: DataMigrationTask[];
    public migrationHistoryList: DataMigrationHistory[];
    public updatedYear: DimSchoolYearDataMigrationType[];
    private yearsNew: DimSchoolYearDataMigrationType[];
    public taskSequencesLists: number[];
    public maxtaskSequence: number;
    public minTaskSequence: number;
    public shouldRefreshMigrationTaskList: boolean;
    lastTriggerTime: Date;
    errorMessage: string;
    resultMessage: string;

    odsMigrationIsAvailable: boolean;
    odsMigrationIsProcessing: boolean;
    cancelIsAvailable: boolean;
    isCanceling: boolean;

    showODSMigrateStatus: boolean;
    showODSMigrateProgress: boolean;
    showODSMigrateTimeRemaining: boolean;


    odsMessage: string;

    estimatedODSCompletionTime: string;

    public userService: UserService;
    public migrationMessageService: MigrationMessageService;
    @ViewChild('reportGrid', { static: false }) reportGrid: any;
    @ViewChildren('reportGrid') reportGrids: QueryList<any>;
    @ViewChild('comboReportYear', { static: false }) comboReportYear: any;


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

    paging: GuiPaging = {
        enabled: true,
        page: 1,
        pageSize: 5,
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

    ngOnInit() {
        let self = this;
        this.isLoading = true;
        this.initializeODSpage();
    }

    initializeODSpage() {
        this.yearsNew = [];
        this.taskSequencesLists = [];
        forkJoin(
            this._dataMigrationService.getYears('ods'),
            this._dataMigrationService.getTaskLists('ods'),
            this._dataMigrationHistoryService.getMigrationHistory('ods')
        ).subscribe(data => {
            this.isLoading = false;
            this.reportYears = data[0].reverse();
            this.migrationTasks = data[1];
            this.selectedTasks = data[1];
            this.migrationTaskLists = data[1];
            this.migrationHistoryList = data[2];

            //this.dimDateDataMigrationType;
            this.reportYears.forEach(a => {
                this.dimSchoolYearDataMigrationType = {
                    dimSchoolYearId: a.dimSchoolYearId,
                    dataMigrationTypeId: a.dataMigrationTypeId,
                    isSelected: a.isSelected
                };
                this.yearsNew.push(this.dimSchoolYearDataMigrationType);
            });
            this.migrationTasks.forEach(b => {
                this.taskSequencesLists.push(b.taskSequence);
            });
            this.maxtaskSequence = Math.max.apply(this, this.taskSequencesLists);
            //console.log(this.maxtaskSequence);
            this.minTaskSequence = Math.min.apply(this, this.taskSequencesLists);
            this.cvData = this.migrationTasks;
            this.cvData.sortDescriptions.push('taskSequence', true);
            this.cvDataYear = this.reportYears;
        });
    }

    ngOnDestroy() {
        if (this.refreshInterval) {
            clearInterval(this.refreshInterval);
        }
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
        this.odsMessage = 'Migration Pending';

        this.odsMigrationIsAvailable = false;
        this.odsMigrationIsProcessing = false;
        this.cancelIsAvailable = false;
        this.isCanceling = false;

        this.showODSMigrateStatus = false;
        this.showODSMigrateProgress = false;
        this.showODSMigrateTimeRemaining = false;
        this.reportType = 'ods';
        this.shouldRefreshMigrationTaskList = false;
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

    initYearGrid(s, e) {
        let self = this;
        s.columnHeaders.setCellData(0, 0, "");
        s.rows.defaultSize = 24;
        s.columnHeaders.rows.defaultSize = 24;
        s.cellEditEnded.addHandler(function (s, e) {
            if (e.col == 0) {
                let item = s.rows[e.row].dataItem;
                let dataMigrationTypeId = parseInt(item.dataMigrationTypeId);
                let dimDateId = parseInt(item.dimSchoolYearId);
                let isSelected = item.isSelected;
                self.yearsNew.forEach(a => {
                    if (a.dimSchoolYearId === dimDateId && a.dataMigrationTypeId === dataMigrationTypeId) {
                        a.isSelected = item.isSelected;
                    }
                });
            }
        });
        s.beginningEdit.addHandler(function (s, e) {
            if (s.columns[e.col].binding == 'submissionYear') {
                e.cancel = true;
            }
        });
    }

    initGrid(s, e) {
        let self = this;
        s.columnHeaders.setCellData(0, 0, "");
        s.rows.defaultSize = 24;
        s.columnHeaders.rows.defaultSize = 24;
        s.cellEditEnded.addHandler(function (s, e) {
            if (e.col == 0) {
                let item = s.rows[e.row].dataItem;
                let migrationTaskId = parseInt(item.dataMigrationTaskId);

                self.selectedTasks.forEach(a => {
                    if (a.dataMigrationTaskId === migrationTaskId) {
                        a.isSelected = item.isSelected;
                    }
                });
            }
        });

        s.beginningEdit.addHandler(function (s, e) {
            if (s.columns[e.col].binding == 'taskSequence' || s.columns[e.col].binding == 'storedProcedureName' || s.columns[e.col].binding == 'description') {
                e.cancel = true;
            }
        });
    }

    refreshData(s, e) {
        this.cvData.refresh();
        //console.log(this.cvData);
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

    updateStatus() {

        this._dataMigrationHistoryService.getMigrationHistory('ods')
            .subscribe(resp => { this.migrationHistoryList = resp });

        this._dataMigrationService.currentMigrationStatus()
            .subscribe(
                resp => {
                    let data = resp;

                    if (data.odsMigrationStatusCode === 'initial') {
                        this.odsMigrationIsAvailable = true;
                        this.odsMigrationIsProcessing = false;
                        this.cancelIsAvailable = false;
                        this.isCanceling = false;

                        this.showODSMigrateProgress = false;
                        this.showODSMigrateStatus = false;
                        this.showODSMigrateTimeRemaining = false;
                    } else if (data.odsMigrationStatusCode === 'success') {
                        this.odsMigrationIsAvailable = true;
                        this.odsMigrationIsProcessing = false;
                        this.cancelIsAvailable = false;
                        this.isCanceling = false;

                        this.showODSMigrateProgress = false;
                        this.showODSMigrateStatus = true;
                        this.showODSMigrateTimeRemaining = false;
                        this.odsMessage = this.migrationMessageService.getStatusMessage(data.odsLastMigrationTriggerDate, data.odsLastMigrationDurationInSeconds, data.userName, '');


                        if (this.shouldRefreshMigrationTaskList) {
                            this.migrationTasks = this.migrationTaskLists;
                            this.cvData = this.migrationTasks;
                            this.cvData.sortDescriptions.push('taskSequence', true);
                            this.shouldRefreshMigrationTaskList = false;
                        }

                    } else if (data.odsMigrationStatusCode === 'error') {

                        let durationSinceError;
                        let elapsedSecondsSinceError = 0;
                        if (data.odsLastMigrationHistoryDate != null) {
                            let currentUtcTime = moment.utc();
                            let lastUtcTime = moment.utc(data.odsLastMigrationHistoryDate).toDate();

                            durationSinceError = moment.duration(currentUtcTime.diff(lastUtcTime));
                            elapsedSecondsSinceError = durationSinceError.asSeconds();
                        } else {
                            elapsedSecondsSinceError = 0;
                        }

                        let timeRemaining = Math.round(120 - elapsedSecondsSinceError);

                        // Do not make migration available again until at least 2 minutes after cancel/error
                        if (elapsedSecondsSinceError > 120 || data.odsLastMigrationHistoryDate == null) {
                            this.odsMigrationIsAvailable = true;
                            this.odsMessage = 'Last migration was either canceled or resulted in an error';
                        }
                        else {
                            this.odsMigrationIsAvailable = false;
                            this.odsMessage = 'Migration was canceled or resulted in an error - please wait for tasks to finish (approximately ' + timeRemaining + ' seconds)';
                        }

                        this.odsMigrationIsProcessing = false;
                        this.cancelIsAvailable = false;
                        this.isCanceling = false;

                        this.showODSMigrateProgress = false;
                        this.showODSMigrateStatus = true;
                        this.showODSMigrateTimeRemaining = false;

                    } else if (data.odsMigrationStatusCode === 'pending' || data.odsMigrationStatusCode === 'processing') {

                        this.odsMigrationIsAvailable = true;
                        this.odsMigrationIsProcessing = true;
                        
                        this.showODSMigrateStatus = true;

                        if (data.odsLastMigrationHistoryMessage != null) {

                            if (data.odsLastMigrationHistoryMessage != 'Migration starting ...' && data.odsLastMigrationHistoryMessage != 'Migration Pending') {
                                this.cancelIsAvailable = true;
                            }

                            if (this.isCanceling) {
                                data.odsLastMigrationHistoryMessage = 'Canceling migration';
                            }


                            if (data.odsLastMigrationHistoryDate != null) {
                                let lastMigrationHistoryDateUtc = moment.utc(data.odsLastMigrationHistoryDate).toDate();
                                let lastMigrationHistoryDateLocal = moment(lastMigrationHistoryDateUtc).format('MM/DD/YYYY, h:mm:ss a');
                                this.odsMessage = moment(lastMigrationHistoryDateUtc).format('MM/DD/YYYY, h:mm:ss a') + ' - ' + data.odsLastMigrationHistoryMessage;
                            }
                            else {
                                this.odsMessage = data.odsLastMigrationHistoryMessage;
                            }

                        }
                        else {
                            this.odsMessage = 'Migration Pending';
                        }

                        if (data.odsLastMigrationDurationInSeconds != null && data.odsLastMigrationTriggerDate != null) {
                            this.setProgress(data.odsLastMigrationDurationInSeconds, data.odsLastMigrationTriggerDate, '#odsMigrationStatus');
                            this.showODSMigrateProgress = true;
                            this.showODSMigrateTimeRemaining = true;
                        }
                        else {
                            this.showODSMigrateProgress = false;
                            this.showODSMigrateTimeRemaining = false;
                        }
                    }

                    if (data.rdsMigrationStatusCode === 'pending' || data.rdsMigrationStatusCode === 'processing' || data.reportMigrationStatusCode === 'pending' || data.reportMigrationStatusCode === 'processing') {
                        this.odsMigrationIsAvailable = false;
                        this.odsMigrationIsProcessing = false;
                        this.cancelIsAvailable = false;
                        this.isCanceling = false;
                    }
                },
                error => this.errorMessage = <any>error);

    }



    setProgress(totalduration: number, lasttriggerdate: Date, progressControlid) {

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

        this.estimatedODSCompletionTime = etaMessage;

        if (progress >= 100) {
            progress = 100;
        }

        let progressBar = document.querySelector(progressControlid);
        if (progressBar != null) {
            progressBar['MaterialProgress'].setProgress(parseInt(progress));
        }

    }

    showConfirmODSDialog(dlg: any) {
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


    Up(item) {
        this.shouldRefreshMigrationTaskList = true;
        let x = this.migrationTasks.indexOf(this.migrationTasks.find(x => x.taskSequence === item.taskSequence));
        let y = this.migrationTasks.indexOf(this.migrationTasks.find(x => x.taskSequence === (item.taskSequence - 1)));
        let j = parseInt(item.taskSequence);
        this.migrationTasks[x].taskSequence = j - 1;
        this.migrationTasks[y].taskSequence = j;
        this.cvData = this.migrationTasks;
        this.cvData.sortDescriptions.push('taskSequence', true);
        this.cvData.moveCurrentToPosition(j - 2);
    }

    Down(item) {
        this.shouldRefreshMigrationTaskList = true;
        let x = this.migrationTasks.indexOf(this.migrationTasks.find(x => x.taskSequence === item.taskSequence));
        let y = this.migrationTasks.indexOf(this.migrationTasks.find(x => x.taskSequence === (item.taskSequence + 1)));
        let j = parseInt(item.taskSequence);
        this.migrationTasks[x].taskSequence = j + 1;
        this.migrationTasks[y].taskSequence = j;
        this.cvData = this.migrationTasks;
        this.cvData.sortDescriptions.push('taskSequence', true);
        this.cvData.moveCurrentToPosition(j);
    }

    triggerODSMigration(dlg: any) {
        if (dlg) {
            dlg.hide();
        }

        this.odsMigrationIsProcessing = true;

        this.odsMessage = "Migration starting ...";
        this.showODSMigrateStatus = true;

        this.lastTriggerTime = moment.utc();

        this._dataMigrationService.migrateODS(this.yearsNew, this.selectedTasks)
            .subscribe(result => {
                this.resultMessage = <any>result;
                this._dataMigrationService.getYears('ods')
                    .subscribe(data => {
                        this.reportYears = data;
                    });

            },
            error => this.errorMessage = <any>error);


        return false;
    }


    cancelMigration(dlg: any) {

        if (dlg) {
            dlg.hide();
        }

        this.cancelIsAvailable = false;
        this.isCanceling = true;

        this._dataMigrationService.cancelMigration("ods")
            .subscribe(result => {
                this.resultMessage = <any>result;
                this.updateStatus();
            },
                error => this.errorMessage = <any>error
            );

        return false;
    }

    
    gotoDataStore() {
        this._router.navigateByUrl('/settings/datastore');
        return false;
    }

}
