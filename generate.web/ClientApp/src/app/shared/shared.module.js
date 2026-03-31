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
exports.SharedModule = void 0;
var core_1 = require("@angular/core");
var common_1 = require("@angular/common");
var breadcrumbs_component_1 = require("./components/breadcrumbs.component");
var pagetitle_component_1 = require("./components/pagetitle.component");
var login_component_1 = require("./components/login.component");
var ok_dialog_component_1 = require("./components/ok-dialog.component");
var dialog_1 = require("@angular/material/dialog");
var keepalive_1 = require("@ng-idle/keepalive");
var yes_no_dialog_component_1 = require("./components/yes-no-dialog.component");
var confirmationdialog_component_1 = require("./components/confirmationdialog.component");
var pivottable_component_1 = require("./components/pivottable/pivottable.component");
/* Pagination Module */
var paginator_1 = require("@angular/material/paginator");
var datepicker_component_1 = require("./components/datepicker/datepicker.component");
var combo_box_component_1 = require("./components/combo-box/combo-box.component");
var dialog_component_1 = require("./components/dialog/dialog.component");
var autocomplete_component_1 = require("./components/autocomplete/autocomplete.component");
var flextable_component_1 = require("./components/flextable/flextable.component");
var report_library_table_component_1 = require("./components/report-library-table/report-library-table.component");
var SharedModule = function () {
    var _classDecorators = [(0, core_1.NgModule)({
            imports: [
                common_1.CommonModule,
                dialog_1.MatDialogModule,
                keepalive_1.NgIdleKeepaliveModule.forRoot(),
                paginator_1.MatPaginatorModule,
                datepicker_component_1.DatepickerComponent,
                combo_box_component_1.ComboBoxComponent,
                dialog_component_1.DialogComponent,
                autocomplete_component_1.AutocompleteComponent,
                flextable_component_1.FlextableComponent,
                report_library_table_component_1.ReportLibraryTableComponent,
            ],
            declarations: [
                breadcrumbs_component_1.BreadcrumbsComponent,
                pagetitle_component_1.PageTitleComponent,
                login_component_1.LoginComponent,
                ok_dialog_component_1.OkDialogComponent,
                yes_no_dialog_component_1.YesNoDialogComponent,
                confirmationdialog_component_1.ConfirmationDialogComponent,
                pivottable_component_1.PivottableComponent
            ],
            exports: [
                common_1.CommonModule,
                breadcrumbs_component_1.BreadcrumbsComponent,
                pagetitle_component_1.PageTitleComponent,
                login_component_1.LoginComponent,
                pivottable_component_1.PivottableComponent,
                datepicker_component_1.DatepickerComponent,
                combo_box_component_1.ComboBoxComponent,
                dialog_component_1.DialogComponent,
                autocomplete_component_1.AutocompleteComponent,
                flextable_component_1.FlextableComponent,
                report_library_table_component_1.ReportLibraryTableComponent,
            ]
        })];
    var _classDescriptor;
    var _classExtraInitializers = [];
    var _classThis;
    var SharedModule = _classThis = /** @class */ (function () {
        function SharedModule_1() {
        }
        return SharedModule_1;
    }());
    __setFunctionName(_classThis, "SharedModule");
    (function () {
        var _metadata = typeof Symbol === "function" && Symbol.metadata ? Object.create(null) : void 0;
        __esDecorate(null, _classDescriptor = { value: _classThis }, _classDecorators, { kind: "class", name: _classThis.name, metadata: _metadata }, null, _classExtraInitializers);
        SharedModule = _classThis = _classDescriptor.value;
        if (_metadata) Object.defineProperty(_classThis, Symbol.metadata, { enumerable: true, configurable: true, writable: true, value: _metadata });
        __runInitializers(_classThis, _classExtraInitializers);
    })();
    return SharedModule = _classThis;
}();
exports.SharedModule = SharedModule;
//# sourceMappingURL=shared.module.js.map