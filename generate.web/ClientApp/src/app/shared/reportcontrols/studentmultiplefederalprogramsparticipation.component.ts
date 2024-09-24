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
    selector: 'generate-app-studentmultiplefederalprogramsparticipation',
    templateUrl: './studentmultiplefederalprogramsparticipation.component.html',
    styleUrls: ['./studentmultiplefederalprogramsparticipation.component.scss'],
    providers: [GenerateReportService]
})

export class MultipleFederalProgramsParticipationComponent implements AfterViewInit, OnChanges, OnInit {

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

    private graphActive: boolean

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

        if(this.reportParameters.reportLevel === 'sea') {
            this.graphActive = true
        } else {
            this.graphActive = false
        }
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
                categorySetCode = 'CatSetA';
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
                    this._generateReportService.getStateReport(this.reportParameters.reportType, this.reportParameters.reportCode, this.reportParameters.reportLevel, this.reportParameters.reportYear, categorySetCode, reportLea, reportSchool, this.reportParameters.reportFilter, this.reportParameters.reportSubFilter, null, null, this.reportParameters.reportSort, skip, take)
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

                    this.convertHeaders()


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

    convertHeaders() {

        for(let i = 0; i < this.reportDataDto.data.length; i++) {

            if(this.reportDataDto.data[i].category1 === "FOSTERCARE") {
                this.reportDataDto.data[i].category1 = "Foster Care"
            } else if(this.reportDataDto.data[i].category1 === "IMMIGNTTTLIII") {
                this.reportDataDto.data[i].category1 = "Immigrant Title III"
            } else if(this.reportDataDto.data[i].category1 === "FL") {
                this.reportDataDto.data[i].category1 = "Free and Reduced Lunch"
            } else if(this.reportDataDto.data[i].category1 === "CTEPART") {
                this.reportDataDto.data[i].category1 = "CTE"
            } else if(this.reportDataDto.data[i].category1 === "HOMELSENRL") {
                this.reportDataDto.data[i].category1 = "Homeless"
            } else if(this.reportDataDto.data[i].category1 === "SECTION504") {
                this.reportDataDto.data[i].category1 = "504"
            } else if(this.reportDataDto.data[i].category1 === "MS") {
                this.reportDataDto.data[i].category1 = "Migrant"
            } else if(this.reportDataDto.data[i].category1 === "TITLE1SCHOOLSTATUS") {
                this.reportDataDto.data[i].category1 = "Title 1"
            }
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
        this.cvData = this.reportDataDto.data;
        if (this.reportGraph !== undefined) {
            this.reportGraph.invalidate();
        }
    }

    initializeGraph(s, e) {
        if (s !== undefined) {
            s.tooltip.content = null
            s.options = {
                groupWidth: '50%'
            }
        }
    }

    formatItem(s, e) {
        e.cell.innerHTML = '<div style="top: 50%; white-space: pre-wrap; position: relative; transform: translateY(-50%);">' + e.cell.innerHTML + '</div>';
    }

    getReportFilter() {
        let filterText: string = '';
        if (this.reportParameters.reportFilter !== undefined) {
            if (this.reportParameters.reportFilter == 'AllStudents') {
                filterText = '';
            } else if (this.reportParameters.reportFilter == 'SWD') {
                filterText = 'Students With Disabilities';
            } else if (this.reportParameters.reportFilter == 'SWOD') {
                filterText = 'Students Without Disabilities';
            }
        }

        return filterText;
    }

    isGraphVisible() {

        let canViewGraph: boolean = false;
        if (this.reportParameters.reportLevel === 'lea') {
            if (this.reportParameters.reportLea !== 'all') {
                canViewGraph = true;
            }
        } else if (this.reportParameters.reportLevel === 'sch') {
            if (this.reportParameters.reportSchool !== 'all') {
                canViewGraph = true;
            }
        } else {
            canViewGraph = this.currentReport.showGraph;
        }

        return canViewGraph;
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
            if (this.reportParameters.reportFilter == 'AllStudents') {
                filterText = filterText + 'All Students';
            } else {
                filterText = filterText + this.reportParameters.reportFilter;
            }
        }

        let header = this.reportDataDto.reportTitle + ' - ' + this.reportParameters.reportLevel.toUpperCase() + ' Level, ' + this.reportParameters.reportYear;
        if (organizationInfo.length > 0) {
            header += ' - ' + organizationInfo;
        }
        header += ' - ' + filterText;

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


}
