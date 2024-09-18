import { Component, Input, AfterViewInit, OnInit, OnChanges, SimpleChange, ViewChild, ViewChildren, QueryList, ElementRef, NgZone } from '@angular/core';
import { Router, ActivatedRoute, NavigationExtras } from '@angular/router';
import { GenerateReportService } from '../../services/app/generateReport.service';
import { GenerateReportDto } from '../../models/app/generateReportDto';
import { GenerateReportDataDto } from '../../models/app/generateReportDataDto';
import { GenerateReportParametersDto } from '../../models/app/generateReportParametersDto';
import { CategorySetDto } from '../../models/app/categorySetDto';
import { forkJoin } from 'rxjs'


import { Filter } from '../../models/app/categorySetDto'
import { CatToDisplay } from '../../models/app/categorySetDto';

declare var componentHandler: any;
declare var saveAs: any;
declare var alphanum: any;

@Component({
    selector: 'generate-app-leastudentsprofile',
    templateUrl: './leastudentsprofile.component.html',
    styleUrls: ['./leastudentsprofile.component.scss'],
    providers: [GenerateReportService]
})

export class LeaStudentsProfileComponent implements AfterViewInit, OnChanges, OnInit {

    public errorMessage: string;

    @Input() reportParameters: GenerateReportParametersDto;

    public currentReport: GenerateReportDto;
    public filters: Filter;
    public categoryOptions: string[];
    public subPopulation: string;
    public isLoading: boolean = false;
    public hasRecords: boolean = false;
    public showNoRecords: boolean = false;
    public reportDataDto: GenerateReportDataDto;
    public catToDisplay: CatToDisplay;
    private pageCount: number = 0;
    private pageArray: number[];
    private organizationLevel: string = '';
    public cvData: any;

    private _groupBy: string = '';
    private _filter: string = '';
    private _toFilter: any;

    @ViewChild('reportGraph', { static: false }) reportGraph: any;
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
            console.log(this.reportParameters);

            this.isLoading = true;
            this.showNoRecords = false;
            let take = 0;
            let skip = 0;
            this.organizationLevel = 'LEA';
            
