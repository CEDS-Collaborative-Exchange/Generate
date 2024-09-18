import { Component, AfterViewInit } from '@angular/core';
import { FSMetadataUpdate } from '../../services/app/FSMetadataUpdate.service';
import { MetadataStatus } from '../../models/app/metadataStatus';

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
    
    constructor(
        private _FSMetadatapdateService: FSMetadataUpdate
        ) {
        this._fsmetadatapdateService = _FSMetadatapdateService
        this.getStatus();

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

        this._fsmetadatapdateService.callFSMetaServc()
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
                        this.isprocessing = true;
                    } else { this.isprocessing = false; }
                }
            });
    }

    metadataCss(status: string) {
        if (status === "FAILED") { this.metadataStatusCss = 'generate-metadata__error'; }
        else {
            this.metadataStatusCss = 'generate-metadata__message';
        }
    }

}
