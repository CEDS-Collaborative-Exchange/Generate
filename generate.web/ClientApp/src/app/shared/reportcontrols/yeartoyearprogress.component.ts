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


declare let componentHandler: any;
declare let alphanum: any;

@Component({
    selector: 'generate-app-yeartoyearprogress',
    templateUrl: './yeartoyearprogress.component.html',
    styleUrls: ['./yeartoyearprogress.component.scss'],
    providers: [GenerateReportService]
})

export class YeartoYearProgressComponent implements AfterViewInit, OnChanges, OnInit {

    public errorMessage: string;

    @Input() reportParameters: GenerateReportParametersDto;

    public currentReport: GenerateReportDto;

    public isLoading: boolean = false;
    public hasRecords: boolean = false;
    public reportDataDto: GenerateReportDataDto;

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

        //console.log('populate');

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

            if (s.columnHeaders.rows.length < 2) {
                s.columnHeaders.rows[0].allowMerging = true;
            }

            {
                if (e.row === 0) {

                    let headerContent = '';

                    if (this.reportParameters.reportCategorySetCode === 'All') {

                        if (e.col > 2 && e.col <= 6) {
                            headerContent = 'School Year';
                        }
                    } else {
                        if (e.col > 3 && e.col <= 7) {
                            headerContent = 'School Year';
                        }
                    }

                    if (headerContent.length > 0) {

                        s.columnHeaders.setCellData(e.row, e.col, headerContent);
                    }
                }
            }

            this.mergeCols();

            if (s.columnFooters.rows.length < 2) {
            }

            //Calculate Totals
            this.calculateProficientTotals(s)

            // s.columnFooters.setCellData(0, 1, 'Total');
            //if (e.col > 1 && e.col < 6) {
            //        s.columnFooters.setCellData(0, e.col, '');
            //}
        }

    }

    calculateProficientTotals(s) {
        let data = this.reportDataDto.data  //Report Data
        let columnNames = ["col_1", "col_2", "col_3", "col_4"]  //Names of the columns inside the data object
        let proficientTotals = []   //Array of sum of proficient students per school year
        let belowProficientTotals = []  //Array of sum of non-proficient students per school year
        let totalLabelIndex = 2 //Column Index where the totals label will go

        //Check if we have an extra category so we can put the label in the right spot
        if (data[0].category1 != data[0].reportFilter) {
            totalLabelIndex = 3
        }

        //Set the footers
        s.columnFooters.setCellData(0, totalLabelIndex, 'Below Proficient Total')
        s.columnFooters.setCellData(1, totalLabelIndex, 'Proficient Total')

        //For each entry in the data object
        for (let dataIndex = 0; dataIndex < data.length; dataIndex++) {

            //For each column inside each data entry
            for (let columnNameIndex = 0; columnNameIndex < columnNames.length; columnNameIndex++) {

                //Check if data exists inside the column, if not, we have reached the end of the data and can break
                if (data[dataIndex][columnNames[columnNameIndex]] != null) {

                    //Push a 0 into the totals arrays if we are on a new column and an entry in the totals does not exist
                    if (proficientTotals[columnNameIndex] == undefined) {
                        proficientTotals.push(0)
                    }
                    if (belowProficientTotals[columnNameIndex] == undefined) {
                        belowProficientTotals.push(0)
                    }

                    //Check if we need to add to the proficient or below proficient total
                    if (data[dataIndex].reportFilter === "Below Proficient") {

                        belowProficientTotals[columnNameIndex] += data[dataIndex][columnNames[columnNameIndex]]

                    } else {

                        proficientTotals[columnNameIndex] += data[dataIndex][columnNames[columnNameIndex]]
                    }

                } else {

                    break
                }
            }
        }

        //The data comes in reversed so we have to set it back
        belowProficientTotals.reverse()
        proficientTotals.reverse()

        //Set the totals in the footers
        for (let i = 0; i < proficientTotals.length; i++) {

            s.columnFooters.setCellData(0, totalLabelIndex + 1 + i, belowProficientTotals[i])
            s.columnFooters.setCellData(1, totalLabelIndex + 1 + i, proficientTotals[i])
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

            if (priorYear === 0) { header = this.reportParameters.reportYear; }
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

}

