import { Component, Inject, SimpleChange } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { Subscription, finalize } from 'rxjs';

import { GenerateReportService } from '../../services/app/generateReport.service';

@Component({
  selector: 'app-reportdebuginformation',
  templateUrl: './reportdebuginformation.component.html',
    styleUrl: './reportdebuginformation.component.css',
    providers: [GenerateReportService]
})
export class ReportDebugInformationComponent {
    private subscriptions: Subscription[] = [];

    public errorMessage: string;
    public isLoading: boolean = false;
    public repotDebugData: any;
    public headers: any;
    public bindings: any;
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
}
