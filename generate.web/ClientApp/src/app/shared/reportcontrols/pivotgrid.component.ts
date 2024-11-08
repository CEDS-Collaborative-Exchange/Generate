import { Component, Input, AfterViewInit, OnInit, OnChanges, SimpleChange, ViewChild, ViewChildren, QueryList, ElementRef, NgZone, OnDestroy } from '@angular/core';
import { Router } from '@angular/router';

import { GenerateReportService } from '../../services/app/generateReport.service';
import { GenerateReport } from '../../models/app/generateReport';
import { GenerateReportDto } from '../../models/app/generateReportDto';
import { GenerateReportDataDto } from '../../models/app/generateReportDataDto';
import { OrganizationLevelDto } from '../../models/app/organizationLevelDto';
import { CategoryOptionDto } from '../../models/app/categoryOptionDto';
import { GenerateReportParametersDto } from '../../models/app/generateReportParametersDto';
import { CategorySetDto } from '../../models/app/categorySetDto';
import { Observable } from 'rxjs';
import { RefState } from '../../models/ods/refState';


import { PivottableComponent } from '../components/pivottable/pivottable.component';

import { AppConfig } from '../../app.config';
import { IAppConfig } from '../../models/app-config.model';

import { Subscription } from 'rxjs';


declare var saveAs: any;
declare var componentHandler: any;
declare var alphanum: any;

@Component({
    selector: 'generate-app-pivotgrid',
    templateUrl: './pivotgrid.component.html',
    styleUrls: ['./pivotgrid.component.scss'],
    providers: [GenerateReportService]
})

export class PivotGridComponent implements AfterViewInit, OnChanges, OnInit {

    public errorMessage: string;
    private subscriptions: Subscription[] = [];

    @Input() reportParameters: GenerateReportParametersDto;

    @ViewChild(PivottableComponent) pivotComponent: PivottableComponent;


    public isLoading: boolean = false;
    public isPending: boolean = false;
    public isSubmissionFileAvailable: boolean = false;
    public hasRecords: boolean = false;

    public reportDataDto: GenerateReportDataDto;
    public generateFile: GenerateReport;

    public formatToGenerate: string = '';

    private pageCount: number = 0;
    private pageArray: number[];
    private pageSize: number;

    public cvData: any;

    private _groupBy: string = '';
    private _filter: string = '';
    private _toFilter: any;

    public gridPageNumber: number = 1;
    public gridPageCount: number = 1;


    constructor(
        private _router: Router,
        private _generateReportService: GenerateReportService,
        private _ngZone: NgZone,
        private appConfig: AppConfig
    ) {

        this.appConfig.getConfig().subscribe((res: IAppConfig) => {
            this.pageSize = res.pageSize;
        });

        //console.log('Construct');

        this.reportDataDto = <GenerateReportDataDto>{};

        this.cvData = this.reportDataDto.data;

    }


    ngOnInit() {
        let self = this;

        this.subscriptions.push(this._generateReportService.getSubmissionReport(this.reportParameters.reportType, this.reportParameters.reportCode)
            .subscribe(
                data => {
                    this.generateFile = data;
                    this.isSubmissionFileAvailable = true;
                },
                error => this.errorMessage = <any>error));

    }



    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();

