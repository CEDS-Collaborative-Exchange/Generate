import { Component, AfterViewInit } from '@angular/core';

declare var componentHandler: any;

@Component({
    selector: 'generate-app-resources-tutorials',
    templateUrl: './tutorials.component.html',
    styleUrls: ['./tutorials.component.scss']
})
export class ResourcesTutorialsComponent implements AfterViewInit {

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }

    downloadTranscript() {
        window.open('./assets/downloads/Generate-Tutorial-Transcript.pdf', '_blank');
        return false;
    }
}
