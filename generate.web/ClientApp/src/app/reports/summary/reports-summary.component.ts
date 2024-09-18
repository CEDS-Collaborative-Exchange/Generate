import {Component, AfterViewInit} from '@angular/core';

declare var componentHandler: any;

@Component({
    templateUrl: './reports-summary.component.html',
    styleUrls: ['./reports-summary.component.scss']
})

export class ReportsSummaryComponent implements AfterViewInit {

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }    

}