        let self: any = this;

    }

    getCellTitle(header: string, cellValue: string) {

        let optionValue: string = '';
        let tooltip: string = cellValue;

        if (cellValue === 'MISSING') {
            optionValue = 'Missing';
        } else {

            if (this.reportParameters.reportCategorySet != null) {

                for (let i = 0; i < this.reportParameters.reportCategorySet.categoryOptions.length; i++) {
                    let option: CategoryOptionDto = this.reportParameters.reportCategorySet.categoryOptions[i];
                    if (header === option.categoryName) {
                        if (cellValue.trim() === option.categoryOptionCode.trim()) {
                            optionValue = option.categoryOptionName;
                        }
                    }
                }
            }

        }

        if (optionValue.length > 0) {
            tooltip = optionValue;
        }

        return tooltip;

    }

    ngOnChanges(changes: { [propName: string]: SimpleChange }) {
        for (let prop in changes) {
            if (changes.hasOwnProperty(prop)) {
                this.populateReport(false);
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



    ngOnDestroy() {
        this.subscriptions.forEach(subscription => subscription.unsubscribe());

        this.reportDataDto = null;
    }

    populateReport(ispageUpdated: boolean) {

        console.log('populate');
        console.log('Report Level is: ' + this.reportParameters.reportLevel + ' ' + this.reportParameters.reportYear + ' ' + this.reportParameters.reportCode + ' ' + this.reportParameters.reportCategorySetCode);
        console.log('Page size is : ' + this.pageSize);

        this.isSubmissionFileAvailable = false;


        if (this.reportParameters.reportType !== undefined
            && this.reportParameters.reportCode !== undefined
            && this.reportParameters.reportLevel !== undefined
            && this.reportParameters.reportYear !== undefined) {

            //reset the error message from previous report load, if any
            this.errorMessage = null;
            this.isLoading = true;

            if (!ispageUpdated) { this.gridPageNumber = 1; }
            // Define take and skip

            //let take = +this.reportParameters.reportPageSize;
            //let skip = (+this.reportParameters.reportPage - 1) * +this.reportParameters.reportPageSize;

            // Retrieve all data
            let take = 0;
            let skip = 0;

            if (this.reportParameters.reportSort === undefined) {
                this.reportParameters.reportSort = 1;
            }

            let categorySetCode: string = 'null';



            if (this.reportParameters.reportCategorySetCode !== undefined) {
                categorySetCode = this.reportParameters.reportCategorySetCode

            } else {
                categorySetCode = 'CSA';
            }

            if (this.reportParameters.reportCategorySet !== undefined) {
                categorySetCode = this.reportParameters.reportCategorySet.categorySetCode;
            }


            this.subscriptions.push(this._generateReportService.getPagedReport(this.reportParameters.reportType, this.reportParameters.reportCode, this.reportParameters.reportLevel, this.reportParameters.reportYear, categorySetCode, this.reportParameters.reportSort, skip, take, this.pageSize, this.gridPageNumber)
                .subscribe(
                    reportDataDto => {

                        this.reportDataDto = reportDataDto;

                        this.cvData = reportDataDto.data;

                        if (reportDataDto.categorySets !== null && reportDataDto.categorySets.length > 0) {

                            this.reportParameters.reportCategorySet = reportDataDto.categorySets[0];

                            if (this.reportDataDto === null) {
                                this.errorMessage = 'Invalid Report';
                            } else {

                                this.gridPageCount = Math.ceil(this.reportDataDto.dataCount / this.pageSize);

                                if ((this.gridPageCount * this.pageSize) < this.reportDataDto.dataCount) {
                                    this.gridPageCount++;
                                }

                                this.pageCount = Math.ceil(this.reportDataDto.dataCount / this.reportParameters.reportPageSize);


                                this.setPageArray();

                                //console.log(this.cvData.itemCount);
                                if (this.cvData.length > 0) { this.hasRecords = true; }
                                else if (this.reportDataDto.dataCount === -1) { this.hasRecords = true; }
                                else { this.hasRecords = false; }

                            }

                            this.isLoading = false;

                            //this.subscriptions.forEach(subscription => subscription.unsubscribe());
                        }
                        

                    },
                    error => this.errorMessage = <any>error));

            this.subscriptions.push(this._generateReportService.getSubmissionReport(this.reportParameters.reportType, this.reportParameters.reportCode)
                .subscribe(
                    data => {
                        this.generateFile = data;
                        this.isSubmissionFileAvailable = true;
                    },
                    error => this.errorMessage = <any>error));
        }
    }

    getReportYear() {
        if (this.reportDataDto.reportYear === '2017' || this.reportDataDto.reportYear === '2016' || this.reportDataDto.reportYear === '2015' || this.reportDataDto.reportYear === '2014')
            return true
        else
            return false;
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

    showCategorySetLabel() {
        let isShow: boolean = true;
        if (this.reportParameters.reportLevel === 'sch' && this.reportParameters.reportCode === 'c059') {
            isShow = false;
        }
        return isShow;
    }


    setReportPage(event, reportPage: number) {
        if (this.reportParameters.reportPage !== reportPage) {
            this.reportParameters.reportPage = reportPage;
            this.populateReport(false);
        }
        return false;
    }

    moveCurrentToNext(s, e) {
        console.log('Refresh the grid');
        let cv = this.cvData;
        cv.refresh();

    }

    export() {
        console.log("ExportToExcel");
        let sheetName = this.reportParameters.reportCode.toUpperCase();
        let reportCategorySetCode = this.reportParameters.reportCategorySetCode !== undefined ? this.reportParameters.reportCategorySetCode : '';
        let fileName = this.reportParameters.reportCode.toUpperCase() + ' - ' + this.reportParameters.reportYear + ' - ' + this.reportParameters.reportLevel.toUpperCase() + ' - ' + reportCategorySetCode + '.xlsx';
        this.pivotComponent.exportToExcel(fileName);
        return;
    }



    private _filterFunction(item: any) {
        if (this._filter) {

            let isFiltered: boolean = false;
            if (item.organizationName.toLowerCase().indexOf(this._filter.toLowerCase()) > -1) { isFiltered = true; }
            if (!isFiltered) {
                if (item.organizationStateId.toLowerCase().indexOf(this._filter.toLowerCase()) > -1) { isFiltered = true; }
            }
            return isFiltered;

        }
        return true;
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


        let currentDate = new Date();
        let version = 'v' + this.leadingZero(currentDate.getDate()) + this.leadingZero(currentDate.getMinutes()) + this.leadingZero(currentDate.getSeconds());
        let fileName = stateCode + reportLevel.toUpperCase() + version + '.' + format;
        if (this.generateFile !== undefined) {
            fileName = stateCode + reportLevel.toUpperCase() + this.generateFile.reportTypeAbbreviation.slice(0, 9) + version + '.' + format;
            console.log(fileName);
        }



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

    setGridPage() {
        console.log('Selected Page is: ' + this.gridPageNumber);
        console.log('Page Count is: ' + this.gridPageCount);
        this.populateReport(true);
        return false;
    }

    updateSliderGridPage(n) {
        this.gridPageNumber = n;
        this.setGridPage();
    }

}
