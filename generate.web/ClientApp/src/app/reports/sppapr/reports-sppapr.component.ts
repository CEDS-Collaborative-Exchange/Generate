import {Component, AfterViewInit} from '@angular/core';

declare var componentHandler: any;

@Component({
    templateUrl: './reports-sppapr.component.html',
    styleUrls: ['./reports-sppapr.component.scss'],
    standalone: false
})


export class ReportsSppaprComponent implements AfterViewInit {

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }


}
