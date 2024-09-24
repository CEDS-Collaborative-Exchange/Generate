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

declare let componentHandler: any;
declare let alphanum: any;

@Component({
    selector: 'generate-app-disciplinaryremovals',
    templateUrl: './disciplinaryremovals.component.html',
    styleUrls: ['./disciplinaryremovals.component.scss'],
    providers: [GenerateReportService]
})

export class DisciplinaryRemovalsComponent implements AfterViewInit, OnChanges, OnInit {

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
        if (this.reportParameters.reportCategorySetCode === 'exitingspeceducation') {
            s.columns.defaultSize = 150;
            s.rows.defaultSize = 100;
        }


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
        // let cellId: string = 'generate-app-federalprogram-header';
        // e.cell.innerHTML = '<div id="' + cellId + '">' + e.cell.innerHTML + '</div>';
        e.cell.innerHTML = '<div style="top: 50%; white-space: pre-wrap; position: relative; transform: translateY(-50%);">' + e.cell.innerHTML + '</div>';

        if (s !== undefined) {

            if (s.columnHeaders.rows.length < 3) {

                s.allowMerging = 'ColumnHeaders';


                //let headerRow: wjGrid.Row = new wjGrid.Row();
                //s.columnHeaders.rows.push(headerRow);
                //let headerRow1: wjGrid.Row = new wjGrid.Row();
                //s.columnHeaders.rows.push(headerRow1);
                //let headerRow2: wjGrid.Row = new wjGrid.Row();
                //s.columnHeaders.rows.push(headerRow2);

                s.columnHeaders.rows.splice(3, 1);

                for (let r = 0; r < 3; r++) {

                    for (let c = 0; c < s.columnHeaders.columns.length; c++) {

                        let headerContent = '';

                        if (r === 0) {
                            if (c === 0) {
                                headerContent = 'Organization Name';
                            }
                            else if (c === 1) {
                                headerContent = 'Subpopulation';
                            }
                            else if (c > 1 && c < 6) {
                                headerContent = 'Removals to an IAE';
                            }
                            else if (c === 6) {
                                headerContent = 'Removals to an IAE  - Determination';
                            }
                            else if (c > 6 && c < 9) {
                                headerContent = 'Out of School Sus./Exp. With Days Totaling';
                            }
                            else if (c > 8 && c < 11) {
                                headerContent = 'In School Sus. With Days Totaling';
                            }
                            else if (c > 10) {
                                headerContent = 'Disciplinary Removals';
                            }
                        }
                        if (r === 1) {
                            if (c === 0) {
                                headerContent = 'Organization Name';
                            }
                            else if (c === 1) {
                                headerContent = 'Subpopulation';
                            }
                            else if (c === 2) {
                                headerContent = 'Number of Children (C005)';
                            }
                            else if (c > 2 && c < 6) {
                                headerContent = '# of Removals for';
                            }
                            else if (c === 6) {
                                headerContent = 'Number of Children (C005)';
                            }
                            else if (c === 7 || c === 9) {
                                headerContent = '10 Days or Less (C006)';
                            }
                            else if (c === 8 || c === 10) {
                                headerContent = '> 10 Days (C006)';
                            }
                            else if (c === 11) {
                                headerContent = 'Total Disciplinary Removals (C143)';
                            }
                            else if (c > 11) {
                                headerContent = '# With Days Totaling';
                            }
                        }
                        if (r === 2) {

                            if (c === 0) {
                                headerContent = 'Organization Name';
                            }
                            else if (c === 1) {
                                headerContent = 'Subpopulation';
                            }
                            else if (c === 2) {
                                headerContent = 'Number of Children (C005)';
                            }
                            else if (c === 3) {
                                headerContent = 'Drugs (C007)';
                            }
                            else if (c === 4) {
                                headerContent = 'Weapons (C007)';
                            }
                            else if (c === 5) {
                                headerContent = 'Serious Bodily Injury (C007)';
                            }
                            else if (c === 6) {
                                headerContent = 'Number of Children (C005)';
                            }
                            else if (c === 7) {
                                headerContent = '10 Days or Less (C006)';
                            }
                            else if (c === 8) {
                                headerContent = '> 10 Days (C006)';
                            }
                            else if (c === 9) {
                                headerContent = '10 Days or Less (C006)';
                            }
                            else if (c === 10) {
                                headerContent = '> 10 Days (C006)';
                            }
                            else if (c === 11) {
                                headerContent = 'Total Disciplinary Removals (C143)';
                            }
                            else if (c === 12) {
                                headerContent = '1 Day (C088)';
                            }
                            else if (c === 13) {
                                headerContent = '2-10 Days (C088)';
                            }
                            else if (c === 14) {
                                headerContent = '> 10 Days (C088)';
                            }
                        }

                        if (headerContent.length > 0) {
                            s.columnHeaders.setCellData(r, c, headerContent);
                        }
                    }
                }

                //headerRow.allowMerging = true;
                //headerRow1.allowMerging = true;
                //headerRow2.allowMerging = true;
                for (let r = 0; r < s.columnHeaders.columns.length; r++) {
                    s.columnHeaders.columns[r].allowMerging = true;
                }


                // customize the merge manager
                //let mm = new wjGrid.MergeManager(s);
                //let headerRanges: wjGrid.CellRange[] = [];
                //headerRanges.push(new wjGrid.CellRange(0, 2, 0, 5));
                //headerRanges.push(new wjGrid.CellRange(0, 7, 0, 8));
                //headerRanges.push(new wjGrid.CellRange(0, 9, 0, 10));
                //headerRanges.push(new wjGrid.CellRange(0, 11, 0, 14));
                //headerRanges.push(new wjGrid.CellRange(1, 3, 1, 5));
                //headerRanges.push(new wjGrid.CellRange(1, 12, 1, 14));
                //headerRanges.push(new wjGrid.CellRange(0, 0, 2, 0));
                //headerRanges.push(new wjGrid.CellRange(0, 1, 2, 1));
                //headerRanges.push(new wjGrid.CellRange(1, 2, 2, 2));
                //headerRanges.push(new wjGrid.CellRange(1, 6, 2, 6));
                //headerRanges.push(new wjGrid.CellRange(1, 7, 2, 7));
                //headerRanges.push(new wjGrid.CellRange(1, 8, 2, 8));
                //headerRanges.push(new wjGrid.CellRange(1, 9, 2, 9));
                //headerRanges.push(new wjGrid.CellRange(1, 10, 2, 10));
                //headerRanges.push(new wjGrid.CellRange(1, 11, 2, 11));

            //    let cellRng = new wjGrid.CellRange(0, 0, this.reportGrid.rows.length - 1, 0);

            //    mm.getMergedRange = function (panel, r, c) {
            //        if (panel.cellType == wjGrid.CellType.ColumnHeader) {
            //            if (r >= 0) {
            //                return headerRanges.find(t => t.contains(r, c));
            //            }
            //        }
            //        if (panel.cellType == wjGrid.CellType.Cell) {
            //            if (r >= 0 && cellRng.contains(r, c)) {
            //                return cellRng;
            //            }

            //        }

            //        return null;
            //    };
            //    s.mergeManager = mm;
            }
        }

    }



    getCurrentDate() {
        return new Date().toDateString();
    }

}
