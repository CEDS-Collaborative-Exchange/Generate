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
exports.C035Component = void 0;
var core_1 = require("@angular/core");
var generateReport_service_1 = require("../../services/app/generateReport.service");
var flextable_component_1 = require("../components/flextable/flextable.component");
var C035Component = function () {
    var _classDecorators = [(0, core_1.Component)({
            selector: 'generate-app-c035',
            templateUrl: './c035.component.html',
            styleUrls: ['./c035.component.scss'],
            providers: [generateReport_service_1.GenerateReportService]
        })];
    var _classDescriptor;
    var _classExtraInitializers = [];
    var _classThis;
    var _reportParameters_decorators;
    var _reportParameters_initializers = [];
    var _reportParameters_extraInitializers = [];
    var _flextableComponent_decorators;
    var _flextableComponent_initializers = [];
    var _flextableComponent_extraInitializers = [];
    var C035Component = _classThis = /** @class */ (function () {
        function C035Component_1(_router, _generateReportService, _ngZone, activatedRoute) {
            this._router = _router;
            this._generateReportService = _generateReportService;
            this._ngZone = _ngZone;
            this.activatedRoute = activatedRoute;
            this.reportParameters = __runInitializers(this, _reportParameters_initializers, void 0);
            this.flextableComponent = (__runInitializers(this, _reportParameters_extraInitializers), __runInitializers(this, _flextableComponent_initializers, void 0));
            this.currentReport = __runInitializers(this, _flextableComponent_extraInitializers);
            this.isLoading = false;
            this.isPending = false;
            this.hasRecords = false;
            this.formatToGenerate = '';
            this.pageCount = 0;
            this._groupBy = '';
            this._filter = '';
        }
        C035Component_1.prototype.ngOnInit = function () {
            var self = this;
        };
        C035Component_1.prototype.ngAfterViewInit = function () {
            componentHandler.upgradeAllRegistered();
            var self = this;
        };
        C035Component_1.prototype.populateReport = function () {
            var _this = this;
            if (this.reportParameters.reportType !== undefined
                && this.reportParameters.reportCode !== undefined
                && this.reportParameters.reportLevel !== undefined
                && this.reportParameters.reportYear !== undefined) {
                this.isLoading = true;
                var take = 0;
                var skip = 0;
                if (this.reportParameters.reportSort === undefined) {
                    this.reportParameters.reportSort = 1;
                }
                var categorySetCode = 'null';
                if (this.reportParameters.reportCategorySet !== undefined) {
                    categorySetCode = this.reportParameters.reportCategorySet.categorySetCode;
                }
                var reportLea = 'null';
                if (this.reportParameters.reportLea !== undefined) {
                    reportLea = this.reportParameters.reportLea.split('(')[0].trim();
                }
                var reportSchool = 'null';
                if (this.reportParameters.reportSchool !== undefined) {
                    reportSchool = this.reportParameters.reportSchool.split('(')[0].trim();
                }
                this._generateReportService.getReport(this.reportParameters.reportType, this.reportParameters.reportCode, this.reportParameters.reportLevel, this.reportParameters.reportYear, categorySetCode, this.reportParameters.reportSort, skip, take)
                    .subscribe(function (reportDataDto) {
                    _this.reportDataDto = reportDataDto;
                    _this.cvData = _this.reportDataDto.data;
                    // Replace allocation type codes with descriptions
                    if (_this.cvData && Array.isArray(_this.cvData)) {
                        _this.cvData.forEach(function (row) {
                            if (row.federalFundAllocationType) {
                                row.federalFundAllocationType = _this.getAllocationTypeDescription(row.federalFundAllocationType) || row.federalFundAllocationType;
                            }
                        });
                    }
                    if (_this.reportParameters.reportCategorySet === undefined) {
                        if (_this.reportDataDto.categorySets !== null && _this.reportDataDto.categorySets.length > 0) {
                            _this.reportParameters.reportCategorySet = _this.getDefaultCategorySet(_this.reportDataDto.categorySets);
                        }
                    }
                    if (_this.reportDataDto === null) {
                        _this.errorMessage = 'Invalid Report';
                    }
                    else {
                        _this.pageCount = Math.ceil(_this.reportDataDto.dataCount / +_this.reportParameters.reportPageSize);
                        _this.setPageArray();
                        if (_this.cvData.itemCount > 0) {
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
                });
                this.isLoading = false;
                this._generateReportService.getSubmissionReport(this.reportParameters.reportType, this.reportParameters.reportCode)
                    .subscribe(function (data) {
                    _this.generateFile = data;
                }, function (error) { return _this.errorMessage = error; });
            }
        };
        C035Component_1.prototype.ngOnChanges = function (changes) {
            for (var prop in changes) {
                if (changes.hasOwnProperty(prop)) {
                    this.populateReport();
                }
            }
        };
        Object.defineProperty(C035Component_1.prototype, "groupBy", {
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
        Object.defineProperty(C035Component_1.prototype, "filter", {
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
        C035Component_1.prototype.refreshData = function (s, e) {
            this.cvData.refresh();
        };
        C035Component_1.prototype.itemsSourceChanged = function (s, e) {
            var d = new Date();
            var n = d.getMilliseconds();
            console.log("C035itemsSourceChanged");
            setTimeout(function () {
                if (s.hostElement != null) {
                    var row = s.columnHeaders.rows[0];
                    row.wordWrap = true;
                    s.autoSizeRow(0, true);
                }
            });
        };
        C035Component_1.prototype.getDefaultCategorySet = function (categorySets) {
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
        C035Component_1.prototype.dataCountCaption = function () {
            if (this.reportParameters.reportLevel === 'lea') {
                return 'Total LEAs: ';
            }
            else {
                return 'Total: ';
            }
        };
        C035Component_1.prototype.export = function () {
            var self = this;
            var sheetName = this.reportParameters.reportCode.toUpperCase();
            var fileName = this.reportParameters.reportCode.toUpperCase() + ' - ' + this.reportParameters.reportYear + ' - ' + this.reportParameters.reportLevel.toUpperCase();
            if (this.reportParameters.reportCategorySet !== undefined) {
                fileName += ' - ' + this.reportParameters.reportCategorySet.categorySetName.replace('?', '');
            }
            fileName += ".xlsx";
            var reportTitle = this.reportDataDto.reportTitle;
            var categorySetCaption = this.reportParameters.reportCategorySet.categorySetName;
            var totalCaption = this.dataCountCaption() + " " + this.reportDataDto.dataCount;
            var reportCaptionCol = 2;
            var reportCols = [];
            if (this.reportParameters.reportLevel === 'sea') {
                reportCols.push({ wpx: 250 });
                reportCols.push({ wpx: 100 });
                reportCols.push({ wpx: 150 });
                reportCols.push({ wpx: 150 });
                reportCols.push({ wpx: 260 });
                reportCols.push({ wpx: 150 });
            }
            else if (this.reportParameters.reportLevel === 'lea') {
                reportCols.push({ wpx: 200 });
                reportCols.push({ wpx: 200 });
                reportCols.push({ wpx: 200 });
                reportCols.push({ wpx: 200 });
                reportCaptionCol = 4;
            }
            var reportRows = [
                { hpx: 25 }, // row 1 sets to the height of 12 in points
                { hpx: 23 }, // row 2 sets to the height of 16 in pixels
                { hpx: 20 }, // row 2 sets to the height of 16 in pixels
                { hpx: 20 }, // row 2 sets to the height of 16 in pixels
                { hpx: 45 }, // row 2 sets to the height of 16 in pixels
            ];
            this.flextableComponent.exportToExcel(fileName, reportTitle, categorySetCaption, totalCaption, reportCols, reportRows, reportCaptionCol);
            return;
        };
        C035Component_1.prototype._applyGroupBy = function () {
            var cv = this.cvData;
            cv.beginUpdate();
            cv.groupDescriptions.clear();
            if (this.groupBy) {
                var groupNames = this.groupBy.split(',');
                for (var i = 0; i < groupNames.length; i++) {
                    var groupName = groupNames[i];
                }
                cv.refresh();
            }
            cv.endUpdate();
        };
        C035Component_1.prototype._filterFunction = function (item) {
            if (this._filter) {
                if (this.reportParameters.reportType === 'datapopulation') {
                    return item.rowKey.toLowerCase().indexOf(this._filter.toLowerCase()) > -1;
                }
                else {
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
            }
            return true;
        };
        C035Component_1.prototype.getReportYear = function () {
            if (this.reportDataDto.reportYear === '2016-17' || this.reportDataDto.reportYear === '2015-16' || this.reportDataDto.reportYear === '2014-15' || this.reportDataDto.reportYear === '2013-14')
                return true;
            else
                return false;
        };
        C035Component_1.prototype.setPageArray = function () {
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
        C035Component_1.prototype.activeReportPageCss = function (reportPage) {
            if (this.reportParameters.reportPage === reportPage) {
                return 'mdl-button--raised mdl-button--accent';
            }
            else {
                return '';
            }
        };
        C035Component_1.prototype.backPageDisabled = function () {
            if (this.reportParameters.reportPage === 1) {
                return 'disabled';
            }
            else {
                return '';
            }
        };
        C035Component_1.prototype.forwardPageDisabled = function () {
            if (this.reportParameters.reportPage === this.pageCount) {
                return 'disabled';
            }
            else {
                return '';
            }
        };
        C035Component_1.prototype.createSubmissionFile = function (dlg, format) {
            this.formatToGenerate = format;
            if (dlg) {
                dlg.modal = true;
                dlg.show();
            }
        };
        C035Component_1.prototype.getDownloadFileType = function (format) {
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
        C035Component_1.prototype.leadingZero = function (value) {
            if (value < 10) {
                return '0' + value.toString();
            }
            return value.toString();
        };
        C035Component_1.prototype.getFileSubmission = function (dlg) {
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
            var fileName = stateCode + reportLevel.toUpperCase() + this.generateFile.reportTypeAbbreviation + version + '.' + format;
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
        C035Component_1.prototype.getAllocationTypeDescription = function (allocationCode) {
            var description = '';
            if (allocationCode === 'RETAINED' || allocationCode === 'RETAINED_1') {
                description = 'Retained by SEA for program administration, etc';
            }
            else if (allocationCode === 'TRANSFER' || allocationCode === 'TRANSFER_1') {
                description = 'Transferred to another state-level agency';
            }
            else if (allocationCode === 'DISTNONLEA' || allocationCode === 'DISTNONLEA_1') {
                description = 'Distributed to entities other than LEAs';
            }
            else if (allocationCode === 'UNALLOC' || allocationCode === 'UNALLOC_1') {
                description = 'Unallocated or returned funds';
            }
            return description;
        };
        return C035Component_1;
    }());
    __setFunctionName(_classThis, "C035Component");
    (function () {
        var _metadata = typeof Symbol === "function" && Symbol.metadata ? Object.create(null) : void 0;
        _reportParameters_decorators = [(0, core_1.Input)()];
        _flextableComponent_decorators = [(0, core_1.ViewChild)(flextable_component_1.FlextableComponent)];
        __esDecorate(null, null, _reportParameters_decorators, { kind: "field", name: "reportParameters", static: false, private: false, access: { has: function (obj) { return "reportParameters" in obj; }, get: function (obj) { return obj.reportParameters; }, set: function (obj, value) { obj.reportParameters = value; } }, metadata: _metadata }, _reportParameters_initializers, _reportParameters_extraInitializers);
        __esDecorate(null, null, _flextableComponent_decorators, { kind: "field", name: "flextableComponent", static: false, private: false, access: { has: function (obj) { return "flextableComponent" in obj; }, get: function (obj) { return obj.flextableComponent; }, set: function (obj, value) { obj.flextableComponent = value; } }, metadata: _metadata }, _flextableComponent_initializers, _flextableComponent_extraInitializers);
        __esDecorate(null, _classDescriptor = { value: _classThis }, _classDecorators, { kind: "class", name: _classThis.name, metadata: _metadata }, null, _classExtraInitializers);
        C035Component = _classThis = _classDescriptor.value;
        if (_metadata) Object.defineProperty(_classThis, Symbol.metadata, { enumerable: true, configurable: true, writable: true, value: _metadata });
        __runInitializers(_classThis, _classExtraInitializers);
    })();
    return C035Component = _classThis;
}();
exports.C035Component = C035Component;
//# sourceMappingURL=c035.component.js.map