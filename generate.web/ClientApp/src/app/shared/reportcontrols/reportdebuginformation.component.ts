import { Component, Input, AfterViewInit, OnInit, OnChanges, SimpleChange, ViewChild, ViewChildren, QueryList, ElementRef, NgZone, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Subscription, finalize } from 'rxjs';

import { GenerateReportService } from '../../services/app/generateReport.service';
import { FlextableComponent } from '../components/flextable/flextable.component';


declare let componentHandler: any;

@Component({
  selector: 'app-reportdebuginformation',
  templateUrl: './reportdebuginformation.component.html',
    styleUrl: './reportdebuginformation.component.css',
    providers: [GenerateReportService]
})
export class ReportDebugInformationComponent {
    private subscriptions: Subscription[] = [];
    @ViewChild(FlextableComponent) flextableComponent: FlextableComponent;

    public errorMessage: string;
    public isLoading: boolean = false;
    public repotDebugData: any;
    public headers: any;
    public bindings: any;
    zoomLevel = 1; // 100% zoom

    constructor(
        public dialogRef: MatDialogRef<ReportDebugInformationComponent>,
        private _generateReportService: GenerateReportService,
        @Inject(MAT_DIALOG_DATA) public data: any
    ) {

    }

    closeDialog(): void {
        this.dialogRef.close();
    }


    ngOnInit() {
        this.populateReport();
    }

    ngOnDestroy() {
        this.subscriptions.forEach(subscription => subscription.unsubscribe());

        this.repotDebugData = null;
    }
    ngOnChanges(changes: { [propName: string]: SimpleChange }) {
        for (let prop in changes) {
            if (changes.hasOwnProperty(prop)) {
                this.populateReport();
            }
        }
    }

    populateReport() {
        let self = this;
        let reportYear = this.data.reportYear;
        let reportLevel = this.data.reportLevel;
        let categorySetCode = this.data.categorySetCode;
        let reportCode = this.data.reportCode;
        let filters = this.data.filters;
        this.bindings = this.data.bindings;
        this.headers = this.data.headers;

        this.subscriptions.push(this._generateReportService.getReportDebugData(reportCode, reportLevel, reportYear, categorySetCode, filters)
            .pipe(finalize(() => this.isLoading = false))
            .subscribe(
                data => {
                    this.repotDebugData = data.map(i => i['fields']);

                },
                error => this.errorMessage = <any>error));
    }

    export() {
        let self = this;
        let cellColspan = 10;

        let sheetName = this.data.reportCode.toUpperCase();
        let fileName = this.data.reportCode.toUpperCase() + ' - ' + this.data.reportYear + ' - ' + this.data.reportLevel.toUpperCase();

        if (this.data.categorySetCode !== undefined) {
            fileName += ' - ' + this.data.categorySetCode;
        }

        let reportTitle = this.data.reportData.reportTitle;// reportTitle just the title removing categorySetName

        fileName += ".xlsx";

        let caption2 = this.data.reportData.categorySets[0].categories.join(','); //caption2 as category set
        let caption3 = "Count: "+this.data.recordCount;

        let reportCaptionCol = 3;
        let reportCols = [];

        let reportRows = [
            { hpx: 100 }, // row 1 sets to the height of 12 in points
            { hpx: 23 }, // row 2 sets to the height of 16 in pixels
            { hpx: 20 }, // row 2 sets to the height of 16 in pixels
            { hpx: 20 }, // row 2 sets to the height of 16 in pixels
            { hpx: 45 }, // row 2 sets to the height of 16 in pixels
        ];
        this.flextableComponent.exportToExcel(fileName, reportTitle, caption2, caption3, reportCols, reportRows, reportCaptionCol);

        return;
    }
}
