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
exports.ReportMigationComponent = void 0;
var core_1 = require("@angular/core");
var dataMigration_service_1 = require("../../services/app/dataMigration.service");
var dataMigrationHistory_service_1 = require("../../services/app/dataMigrationHistory.service");
var user_service_1 = require("../../services/app/user.service");
var migrationmessage_service_1 = require("../../services/app/migrationmessage.service");
var ngx_grid_1 = require("@generic-ui/ngx-grid");
var rxjs_1 = require("rxjs");
var ReportMigationComponent = function () {
    var _classDecorators = [(0, core_1.Component)({
            selector: 'generate-app-reportmigration',
            templateUrl: './reportmigration.component.html',
            styleUrls: ['./reportmigration.component.scss'],
            providers: [dataMigration_service_1.DataMigrationService, user_service_1.UserService, migrationmessage_service_1.MigrationMessageService, dataMigrationHistory_service_1.DataMigrationHistoryService]
        })];
    var _classDescriptor;
    var _classExtraInitializers = [];
    var _classThis;
    var _comboReportYear_decorators;
    var _comboReportYear_initializers = [];
    var _comboReportYear_extraInitializers = [];
    var _comboFactType_decorators;
    var _comboFactType_initializers = [];
    var _comboFactType_extraInitializers = [];
    var _reportGrid_decorators;
    var _reportGrid_initializers = [];
    var _reportGrid_extraInitializers = [];
    var _reportGrids_decorators;
    var _reportGrids_initializers = [];
    var _reportGrids_extraInitializers = [];
    var ReportMigationComponent = _classThis = /** @class */ (function () {
        function ReportMigationComponent_1(_router, _dataMigrationService, _userService, _migrationMessageService, _dataMigrationHistoryService) {
            var _this = this;
            this._router = _router;
            this._dataMigrationService = _dataMigrationService;
            this._userService = _userService;
            this._migrationMessageService = _migrationMessageService;
            this._dataMigrationHistoryService = _dataMigrationHistoryService;
            this.comboReportYear = __runInitializers(this, _comboReportYear_initializers, void 0);
            this.comboFactType = (__runInitializers(this, _comboReportYear_extraInitializers), __runInitializers(this, _comboFactType_initializers, void 0));
            this.reportGrid = (__runInitializers(this, _comboFactType_extraInitializers), __runInitializers(this, _reportGrid_initializers, void 0));
            this.reportGrids = (__runInitializers(this, _reportGrid_extraInitializers), __runInitializers(this, _reportGrids_initializers, void 0));
            this.gridColumns = (__runInitializers(this, _reportGrids_extraInitializers), [
                {
                    header: 'Migration Date',
                    field: 'dataMigrationHistoryDate',
                    type: 'string',
                    width: 200
                },
                {
                    header: 'Message',
                    field: 'dataMigrationHistoryMessage',
                    type: 'string',
                    width: 900
                }
            ]);
            this.validationGridColumns = [
                {
                    header: 'Fact Type',
                    field: 'factTypeOrReportCode',
                    type: 'string',
                    width: 100
                },
                {
                    header: 'Table Name',
                    field: 'stagingTableName',
                    type: 'string',
                    width: 300
                },
                {
                    header: 'Column',
                    field: 'columnName',
                    type: 'string',
                    width: 250
                },
                {
                    header: 'Validation Message',
                    field: 'validationMessage',
                    type: 'string',
                    width: 800
                },
                {
                    header: 'Severity',
                    field: 'severity',
                    type: 'string',
                    width: 100
                }
            ];
            this.paging = {
                enabled: true,
                page: 1,
                pageSize: 10,
                pageSizes: [5, 10, 25],
                pagerTop: true,
                pagerBottom: true,
                display: ngx_grid_1.GuiPagingDisplay.ADVANCED
            };
            this.rowColoring = ngx_grid_1.GuiRowColoring.EVEN;
            this.rowStyle = {
                styleFunction: function (data, index) {
                    if ((data.dataMigrationHistoryMessage.toLowerCase().indexOf("exception") > -1) || (data.dataMigrationHistoryMessage.toLowerCase().indexOf("error") > -1)) {
                        return 'background: #FFF3E0';
                    }
                }
            };
            this.lastRunFactType = null;
            this.isLoading = false;
            this.userService = _userService;
            this.migrationMessageService = _migrationMessageService;
            this.reportMessage = 'Migration Pending';
            this.reportMigrationIsAvailable = false;
            this.reportMigrationIsProcessing = false;
            this.cancelIsAvailable = false;
            this.isCanceling = false;
            this.showReportMigrateStatus = false;
            this.showReportMigrateProgress = false;
            this.showReportMigrateTimeRemaining = false;
            this.reportType = 'report';
            this.updateStatus();
            this.refreshInterval = setInterval(function () {
                var currentUtcTime = moment.utc();
                var elapsedSeconds = 0;
                if (_this.lastTriggerTime != null) {
                    var durationSinceTrigger = moment.duration(currentUtcTime.diff(_this.lastTriggerTime));
                    elapsedSeconds = durationSinceTrigger.asSeconds();
                }
                if (elapsedSeconds >= 15 || _this.lastTriggerTime == null) {
                    _this.updateStatus();
                }
            }, 10000);
        }
        ReportMigationComponent_1.prototype.ngOnInit = function () {
            var self = this;
            this.isLoading = true;
            this.isRunning = false;
            this.tabIndex = 0;
            this.initializeReportPage();
        };
        ReportMigationComponent_1.prototype.initializeReportPage = function () {
            var _this = this;
            this.yearsNew = [];
            (0, rxjs_1.forkJoin)(this._dataMigrationService.getYears('report'), this._dataMigrationService.getFactTypes(), this._dataMigrationService.generateReportList(), this._dataMigrationService.generateReportType(), this._dataMigrationService.getLastRunFactType(), this._dataMigrationHistoryService.getStagingValidationResults()).subscribe(function (data) {
                _this.isLoading = false;
                _this.reportYears = data[0];
                _this.factTypes = data[1];
                _this.migrationTasks = data[2];
                _this.selectedReports = data[2];
                _this.generateReportTypes = data[3];
                _this.lastRunFactType = data[4];
                _this.stagingValidationResultList = data[5];
                //if (this.stagingValidationResultList.length > 0) { this.tabIndex = 2; }
                if (_this.lastRunFactType !== null) {
                    _this.selectedFactTypeCode = _this.lastRunFactType.factTypeCode;
                }
                _this.reportYears.forEach(function (item, index) {
                    if (item.isSelected) {
                        _this.selectedyear = item;
                    }
                    _this.dimSchoolYearDataMigrationType = {
                        dimSchoolYearId: item.dimSchoolYearId,
                        dataMigrationTypeId: item.dataMigrationTypeId,
                        isSelected: item.isSelected
                    };
                    _this.yearsNew.push(_this.dimSchoolYearDataMigrationType);
                });
                _this.migrationTasks.forEach(function (b) {
                    _this.generateReportTypes.forEach(function (c) {
                        if (c.generateReportTypeId === b.generateReportTypeId) {
                            b.reportType = c.reportTypeName;
                        }
                    });
                });
                //this.directoryCheck();
                if (_this.selectedFactTypeCode !== undefined && _this.selectedFactTypeCode !== null && _this.selectedFactTypeCode.length > 0) {
                    var selectedFactTypeId_1 = _this.factTypes.filter(function (t) { return t.factTypeCode === _this.selectedFactTypeCode; })[0].dimFactTypeId;
                    _this.setFactType(selectedFactTypeId_1);
                    _this.cvData = _this.selectedReports.filter(function (t) { return t.generateReport_FactTypes.map(function (t) { return t.factTypeId; }).includes(selectedFactTypeId_1); });
                }
                else {
                    _this.cvData = _this.migrationTasks;
                }
                // Filter to get distinct school years
                var distinctYears = _this.reportYears.filter(function (year, index, self) {
                    return self.findIndex(function (y) { return y.dimSchoolYearId === year.dimSchoolYearId; }) === index;
                });
                // Set selectedIndex to the year where isSelected = true
                if (_this.selectedyear) {
                    _this.selectedIndex = distinctYears.findIndex(function (y) { return y.dimSchoolYearId === _this.selectedyear.dimSchoolYearId; });
                }
                _this.cvDataYear = distinctYears;
                _this.cvFactTypes = _this.factTypes;
            });
        };
        ReportMigationComponent_1.prototype.ngOnDestroy = function () {
            if (this.refreshInterval) {
                clearInterval(this.refreshInterval);
            }
        };
        ReportMigationComponent_1.prototype.initGrid = function (s, e) {
            var self = this;
            s.columnHeaders.setCellData(0, 0, "");
            s.rows.defaultSize = 24;
            s.columnHeaders.rows.defaultSize = 24;
            s.cellEditEnded.addHandler(function (s, e) {
                if (e.col == 0) {
                    var item_1 = s.rows[e.row].dataItem;
                    var generateReportId_1 = parseInt(item_1.generateReportId);
                    self.selectedReports.forEach(function (a) {
                        if (a.generateReportId === generateReportId_1) {
                            a.isLocked = item_1.isLocked;
                        }
                    });
                }
            });
            s.beginningEdit.addHandler(function (s, e) {
                if (s.columns[e.col].binding == 'reportCode' || s.columns[e.col].binding == 'reportName' || s.columns[e.col].binding == 'reportType' || s.columns[e.col].binding == 'description') {
                    e.cancel = true;
                }
            });
        };
        ReportMigationComponent_1.prototype.reportSelected = function (s, e) {
            var self = this;
            var generateReportId = parseInt(s.selectedIds[0]);
            self.selectedReports.forEach(function (a) {
                if (s.selectedIds.find(function (item) { return item == a.generateReportId.toString(); }) !== undefined) {
                    a.isLocked = true;
                }
                else {
                    a.isLocked = false;
                }
            });
        };
        ReportMigationComponent_1.prototype.refreshData = function (s, e) {
            this.cvData.refresh();
        };
        ReportMigationComponent_1.prototype.onReportYearUpdate = function (ev, control) {
            var _this = this;
            this.checkedYear = control.selectedItem;
            // Update yearsNew for data consistency
            this.yearsNew.forEach(function (item) {
                if (item.dimSchoolYearId === _this.checkedYear.dimSchoolYearId) {
                    item.isSelected = true;
                }
                else {
                    item.isSelected = false;
                }
            });
            // Set selectedIndex using cvDataYear (the array displayed in dropdown)
            // cvDataYear contains distinct years, so we must find index in that array
            this.selectedIndex = this.cvDataYear.findIndex(function (y) { return y.dimSchoolYearId === _this.checkedYear.dimSchoolYearId; });
        };
        ReportMigationComponent_1.prototype.onFactTypeUpdate = function (ev, control) {
            var selectedFactTypeId = control.selectedItem.dimFactTypeId;
            this.setFactType(selectedFactTypeId);
            /*control.selectedItem = this.factTypes.filter(t => t.dimFactTypeId === selectedFactTypeId)[0];*/
            this.selectedFactTypeCode = control.selectedItem.factTypeCode;
            this.cvData = this.selectedReports.filter(function (t) { return t.generateReport_FactTypes.map(function (t) { return t.factTypeId; }).includes(selectedFactTypeId); });
        };
        ReportMigationComponent_1.prototype.setFactType = function (selectedFactTypeId) {
            var _this = this;
            this.factTypes.forEach(function (item, index) {
                if (item.dimFactTypeId === selectedFactTypeId) {
                    _this.selectedFactTypeIndex = index;
                }
            });
        };
        ReportMigationComponent_1.prototype.itemsSourceChanged = function (s, e) {
            var d = new Date();
            var n = d.getMilliseconds();
            setTimeout(function () {
                if (s.hostElement != null) {
                    var row = s.columnHeaders.rows[0];
                    row.wordWrap = true;
                    s.autoSizeRow(0, true);
                }
            });
        };
        ReportMigationComponent_1.prototype.ngAfterViewInit = function () {
            componentHandler.upgradeAllRegistered();
        };
        ReportMigationComponent_1.prototype.updateStatus = function () {
            var _this = this;
            var lastFactType = this.lastRunFactType;
            this._dataMigrationService.getLastRunFactType().subscribe(function (resp) {
                _this.lastRunFactType = resp;
                if (_this.selectedReports !== undefined && (_this.lastRunFactType !== null) && _this.lastRunFactType.factTypeCode !== ((lastFactType !== null) ? lastFactType.factTypeCode : null)) {
                    //this.selectedFactTypeCode = this.lastRunFactType.factTypeCode;
                    //this.setFactType(this.lastRunFactType.dimFactTypeId);
                    _this.cvData = _this.selectedReports.filter(function (t) { return t.generateReport_FactTypes.map(function (t) { return t.factTypeId; }).includes(_this.lastRunFactType.dimFactTypeId); });
                }
            });
            this._dataMigrationService.currentMigrationStatus()
                .subscribe(function (resp) {
                var data = resp;
                var factTypeMessage = (_this.lastRunFactType !== null) ? (' for ' + _this.lastRunFactType.factTypeCode) : '';
                var userName = (data.userName !== null) ? (' by ' + data.userName) : '';
                if (data.reportMigrationStatusCode === 'initial') {
                    _this.reportMigrationIsAvailable = true;
                    _this.reportMigrationIsProcessing = false;
                    _this.cancelIsAvailable = false;
                    _this.isCanceling = false;
                    _this.showReportMigrateProgress = false;
                    _this.showReportMigrateStatus = false;
                    _this.showReportMigrateTimeRemaining = false;
                    //this.directoryCheck();
                }
                else if (data.reportMigrationStatusCode === 'success') {
                    _this.reportMigrationIsAvailable = true;
                    _this.reportMigrationIsProcessing = false;
                    _this.cancelIsAvailable = false;
                    _this.isCanceling = false;
                    _this.showReportMigrateProgress = false;
                    _this.showReportMigrateStatus = true;
                    _this.showReportMigrateTimeRemaining = false;
                    _this.reportMessage = _this.migrationMessageService.getStatusMessage(data.reportLastMigrationTriggerDate, data.reportLastMigrationDurationInSeconds, userName, factTypeMessage);
                    if (_this.flag === true) {
                        _this.migrationTasks.forEach(function (b) {
                            b.isLocked = false;
                        });
                        /*this.cvData = this.migrationTasks;*/
                    }
                    _this.flag = false;
                    //this.directoryCheck();
                }
                else if (data.reportMigrationStatusCode === 'error') {
                    var durationSinceError = void 0;
                    var elapsedSecondsSinceError = 0;
                    if (data.reportLastMigrationHistoryDate != null) {
                        var currentUtcTime = moment.utc();
                        var lastUtcTime = moment.utc(data.reportLastMigrationHistoryDate).toDate();
                        durationSinceError = moment.duration(currentUtcTime.diff(lastUtcTime));
                        elapsedSecondsSinceError = durationSinceError.asSeconds();
                    }
                    else {
                        elapsedSecondsSinceError = 0;
                    }
                    var timeRemaining = Math.round(120 - elapsedSecondsSinceError);
                    // Do not make migration available again until at least 2 minutes after cancel/error
                    if (elapsedSecondsSinceError > 120 || data.reportLastMigrationHistoryDate == null) {
                        _this.reportMigrationIsAvailable = true;
                        _this.reportMessage = 'Last migration was initiated ' + userName + factTypeMessage + ' and was either cancelled or resulted in an error. If the migration failed, check the Data Migration Log tab on this page or click <a href="https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/migration/troubleshooting" target="_blank">here</a> for documentation on possible migration issues.';
                        _this.isCanceling = false;
                    }
                    else {
                        _this.reportMigrationIsAvailable = false;
                        _this.reportMessage = 'Last Migration was initiated ' + userName + factTypeMessage + ' and was either cancelled or resulted in an error - please wait for tasks to finish (approximately ' + timeRemaining + ' seconds). If the migration failed, check the Data Migration Log tab on this page or click <a href="https://center-for-the-integration-of-id.gitbook.io/generate-documentation/developer-guides/migration/troubleshooting" target="_blank">here</a> for documentation on possible migration issues.';
                        _this.isCanceling = true;
                    }
                    _this.reportMigrationIsProcessing = false;
                    _this.cancelIsAvailable = false;
                    _this.isCanceling = false;
                    _this.showReportMigrateProgress = false;
                    _this.showReportMigrateStatus = true;
                    _this.showReportMigrateTimeRemaining = false;
                    _this.reportMigrationIsAvailable = true;
                }
                else if (data.reportMigrationStatusCode === 'pending' || data.reportMigrationStatusCode === 'processing') {
                    _this.reportMigrationIsAvailable = true;
                    _this.reportMigrationIsProcessing = true;
                    _this.showReportMigrateStatus = true;
                    if (data.reportLastMigrationDurationInSeconds != null) {
                        if (data.reportLastMigrationHistoryMessage != 'Migration starting ...' && data.reportLastMigrationHistoryMessage != 'Migration Pending') {
                            _this.cancelIsAvailable = true;
                        }
                        if (_this.isCanceling) {
                            data.reportLastMigrationHistoryMessage = 'Cancelling migration';
                        }
                        if (data.reportLastMigrationHistoryDate != null) {
                            var lastMigrationHistoryDateUtc = moment.utc(data.reportLastMigrationHistoryDate).toDate();
                            var lastMigrationHistoryDateLocal = moment(lastMigrationHistoryDateUtc).format('MM/DD/YYYY, h:mm:ss a');
                            _this.reportMessage = moment(lastMigrationHistoryDateUtc).format('MM/DD/YYYY, h:mm:ss a') + ' - ' + data.reportLastMigrationHistoryMessage;
                        }
                        else {
                            _this.reportMessage = data.reportLastMigrationHistoryMessage;
                        }
                    }
                    else {
                        _this.reportMessage = 'Migration Pending';
                    }
                    if (data.reportLastMigrationDurationInSeconds != null && data.reportLastMigrationTriggerDate != null) {
                        _this.setProgress(data.reportLastMigrationDurationInSeconds, data.reportLastMigrationTriggerDate, userName, '#reportMigrationStatus');
                        _this.showReportMigrateProgress = true;
                        _this.showReportMigrateTimeRemaining = true;
                    }
                    else {
                        _this.showReportMigrateProgress = false;
                        _this.showReportMigrateTimeRemaining = false;
                    }
                }
            }, function (error) { return _this.errorMessage = error; });
        };
        ReportMigationComponent_1.prototype.setProgress = function (totalduration, lasttriggerdate, username, progressControlid) {
            var progress;
            var elapsedSeconds;
            var remainingMinutes;
            var duration;
            if (lasttriggerdate != null) {
                var currentUtcTime = moment.utc();
                var triggerUtcTime = moment.utc(lasttriggerdate).toDate();
                duration = moment.duration(currentUtcTime.diff(triggerUtcTime));
                elapsedSeconds = duration.asSeconds();
            }
            else {
                elapsedSeconds = 0;
            }
            remainingMinutes = (totalduration - elapsedSeconds) / 60;
            progress = (elapsedSeconds / totalduration) * 100;
            remainingMinutes = parseInt(remainingMinutes);
            var etaMessage = '';
            if (remainingMinutes > 1) {
                etaMessage = 'Approximately ' + remainingMinutes + ' minutes remaining';
            }
            else if (Math.abs(remainingMinutes) <= 1) {
                etaMessage = 'Migration will finish momentarily';
            }
            else {
                etaMessage = 'Migration has exceeded previous duration by ' + Math.abs(remainingMinutes) + ' minutes';
            }
            this.estimatedReportCompletionTime = etaMessage;
            if (progress >= 100) {
                progress = 100;
            }
            var progressBar = document.querySelector(progressControlid);
            if (progressBar != null) {
                progressBar['MaterialProgress'].setProgress(parseInt(progress));
            }
        };
        ReportMigationComponent_1.prototype.executeReportMigration = function () {
            var _this = this;
            this.reportMigrationIsProcessing = true;
            this.reportMessage = "Migration starting ...";
            this.showReportMigrateStatus = true;
            this.lastTriggerTime = moment.utc();
            this.flag = true;
            this._dataMigrationService.migrateReport(this.yearsNew, this.selectedReports, this._userService.getUserLoginName())
                .subscribe(function (result) {
                _this.resultMessage = result;
                _this._dataMigrationService.getYears('ods')
                    .subscribe(function (data) {
                    _this.reportYears = data;
                });
            }, function (error) { return _this.errorMessage = error; });
        };
        ReportMigationComponent_1.prototype.triggerReportMigration = function (dlg) {
            if (dlg) {
                dlg.hide();
            }
            this.executeReportMigration();
            return false;
        };
        ReportMigationComponent_1.prototype.migrateDirectory = function () {
            var _this = this;
            this.selectedFactTypeCode = 'directory';
            this.setFactType(this.factTypes.filter(function (t) { return t.factTypeCode === _this.selectedFactTypeCode; })[0].dimFactTypeId);
            this.selectedReports.forEach(function (t) {
                if (t.reportCode === '029') {
                    t.isLocked = true;
                }
                else {
                    t.isLocked = false;
                }
            });
            this.executeReportMigration();
        };
        ReportMigationComponent_1.prototype.showDialog = function (dlg, dialogId) {
            dlg.modal = true;
            dlg.show();
        };
        ReportMigationComponent_1.prototype.discardDialog = function (dlg) {
            this.errorMessage = '';
            dlg.hide();
        };
        ReportMigationComponent_1.prototype.showConfirmReportDialog = function (dlg) {
            if (dlg) {
                dlg.modal = true;
                dlg.show();
            }
        };
        ;
        ReportMigationComponent_1.prototype.showConfirmCancellationDialog = function (dlg) {
            if (dlg) {
                dlg.modal = true;
                dlg.show();
            }
        };
        ;
        ReportMigationComponent_1.prototype.cancelMigration = function (dlg) {
            var _this = this;
            if (dlg) {
                dlg.hide();
            }
            this.isCanceling = true;
            this._dataMigrationService.cancelMigration("report")
                .subscribe(function (result) {
                _this.resultMessage = result;
                _this.updateStatus();
            }, function (error) { return _this.errorMessage = error; });
            return false;
        };
        ReportMigationComponent_1.prototype.gotoDataStore = function () {
            this._router.navigateByUrl('/reports/edfacts');
            return false;
        };
        ReportMigationComponent_1.prototype.directoryCheck = function () {
            var _this = this;
            if (this.selectedyear !== undefined && this.selectedyear.dimSchoolYearId > 0) {
                this._dataMigrationService.checkIfDirectoryDataExists(this.selectedyear.dimSchoolYearId)
                    .subscribe(function (result) {
                    if (!_this.reportMigrationIsProcessing) {
                        _this.reportMigrationIsAvailable = result;
                        if (!result) {
                            _this.reportMessage = "Please run Directory migration before running other migrations.";
                        }
                    }
                });
            }
        };
        ReportMigationComponent_1.prototype.getTabContent = function (tabIndex) {
            var _this = this;
            if (tabIndex === 0) {
                this.updateStatus();
            }
            if (tabIndex === 1) {
                this._dataMigrationHistoryService.getMigrationHistory('report')
                    .subscribe(function (resp) { _this.migrationHistoryList = resp; });
            }
            else if (tabIndex === 2) {
                this._dataMigrationHistoryService.getStagingValidationResults()
                    .subscribe(function (resp) { _this.stagingValidationResultList = resp; });
            }
        };
        return ReportMigationComponent_1;
    }());
    __setFunctionName(_classThis, "ReportMigationComponent");
    (function () {
        var _metadata = typeof Symbol === "function" && Symbol.metadata ? Object.create(null) : void 0;
        _comboReportYear_decorators = [(0, core_1.ViewChild)('comboReportYear', { static: false })];
        _comboFactType_decorators = [(0, core_1.ViewChild)('comboFactType', { static: false })];
        _reportGrid_decorators = [(0, core_1.ViewChild)('reportGrid', { static: false })];
        _reportGrids_decorators = [(0, core_1.ViewChildren)('reportGrid')];
        __esDecorate(null, null, _comboReportYear_decorators, { kind: "field", name: "comboReportYear", static: false, private: false, access: { has: function (obj) { return "comboReportYear" in obj; }, get: function (obj) { return obj.comboReportYear; }, set: function (obj, value) { obj.comboReportYear = value; } }, metadata: _metadata }, _comboReportYear_initializers, _comboReportYear_extraInitializers);
        __esDecorate(null, null, _comboFactType_decorators, { kind: "field", name: "comboFactType", static: false, private: false, access: { has: function (obj) { return "comboFactType" in obj; }, get: function (obj) { return obj.comboFactType; }, set: function (obj, value) { obj.comboFactType = value; } }, metadata: _metadata }, _comboFactType_initializers, _comboFactType_extraInitializers);
        __esDecorate(null, null, _reportGrid_decorators, { kind: "field", name: "reportGrid", static: false, private: false, access: { has: function (obj) { return "reportGrid" in obj; }, get: function (obj) { return obj.reportGrid; }, set: function (obj, value) { obj.reportGrid = value; } }, metadata: _metadata }, _reportGrid_initializers, _reportGrid_extraInitializers);
        __esDecorate(null, null, _reportGrids_decorators, { kind: "field", name: "reportGrids", static: false, private: false, access: { has: function (obj) { return "reportGrids" in obj; }, get: function (obj) { return obj.reportGrids; }, set: function (obj, value) { obj.reportGrids = value; } }, metadata: _metadata }, _reportGrids_initializers, _reportGrids_extraInitializers);
        __esDecorate(null, _classDescriptor = { value: _classThis }, _classDecorators, { kind: "class", name: _classThis.name, metadata: _metadata }, null, _classExtraInitializers);
        ReportMigationComponent = _classThis = _classDescriptor.value;
        if (_metadata) Object.defineProperty(_classThis, Symbol.metadata, { enumerable: true, configurable: true, writable: true, value: _metadata });
        __runInitializers(_classThis, _classExtraInitializers);
    })();
    return ReportMigationComponent = _classThis;
}();
exports.ReportMigationComponent = ReportMigationComponent;
//# sourceMappingURL=reportmigration.component.js.map