import { Component, Input, AfterViewInit, OnInit, OnChanges, SimpleChange, ViewChild, ViewChildren, QueryList, ElementRef, NgZone } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { Subscription } from 'rxjs';
import { GenerateReportService } from '../../services/app/generateReport.service';
import { GenerateReport } from '../../models/app/generateReport';
import { GenerateReportDto } from '../../models/app/generateReportDto';
import { GenerateReportDataDto } from '../../models/app/generateReportDataDto';
import { OrganizationLevelDto } from '../../models/app/organizationLevelDto';
import { CategoryOptionDto } from '../../models/app/categoryOptionDto';
import { GenerateReportParametersDto } from '../../models/app/generateReportParametersDto';
import { CategorySetDto } from '../../models/app/categorySetDto';
import { Observable } from 'rxjs';
import { forkJoin } from 'rxjs';

import { FlextableComponent } from '../components/flextable/flextable.component';

declare var componentHandler: any;
declare var saveAs: any;
declare var alphanum: any;

@Component({
    selector: 'generate-app-c131',
    templateUrl: './c131.component.html',
    styleUrls: ['./c131.component.scss'],
    providers: [GenerateReportService]
})

export class C131Component implements AfterViewInit, OnChanges, OnInit {
    public errorMessage: string;

    @Input() reportParameters: GenerateReportParametersDto;
    @ViewChild(FlextableComponent) flextableComponent: FlextableComponent;

    public currentReport: GenerateReportDto;

    public isLoading: boolean = false;
    public isPending: boolean = false;
    public hasRecords: boolean = false;
    public reportDataDto: GenerateReportDataDto;
    public generateFile: GenerateReport;
    public reportCode: string;
    public formatToGenerate: string = '';


    private pageCount: number = 0;
    private pageArray: number[];

    public cvData: any;

    private _groupBy: string = '';
    private _filter: string = '';
    private _toFilter: any;

    constructor(
        private _router: Router,
        private _generateReportService: GenerateReportService,
        private _ngZone: NgZone,
        private activatedRoute: ActivatedRoute
    ) {
    }


    ngOnInit() {
        let self = this;
    }

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();

