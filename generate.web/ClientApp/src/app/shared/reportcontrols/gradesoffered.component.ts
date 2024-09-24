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
import { forkJoin } from 'rxjs'

import { FlextableComponent } from '../components/flextable/flextable.component';


declare let componentHandler: any;
declare let saveAs: any;
declare let alphanum: any;

@Component({
    selector: 'generate-app-gradesoffered',
    templateUrl: './gradesoffered.component.html',
    styleUrls: ['./gradesoffered.component.scss'],
    providers: [GenerateReportService]
})

export class GradesOfferedComponent implements AfterViewInit, OnChanges, OnInit {
    public errorMessage: string;

    @Input() reportParameters: GenerateReportParametersDto;
    @ViewChild(FlextableComponent) flextableComponent: FlextableComponent;

    public currentReport: GenerateReportDto;

    public isLoading: boolean = false;  
    public isPending: boolean = false; 
    public hasRecords: boolean = false;
    public reportDataDto: GenerateReportDataDto;
    public generateFile: GenerateReport;
   
    public formatToGenerate: string = '';
    

    private pageCount: number = 0;
    private pageArray: number[];
    private organizationLevel: string = '';

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
        this.reportDataDto = null;
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


            this.isLoading = true;

            let take = 0;
            let skip = 0;

            if (this.reportParameters.reportLevel.toLowerCase() === 'lea') {
                this.organizationLevel = 'LEA';
            } else {
                this.organizationLevel = 'School';
            }

            if (this.reportParameters.reportSort === undefined) {
                this.reportParameters.reportSort = 1;
            }

            let categorySetCode: string = 'null';
            if (this.reportParameters.reportCategorySet !== undefined) {
                categorySetCode = this.reportParameters.reportCategorySet.categorySetCode;
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
                  
                        this.cvData = this.reportDataDto.data;

                        // Get new category set
                        if (this.reportParameters.reportCategorySet === undefined) {
                            if (this.reportDataDto.categorySets !== null && this.reportDataDto.categorySets.length > 0) {
                                this.reportParameters.reportCategorySet = this.getDefaultCategorySet(this.reportDataDto.categorySets);
                            }
                        }
                   //     this.cvData.filter = this._filterFunction.bind(this);


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

    refreshData(s, e) {
        this.cvData.refresh();
    }

    itemsSourceChanged(s, e) {

        let d = new Date();
        let n = d.getMilliseconds();
        //console.log('itemsSourceChanged - ' + n);
        //console.log(s


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

        let self = this;
        let cellColspan = 10;

        let sheetName = this.reportParameters.reportCode.toUpperCase();
        let fileName = this.reportParameters.reportCode.toUpperCase() + ' - ' + this.reportParameters.reportYear + ' - ' + this.reportParameters.reportLevel.toUpperCase();

        if (this.reportParameters.reportCategorySet !== undefined) {
            fileName += ' - ' + this.reportParameters.reportCategorySet.categorySetName.replace('?', '');
        }

        fileName += ".xlsx";

        let reportTitle = this.reportDataDto.reportTitle;
        let statetCaption = this.reportDataDto.data[0].stateName;
        let totalCaption = this.dataCountCaption() + " " + this.reportDataDto.dataCount;

        let reportCaptionCol = 2;
        let reportCols = [];
        if (this.reportParameters.reportLevel === 'lea') {
            reportCols.push({ wpx: 200 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 400 });

            reportCaptionCol = 4;
        } else if (this.reportParameters.reportLevel === 'sch') {
            reportCols.push({ wpx: 200 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 400 });
        }

        let reportRows = [
            { hpx: 25 }, // row 1 sets to the height of 1pixels
            { hpx: 23 }, 
            { hpx: 20 }, 
            { hpx: 20 }, 
            { hpx: 45 }, 
            { hpx: 25 } // Set the data row height
        ];
        this.flextableComponent.exportToExcel(fileName, reportTitle, statetCaption, totalCaption, reportCols, reportRows, reportCaptionCol);

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

        // Following code can be used in future once Blob gets implemented in angular 2

        //this._http.get(url)
        //    .subscribe(res => {
        //        //   let blob = new Blob([res._body], { type: 'text/csv' });
        //        console.log('Returned blob');
        //        let blob = new Blob([res._body], { type: 'text/csv' });
        //        let filename = 'test.csv';
        //        saveAs(blob, filename);

        //    },
        //    error => {
        //        console.log('Error downloading the file.');
        //    });
    }



}

