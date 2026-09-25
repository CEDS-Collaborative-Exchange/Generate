import { Component, AfterViewInit, OnDestroy } from '@angular/core';
import { Router } from '@angular/router';

import { GenerateUpdateService } from '../../services/app/generate-update.service';
import { forkJoin } from 'rxjs';
import { UpdatePackage } from '../../models/app/update-package';

import { UpdateStatus } from 'src/app/models/app/update-status';
import { AppConfig } from 'src/app/app.config';
import { IAppConfig } from '../../models/app-config.model';

declare let componentHandler: any;
declare const moment: any;

const IDLE_POLL_MS = 30000;
const ACTIVE_POLL_MS = 3000;
const FAILED_PREFIX = 'FAILED - ';

@Component({
    selector: 'generate-app-settings-update',
    templateUrl: './update.component.html',
    styleUrls: ['./update.component.scss'],
    providers: [GenerateUpdateService],
    standalone: false
})
export class UpdateComponent implements AfterViewInit, OnDestroy {


    pendingUpdates: Array<UpdatePackage> = [];
    downloadedUpdates: Array<UpdatePackage> = [];
    resultMessage: string;
    errorMessage: string;
    databaseBackupSuggested: boolean = false;
    pollTimeout: any;
    updateProcessing: boolean = false;
    downloadingUpdates: boolean = false;
    callService: boolean = false;

    updateStatus: UpdateStatus;

    constructor(
        private _router: Router,
        private _generateUpdateService: GenerateUpdateService,
        private appConfig: AppConfig
    ) {

        this.appConfig.getConfig().subscribe((res: IAppConfig) => {
            this.callService = res.callService

            if (this.callService) {
                this.checkAvailable();
                this.schedulePoll();
            }
            else {
                this.checkAvailableOffline();
            }

        })

    }

    // Polls quickly (every few seconds) while an update is actively running so phase text
    // stays current, and falls back to the slower idle cadence the rest of the time.
    schedulePoll() {
        if (this.pollTimeout) {
            clearTimeout(this.pollTimeout);
        }

        const delay = this.isUpdateInProgress() ? ACTIVE_POLL_MS : IDLE_POLL_MS;

        this.pollTimeout = setTimeout(() => {
            this.checkAvailable();
            this.schedulePoll();
        }, delay);
    }

    ngOnDestroy() {
        if (this.pollTimeout) {
            clearTimeout(this.pollTimeout);
        }
    }

    isUpdateInProgress(): boolean {
        return this.updateStatus != null &&
            (this.updateStatus.webStatus === 'IN_PROGRESS' || this.updateStatus.backgroundStatus === 'IN_PROGRESS');
    }

    hasUpdateFailed(): boolean {
        return this.updateStatus != null &&
            (this.isFailedStatus(this.updateStatus.webStatus) || this.isFailedStatus(this.updateStatus.backgroundStatus));
    }

    formatFailureMessage(status: string): string {
        if (!this.isFailedStatus(status)) {
            return '';
        }
        return status.substring(FAILED_PREFIX.length);
    }

    private isFailedStatus(status: string): boolean {
        return status?.startsWith(FAILED_PREFIX) ?? false;
    }

    filesUploaded($event) {
        if (this.callService)
        { this.checkAvailable(); }
        else
        { this.checkAvailableOffline(); } 
    }

    checkAvailable() {

        forkJoin(
            this._generateUpdateService.getStatus(),
            this._generateUpdateService.getPendingUpdates(),
            this._generateUpdateService.getDownloadedUpdates(),
        ).subscribe(data => {

            this.updateStatus = data[0];
            let pending = data[1];
            let downloaded = data[2];
            
            this.pendingUpdates = [];

            // There is probably a more elegant way to do this in JS

            if (pending != null) {
                for (let i = 0; i < pending.length; i++) {
                    let pendingUpdate = pending[i];

                    let foundUpdate = false;
                    for (let j = 0; j < downloaded.length; j++) {
                        let downloadedUpdate = downloaded[j];
                        if (downloadedUpdate.fileName == pendingUpdate.fileName) {
                            foundUpdate = true;
                        }

                        if (downloadedUpdate.databaseBackupSuggested) {
                            this.databaseBackupSuggested = true;
                        }
                    }
                    if (!foundUpdate) {
                        this.pendingUpdates.push(pendingUpdate);
                    }

                }
            }

            this.downloadedUpdates = downloaded;

            if (!this.isUpdateInProgress() && (this.downloadedUpdates.length == 0 || this.hasUpdateFailed())) {
                this.updateProcessing = false;
            }

        });
    }

    checkAvailableOffline() {

        forkJoin(
            this._generateUpdateService.getStatus(),
            this._generateUpdateService.getDownloadedUpdates()
        ).subscribe(data => {

            this.updateStatus = data[0];
            let downloaded = data[1];

            this.downloadedUpdates = downloaded;

            if (!this.isUpdateInProgress() && (this.downloadedUpdates.length == 0 || this.hasUpdateFailed())) {
                this.updateProcessing = false;
            }

        });
    }

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }

    clear() {

        this._generateUpdateService.clearDownloadedUpdates()
            .subscribe(
                result => {
                    this.resultMessage = <any>result;
                    this.checkAvailable();
                },
                error => this.errorMessage = <any>error);

        return false;
    }

    download() {
        this.downloadingUpdates = true
        this._generateUpdateService.downloadUpdates()
            .subscribe(
            result => {
                this.resultMessage = <any>result;
                this.checkAvailable();
                this.downloadingUpdates = false
            },
            error => {this.errorMessage = <any>error; this.downloadingUpdates = false});

        return false;
    }

    update(dlg: any) {
        if (dlg) {
            dlg.hide();
        }

        this.updateProcessing = true;
        this.errorMessage = null;

        this._generateUpdateService.applyDownloadedUpdates()
            .subscribe(
                result => {
                    this.resultMessage = <any>result;
                    this.checkAvailable();
                },
                error => {
                    // The apply request itself failed (e.g. network error) before the backend
                    // could even record a WebStatus/BackgroundStatus - don't leave the page
                    // stuck showing "Update in Progress" forever.
                    this.errorMessage = <any>error;
                    this.updateProcessing = false;
                    this.checkAvailable();
                });

        return false;
    }


    showConfirmUpdateDialog(dlg: any) {
        if (dlg) {
            dlg.modal = true;
            dlg.show();
        }
        return false;
    };

    formatDateTime(d: string): string {
        if (d == undefined || d == '' || d == null) {
            return '';
        }
        let returnDate = moment(d).format('MMMM DD, YYYY')
        return returnDate;
    }


}
