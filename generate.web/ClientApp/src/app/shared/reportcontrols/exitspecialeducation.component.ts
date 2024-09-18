import { Component, Input, AfterViewInit, OnInit, OnChanges, SimpleChange, ViewChild, ViewChildren, QueryList, ElementRef, NgZone } from '@angular/core';
import { Router } from '@angular/router';
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
    selector: 'generate-app-exitspecialeducation',
    templateUrl: './exitspecialeducation.component.html',
    styleUrls: ['./exitspecialeducation.component.scss'],
    providers: [GenerateReportService]
})

export class ExitSpecEdComponent implements AfterViewInit, OnChanges, OnInit {

    public errorMessage: string;

    @Input() reportParameters: GenerateReportParametersDto;

    public currentReport: GenerateReportDto;
    public pivotEngine: any;

    public isLoading: boolean = false;
    public hasRecords: boolean = false;
    public reportDataDto: GenerateReportDataDto;

    private pageCount: number = 0;
    private pageArray: number[];

    public cvData: any;

    private _groupBy: string = '';
    private _filter: string = '';
    private _toFilter: any;

    public pivotGrid: any;

    constructor(
        private _router: Router,
        private _generateReportService: GenerateReportService,
        private _ngZone: NgZone
    ) {

        this.reportDataDto = <GenerateReportDataDto>{};

        this.pivotEngine.showZeros = true;

        this.cvData = this.reportDataDto.data;

        this.pivotEngine.itemsSource = this.cvData;


    }


    //naturalSorter(as, bs) {
    //    // Sort strings naturally (e.g. 1, 2, 3, 10, 11, 12 instead of 1, 10, 11, 12, 2, 3)
    //    let a, b, a1, b1, i = 0, n, L,
    //        rx = /(\.\d+)|(\d+(\.\d+)?)|([^\d.]+)|(\.\D+)|(\.$)/g;
    //    if (as === bs) return 0;
    //    a = as.toString().toLowerCase().match(rx);
    //    b = bs.toString().toLowerCase().match(rx);
    //    L = a.length;
    //    while (i < L) {
    //        if (!b[i]) return 1;
    //        a1 = a[i],
    //            b1 = b[i++];
    //        if (a1 !== b1) {
    //            n = a1 - b1;
    //            if (!isNaN(n)) return n;
    //            return a1 > b1 ? 1 : -1;
    //        }
    //    }
    //    return b[i] ? -1 : 0;
    //}

    ngOnInit() {
        let self = this;

        this.pivotGrid.alternatingRowStep = 1;

        this.pivotGrid.sortingColumn.addHandler(function (s, e) {
            self.refreshData(s, e);
        });

        this.pivotGrid.resizedColumn.addHandler(function (s, e) {
            self.refreshData(s, e);
        });
        
    }

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();

        let self: any = this;

        if (this.pivotGrid !== undefined) {
            this.pivotGrid.updatedLayout.addHandler(function (s, e) {

                setTimeout(function () {
                    self.addExtraHeaders(s);
                });
            });
        }
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
                        if (cellValue === option.categoryOptionCode) {
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

        let self: any = this;
        let d = new Date();
        let n = d.getMilliseconds();
        //console.log('itemsSourceChanged - ' + n);
        //console.log(s);
        
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


    addExtraHeaders(s: any) {


        let self = this;


        // Add additional column headers (if not already done)



    }


    resizeRows(s: any) {

        let self = this;

        let d = new Date();
        let n = d.getMilliseconds();
        //console.log('resizeRows - ' + n);

        if (s !== undefined) {


            s.columnHeaders.rows.defaultSize = 120;
           
            //self.addExtraHeaders(s);
            // enable wrapping on all column headers
            if (s.columnHeaders !== undefined && s.columnHeaders.rows !== undefined) {
                for (let i = 0; i < s.columnHeaders.rows.length; i++) {



                }
            }



            // enable wrapping on all rows
            if (s.rows !== undefined) {
                for (let i = 0; i < s.rows.length; i++) {

                }
            }

            // autosize all row headers
            if (s.rowHeaders !== undefined && s.rowHeaders.rows !== undefined) {
                for (let i = 0; i < s.rowHeaders.rows.length; i++) {
                    if (s.hostElement != null) {

                        s.autoSizeRow(i, true);
                    }
                }
            }

            //// autosize all rows
            //if (s.rows !== undefined) {
            //    for (let i = 0; i < s.rows.length; i++) {
            //        s.autoSizeRow(i, false);
            //    }
            //}

            //s.autoSizeColumns();
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

                    this.pivotGrid.rowHeaders.rows.defaultSize = 90;
                    this.pivotGrid.columnHeaders.rows.defaultSize = 120;
                    if (this.reportParameters.reportCategorySetCode === 'title1') {
                        this.pivotGrid.columns.defaultSize = 150;
                    }


                    if (this.pivotEngine !== undefined) {
                        this.pivotEngine.itemsSource = this.cvData;

                        // Get new category set
                        if (this.reportParameters.reportCategorySet === undefined) {
                            if (this.reportDataDto.categorySets !== null && this.reportDataDto.categorySets.length > 0) {
                                this.reportParameters.reportCategorySet = this.getDefaultCategorySet(this.reportDataDto.categorySets);
                            }
                        }

                        console.log(this.reportParameters.reportCategorySet.categorySetCode);

                        if (this.reportParameters.reportCategorySet !== undefined && this.reportParameters.reportCategorySet.viewDefinition !== undefined) {
                            this.pivotEngine.viewDefinition = this.reportParameters.reportCategorySet.viewDefinition;
                            //console.log(this.pivotEngine.viewDefinition);
                        }

                        this.pivotEngine.invalidate();


                    }


                    // Delay in order to give ngIf time to render viewchild
                    //this._ngZone.runOutsideAngular(() => {
                    //setTimeout(() => this.resizeRows(this.pivotGrid), 400);
                    //});


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

        if (this.reportParameters.reportCategorySet !== undefined) {
            fileName += ' - ' + this.reportParameters.reportCategorySet.categorySetName.replace('?', '');
        }


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

    getReportFilter() {
        let filterText: string = '';
        if (this.reportParameters.reportFilter !== undefined) {
            if (this.reportParameters.reportFilter == 'AllStudents') {
                filterText = 'All Students';
            } else if (this.reportParameters.reportFilter == 'SWD') {
                filterText = 'Students With Disabilities';
            } else if (this.reportParameters.reportFilter == 'SWOD') {
                filterText = 'Students Without Disabilities';
            }
        }

        return filterText;
    }


}
