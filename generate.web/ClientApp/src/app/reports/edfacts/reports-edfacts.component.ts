import {Component, AfterViewInit} from '@angular/core';

declare var componentHandler: any;

@Component({
    templateUrl: './reports-edfacts.component.html',
    styleUrls: ['./reports-edfacts.component.scss']
})

export class ReportsEdfactsComponent implements AfterViewInit {

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }

}
