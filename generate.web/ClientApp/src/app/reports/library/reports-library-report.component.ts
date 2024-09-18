import { Component, OnInit, OnDestroy, AfterViewInit } from '@angular/core';
import { Router} from '@angular/router';


declare var componentHandler: any;

@Component({
    selector: 'generate-app-reports-library',
    templateUrl: './reports-library-report.component.html',
    styleUrls: ['./reports-library-report.component.scss']
})
export class ReportsLibraryReportComponent implements OnInit, OnDestroy, AfterViewInit {

    constructor(private _router: Router) { }

    ngOnInit() {
    }
    
    ngOnDestroy() {
    }

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }

}
