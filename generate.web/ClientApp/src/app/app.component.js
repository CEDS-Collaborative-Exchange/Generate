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
exports.AppComponent = void 0;
var core_1 = require("@angular/core");
var router_1 = require("@angular/router");
var platform_browser_1 = require("@angular/platform-browser");
var user_service_1 = require("./services/app/user.service");
var AppComponent = function () {
    var _classDecorators = [(0, core_1.Component)({
            selector: 'app',
            templateUrl: './app.component.html',
            styleUrls: ['./app.component.scss'],
            providers: [platform_browser_1.Title, user_service_1.UserService],
            encapsulation: core_1.ViewEncapsulation.None
        })];
    var _classDescriptor;
    var _classExtraInitializers = [];
    var _classThis;
    var AppComponent = _classThis = /** @class */ (function () {
        //isDrawerOpen = false;
        //openDrawer() {
        //    this.isDrawerOpen = true;
        //}
        //closeDrawer() {
        //    this.isDrawerOpen = false;
        //}
        function AppComponent_1(_router, _titleService, userService, appConfig) {
            this._router = _router;
            this._titleService = _titleService;
            this.userService = userService;
            this.appConfig = appConfig;
            this.submenus = {
                resources: false,
                reports: false,
                settings: false
            };
        }
        // Toggle submenu open/close
        AppComponent_1.prototype.toggleSubmenu = function (menu) {
            this.submenus[menu] = !this.submenus[menu];
        };
        AppComponent_1.prototype.ngOnInit = function () {
            var _this = this;
            this._router.events.subscribe(function (event) {
                if (event instanceof router_1.NavigationEnd) {
                    _this.appConfig.getConfig().subscribe(function (res) {
                        if (res.authType.toUpperCase() === 'OAUTH') {
                            if (_this.userService.isLoggedIn && event.urlAfterRedirects != '/' && event.urlAfterRedirects.indexOf('login') <= 0) {
                                window.localStorage.setItem('lastUrl', event.urlAfterRedirects);
                            }
                        }
                        else {
                            if (_this.userService.isLoggedIn && event.urlAfterRedirects != '/') {
                                window.localStorage.setItem('lastUrl', event.urlAfterRedirects);
                            }
                        }
                    });
                }
            });
        };
        AppComponent_1.prototype.ngAfterViewInit = function () {
            componentHandler.upgradeDom();
        };
        AppComponent_1.prototype.gotoSummary = function () {
            if (this.userService.isLoggedIn()) {
                this._router.navigateByUrl('/reports/summary');
            }
            else {
                var snackbarContainer = document.querySelector('#generate-app__message');
                var data = { message: 'You must be logged in to access this area of Generate.' };
                snackbarContainer['MaterialSnackbar'].showSnackbar(data);
            }
            return false;
        };
        AppComponent_1.prototype.gotoReportsEdFacts = function () {
            if (this.userService.isLoggedIn()) {
                this._router.navigate(['/reports/edfacts']);
            }
            else {
                var snackbarContainer = document.querySelector('#generate-app__message');
                var data = { message: 'You must be logged in to access this area of Generate.' };
                snackbarContainer['MaterialSnackbar'].showSnackbar(data);
            }
            return false;
        };
        AppComponent_1.prototype.gotoReportsSppApr = function () {
            if (this.userService.isLoggedIn()) {
                this._router.navigate(['/reports/sppapr']);
            }
            else {
                var snackbarContainer = document.querySelector('#generate-app__message');
                var data = { message: 'You must be logged in to access this area of Generate.' };
                snackbarContainer['MaterialSnackbar'].showSnackbar(data);
            }
            return false;
        };
        AppComponent_1.prototype.gotoReportsLibrary = function () {
            if (this.userService.isLoggedIn()) {
                this._router.navigate(['/reports/library']);
            }
            else {
                var snackbarContainer = document.querySelector('#generate-app__message');
                var data = { message: 'You must be logged in to access this area of Generate.' };
                snackbarContainer['MaterialSnackbar'].showSnackbar(data);
            }
            return false;
        };
        return AppComponent_1;
    }());
    __setFunctionName(_classThis, "AppComponent");
    (function () {
        var _metadata = typeof Symbol === "function" && Symbol.metadata ? Object.create(null) : void 0;
        __esDecorate(null, _classDescriptor = { value: _classThis }, _classDecorators, { kind: "class", name: _classThis.name, metadata: _metadata }, null, _classExtraInitializers);
        AppComponent = _classThis = _classDescriptor.value;
        if (_metadata) Object.defineProperty(_classThis, Symbol.metadata, { enumerable: true, configurable: true, writable: true, value: _metadata });
        __runInitializers(_classThis, _classExtraInitializers);
    })();
    return AppComponent = _classThis;
}();
exports.AppComponent = AppComponent;
//# sourceMappingURL=app.component.js.map