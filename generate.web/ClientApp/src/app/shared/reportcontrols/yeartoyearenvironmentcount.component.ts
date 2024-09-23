import { Component, Input, AfterViewInit, OnInit, OnChanges, SimpleChange, ViewChild, ViewChildren, QueryList, NgZone } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { GenerateReportService } from '../../services/app/generateReport.service';
import { GenerateReportDto } from '../../models/app/generateReportDto';
import { GenerateReportDataDto } from '../../models/app/generateReportDataDto';
import { GenerateReportParametersDto } from '../../models/app/generateReportParametersDto';
import { CategorySetDto } from '../../models/app/categorySetDto';
import { Categoriess } from '../../models/app/categorySetDto';
import { forkJoin } from 'rxjs'


declare let componentHandler: any;

@Component({
    selector: 'generate-app-yeartoyearenvironmentcount',
    templateUrl: './yeartoyearenvironmentcount.component.html',
    styleUrls: ['./yeartoyearenvironmentcount.component.scss'],
    providers: [GenerateReportService]
})

export class YearToYearEnvironmentCountComponent implements AfterViewInit, OnChanges, OnInit {

    public errorMessage: string;

    @Input() reportParameters: GenerateReportParametersDto;

    public currentReport: GenerateReportDto;
    public categ: Categoriess[];
    public categoryOptions: string[];
    public isLoading: boolean = false;
    public hasRecords: boolean = false;
    public showNoRecords: boolean = false;
    public reportDataDto: GenerateReportDataDto;

    private pageCount: number = 0;
    private pageArray: number[];

    public cvData: any;
    public head: any;
    private _groupBy: string = '';
    private organizationLevel: string = '';
    private _filter: string = '';
    private _toFilter: any;
    private dp: any;
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
        this.categ = [];

