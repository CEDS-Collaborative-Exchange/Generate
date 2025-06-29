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
exports.ReportsModule = void 0;
var core_1 = require("@angular/core");
var forms_1 = require("@angular/forms");
var shared_module_1 = require("../shared/shared.module");
// Routing
var reports_routing_module_1 = require("./reports-routing.module");
// Containers
var reports_component_1 = require("./reports.component");
// Pages
var reports_summary_component_1 = require("./summary/reports-summary.component");
var reports_edfacts_component_1 = require("./edfacts/reports-edfacts.component");
var reports_sppapr_component_1 = require("./sppapr/reports-sppapr.component");
var reports_library_component_1 = require("./library/reports-library.component");
// Child Components
var report_component_1 = require("../shared/report.component");
var flexgrid_component_1 = require("../shared/reportcontrols/flexgrid.component");
var pivotgrid_component_1 = require("../shared/reportcontrols/pivotgrid.component");
var indicator4a_component_1 = require("../shared/reportcontrols/indicator4a.component");
var indicator4b_component_1 = require("../shared/reportcontrols/indicator4b.component");
var studentcount_component_1 = require("../shared/reportcontrols/studentcount.component");
var exitspecialeducation_component_1 = require("../shared/reportcontrols/exitspecialeducation.component");
var cohortgraduationrate_component_1 = require("../shared/reportcontrols/cohortgraduationrate.component");
var studentfederalprogramsparticipation_component_1 = require("../shared/reportcontrols/studentfederalprogramsparticipation.component");
var studentmultiplefederalprogramsparticipation_component_1 = require("../shared/reportcontrols/studentmultiplefederalprogramsparticipation.component");
var disciplinaryremovals_component_1 = require("../shared/reportcontrols/disciplinaryremovals.component");
var stateassessmentsperformance_component_1 = require("../shared/reportcontrols/stateassessmentsperformance.component");
var edenvironmentdisabilitiesage3_5_component_1 = require("../shared/reportcontrols/edenvironmentdisabilitiesage3-5.component");
var edenvironmentdisabilitiesage6_21_component_1 = require("../shared/reportcontrols/edenvironmentdisabilitiesage6-21.component");
var gradesoffered_component_1 = require("../shared/reportcontrols/gradesoffered.component");
var c029_component_1 = require("../shared/reportcontrols/c029.component");
var ccdschool_component_1 = require("../shared/reportcontrols/ccdschool.component");
var leafederalfund_component_1 = require("../shared/reportcontrols/leafederalfund.component");
var earlycharter_component_1 = require("../shared/reportcontrols/earlycharter.component");
var charterschool_component_1 = require("../shared/reportcontrols/charterschool.component");
var c197_component_1 = require("../shared/reportcontrols/c197.component");
var c198_component_1 = require("../shared/reportcontrols/c198.component");
var c132_component_1 = require("../shared/reportcontrols/c132.component");
var c199_component_1 = require("../shared/reportcontrols/c199.component");
var c170_component_1 = require("../shared/reportcontrols/c170.component");
var c205_component_1 = require("../shared/reportcontrols/c205.component");
var c206_component_1 = require("../shared/reportcontrols/c206.component");
var c131_component_1 = require("../shared/reportcontrols/c131.component");
var c163_component_1 = require("../shared/reportcontrols/c163.component");
var c207_component_1 = require("../shared/reportcontrols/c207.component");
var c223_component_1 = require("../shared/reportcontrols/c223.component");
var yeartoyearchildcount_component_1 = require("../shared/reportcontrols/yeartoyearchildcount.component");
var yeartoyearenvironmentcount_component_1 = require("../shared/reportcontrols/yeartoyearenvironmentcount.component");
var yeartoyearexitcount_component_1 = require("../shared/reportcontrols/yeartoyearexitcount.component");
var leastudentsprofile_component_1 = require("../shared/reportcontrols/leastudentsprofile.component");
var yeartoyearremovalcount_component_1 = require("../shared/reportcontrols/yeartoyearremovalcount.component");
var c035_component_1 = require("../shared/reportcontrols/c035.component");
var reports_library_report_component_1 = require("./library/reports-library-report.component");
var yeartoyearprogress_component_1 = require("../shared/reportcontrols/yeartoyearprogress.component");
var yeartoyearattendance_component_1 = require("../shared/reportcontrols/yeartoyearattendance.component");
var reportdebuginformation_component_1 = require("../shared/reportcontrols/reportdebuginformation.component");
var ReportsModule = function () {
    var _classDecorators = [(0, core_1.NgModule)({
            imports: [
                shared_module_1.SharedModule,
                forms_1.FormsModule,
                forms_1.ReactiveFormsModule,
                reports_routing_module_1.ReportsRoutingModule
            ],
            declarations: [
                reports_component_1.ReportsComponent,
                reports_summary_component_1.ReportsSummaryComponent,
                reports_edfacts_component_1.ReportsEdfactsComponent,
                reports_sppapr_component_1.ReportsSppaprComponent,
                reports_library_component_1.ReportsLibraryComponent,
                report_component_1.ReportComponent,
                flexgrid_component_1.FlexGridComponent,
                pivotgrid_component_1.PivotGridComponent,
                indicator4a_component_1.Indicator4aComponent,
                indicator4b_component_1.Indicator4bComponent,
                studentcount_component_1.StudentCountComponent,
                exitspecialeducation_component_1.ExitSpecEdComponent,
                cohortgraduationrate_component_1.CohortGradRateComponent,
                studentfederalprogramsparticipation_component_1.FederalProgramsParticipationComponent,
                studentmultiplefederalprogramsparticipation_component_1.MultipleFederalProgramsParticipationComponent,
                disciplinaryremovals_component_1.DisciplinaryRemovalsComponent,
                stateassessmentsperformance_component_1.StateAssessmentsPerformanceComponent,
                edenvironmentdisabilitiesage3_5_component_1.EdEnvironmentDisabilitiesage3To5Component,
                edenvironmentdisabilitiesage6_21_component_1.EdEnvironmentDisabilitiesage6To21Component,
                gradesoffered_component_1.GradesOfferedComponent,
                c029_component_1.c029Component,
                ccdschool_component_1.CCDSchoolComponent,
                leafederalfund_component_1.LeaFederalFundComponent,
                earlycharter_component_1.EarlyCharterComponent,
                charterschool_component_1.CharterSchoolComponent,
                c197_component_1.C197Component,
                c198_component_1.C198Component,
                c132_component_1.C132Component,
                c170_component_1.C170Component,
                c205_component_1.C205Component,
                c206_component_1.C206Component,
                c131_component_1.C131Component,
                c163_component_1.C163Component,
                c207_component_1.C207Component,
                c223_component_1.C223Component,
                yeartoyearchildcount_component_1.YearToYearChildCountComponent,
                yeartoyearenvironmentcount_component_1.YearToYearEnvironmentCountComponent,
                yeartoyearexitcount_component_1.YearToYearExitCountComponent,
                c199_component_1.C199Component,
                leastudentsprofile_component_1.LeaStudentsProfileComponent,
                yeartoyearremovalcount_component_1.YearToYearRemovalCountComponent,
                c035_component_1.C035Component,
                reports_library_report_component_1.ReportsLibraryReportComponent,
                yeartoyearprogress_component_1.YeartoYearProgressComponent,
                yeartoyearattendance_component_1.YeartoYearAttendanceComponent,
                reportdebuginformation_component_1.ReportDebugInformationComponent
            ],
            exports: [
                report_component_1.ReportComponent,
                flexgrid_component_1.FlexGridComponent,
                pivotgrid_component_1.PivotGridComponent,
                indicator4a_component_1.Indicator4aComponent,
                indicator4b_component_1.Indicator4bComponent,
                studentcount_component_1.StudentCountComponent,
                exitspecialeducation_component_1.ExitSpecEdComponent,
                cohortgraduationrate_component_1.CohortGradRateComponent,
                studentfederalprogramsparticipation_component_1.FederalProgramsParticipationComponent,
                studentmultiplefederalprogramsparticipation_component_1.MultipleFederalProgramsParticipationComponent,
                disciplinaryremovals_component_1.DisciplinaryRemovalsComponent,
                stateassessmentsperformance_component_1.StateAssessmentsPerformanceComponent,
                edenvironmentdisabilitiesage3_5_component_1.EdEnvironmentDisabilitiesage3To5Component,
                edenvironmentdisabilitiesage6_21_component_1.EdEnvironmentDisabilitiesage6To21Component,
                gradesoffered_component_1.GradesOfferedComponent,
                c029_component_1.c029Component,
                ccdschool_component_1.CCDSchoolComponent,
                leafederalfund_component_1.LeaFederalFundComponent,
                earlycharter_component_1.EarlyCharterComponent,
                charterschool_component_1.CharterSchoolComponent,
                c197_component_1.C197Component,
                c198_component_1.C198Component,
                c132_component_1.C132Component,
                c170_component_1.C170Component,
                c205_component_1.C205Component,
                c206_component_1.C206Component,
                c131_component_1.C131Component,
                c163_component_1.C163Component,
                c207_component_1.C207Component,
                c223_component_1.C223Component,
                yeartoyearchildcount_component_1.YearToYearChildCountComponent,
                yeartoyearenvironmentcount_component_1.YearToYearEnvironmentCountComponent,
                yeartoyearexitcount_component_1.YearToYearExitCountComponent,
                c199_component_1.C199Component,
                leastudentsprofile_component_1.LeaStudentsProfileComponent,
                yeartoyearremovalcount_component_1.YearToYearRemovalCountComponent,
                c035_component_1.C035Component,
                yeartoyearprogress_component_1.YeartoYearProgressComponent,
                yeartoyearattendance_component_1.YeartoYearAttendanceComponent,
                reportdebuginformation_component_1.ReportDebugInformationComponent
            ]
        })];
    var _classDescriptor;
    var _classExtraInitializers = [];
    var _classThis;
    var ReportsModule = _classThis = /** @class */ (function () {
        function ReportsModule_1() {
        }
        return ReportsModule_1;
    }());
    __setFunctionName(_classThis, "ReportsModule");
    (function () {
        var _metadata = typeof Symbol === "function" && Symbol.metadata ? Object.create(null) : void 0;
        __esDecorate(null, _classDescriptor = { value: _classThis }, _classDecorators, { kind: "class", name: _classThis.name, metadata: _metadata }, null, _classExtraInitializers);
        ReportsModule = _classThis = _classDescriptor.value;
        if (_metadata) Object.defineProperty(_classThis, Symbol.metadata, { enumerable: true, configurable: true, writable: true, value: _metadata });
        __runInitializers(_classThis, _classExtraInitializers);
    })();
    return ReportsModule = _classThis;
}();
exports.ReportsModule = ReportsModule;
//# sourceMappingURL=reports.module.js.map