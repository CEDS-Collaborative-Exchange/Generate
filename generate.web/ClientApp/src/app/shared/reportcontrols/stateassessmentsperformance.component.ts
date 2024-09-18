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
import { PerformanceLevelService } from '../../services/ods/performancelevel.service';
import { PerformanceLevelDto } from '../../models/ods/performanceLevelDto';
import { forkJoin } from 'rxjs'



declare var componentHandler: any;
declare var alphanum: any;

@Component({
    selector: 'generate-app-stateassessmentsperformance',
    templateUrl: './stateassessmentsperformance.component.html',
    styleUrls: ['./stateassessmentsperformance.component.scss'],
    providers: [GenerateReportService, PerformanceLevelService]
})

export class StateAssessmentsPerformanceComponent implements AfterViewInit, OnChanges, OnInit {

    public errorMessage: string;

    @Input() reportParameters: GenerateReportParametersDto;

    public currentReport: GenerateReportDto;

    public isLoading: boolean = false;
    public hasRecords: boolean = false;
    public reportDataDto: GenerateReportDataDto;
    public performanceLevels: PerformanceLevelDto[];
    
    private pageCount: number = 0;
    private pageArray: number[];

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
        private _performanceLevelService: PerformanceLevelService,
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

            if (this.reportParameters.reportType !== undefined && this.reportParameters.reportCode !== undefined) {
                forkJoin(
                    this._generateReportService.getReportByCode(this.reportParameters.reportType, this.reportParameters.reportCode),
                    this._generateReportService.getStateReport(this.reportParameters.reportType, this.reportParameters.reportCode, this.reportParameters.reportLevel, this.reportParameters.reportYear, categorySetCode, reportLea, reportSchool, this.reportParameters.reportFilter, this.reportParameters.reportSubFilter, null, this.reportParameters.reportGrade, this.reportParameters.reportSort, skip, take),
                    this._performanceLevelService.getAll()
                ).subscribe(data => {
                    this.currentReport = data[0];
                    this.reportDataDto = data[1];
                    this.performanceLevels = data[2];

                    this.cvData = this.getGraphCategories();
                   

                    // Get new category set
                    if (this.reportParameters.reportCategorySet === undefined) {
                        if (this.reportDataDto.categorySets !== null && this.reportDataDto.categorySets.length > 0) {
                            this.reportParameters.reportCategorySet = this.getDefaultCategorySet(this.reportDataDto.categorySets);
                        }
                    }


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

        s.rowHeaders.rows.defaultSize = 50;
        s.columnHeaders.rows.defaultSize = 120;


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

        let self = this;
        let sheetName = this.reportParameters.reportCode.toUpperCase();
        let fileName = this.reportParameters.reportCode.toUpperCase() + ' - ' + this.reportParameters.reportYear + ' - ' + this.reportParameters.reportLevel.toUpperCase();


    }

    exportGraph() {

        let self = this;
        let sheetName = this.reportParameters.reportCode.toUpperCase();
        let fileName = this.reportParameters.reportCode.toUpperCase() + ' - ' + this.reportParameters.reportYear + ' - ' + this.reportParameters.reportLevel.toUpperCase();

        if (this.reportGraph !== undefined) {
            fileName = fileName + ".png";
            this.reportGraph.saveImageToFile(fileName);

        }

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

    clickedDataTab() {
        this.cvData = this.reportDataDto.data;
        if (this.reportGrid !== undefined) {
            this.reportGrid.invalidate();
        }

    }

    clickedGraphTab() {
        this.cvData = this.getGraphCategories()

        if (this.reportGraph !== undefined) {
            this.reportGraph.invalidate();
        }
    }

    getGraphCategories() {
        let graphData = this.reportDataDto.data;

    }


    initializeGraph(s, e) {
        if (s !== undefined) {


        }
    }
    

    formatItem(s, e) {

        let isHeaderRow: boolean = false;

        {
            if (e.row === 0) { isHeaderRow = true; }
            if (this.reportParameters.reportCategorySetCode === 'All') {
                if (e.row === 4 || e.row === 13) { isHeaderRow = true; }
            } else if (this.reportParameters.reportCategorySetCode === 'WDIS') {
                if (e.row === 14 || e.row === 23) { isHeaderRow = true; }
            } else {
                if (e.row === 9 || e.row === 12) { isHeaderRow = true; }
            }

             if (isHeaderRow) {
                if (e.col === 1) {
                    e.cell.innerHTML = '<b>' + e.cell.innerHTML + '</b>';
                }
                if (e.col > 1) {
                    e.cell.innerHTML = '';
                }
                else {
                    e.cell.innerHTML = '<div style="top: 50%; white-space: pre-wrap; position: relative; transform: translateY(-50%);">' + e.cell.innerHTML + '</div>';
                }
            } else {
                e.cell.innerHTML = '<div style="top: 50%; white-space: pre-wrap; position: relative; transform: translateY(-50%);">' + e.cell.innerHTML + '</div>';
            }
        }
    }

    getReportFilter() {
        let filterText: string = '';
        if (this.reportParameters.reportCategorySetCode !== undefined) {
            if (this.reportParameters.reportCategorySetCode == 'All') {
                filterText = 'All Students';
            } else if (this.reportParameters.reportCategorySetCode == 'WDIS') {
                filterText = 'Students With Disabilities';
            } else if (this.reportParameters.reportCategorySetCode == 'WODIS') {
                filterText = 'Students Without Disabilities';
            }
        }
        let subFilterName = this.currentReport.reportFilterOptions.filter(option => { return option.filterCode === this.reportParameters.reportSubFilter })[0].filterName;

        filterText += ', ' + this.reportParameters.reportFilter + ', ' + subFilterName + ', ' + this.reportParameters.reportGrade;
        return filterText;
    }


    getGraphHeader() {

        let organizationInfo: string = '';
        let filterText: string = '';

        if (this.cvData !== undefined) {
            if (this.reportParameters.reportLevel === 'lea' && this.reportParameters.reportLea === 'all') {
                organizationInfo = 'All LEAs';
            } else if (this.reportParameters.reportLevel === 'sch' && this.reportParameters.reportSchool === 'all') {
                organizationInfo = 'All Schools';
            } else {
                let item = this.cvData.items[0];
                if (item !== undefined) {
                    organizationInfo = item.organizationName + ', ' + item.organizationStateId;
                }
            }
        }

        if (this.reportParameters.reportFilter !== undefined) {
            filterText = this.getReportFilter();
        }

        let header = '';
        let headerLine1 = '';
        if (organizationInfo.length > 0) {
            headerLine1 = "<tspan x='250'>" + this.reportDataDto.reportTitle + " - " + this.reportParameters.reportLevel.toUpperCase() + " Level, " + this.reportParameters.reportYear + " - " + organizationInfo + "</tspan>";
        } else {
            headerLine1 = "<tspan x='250'>" + this.reportDataDto.reportTitle + " - " + this.reportParameters.reportLevel.toUpperCase() + " Level, " + this.reportParameters.reportYear + "</tspan>";
        }

        let headerline2 = "<tspan x='250' dy='1.4em'>" + filterText + "</tspan>";

        header = headerLine1 + headerline2;

        return header;
    }

    getGraphFooter() {
        let footer: string = '';
        if (this.reportParameters.connectionLink !== undefined && this.reportParameters.connectionLink.length > 0) {

            footer = 'For report methodology, see ' + this.reportParameters.connectionLink + '.';
        }

        footer += ' Report Created On: ' + new Date().toDateString();

        return footer;
    }

    getPerformanceHeader(prefix, label, suffix) {
            let header: string = '';
            header = prefix + ' (' + label + ') ' + suffix;
            return header;
    }


}
