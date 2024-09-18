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


declare var componentHandler: any;
declare var alphanum: any;

@Component({
    selector: 'generate-app-yeartoyearattendance',
    templateUrl: './yeartoyearattendance.component.html',
    styleUrls: ['./yeartoyearattendance.component.scss'],
    providers: [GenerateReportService]
})

export class YeartoYearAttendanceComponent implements AfterViewInit, OnChanges, OnInit {

    public errorMessage: string;

    @Input() reportParameters: GenerateReportParametersDto;

    public currentReport: GenerateReportDto;

    public isLoading: boolean = false;
    public hasRecords: boolean = false;
    public reportDataDto: GenerateReportDataDto;
    public organizationInformation: string = '';

    private pageCount: number = 0;
    private pageArray: number[];

    public cvData: any;

    private _groupBy: string = '';
    private _filter: string = '';
    private _toFilter: any;

    public isExporting: boolean = false

    @ViewChild('reportGrid', { static: false }) reportGrid: any;
    @ViewChildren('reportGrid') reportGrids: QueryList<any>;


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
        if (this.reportGrids.length > 0) {
            this.reportGrid = this.reportGrids[0];

        }
    }

    populateReport() {

        if (this.reportParameters.reportType !== undefined
            && this.reportParameters.reportCode !== undefined
            && this.reportParameters.reportLevel !== undefined
            && this.reportParameters.reportYear !== undefined) {

            this.isLoading = true;

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

            let reportLea: string = 'null';
            if (this.reportParameters.reportLea !== undefined) {
                reportLea = this.reportParameters.reportLea;
            }

            let reportSchool: string = 'null';
            if (this.reportParameters.reportSchool !== undefined) {
                reportSchool = this.reportParameters.reportSchool;
            }

            let reportGrade: string = 'null';
            if (this.reportParameters.reportGrade !== undefined) {
                reportGrade = this.reportParameters.reportGrade;
            }
            else {
                reportGrade = '03';
                this.reportParameters.reportGrade = reportGrade;
            }



            if (this.reportParameters.reportType !== undefined && this.reportParameters.reportCode !== undefined) {
                forkJoin(
                    this._generateReportService.getReportByCode(this.reportParameters.reportType, this.reportParameters.reportCode),
                    this._generateReportService.getStateReport(this.reportParameters.reportType, this.reportParameters.reportCode, this.reportParameters.reportLevel, this.reportParameters.reportYear, categorySetCode, reportLea, reportSchool, this.reportParameters.reportFilter, this.reportParameters.reportSubFilter, null, this.reportParameters.reportGrade, this.reportParameters.reportSort, skip, take)
                ).subscribe(data => {

                    this.currentReport = data[0];
                    this.reportDataDto = data[1];

                    this.cvData = this.reportDataDto.data;

                    // Get new category set
                    if (this.reportParameters.reportCategorySet === undefined) {
                        if (this.reportDataDto.categorySets !== null && this.reportDataDto.categorySets.length > 0) {
                            this.reportParameters.reportCategorySet = this.getDefaultCategorySet(this.reportDataDto.categorySets);
                        }
                    }

                    this._groupBy = 'organizationStateId,category1';

                    this.cvData.sortComparer = function (a, b) {

                        //console.log('sort');

                        if (a === 'MISSING') return 1;
                        if (b === 'MISSING') return -1;
                        if (a === 'MISSING' && b === 'MISSING') return 0;

                        return null;
                    };


                    if (this.reportDataDto === null) {
                        this.errorMessage = 'Invalid Report';
                    } else {

                        this.pageCount = Math.ceil(this.reportDataDto.dataCount / +this.reportParameters.reportPageSize);

                        this.setPageArray();


                        //console.log(this.cvData.itemCount);
                        if (this.cvData.itemCount > 0) { this.hasRecords = true; }
                        else if (this.reportDataDto.dataCount === -1) { this.hasRecords = true; }
                        else { this.hasRecords = false; }


                    }

                    //Get organization information
                    this.organizationInformation = this.getOrganizationInformation();

                    this.isLoading = false;

                });
            }

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
        //console.log('itemsSourceChanged - ' + n);
        //console.log(s);

        s.rowHeaders.rows.defaultSize = 60;
        s.columnHeaders.rows.defaultSize = 80;
        s.columnFooters.rows.defaultSize = 60;

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


    setReportPage(event, reportPage: number) {
        if (this.reportParameters.reportPage !== reportPage) {
            this.reportParameters.reportPage = reportPage;
            this.populateReport();
        }
        return false;
    }

    export() {

        this.isExporting = true

        setTimeout(() => {

            let self = this;
            let sheetName = this.reportParameters.reportCode.toUpperCase();
            let fileName = this.reportParameters.reportCode.toUpperCase() + ' - ' + this.reportParameters.reportYear + ' - ' + this.reportParameters.reportLevel.toUpperCase();


            this.isExporting = false

        }, 1000)
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



    formatItem(s, e) {

        if (s !== undefined) {

            e.cell.innerHTML = '<div style="top: 50%; padding: 0.5em; white-space: pre-wrap; position: relative; transform: translateY(-50%);">' + e.cell.innerHTML + '</div>';
            s.columnHeaders.rows.defaultSize = 50

            if (s.columnHeaders.rows.length < 3) {
                s.columnHeaders.rows[0].allowMerging = true;
            }

            {
                if (e.row === 0) {

                    let headerContent = '';

                    if (this.reportParameters.reportCategorySetCode === 'All') {

                        if (e.col > 3 && e.col <= 11) {
                            headerContent = 'School Year';
                        }
                    } else {
                        if (e.col > 4 && e.col <= 12) {
                            headerContent = 'School Year';
                        }
                    }

                    if (headerContent.length > 0) {

                        s.columnHeaders.setCellData(e.row, e.col, headerContent);
                    }
                }

                if (e.row === 1) {

                    if (this.reportParameters.reportCategorySetCode === 'All') {

                        s.columnHeaders.setCellData(1, 4, this.getSchoolYear(0));
                        s.columnHeaders.setCellData(1, 5, this.getSchoolYear(0));

                        s.columnHeaders.setCellData(1, 6, this.getSchoolYear(1));
                        s.columnHeaders.setCellData(1, 7, this.getSchoolYear(1));

                        s.columnHeaders.setCellData(1, 8, this.getSchoolYear(2));
                        s.columnHeaders.setCellData(1, 9, this.getSchoolYear(2));
                        
                        s.columnHeaders.setCellData(1, 10, this.getSchoolYear(3));
                        s.columnHeaders.setCellData(1, 11, this.getSchoolYear(3));

                    } else {

                        s.columnHeaders.setCellData(1, 5, this.getSchoolYear(0));
                        s.columnHeaders.setCellData(1, 6, this.getSchoolYear(0));

                        s.columnHeaders.setCellData(1, 7, this.getSchoolYear(1));
                        s.columnHeaders.setCellData(1, 8, this.getSchoolYear(1));

                        s.columnHeaders.setCellData(1, 9, this.getSchoolYear(2));
                        s.columnHeaders.setCellData(1, 10, this.getSchoolYear(2));

                        s.columnHeaders.setCellData(1, 11, this.getSchoolYear(3));
                        s.columnHeaders.setCellData(1, 12, this.getSchoolYear(3));

                    }
                   
                }
            }


            this.mergeCols();
        }

    }

    mergeCols() {

        if (this.reportGrid !== undefined) {


        }
    }

    getReportFilter() {
        let filterText: string = this.reportParameters.reportCategorySet.categorySetName;
        filterText += ', SY ' + this.reportParameters.reportYear + ', Grade ' + this.reportParameters.reportGrade;
        return filterText;
    }

    getSchoolYear(priorYear: number) {
        let header = '';

        if (this.reportParameters.reportYear !== undefined) {

            let year = parseInt(this.reportParameters.reportYear.slice(0, this.reportParameters.reportYear.length - 3));

            if (priorYear === 0) { header = year.toString() + '-' + (year + 1).toString() + ' (Dropout Year)'; }
            else if (priorYear === 1) { header = (year - 1).toString() + '-' + year.toString(); }
            if (priorYear === 2) { header = (year - 2).toString() + '-' + (year - 1).toString(); }
            if (priorYear === 3) { header = (year - 3).toString() + '-' + (year - 2).toString(); }
        }

        return header;
    }

    getOrganizationHeader(headerType: string) {
        let header = '';

        if (headerType === 'name') {
            if (this.reportParameters.reportLevel === 'sea') { header = 'State Education Agency'; }
            else if (this.reportParameters.reportLevel === 'lea') { header = 'Local Education Agency'; }
            else if (this.reportParameters.reportLevel === 'sch') { header = 'School Name'; }
        }
        else {
            if (this.reportParameters.reportLevel === 'sea') { header = 'State Education Agency Identifier'; }
            else if (this.reportParameters.reportLevel === 'lea') { header = 'Local Education Agency Identifier'; }
            else if (this.reportParameters.reportLevel === 'sch') { header = 'School Identifier'; }
        }

        return header;
    }

    getOrganizationInformation() {
        let organizationInfo: string = '';
        let firstData: any;

        if (this.cvData.itemCount > 0) {
            firstData = this.cvData.items[0];
            organizationInfo = firstData.organizationName + ',' + firstData.organizationStateId;
        }

        if (this.reportParameters.reportLevel === 'lea' && this.reportParameters.reportLea === 'all') {
            organizationInfo = 'ALL';
        }
        else if (this.reportParameters.reportLevel === 'sch' && this.reportParameters.reportSchool === 'all') {
            organizationInfo = 'ALL';
        }

        return organizationInfo;
    }

    onloadedRows(grid:any) {
        let currentCategory: any;
        let matchingCategory: any;
        let currentCss: boolean = true;
        let previousCss: boolean = false;

        for (var i = 0; i < grid.rows.length; i++) {

            var row = grid.rows[i];
            var item = row.dataItem;
            currentCategory = item.category2;
                      
            //logic to set cssClass of app-alt to odd rows by subject (category2)
            if (currentCategory === 'Student Attendance Rate') {
                //do not set css
                currentCss = false;
                previousCss = false;
                //get the next category
                if (i < grid.rows.length) {
                    matchingCategory = grid.rows[i + 1].dataItem.category2;
                }
            }
            else if (currentCategory === matchingCategory) {
                currentCss = !previousCss;
            }
            else if (currentCategory !== matchingCategory) {
                //reset the matching category
                matchingCategory = currentCategory;
                previousCss = currentCss;
                currentCss = !previousCss;
            }

            if (currentCategory !== 'Student Attendance Rate' && currentCss === true) {

            }
            
        }
    }

}

