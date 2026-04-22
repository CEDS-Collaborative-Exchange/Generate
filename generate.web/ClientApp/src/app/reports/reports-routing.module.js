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
exports.ReportsRoutingModule = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
// Container
var reports_component_1 = require("./reports.component");
// Pages
var reports_summary_component_1 = require("./summary/reports-summary.component");
var reports_edfacts_component_1 = require("./edfacts/reports-edfacts.component");
/*import { ReportsSppaprComponent } from './sppapr/reports-sppapr.component';*/
var reports_library_component_1 = require("./library/reports-library.component");
var reports_library_report_component_1 = require("./library/reports-library-report.component");
var featureRoutes = [
    {
        path: '',
        component: reports_component_1.ReportsComponent,
        children: [
            { path: 'summary', component: reports_summary_component_1.ReportsSummaryComponent },
            { path: 'edfacts', component: reports_edfacts_component_1.ReportsEdfactsComponent },
            /*{ path: 'sppapr', component: ReportsSppaprComponent },*/
            { path: 'library', component: reports_library_component_1.ReportsLibraryComponent },
            { path: 'library/report', component: reports_library_report_component_1.ReportsLibraryReportComponent },
        ]
    }
];
var ReportsRoutingModule = function () {
    var _classDecorators = [(0, core_1.NgModule)({
            imports: [
                router_1.RouterModule.forChild(featureRoutes)
            ],
            exports: [
                router_1.RouterModule
            ]
        })];
    var _classDescriptor;
    var _classExtraInitializers = [];
    var _classThis;
    var ReportsRoutingModule = _classThis = /** @class */ (function () {
        function ReportsRoutingModule_1() {
        }
        return ReportsRoutingModule_1;
    }());
    __setFunctionName(_classThis, "ReportsRoutingModule");
    (function () {
        var _metadata = typeof Symbol === "function" && Symbol.metadata ? Object.create(null) : void 0;
        __esDecorate(null, _classDescriptor = { value: _classThis }, _classDecorators, { kind: "class", name: _classThis.name, metadata: _metadata }, null, _classExtraInitializers);
        ReportsRoutingModule = _classThis = _classDescriptor.value;
        if (_metadata) Object.defineProperty(_classThis, Symbol.metadata, { enumerable: true, configurable: true, writable: true, value: _metadata });
        __runInitializers(_classThis, _classExtraInitializers);
    })();
    return ReportsRoutingModule = _classThis;
}();
exports.ReportsRoutingModule = ReportsRoutingModule;
//# sourceMappingURL=reports-routing.module.js.map