            if (this.reportParameters.reportSort === undefined) {
                this.reportParameters.reportSort = 1;
            }
            if (this.reportParameters.reportCategorySetCode === 'lepstatus') {
                this.subPopulation = 'LEP Status';
            }
            else if (this.reportParameters.reportCategorySetCode === 'disability') {
                this.subPopulation = 'Disability (IDEA)';
            }
            else if (this.reportParameters.reportCategorySetCode === 'age') {
                this.subPopulation = 'Age';
            }
            else if (this.reportParameters.reportCategorySetCode === 'gender') {
                this.subPopulation = 'Gender';
            }
            else if (this.reportParameters.reportCategorySetCode === 'raceethnic') {
                this.subPopulation = 'Race/Ethnic';
            }
            else if (this.reportParameters.reportCategorySetCode === 'earlychildhood') {
                this.subPopulation = 'Educational Environment 3-5';
            }
            else if (this.reportParameters.reportCategorySetCode === 'schoolage') {
                this.subPopulation = 'Educational Environment 6-21';
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
            //debugger;
            this.reportParameters.reportCategorySet.categories = [];
            if (this.reportParameters.reportCategorySetCode === 'age') {
                    this.reportParameters.reportCategorySet.categories.push('Age');
                }
            else if (this.reportParameters.reportCategorySetCode === 'disability') {
                    this.reportParameters.reportCategorySet.categories.push('Disability (IDEA) Status');
                }
            else if (this.reportParameters.reportCategorySetCode === 'gender') {
                    this.reportParameters.reportCategorySet.categories.push('Sex (Membership)');
                }
            else if (this.reportParameters.reportCategorySetCode === 'raceethnic') {
                    this.reportParameters.reportCategorySet.categories.push('Racial Ethnic');
                }
            else if (this.reportParameters.reportCategorySetCode === 'lepstatus') {
                    this.reportParameters.reportCategorySet.categories.push('LEP Status (BOTH)');
                }
            else if (this.reportParameters.reportCategorySetCode === 'earlychildhood') {
                this.reportParameters.reportCategorySet.categories.push('Educational Environments-Preschool-Ages 3-5, only');
                }
            else if (this.reportParameters.reportCategorySetCode === 'schoolage') {
                this.reportParameters.reportCategorySet.categories.push('Educational Environments-School Age-Ages 6-21, only');
                }
            if (this.reportParameters.reportFilter !== 'select') {
                if (this.reportParameters.reportFilter === 'withage') {
                    this.reportParameters.reportCategorySet.categories.push('Age');
                }
                else if (this.reportParameters.reportFilter === 'withdisability') {
                    this.reportParameters.reportCategorySet.categories.push('Disability (IDEA) Status');
                }
                else if (this.reportParameters.reportFilter === 'withgender') {
                    this.reportParameters.reportCategorySet.categories.push('Sex (Membership)');
                }
                else if (this.reportParameters.reportFilter === 'withraceethnic') {
                    this.reportParameters.reportCategorySet.categories.push('Racial Ethnic');
                }
                else if (this.reportParameters.reportFilter === 'withlepstatus') {
                    this.reportParameters.reportCategorySet.categories.push('LEP Status (BOTH)');
                }
                else if (this.reportParameters.reportFilter === 'withearlychildhood') {
                    this.reportParameters.reportCategorySet.categories.push('Educational Environments-reschool-Ages 3-5, only');
                }
                else if (this.reportParameters.reportFilter === 'withschoolage') {
                    this.reportParameters.reportCategorySet.categories.push('Educational Environments-School Age-Ages 6-21, only');
                }
            }

            if (this.reportParameters.reportType !== undefined && this.reportParameters.reportCode !== undefined) {
                forkJoin(
                    this._generateReportService.getReportByCode(this.reportParameters.reportType, this.reportParameters.reportCode),
                    this._generateReportService.getDataQualityReport(this.reportParameters.reportType, this.reportParameters.reportCode, this.reportParameters.reportLevel, this.reportParameters.reportYear, categorySetCode, reportLea, reportSchool, this.reportParameters.reportFilter, null, this.reportParameters.organizationalIdList, null, this.reportParameters.reportSort, skip, take),
                    this._generateReportService.getCats(this.reportParameters.reportYear, this.reportParameters.reportLevel, this.reportParameters.reportCode, this.reportParameters.reportCategorySetCode),
                    this._generateReportService.geFilterByCode(this.reportParameters.reportFilter),
                    this._generateReportService.getFilterToDisplay(this.reportParameters.reportCategorySetCode)
                ).subscribe(data => {
                    this.currentReport = data[0];
                    this.reportDataDto = data[1];
                    this.categoryOptions = data[2];
                    this.filters = data[3];
                    this.catToDisplay = data[4];
                    this._groupBy = '';
                    this.cvData = this.reportDataDto.data;
                  
                    if (this.cvData.itemCount > 0) {
                        this.showNoRecords = false;
                    }
                    else {
                        this.showNoRecords = true;
                    }

                    if (this.reportParameters.reportCategorySet === undefined) {
                        if (this.reportDataDto.categorySets !== null && this.reportDataDto.categorySets.length > 0) {
                            this.reportParameters.reportCategorySet = this.getDefaultCategorySet(this.reportDataDto.categorySets);
                        }
                    }


                    this.cvData.sortComparer = function (a, b) {
                        if (a === 'MISSING') return 1;
                        if (b === 'MISSING') return -1;
                        if (a === 'MISSING' && b === 'MISSING') return 0;

                        return null;
                    };

                    //this.cvData.filter = this._filterFunction.bind(this);

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

                });
            }

        }

    }
    
    get removeSubmissionYear() {
       
        return this.reportParameters.reportCategorySet.categories.filter(x => x !== 'Submission Year');
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
        this.cvData.groupDescriptions.clear();
    }

    get filter(): string {
        return this._filter;
    }
    CurrentYear() {
        return this.categoryOptions[1];
    }
    PreviousYear() {
        return this.categoryOptions[0];
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
        s.rowHeaders.rows.defaultSize = 50;
        s.columnHeaders.rows.defaultSize = 120;

        setTimeout(function () {
            if (s.hostElement != null) {

                let row = s.columnHeaders.rows[0];
                row.wordWrap = true;
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

    setReportPage(event, reportPage: number) {
        if (this.reportParameters.reportPage !== reportPage) {
            this.reportParameters.reportPage = reportPage;
            this.populateReport();
        }
        return false;
    }

    export() {

        let self = this;
        let sheetName = this.reportParameters.reportCode.toUpperCase();
        let fileName = this.reportParameters.reportCode.toUpperCase() + ' - ' + this.reportParameters.reportYear + ' - ' + this.reportParameters.reportLevel.toUpperCase();

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

    clickedDataTab() {
        this.cvData = this.reportDataDto.data;
        if (this.reportGrid !== undefined) {
            this.reportGrid.invalidate();
        }

    }

    clickedGraphTab() {
        this.cvData = this.reportDataDto.data;
        if (this.reportGraph !== undefined) {
            this.reportGraph.invalidate();
        }
    }


    formatItemForGender(s, e) {

        e.cell.innerHTML = '<div style="top: 50%; white-space: pre-wrap; position: relative; transform: translateY(-50%);">' + e.cell.innerHTML + '</div>';

        if (s.columnHeaders.rows.length < 2) {
            s.columnHeaders.rows[0].allowMerging = true;
        }


        {
            if (e.row === 0) {
                let headerContent = '';
                if (this.reportParameters.reportFilter === 'withgender') {
                  if (e.col > 2 && e.col <= 4) {
                    headerContent = 'Male';
                    }
                else if (e.col > 4 && e.col <= 6) {
                    headerContent = 'Female';
                    }
                else if (e.col > 6 && e.col <= 8) {
                    headerContent = 'Total';
                    } 
                if (headerContent.length > 0) {
                    s.columnHeaders.setCellData(e.row, e.col, headerContent);
                    }
                }
                else if (this.reportParameters.reportFilter === 'withlepstatus') {
                    if (e.col > 2 && e.col <= 4) {
                        headerContent = 'LEP Students';
                    }
                    else if (e.col > 4 && e.col <= 6) {
                        headerContent = 'Non LEP Student';
                    }
                    else if (e.col > 6 && e.col <= 8) {
                        headerContent = 'Total';
                    }
                    if (headerContent.length > 0) {
                        s.columnHeaders.setCellData(e.row, e.col, headerContent);
                    }
                }                
            }
        }

        this.mergeHeader();

        if (s.columnFooters.rows.length < 1) {
        }

        s.columnFooters.setCellData(0, 0, 'Total');
        if (e.col > 0 && e.col < 19) {
            if (e.col % 2 == 0) {
                s.columnFooters.setCellData(0, e.col, '');
            }
        }
    }

    mergeHeader() {
        if (this.reportGrid !== undefined) {

        }
    }

    formatItemForRace(s, e) {

        e.cell.innerHTML = '<div style="top: 50%; white-space: pre-wrap; position: relative; transform: translateY(-50%);">' + e.cell.innerHTML + '</div>';

        if (s.columnHeaders.rows.length < 2) {
            s.columnHeaders.rows[0].allowMerging = true;
        }

        {
            if (e.row === 0) {
                let headerContent = '';
                    if (e.col > 2 && e.col <= 4) {
                        headerContent = 'American Indian or Alaska Native';
                    }
                    else if (e.col > 4 && e.col <= 6) {
                        headerContent = 'Asian';
                    }
                    else if (e.col > 6 && e.col <= 8) {
                        headerContent = 'Black or African American';
                }
                    else if (e.col > 8 && e.col <= 10) {
                        headerContent = 'Hispanic/Latino';
                }
                    else if (e.col > 10 && e.col <= 12) {
                        headerContent = 'Native Hawaiian or Other Pacific Islander';
                }
                    else if (e.col > 12 && e.col <= 14) {
                        headerContent = 'Two Or More Races';
                }
                    else if (e.col > 14 && e.col <= 16) {
                        headerContent = 'White';
                }
                    else if (e.col > 16 && e.col <= 18) {
                        headerContent = 'Total';
                    }
                    if (headerContent.length > 0) {
                        s.columnHeaders.setCellData(e.row, e.col, headerContent);
                    }

            }
        }

        this.mergeHeaderForRace();

        if (s.columnFooters.rows.length < 1) {
        }

        s.columnFooters.setCellData(0, 0, 'Total');
        if (e.col > 0 && e.col < 16) {
            if (e.col % 2 == 0) {
                s.columnFooters.setCellData(0, e.col, '');
            }
        }
    }

    mergeHeaderForRace() {
        if (this.reportGrid !== undefined) {


        }
    }

    formatItemForDisability(s, e) {

        e.cell.innerHTML = '<div style="top: 50%; white-space: pre-wrap; position: relative; transform: translateY(-50%);">' + e.cell.innerHTML + '</div>';

        if (s.columnHeaders.rows.length < 2) {
            s.columnHeaders.rows[0].allowMerging = true;
        }

        {
            if (e.row === 0) {
                let headerContent = '';
                if (e.col > 2 && e.col <= 4) {
                    headerContent = 'Autism';
                }
                else if (e.col > 4 && e.col <= 6) {
                    headerContent = 'Deaf-blindness';
                }
                else if (e.col > 6 && e.col <= 8) {
                    headerContent = 'Developmental Delay';
                }
                else if (e.col > 8 && e.col <= 10) {
                    headerContent = 'Emotional Disturbance';
                }
                else if (e.col > 10 && e.col <= 1) {
                    headerContent = 'Hearing Impairment';
                }
                else if (e.col > 12 && e.col <= 14) {
                    headerContent = 'Intellectual Disability';
                }
                else if (e.col > 14 && e.col <= 16) {
                    headerContent = 'Multiple Impairments';
                }
                else if (e.col > 16 && e.col <= 18) {
                    headerContent = 'Orthopedic Impairment';
                }
                else if (e.col > 18 && e.col <= 20) {
                    headerContent = 'Other Health Impairment';
                }
                else if (e.col > 20 && e.col <= 22) {
                    headerContent = 'Specific Learning Disability';
                }
                else if (e.col > 22 && e.col <= 24) {
                    headerContent = 'Speech or Language Impairment';
                }
                else if (e.col > 24 && e.col <= 26) {
                    headerContent = 'Traumatic Brain Injury';
                }
                else if (e.col > 26 && e.col <= 28) {
                    headerContent = 'Visual Impairment';
                }
                else if (e.col > 28 && e.col <= 30) {
                    headerContent = 'Total';
                }
                if (headerContent.length > 0) {
                    s.columnHeaders.setCellData(e.row, e.col, headerContent);
                }

            }
        }

        this.mergeHeaderForDisability();

        if (s.columnFooters.rows.length < 1) {
        }

        s.columnFooters.setCellData(0, 0, 'Total');
        if (e.col > 0 && e.col < 29) {
            if (e.col % 2 == 0) {
                s.columnFooters.setCellData(0, e.col, '');
            }
        }
    }
    mergeHeaderForDisability() {
        if (this.reportGrid !== undefined) {

        }
    }

    mergeHeaderForAge() {
        if (this.reportGrid !== undefined) {

        }
    }

    mergeHeaderForEarlyChildhoodWithAge() {
        if (this.reportGrid !== undefined) {

        }
    }

    formatItemForAge(s, e) {

        e.cell.innerHTML = '<div style="top: 50%; white-space: pre-wrap; position: relative; transform: translateY(-50%);">' + e.cell.innerHTML + '</div>';

        if (s.columnHeaders.rows.length < 2) {
            s.columnHeaders.rows[0].allowMerging = true;
        }

        {
            if (e.row === 0) {
                let headerContent = '';
                if (e.col > 2 && e.col <= 4) {
                    headerContent = 'Age 3';
                }
                else if (e.col > 4 && e.col <= 6) {
                    headerContent = 'Age 4';
                }
                else if (e.col > 6 && e.col <= 8) {
                    headerContent = 'Age 5';
                }
                else if (e.col > 8 && e.col <= 10) {
                    headerContent = 'Age 6';
                }
                else if (e.col > 10 && e.col <= 12) {
                    headerContent = 'Age 7';
                }
                else if (e.col > 12 && e.col <= 14) {
                    headerContent = 'Age 8';
                }
                else if (e.col > 14 && e.col <= 16) {
                    headerContent = 'Age 9';
                }
                else if (e.col > 16 && e.col <= 18) {
                    headerContent = 'Age 10';
                }
                else if (e.col > 18 && e.col <= 20) {
                    headerContent = 'Age 11';
                }
                else if (e.col > 20 && e.col <= 22) {
                    headerContent = 'Age 12';
                }
                else if (e.col > 22 && e.col <= 24) {
                    headerContent = 'Age 13';
                }
                else if (e.col > 24 && e.col <= 26) {
                    headerContent = 'Age 14';
                }
                else if (e.col > 26 && e.col <= 28) {
                    headerContent = 'Age 15';
                }
                else if (e.col > 28 && e.col <= 30) {
                    headerContent = 'Age 16';
                }
                else if (e.col > 30 && e.col <= 32) {
                    headerContent = 'Age 17';
                }
                else if (e.col > 32 && e.col <= 34) {
                    headerContent = 'Age 18';
                }
                else if (e.col > 34 && e.col <= 36) {
                    headerContent = 'Age 19';
                }
                else if (e.col > 36 && e.col <= 38) {
                    headerContent = 'Age 20';
                }
                else if (e.col > 38 && e.col <= 40) {
                    headerContent = 'Age 21';
                }
                else if (e.col > 40 && e.col <= 42) {
                    headerContent = 'Total';
                }
                if (headerContent.length > 0) {
                    s.columnHeaders.setCellData(e.row, e.col, headerContent);
                }

            }
        }

        this.mergeHeaderForAge();

        if (s.columnFooters.rows.length < 1) {

        }

        s.columnFooters.setCellData(0, 0, 'Total');
        if (e.col > 0 && e.col < 41) {
            if (e.col % 2 == 0) {
                s.columnFooters.setCellData(0, e.col, '');
            }
        }
    }
    formatItemForSchoolAge(s, e) {
        e.cell.innerHTML = '<div style="top: 50%; white-space: pre-wrap; position: relative; transform: translateY(-50%);">' + e.cell.innerHTML + '</div>';
        if (s.columnHeaders.rows.length < 2) {
            s.columnHeaders.rows[0].allowMerging = true;
        }
 
        {
            if (e.row === 0) {
                let headerContent = '';
                 if (e.col > 2 && e.col <= 4) {
                    headerContent = 'Homebound/Hospital';
                }
                else if (e.col > 4 && e.col <= 6) {
                    headerContent = 'Inside regular class 40% through 79% of the day';
                }
                else if (e.col > 6 && e.col <= 8) {
                    headerContent = 'Inside regular class 80% or more of the day';
                }
                else if (e.col > 8 && e.col <= 10) {
                    headerContent = 'Inside regular class less than 40% of the day';
                }
                else if (e.col > 10 && e.col <= 12) {
                    headerContent = 'Parentally Placed in Private Schools';
                }
                else if (e.col > 12 && e.col <= 14) {
                    headerContent = 'Residential Facility';
                }
                else if (e.col > 14 && e.col <= 16) {
                    headerContent = 'Separate School';
                }
                else if (e.col > 16 && e.col <= 18) {
                    headerContent = 'Total';
                }
                 else if (e.col > 18 && e.col <= 20) {
                     headerContent = 'Correctional Facility';
                 }

                if (headerContent.length > 0) {
                    s.columnHeaders.setCellData(e.row, e.col, headerContent);
                }

            }
        }

        this.mergeHeaderForSchoolAge();

        if (s.columnFooters.rows.length < 1) {
        }

        s.columnFooters.setCellData(0, 0, 'Total');
        if (e.col > 0 && e.col < 19) {
            if (e.col % 2 == 0) {
                s.columnFooters.setCellData(0, e.col, '');
            }
        }
    }


    formatItemForEarlychildhoodWithAge(s, e) {

        e.cell.innerHTML = '<div style="top: 50%; white-space: pre-wrap; position: relative; transform: translateY(-50%);">' + e.cell.innerHTML + '</div>';

        if (s.columnHeaders.rows.length < 2) {
            s.columnHeaders.rows[0].allowMerging = true;
        }

        {
            if (e.row === 0) {
                let headerContent = '';
                if (e.col > 2 && e.col <= 4) {
                    headerContent = 'Age 3';
                }
                else if (e.col > 4 && e.col <= 6) {
                    headerContent = 'Age 4';
                }
                else if (e.col > 6 && e.col <= 8) {
                    headerContent = 'Age 5';
                }

                else if (e.col > 8 && e.col <= 10) {
                    headerContent = 'Total';
                }
                if (headerContent.length > 0) {
                    s.columnHeaders.setCellData(e.row, e.col, headerContent);
                }

            }
        }

        this.mergeHeaderForEarlyChildhoodWithAge();

        if (s.columnFooters.rows.length < 1) {
        }

        s.columnFooters.setCellData(0, 0, 'Total');
        if (e.col > 0 && e.col < 8) {
            if (e.col % 2 == 0) {
                s.columnFooters.setCellData(0, e.col, '');
            }
        }
    }




    formatItemForEarlyChildhood(s, e) {
        e.cell.innerHTML = '<div style="top: 50%; white-space: pre-wrap; position: relative; transform: translateY(-50%);">' + e.cell.innerHTML + '</div>';
        if (s.columnHeaders.rows.length < 2) {
            s.columnHeaders.rows[0].allowMerging = true;
        }

        {
            if (e.row === 0) {
                let headerContent = '';
                if (e.col > 2 && e.col <= 4) {
                    headerContent = 'Home';
                }
                else if (e.col > 4 && e.col <= 6) {
                    headerContent = 'Attend regular early childhood program less than 10 hours a week and receive the majority of services in some other location';
                }
                else if (e.col > 6 && e.col <= 8) {
                    headerContent = 'Attend regular early childhood program less than 10 hours a week and receive the majority of services in that location';
                }
                else if (e.col > 8 && e.col <= 10) {
                    headerContent = 'Attend regular early childhood program at least 10 hours a week and receive the majority of services in some other location';
                }
                else if (e.col > 10 && e.col <= 12) {
                    headerContent = 'Attend regular early childhood program at least 10 hours a week and receive the majority of services in that location';
                }
                else if (e.col > 12 && e.col <= 14) {
                    headerContent = 'Residential Facility';
                }
                else if (e.col > 14 && e.col <= 16) {
                    headerContent = 'Separate Class';
                }
                else if (e.col > 16 && e.col <= 18) {
                    headerContent = 'Service Provider Location';
                }
                else if (e.col > 18 && e.col <= 20) {
                    headerContent = 'Separate School';
                }
                else if (e.col > 20 && e.col <= 22) {
                    headerContent = 'Total';
                }
                if (headerContent.length > 0) {
                    s.columnHeaders.setCellData(e.row, e.col, headerContent);
                }

            }
        }

        this.mergeHeaderForEarlyChildhood();

        if (s.columnFooters.rows.length < 1) {
        }

        s.columnFooters.setCellData(0, 0, 'Total');
        if (e.col > 0 && e.col < 21) {
            if (e.col % 2 == 0) {
                s.columnFooters.setCellData(0, e.col, '');
            }
        }
    }



    mergeHeaderForSchoolAge() {
        if (this.reportGrid !== undefined) {

        }
    }

    mergeHeaderForEarlyChildhood() {
        if (this.reportGrid !== undefined) {

        }
    }


    formatItemss(s, e) {

        if (s.columnFooters.rows.length < 1) {
        }

        s.columnFooters.setCellData(0, 0, 'Total');
        if (e.col > 0 && e.col < 21) {
            if (e.col % 2 == 0) {
                s.columnFooters.setCellData(0, e.col, '');
            }
        }
    }

    formatItemSchoolAgewithAge(s, e) {

        e.cell.innerHTML = '<div style="top: 50%; white-space: pre-wrap; position: relative; transform: translateY(-50%);">' + e.cell.innerHTML + '</div>';

        if (s.columnHeaders.rows.length < 2) {
            s.columnHeaders.rows[0].allowMerging = true;
        }


        {
            if (e.row === 0) {
                let headerContent = '';
                if (e.col > 2 && e.col <= 4) {
                    headerContent = 'Age 6';
                }
                else if (e.col > 4 && e.col <= 6) {
                    headerContent = 'Age 7';
                }
                else if (e.col > 6 && e.col <= 8) {
                    headerContent = 'Age 8';
                }
                else if (e.col > 8 && e.col <= 10) {
                    headerContent = 'Age 9';
                }
                else if (e.col > 10 && e.col <= 12) {
                    headerContent = 'Age 10';
                }
                else if (e.col > 12 && e.col <= 14) {
                    headerContent = 'Age 11';
                }
                else if (e.col > 14 && e.col <= 16) {
                    headerContent = 'Age 12';
                }
                else if (e.col > 16 && e.col <= 18) {
                    headerContent = 'Age 13';
                }
                else if (e.col > 18 && e.col <= 20) {
                    headerContent = 'Age 14';
                }
                else if (e.col > 20 && e.col <= 22) {
                    headerContent = 'Age 15';
                }
                else if (e.col > 22 && e.col <= 24) {
                    headerContent = 'Age 16';
                }
                else if (e.col > 24 && e.col <= 26) {
                    headerContent = 'Age 17';
                }
                else if (e.col > 26 && e.col <= 28) {
                    headerContent = 'Age 18';
                }
                else if (e.col > 28 && e.col <= 30) {
                    headerContent = 'Age 19';
                }
                else if (e.col > 30 && e.col <= 32) {
                    headerContent = 'Age 20';
                }
                else if (e.col > 32 && e.col <= 34) {
                    headerContent = 'Age 21';
                }
                else if (e.col > 34 && e.col <= 36) {
                    headerContent = 'Total';
                }
                if (headerContent.length > 0) {
                    s.columnHeaders.setCellData(e.row, e.col, headerContent);
                }

            }
        }

        this.mergeHeaderForSchoolagewithAge();

        if (s.columnFooters.rows.length < 1) {
        }

        s.columnFooters.setCellData(0, 0, 'Total');
        if (e.col > 0 && e.col < 34) {
            if (e.col % 2 == 0) {
                s.columnFooters.setCellData(0, e.col, '');
            }
        }
    }
    mergeHeaderForSchoolagewithAge() {
        if (this.reportGrid !== undefined) {

        }
    }

}