        let self: any = this;
    }

    populateReport() {

        if (this.reportParameters.reportType !== undefined
            && this.reportParameters.reportCode !== undefined
            && this.reportParameters.reportLevel !== undefined
            && this.reportParameters.reportYear !== undefined) {

            this.reportCode = this.reportParameters.reportCode;
            this.isLoading = true;

            let take = 0;
            let skip = 0;

            if (this.reportParameters.reportSort === undefined) {
                this.reportParameters.reportSort = 1;
            }

            let categorySetCode: string = 'null';
            if (this.reportParameters.reportCategorySet !== undefined) {
                categorySetCode = this.reportParameters.reportCategorySet.categorySetCode;
            } else {
                categorySetCode = 'CSA';
            }


            let reportLea: string = 'null';
            if (this.reportParameters.reportLea !== undefined) {
                reportLea = this.reportParameters.reportLea.split('(')[0].trim();
            }

            let reportSchool: string = 'null';
            if (this.reportParameters.reportSchool !== undefined) {
                reportSchool = this.reportParameters.reportSchool.split('(')[0].trim();
            }

            this._generateReportService.getReport(this.reportParameters.reportType, this.reportParameters.reportCode, this.reportParameters.reportLevel, this.reportParameters.reportYear, categorySetCode, this.reportParameters.reportSort, skip, take)
                .subscribe(
                    reportDataDto => {
                        this.reportDataDto = reportDataDto;

                        if (this.reportDataDto.data !== null && this.reportDataDto.data.length > 0) {
                            this.reportDataDto.data.forEach((item, index) => {
                                item.organizationName = item.organizationName + ' ( ' + item.organizationStateId + ' ) ';
                                item.stateAgencyCode = '01';
                            });

                        }
                        console.log(this.reportDataDto.data);
                        this.cvData = this.reportDataDto.data;

                        // Get new category set
                        if (this.reportParameters.reportCategorySet === undefined) {
                            if (this.reportDataDto.categorySets !== null && this.reportDataDto.categorySets.length > 0) {
                                this.reportParameters.reportCategorySet = this.getDefaultCategorySet(this.reportDataDto.categorySets);
                            }
                        }

                        if (this.reportDataDto === null) {
                            this.errorMessage = 'Invalid Report';
                        } else {

                            this.pageCount = Math.ceil(this.reportDataDto.dataCount / +this.reportParameters.reportPageSize);

                            this.setPageArray();
                            if (this.cvData.itemCount > 0) { this.hasRecords = true; }
                            else if (this.reportDataDto.dataCount === -1) { this.hasRecords = true; }
                            else { this.hasRecords = false; }
                        }
                        this.isLoading = false;

                        this._generateReportService.getSubmissionReport(this.reportParameters.reportType, this.reportParameters.reportCode)
                            .subscribe(
                                data => {
                                    this.generateFile = data;
                                },
                                error => this.errorMessage = <any>error);
                    });
        }
    }

    ngOnChanges(changes: { [propName: string]: SimpleChange }) {
        for (let prop in changes) {
            if (changes.hasOwnProperty(prop)) {
                this.populateReport();
            }
        }
    }

    get groupBy(): string {
        return this._groupBy;
    }
    set groupBy(value: string) {
        if (this._groupBy !== value) {
            this._groupBy = value;
        }
    }

    get filter(): string {
        return this._filter;
    }
    set filter(value: string) {
        if (this._filter !== value) {
            this._filter = value;
            if (this._toFilter) {
                clearTimeout(this._toFilter);
            }
            let self = this;
            this._toFilter = setTimeout(function () {
                self.cvData.refresh();
                if (self.cvData.itemCount > 0) { self.hasRecords = true; }
                else { self.hasRecords = false; }
            }, 500);


        }
    }


    refreshData(s, e) {
        this.cvData.refresh();
    }

    itemsSourceChanged(s, e) {

        let d = new Date();
        let n = d.getMilliseconds();


        setTimeout(function () {

            if (s.hostElement != null) {
                // enable wrapping on first header row
                let row = s.columnHeaders.rows[0];
                row.wordWrap = true;

                // autosize first header row
                s.autoSizeRow(0, true);
            }

        });
    }

    getDefaultCategorySet(categorySets: Array<CategorySetDto>) {

        if (categorySets === undefined || categorySets.length === 0) {
            return null;
        }

        function compare(a: CategorySetDto, b: CategorySetDto) {
            if (a.categorySetName < b.categorySetName)
                return -1;
            if (a.categorySetName > b.categorySetName)
                return 1;
            return 0;
        }

        categorySets.sort(compare);

        return categorySets[0];
    }

    dataCountCaption() {

        if (this.reportParameters.reportLevel === 'lea') {
            return 'Total LEAs: ';
        } else if (this.reportParameters.reportLevel === 'sch') {
            return 'Total Schools: ';
        } else {
            return 'Total: ';
        }
    }

    export() {
;
        let self = this;
        let cellColspan = 10;

        let sheetName = this.reportParameters.reportCode.toUpperCase();
        let fileName = this.reportParameters.reportCode.toUpperCase() + ' - ' + this.reportParameters.reportYear + ' - ' + this.reportParameters.reportLevel.toUpperCase();

        if (this.reportParameters.reportCategorySet !== undefined) {
            fileName += ' - ' + this.reportParameters.reportCategorySet.categorySetName.replace('?', '');
        }

        fileName += ".xlsx";

        let reportTitle = this.reportDataDto.reportTitle;
        let reportYearCaption = this.reportDataDto.reportYear;
        let categorySetCaption = this.reportParameters.reportCategorySet.categorySetName;
        let totalCaption = this.dataCountCaption() + " " + this.reportDataDto.dataCount;

        let reportCaptionCol = 2;
        var reportCols = [];
        if (this.reportParameters.reportLevel === 'lea') {
            reportCols.push({ wpx: 200 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 250 });
            reportCols.push({ wpx: 200 });
            reportCols.push({ wpx: 200 });
        }

        var reportRows = [
            { hpx: 25 }, // row 1 sets to the height of 25 in points
            { hpx: 23 }, 
            { hpx: 20 }, 
            { hpx: 20 }, 
            { hpx: 45 }, 
        ];
        this.flextableComponent.exportToExcel(fileName, reportTitle, categorySetCaption, totalCaption, reportCols, reportRows, reportCaptionCol);

        return;

    }

    private _filterFunction(item: any) {
        if (this._filter) {
            if (this.reportParameters.reportType === 'datapopulation') {
                return item.rowKey.toLowerCase().indexOf(this._filter.toLowerCase()) > -1;
            } else {
                let isFiltered: boolean = false;
                if (item.organizationName.toLowerCase().indexOf(this._filter.toLowerCase()) > -1) { isFiltered = true; }
                if (!isFiltered) {
                    if (item.organizationStateId.toLowerCase().indexOf(this._filter.toLowerCase()) > -1) { isFiltered = true; }
                }
                return isFiltered;
            }
        }
        return true;
    }

    getReportYear() {
        if (this.reportDataDto.reportYear === '2016-17' || this.reportDataDto.reportYear === '2015-16' || this.reportDataDto.reportYear === '2014-15' || this.reportDataDto.reportYear === '2013-14')
            return true
        else
            return false;
    }

    setPageArray() {

        let pageArrayStart = 1;
        let pageArrayEnd = 5;

        if (this.reportParameters.reportPage === 1) {
            pageArrayStart = 1;
        } else {
            pageArrayStart = (Math.floor((this.reportParameters.reportPage - 1) / 5) * 5) + 1;
        }
        pageArrayEnd = pageArrayStart + 4;
        if (pageArrayEnd > this.pageCount) {
            pageArrayEnd = this.pageCount;
        }

        this.pageArray = new Array();
        for (let i = pageArrayStart; i <= pageArrayEnd; i++) {
            this.pageArray.push(i);
        }
    }


    activeReportPageCss(reportPage: number) {
        if (this.reportParameters.reportPage === reportPage) {
            return 'mdl-button--raised mdl-button--accent';
        } else {
            return '';
        }
    }

    backPageDisabled() {
        if (this.reportParameters.reportPage === 1) {
            return 'disabled';
        } else {
            return '';
        }
    }

    forwardPageDisabled() {
        if (this.reportParameters.reportPage === this.pageCount) {
            return 'disabled';
        } else {
            return '';
        }
    }


    createSubmissionFile(dlg: any, format: string) {

        this.formatToGenerate = format;

        if (dlg) {
            dlg.modal = true;
            dlg.show();
        }

    }

    getDownloadFileType(format: string) {

        if (format === 'csv' || format === 'txt') {
            return 'text/csv';
        } else if (format === 'tab') {
            return 'application/vnd.ms-excel';
        } else if (format === 'xml') {
            return 'text/xml';
        }

    }

    leadingZero(value) {
        if (value < 10) {
            return '0' + value.toString();
        }
        return value.toString();
    }

    getFileSubmission(dlg: any) {
        if (dlg) {
            dlg.hide();
        }

        let format = this.formatToGenerate;

        this.isPending = true;
        let self = this;

        // Get State ANSI Code
        let stateCode: string = '';
        if (this.reportDataDto !== undefined && this.reportDataDto.data.length > 0) {
            let row: any = this.reportDataDto.data[0];
            if (row.stateAbbreviationCode !== undefined) {
                stateCode = row.stateAbbreviationCode;
            } else {
                stateCode = row.stateCode;
            }
        }

        let reportType = this.reportParameters.reportType;
        let reportCode = this.reportParameters.reportCode;
        let reportLevel = this.reportParameters.reportLevel;
        let reportYear = this.reportParameters.reportYear;
        let formatType = this.getDownloadFileType(format);
        // let submissionFile: this.generateFiles;
        let currentDate = new Date();
        let version = 'v' + this.leadingZero(currentDate.getDate()) + this.leadingZero(currentDate.getMinutes()) + this.leadingZero(currentDate.getSeconds());
        let fileName = stateCode + reportLevel.toUpperCase() + this.generateFile.reportTypeAbbreviation + version + '.' + format;

        let xhr = new XMLHttpRequest();
        let url = 'api/app/filesubmissions/' + reportType + '/' + reportCode + '/' + reportLevel + '/' + reportYear + '/' + format + '/' + fileName;

        xhr.open('GET', url, true);
        xhr.responseType = 'blob';

        xhr.onreadystatechange = function () {

            setTimeout(() => { }, 0);

            if (xhr.readyState === 4 && xhr.status === 200) {
                self.isPending = false;
                let blob = new Blob([this.response], { type: formatType });
                saveAs(blob, fileName);
            } else if (xhr.readyState === 4 && xhr.status !== 200) {
                self.isPending = false;
                console.log('File submission error');
                alert('An unknown error occurred while generating the file. Please contact your system administrator.');
            }
        };

        xhr.send();
    }



}

