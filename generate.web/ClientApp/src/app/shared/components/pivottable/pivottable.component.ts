/// <reference path="../../../app.config.ts" />
import { Component, Input, Renderer2, ElementRef, SimpleChange, ViewEncapsulation, ViewChild } from '@angular/core';

import { GenerateReportDataDto } from '../../../models/app/generateReportDataDto';
import { GenerateReportParametersDto } from '../../../models/app/generateReportParametersDto';
import { CategoryOptionDto } from '../../../models/app/categoryOptionDto';
import 'node_modules/pivottable/dist/pivot.js';
import { MatPaginator, PageEvent } from '@angular/material/paginator';

//import * as XLSX from '../../../../lib/xlsx-js-style/dist/xlsx.bundle.js'
import * as XLSX from '../../../../lib/xlsx-js-style/xlsx.js'
//import * as XLSX from '../../../../../node_modules/xlsx-js-style/dist/xlsx.bundle.js'

declare var $: any;

export var inclusions: any;
export var populateReport: any;
export var reportData: GenerateReportDataDto;
export var filterBy: any;
export var filterBy2: any;
export var gstudentCount: any;

export var studentCountColumn: any;
export var aggregateColumn: any;

@Component({
    selector: 'app-pivottable',
    templateUrl: './pivottable.component.html',
    styleUrls: ['./pivottable.component.scss'],
    encapsulation: ViewEncapsulation.None
})
export class PivottableComponent {

    @Input() reportDataDto: GenerateReportDataDto;
    @ViewChild(MatPaginator) paginator: MatPaginator;
    @ViewChild('container', { read: ElementRef }) searchContainer: ElementRef;


    currentPage: number = 0;
    itemsPerPage: number = 10;
    totalItems: number;
    self: any;
    constructor(private renderer: Renderer2) {
        console.log('constructor');
        this.populateReport = this.populateReport.bind(this);
        this.markSearchFields = this.markSearchFields.bind(this);
        this.restoreSearchFields = this.restoreSearchFields.bind(this);
    }

    ngOnInit() {

        filterBy = {};

        filterBy2 = {};

        //studentCountColumn = "studentCount";
        //aggregateColumn = "sex";

        inclusions = {};

        gstudentCount = this.studentCount;

        reportData = JSON.parse(JSON.stringify(this.reportDataDto));

        console.log('ngOnInit');

        this.populateReport();
        //        this.paginator.firstPage();

        $('.pvtAxisLabel').find('span').remove();

        $("body").on("keyup", ".filter", function (e) {
            if (e.key === 'Enter' || e.keyCode === 13) {
                if ($(this).val() != '') {
                    inclusions[$(this).parent().text()] = $(this).val();

                    $('.pvtAxisLabel').find('input').each(function () {
                        filterBy['filterCol'] = $(this).closest('.pvtAxisLabel').text();
                        filterBy['filterValue'] = $(this).val();

                        var colKey = $(this).closest('.pvtAxisLabel').text();
                        colKey = colKey.replace('*', '');
                        filterBy2[colKey] = $(this).val();
                    });

                    this.populateReport();
                }
            }
        });

        $("body").on("click", "#btnSearch", function (e) {
            $('.pvtAxisLabel').find('input').each(function () {
                filterBy['filterCol'] = $(this).closest('.pvtAxisLabel').text();
                filterBy['filterValue'] = $(this).val();

                var colKey = $(this).closest('.pvtAxisLabel').text();
                colKey = colKey.replace('*', '');
                filterBy2[colKey] = $(this).val();
            });

            this.populateReport();
        });


    }

    onSearch() {
        $('.pvtAxisLabel').find('input').each(function () {
            filterBy['filterCol'] = $(this).closest('.pvtAxisLabel').text();
            filterBy['filterValue'] = $(this).val();

            var colKey = $(this).closest('.pvtAxisLabel').text();
            colKey = colKey.replace('*', '');
            filterBy2[colKey] = $(this).val();
        });

        this.populateReport();
    };


    // Update Pivot.js table when pagination changes
    pageChange(event: PageEvent) {
        this.currentPage = event.pageIndex;
        this.itemsPerPage = event.pageSize;
        this.populateReport();
    };

    ngOnChanges(changes: { [propName: string]: SimpleChange }) {
        console.log('ngOnChanges');
        if (this.reportInputChanges(changes)) {
            filterBy2 = {};
        }
        for (let prop in changes) {
            if (changes.hasOwnProperty(prop)) {
                reportData = JSON.parse(JSON.stringify(this.reportDataDto));
                this.populateReport();
            }
        }
    }

    reportInputChanges(changes) {
        let ret = false;
        let previousParams = changes['reportDataDto']['previousValue'];
        if (!previousParams)
            return true;

        let currentParams = changes['reportDataDto']['currentValue'];

        if (!this.isNullOrUndefined(currentParams)) {
            if (currentParams.reportTitle !== previousParams.reportTitle
                //    || currentParams.categorySets[0].organizationLevelCode !== previousParams.categorySets[0].organizationLevelCode
                || currentParams.reportYear !== previousParams.reportYear
                || currentParams.reportCategorySetCode !== previousParams.reportCategorySetCode
            ) {
                ret = true;
            }


            if (currentParams.reportTitle !== previousParams.reportTitle) {
                if ($('#searchTable').is(':checked'))
                    $('#searchTable').click();
            }
        }
        return ret;
    }

    isNullOrUndefined(value: any): boolean {
        return value === null || value === undefined;
    }

    ngAfterViewInit() {

        reportData = JSON.parse(JSON.stringify(this.reportDataDto));
    }

