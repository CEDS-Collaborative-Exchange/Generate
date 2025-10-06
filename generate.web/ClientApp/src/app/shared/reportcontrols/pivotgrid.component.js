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
exports.PivotGridComponent = void 0;
var core_1 = require("@angular/core");
var generateReport_service_1 = require("../../services/app/generateReport.service");
var pivottable_component_1 = require("../components/pivottable/pivottable.component");
var rxjs_1 = require("rxjs");
var PivotGridComponent = function () {
    var _classDecorators = [(0, core_1.Component)({
            selector: 'generate-app-pivotgrid',
            templateUrl: './pivotgrid.component.html',
            styleUrls: ['./pivotgrid.component.scss'],
            providers: [generateReport_service_1.GenerateReportService]
        })];
    var _classDescriptor;
    var _classExtraInitializers = [];
    var _classThis;
    var _reportParameters_decorators;
    var _reportParameters_initializers = [];
    var _reportParameters_extraInitializers = [];
    var _pivotComponent_decorators;
    var _pivotComponent_initializers = [];
    var _pivotComponent_extraInitializers = [];
    var PivotGridComponent = _classThis = /** @class */ (function () {
        function PivotGridComponent_1(_router, _generateReportService, _ngZone, appConfig) {
            var _this = this;
            this._router = _router;
            this._generateReportService = _generateReportService;
            this._ngZone = _ngZone;
            this.appConfig = appConfig;
            this.subscriptions = [];
            this.reportParameters = __runInitializers(this, _reportParameters_initializers, void 0);
            this.pivotComponent = (__runInitializers(this, _reportParameters_extraInitializers), __runInitializers(this, _pivotComponent_initializers, void 0));
            this.isLoading = (__runInitializers(this, _pivotComponent_extraInitializers), false);
            this.isPending = false;
            this.isSubmissionFileAvailable = false;
            this.hasRecords = false;
            this.formatToGenerate = '';
            this.pageCount = 0;
            this._groupBy = '';
            this._filter = '';
            this.gridPageNumber = 1;
            this.gridPageCount = 1;
            this.appConfig.getConfig().subscribe(function (res) {
                _this.pageSize = res.pageSize;
            });
            this.reportDataDto = {};
            this.cvData = this.reportDataDto.data;
        }
        PivotGridComponent_1.prototype.ngOnInit = function () {
            var _this = this;
            var self = this;
            this.subscriptions.push(this._generateReportService.getSubmissionReport(this.reportParameters.reportType, this.reportParameters.reportCode)
                .pipe((0, rxjs_1.finalize)(function () { return _this.isLoading = false; }))
                .subscribe(function (data) {
                _this.generateFile = data;
                _this.isSubmissionFileAvailable = true;
            }, function (error) { return _this.errorMessage = error; }));
        };
        PivotGridComponent_1.prototype.ngAfterViewInit = function () {
            componentHandler.upgradeAllRegistered();
            var self = this;
        };
        PivotGridComponent_1.prototype.getCellTitle = function (header, cellValue) {
            var optionValue = '';
            var tooltip = cellValue;
            if (cellValue === 'MISSING') {
                optionValue = 'Missing';
            }
            else {
                if (this.reportParameters.reportCategorySet != null) {
                    for (var i = 0; i < this.reportParameters.reportCategorySet.categoryOptions.length; i++) {
                        var option = this.reportParameters.reportCategorySet.categoryOptions[i];
                        if (header === option.categoryName) {
                            if (cellValue.trim() === option.categoryOptionCode.trim()) {
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
        };
        PivotGridComponent_1.prototype.ngOnChanges = function (changes) {
            for (var prop in changes) {
                if (changes.hasOwnProperty(prop)) {
                    this.populateReport(false);
                }
            }
        };
        Object.defineProperty(PivotGridComponent_1.prototype, "groupBy", {
            get: function () {
                return this._groupBy;
            },
            set: function (value) {
                if (this._groupBy !== value) {
                    this._groupBy = value;
                }
            },
            enumerable: false,
            configurable: true
        });
        Object.defineProperty(PivotGridComponent_1.prototype, "filter", {
            get: function () {
                return this._filter;
            },
            set: function (value) {
                if (this._filter !== value) {
                    this._filter = value;
                    if (this._toFilter) {
                        clearTimeout(this._toFilter);
                    }
                    var self_1 = this;
                    this._toFilter = setTimeout(function () {
                        self_1.cvData.refresh();
                        if (self_1.cvData.itemCount > 0) {
                            self_1.hasRecords = true;
                        }
                        else {
                            self_1.hasRecords = false;
                        }
                    }, 500);
                }
            },
            enumerable: false,
            configurable: true
        });
        PivotGridComponent_1.prototype.refreshData = function (s, e) {
            this.cvData.refresh();
        };
        PivotGridComponent_1.prototype.ngOnDestroy = function () {
            this.subscriptions.forEach(function (subscription) { return subscription.unsubscribe(); });
            this.reportDataDto = null;
        };
        PivotGridComponent_1.prototype.populateReport = function (ispageUpdated) {
            var _this = this;
            this.isSubmissionFileAvailable = false;
            if (this.reportParameters.reportType !== undefined
                && this.reportParameters.reportCode !== undefined
                && this.reportParameters.reportLevel !== undefined
                && this.reportParameters.reportYear !== undefined) {
                //reset the error message from previous report load, if any
                this.errorMessage = null;
                this.isLoading = true;
                if (!ispageUpdated) {
                    this.gridPageNumber = 1;
                }
                // Define take and skip
                //let take = +this.reportParameters.reportPageSize;
                //let skip = (+this.reportParameters.reportPage - 1) * +this.reportParameters.reportPageSize;
                // Retrieve all data
                var take = 0;
                var skip = 0;
                if (this.reportParameters.reportSort === undefined) {
                    this.reportParameters.reportSort = 1;
                }
                var categorySetCode = 'null';
                var tableTypeAbbrv = '';
                if (this.reportParameters.reportCategorySetCode !== undefined) {
                    categorySetCode = this.reportParameters.reportCategorySetCode;
                }
                else {
                    categorySetCode = 'CSA';
                }
                if (this.reportParameters.reportCategorySet !== undefined) {
                    categorySetCode = this.reportParameters.reportCategorySet.categorySetCode;
                }
                if (this.reportParameters.reportTableTypeAbbrv !== undefined) {
                    tableTypeAbbrv = this.reportParameters.reportTableTypeAbbrv;
                }
                console.log(tableTypeAbbrv);
                this.subscriptions.push(this._generateReportService.getPagedReport(this.reportParameters.reportType, this.reportParameters.reportCode, this.reportParameters.reportLevel, this.reportParameters.reportYear, categorySetCode, tableTypeAbbrv, this.reportParameters.reportSort, skip, take, this.pageSize, this.gridPageNumber)
                    .subscribe(function (reportDataDto) {
                    _this.reportDataDto = reportDataDto;
                    _this.cvData = reportDataDto.data;
                    if (reportDataDto.categorySets !== null && reportDataDto.categorySets.length > 0) {
                        _this.reportParameters.reportCategorySet = reportDataDto.categorySets[0];
                        if (_this.reportDataDto === null) {
                            _this.errorMessage = 'Invalid Report';
                        }
                        else {
                            _this.gridPageCount = Math.ceil(_this.reportDataDto.dataCount / _this.pageSize);
                            if ((_this.gridPageCount * _this.pageSize) < _this.reportDataDto.dataCount) {
                                _this.gridPageCount++;
                            }
                            _this.pageCount = Math.ceil(_this.reportDataDto.dataCount / _this.reportParameters.reportPageSize);
                            _this.setPageArray();
                            if (_this.cvData.length > 0) {
                                _this.hasRecords = true;
                            }
                            else if (_this.reportDataDto.dataCount === -1) {
                                _this.hasRecords = true;
                            }
                            else {
                                _this.hasRecords = false;
                            }
                        }
                        _this.isLoading = false;
                        //this.subscriptions.forEach(subscription => subscription.unsubscribe());
                    }
                }, function (error) { return _this.errorMessage = error; }));
                this.subscriptions.push(this._generateReportService.getSubmissionReport(this.reportParameters.reportType, this.reportParameters.reportCode)
                    .pipe((0, rxjs_1.finalize)(function () { return _this.isLoading = false; }))
                    .subscribe(function (data) {
                    _this.generateFile = data;
                    _this.isSubmissionFileAvailable = true;
                }, function (error) { return _this.errorMessage = error; }));
            }
        };
        PivotGridComponent_1.prototype.getReportYear = function () {
            if (this.reportDataDto.reportYear === '2017' || this.reportDataDto.reportYear === '2016' || this.reportDataDto.reportYear === '2015' || this.reportDataDto.reportYear === '2014')
                return true;
            else
                return false;
        };
        PivotGridComponent_1.prototype.getDefaultCategorySet = function (categorySets) {
            if (categorySets === undefined || categorySets.length === 0) {
                return null;
            }
            function compare(a, b) {
                if (a.categorySetName < b.categorySetName)
                    return -1;
                if (a.categorySetName > b.categorySetName)
                    return 1;
                return 0;
            }
            categorySets.sort(compare);
            return categorySets[0];
        };
        PivotGridComponent_1.prototype.dataCountCaption = function () {
            if (this.reportParameters.reportLevel === 'lea') {
                return 'Total LEAs: ';
            }
            else if (this.reportParameters.reportLevel === 'sch') {
                return 'Total Schools: ';
            }
            else {
                return 'Total: ';
            }
        };
        PivotGridComponent_1.prototype.showCategorySetLabel = function () {
            var isShow = true;
            if (this.reportParameters.reportLevel === 'sch' && this.reportParameters.reportCode === 'c059') {
                isShow = false;
            }
            return isShow;
        };
        PivotGridComponent_1.prototype.setReportPage = function (event, reportPage) {
            if (this.reportParameters.reportPage !== reportPage) {
                this.reportParameters.reportPage = reportPage;
                this.populateReport(false);
            }
            return false;
        };
        PivotGridComponent_1.prototype.moveCurrentToNext = function (s, e) {
            var cv = this.cvData;
            cv.refresh();
        };
        PivotGridComponent_1.prototype.export = function () {
            var sheetName = this.reportParameters.reportCode.toUpperCase();
            var reportCategorySetCode = this.reportParameters.reportCategorySetCode !== undefined ? this.reportParameters.reportCategorySetCode : '';
            var fileName = this.reportParameters.reportCode.toUpperCase() + ' - ' + this.reportParameters.reportYear + ' - ' + this.reportParameters.reportLevel.toUpperCase() + ' - ' + reportCategorySetCode + '.xlsx';
            this.pivotComponent.exportToExcel(fileName);
            return;
        };
        PivotGridComponent_1.prototype._filterFunction = function (item) {
            if (this._filter) {
                var isFiltered = false;
                if (item.organizationName.toLowerCase().indexOf(this._filter.toLowerCase()) > -1) {
                    isFiltered = true;
                }
                if (!isFiltered) {
                    if (item.organizationStateId.toLowerCase().indexOf(this._filter.toLowerCase()) > -1) {
                        isFiltered = true;
                    }
                }
                return isFiltered;
            }
            return true;
        };
        PivotGridComponent_1.prototype.setPageArray = function () {
            var pageArrayStart = 1;
            var pageArrayEnd = 5;
            if (this.reportParameters.reportPage === 1) {
                pageArrayStart = 1;
            }
            else {
                pageArrayStart = (Math.floor((this.reportParameters.reportPage - 1) / 5) * 5) + 1;
            }
            pageArrayEnd = pageArrayStart + 4;
            if (pageArrayEnd > this.pageCount) {
                pageArrayEnd = this.pageCount;
            }
            this.pageArray = new Array();
            for (var i = pageArrayStart; i <= pageArrayEnd; i++) {
                this.pageArray.push(i);
            }
        };
        PivotGridComponent_1.prototype.activeReportPageCss = function (reportPage) {
            if (this.reportParameters.reportPage === reportPage) {
                return 'mdl-button--raised mdl-button--accent';
            }
            else {
                return '';
            }
        };
        PivotGridComponent_1.prototype.backPageDisabled = function () {
            if (this.reportParameters.reportPage === 1) {
                return 'disabled';
            }
            else {
                return '';
            }
        };
        PivotGridComponent_1.prototype.forwardPageDisabled = function () {
            if (this.reportParameters.reportPage === this.pageCount) {
                return 'disabled';
            }
            else {
                return '';
            }
        };
        PivotGridComponent_1.prototype.createSubmissionFile = function (dlg, format) {
            this.formatToGenerate = format;
            if (dlg) {
                dlg.modal = true;
                dlg.show();
            }
        };
        PivotGridComponent_1.prototype.getDownloadFileType = function (format) {
            if (format === 'csv' || format === 'txt') {
                return 'text/csv';
            }
            else if (format === 'tab') {
                return 'application/vnd.ms-excel';
            }
            else if (format === 'xml') {
                return 'text/xml';
            }
        };
        PivotGridComponent_1.prototype.leadingZero = function (value) {
            if (value < 10) {
                return '0' + value.toString();
            }
            return value.toString();
        };
        PivotGridComponent_1.prototype.getFileSubmission = function (dlg) {
            if (dlg) {
                dlg.hide();
            }
            var format = this.formatToGenerate;
            this.isPending = true;
            var self = this;
            // Get State ANSI Code
            var stateCode = '';
            if (this.reportDataDto !== undefined && this.reportDataDto.data.length > 0) {
                var row = this.reportDataDto.data[0];
                if (row.stateAbbreviationCode !== undefined) {
                    stateCode = row.stateAbbreviationCode;
                }
                else {
                    stateCode = row.stateCode;
                }
            }
            var reportType = this.reportParameters.reportType;
            var reportCode = this.reportParameters.reportCode;
            var reportLevel = this.reportParameters.reportLevel;
            var reportYear = this.reportParameters.reportYear;
            var formatType = this.getDownloadFileType(format);
            var currentDate = new Date();
            var version = 'v' + this.leadingZero(currentDate.getDate()) + this.leadingZero(currentDate.getMinutes()) + this.leadingZero(currentDate.getSeconds());
            var fileName = stateCode + reportLevel.toUpperCase() + version + '.' + format;
            if (this.generateFile !== undefined) {
                fileName = stateCode + reportLevel.toUpperCase() + this.generateFile.reportTypeAbbreviation.slice(0, 9) + version + '.' + format;
            }
            var xhr = new XMLHttpRequest();
            var url = 'api/app/filesubmissions/' + reportType + '/' + reportCode + '/' + reportLevel + '/' + reportYear + '/' + format + '/' + fileName;
            xhr.open('GET', url, true);
            xhr.responseType = 'blob';
            xhr.onreadystatechange = function () {
                setTimeout(function () { }, 0);
                if (xhr.readyState === 4 && xhr.status === 200) {
                    self.isPending = false;
                    var blob = new Blob([this.response], { type: formatType });
                    saveAs(blob, fileName);
                }
                else if (xhr.readyState === 4 && xhr.status !== 200) {
                    self.isPending = false;
                    console.log('File submission error');
                    alert('An unknown error occurred while generating the file. Please contact your system administrator.');
                }
            };
            xhr.send();
        };
        PivotGridComponent_1.prototype.setGridPage = function () {
            this.populateReport(true);
            return false;
        };
        PivotGridComponent_1.prototype.updateSliderGridPage = function (n) {
            this.gridPageNumber = n;
            this.setGridPage();
        };
        return PivotGridComponent_1;
    }());
    __setFunctionName(_classThis, "PivotGridComponent");
    (function () {
        var _metadata = typeof Symbol === "function" && Symbol.metadata ? Object.create(null) : void 0;
        _reportParameters_decorators = [(0, core_1.Input)()];
        _pivotComponent_decorators = [(0, core_1.ViewChild)(pivottable_component_1.PivottableComponent)];
        __esDecorate(null, null, _reportParameters_decorators, { kind: "field", name: "reportParameters", static: false, private: false, access: { has: function (obj) { return "reportParameters" in obj; }, get: function (obj) { return obj.reportParameters; }, set: function (obj, value) { obj.reportParameters = value; } }, metadata: _metadata }, _reportParameters_initializers, _reportParameters_extraInitializers);
        __esDecorate(null, null, _pivotComponent_decorators, { kind: "field", name: "pivotComponent", static: false, private: false, access: { has: function (obj) { return "pivotComponent" in obj; }, get: function (obj) { return obj.pivotComponent; }, set: function (obj, value) { obj.pivotComponent = value; } }, metadata: _metadata }, _pivotComponent_initializers, _pivotComponent_extraInitializers);
        __esDecorate(null, _classDescriptor = { value: _classThis }, _classDecorators, { kind: "class", name: _classThis.name, metadata: _metadata }, null, _classExtraInitializers);
        PivotGridComponent = _classThis = _classDescriptor.value;
        if (_metadata) Object.defineProperty(_classThis, Symbol.metadata, { enumerable: true, configurable: true, writable: true, value: _metadata });
        __runInitializers(_classThis, _classExtraInitializers);
    })();
    return PivotGridComponent = _classThis;
}();
exports.PivotGridComponent = PivotGridComponent;
//# sourceMappingURL=pivotgrid.component.js.map