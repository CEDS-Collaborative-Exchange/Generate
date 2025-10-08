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
exports.ReportComponent = void 0;
var core_1 = require("@angular/core");
var rxjs_1 = require("rxjs");
var generateReport_service_1 = require("../services/app/generateReport.service");
var dataMigration_service_1 = require("../services/app/dataMigration.service");
var organization_service_1 = require("../services/ods/organization.service");
var gradelevel_service_1 = require("../services/ods/gradelevel.service");
var FSMetadataUpdate_service_1 = require("../services/app/FSMetadataUpdate.service");
var generateReportParametersDto_1 = require("../models/app/generateReportParametersDto");
var flextable_component_1 = require("./components/flextable/flextable.component");
var ReportComponent = function () {
    var _classDecorators = [(0, core_1.Component)({
            selector: 'generate-app-report',
            templateUrl: './report.component.html',
            styleUrls: ['./report.component.scss'],
            providers: [generateReport_service_1.GenerateReportService, dataMigration_service_1.DataMigrationService, organization_service_1.OrganizationService, gradelevel_service_1.GradeLevelService, FSMetadataUpdate_service_1.FSMetadataUpdate]
        })];
    var _classDescriptor;
    var _classExtraInitializers = [];
    var _classThis;
    var _reportType_decorators;
    var _reportType_initializers = [];
    var _reportType_extraInitializers = [];
    var _flextableComponent_decorators;
    var _flextableComponent_initializers = [];
    var _flextableComponent_extraInitializers = [];
    var ReportComponent = _classThis = /** @class */ (function () {
        function ReportComponent_1(_router, _generateReportService, _dataMigrationService, _organizationService, _gradelevelService, activatedRoute, _metadataUpdate) {
            this._router = _router;
            this._generateReportService = _generateReportService;
            this._dataMigrationService = _dataMigrationService;
            this._organizationService = _organizationService;
            this._gradelevelService = _gradelevelService;
            this.activatedRoute = activatedRoute;
            this._metadataUpdate = _metadataUpdate;
            this.subscriptions = [];
            this.reportType = __runInitializers(this, _reportType_initializers, void 0);
            this.flextableComponent = (__runInitializers(this, _reportType_extraInitializers), __runInitializers(this, _flextableComponent_initializers, void 0));
            this.reportParameters = (__runInitializers(this, _flextableComponent_extraInitializers), new generateReportParametersDto_1.GenerateReportParametersDto());
            this.isReportChanged = false;
            this.flag = false;
            this.flag1 = false;
        }
        ReportComponent_1.prototype.ngOnInit = function () {
            var _this = this;
            this.reportParameters.reportType = this.reportType;
            this.subscriptions.push(this.activatedRoute.queryParams.subscribe(function (params) {
                _this.reportParameters.reportCode = params['reportCode'];
                _this.reportParameters.reportLevel = params['reportLevel'];
                _this.reportParameters.reportYear = params['reportYear'];
                _this.reportParameters.reportCategorySetCode = params['reportCategorySetCode'];
                if (_this.reportParameters.reportCode === 'yeartoyearexitcount' && _this.reportParameters.reportCategorySetCode !== 'exitOnly') {
                    _this.reportParameters.reportFilter = 'select';
                }
                else if (_this.reportParameters.reportCode === 'yeartoyearremovalcount' && _this.reportParameters.reportCategorySetCode !== 'removaltype') {
                    _this.reportParameters.reportFilter = 'select';
                }
                else {
                    _this.reportParameters.reportFilter = params['reportFilter'];
                }
                _this.reportParameters.reportSubFilter = params['reportSubFilter'];
                _this.reportParameters.reportLea = params['reportLea'];
                _this.reportParameters.reportSchool = params['reportSchool'];
                _this.reportParameters.reportGrade = params['reportGrade'];
            }));
            if (this.reportType === 'statereport') {
                this.initializeStateReportsPage();
            }
            else {
                this.initializeReportsPage();
            }
        };
        ReportComponent_1.prototype.ngAfterViewInit = function () {
            componentHandler.upgradeAllRegistered();
        };
        ReportComponent_1.prototype.ngOnDestroy = function () {
            // prevent memory leak by unsubscribing
            this.subscriptions.forEach(function (subscription) { return subscription.unsubscribe(); });
        };
        ReportComponent_1.prototype.updateSubmissionYear = function (reportCode) {
            if (reportCode === 'indicator4a' || reportCode === 'indicator4b') {
                if (this.submissionYears.indexOf(this.latestYear) > -1) {
                    this.submissionYears.splice(0, 1);
                }
            }
            else {
                if (this.submissionYears.indexOf(this.latestYear) === -1) {
                    this.submissionYears.unshift(this.latestYear);
                }
            }
        };
        ReportComponent_1.prototype.populateLEAs = function (leas) {
            var _this = this;
            this.leas = [];
            this.leas.push({ organizationId: '-1', name: 'Select LEA', shortName: 'Select' });
            if (this.reportParameters.reportType === 'statereport') {
                this.leas.push({ organizationId: '0', name: 'All LEAs', shortName: 'All', organizationStateIdentifier: 'all' });
            }
            leas.forEach(function (s) { return _this.leas.push({
                organizationId: s.organizationId,
                refOrganizationTypeId: s.refOrganizationTypeId,
                name: s.name + ' (' + s.organizationStateIdentifier + ')',
                parentOrganizationId: s.parentOrganizationId,
                organizationStateIdentifier: s.organizationStateIdentifier,
                shortName: s.shortName
            }); });
        };
        ReportComponent_1.prototype.populateSchools = function (schools) {
            var _this = this;
            this.schools = [];
            this.filteredSchools = [];
            this.filteredSchools.push({ organizationId: '-1', name: 'Select School', shortName: 'Select' });
            if (this.reportParameters.reportType === 'statereport') {
                this.filteredSchools.push({ organizationId: '0', name: 'All Schools', shortName: 'All', organizationStateIdentifier: 'all' });
            }
            schools.forEach(function (s) {
                _this.schools.push(s);
                _this.filteredSchools.push({
                    organizationId: s.organizationId,
                    refOrganizationTypeId: s.refOrganizationTypeId,
                    name: s.name + ' (' + s.organizationStateIdentifier + ')',
                    parentOrganizationId: s.parentOrganizationId,
                    organizationStateIdentifier: s.organizationStateIdentifier,
                    shortName: s.shortName
                });
            });
        };
        ReportComponent_1.prototype.populateFilterOptions = function (reportFilterOptions, grades) {
            // console.log('Filter is :' + reportFilterOptions);
            if (this.reportType === 'statereport' && reportFilterOptions !== undefined && reportFilterOptions.length > 0) {
                this.reportFilterOptions = reportFilterOptions.filter(function (s) { return s.isSubFilter === false; });
                this.reportSubFilterOptions = reportFilterOptions.filter(function (s) { return s.isSubFilter === true; });
            }
            if (this.reportswithGradeFilter.indexOf(this.currentReport.reportCode) > -1 && grades !== undefined && grades.length > 0) {
                this.reportGrades = grades.filter(function (s) {
                    if (s.code === 'HS') {
                        return s.code;
                    }
                    if (!isNaN(parseInt(s.code))) {
                        if (parseInt(s.code) > 2) {
                            return s.code;
                        }
                    }
                });
            }
        };
        ReportComponent_1.prototype.populateFilterOptionsSummary = function (reportFilterOptions, cat) {
            if (reportFilterOptions !== undefined && reportFilterOptions.length > 0 && cat !== 'Educational Environment 3-5' && cat !== 'Educational Environment 6-21') {
                this.reportFilterOptions = reportFilterOptions.filter(function (x) { return x.filterName !== cat; }).filter(function (s) { return s.isSubFilter === false; });
                this.reportSubFilterOptions = reportFilterOptions.filter(function (x) { return x.filterName !== cat; }).filter(function (s) { return s.isSubFilter === true; });
            }
            else if (reportFilterOptions !== undefined && reportFilterOptions.length > 0 && cat === 'Educational Environment 6-21') {
                this.reportFilterOptions = reportFilterOptions.filter(function (x) { return x.filterName !== cat; }).filter(function (x) { return x.filterName !== 'Educational Environment 3-5'; }).filter(function (s) { return s.isSubFilter === false; });
                this.reportSubFilterOptions = reportFilterOptions.filter(function (x) { return x.filterName !== cat; }).filter(function (x) { return x.filterName !== 'Educational Environment 3-5'; }).filter(function (s) { return s.isSubFilter === true; });
            }
            else if (reportFilterOptions !== undefined && reportFilterOptions.length > 0 && cat === 'Educational Environment 3-5') {
                this.reportFilterOptions = reportFilterOptions.filter(function (x) { return x.filterName !== cat; }).filter(function (x) { return x.filterName !== 'Educational Environment 6-21'; }).filter(function (s) { return s.isSubFilter === false; });
                this.reportSubFilterOptions = reportFilterOptions.filter(function (x) { return x.filterName !== cat; }).filter(function (x) { return x.filterName !== 'Educational Environment 6-21'; }).filter(function (s) { return s.isSubFilter === true; });
            }
        };
        ReportComponent_1.prototype.filterSchools = function (lea) {
            var _this = this;
            this.filteredSchools = [];
            if (lea.organizationId !== '0') {
                this.filteredSchools.push({ organizationId: '-1', name: 'Select School', shortName: 'Select' });
                if (this.reportParameters.reportType === 'statereport') {
                    this.filteredSchools.push({ organizationId: '0', name: 'All Schools', shortName: 'All', organizationStateIdentifier: 'all' });
                }
                if (this.schools !== undefined) {
                    this.schools.filter(function (s) { return (s.parentOrganizationId === lea.organizationId); })
                        .forEach(function (t) {
                        _this.filteredSchools.push({
                            organizationId: t.organizationId,
                            refOrganizationTypeId: t.refOrganizationTypeId,
                            name: t.name + ' (' + t.organizationStateIdentifier + ')',
                            parentOrganizationId: t.parentOrganizationId,
                            organizationStateIdentifier: t.organizationStateIdentifier,
                            shortName: t.shortName
                        });
                    });
                }
            }
            else if (lea.organizationId === '0') {
                this.filteredSchools.push({ organizationId: '-1', name: 'Select School', shortName: 'Select' });
                if (this.reportParameters.reportType === 'statereport') {
                    this.filteredSchools.push({ organizationId: '0', name: 'All Schools', shortName: 'All', organizationStateIdentifier: 'all' });
                }
                this.schools.forEach(function (s) {
                    _this.filteredSchools.push({
                        organizationId: s.organizationId,
                        refOrganizationTypeId: s.refOrganizationTypeId,
                        name: s.name + ' (' + s.organizationStateIdentifier + ')',
                        parentOrganizationId: s.parentOrganizationId,
                        organizationStateIdentifier: s.organizationStateIdentifier,
                        shortName: s.shortName
                    });
                });
            }
        };
        ReportComponent_1.prototype.initializeReportsPage = function () {
            var _this = this;
            if (this.reportType !== undefined) {
                (0, rxjs_1.forkJoin)(this._generateReportService.getReports(this.reportType), this._dataMigrationService.currentMigrationStatus(), this._metadataUpdate.getMetadataStatus()).subscribe(function (data) {
                    _this.generateReports = data[0];
                    _this.currentMigrationStatus = data[1];
                    _this.metadataStatus = data[2];
                    var status = '';
                    if (_this.metadataStatus !== undefined && _this.metadataStatus.length > 0) {
                        _this.metadataStatusMessage = _this.metadataStatus.filter(function (t) { return t.generateConfigurationKey === 'MetaLastRunLog'; })[0].generateConfigurationValue;
                        status = _this.metadataStatus.filter(function (t) { return t.generateConfigurationKey === 'metaStatus'; })[0].generateConfigurationValue;
                        _this.metadataCss(status);
                    }
                    if (status.toUpperCase() === 'PROCESSING') {
                        _this.errorMessage = 'Metadata is currently being processed. Allow the metadata process to finish before viewing reports.';
                    }
                    else if (status.toUpperCase() === 'FAILED') {
                        _this.errorMessage = 'Metadata process failed. Please successfully migrate the metadata before viewing reports.';
                    }
                    else if (_this.currentMigrationStatus.reportMigrationStatusCode === 'processing') {
                        _this.errorMessage = 'A migration is in progress. Allow the current migration to finish before viewing reports.';
                    }
                    else if (_this.currentMigrationStatus.reportMigrationStatusCode !== 'success') {
                        _this.errorMessage = 'The migration must be run prior to viewing reports.';
                    }
                    else {
                        var newParameters = _this.getNewReportParameters();
                        if (newParameters.reportPageSize === undefined) {
                            newParameters.reportPageSize = 25;
                        }
                        if (newParameters.reportPage === undefined) {
                            newParameters.reportPage = 1;
                        }
                        if (newParameters.reportLea === undefined) {
                            newParameters.reportLea = 'select';
                        }
                        if (newParameters.reportSchool === undefined) {
                            newParameters.reportSchool = 'select';
                        }
                        if (newParameters.reportYear === undefined) {
                            newParameters.reportYear = (new Date()).getFullYear().toString();
                        }
                        if (newParameters.reportTableTypeAbbrv === undefined) {
                            newParameters.reportTypeAbbreviation = _this.tableTypes[0].tableTypeAbbrv;
                        }
                        _this.reportswithGradeFilter = '';
                        _this.errorMessage = null;
                    }
                });
            }
        };
        ReportComponent_1.prototype.initializeStateReportsPage = function () {
            var _this = this;
            if (this.reportType !== undefined) {
                this.subscriptions.push(this._dataMigrationService.currentMigrationStatus()
                    .subscribe(function (data) {
                    _this.currentMigrationStatus = data;
                    if (_this.currentMigrationStatus.reportMigrationStatusCode === 'processing') {
                        _this.errorMessage = 'A migration is in progress. Allow the current migration to finish before viewing reports.';
                    }
                    else if (_this.currentMigrationStatus.reportMigrationStatusCode !== 'success') {
                        _this.errorMessage = 'The migration must be run prior to viewing reports.';
                    }
                    else {
                        var newParameters = _this.getNewReportParameters();
                        if (newParameters.reportPageSize === undefined) {
                            newParameters.reportPageSize = 25;
                        }
                        if (newParameters.reportPage === undefined) {
                            newParameters.reportPage = 1;
                        }
                        if (newParameters.reportLea === undefined) {
                            newParameters.reportLea = 'select';
                        }
                        if (newParameters.reportSchool === undefined) {
                            newParameters.reportSchool = 'select';
                        }
                        _this.reportswithGradeFilter = 'stateassessmentsperformance,yeartoyearprogress,yeartoyearattendance';
                        _this.errorMessage = null;
                        _this.getStateReport(_this.reportParameters);
                    }
                }));
            }
        };
        ReportComponent_1.prototype.getReportYears = function (newParameters) {
            var _this = this;
            this._generateReportService.getSubmissionYearss(newParameters.reportCode, this.reportType)
                .subscribe(function (years) {
                _this.submissionYears = years;
            });
        };
        ReportComponent_1.prototype.getReport = function (newParameters) {
            var _this = this;
            (0, rxjs_1.forkJoin)(this._generateReportService.getReportByCodeAndYear(this.reportType, newParameters.reportCode, newParameters.reportYear)).subscribe(function (data) {
                _this.currentReport = data[0];
                if (!_this.isNullOrUndefined(_this.currentReport)) {
                    if (_this.currentReport.organizationLevels.filter(function (t) { return t.levelCode === newParameters.reportLevel; }).length < 1) {
                        for (var i = 0; i < _this.currentReport.organizationLevels.length; i++) {
                            var level = _this.currentReport.organizationLevels[i];
                            /*console.log('Level report is : ' + level.levelCode);*/
                            if (level.levelCode === 'sea') {
                                newParameters.reportLevel = 'sea';
                                break;
                            }
                            else if (level.levelCode === 'lea') {
                                newParameters.reportLevel = 'lea';
                                break;
                            }
                            else if (level.levelCode === 'sch') {
                                newParameters.reportLevel = 'sch';
                                break;
                            }
                            else if (level.levelCode === 'CAO') {
                                newParameters.reportLevel = 'CAO';
                                break;
                            }
                            else if (level.levelCode === 'CMO') {
                                newParameters.reportLevel = 'CMO';
                                break;
                            }
                        }
                    }
                    /*this.reportParameters.reportLevel = newParameters.reportLevel;*/
                }
                _this.categorySets = _this.getCategorySets(_this.currentReport.categorySets, newParameters);
                _this.tableTypes = _this.categorySets[0].tableTypes;
                /*console.log(this.tableTypes);*/
                if (_this.categorySets !== undefined && _this.categorySets.length > 0) {
                    newParameters.reportCategorySet = _this.categorySets.filter(function (t) { return t.organizationLevelCode === newParameters.reportLevel && t.submissionYear === newParameters.reportYear; })[0];
                    newParameters.reportCategorySetCode = newParameters.reportCategorySet.categorySetCode;
                }
                if (_this.tableTypes !== undefined && _this.tableTypes.length > 0) {
                    newParameters.reportTableTypeAbbrv = _this.tableTypes[0].tableTypeAbbrv;
                }
                newParameters.connectionLink = _this.currentReport.connectionLink;
                _this.getOrganizationLevelByCode(newParameters);
                if (newParameters.reportCode === '029') {
                    _this._organizationService.getLEAs(newParameters.reportYear)
                        .subscribe(function (data) {
                        _this.populateLEAs(data);
                    }, function (error) { return _this.errorMessage = error; });
                    _this._organizationService.getSchools(newParameters.reportYear)
                        .subscribe(function (data) {
                        _this.populateSchools(data);
                    }, function (error) { return _this.errorMessage = error; });
                    var lea = null;
                    if (newParameters.reportLea !== undefined) {
                        if (_this.reportParameters.reportLea === 'all') {
                            lea = { organizationId: '0', name: 'All Schools', shortName: 'All', organizationStateIdentifier: 'all' };
                        }
                        else if (_this.reportParameters.reportLea === 'select') {
                            lea = { organizationId: '-1', name: 'Select School', shortName: 'Select' };
                        }
                        else {
                            var idx = _this.leas.map(function (s) { return s.name; }).indexOf(_this.reportParameters.reportLea);
                            if (idx > -1) {
                                lea = _this.leas[idx];
                            }
                        }
                        if (lea !== null) {
                            _this.filterSchools(lea);
                        }
                    }
                    else if (_this.reportParameters.reportLevel === 'sch') {
                        lea = { organizationId: '-1', name: 'Select School', shortName: 'Select' };
                        _this.filterSchools(lea);
                    }
                }
                _this.reportParameters = newParameters;
            });
        };
        ReportComponent_1.prototype.getStateReport = function (newParameters) {
            var _this = this;
            (0, rxjs_1.forkJoin)(this._generateReportService.getReportByCodes(this.reportType, newParameters.reportCode), this._gradelevelService.getGradeLevelsOffered(), this._organizationService.getLEAs(newParameters.reportYear), this._organizationService.getSchools(newParameters.reportYear)).subscribe(function (data) {
                _this.currentReport = data[0];
                if (newParameters.reportLevel === undefined) {
                    for (var i = 0; i < _this.currentReport.organizationLevels.length; i++) {
                        var level = _this.currentReport.organizationLevels[i];
                        if (level.levelCode === 'sea') {
                            newParameters.reportLevel = 'sea';
                            break;
                        }
                        else if (level.levelCode === 'lea') {
                            newParameters.reportLevel = 'lea';
                            break;
                        }
                        else if (level.levelCode === 'sch') {
                            newParameters.reportLevel = 'sch';
                            break;
                        }
                        else if (level.levelCode === 'CAO') {
                            newParameters.reportLevel = 'CAO';
                            break;
                        }
                        else if (level.levelCode === 'CMO') {
                            newParameters.reportLevel = 'CMO';
                            break;
                        }
                    }
                }
                _this.categorySets = _this.getCategorySets(_this.currentReport.categorySets, newParameters);
                if (_this.categorySets !== undefined && _this.categorySets.length > 0) {
                    newParameters.reportCategorySet = _this.categorySets.filter(function (t) { return t.organizationLevelCode === newParameters.reportLevel && t.submissionYear === newParameters.reportYear; })[0];
                    newParameters.reportCategorySetCode = newParameters.reportCategorySet.categorySetCode;
                }
                newParameters.connectionLink = _this.currentReport.connectionLink;
                _this.getOrganizationLevelByCode(newParameters);
                _this.reportFilters = _this.currentReport.reportFilters;
                _this.populateFilterOptions(_this.currentReport.reportFilterOptions, data[1]);
                if (newParameters.reportFilter === undefined && _this.reportFilterOptions !== undefined) {
                    newParameters.reportFilter = _this.reportFilterOptions[0].filterCode;
                }
                if (newParameters.reportSubFilter === undefined && _this.reportSubFilterOptions !== undefined && _this.reportSubFilterOptions.length > 0) {
                    newParameters.reportSubFilter = _this.reportSubFilterOptions[0].filterCode;
                }
                if (_this.reportswithGradeFilter.indexOf(_this.currentReport.reportCode) > -1 && newParameters.reportGrade === undefined && _this.reportGrades !== undefined && _this.reportGrades.length > 0) {
                    newParameters.reportGrade = _this.reportGrades[0].code;
                }
                _this.populateLEAs(data[2]);
                _this.populateSchools(data[3]);
                var lea = null;
                if (newParameters.reportLea !== undefined) {
                    if (_this.reportParameters.reportLea === 'all') {
                        lea = { organizationId: '0', name: 'All LEAs', shortName: 'All', organizationStateIdentifier: 'all' };
                    }
                    else if (_this.reportParameters.reportLea === 'select') {
                        lea = { organizationId: '-1', name: 'Select LEA', shortName: 'Select' };
                    }
                    else {
                        var idx = _this.leas.map(function (s) { return s.organizationStateIdentifier; }).indexOf(_this.reportParameters.reportLea);
                        if (idx > -1) {
                            lea = _this.leas[idx];
                        }
                    }
                    if (lea !== null) {
                        _this.filterSchools(lea);
                    }
                }
                else if (_this.reportParameters.reportLevel === 'sch') {
                    lea = { organizationId: '-1', name: 'Select School', shortName: 'Select', organizationStateIdentifier: 'all' };
                    if (lea !== null) {
                        _this.filterSchools(lea);
                    }
                }
                if (newParameters.reportCode === 'studentssummary') {
                    if (!_this.flag1) {
                        newParameters.reportFilter = 'select';
                        _this.populateFilterOptionsSummary(_this.currentReport.reportFilterOptions, newParameters.reportCategorySet.categorySetName);
                    }
                    else {
                        _this.flag1 = false;
                    }
                }
                //else if (newParameters.reportCode === 'studentssummary') {
                //    this.populateFilterOptionsSummary(this.currentReport.reportFilterOptions, newParameters.reportCategorySet.categorySetName);
                //}
                _this.setQueryString(newParameters);
                _this.reportParameters = newParameters;
            });
        };
        ReportComponent_1.prototype.getSelectedEntity = function (reportLevel) {
            var idx = -1;
            if (reportLevel === 'lea') {
                if (this.reportParameters.reportLea !== undefined) {
                    idx = this.leas.map(function (s) { return s.organizationStateIdentifier; }).indexOf(this.reportParameters.reportLea);
                }
            }
            else {
                if (this.reportParameters.reportSchool !== undefined) {
                    idx = this.filteredSchools.map(function (s) { return s.organizationStateIdentifier; }).indexOf(this.reportParameters.reportSchool);
                }
            }
            return idx;
        };
        ReportComponent_1.prototype.getCategorySets = function (categorySets, newParameters) {
            var returnSet = new Array();
            if (categorySets !== undefined && categorySets.length > 0) {
                for (var i = 0; i < categorySets.length; i++) {
                    var categorySet = categorySets[i];
                    if (categorySet.organizationLevelCode === newParameters.reportLevel && categorySet.submissionYear === newParameters.reportYear) {
                        if (categorySet.includeOnFilter !== null) {
                            if (newParameters.reportFilter === categorySet.includeOnFilter) {
                                returnSet.push(categorySet);
                            }
                        }
                        else if (categorySet.excludeOnFilter !== null) {
                            if (newParameters.reportFilter !== categorySet.excludeOnFilter) {
                                returnSet.push(categorySet);
                            }
                        }
                        else {
                            returnSet.push(categorySet);
                        }
                    }
                }
            }
            function compare(a, b) {
                if (a.categorySetName < b.categorySetName)
                    return -1;
                if (a.categorySetName > b.categorySetName)
                    return 1;
                return 0;
            }
            returnSet.sort(compare);
            return returnSet;
        };
        ReportComponent_1.prototype.getNewReportParameters = function () {
            var newParameters = new generateReportParametersDto_1.GenerateReportParametersDto();
            newParameters.reportType = this.reportParameters.reportType;
            newParameters.reportCode = this.reportParameters.reportCode;
            newParameters.reportLevel = this.reportParameters.reportLevel;
            newParameters.reportYear = this.reportParameters.reportYear;
            newParameters.reportCategorySet = this.reportParameters.reportCategorySet;
            newParameters.reportCategorySetCode = this.reportParameters.reportCategorySetCode;
            newParameters.reportSort = this.reportParameters.reportSort;
            newParameters.reportPage = this.reportParameters.reportPage;
            newParameters.reportPageSize = this.reportParameters.reportPageSize;
            newParameters.reportFilter = this.reportParameters.reportFilter;
            newParameters.reportFilterValue = this.reportParameters.reportFilterValue;
            newParameters.reportSubFilter = this.reportParameters.reportSubFilter;
            newParameters.reportGrade = this.reportParameters.reportGrade;
            newParameters.reportLea = this.reportParameters.reportLea;
            newParameters.reportSchool = this.reportParameters.reportSchool;
            newParameters.connectionLink = this.reportParameters.connectionLink;
            newParameters.organizationalIdList = this.reportParameters.organizationalIdList;
            newParameters.reportTableTypeAbbrv = this.reportParameters.reportTableTypeAbbrv;
            return newParameters;
        };
        ReportComponent_1.prototype.getOrganizationLevelByCode = function (newParameters) {
            var _this = this;
            this._generateReportService.getReportLevelsByCode(this.reportType, newParameters.reportCode, newParameters.reportYear, newParameters.reportCategorySetCode)
                .subscribe(function (data) {
                _this.organizationLevels = data;
            }, function (error) { return _this.errorMessage = error; });
        };
        ReportComponent_1.prototype.setReportLevel = function (event, reportLevel) {
            if (this.reportParameters.reportLevel !== reportLevel) {
                var newParameters = this.getNewReportParameters();
                newParameters.reportLevel = reportLevel;
                newParameters.reportPage = 1;
                newParameters.reportSort = 1;
                if (this.reportType === 'statereport') {
                    this.setQueryString(newParameters);
                }
                this.reportParameters = newParameters;
            }
            return false;
        };
        ReportComponent_1.prototype.setReportCategorySet = function (event, comboCategorySet) {
            var reportCategorySet;
            var newParameters = this.getNewReportParameters();
            if (newParameters.reportCode === 'studentssummary') {
                this.flag1 = false;
            }
            if (!comboCategorySet._focus) {
                comboCategorySet.selectedItem = newParameters.reportCategorySet;
            }
            else {
                if (comboCategorySet.selectedItem !== undefined) {
                    reportCategorySet = comboCategorySet.selectedItem;
                    if (newParameters.reportCategorySet.categorySetCode !== reportCategorySet.categorySetCode) {
                        newParameters.reportCategorySet = reportCategorySet;
                        newParameters.reportCategorySetCode = reportCategorySet.categorySetCode;
                        if (this.reportType === 'statereport') {
                            this.setQueryString(newParameters);
                        }
                        this.reportParameters = newParameters;
                    }
                }
            }
            return false;
        };
        ReportComponent_1.prototype.reportChanged = function ($event) {
            this.isReportChanged = true;
        };
        ReportComponent_1.prototype.reportChangedd = function ($event) {
            this.flag = true;
        };
        ReportComponent_1.prototype.setReportCode = function (event, comboReportCode, comboYear) {
            var _this = this;
            if (this.reportSearchTimer) {
                window.clearTimeout(this.reportSearchTimer);
                this.reportSearchTimer = null;
            }
            this.reportSearchTimer = setTimeout(function () {
                var reportCode;
                if (comboReportCode.selectedItem !== undefined && _this.isReportChanged) {
                    reportCode = comboReportCode.selectedItem.reportCode;
                    if (_this.reportParameters.reportCode !== reportCode) {
                        var newParameters = _this.getNewReportParameters();
                        newParameters.reportCode = reportCode;
                        newParameters.reportPage = 1;
                        newParameters.reportSort = 1;
                        newParameters.reportCategorySetCode = 'CSA';
                        newParameters.reportTableTypeAbbrv = undefined;
                        if (_this.submissionYears !== undefined && _this.submissionYears.length > 0) {
                            _this.getReport(newParameters);
                        }
                        else {
                            _this.getReportYears(newParameters);
                            _this.reportParameters = newParameters;
                        }
                    }
                }
                //else if (comboReportCode.selectedItem !== undefined && this.currentReport !== undefined) {
                //    comboReportCode.selectedItem = this.currentReport;
                //}
                return false;
            }, 1000);
        };
        ReportComponent_1.prototype.setReportYear = function (event, comboYear) {
            var _this = this;
            var newParameters = this.getNewReportParameters();
            if (!comboYear._focus) {
                comboYear.selectedItem = newParameters.reportYear;
            }
            else {
                if (comboYear.selectedItem !== undefined) {
                    if (newParameters.reportYear !== comboYear.selectedItem) {
                        newParameters.reportYear = comboYear.selectedItem;
                        newParameters.reportPage = 1;
                        this.getReport(newParameters);
                        if (this.categorySets !== undefined && this.categorySets.length > 0) {
                            this.categorySets.splice(0, this.categorySets.length);
                        }
                        if (!this.isNullOrUndefined(this.currentReport)) {
                            this.categorySets = this.getCategorySets(this.currentReport.categorySets, newParameters);
                        }
                        if (this.categorySets !== undefined && this.categorySets.length > 0) {
                            newParameters.reportCategorySet = this.categorySets.filter(function (t) { return t.organizationLevelCode === newParameters.reportLevel
                                && t.submissionYear === newParameters.reportYear; })[0];
                            newParameters.reportCategorySetCode = newParameters.reportCategorySet.categorySetCode;
                        }
                        if (this.reportType === 'statereport') {
                            this.setQueryString(newParameters);
                        }
                        this.reportParameters = newParameters;
                    }
                }
            }
            this._organizationService.getLEAs(newParameters.reportYear)
                .subscribe(function (data) {
                _this.populateLEAs(data);
            }, function (error) { return _this.errorMessage = error; });
            this._organizationService.getSchools(newParameters.reportYear)
                .subscribe(function (data) {
                _this.populateSchools(data);
            }, function (error) { return _this.errorMessage = error; });
            return false;
        };
        ReportComponent_1.prototype.setTableType = function (event, comboTableType) {
            var reportTableType;
            var newParameters = this.getNewReportParameters();
            if (comboTableType.selectedItem !== undefined) {
                reportTableType = comboTableType.selectedItem;
                if (newParameters.reportTableTypeAbbrv !== reportTableType.tableTypeAbbrv) {
                    newParameters.reportTableTypeAbbrv = reportTableType.tableTypeAbbrv;
                    newParameters.reportPage = 1;
                    this.reportParameters = newParameters;
                }
            }
        };
        ReportComponent_1.prototype.setReportFilter = function (event, reportFilter, reportFilterValue) {
            var newParameters = this.getNewReportParameters();
            if (newParameters.reportCode === 'studentssummary') {
                this.flag1 = false;
            }
            newParameters.reportFilter = reportFilter;
            newParameters.reportFilterValue = reportFilterValue;
            newParameters.reportPage = 1;
            newParameters.reportSort = 1;
            var organizationIds;
            organizationIds = '';
            for (var i = 0; i < this.leas.length; i++) {
                organizationIds += this.leas[i].organizationId.toString();
                if (i !== this.leas.length - 1) {
                    organizationIds += ',';
                }
            }
            newParameters.organizationalIdList = organizationIds;
            if (this.reportType === 'statereport') {
                this.setQueryString(newParameters);
            }
            this.reportParameters = newParameters;
            return false;
        };
        ReportComponent_1.prototype.setReportFilterOption = function (event, comboReportFilter) {
            var newParameters = this.getNewReportParameters();
            if (comboReportFilter._focus) {
                if (comboReportFilter.selectedItem !== undefined) {
                    var reportFilterOption = comboReportFilter.selectedItem;
                    newParameters.reportFilter = reportFilterOption.filterCode;
                    newParameters.reportPage = 1;
                    newParameters.reportSort = 1;
                    if (this.reportType === 'statereport') {
                        this.setQueryString(newParameters);
                    }
                    this.reportParameters = newParameters;
                }
            }
            return false;
        };
        ReportComponent_1.prototype.setReportSubFilterOption = function (event, comboReportSubFilter) {
            var newParameters = this.getNewReportParameters();
            if (comboReportSubFilter._focus) {
                if (comboReportSubFilter.selectedItem !== undefined) {
                    var reportFilterOption = comboReportSubFilter.selectedItem;
                    newParameters.reportSubFilter = reportFilterOption.filterCode;
                    newParameters.reportPage = 1;
                    newParameters.reportSort = 1;
                    if (this.reportType === 'statereport') {
                        this.setQueryString(newParameters);
                    }
                    this.reportParameters = newParameters;
                }
            }
            return false;
        };
        ReportComponent_1.prototype.setReportGradeOption = function (event, comboReportGradeFilter) {
            var newParameters = this.getNewReportParameters();
            if (comboReportGradeFilter._focus) {
                if (comboReportGradeFilter.selectedItem !== undefined) {
                    var reportFilterGrade = comboReportGradeFilter.selectedItem;
                    newParameters.reportGrade = reportFilterGrade.code;
                    newParameters.reportPage = 1;
                    newParameters.reportSort = 1;
                    if (this.reportType === 'statereport') {
                        this.setQueryString(newParameters);
                    }
                    this.reportParameters = newParameters;
                }
            }
            return false;
        };
        ReportComponent_1.prototype.setReportLea = function (event, comboReportLea) {
            /*console.log('MySetLea');*/
            var newParameters = this.getNewReportParameters();
            if (newParameters.reportCode === 'studentssummary') {
                this.flag1 = true;
            }
            //console.log('Is school display : ' + this.isDisplaySchool() + ' ' + this.schools + ' ' + comboReportLea.selectedItem);
            if (comboReportLea._focus) {
                if (comboReportLea.selectedItem !== null) {
                    var selectedLea = comboReportLea.selectedItem;
                    if (selectedLea !== null && selectedLea.organizationId !== '0' && selectedLea.organizationId !== '-1') {
                        newParameters.reportLea = selectedLea.organizationStateIdentifier;
                    }
                    else if (selectedLea !== null && selectedLea.organizationId === '0') {
                        newParameters.reportLea = 'all';
                        selectedLea = { organizationId: '0', name: 'All LEAs', shortName: 'All', organizationStateIdentifier: 'all' };
                    }
                    else {
                        newParameters.reportLea = 'select';
                        selectedLea = { organizationId: '-1', name: 'Select LEA', shortName: 'Select' };
                    }
                    newParameters.reportPage = 1;
                    if (this.isDisplaySchool()) {
                        newParameters.reportSchool = 'select';
                        if (this.schools !== undefined) {
                            this.filterSchools(selectedLea);
                        }
                    }
                    this.reportParameters = newParameters;
                    if (this.reportType === 'statereport') {
                        this.setQueryString(newParameters);
                    }
                }
            }
            return false;
        };
        ReportComponent_1.prototype.setReportSchool = function ($event, comboReportSchool) {
            var newParameters = this.getNewReportParameters();
            if (comboReportSchool._focus) {
                if (comboReportSchool.selectedItem !== null) {
                    var selectedSchool = comboReportSchool.selectedItem;
                    if (selectedSchool !== null && selectedSchool.organizationId !== '0' && selectedSchool.organizationId !== '-1') {
                        newParameters.reportSchool = selectedSchool.organizationStateIdentifier;
                    }
                    else if (selectedSchool !== null && selectedSchool.organizationId === '0') {
                        newParameters.reportSchool = 'all';
                        selectedSchool = { organizationId: '0', name: 'All Schools', shortName: 'All', organizationStateIdentifier: 'all' };
                    }
                    else {
                        newParameters.reportSchool = 'select';
                        selectedSchool = { organizationId: '-1', name: 'Select School', shortName: 'Select' };
                    }
                    newParameters.reportPage = 1;
                    this.reportParameters = newParameters;
                    if (this.reportType === 'statereport') {
                        this.setQueryString(newParameters);
                    }
                }
            }
            return false;
        };
        ReportComponent_1.prototype.getCMOLevelLabel = function (reportCode) {
            var CMOlbl = 'CMOs';
            if (this.currentReport !== undefined) {
                if (this.reportParameters.reportCode === reportCode) {
                    CMOlbl = 'Management Organization Type';
                }
            }
            return CMOlbl;
        };
        ReportComponent_1.prototype.CMOLevelLabelCss = function (reportCode) {
            if (this.reportParameters.reportCode === reportCode) {
                return 'generate-app-report-controls__reportlevel-button-mgmt';
            }
            else {
                return '';
            }
        };
        ReportComponent_1.prototype.activeReportCodeCss = function (reportCode) {
            if (this.reportParameters.reportCode === reportCode) {
                return 'mdl-button--raised mdl-button--accent';
            }
            else {
                return '';
            }
        };
        ReportComponent_1.prototype.activeReportLevelCss = function (reportLevel) {
            if (this.reportParameters.reportLevel === reportLevel) {
                return 'mdl-button--accent';
            }
            else {
                return '';
            }
        };
        ReportComponent_1.prototype.parameterColumnSpanCss = function () {
            if (this.currentReport !== undefined) {
                if (this.reportType === 'edfactsreport' || this.reportType === 'sppaprreport' || this.reportType === 'statereport' || this.currentReport.showCategorySetControl) {
                    return 'mdl-cell--3-col';
                }
                else {
                    return 'mdl-cell--4-col';
                }
            }
            else {
                if (this.reportType === 'edfactsreport' || this.reportType === 'sppaprreport' || this.reportType === 'statereport') {
                    return 'mdl-cell--3-col';
                }
                else {
                    return 'mdl-cell--4-col';
                }
            }
        };
        ReportComponent_1.prototype.reportWidth = function () {
            if (this.reportType === 'edfactsreport' || this.reportType === 'sppaprreport') {
                return 'generate-app-report-controls__submission';
            }
            else {
                return 'generate-app-report-controls__datapopulation';
            }
        };
        ReportComponent_1.prototype.showReportLevelButton = function (reportLevel) {
            var show = false;
            if (this.currentReport !== undefined) {
                if (this.organizationLevels !== undefined) {
                    for (var i = 0; i < this.organizationLevels.length; i++) {
                        var level = this.organizationLevels[i];
                        if (level.levelCode === reportLevel) {
                            show = true;
                        }
                    }
                }
            }
            return show;
        };
        ReportComponent_1.prototype.showReportData = function () {
            var show = false;
            if ((this.reportType === 'statereport') && this.reportParameters.reportLevel === 'lea') {
                if (this.reportParameters.reportLea !== undefined && this.reportParameters.reportLea !== 'select') {
                    show = true;
                }
                else {
                    show = false;
                }
            }
            else if ((this.reportType === 'statereport') && this.reportParameters.reportLevel === 'sch') {
                if (this.reportParameters.reportSchool !== undefined && this.reportParameters.reportSchool !== 'select') {
                    show = true;
                }
                else {
                    show = false;
                }
            }
            else {
                show = true;
            }
            return show;
        };
        ReportComponent_1.prototype.setQueryString = function (newParameters) {
            var navigationExtras = {};
            var gradeExtras = {};
            var organizationIds;
            organizationIds = '';
            if (this.leas !== undefined) {
                for (var i = 0; i < this.leas.length; i++) {
                    organizationIds += this.leas[i].organizationId.toString();
                    if (i !== this.leas.length - 1) {
                        organizationIds += ',';
                    }
                }
                this.reportParameters.organizationalIdList = organizationIds;
                newParameters.organizationalIdList = organizationIds;
            }
            if (newParameters.reportLevel === 'sea') {
                navigationExtras = {
                    queryParams: {
                        'reportCode': newParameters.reportCode,
                        'reportLevel': newParameters.reportLevel,
                        'reportYear': newParameters.reportYear,
                        'reportCategorySetCode': newParameters.reportCategorySetCode,
                        'reportFilter': newParameters.reportFilter,
                        'reportSubFilter': newParameters.reportSubFilter
                    }
                };
                gradeExtras = {
                    queryParams: {
                        'reportCode': newParameters.reportCode,
                        'reportLevel': newParameters.reportLevel,
                        'reportYear': newParameters.reportYear,
                        'reportCategorySetCode': newParameters.reportCategorySetCode,
                        'reportFilter': newParameters.reportFilter,
                        'reportSubFilter': newParameters.reportSubFilter,
                        'reportGrade': newParameters.reportGrade
                    }
                };
            }
            else if (newParameters.reportLevel === 'lea') {
                navigationExtras = {
                    queryParams: {
                        'reportCode': newParameters.reportCode,
                        'reportLevel': newParameters.reportLevel,
                        'reportYear': newParameters.reportYear,
                        'reportCategorySetCode': newParameters.reportCategorySetCode,
                        'reportFilter': newParameters.reportFilter,
                        'reportSubFilter': newParameters.reportSubFilter,
                        'reportLea': newParameters.reportLea,
                        'organizationalIdList': newParameters.organizationalIdList
                    }
                };
                gradeExtras = {
                    queryParams: {
                        'reportCode': newParameters.reportCode,
                        'reportLevel': newParameters.reportLevel,
                        'reportYear': newParameters.reportYear,
                        'reportCategorySetCode': newParameters.reportCategorySetCode,
                        'reportFilter': newParameters.reportFilter,
                        'reportSubFilter': newParameters.reportSubFilter,
                        'reportLea': newParameters.reportLea,
                        'reportGrade': newParameters.reportGrade,
                        'organizationalIdList': newParameters.organizationalIdList
                    }
                };
            }
            else if (newParameters.reportLevel === 'sch') {
                navigationExtras = {
                    queryParams: {
                        'reportCode': newParameters.reportCode,
                        'reportLevel': newParameters.reportLevel,
                        'reportYear': newParameters.reportYear,
                        'reportCategorySetCode': newParameters.reportCategorySetCode,
                        'reportFilter': newParameters.reportFilter,
                        'reportSubFilter': newParameters.reportSubFilter,
                        'reportLea': newParameters.reportLea,
                        'reportSchool': newParameters.reportSchool
                    }
                };
                gradeExtras = {
                    queryParams: {
                        'reportCode': newParameters.reportCode,
                        'reportLevel': newParameters.reportLevel,
                        'reportYear': newParameters.reportYear,
                        'reportCategorySetCode': newParameters.reportCategorySetCode,
                        'reportFilter': newParameters.reportFilter,
                        'reportSubFilter': newParameters.reportSubFilter,
                        'reportLea': newParameters.reportLea,
                        'reportGrade': newParameters.reportGrade,
                        'reportSchool': newParameters.reportSchool,
                        'organizationalIdList': newParameters.organizationalIdList
                    }
                };
            }
            else if (newParameters.reportLevel === 'CAO') {
                navigationExtras = {
                    queryParams: {
                        'reportCode': newParameters.reportCode,
                        'reportLevel': newParameters.reportLevel,
                        'reportYear': '2016-17',
                        'reportCategorySetCode': newParameters.reportCategorySetCode,
                        'reportFilter': newParameters.reportFilter,
                        'reportSubFilter': newParameters.reportSubFilter,
                        'reportLea': newParameters.reportLea,
                        'reportSchool': newParameters.reportSchool
                    }
                };
            }
            else if (newParameters.reportLevel === 'CMO') {
                navigationExtras = {
                    queryParams: {
                        'reportCode': newParameters.reportCode,
                        'reportLevel': newParameters.reportLevel,
                        'reportYear': newParameters.reportYear,
                        'reportCategorySetCode': newParameters.reportCategorySetCode,
                        'reportFilter': newParameters.reportFilter,
                        'reportSubFilter': newParameters.reportSubFilter,
                        'reportLea': newParameters.reportLea,
                        'reportSchool': newParameters.reportSchool
                    }
                };
            }
            if (this.reportswithGradeFilter.indexOf(this.currentReport.reportCode) > -1) {
                this._router.navigate(['/reports/library/report'], gradeExtras);
            }
            else {
                this._router.navigate(['/reports/library/report'], navigationExtras);
            }
        };
        ReportComponent_1.prototype.gotoReportsLibrary = function () {
            this._router.navigateByUrl('/reports/library');
            return false;
        };
        ReportComponent_1.prototype.isDisplayLEA = function () {
            var isDisplayed = false;
            if ((this.reportType === 'statereport') && this.reportParameters.reportLevel !== 'sea') {
                isDisplayed = true;
            }
            return isDisplayed;
        };
        ReportComponent_1.prototype.isDisplaySchool = function () {
            var isDisplayed = false;
            if ((this.reportType === 'statereport') && this.reportParameters.reportLevel === 'sch') {
                isDisplayed = true;
            }
            return isDisplayed;
        };
        //Remove Category Set from the School Level report title. Per file spec: "For the school level file, there are no required categories and totals.
        ReportComponent_1.prototype.showCategorySet = function () {
            var isDisplayed = true;
            if ((this.reportParameters.reportCode === '059') && this.reportParameters.reportLevel == 'sch') {
                isDisplayed = false;
            }
            if (this.reportParameters.reportCode === '190' || this.reportParameters.reportCode === '196' || this.reportParameters.reportCode === '197' || this.reportParameters.reportCode === '198') {
                isDisplayed = false;
            }
            return isDisplayed;
        };
        ReportComponent_1.prototype.showTableType = function () {
            var isDisplayed = false;
            var assessmentCodes = ['175', '178', '179', '185', '188', '189'];
            if (assessmentCodes.includes(this.reportParameters.reportCode)) {
                isDisplayed = true;
            }
            return isDisplayed;
        };
        ReportComponent_1.prototype.metadataCss = function (status) {
            if (status === "FAILED") {
                this.metadataStatusCss = 'generate-app-report-metadata__error';
            }
            else {
                this.metadataStatusCss = 'generate-app-report-controls__sectiontitle';
            }
        };
        ReportComponent_1.prototype.isNullOrUndefined = function (value) {
            return value === null || value === undefined;
        };
        return ReportComponent_1;
    }());
    __setFunctionName(_classThis, "ReportComponent");
    (function () {
        var _metadata = typeof Symbol === "function" && Symbol.metadata ? Object.create(null) : void 0;
        _reportType_decorators = [(0, core_1.Input)()];
        _flextableComponent_decorators = [(0, core_1.ViewChild)(flextable_component_1.FlextableComponent)];
        __esDecorate(null, null, _reportType_decorators, { kind: "field", name: "reportType", static: false, private: false, access: { has: function (obj) { return "reportType" in obj; }, get: function (obj) { return obj.reportType; }, set: function (obj, value) { obj.reportType = value; } }, metadata: _metadata }, _reportType_initializers, _reportType_extraInitializers);
        __esDecorate(null, null, _flextableComponent_decorators, { kind: "field", name: "flextableComponent", static: false, private: false, access: { has: function (obj) { return "flextableComponent" in obj; }, get: function (obj) { return obj.flextableComponent; }, set: function (obj, value) { obj.flextableComponent = value; } }, metadata: _metadata }, _flextableComponent_initializers, _flextableComponent_extraInitializers);
        __esDecorate(null, _classDescriptor = { value: _classThis }, _classDecorators, { kind: "class", name: _classThis.name, metadata: _metadata }, null, _classExtraInitializers);
        ReportComponent = _classThis = _classDescriptor.value;
        if (_metadata) Object.defineProperty(_classThis, Symbol.metadata, { enumerable: true, configurable: true, writable: true, value: _metadata });
        __runInitializers(_classThis, _classExtraInitializers);
    })();
    return ReportComponent = _classThis;
}();
exports.ReportComponent = ReportComponent;
//# sourceMappingURL=report.component.js.map