    onResetFilter() {

        filterBy2 = {};

        this.populateReport();
    }

    markSearchFields() {
        if ($('.pvtAxisLabel').length == 0) {
            window.setTimeout(() => { this.markSearchFields() }, 100);
        }
        else {
            $('.pvtAxisLabel').each((index, element) => {
                var text = element.innerHTML;
                if ($(element).find('.filter').length == 0) {
                    var searchField = this.renderer.createElement('div');
                    this.renderer.addClass(searchField, 'search-container');

                    var inputField = this.renderer.createElement('input');
                    this.renderer.setAttribute(inputField, 'type', 'text');
                    this.renderer.addClass(inputField, 'filter');
                    this.renderer.setAttribute(inputField, 'placeholder', text);

                    var button = this.renderer.createElement('button');
                    this.renderer.listen(button, 'click', this.onSearch.bind(this));
                    var icon = this.renderer.createElement('i');
                    this.renderer.addClass(icon, 'fa');
                    this.renderer.addClass(icon, 'fa-search');
                    this.renderer.appendChild(button, icon);

                    this.renderer.appendChild(searchField, inputField);
                    this.renderer.appendChild(searchField, button);
                    this.renderer.appendChild(element, searchField);

                    //    this.renderer.setStyle(this.renderer.selectRootElement('.pvtAxisLabel .filter'), 'width', '8em');
                }
            });
        }
    }

    restoreSearchFields() {
        this.markSearchFields();
        if ($('.pvtAxisLabel').length == 0) {
            window.setTimeout(this.restoreSearchFields, 100);
        }
        else {
            for (var key in filterBy2) {
                $('.pvtAxisLabel').each((index, element) => {
                    if (element.innerHTML.indexOf(key) > -1) {
                        $(element).find('input').val(filterBy2[key]);
                    }
                });
            }
        }

        if ($('#searchTable').prop("checked")) {
            $('#resetFilter').show();
            $('.search-container').show();
        }
        else {
            $('#resetFilter').hide();
            $('.search-container').hide();
        }
    }

    onToggleSearchFilter() {
        if ($('#searchTable').prop("checked")) {
            $('#resetFilter').show();
            $('.pvtAxisLabel .search-container').show();
        } else {
            $('#resetFilter').hide();
            $('.pvtAxisLabel .search-container').hide();
        }
        this.markSearchFields();

    }

    studentCount() {
        return function () {
            return {
                studentCount: 0,
                push: function (record) {

                    return this[studentCountColumn] = record[studentCountColumn];
                },
                value: function () {
                    return this[studentCountColumn];
                },
                format: function (x) {
                    //format with thousands separators
                    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                },
                numInputs: 0
            };
        };
    }

    replaceCategoryOptionCodes() {
        let categoryOptionName: string = '';

        for (let i = 0; i < this.reportDataDto.categorySets[0].categoryOptions.length; i++) {
            let option: CategoryOptionDto = this.reportDataDto.categorySets[0].categoryOptions[i];
            option.categoryOptionCode = option.categoryOptionName;
        }

        return categoryOptionName;
    }

