import {Component, AfterViewInit} from '@angular/core';

declare var componentHandler: any;

@Component({
    templateUrl: './reports-summary.component.html',
    styleUrls: ['./reports-summary.component.scss'],
    standalone: false
})

export class ReportsSummaryComponent implements AfterViewInit {

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }    

}
