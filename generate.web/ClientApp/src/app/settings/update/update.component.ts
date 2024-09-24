import { Component, AfterViewInit } from '@angular/core';
import { Router } from '@angular/router';

import { GenerateUpdateService } from '../../services/app/generate-update.service';
import { forkJoin } from 'rxjs';
import { UpdatePackage } from '../../models/app/update-package';
import * as moment from 'moment';

import { UpdateStatus } from 'src/app/models/app/update-status';
import { AppConfig } from 'src/app/app.config';
import { IAppConfig } from '../../models/app-config.model';

declare let componentHandler: any;

@Component({
    selector: 'generate-app-settings-update',
    templateUrl: './update.component.html',
    styleUrls: ['./update.component.scss'],
    providers: [GenerateUpdateService]

})
export class UpdateComponent implements AfterViewInit {


    pendingUpdates: Array<UpdatePackage> = [];
    downloadedUpdates: Array<UpdatePackage> = [];
    resultMessage: string;
    errorMessage: string;
    databaseBackupSuggested: boolean = false;
    refreshInterval: any;
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
            //this.timeLeftSeconds = res.timeoutInSeconds
            this.callService = res.callService

            if (this.callService) {
                console.log("checkAvailable true--");
                this.checkAvailable();


                this.refreshInterval = setInterval(
                    () => {
                        this.checkAvailable();
                    }, 30000);
            }
            else {
                console.log("checkAvailable false--");
                this.checkAvailableOffline();
            }

        })

        //console.log("before callService");
        //console.log(<string><unknown>this.callService);
        //console.log("before callService1");
        //    this.checkAvailable();
        //    this.refreshInterval = setInterval(
        //        () => {
        //            this.checkAvailable();
        //        }, 30000);


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

            if (this.downloadedUpdates.length == 0 || this.updateStatus.status != "OK") {
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

            if (this.downloadedUpdates.length == 0 || this.updateStatus.status != "OK") {
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

        this._generateUpdateService.applyDownloadedUpdates()
            .subscribe(
                result => this.resultMessage = <any>result,
                error => this.errorMessage = <any>error);

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