    populateReport() {
        if (this.isNullOrUndefined(reportData) || Object.keys(reportData).length === 0)
            return;
        var derivers = $.pivotUtilities.derivers;
        let viewDef: any = JSON.parse(reportData.categorySets[0].viewDefinition);
        let rowDisplayFields: any = viewDef.rowFields;
        let columnDisplayFields: any = viewDef.columnFields;
        let derivedAttributes: any = {};

        let uiData = reportData.data;

        uiData = JSON.parse(JSON.stringify(this.reportDataDto.data))
        if (uiData[0] !== undefined && uiData[0].parentOrganizationIdentifierSea !== undefined) {
            uiData = uiData
                .sort((a, b) => {
                    if (a.OrganizationName < b.OrganizationName) {
                        return -1;
                    }
                    if (a.OrganizationName > b.OrganizationName) {
                        return 1;
                    }

                    return 0;
                });
        }

        uiData = uiData
            .sort((a, b) => {
                if (a.OrganizationName < b.OrganizationName) {
                    return -1;
                }
                if (a.OrganizationName > b.OrganizationName) {
                    return 1;
                }
                return 0;
            })
            .sort((a, b) => {
                if (a.OrganizationIdentifierSea < b.OrganizationIdentifierSea) {
                    return -1;
                }
                if (a.OrganizationIdentifierSea > b.OrganizationIdentifierSea) {
                    return 1;
                }
                return 0;
            })
            .filter(d => {
                if (Object.keys(filterBy2).length === 0) { return true; }

                var matchFound = true;
                for (var i = 0; i < Object.keys(filterBy2).length; i++) {
                    if (filterBy2[Object.keys(filterBy2)[i]] != "") {
                        var dataValue = d[viewDef.fields.find(f => f.header === Object.keys(filterBy2)[i]).binding];
                        var searchValue = filterBy2[Object.keys(filterBy2)[i]];

                        var categoryOption = reportData.categorySets[0].categoryOptions.find(o => o.categoryOptionCode.toLowerCase() == dataValue.toLowerCase());
                        var categoryOptionName = "";
                        if (categoryOption != undefined) {
                            categoryOptionName = categoryOption.categoryOptionName;
                        }

                        if (dataValue.toLowerCase().indexOf(searchValue.toLowerCase()) == -1 && categoryOptionName.toLowerCase().indexOf(searchValue.toLowerCase()) == -1) {
                            matchFound = false;
                            break;
                        }
                    }
                }
                return matchFound;
            });

        if (uiData.length > 0) {
            if (reportData.categorySets[0].organizationLevelCode.toLowerCase() == "sea") {
                this.paginator.disabled = true;
            }
            else {
                this.paginator.disabled = false;
                // Apply pagination
                let startIndex = this.currentPage * this.itemsPerPage;

                if (startIndex > 0) {
                    startIndex--; // This is necessary on any page past page 1 to accomodate 0-based indexes
                }

                let organizationCount = 0;
                let firstRecordIndex = -1;
                let currentOrganization = uiData[0].organizationIdentifierSea;

                for (let i = 0; i < uiData.length; i++) {
                    if (organizationCount == startIndex && firstRecordIndex == -1) { // For page 1
                        firstRecordIndex = i;
                    }
                    else if (i === 0 || currentOrganization !== uiData[i].organizationIdentifierSea) {
                        organizationCount++;
                    }

                    if (organizationCount == startIndex && firstRecordIndex == -1) { // For all other pages
                        firstRecordIndex = i;
                    }

                    currentOrganization = uiData[i].organizationIdentifierSea;

                    if (firstRecordIndex !== -1) {
                        break;
                    }
                }

                if (firstRecordIndex === -1) {
                    firstRecordIndex = 0;
                    this.currentPage = 0
                }
                let lastRecordIndex = -1;
                let organizationCounter = 0;
                currentOrganization = "";
                for (let i = firstRecordIndex; i < uiData.length; i++) {
                    if (currentOrganization !== uiData[i].organizationIdentifierSea) {
                        organizationCounter++;
                    }
                    currentOrganization = uiData[i].organizationIdentifierSea;

                    if (organizationCounter > this.itemsPerPage && lastRecordIndex == -1) {
                        lastRecordIndex = i;
                        break;
                    }
                    if (i == uiData.length - 1) {
                        lastRecordIndex = uiData.length;
                        break;
                    }
                }


                uiData = uiData.slice(firstRecordIndex, lastRecordIndex);
            }
        }

        // Update totalItems based on the total count of data
        this.paginator.length = new Set(this.reportDataDto.data.filter(d => {
            if (Object.keys(filterBy2).length === 0) { return true; }

            var matchFound = true;
            for (var i = 0; i < Object.keys(filterBy2).length; i++) {
                if (filterBy2[Object.keys(filterBy2)[i]] != "") {
                    var dataValue = d[viewDef.fields.find(f => f.header === Object.keys(filterBy2)[i]).binding];
                    var searchValue = filterBy2[Object.keys(filterBy2)[i]];

                    var categoryOption = reportData.categorySets[0].categoryOptions.find(o => o.categoryOptionName.toLowerCase() === searchValue.toLowerCase());
                    var categoryOptionCode = "";
                    if (categoryOption != undefined) {
                        categoryOptionCode = categoryOption.categoryOptionCode;
                    }

                    if (dataValue.toLowerCase().indexOf(searchValue.toLowerCase()) === -1 && dataValue.toLowerCase() !== categoryOptionCode.toLowerCase()) {
                        matchFound = false;
                        break;
                    }
                }
            }
            return matchFound;
        }).map(item => item.organizationIdentifierSea)).size;

        rowDisplayFields.items.forEach(r => {
            viewDef.fields.forEach(f => {
                if (r === f.header) {
                    derivedAttributes[r] = function (mp) {
                        return mp[f.binding];
                    }
                }
            });
        });

        columnDisplayFields.items.forEach(r => {
            viewDef.fields.forEach(f => {
                if (r === f.header) {
                    derivedAttributes[r] = function (mp) {
                        return mp[f.binding] != null ? mp[f.binding] : 0;
                    }
                }
            });
        });

        derivedAttributes["organizationStateId"] = function (mp) {
            return mp["organizationIdentifierSea"];
        }

        reportData.categorySets[0].categories.forEach(c => {
            uiData.forEach(d => {
                viewDef.fields.forEach(f => {
                    if (c === f.header) {
                        reportData.categorySets[0].categoryOptions.forEach(o => {
                            if (o.categoryOptionCode === d[f.binding]) {
                                d[f.binding] = o.categoryOptionName;
                            }
                        });
                    }
                });
            });
        });

        //find out the column of student count in the data dto.
        viewDef.fields.forEach(f => {
            //Could get 'Count' from valueFields	
            if ("Count" === f.header && f.aggregate == 1) {
                studentCountColumn = f.binding;
            }
        });

        var len = viewDef.columnFields.items.length;

        aggregateColumn = viewDef.columnFields.items[len - 1];

        $("#container").pivotUI(uiData, {
            showUI: false,
            rows: viewDef.rowFields.items, cols: viewDef.columnFields.items,
            aggregators: {
                aggregateColumn: gstudentCount
            },
            derivedAttributes: derivedAttributes,
            rendererOptions: {
                table: {
                    rowTotals: false,
                    colTotals: false,
                    rendererName: "Table",
                    clickCallback: function (e, value, filters, pivotData) {
                        var names = [];
                        pivotData.forEachMatchingRecord(filters,
                            function (record) { names.push(record.Name); });
                    }
                }
            }
        },
            true
        );

        $.fn.textWidth = function (text, font) {
            if (!$.fn.textWidth.fakeEl) $.fn.textWidth.fakeEl = $('<span>').hide().appendTo(document.body);
            $.fn.textWidth.fakeEl.text(text || this.val() || this.text()).css('font', font || this.css('font'));
            return $.fn.textWidth.fakeEl.width();
        };


        this.restoreSearchFields();

        function relayoutGrid() {
            if ($('.pvtAxisLabel').length == 0) {
                window.setTimeout(relayoutGrid, 100);
            }
            else {
                $('.pvtAxisLabel').last().prop('colspan', 2);
                //remove the last cell on the tr due to the above change
                $('.pvtAxisLabel').last().next().remove();
            }
        }


        relayoutGrid();
    }
    exportToExcel(exportFile) {
        this.self = this;
        if (Object.keys(reportData).length === 0)
            return;
        var derivers = $.pivotUtilities.derivers;
        let viewDef: any = JSON.parse(reportData.categorySets[0].viewDefinition);
        let rowDisplayFields: any = viewDef.rowFields;
        let columnDisplayFields: any = viewDef.columnFields;
        let derivedAttributes: any = {};

        rowDisplayFields.items.forEach(r => {
            viewDef.fields.forEach(f => {
                if (r === f.header) {
                    derivedAttributes[r] = function (mp) {
                        return mp[f.binding];
                    }
                }
            });
        });

        columnDisplayFields.items.forEach(r => {
            viewDef.fields.forEach(f => {
                if (r === f.header) {
                    derivedAttributes[r] = function (mp) {
                        return mp[f.binding] != null ? mp[f.binding] : 0;
                    }
                }
            });
        });

        derivedAttributes["organizationStateId"] = function (mp) {
            return mp["organizationIdentifierSea"];
        }

        reportData.categorySets[0].categories.forEach(c => {
            reportData.data.forEach(d => {
                viewDef.fields.forEach(f => {
                    if (c === f.header) {
                        reportData.categorySets[0].categoryOptions.forEach(o => {
                            if (o.categoryOptionCode === d[f.binding]) {
                                d[f.binding] = o.categoryOptionName;
                            }
                        });
                    }
                });
            });
        });

        //find out the column of student count in the data dto.
        viewDef.fields.forEach(f => {
            //Could get 'Count' from valueFields	
            if ("Count" === f.header && f.aggregate == 1) {
                studentCountColumn = f.binding;
            }
        });

        var len = viewDef.columnFields.items.length;

        aggregateColumn = viewDef.columnFields.items[len - 1];


        $("#containerExport").pivotUI(reportData.data, {
            showUI: false,
            rows: viewDef.rowFields.items, cols: viewDef.columnFields.items,
            aggregators: {
                aggregateColumn: gstudentCount
            },
            filter: function (rowObj) {
                for (var key in filterBy2) {
                    if (rowObj[key] === undefined || rowObj[key].indexOf(filterBy2[key]) < 0)
                        return false;
                }

                return true;
            },
            derivedAttributes: derivedAttributes,
            rendererOptions: {
                table: {
                    rowTotals: false,
                    colTotals: false,
                    rendererName: "Table",
                    clickCallback: function (e, value, filters, pivotData) {
                        var names = [];
                        pivotData.forEachMatchingRecord(filters,
                            function (record) { names.push(record.Name); });
                    }
                }
            },
            onRefresh: function (config) {
                console.log('load completed');
                console.log(config);
                var html = $("#containerExport").html();
                const table = document.getElementsByClassName('pvtTable');
                var colLength = $('#containerExport .pvtTable thead').find('tr:nth-child(1)').children().length;
                $('#containerExport .pvtTable thead').prepend('<tr><td></td></tr><tr><td></td></tr><tr><td></td></tr><tr><td></td></tr>');

                //Add more rows above, have to change tr:nth-child(5)
                let firstEmptyCellSpan = $('#containerExport .pvtTable thead tr:last th').length - 2;
                // The colspan for the first empty cell in the header
                $('#containerExport .pvtTable thead').find('tr:nth-child(5)').find('th:first').prop('colspan', firstEmptyCellSpan);
                $('#containerExport .pvtTable thead').find('tr:nth-child(3)').find('th:first').prop('background-color', 'red');
                $("#containerExport .pvtTable .pvtRowLabel").prop('colspan', '1');
                var start = Date.now();
                const wb = XLSX.utils.table_to_book(table[1], { sheet: 'Generate Report' });

                //    const wb = XLSX.utils.table_to_book(table, { sheet: 'StyledSheet' });

                let count = $('#containerExport .pvtTable tr').length;
                console.log(count)
                //pvtAxisLabel
                $('#containerExport .pvtTable th').css('color', 'red');
                const ws = wb.Sheets['Generate Report'];

                //Set Column width
                var wscols = [
                    { wpx: 100 },
                    { wpx: 70 }
                ];

                var reportCaption = $('.generate-app-report__title').text();
                let index = reportCaption.indexOf(':');
                let reportCode = reportCaption.substring(0, index);

                var colWidth = 150;
                var category = $('.generate-app-pivotgrid__categoryset-definition span').html();


                //Column C
                if (reportCode.toLowerCase() == "c002") {
                    if (category.toLowerCase() == "category set a" || category.toLowerCase() == "category set b" || category.toLowerCase() == "category set c"
                        || category.toLowerCase() == "category set d") {
                        colWidth = 220;
                    }
                }
                else if (reportCode.toLowerCase() == "c005") {
                    if (category.toLowerCase() == "category set a" || category.toLowerCase() == "category set b" || category.toLowerCase() == "category set c" || category.toLowerCase() == "category set c" || category.toLowerCase() == "category set d") {
                        colWidth = 500;
                    }
                }
                else if (reportCode.toLowerCase() == "c009") {
                    if (category.toLowerCase() == "category set a") {
                        colWidth = 220;
                    }
                }
                else if (reportCode.toLowerCase() == "c089") {
                    if (category.toLowerCase() == "category set a" || category.toLowerCase() == "category set b") {
                        colWidth = 220;
                    } else if (category.toLowerCase() == "category set c" || category.toLowerCase() == "category set d") {
                        colWidth = 250;
                    }
                }
                wscols.push({ wpx: colWidth });


                if (firstEmptyCellSpan > 2) {
                    if (reportCode.toLowerCase() == "c175" || reportCode.toLowerCase() == "c178") {
                        //Starting from Column A
                        wscols = [
                            { wpx: 120 },
                            { wpx: 70 },
                            { wpx: 110 },
                        ];
                        if (category.toLowerCase() == "category set a" || category.toLowerCase() == "category set b" || category.toLowerCase() == "category set c"
                            || category.toLowerCase() == "category set d" || category.toLowerCase() == "category set e" || category.toLowerCase() == "category set f" || category.toLowerCase() == "category set g"
                            || category.toLowerCase() == "category set h") {
                            wscols.push({ wpx: 150 });
                            wscols.push({ wpx: 300 }); //Column E
                        } else if (category.toLowerCase() == "category set i") {
                            wscols.push({ wpx: 200 });
                            wscols.push({ wpx: 300 }); //Column E
                        } else if (category.toLowerCase() == "category set j") {
                            wscols.push({ wpx: 200 });
                            wscols.push({ wpx: 180 }); //Column E
                        } else {
                            wscols.push({ wpx: 180 }); //Column D
                        }
                    }
                    else if (reportCode.toLowerCase() == "c179") {
                        //Starting from Column A
                        wscols = [
                            { wpx: 120 },
                            { wpx: 70 },
                            { wpx: 110 },
                        ];
                        if (category.toLowerCase() == "category set a") {
                            wscols.push({ wpx: 150 });
                            wscols.push({ wpx: 200 }); //Column E
                        } else if (category.toLowerCase() == "category set b" || category.toLowerCase() == "category set c"
                            || category.toLowerCase() == "category set d" || category.toLowerCase() == "category set f" || category.toLowerCase() == "category set g"
                            || category.toLowerCase() == "category set h") {
                            wscols.push({ wpx: 150 });
                            wscols.push({ wpx: 175 }); //Column E
                        } else if (category.toLowerCase() == "category set e") {
                            wscols.push({ wpx: 150 });
                            wscols.push({ wpx: 225 }); //Column E
                        }
                        else if (category.toLowerCase() == "category set i") {
                            wscols.push({ wpx: 210 });
                            wscols.push({ wpx: 190 }); //Column E
                        } else if (category.toLowerCase() == "category set j") {
                            wscols.push({ wpx: 200 });
                            wscols.push({ wpx: 180 }); //Column E
                        } else {
                            wscols.push({ wpx: 180 }); //Column D
                        }
                    }
                    else if (reportCode.toLowerCase() == "c185") {
                        wscols.push({ wpx: 200 }); //Column D
                        if (category.toLowerCase() == "category set j")
                            wscols.push({ wpx: 180 });// Column E
                    }
                    else if (reportCode.toLowerCase() == "c188") {
                        if (category.toLowerCase() == "subtotal 1")
                            wscols.push({ wpx: 325 }); //Column D
                        else
                            wscols.push({ wpx: 200 }); //Column D

                        if (category.toLowerCase() == "category set j")
                            wscols.push({ wpx: 180 });// Column E
                    }
                    else if (reportCode.toLowerCase() == "c189") {
                        //  wscols.push({ wpx: 200 }); //Column D
                        if (category.toLowerCase() == "category set b" || category.toLowerCase() == "category set c" || category.toLowerCase() == "category set d" || category.toLowerCase() == "category set f")
                            wscols.push({ wpx: 150 });// Column D
                        //else if (category.toLowerCase() == "category set b")
                        //    wscols.push({ wpx: 220 });// Column D
                    }
                    else {
                        wscols.push({ wpx: 300 });
                    }
                }
                ws['!cols'] = wscols;


                //Set data columns
                var dataColumnNumber = $('#containerExport .pvtTable thead tr:last').prev().find('.pvtColLabel').length;
                if (reportCode.toLowerCase() == "c005" && category.toLowerCase() == "subtotal 1") {
                    for (var i = 0; i <= dataColumnNumber; i++) {
                        ws['!cols'].push({ wpx: 200 })
                    }
                }
                else if ((reportCode.toLowerCase() == "c175" || reportCode.toLowerCase() == "c178" || reportCode.toLowerCase() == "c179") && category.toLowerCase() == "category set j") {
                    for (var i = 0; i <= dataColumnNumber; i++) {
                        ws['!cols'].push({ wpx: 200 })
                    }
                }
                else if (reportCode.toLowerCase() == "c178" && category.toLowerCase() == "category set j") {
                    for (var i = 0; i <= dataColumnNumber; i++) {
                        ws['!cols'].push({ wpx: 200 })
                    }
                }
                else if (reportCode.toLowerCase() == "c185") {
                    let dataCol = 200;
                    if (category.toLowerCase() == "category set j" || category.toLowerCase() == "subtotal 1")
                        dataCol = 100;

                    for (var i = 0; i <= dataColumnNumber; i++) {
                        ws['!cols'].push({ wpx: dataCol })
                    }
                }
                else if (reportCode.toLowerCase() == "c188") {
                    let dataCol = 200;
                    if (category.toLowerCase() == "category set j" || category.toLowerCase() == "subtotal 1")
                        dataCol = 100;

                    for (var i = 0; i <= dataColumnNumber; i++) {
                        ws['!cols'].push({ wpx: dataCol })
                    }
                }
                else if (reportCode.toLowerCase() == "c189") {
                    let dataCol = 200;
                    if (category.toLowerCase() == "subtotal 1")
                        dataCol = 150;

                    for (var i = 0; i <= dataColumnNumber; i++) {
                        ws['!cols'].push({ wpx: dataCol })
                    }
                }
                else {
                    if ($('#containerExport .pvtTable .pvtColLabel').closest('tr').length == 1) {

                        for (var i = 0; i <= dataColumnNumber; i++) {
                            var len = $('#containerExport .pvtTable .pvtColLabel').eq(i).text().length;
                            if (len >= 13) {
                                ws['!cols'].push({ wpx: 125 })
                            } else {
                                ws['!cols'].push({ wpx: 85 })
                            }
                        }
                    } else if ($('#containerExport .pvtTable .pvtColLabel').length >= 2) {
                        dataColumnNumber = $("#containerExport .pvtTable .pvtAxisLabel").closest("tr").eq(1).find('.pvtColLabel').length;
                        for (var i = 0; i <= dataColumnNumber; i++) {
                            var len = $("#containerExport .pvtTable .pvtAxisLabel").closest("tr").eq(1).find('.pvtColLabel').eq(i).text().length;
                            if (len >= 13) {
                                ws['!cols'].push({ wpx: 160 })
                            }
                            else {
                                ws['!cols'].push({ wpx: 85 })
                            }

                        }
                    }
                }


                //Set row height
                var wsrows = [
                    { hpx: 25 }, // row 1 sets to the height in pixels
                    { hpx: 20 },
                    { hpx: 20 },
                    { hpx: 20 },
                ];

                ws['!rows'] = wsrows; // ws - worksheet
                let headerRowLength = $('#containerExport .pvtTable thead tr').length - 4; //4 is caption rows
                for (var i = 0; i < headerRowLength; i++) {
                    ws['!rows'].push({ hpx: 35 });
                }

                //Set all data row height
                let dataRowLength = $('#containerExport .pvtTable tbody tr').length;
                for (var i = 0; i <= dataRowLength; i++) {
                    if (reportCode.toLowerCase() == "c175" || reportCode.toLowerCase() == "c178") {
                        ws['!rows'].push({ hpx: 45 });
                    } else if (reportCode.toLowerCase() == "c179") {
                        if (category.toLowerCase() == "subtotal 1")
                            ws['!rows'].push({ hpx: 45 });
                    }

                    else {
                        if (dataRowLength <= 2)
                            ws['!rows'].push({ hpx: 40 });
                        else
                            ws['!rows'].push({ hpx: 30 });
                    }

                }
                //first row e.g. A1:AB12
                var ref = ws["!fullref"];
                console.log(ref);

                var range = XLSX.utils.decode_range(ws['!ref']);
                //0 index based
                var colTotal = range.e.c;
                var rowTotal = range.e.r;
                //search worksheet ws with the cell type of 's'

                //pvtAxisLabel with darker
                var pvtAxisLabels = [];
                $('#containerExport .pvtAxisLabel').each(function (index, element) {
                    pvtAxisLabels.push(element.getInnerHTML());
                });

                var pvtRowLabels = [];
                $('#containerExport .pvtRowLabel').each(function (index, element) {
                    pvtRowLabels.push(element.getInnerHTML());
                });

                start = Date.now();
                colTotal = 3;

                var titleColSpan = 12;
                var new_headers = [];

                for (var i = 0; i <= 2; i++) {
                    new_headers.push('');
                }

                new_headers.push($('.generate-app-report__title').text());
                ws["!merges"].push({ s: { r: 0, c: 3 }, e: { r: 0, c: titleColSpan } });

                XLSX.utils.sheet_add_aoa(ws, [new_headers],
                    { skipHeader: true, origin: "A1" });
                ws['D1'].s = { font: { bold: true, sz: 14 }, alignment: { horizontal: 'center', vertical: 'center' } };

                new_headers = [];
                //for loop to add the new headers to the worksheet
                for (var i = 0; i <= 2; i++) {
                    new_headers.push('');
                }

                var caption2 = '';
                $('.generate-app-pivotgrid__categoryset-definition').find('span').each(function (idx) {
                    if ($.trim($(this).text()) !== ",")
                        caption2 += $(this).text();
                });
                new_headers.push(caption2);
                ws["!merges"].push({ s: { r: 1, c: 3 }, e: { r: 1, c: titleColSpan } });

                XLSX.utils.sheet_add_aoa(ws, [new_headers],
                    { skipHeader: true, origin: "A2" });
                ws['D2'].s = { font: { bold: false }, alignment: { horizontal: 'center', vertical: 'center' } };


                ////generate-app-pivotgrid__total
                new_headers = [];
                //for loop to add the new headers to the worksheet
                for (var i = 0; i <= 2; i++) {
                    new_headers.push('');
                }

                new_headers.push($('.generate-app-pivotgrid__total').text());
                ws["!merges"].push({ s: { r: 2, c: 3 }, e: { r: 2, c: titleColSpan } });

                XLSX.utils.sheet_add_aoa(ws, [new_headers],
                    { skipHeader: true, origin: "A3" });
                ws['D3'].s = { font: { bold: true }, alignment: { horizontal: 'center', vertical: 'center' } };



                //ws['C4'].s = {
                //    font: { bold: true, color: { rgb: '000000' } }
                //};
                //lighter: #e6eeee
                //      ws['A4'].s = { font: { italic: true }, fill: { fgColor: { rgb: 'ff0000' } }, alignment: { horizontal: 'center' } };
                //{compression:true}
                //  var newCell = { t: 's', v: '' };
                // File in the blank cell on pvtAxisLabel
                ws['A5'] = { t: 's', v: '' };
                ws['A5'].t = 's';
                ws['A5'].s = { font: { italic: true }, fill: { fgColor: { rgb: 'cfd6d6' } }, alignment: { horizontal: 'center' } };

                //  var newCell = { t: 's', v: '' };
                //  ws['C3'] = { t: 's', v: '' };
                //     ws["!merges"].push({ s: { r: 2, c: 3 }, e: { r: 2, c: 2 }});
                XLSX.writeFile(wb, exportFile);

                $("#containerExport").html('');
            },
            //Utility function
            getColumnQidth: function (columnVal) {
                var arr = columnVal.split(' ');
                var longest = arr.reduce(
                    function (a, b) {
                        return a.length > b.length ? a : b;
                    }
                );

                return longest ? longest.length : 0;
            },
            columnToLetter: function (column) {
                var temp, letter = '';
                while (column > 0) {
                    temp = (column - 1) % 26;
                    letter = String.fromCharCode(temp + 65) + letter;
                    column = (column - temp - 1) / 26;
                }

                return letter;
            }
        },
            true
        );

        $.fn.textWidth = function (text, font) {
            if (!$.fn.textWidth.fakeEl) $.fn.textWidth.fakeEl = $('<span>').hide().appendTo(document.body);
            $.fn.textWidth.fakeEl.text(text || this.val() || this.text()).css('font', font || this.css('font'));
            return $.fn.textWidth.fakeEl.width();
        };

        function markSearchFields() {
            if ($('.pvtAxisLabel').length == 0) {
                window.setTimeout(markSearchFields, 100);
            }
            else {
                $('.pvtAxisLabel').each(function () {
                    var text = $(this).html();
                    text = '';
                    if ($(this).find('.filter').length == 0) {
                        var searchField = "<div class='search-container' style='display:none;'>";
                        searchField = searchField + "<input type='text' class='filter' value='' placeholder='" + text + "' />";
                        searchField = searchField + "<button type='button' id='btnSearch' ><i class='fa fa-search' (click)='onSearch()'></i></button>";
                        searchField = searchField + "</div>";
                        $(this).append(searchField);

                        $(this).find('.filter').css('width', '8em');
                    }
                });
            }
        }

        markSearchFields();

        function restoreSearchFields() {
            if ($('.pvtAxisLabel').length == 0) {
                window.setTimeout(restoreSearchFields, 100);
            }
            else {
                for (var key in filterBy2) {
                    $('.pvtAxisLabel').each(function () {
                        var text = $(this).html();
                        if ($(this).html().indexOf(key) > -1) {
                            $(this).find('input').val(filterBy2[key]);
                        }
                    });
                }
            }

            if ($('#searchTable').prop("checked")) {
                $('#resetFilter').show();
                $('.pvtAxisLabel .search-container').show();
            }
        }

        restoreSearchFields();

        function relayoutGrid() {
            if ($('.pvtAxisLabel').length == 0) {
                window.setTimeout(relayoutGrid, 100);
            }
            else {
                $('.pvtAxisLabel').last().prop('colspan', 2);
                //remove the last cell on the tr due to the above change
                $('.pvtAxisLabel').last().next().remove();
            }
        }


        relayoutGrid();
    }
    exportToExcel2() {

        if (Object.keys(reportData).length === 0)
            return;
        var derivers = $.pivotUtilities.derivers;
        let viewDef: any = JSON.parse(reportData.categorySets[0].viewDefinition);
        let rowDisplayFields: any = viewDef.rowFields;
        let columnDisplayFields: any = viewDef.columnFields;
        let derivedAttributes: any = {};

        rowDisplayFields.items.forEach(r => {
            viewDef.fields.forEach(f => {
                if (r === f.header) {
                    derivedAttributes[r] = function (mp) {
                        return mp[f.binding];
                    }
                }
            });
        });

        columnDisplayFields.items.forEach(r => {
            viewDef.fields.forEach(f => {
                if (r === f.header) {
                    derivedAttributes[r] = function (mp) {
                        return mp[f.binding] != null ? mp[f.binding] : 0;
                    }
                }
            });
        });

        derivedAttributes["organizationStateId"] = function (mp) {
            return mp["organizationIdentifierSea"];
        }

        reportData.categorySets[0].categories.forEach(c => {
            reportData.data.forEach(d => {
                viewDef.fields.forEach(f => {
                    if (c === f.header) {
                        reportData.categorySets[0].categoryOptions.forEach(o => {
                            if (o.categoryOptionCode === d[f.binding]) {
                                d[f.binding] = o.categoryOptionName;
                            }
                        });
                    }
                });
            });
        });

        //find out the column of student count in the data dto.
        viewDef.fields.forEach(f => {
            //Could get 'Count' from valueFields	
            if ("Count" === f.header && f.aggregate == 1) {
                studentCountColumn = f.binding;
            }
        });

        var len = viewDef.columnFields.items.length;

        aggregateColumn = viewDef.columnFields.items[len - 1];


        $("#containerExport").pivotUI(reportData.data, {
            showUI: false,
            rows: viewDef.rowFields.items, cols: viewDef.columnFields.items,
            aggregators: {
                aggregateColumn: gstudentCount
            },
            filter: function (rowObj) {
                for (var key in filterBy2) {
                    if (rowObj[key] === undefined || rowObj[key].indexOf(filterBy2[key]) < 0)
                        return false;
                }

                return true;
            },
            derivedAttributes: derivedAttributes,
            rendererOptions: {
                table: {
                    rowTotals: false,
                    colTotals: false,
                    rendererName: "Table",
                    clickCallback: function (e, value, filters, pivotData) {
                        var names = [];
                        pivotData.forEachMatchingRecord(filters,
                            function (record) { names.push(record.Name); });
                    }
                }
            },
            onRefresh: function (config) {
                console.log('completed-onrefresh');
                var html = $("#containerExport").html();
                const table = document.getElementsByClassName('pvtTable');
                $('#containerExport .pvtTable thead').prepend('<tr><td>n1</td></tr><tr><td>n2</td></tr>');

                $("#containerExport .pvtTable tr:first th:first").text('empty');
                $("#containerExport .pvtTable tr:first th:first").prop('class', 'pvtAxisLabel');

                $('#containerExport .pvtTable thead tr:first th:first')
                $(table).find('.pvtTable thead').find('tr:nth-child(3)').find('th:first').prop('colspan', '2');
                const wb = XLSX.utils.table_to_book(table[1], { sheet: 'StyledSheet' });

                let count = $('#containerExport .pvtTable tr').length;

                $('#containerExport .pvtTable th').css('color', 'red');
                const ws = wb.Sheets['StyledSheet'];

                var wscols = [
                    { wch: 150 },
                    { wch: 70 },
                    { wch: 200 },
                    //{ wch: 200 },
                    //{ wch: 200 },
                    //{ wch: 200 },
                    //{ wch: 200 },
                    //{ wch: 200 },
                    //{ wch: 200 }
                ];

                //    ws['!cols'] = wscols;
                ws['!cols'] = [{ width: 20 }, { width: 10 }, { width: 35 }];

                var wsrows = [
                    { hpt: 12 }, // row 1 sets to the height of 12 in points
                    { hpx: 160 }, // row 2 sets to the height of 16 in pixels
                    { hpx: 160 }, // row 2 sets to the height of 16 in pixels
                    { hpx: 160 }, // row 2 sets to the height of 16 in pixels
                    { hpx: 160 }, // row 2 sets to the height of 16 in pixels
                    { hpx: 160 }, // row 2 sets to the height of 16 in pixels
                    { hpx: 160 } // row 2 sets to the height of 16 in pixels
                ];

                //   ws['!rows'] = wsrows; // ws - worksheet
                //   ws['!rows'] = [{ height: 200 }, { height: 200 }, { height: 150 }];

                //first row e.g. A1:AB12
                var ref = ws["!fullref"];
                console.log(ref);

                var range = XLSX.utils.decode_range(ws['!ref']);
                //0 index based
                var colTotal = range.e.c;
                var rowTotal = range.e.r;

                //pvtAxisLabel with darker
                var pvtAxisLabels = [];
                $('#containerExport .pvtAxisLabel').each(function (index, element) {
                    pvtAxisLabels.push(element.getInnerHTML());
                });

                var pvtRowLabels = [];
                $('#containerExport .pvtRowLabel').each(function (index, element) {
                    pvtRowLabels.push(element.getInnerHTML());
                });

                rowTotal = 3;
                var new_headers = ["S", "h", "e", "e", "t", "J", "S"];
                XLSX.utils.sheet_add_aoa(ws, [new_headers],
                    { skipHeader: true, origin: "A1" });

                //pvtColLabel with lighter, center
                //pvtRowLabel with lighter, left

                XLSX.writeFile(wb, 'styledData.xlsx');

                $("#containerExport").html('');
            },
            //Utility function
            columnToLetter: function (column) {
                var temp, letter = '';
                while (column > 0) {
                    temp = (column - 1) % 26;
                    letter = String.fromCharCode(temp + 65) + letter;
                    column = (column - temp - 1) / 26;
                }

                return letter;
            }
        },
            true
        );

        $.fn.textWidth = function (text, font) {
            if (!$.fn.textWidth.fakeEl) $.fn.textWidth.fakeEl = $('<span>').hide().appendTo(document.body);
            $.fn.textWidth.fakeEl.text(text || this.val() || this.text()).css('font', font || this.css('font'));
            return $.fn.textWidth.fakeEl.width();
        };

        function markSearchFields() {
            if ($('.pvtAxisLabel').length == 0) {
                window.setTimeout(markSearchFields, 100);
            }
            else {
                $('.pvtAxisLabel').each(function () {
                    var text = $(this).html();
                    text = '';
                    //       let width = $(this).textWidth(text, $(this).css('font'));
                    if ($(this).find('.filter').length == 0) {
                        var searchField = "<div class='search-container' style='display:none;'>";
                        searchField = searchField + "<input type='text' class='filter' value='' placeholder='" + text + "' />";
                        searchField = searchField + "<button type='button' id='btnSearch' ><i class='fa fa-search' (click)='onSearch()'></i></button>";
                        searchField = searchField + "</div>";
                        $(this).append(searchField);

                        $(this).find('.filter').css('width', '8em');
                    }
                });
            }
        }

        markSearchFields();

        function restoreSearchFields() {
            if ($('.pvtAxisLabel').length == 0) {
                window.setTimeout(restoreSearchFields, 100);
            }
            else {
                for (var key in filterBy2) {
                    $('.pvtAxisLabel').each(function () {
                        var text = $(this).html();
                        if ($(this).html().indexOf(key) > -1) {
                            $(this).find('input').val(filterBy2[key]);
                        }
                    });
                }
            }

            if ($('#searchTable').prop("checked")) {
                $('#resetFilter').show();
                $('.pvtAxisLabel .search-container').show();
            }
        }

        restoreSearchFields();

        function relayoutGrid() {
            if ($('.pvtAxisLabel').length == 0) {
                window.setTimeout(relayoutGrid, 100);
            }
            else {
                $('.pvtAxisLabel').last().prop('colspan', 2);
                //remove the last cell on the tr due to the above change
                $('.pvtAxisLabel').last().next().remove();
            }
        }


        relayoutGrid();
    }
}
