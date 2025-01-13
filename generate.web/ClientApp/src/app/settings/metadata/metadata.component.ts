import { Component, AfterViewInit } from '@angular/core';
import { FSMetadataUpdate } from '../../services/app/FSMetadataUpdate.service';
import { MetadataStatus } from '../../models/app/metadataStatus';
import { FormsModule } from '@angular/forms';

declare let componentHandler: any;
declare let moment: any;

@Component({
    selector: 'generate-app-metadata',
    templateUrl: './metadata.component.html',
    styleUrl: './metadata.component.scss',
    providers: [FSMetadataUpdate]
})
export class MetadataComponent implements AfterViewInit {

    _fsmetadatapdateService: FSMetadataUpdate;
    metadataStatus: MetadataStatus[];
    metadataStatusCss: string;
    isprocessing = false;
    metadataStatusMessage: string;
    refreshInterval: any;
    lastTriggerTime: Date;
    latestPubSYlist: string[];
    ddlDisabled: boolean = false;
    selSY: string;

    constructor(
        private _FSMetadatapdateService: FSMetadataUpdate
        ) {
        this._fsmetadatapdateService = _FSMetadatapdateService
        this.getStatus();
        this.getLatestSYs();
        this.getUplFlag();

        this.refreshInterval = setInterval(
            () => {

                let currentUtcTime = moment.utc();
                let elapsedSeconds = 0;

                if (this.lastTriggerTime != null) {
                    let durationSinceTrigger = moment.duration(currentUtcTime.diff(this.lastTriggerTime));
                    elapsedSeconds = durationSinceTrigger.asSeconds();
                }

                if (elapsedSeconds >= 15 || this.lastTriggerTime == null) {
                    this.getStatus();
                }

            }, 10000);

    }

    ngAfterViewInit() {
        //componentHandler.upgradeAllRegistered();
    }

    callFSmetaAPI()
    {
        this.isprocessing = true;
        this.metadataStatusMessage = "The metadata is currently being processed.";
        this.metadataCss('PROCESSING');

        this._fsmetadatapdateService.callFSMetaServc(this.selSY)
            .subscribe(resp => {});
    }

    getStatus() {
        this._fsmetadatapdateService.getMetadataStatus()
            .subscribe(resp => {
                this.metadataStatus = resp;

                if (this.metadataStatus !== undefined) {
                    this.metadataStatusMessage = this.metadataStatus.filter(t => t.generateConfigurationKey === 'MetaLastRunLog')[0].generateConfigurationValue;
                    let status = this.metadataStatus.filter(t => t.generateConfigurationKey === 'metaStatus')[0].generateConfigurationValue;
                    this.metadataCss(status);
                    if (status.toUpperCase() === 'PROCESSING') {
                        this.isprocessing = true; this.ddlDisabled = true;
                    } else {
                        this.isprocessing = false;
                        this.getUplFlag();
                        this.getLatestSYs();
                        //this.ddlDisabled = false;
                    }
                }
            });
    }

    metadataCss(status: string) {
        if (status === "FAILED") { this.metadataStatusCss = 'generate-metadata__error'; }
        else {
            this.metadataStatusCss = 'generate-metadata__message';
        }
    }

    getLatestSYs() {
        console.log('--getLatestSYs--')
        this._fsmetadatapdateService.getlatestSYs()
            .subscribe(resp => {
                console.log("aaaa");
                console.log(resp);
                this.latestPubSYlist = resp;
                console.log("bbbb");
                if (this.latestPubSYlist !=null && this.latestPubSYlist.length > 0) {
                    this.selSY = this.latestPubSYlist[0];
                }
                console.log("cccc");
            });
    }

    getUplFlag() {
        console.log('--getUplFlag--')
        this._fsmetadatapdateService.getFlag()
            .subscribe(resp => {
                console.log('getUplFlag');
                console.log(resp);
                //this.latestPubSYlist = resp;

                if (resp=="True") {
                    this.ddlDisabled = true;
                    //this.selSY = "";
                    console.log('--True--');
                }
                else {
                    this.ddlDisabled = false;
                }

            });
    }

}
