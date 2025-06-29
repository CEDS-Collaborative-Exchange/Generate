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
exports.SettingsModule = void 0;
var core_1 = require("@angular/core");
var forms_1 = require("@angular/forms");
var ngx_grid_1 = require("@generic-ui/ngx-grid");
// Shared
var shared_module_1 = require("../shared/shared.module");
var toggleSection_filter_1 = require("../shared/filters/toggleSection.filter");
var toggleQuestion_filter_1 = require("../shared/filters/toggleQuestion.filter");
var toggleQuestionType_filter_1 = require("../shared/filters/toggleQuestionType.filter");
var toggleQuestionOption_filter_1 = require("../shared/filters/toggleQuestionOption.filter");
var toggleQuestionOtherOption_filter_1 = require("../shared/filters/toggleQuestionOtherOption.filter");
var toggleQuestionResponse_filter_1 = require("../shared/filters/toggleQuestionResponse.filter");
var upload_module_1 = require("../shared/components/upload/upload.module");
// Routing
var settings_routing_module_1 = require("./settings-routing.module");
// Containers
var settings_component_1 = require("./settings.component");
// Pages
var toggle_component_1 = require("./toggle/toggle.component");
var toggle_assessment_component_1 = require("./toggle/toggle-assessment.component");
var datastore_component_1 = require("./datastore/datastore.component");
var odsmigration_component_1 = require("./datastore/odsmigration.component");
var rdsmigration_component_1 = require("./datastore/rdsmigration.component");
var reportmigration_component_1 = require("./datastore/reportmigration.component");
var update_component_1 = require("./update/update.component");
var metadata_component_1 = require("./metadata/metadata.component");
var dialog_1 = require("@angular/material/dialog");
var tabs_1 = require("@angular/material/tabs");
var icon_1 = require("@angular/material/icon");
var forms_2 = require("@angular/forms");
var SettingsModule = function () {
    var _classDecorators = [(0, core_1.NgModule)({
            imports: [
                shared_module_1.SharedModule,
                settings_routing_module_1.SettingsRoutingModule,
                forms_1.ReactiveFormsModule,
                upload_module_1.UploadModule,
                dialog_1.MatDialogModule,
                ngx_grid_1.GuiGridModule,
                tabs_1.MatTabsModule,
                icon_1.MatIconModule,
                forms_2.FormsModule
            ],
            declarations: [
                settings_component_1.SettingsComponent,
                toggle_component_1.SettingsToggleComponent,
                toggle_assessment_component_1.SettingsToggleAssessmentComponent,
                datastore_component_1.SettingsDataStoreComponent,
                odsmigration_component_1.ODSMigationComponent,
                rdsmigration_component_1.RDSMigrationComponent,
                reportmigration_component_1.ReportMigationComponent,
                toggleSection_filter_1.ToggleSectionFilter,
                toggleQuestion_filter_1.ToggleQuestionFilter,
                toggleQuestionType_filter_1.ToggleQuestionTypeFilter,
                toggleQuestionOption_filter_1.ToggleQuestionOptionFilter,
                toggleQuestionOtherOption_filter_1.ToggleQuestionOtherOptionFilter,
                toggleQuestionResponse_filter_1.ToggleQuestionResponseFilter,
                update_component_1.UpdateComponent,
                metadata_component_1.MetadataComponent
            ]
        })];
    var _classDescriptor;
    var _classExtraInitializers = [];
    var _classThis;
    var SettingsModule = _classThis = /** @class */ (function () {
        function SettingsModule_1() {
        }
        return SettingsModule_1;
    }());
    __setFunctionName(_classThis, "SettingsModule");
    (function () {
        var _metadata = typeof Symbol === "function" && Symbol.metadata ? Object.create(null) : void 0;
        __esDecorate(null, _classDescriptor = { value: _classThis }, _classDecorators, { kind: "class", name: _classThis.name, metadata: _metadata }, null, _classExtraInitializers);
        SettingsModule = _classThis = _classDescriptor.value;
        if (_metadata) Object.defineProperty(_classThis, Symbol.metadata, { enumerable: true, configurable: true, writable: true, value: _metadata });
        __runInitializers(_classThis, _classExtraInitializers);
    })();
    return SettingsModule = _classThis;
}();
exports.SettingsModule = SettingsModule;
//# sourceMappingURL=settings.module.js.map