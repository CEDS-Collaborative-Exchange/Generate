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
exports.MetadataComponent = void 0;
var core_1 = require("@angular/core");
var FSMetadataUpdate_service_1 = require("../../services/app/FSMetadataUpdate.service");
var MetadataComponent = function () {
    var _classDecorators = [(0, core_1.Component)({
            selector: 'generate-app-metadata',
            templateUrl: './metadata.component.html',
            styleUrl: './metadata.component.scss',
            providers: [FSMetadataUpdate_service_1.FSMetadataUpdate],
            standalone: false
        })];
    var _classDescriptor;
    var _classExtraInitializers = [];
    var _classThis;
    var MetadataComponent = _classThis = /** @class */ (function () {
        function MetadataComponent_1(_FSMetadatapdateService) {
            var _this = this;
            this._FSMetadatapdateService = _FSMetadatapdateService;
            this.isprocessing = false;
            this.ddlDisabled = true;
            this._fsmetadatapdateService = _FSMetadatapdateService;
            this.getStatus();
            //this.getLatestSYs();
            this.getUplFlag();
            this.refreshInterval = setInterval(function () {
                var currentUtcTime = moment.utc();
                var elapsedSeconds = 0;
                if (_this.lastTriggerTime != null) {
                    var durationSinceTrigger = moment.duration(currentUtcTime.diff(_this.lastTriggerTime));
                    elapsedSeconds = durationSinceTrigger.asSeconds();
                }
                if (elapsedSeconds >= 15 || _this.lastTriggerTime == null) {
                    _this.getStatus();
                }
            }, 10000);
        }
        MetadataComponent_1.prototype.ngAfterViewInit = function () {
            //componentHandler.upgradeAllRegistered();
        };
        MetadataComponent_1.prototype.ngOnInit = function () { };
        MetadataComponent_1.prototype.callFSmetaAPI = function () {
            this.isprocessing = true;
            this.metadataStatusMessage = "The metadata is currently being processed.";
            this.metadataCss('PROCESSING');
            this._fsmetadatapdateService.callFSMetaServc(this.selSY)
                .subscribe(function (resp) { });
        };
        MetadataComponent_1.prototype.getStatus = function () {
            var _this = this;
            this._fsmetadatapdateService.getMetadataStatus()
                .subscribe(function (resp) {
                _this.metadataStatus = resp;
                if (_this.metadataStatus !== undefined) {
                    _this.metadataStatusMessage = _this.metadataStatus.filter(function (t) { return t.generateConfigurationKey === 'MetaLastRunLog'; })[0].generateConfigurationValue;
                    var status_1 = _this.metadataStatus.filter(function (t) { return t.generateConfigurationKey === 'metaStatus'; })[0].generateConfigurationValue;
                    _this.metadataCss(status_1);
                    if (status_1.toUpperCase() === 'PROCESSING') {
                        _this.isprocessing = true;
                        _this.ddlDisabled = true;
                    }
                    else {
                        _this.isprocessing = false;
                        _this.ddlDisabled = false;
                    }
                }
            });
        };
        MetadataComponent_1.prototype.metadataCss = function (status) {
            if (status === "FAILED") {
                this.metadataStatusCss = 'generate-metadata__error';
            }
            else {
                this.metadataStatusCss = 'generate-metadata__message';
            }
        };
        MetadataComponent_1.prototype.getLatestSYs = function () {
            var _this = this;
            console.log('--getLatestSYs--');
            this._fsmetadatapdateService.getlatestSYs()
                .subscribe(function (resp) {
                console.log(resp);
                _this.latestPubSYlist = resp;
                if (_this.latestPubSYlist != null && _this.latestPubSYlist.length > 0) {
                    _this.selSY = _this.latestPubSYlist[0];
                }
            });
            //if (this.ddlDisabled == false) {
            //}
        };
        MetadataComponent_1.prototype.getUplFlag = function () {
            console.log('--getUplFlag--');
            //this.ddlDisabled = false;
            this.getLatestSYs();
            //this._fsmetadatapdateService.getFlag()
            //    .subscribe(resp => {
            //        console.log('getUplFlag');
            //        console.log(resp);
            //        //this.latestPubSYlist = resp;
            //        if (resp=="True") {
            //            this.ddlDisabled = true;
            //            //this.selSY = "";
            //            console.log('--True--');
            //        }
            //        else {
            //            this.ddlDisabled = false;
            //            this.getLatestSYs();
            //        }
            //    });
        };
        return MetadataComponent_1;
    }());
    __setFunctionName(_classThis, "MetadataComponent");
    (function () {
        var _metadata = typeof Symbol === "function" && Symbol.metadata ? Object.create(null) : void 0;
        __esDecorate(null, _classDescriptor = { value: _classThis }, _classDecorators, { kind: "class", name: _classThis.name, metadata: _metadata }, null, _classExtraInitializers);
        MetadataComponent = _classThis = _classDescriptor.value;
        if (_metadata) Object.defineProperty(_classThis, Symbol.metadata, { enumerable: true, configurable: true, writable: true, value: _metadata });
        __runInitializers(_classThis, _classExtraInitializers);
    })();
    return MetadataComponent = _classThis;
}();
exports.MetadataComponent = MetadataComponent;
//# sourceMappingURL=metadata.component.js.map