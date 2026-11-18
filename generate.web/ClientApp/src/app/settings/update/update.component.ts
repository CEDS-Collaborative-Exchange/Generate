import { Component, AfterViewInit, OnDestroy } from '@angular/core';
import { Router } from '@angular/router';

import { GenerateUpdateService } from '../../services/app/generate-update.service';
import { forkJoin, Observable, of } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { UpdatePackage } from '../../models/app/update-package';

import { UpdateStatus } from 'src/app/models/app/update-status';
import { AppConfig } from 'src/app/app.config';
import { IAppConfig } from '../../models/app-config.model';

declare let componentHandler: any;
declare const moment: any;

const IDLE_POLL_MS = 30000;
const ACTIVE_POLL_MS = 3000;
const FAILED_PREFIX = 'FAILED - ';
// How long after starting an update, or after the last IN_PROGRESS status, failed checks are
// treated as the sites restarting rather than shown as errors.
const UPDATE_RESTART_GRACE_MS = 5 * 60 * 1000;
// Web asks background to start its half and retries for a couple of minutes before recording a
// failure, so backgroundWaitingToStart staying true for longer means web restarted before it
// could finish.
const BACKGROUND_START_TIMEOUT_MS = 5 * 60 * 1000;
// Statuses meaning the web site itself is unreachable or offline (app_offline.htm) - expected
// while background replaces web's files, so they never end the wait on their own.
const SITE_OFFLINE_STATUSES = new Set([0, 502, 503, 504]);
const UNAUTHORIZED = 401;

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

    // While an update runs, web and background take each other offline and restart, so the
    // update API calls fail (503) or briefly disagree on the downloaded updates until it ends.
    private quietUntil = 0;

    private backgroundWaitStartedAt = 0;
    backgroundStartTimedOut = false;

    // When the update status was last read. updateStatus keeps the last value read, so without
    // this a status call that keeps failing leaves the page trusting a stale IN_PROGRESS forever.
    private lastStatusAt = 0;

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

        const delay = this.isUpdateInProgress() || this.updateProcessing ? ACTIVE_POLL_MS : IDLE_POLL_MS;

        this.pollTimeout = setTimeout(() => {
            // Web and background download the update one after the other, so their downloaded
            // lists disagree until the download finishes. download() checks again once it's done.
            if (!this.downloadingUpdates) {
                this.checkAvailable();
            }
            this.schedulePoll();
        }, delay);
    }

    ngOnDestroy() {
        if (this.pollTimeout) {
            clearTimeout(this.pollTimeout);
        }
    }

    isUpdateInProgress(): boolean {
        return this.updateStatus != null && !this.backgroundStartTimedOut &&
            (this.updateStatus.webStatus === 'IN_PROGRESS' || this.updateStatus.backgroundStatus === 'IN_PROGRESS');
    }

    hasUpdateFailed(): boolean {
        return this.updateStatus != null && (this.backgroundStartTimedOut ||
            this.isFailedStatus(this.updateStatus.webStatus) || this.isFailedStatus(this.updateStatus.backgroundStatus));
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

    private isUpdateRunning(): boolean {
        return this.isUpdateInProgress() || (this.updateProcessing && Date.now() < this.quietUntil);
    }

    private applyStatus(status: UpdateStatus) {
        this.updateStatus = status;
        this.lastStatusAt = Date.now();
        this.checkBackgroundStartTimeout();
        if (this.isUpdateInProgress()) {
            this.quietUntil = Date.now() + UPDATE_RESTART_GRACE_MS;
        }
    }

    // Reports the update as failed when background has been waiting to start for too long,
    // instead of polling "Update in Progress" forever.
    private checkBackgroundStartTimeout() {
        if (!this.updateStatus?.backgroundWaitingToStart) {
            this.backgroundWaitStartedAt = 0;
            this.backgroundStartTimedOut = false;
            return;
        }

        if (!this.backgroundWaitStartedAt) {
            this.backgroundWaitStartedAt = Date.now();
        } else if (!this.backgroundStartTimedOut && Date.now() - this.backgroundWaitStartedAt > BACKGROUND_START_TIMEOUT_MS) {
            this.backgroundStartTimedOut = true;
            // Show the failure directly; going through the "update finished" reload would just
            // restart the wait.
            this.updateProcessing = false;
        }
    }

    // Lets the status still come back when the update lists can't be read, so a running or
    // failed update is reported instead of the list error.
    private captureError<T>(request: Observable<T>, onError: (error: any) => void): Observable<T> {
        return request.pipe(catchError(error => {
            onError(error);
            return of(null as T);
        }));
    }

    private showCheckError(error: any) {
        if (this.shouldReloadAfterUpdate(error)) {
            // Web is back but the update API can't be used from this page any more - most likely
            // the update finished and web's restart dropped the session. Reload to show the real
            // result (or the login prompt) instead of "Update in Progress" forever.
            window.location.reload();
            return;
        }
        if (this.isUpdateRunning() && !this.hasUpdateFailed()) {
            return;
        }
        this.updateProcessing = false;
        this.errorMessage = error;
    }

    private shouldReloadAfterUpdate(error: any): boolean {
        if (!this.updateProcessing) {
            return false;
        }

        const status: number | undefined = error?.status;
        if (status === UNAUTHORIZED) {
            return true;
        }

        // While web is offline or restarting, keep waiting however long the update takes. Once it
        // answers again, give up on a status that hasn't been readable for the whole grace period.
        const siteOffline = status === undefined || SITE_OFFLINE_STATUSES.has(status);
        return !siteOffline && Date.now() - this.lastStatusAt > UPDATE_RESTART_GRACE_MS;
    }

    filesUploaded($event) {
        if (this.callService)
        { this.checkAvailable(); }
        else
        { this.checkAvailableOffline(); } 
    }

    checkAvailable() {

        let listError: any = null;
        forkJoin(
            this._generateUpdateService.getStatus(),
            this.captureError(this._generateUpdateService.getPendingUpdates(), error => listError = error),
            this.captureError(this._generateUpdateService.getDownloadedUpdates(), error => listError = error),
        ).subscribe(data => {

            this.applyStatus(data[0]);
            if (listError) {
                this.showCheckError(listError);
                return;
            }
            this.errorMessage = null;

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
                if (this.updateProcessing) {
                    // The update finished while this page was open. Reload so the browser picks up
                    // the updated application files and shows the current update status.
                    window.location.reload();
                    return;
                }
                this.updateProcessing = false;
            }

        },
        error => this.showCheckError(error));
    }

    checkAvailableOffline() {

        let listError: any = null;
        forkJoin(
            this._generateUpdateService.getStatus(),
            this.captureError(this._generateUpdateService.getDownloadedUpdates(), error => listError = error)
        ).subscribe(data => {

            this.applyStatus(data[0]);
            if (listError) {
                this.showCheckError(listError);
                return;
            }
            this.errorMessage = null;

            let downloaded = data[1];

            this.downloadedUpdates = downloaded;

            if (!this.isUpdateInProgress() && (this.downloadedUpdates.length == 0 || this.hasUpdateFailed())) {
                if (this.updateProcessing) {
                    // The update finished while this page was open. Reload so the browser picks up
                    // the updated application files and shows the current update status.
                    window.location.reload();
                    return;
                }
                this.updateProcessing = false;
            }

        },
        error => this.showCheckError(error));
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
        this.quietUntil = Date.now() + UPDATE_RESTART_GRACE_MS;
        this.lastStatusAt = Date.now();
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
