"use strict";
var __esDecorate = (this && this.__esDecorate) || function (ctor, descriptorIn, decorators, contextIn, initializers, extraInitializers) {
    function accept(f) { if (f !== void 0 && typeof f !== "function") throw new TypeError("Function expected"); return f; }
    var kind = contextIn.kind, key = kind === "getter" ? "get" : kind === "setter" ? "set" : "value";
    var target = !descriptorIn && ctor ? contextIn["static"] ? ctor : ctor.prototype : null;
    var descriptor = descriptorIn || (target ? Object.getOwnPropertyDescriptor(target, contextIn.name) : {});
    var _, done = false;
    for (var i = decorators.length - 1; i >= 0; i--) {
        var context = {};
        for (var p in contextIn) context[p] = p === "access" ? {} : contextIn[p];
        for (var p in contextIn.access) context.access[p] = contextIn.access[p];
        context.addInitializer = function (f) { if (done) throw new TypeError("Cannot add initializers after decoration has completed"); extraInitializers.push(accept(f || null)); };
        var result = (0, decorators[i])(kind === "accessor" ? { get: descriptor.get, set: descriptor.set } : descriptor[key], context);
        if (kind === "accessor") {
            if (result === void 0) continue;
            if (result === null || typeof result !== "object") throw new TypeError("Object expected");
            if (_ = accept(result.get)) descriptor.get = _;
            if (_ = accept(result.set)) descriptor.set = _;
            if (_ = accept(result.init)) initializers.unshift(_);
        }
        else if (_ = accept(result)) {
            if (kind === "field") initializers.unshift(_);
            else descriptor[key] = _;
        }
    }
    if (target) Object.defineProperty(target, contextIn.name, descriptor);
    done = true;
};
var __runInitializers = (this && this.__runInitializers) || function (thisArg, initializers, value) {
    var useValue = arguments.length > 2;
    for (var i = 0; i < initializers.length; i++) {
        value = useValue ? initializers[i].call(thisArg, value) : initializers[i].call(thisArg);
    }
    return useValue ? value : void 0;
};
var __setFunctionName = (this && this.__setFunctionName) || function (f, name, prefix) {
    if (typeof name === "symbol") name = name.description ? "[".concat(name.description, "]") : "";
    return Object.defineProperty(f, "name", { configurable: true, value: prefix ? "".concat(prefix, " ", name) : name });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PivottableComponent = exports.aggregateColumn = exports.studentCountColumn = exports.gstudentCount = exports.filterBy2 = exports.filterBy = exports.reportData = exports.populateReport = exports.inclusions = void 0;
/// <reference path="../../../app.config.ts" />
var core_1 = require("@angular/core");
require("node_modules/pivottable/dist/pivot.js");
var paginator_1 = require("@angular/material/paginator");
//import ReportDebugInformationComponent
var reportdebuginformation_component_1 = require("../../reportcontrols/reportdebuginformation.component");
//import * as XLSX from '../../../../lib/xlsx-js-style/dist/xlsx.bundle.js'
var XLSX = require("../../../../lib/xlsx-js-style/xlsx.js");
var PivottableComponent = function () {
    var _classDecorators = [(0, core_1.Component)({
            selector: 'app-pivottable',
            templateUrl: './pivottable.component.html',
            styleUrls: ['./pivottable.component.scss'],
            encapsulation: core_1.ViewEncapsulation.None
        })];
    var _classDescriptor;
    var _classExtraInitializers = [];
    var _classThis;
    var _reportDataDto_decorators;
    var _reportDataDto_initializers = [];
    var _reportDataDto_extraInitializers = [];
    var _paginator_decorators;
    var _paginator_initializers = [];
    var _paginator_extraInitializers = [];
    var _searchContainer_decorators;
    var _searchContainer_initializers = [];
    var _searchContainer_extraInitializers = [];
    var PivottableComponent = _classThis = /** @class */ (function () {
        function PivottableComponent_1(renderer, dialog) {
            this.renderer = renderer;
            this.dialog = dialog;
            this.reportDataDto = __runInitializers(this, _reportDataDto_initializers, void 0);
            this.paginator = (__runInitializers(this, _reportDataDto_extraInitializers), __runInitializers(this, _paginator_initializers, void 0));
            this.searchContainer = (__runInitializers(this, _paginator_extraInitializers), __runInitializers(this, _searchContainer_initializers, void 0));
            this.currentPage = (__runInitializers(this, _searchContainer_extraInitializers), 0);
            this.itemsPerPage = 10;
            /* console.log('constructor');*/
            this.populateReport = this.populateReport.bind(this);
            this.markSearchFields = this.markSearchFields.bind(this);
            this.restoreSearchFields = this.restoreSearchFields.bind(this);
        }
        PivottableComponent_1.prototype.openDialog = function (data) {
            this.dialog.open(reportdebuginformation_component_1.ReportDebugInformationComponent, {
                width: '1000px',
                minHeight: '700px',
                maxHeight: '1200px',
                data: data
            });
        };
        PivottableComponent_1.prototype.closeDialog = function () {
            this.dialog.closeAll();
        };
        PivottableComponent_1.prototype.ngOnInit = function () {
            exports.filterBy = {};
            exports.filterBy2 = {};
            //studentCountColumn = "studentCount";
            //aggregateColumn = "sex";
            exports.inclusions = {};
            exports.gstudentCount = this.studentCount;
            exports.reportData = JSON.parse(JSON.stringify(this.reportDataDto));
            /*console.log('ngOnInit');*/
            this.populateReport();
            //        this.paginator.firstPage();
            $('.pvtAxisLabel').find('span').remove();
            $("body").on("keyup", ".filter", function (e) {
                if (e.key === 'Enter' || e.keyCode === 13) {
                    if ($(this).val() != '') {
                        exports.inclusions[$(this).parent().text()] = $(this).val();
                        $('.pvtAxisLabel').find('input').each(function () {
                            exports.filterBy['filterCol'] = $(this).closest('.pvtAxisLabel').text();
                            exports.filterBy['filterValue'] = $(this).val();
                            var colKey = $(this).closest('.pvtAxisLabel').text();
                            colKey = colKey.replace('*', '');
                            exports.filterBy2[colKey] = $(this).val();
                        });
                        this.populateReport();
                    }
                }
            });
            $("body").on("click", "#btnSearch", function (e) {
                $('.pvtAxisLabel').find('input').each(function () {
                    exports.filterBy['filterCol'] = $(this).closest('.pvtAxisLabel').text();
                    exports.filterBy['filterValue'] = $(this).val();
                    var colKey = $(this).closest('.pvtAxisLabel').text();
                    colKey = colKey.replace('*', '');
                    exports.filterBy2[colKey] = $(this).val();
                });
                this.populateReport();
            });
        };
        PivottableComponent_1.prototype.onSearch = function () {
            $('.pvtAxisLabel').find('input').each(function () {
                exports.filterBy['filterCol'] = $(this).closest('.pvtAxisLabel').text();
                exports.filterBy['filterValue'] = $(this).val();
                var colKey = $(this).closest('.pvtAxisLabel').text();
                colKey = colKey.replace('*', '');
                exports.filterBy2[colKey] = $(this).val();
            });
            this.populateReport();
        };
        ;
        // Update Pivot.js table when pagination changes
        PivottableComponent_1.prototype.pageChange = function (event) {
            this.currentPage = event.pageIndex;
            this.itemsPerPage = event.pageSize;
            this.populateReport();
        };
        ;
        PivottableComponent_1.prototype.ngOnChanges = function (changes) {
            /* console.log('ngOnChanges');*/
            if (this.reportInputChanges(changes)) {
                exports.filterBy2 = {};
            }
            for (var prop in changes) {
                if (changes.hasOwnProperty(prop)) {
                    exports.reportData = JSON.parse(JSON.stringify(this.reportDataDto));
                    this.populateReport();
                }
            }
        };
        PivottableComponent_1.prototype.reportInputChanges = function (changes) {
            var ret = false;
            var previousParams = changes['reportDataDto']['previousValue'];
            if (!previousParams)
                return true;
            var currentParams = changes['reportDataDto']['currentValue'];
            if (!this.isNullOrUndefined(currentParams)) {
                if (currentParams.reportTitle !== previousParams.reportTitle
                    //    || currentParams.categorySets[0].organizationLevelCode !== previousParams.categorySets[0].organizationLevelCode
                    || currentParams.reportYear !== previousParams.reportYear
                    || currentParams.reportCategorySetCode !== previousParams.reportCategorySetCode) {
                    ret = true;
                }
                if (currentParams.reportTitle !== previousParams.reportTitle) {
                    if ($('#searchTable').is(':checked'))
                        $('#searchTable').click();
                }
            }
            return ret;
        };
        PivottableComponent_1.prototype.isNullOrUndefined = function (value) {
            return value === null || value === undefined;
        };
        PivottableComponent_1.prototype.ngAfterViewInit = function () {
            exports.reportData = JSON.parse(JSON.stringify(this.reportDataDto));
        };
        PivottableComponent_1.prototype.onResetFilter = function () {
            exports.filterBy2 = {};
            this.populateReport();
        };
        PivottableComponent_1.prototype.markSearchFields = function () {
            var _this = this;
            if ($('.pvtAxisLabel').length == 0) {
                window.setTimeout(function () { _this.markSearchFields(); }, 100);
            }
            else {
                $('.pvtAxisLabel').each(function (index, element) {
                    var text = element.innerHTML;
                    if ($(element).find('.filter').length == 0) {
                        var searchField = _this.renderer.createElement('div');
                        _this.renderer.addClass(searchField, 'search-container');
                        var inputField = _this.renderer.createElement('input');
                        _this.renderer.setAttribute(inputField, 'type', 'text');
                        _this.renderer.addClass(inputField, 'filter');
                        _this.renderer.setAttribute(inputField, 'placeholder', text);
                        var button = _this.renderer.createElement('button');
                        _this.renderer.listen(button, 'click', _this.onSearch.bind(_this));
                        var icon = _this.renderer.createElement('i');
                        _this.renderer.addClass(icon, 'fa');
                        _this.renderer.addClass(icon, 'fa-search');
                        _this.renderer.appendChild(button, icon);
                        _this.renderer.appendChild(searchField, inputField);
                        _this.renderer.appendChild(searchField, button);
                        _this.renderer.appendChild(element, searchField);
                        //    this.renderer.setStyle(this.renderer.selectRootElement('.pvtAxisLabel .filter'), 'width', '8em');
                    }
                });
            }
        };
        PivottableComponent_1.prototype.restoreSearchFields = function () {
            this.markSearchFields();
            if ($('.pvtAxisLabel').length == 0) {
                window.setTimeout(this.restoreSearchFields, 100);
            }
            else {
                for (var key in exports.filterBy2) {
                    $('.pvtAxisLabel').each(function (index, element) {
                        if (element.innerHTML.indexOf(key) > -1) {
                            $(element).find('input').val(exports.filterBy2[key]);
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
        };
        PivottableComponent_1.prototype.onToggleSearchFilter = function () {
            if ($('#searchTable').prop("checked")) {
                $('#resetFilter').show();
                $('.pvtAxisLabel .search-container').show();
            }
            else {
                $('#resetFilter').hide();
                $('.pvtAxisLabel .search-container').hide();
            }
            this.markSearchFields();
        };
        PivottableComponent_1.prototype.studentCount = function () {
            return function () {
                return {
                    studentCount: 0,
                    push: function (record) {
                        return this[exports.studentCountColumn] = record[exports.studentCountColumn];
                    },
                    value: function () {
                        return this[exports.studentCountColumn];
                    },
                    format: function (x) {
                        //format with thousands separators
                        return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                    },
                    numInputs: 0
                };
            };
        };
        PivottableComponent_1.prototype.replaceCategoryOptionCodes = function () {
            var categoryOptionName = '';
            for (var i = 0; i < this.reportDataDto.categorySets[0].categoryOptions.length; i++) {
                var option = this.reportDataDto.categorySets[0].categoryOptions[i];
                option.categoryOptionCode = option.categoryOptionName;
            }
            return categoryOptionName;
        };
        PivottableComponent_1.prototype.populateReport = function () {
            var self = this;
            if (this.isNullOrUndefined(exports.reportData) || Object.keys(exports.reportData).length === 0)
                return;
            var derivers = $.pivotUtilities.derivers;
            var viewDef = JSON.parse(exports.reportData.categorySets[0].viewDefinition);
            var rowDisplayFields = viewDef.rowFields;
            var columnDisplayFields = viewDef.columnFields;
            var derivedAttributes = {};
            var uiData = exports.reportData.data;
            uiData = JSON.parse(JSON.stringify(this.reportDataDto.data));
            if (uiData[0] !== undefined && uiData[0].parentOrganizationIdentifierSea !== undefined) {
                uiData = uiData
                    .sort(function (a, b) {
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
                .sort(function (a, b) {
                var nameA = String(a.organizationName).toUpperCase(); // ignore upper and lowercase
                var nameB = String(b.organizationName).toUpperCase(); // ignore upper and lowercase
                if (nameA < nameB) {
                    //console.log('-1 : ' + nameA + ' , ' + nameB);
                    return -1;
                }
                if (nameA > nameB) {
                    //console.log('1 : ' + nameA + ' , ' + nameB);
                    return 1;
                }
                //console.log('0 : ' + nameA + ' , ' + nameB);
                return 0;
            })
                //.sort((a, b) => {
                //    if (a.OrganizationIdentifierSea < b.OrganizationIdentifierSea) {
                //        return -1;
                //    }
                //    if (a.OrganizationIdentifierSea > b.OrganizationIdentifierSea) {
                //        return 1;
                //    }
                //    return 0;
                //})
                .filter(function (d) {
                if (Object.keys(exports.filterBy2).length === 0) {
                    return true;
                }
                var matchFound = true;
                for (var i = 0; i < Object.keys(exports.filterBy2).length; i++) {
                    if (exports.filterBy2[Object.keys(exports.filterBy2)[i]] != "") {
                        if (viewDef.fields.find(function (f) { return f.header === Object.keys(exports.filterBy2)[i]; }) !== undefined) {
                            var dataValue = d[viewDef.fields.find(function (f) { return f.header === Object.keys(exports.filterBy2)[i]; }).binding];
                            var searchValue = exports.filterBy2[Object.keys(exports.filterBy2)[i]];
                            var categoryOption = exports.reportData.categorySets[0].categoryOptions.find(function (o) { return o.categoryOptionCode.toLowerCase() == dataValue.toLowerCase(); });
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
                }
                return matchFound;
            });
            if (uiData.length > 0) {
                if (exports.reportData.categorySets[0].organizationLevelCode.toLowerCase() == "sea") {
                    this.paginator.disabled = true;
                }
                else {
                    this.paginator.disabled = false;
                    // Apply pagination
                    var startIndex = this.currentPage * this.itemsPerPage;
                    if (startIndex > 0) {
                        startIndex--; // This is necessary on any page past page 1 to accomodate 0-based indexes
                    }
                    var organizationCount = 0;
                    var firstRecordIndex = -1;
                    var currentOrganization = uiData[0].organizationIdentifierSea;
                    for (var i = 0; i < uiData.length; i++) {
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
                        this.currentPage = 0;
                    }
                    var lastRecordIndex = -1;
                    var organizationCounter = 0;
                    currentOrganization = "";
                    for (var i = firstRecordIndex; i < uiData.length; i++) {
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
            this.paginator.length = new Set(this.reportDataDto.data.filter(function (d) {
                if (Object.keys(exports.filterBy2).length === 0) {
                    return true;
                }
                var matchFound = true;
                for (var i = 0; i < Object.keys(exports.filterBy2).length; i++) {
                    if (exports.filterBy2[Object.keys(exports.filterBy2)[i]] != "") {
                        if (viewDef.fields.find(function (f) { return f.header === Object.keys(exports.filterBy2)[i]; }) !== undefined) {
                            var dataValue = d[viewDef.fields.find(function (f) { return f.header === Object.keys(exports.filterBy2)[i]; }).binding];
                            var searchValue = exports.filterBy2[Object.keys(exports.filterBy2)[i]];
                            var categoryOption = exports.reportData.categorySets[0].categoryOptions.find(function (o) { return o.categoryOptionName.toLowerCase() === searchValue.toLowerCase(); });
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
                }
                return matchFound;
            }).map(function (item) { return item.organizationIdentifierSea; })).size;
            rowDisplayFields.items.forEach(function (r) {
                viewDef.fields.forEach(function (f) {
                    if (r === f.header) {
                        derivedAttributes[r] = function (mp) {
                            return mp[f.binding];
                        };
                    }
                });
            });
            columnDisplayFields.items.forEach(function (r) {
                viewDef.fields.forEach(function (f) {
                    if (r === f.header) {
                        derivedAttributes[r] = function (mp) {
                            return mp[f.binding] != null ? mp[f.binding] : 0;
                        };
                    }
                });
            });
            derivedAttributes["organizationStateId"] = function (mp) {
                return mp["organizationIdentifierSea"];
            };
            exports.reportData.categorySets[0].categories.forEach(function (c) {
                uiData.forEach(function (d) {
                    viewDef.fields.forEach(function (f) {
                        if (c === f.header) {
                            exports.reportData.categorySets[0].categoryOptions.forEach(function (o) {
                                //if (o.categoryOptionCode === d[f.binding]) {
                                if (o.categoryOptionCode.toLowerCase() === d[f.binding].toLowerCase()) {
                                    d[f.binding] = o.categoryOptionName;
                                }
                            });
                        }
                    });
                });
            });
            //find out the column of student count in the data dto.
            viewDef.fields.forEach(function (f) {
                //Could get 'Count' from valueFields	
                if ("Count" === f.header && f.aggregate == 1) {
                    exports.studentCountColumn = f.binding;
                }
            });
            var len = viewDef.columnFields.items.length;
            exports.aggregateColumn = viewDef.columnFields.items[len - 1];
            function displayDebugInfo(e, value, filters, pivotData) {
                //let categorySetCode = reportData.categorySets[0].categorySetCode;
                /*console.log(reportData);*/
                var reportYear = exports.reportData.reportYear;
                var reportLevel = exports.reportData.data[0].reportLevel;
                var categorySetCode = exports.reportData.data[0].categorySetCode;
                var reportCode = exports.reportData.data[0].reportCode;
                //  let headers = reportData.categorySets[0].categories;
                var bindings = ["k12StudentStudentIdentifierState"];
                var headers = ["Student Id"];
                //console.log('reportLevel');
                //console.log(reportLevel);
                if (reportLevel == 'lea') {
                    bindings.push('leaIdentifierSea');
                    headers.push('LEA ID');
                }
                if (reportLevel == 'sch') {
                    bindings.push('leaIdentifierSea');
                    headers.push('LEA ID');
                    bindings.push('schoolIdentifierSea');
                    headers.push('School ID');
                }
                var selectedFilter = {};
                var _loop_1 = function (key) {
                    if (filters.hasOwnProperty(key)) {
                        /*console.log('key is :' + key);*/
                        var column = viewDef.fields.find(function (f) { return f.header === key; }).binding;
                        if (column) {
                            if (column === 'organizationIdentifierSea') {
                                selectedFilter[column] = filters[key];
                            }
                            if (column === 'tableTypeAbbrv') {
                                //var col = e.srcElement.classList[2];
                                //var keys = String(pivotData.colKeys);
                                //var split_keys = keys.split(",");
                                //if (col === 'col0') {
                                //    selectedFilter[column] = split_keys[0];
                                //}
                                //else if (col === 'col1') {
                                //    selectedFilter[column] = split_keys[1];
                                //}
                                selectedFilter[column] = filters[key];
                                bindings.push(column);
                                headers.push('TableTypeAbbrv');
                            }
                            //if (column === 'gradelevel') {
                            //    let categoryOption = reportData.categorySets[0].categoryOptions.find(f => f.categoryOptionCode === filters[key]);
                            //    filters[key] = categoryOption.categoryOptionName;
                            //}
                            /*console.log('option is: ' + filters[key]);*/
                            var categoryOption = exports.reportData.categorySets[0].categoryOptions.find(function (f) { return f.categoryOptionName === filters[key]; });
                            if (categoryOption) {
                                selectedFilter[column] = categoryOption.categoryOptionCode;
                                // for displaying
                                bindings.push(column);
                                headers.push(categoryOption.categoryName);
                            }
                        }
                        var binding = viewDef.fields.find(function (item) { return item === key; });
                        for (var k in binding) {
                            if (binding.hasOwnProperty(k)) {
                            }
                        }
                    }
                };
                for (var key in filters) {
                    _loop_1(key);
                }
                var countColumn = viewDef.fields.find(function (f) { return f.header === 'Count'; }).binding;
                if (countColumn) {
                    bindings.push(countColumn);
                    headers.push('Count');
                }
                var selectedFilterJson = JSON.stringify(selectedFilter);
                var data = {
                    reportData: exports.reportData,
                    recordCount: value,
                    filters: selectedFilterJson,
                    reportYear: exports.reportData.reportYear,
                    reportLevel: exports.reportData.data[0].reportLevel,
                    categorySetCode: exports.reportData.data[0].categorySetCode,
                    reportCode: exports.reportData.data[0].reportCode,
                    bindings: bindings,
                    headers: headers
                };
                self.openDialog(data);
            }
            $("#container").pivotUI(uiData, {
                showUI: false,
                rows: viewDef.rowFields.items, cols: viewDef.columnFields.items,
                aggregators: {
                    aggregateColumn: exports.gstudentCount
                },
                derivedAttributes: derivedAttributes,
                rendererOptions: {
                    table: {
                        rowTotals: false,
                        colTotals: false,
                        rendererName: "Table",
                        clickCallback: function (e, value, filters, pivotData) {
                            var names = [];
                            displayDebugInfo(e, value, filters, pivotData);
                            pivotData.forEachMatchingRecord(filters, function (record) { names.push(record.Name); });
                        }
                    }
                }
            }, true);
            $.fn.textWidth = function (text, font) {
                if (!$.fn.textWidth.fakeEl)
                    $.fn.textWidth.fakeEl = $('<span>').hide().appendTo(document.body);
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
        };
        PivottableComponent_1.prototype.exportToExcel = function (exportFile) {
            this.self = this;
            if (Object.keys(exports.reportData).length === 0)
                return;
            var derivers = $.pivotUtilities.derivers;
            var viewDef = JSON.parse(exports.reportData.categorySets[0].viewDefinition);
            var rowDisplayFields = viewDef.rowFields;
            var columnDisplayFields = viewDef.columnFields;
            var derivedAttributes = {};
            rowDisplayFields.items.forEach(function (r) {
                viewDef.fields.forEach(function (f) {
                    if (r === f.header) {
                        derivedAttributes[r] = function (mp) {
                            return mp[f.binding];
                        };
                    }
                });
            });
            columnDisplayFields.items.forEach(function (r) {
                viewDef.fields.forEach(function (f) {
                    if (r === f.header) {
                        derivedAttributes[r] = function (mp) {
                            return mp[f.binding] != null ? mp[f.binding] : 0;
                        };
                    }
                });
            });
            derivedAttributes["organizationStateId"] = function (mp) {
                return mp["organizationIdentifierSea"];
            };
            exports.reportData.categorySets[0].categories.forEach(function (c) {
                exports.reportData.data.forEach(function (d) {
                    viewDef.fields.forEach(function (f) {
                        if (c === f.header) {
                            exports.reportData.categorySets[0].categoryOptions.forEach(function (o) {
                                if (o.categoryOptionCode === d[f.binding]) {
                                    d[f.binding] = o.categoryOptionName;
                                }
                            });
                        }
                    });
                });
            });
            //find out the column of student count in the data dto.
            viewDef.fields.forEach(function (f) {
                //Could get 'Count' from valueFields	
                if ("Count" === f.header && f.aggregate == 1) {
                    exports.studentCountColumn = f.binding;
                }
            });
            var len = viewDef.columnFields.items.length;
            exports.aggregateColumn = viewDef.columnFields.items[len - 1];
            $("#containerExport").pivotUI(exports.reportData.data, {
                showUI: false,
                rows: viewDef.rowFields.items, cols: viewDef.columnFields.items,
                aggregators: {
                    aggregateColumn: exports.gstudentCount
                },
                filter: function (rowObj) {
                    for (var key in exports.filterBy2) {
                        if (rowObj[key] === undefined || rowObj[key].indexOf(exports.filterBy2[key]) < 0)
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
                            pivotData.forEachMatchingRecord(filters, function (record) { names.push(record.Name); });
                        }
                    }
                },
                onRefresh: function (config) {
                    var html = $("#containerExport").html();
                    var table = document.getElementsByClassName('pvtTable');
                    var colLength = $('#containerExport .pvtTable thead').find('tr:nth-child(1)').children().length;
                    $('#containerExport .pvtTable thead').prepend('<tr><td></td></tr><tr><td></td></tr><tr><td></td></tr><tr><td></td></tr>');
                    //Add more rows above, have to change tr:nth-child(5)
                    var firstEmptyCellSpan = $('#containerExport .pvtTable thead tr:last th').length - 2;
                    // The colspan for the first empty cell in the header
                    $('#containerExport .pvtTable thead').find('tr:nth-child(5)').find('th:first').prop('colspan', firstEmptyCellSpan);
                    $('#containerExport .pvtTable thead').find('tr:nth-child(3)').find('th:first').prop('background-color', 'red');
                    $("#containerExport .pvtTable .pvtRowLabel").prop('colspan', '1');
                    var start = Date.now();
                    var wb = XLSX.utils.table_to_book(table[1], { sheet: 'Generate Report' });
                    //    const wb = XLSX.utils.table_to_book(table, { sheet: 'StyledSheet' });
                    var count = $('#containerExport .pvtTable tr').length;
                    /*                console.log(count)*/
                    //pvtAxisLabel
                    $('#containerExport .pvtTable th').css('color', 'red');
                    var ws = wb.Sheets['Generate Report'];
                    //Set Column width
                    var wscols = [
                        { wpx: 100 },
                        { wpx: 70 }
                    ];
                    var reportCaption = $('.generate-app-report__title').text();
                    var index = reportCaption.indexOf(':');
                    var reportCode = reportCaption.substring(0, index);
                    var colWidth = 150;
                    var category = $('.generate-app-pivotgrid__categoryset-definition span').html();
                    //Column C
                    if (reportCode.toLowerCase() == "002") {
                        if (category.toLowerCase() == "category set a" || category.toLowerCase() == "category set b" || category.toLowerCase() == "category set c"
                            || category.toLowerCase() == "category set d") {
                            colWidth = 220;
                        }
                    }
                    else if (reportCode.toLowerCase() == "005") {
                        if (category.toLowerCase() == "category set a" || category.toLowerCase() == "category set b" || category.toLowerCase() == "category set c" || category.toLowerCase() == "category set c" || category.toLowerCase() == "category set d") {
                            colWidth = 500;
                        }
                    }
                    else if (reportCode.toLowerCase() == "009") {
                        if (category.toLowerCase() == "category set a") {
                            colWidth = 220;
                        }
                    }
                    else if (reportCode.toLowerCase() == "089") {
                        if (category.toLowerCase() == "category set a" || category.toLowerCase() == "category set b") {
                            colWidth = 220;
                        }
                        else if (category.toLowerCase() == "category set c" || category.toLowerCase() == "category set d") {
                            colWidth = 250;
                        }
                    }
                    wscols.push({ wpx: colWidth });
                    if (firstEmptyCellSpan > 2) {
                        if (reportCode.toLowerCase() == "175" || reportCode.toLowerCase() == "178") {
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
                            }
                            else if (category.toLowerCase() == "category set i") {
                                wscols.push({ wpx: 200 });
                                wscols.push({ wpx: 300 }); //Column E
                            }
                            else if (category.toLowerCase() == "category set j") {
                                wscols.push({ wpx: 200 });
                                wscols.push({ wpx: 180 }); //Column E
                            }
                            else {
                                wscols.push({ wpx: 180 }); //Column D
                            }
                        }
                        else if (reportCode.toLowerCase() == "179") {
                            //Starting from Column A
                            wscols = [
                                { wpx: 120 },
                                { wpx: 70 },
                                { wpx: 110 },
                            ];
                            if (category.toLowerCase() == "category set a") {
                                wscols.push({ wpx: 150 });
                                wscols.push({ wpx: 200 }); //Column E
                            }
                            else if (category.toLowerCase() == "category set b" || category.toLowerCase() == "category set c"
                                || category.toLowerCase() == "category set d" || category.toLowerCase() == "category set f" || category.toLowerCase() == "category set g"
                                || category.toLowerCase() == "category set h") {
                                wscols.push({ wpx: 150 });
                                wscols.push({ wpx: 175 }); //Column E
                            }
                            else if (category.toLowerCase() == "category set e") {
                                wscols.push({ wpx: 150 });
                                wscols.push({ wpx: 225 }); //Column E
                            }
                            else if (category.toLowerCase() == "category set i") {
                                wscols.push({ wpx: 210 });
                                wscols.push({ wpx: 190 }); //Column E
                            }
                            else if (category.toLowerCase() == "category set j") {
                                wscols.push({ wpx: 200 });
                                wscols.push({ wpx: 180 }); //Column E
                            }
                            else {
                                wscols.push({ wpx: 180 }); //Column D
                            }
                        }
                        else if (reportCode.toLowerCase() == "185") {
                            wscols.push({ wpx: 200 }); //Column D
                            if (category.toLowerCase() == "category set j")
                                wscols.push({ wpx: 180 }); // Column E
                        }
                        else if (reportCode.toLowerCase() == "188") {
                            if (category.toLowerCase() == "subtotal 1")
                                wscols.push({ wpx: 325 }); //Column D
                            else
                                wscols.push({ wpx: 200 }); //Column D
                            if (category.toLowerCase() == "category set j")
                                wscols.push({ wpx: 180 }); // Column E
                        }
                        else if (reportCode.toLowerCase() == "189") {
                            //  wscols.push({ wpx: 200 }); //Column D
                            if (category.toLowerCase() == "category set b" || category.toLowerCase() == "category set c" || category.toLowerCase() == "category set d" || category.toLowerCase() == "category set f")
                                wscols.push({ wpx: 150 }); // Column D
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
                    if (reportCode.toLowerCase() == "005" && category.toLowerCase() == "subtotal 1") {
                        for (var i = 0; i <= dataColumnNumber; i++) {
                            ws['!cols'].push({ wpx: 200 });
                        }
                    }
                    else if ((reportCode.toLowerCase() == "175" || reportCode.toLowerCase() == "178" || reportCode.toLowerCase() == "179") && category.toLowerCase() == "category set j") {
                        for (var i = 0; i <= dataColumnNumber; i++) {
                            ws['!cols'].push({ wpx: 200 });
                        }
                    }
                    else if (reportCode.toLowerCase() == "178" && category.toLowerCase() == "category set j") {
                        for (var i = 0; i <= dataColumnNumber; i++) {
                            ws['!cols'].push({ wpx: 200 });
                        }
                    }
                    else if (reportCode.toLowerCase() == "185") {
                        var dataCol = 200;
                        if (category.toLowerCase() == "category set j" || category.toLowerCase() == "subtotal 1")
                            dataCol = 100;
                        for (var i = 0; i <= dataColumnNumber; i++) {
                            ws['!cols'].push({ wpx: dataCol });
                        }
                    }
                    else if (reportCode.toLowerCase() == "188") {
                        var dataCol = 200;
                        if (category.toLowerCase() == "category set j" || category.toLowerCase() == "subtotal 1")
                            dataCol = 100;
                        for (var i = 0; i <= dataColumnNumber; i++) {
                            ws['!cols'].push({ wpx: dataCol });
                        }
                    }
                    else if (reportCode.toLowerCase() == "189") {
                        var dataCol = 200;
                        if (category.toLowerCase() == "subtotal 1")
                            dataCol = 150;
                        for (var i = 0; i <= dataColumnNumber; i++) {
                            ws['!cols'].push({ wpx: dataCol });
                        }
                    }
                    else {
                        if ($('#containerExport .pvtTable .pvtColLabel').closest('tr').length == 1) {
                            for (var i = 0; i <= dataColumnNumber; i++) {
                                var len = $('#containerExport .pvtTable .pvtColLabel').eq(i).text().length;
                                if (len >= 13) {
                                    ws['!cols'].push({ wpx: 125 });
                                }
                                else {
                                    ws['!cols'].push({ wpx: 85 });
                                }
                            }
                        }
                        else if ($('#containerExport .pvtTable .pvtColLabel').length >= 2) {
                            dataColumnNumber = $("#containerExport .pvtTable .pvtAxisLabel").closest("tr").eq(1).find('.pvtColLabel').length;
                            for (var i = 0; i <= dataColumnNumber; i++) {
                                var len = $("#containerExport .pvtTable .pvtAxisLabel").closest("tr").eq(1).find('.pvtColLabel').eq(i).text().length;
                                if (len >= 13) {
                                    ws['!cols'].push({ wpx: 160 });
                                }
                                else {
                                    ws['!cols'].push({ wpx: 85 });
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
                    var headerRowLength = $('#containerExport .pvtTable thead tr').length - 4; //4 is caption rows
                    for (var i = 0; i < headerRowLength; i++) {
                        ws['!rows'].push({ hpx: 35 });
                    }
                    //Set all data row height
                    var dataRowLength = $('#containerExport .pvtTable tbody tr').length;
                    for (var i = 0; i <= dataRowLength; i++) {
                        if (reportCode.toLowerCase() == "175" || reportCode.toLowerCase() == "178") {
                            ws['!rows'].push({ hpx: 45 });
                        }
                        else if (reportCode.toLowerCase() == "179") {
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
                    var range = XLSX.utils.decode_range(ws['!ref']);
                    //0 index based
                    var colTotal = range.e.c;
                    var rowTotal = range.e.r;
                    //search worksheet ws with the cell type of 's'
                    //pvtAxisLabel with darker
                    var pvtAxisLabels = [];
                    //$('#containerExport .pvtAxisLabel').each(function (index, element) {
                    //    pvtAxisLabels.push(element.getInnerHTML());
                    //});
                    var pvtRowLabels = [];
                    //$('#containerExport .pvtRowLabel').each(function (index, element) {
                    //    pvtRowLabels.push(element.getInnerHTML());
                    //});
                    start = Date.now();
                    colTotal = 3;
                    var titleColSpan = 12;
                    var new_headers = [];
                    for (var i = 0; i <= 2; i++) {
                        new_headers.push('');
                    }
                    new_headers.push($('.generate-app-report__title').text());
                    if (ws["!merges"] !== undefined) {
                        ws["!merges"].push({ s: { r: 0, c: 3 }, e: { r: 0, c: titleColSpan } });
                    }
                    XLSX.utils.sheet_add_aoa(ws, [new_headers], { skipHeader: true, origin: "A1" });
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
                    if (ws["!merges"] !== undefined) {
                        ws["!merges"].push({ s: { r: 1, c: 3 }, e: { r: 1, c: titleColSpan } });
                    }
                    XLSX.utils.sheet_add_aoa(ws, [new_headers], { skipHeader: true, origin: "A2" });
                    ws['D2'].s = { font: { bold: false }, alignment: { horizontal: 'center', vertical: 'center' } };
                    ////generate-app-pivotgrid__total
                    new_headers = [];
                    //for loop to add the new headers to the worksheet
                    for (var i = 0; i <= 2; i++) {
                        new_headers.push('');
                    }
                    new_headers.push($('.generate-app-pivotgrid__total').text());
                    if (ws["!merges"] !== undefined) {
                        ws["!merges"].push({ s: { r: 2, c: 3 }, e: { r: 2, c: titleColSpan } });
                    }
                    XLSX.utils.sheet_add_aoa(ws, [new_headers], { skipHeader: true, origin: "A3" });
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
                    var longest = arr.reduce(function (a, b) {
                        return a.length > b.length ? a : b;
                    });
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
            }, true);
            $.fn.textWidth = function (text, font) {
                if (!$.fn.textWidth.fakeEl)
                    $.fn.textWidth.fakeEl = $('<span>').hide().appendTo(document.body);
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
                    for (var key in exports.filterBy2) {
                        $('.pvtAxisLabel').each(function () {
                            var text = $(this).html();
                            if ($(this).html().indexOf(key) > -1) {
                                $(this).find('input').val(exports.filterBy2[key]);
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
        };
        PivottableComponent_1.prototype.exportToExcel2 = function () {
            if (Object.keys(exports.reportData).length === 0)
                return;
            var derivers = $.pivotUtilities.derivers;
            var viewDef = JSON.parse(exports.reportData.categorySets[0].viewDefinition);
            var rowDisplayFields = viewDef.rowFields;
            var columnDisplayFields = viewDef.columnFields;
            var derivedAttributes = {};
            rowDisplayFields.items.forEach(function (r) {
                viewDef.fields.forEach(function (f) {
                    if (r === f.header) {
                        derivedAttributes[r] = function (mp) {
                            return mp[f.binding];
                        };
                    }
                });
            });
            columnDisplayFields.items.forEach(function (r) {
                viewDef.fields.forEach(function (f) {
                    if (r === f.header) {
                        derivedAttributes[r] = function (mp) {
                            return mp[f.binding] != null ? mp[f.binding] : 0;
                        };
                    }
                });
            });
            derivedAttributes["organizationStateId"] = function (mp) {
                return mp["organizationIdentifierSea"];
            };
            exports.reportData.categorySets[0].categories.forEach(function (c) {
                exports.reportData.data.forEach(function (d) {
                    viewDef.fields.forEach(function (f) {
                        if (c === f.header) {
                            exports.reportData.categorySets[0].categoryOptions.forEach(function (o) {
                                if (o.categoryOptionCode === d[f.binding]) {
                                    d[f.binding] = o.categoryOptionName;
                                }
                            });
                        }
                    });
                });
            });
            //find out the column of student count in the data dto.
            viewDef.fields.forEach(function (f) {
                //Could get 'Count' from valueFields	
                if ("Count" === f.header && f.aggregate == 1) {
                    exports.studentCountColumn = f.binding;
                }
            });
            var len = viewDef.columnFields.items.length;
            exports.aggregateColumn = viewDef.columnFields.items[len - 1];
            $("#containerExport").pivotUI(exports.reportData.data, {
                showUI: false,
                rows: viewDef.rowFields.items, cols: viewDef.columnFields.items,
                aggregators: {
                    aggregateColumn: exports.gstudentCount
                },
                filter: function (rowObj) {
                    for (var key in exports.filterBy2) {
                        if (rowObj[key] === undefined || rowObj[key].indexOf(exports.filterBy2[key]) < 0)
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
                            pivotData.forEachMatchingRecord(filters, function (record) { names.push(record.Name); });
                        }
                    }
                },
                onRefresh: function (config) {
                    /*console.log('completed-onrefresh');*/
                    var html = $("#containerExport").html();
                    var table = document.getElementsByClassName('pvtTable');
                    $('#containerExport .pvtTable thead').prepend('<tr><td>n1</td></tr><tr><td>n2</td></tr>');
                    $("#containerExport .pvtTable tr:first th:first").text('empty');
                    $("#containerExport .pvtTable tr:first th:first").prop('class', 'pvtAxisLabel');
                    $('#containerExport .pvtTable thead tr:first th:first');
                    $(table).find('.pvtTable thead').find('tr:nth-child(3)').find('th:first').prop('colspan', '2');
                    var wb = XLSX.utils.table_to_book(table[1], { sheet: 'StyledSheet' });
                    var count = $('#containerExport .pvtTable tr').length;
                    $('#containerExport .pvtTable th').css('color', 'red');
                    var ws = wb.Sheets['StyledSheet'];
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
                    /*console.log(ref);*/
                    var range = XLSX.utils.decode_range(ws['!ref']);
                    //0 index based
                    var colTotal = range.e.c;
                    var rowTotal = range.e.r;
                    //pvtAxisLabel with darker
                    var pvtAxisLabels = [];
                    //$('#containerExport .pvtAxisLabel').each(function (index, element) {
                    //    pvtAxisLabels.push(element.getInnerHTML());
                    //});
                    var pvtRowLabels = [];
                    //$('#containerExport .pvtRowLabel').each(function (index, element) {
                    //    pvtRowLabels.push(element.getInnerHTML());
                    //});
                    rowTotal = 3;
                    var new_headers = ["S", "h", "e", "e", "t", "J", "S"];
                    XLSX.utils.sheet_add_aoa(ws, [new_headers], { skipHeader: true, origin: "A1" });
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
            }, true);
            $.fn.textWidth = function (text, font) {
                if (!$.fn.textWidth.fakeEl)
                    $.fn.textWidth.fakeEl = $('<span>').hide().appendTo(document.body);
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
                    for (var key in exports.filterBy2) {
                        $('.pvtAxisLabel').each(function () {
                            var text = $(this).html();
                            if ($(this).html().indexOf(key) > -1) {
                                $(this).find('input').val(exports.filterBy2[key]);
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
        };
        return PivottableComponent_1;
    }());
    __setFunctionName(_classThis, "PivottableComponent");
    (function () {
        var _metadata = typeof Symbol === "function" && Symbol.metadata ? Object.create(null) : void 0;
        _reportDataDto_decorators = [(0, core_1.Input)()];
        _paginator_decorators = [(0, core_1.ViewChild)(paginator_1.MatPaginator)];
        _searchContainer_decorators = [(0, core_1.ViewChild)('container', { read: core_1.ElementRef })];
        __esDecorate(null, null, _reportDataDto_decorators, { kind: "field", name: "reportDataDto", static: false, private: false, access: { has: function (obj) { return "reportDataDto" in obj; }, get: function (obj) { return obj.reportDataDto; }, set: function (obj, value) { obj.reportDataDto = value; } }, metadata: _metadata }, _reportDataDto_initializers, _reportDataDto_extraInitializers);
        __esDecorate(null, null, _paginator_decorators, { kind: "field", name: "paginator", static: false, private: false, access: { has: function (obj) { return "paginator" in obj; }, get: function (obj) { return obj.paginator; }, set: function (obj, value) { obj.paginator = value; } }, metadata: _metadata }, _paginator_initializers, _paginator_extraInitializers);
        __esDecorate(null, null, _searchContainer_decorators, { kind: "field", name: "searchContainer", static: false, private: false, access: { has: function (obj) { return "searchContainer" in obj; }, get: function (obj) { return obj.searchContainer; }, set: function (obj, value) { obj.searchContainer = value; } }, metadata: _metadata }, _searchContainer_initializers, _searchContainer_extraInitializers);
        __esDecorate(null, _classDescriptor = { value: _classThis }, _classDecorators, { kind: "class", name: _classThis.name, metadata: _metadata }, null, _classExtraInitializers);
        PivottableComponent = _classThis = _classDescriptor.value;
        if (_metadata) Object.defineProperty(_classThis, Symbol.metadata, { enumerable: true, configurable: true, writable: true, value: _metadata });
        __runInitializers(_classThis, _classExtraInitializers);
    })();
    return PivottableComponent = _classThis;
}();
exports.PivottableComponent = PivottableComponent;
//# sourceMappingURL=pivottable.component.js.map