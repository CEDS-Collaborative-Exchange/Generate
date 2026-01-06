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
exports.AppHeaderComponent = void 0;
var core_1 = require("@angular/core");
var user_service_1 = require("../../services/app/user.service");
var AppHeaderComponent = function () {
    var _classDecorators = [(0, core_1.Component)({
            selector: 'generate-app-header',
            templateUrl: './app-header.component.html',
            styleUrls: ['./app-header.component.scss'],
            providers: [
                user_service_1.UserService
            ]
        })];
    var _classDescriptor;
    var _classExtraInitializers = [];
    var _classThis;
    var _isDrawerOpen_decorators;
    var _isDrawerOpen_initializers = [];
    var _isDrawerOpen_extraInitializers = [];
    var _close_decorators;
    var _close_initializers = [];
    var _close_extraInitializers = [];
    var AppHeaderComponent = _classThis = /** @class */ (function () {
        function AppHeaderComponent_1(_router, _UserService) {
            this._router = _router;
            this._UserService = _UserService;
            this.isDrawerOpen = __runInitializers(this, _isDrawerOpen_initializers, false);
            this.close = (__runInitializers(this, _isDrawerOpen_extraInitializers), __runInitializers(this, _close_initializers, new core_1.EventEmitter()));
            this.submenus = (__runInitializers(this, _close_extraInitializers), {
                resources: false,
                reports: false,
                settings: false
            });
            this.userService = _UserService;
        }
        // Toggle submenu open/close
        AppHeaderComponent_1.prototype.toggleSubmenu = function (menu) {
            this.submenus[menu] = !this.submenus[menu];
        };
        AppHeaderComponent_1.prototype.ngAfterViewInit = function () {
            componentHandler.upgradeAllRegistered();
        };
        /*isDrawerOpen = false;*/
        AppHeaderComponent_1.prototype.openDrawer = function () {
            this.isDrawerOpen = true;
        };
        AppHeaderComponent_1.prototype.closeDrawer = function () {
            this.isDrawerOpen = false;
        };
        AppHeaderComponent_1.prototype.onClickMenuItem = function () {
            return false;
        };
        AppHeaderComponent_1.prototype.gotoSummary = function () {
            if (this._UserService.isLoggedIn()) {
                this._router.navigateByUrl('/reports/summary');
            }
            else {
                var snackbarContainer = document.querySelector('#generate-app__message');
                var data = { message: 'You must be logged in to access this area of Generate.' };
                snackbarContainer['MaterialSnackbar'].showSnackbar(data);
            }
            return false;
        };
        AppHeaderComponent_1.prototype.gotoReportsEdFacts = function () {
            if (this._UserService.isLoggedIn()) {
                this._router.navigate(['/reports/edfacts']);
            }
            else {
                var snackbarContainer = document.querySelector('#generate-app__message');
                var data = { message: 'You must be logged in to access this area of Generate.' };
                snackbarContainer['MaterialSnackbar'].showSnackbar(data);
            }
            return false;
        };
        AppHeaderComponent_1.prototype.gotoReportsSppApr = function () {
            if (this._UserService.isLoggedIn()) {
                this._router.navigate(['/reports/sppapr']);
            }
            else {
                var snackbarContainer = document.querySelector('#generate-app__message');
                var data = { message: 'You must be logged in to access this area of Generate.' };
                snackbarContainer['MaterialSnackbar'].showSnackbar(data);
            }
            return false;
        };
        AppHeaderComponent_1.prototype.gotoReportsLibrary = function () {
            if (this._UserService.isLoggedIn()) {
                this._router.navigate(['/reports/library']);
            }
            else {
                var snackbarContainer = document.querySelector('#generate-app__message');
                var data = { message: 'You must be logged in to access this area of Generate.' };
                snackbarContainer['MaterialSnackbar'].showSnackbar(data);
            }
            return false;
        };
        return AppHeaderComponent_1;
    }());
    __setFunctionName(_classThis, "AppHeaderComponent");
    (function () {
        var _metadata = typeof Symbol === "function" && Symbol.metadata ? Object.create(null) : void 0;
        _isDrawerOpen_decorators = [(0, core_1.Input)()];
        _close_decorators = [(0, core_1.Output)()];
        __esDecorate(null, null, _isDrawerOpen_decorators, { kind: "field", name: "isDrawerOpen", static: false, private: false, access: { has: function (obj) { return "isDrawerOpen" in obj; }, get: function (obj) { return obj.isDrawerOpen; }, set: function (obj, value) { obj.isDrawerOpen = value; } }, metadata: _metadata }, _isDrawerOpen_initializers, _isDrawerOpen_extraInitializers);
        __esDecorate(null, null, _close_decorators, { kind: "field", name: "close", static: false, private: false, access: { has: function (obj) { return "close" in obj; }, get: function (obj) { return obj.close; }, set: function (obj, value) { obj.close = value; } }, metadata: _metadata }, _close_initializers, _close_extraInitializers);
        __esDecorate(null, _classDescriptor = { value: _classThis }, _classDecorators, { kind: "class", name: _classThis.name, metadata: _metadata }, null, _classExtraInitializers);
        AppHeaderComponent = _classThis = _classDescriptor.value;
        if (_metadata) Object.defineProperty(_classThis, Symbol.metadata, { enumerable: true, configurable: true, writable: true, value: _metadata });
        __runInitializers(_classThis, _classExtraInitializers);
    })();
    return AppHeaderComponent = _classThis;
}();
exports.AppHeaderComponent = AppHeaderComponent;
//# sourceMappingURL=app-header.component.js.map