        if (this.reportParameters.reportType !== undefined
            && this.reportParameters.reportCode !== undefined
            && this.reportParameters.reportLevel !== undefined
            && this.reportParameters.reportYear !== undefined) {

            this.isLoading = true;
            this.showNoRecords = false;
            let take = 0;
            let skip = 0;
            if (this.reportParameters.reportLevel.toLowerCase() === 'sea') {
                this.organizationLevel = 'SEA';
            } else if (this.reportParameters.reportLevel.toLowerCase() === 'lea') {
                this.organizationLevel = 'LEA';
            } else {
                this.organizationLevel = 'School';
            }

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
                    this._generateReportService.getDataQualityReport(this.reportParameters.reportType, this.reportParameters.reportCode, this.reportParameters.reportLevel, this.reportParameters.reportYear, categorySetCode, reportLea, reportSchool, null, null, this.reportParameters.organizationalIdList, null, this.reportParameters.reportSort, skip, take),
                    this._generateReportService.getCats(this.reportParameters.reportYear, this.reportParameters.reportLevel, this.reportParameters.reportCode, this.reportParameters.reportCategorySetCode)
                ).subscribe(data => {

                    this.currentReport = data[0];
                    this.reportDataDto = data[1];
                    this.categoryOptions = data[2];
                    this._groupBy = 'organizationName';


                    this.cvData = this.reportDataDto.data;
                    this.cvData.groupDescriptions.push('organizationName');
                    if (this.reportParameters.reportCategorySetCode === 'all') {
                        this.cvData.groupDescriptions.push('categorySetCode');
                    }
                    this.head = this.categ;
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


                    if (this.reportDataDto === null) {
                        this.errorMessage = 'Invalid Report';
                    } else {

                        this.pageCount = Math.ceil(this.reportDataDto.dataCount / +this.reportParameters.reportPageSize);

                        this.setPageArray();

                        if (this.cvData.itemCount > 0) {
                            this.hasRecords = true;
                        }
                        else if (this.reportDataDto.dataCount === -1) {
                            this.hasRecords = true;
                        }
                        else {
                            this.hasRecords = false;
                        }
                    }

                    this.isLoading = false;

                });
            }

        }

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
    CurrentYear() {
        return this.categoryOptions[1];
    }
    PreviousYear() {
        return this.categoryOptions[0];
    }

    setArrow(item: string, item2: string) {
        let itm = parseFloat(item);
        let itm2 = parseFloat(item2);
        if (itm > 20 && itm2 > 0.2) {
            return 'fa-arrow-up';
        } else if (itm < -20 && itm2 < -0.2) {
            return 'fa-arrow-down';
        }
    }

    getItem(index: string, grid: boolean, subgrid: boolean) {
        let expandedRow;
        if (grid && !subgrid) {
            expandedRow = index;

            return this.cvData;
        }
    }


    checkZero(item: string) {
        let itm = parseFloat(item);
        if (itm === 0) {
            return false;
        }

        else {
            return true;
        }
    }

    setColor(item: string, item2: string) {
        let itm = parseFloat(item);
        let itm2 = parseFloat(item2);
        if (itm > 20 && itm2 > 0.2) {
            return 'orange';
        }
        else if (itm < -20 && itm2 < -0.2) {
            return 'red';
        }
        else {
            return 'black';
        }
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
            s.dataLabel.content = "{y}";

        }
    }

    formatItem(args) {
        let a = args.row;
        let b = args.col;
        let cellVal = args.xlsxCell;
        let group =  args.panel.rows[a].dataItem;
        if (group && group.level == 0) {
            if (b === 3) {
                cellVal.value = 'All Environments';
            }
        }
        if (group && group.level == 1) {
            if (b === 3) {
                cellVal.value = '';
            }
            if (b === 2) {
                cellVal.value = '';
            }
            if (b === 1) {
                cellVal.value = '';
            }
        }


        if (parseInt(args.col) === 4) {
            if (a !== undefined) {
                localStorage.setItem('col_1', cellVal.value);
            }
        }
        else if (b === 5) {
            if (a !== undefined) {
                localStorage.setItem('col_2', cellVal.value);
            }
        }
        if (b === 7) {
            if (cellVal.value == '% Change') {
                localStorage.removeItem('col_2');
                localStorage.removeItem('col_1');
            }
            else if (a !== undefined && b != undefined) {
                let x = parseInt(localStorage.getItem('col_1'));
                let y = parseInt(localStorage.getItem('col_2'));
                x !== 0 ? cellVal.value = (y - x) / x : cellVal.value = 0;
                localStorage.removeItem('col_2');
                localStorage.removeItem('col_1');

            }
        }
    }


    getGraphHeader() {

        let organizationInfo: string = '';
        let categoryset: string = '';

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

        if (this.reportParameters.reportCategorySet !== undefined) {

            if (this.reportParameters.reportCategorySet.categories.length > 0) {
                for (let i = 0; i < this.reportParameters.reportCategorySet.categories.length; i++) {
                    if (i > 0) {
                        categoryset += ', ';
                    }
                    categoryset += this.reportParameters.reportCategorySet.categories[i];
                }
            }

            //categoryset = categoryset;
        }

        let header = this.reportDataDto.reportTitle + ' - ' + this.reportParameters.reportLevel.toUpperCase() + ' Level, ' + this.reportParameters.reportYear;
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

    gotoConnectionLink() {
        if (this.reportParameters.connectionLink !== undefined && this.reportParameters.connectionLink.length > 0) {
            this._router.navigateByUrl(this.reportParameters.connectionLink);
        }
        else {
            let snackbarContainer = document.querySelector('#generate-app__message');
            let data = { message: 'Connection is not available for this report.' };
            snackbarContainer['MaterialSnackbar'].showSnackbar(data);
        }
        return false;
    }

    get removeSubmissionYear() {
        return this.reportParameters.reportCategorySet.categories.filter(x => x !== 'Submission Year');
    }

    calculatePercentageDifference(s, e) {
        if (e.panel == s.cells) {
            let row = s.rows[e.row];
            let col = s.columns[e.col];
            let tot = 0;
            let group = null;
            if (group && group.level == 0 && col.binding == 'category1') {
                e.cell.textContent = col.format !== undefined? col.format : 'All Environments';
            }
            if (group && group.level == 1 && col.binding == 'category1') {
                e.cell.textContent = col.format;
            }

            if (group && group.level == 1 && col.binding == 'organizationStateId') {
                e.cell.textContent =  col.format;
            }
            if (group && col.binding == 'col_4') {
                let tot2 = 0;
                for (let i = 0; i < group.items.length; i++) {
                    tot2 += group.items[i].col_1;
                }
                let tot3 = 0;
                for (let i = 0; i < group.items.length; i++) {
                    tot3 += group.items[i].col_2;
                }

                tot2 !== 0 ? tot = (tot3 - tot2) / tot2 : tot = 0;
                e.cell.textContent = col.format !== undefined ? col.format : tot;  
            }
        }
    }

}
