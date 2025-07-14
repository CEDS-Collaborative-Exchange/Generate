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
exports.AppModule = void 0;
exports.initializeApp = initializeApp;
exports.MSALInstanceFactory = MSALInstanceFactory;
var core_1 = require("@angular/core");
var platform_browser_1 = require("@angular/platform-browser");
var forms_1 = require("@angular/forms");
var http_1 = require("@angular/common/http");
var msal_angular_1 = require("@azure/msal-angular");
var msal_browser_1 = require("@azure/msal-browser");
var core_2 = require("@angular/core");
var app_config_1 = require("./app.config");
var animations_1 = require("@angular/platform-browser/animations");
/* Container */
var app_component_1 = require("./app.component");
/* Components */
var home_component_1 = require("./home/home.component");
var about_component_1 = require("./about/about.component");
var app_not_found_component_1 = require("./shared/components/app-not-found.component");
var app_header_component_1 = require("./shared/components/app-header.component");
var app_footer_component_1 = require("./shared/components/app-footer.component");
/* Shared Modules */
var app_routing_module_1 = require("./app-routing.module");
var shared_module_1 = require("./shared/shared.module");
/* Pagination Module */
var paginator_1 = require("@angular/material/paginator");
var HttpConfigInterceptor_1 = require("./shared/interceptors/HttpConfigInterceptor");
function initializeApp(appConfig) {
    return function () {
        appConfig.loadAndSetValues();
    };
}
function MSALInstanceFactory() {
    var clientApp = null;
    this.appConfig.getConfig().subscribe(function (res) {
        if (res.authType.toUpperCase() === 'OAUTH') {
            clientApp = new msal_browser_1.PublicClientApplication({
                auth: {
                    clientId: res.clientId,
                    authority: res.authority,
                    redirectUri: res.redirectUri
                },
                cache: {
                    cacheLocation: 'localStorage',
                    storeAuthStateInCookie: true
                },
                system: {
                    allowNativeBroker: false
                }
            });
        }
    });
    return clientApp;
}
var AppModule = function () {
    var _classDecorators = [(0, core_1.NgModule)({
            imports: [
                platform_browser_1.BrowserModule,
                http_1.HttpClientModule,
                forms_1.FormsModule,
                animations_1.BrowserAnimationsModule,
                app_routing_module_1.AppRoutingModule,
                shared_module_1.SharedModule,
                paginator_1.MatPaginatorModule,
                msal_angular_1.MsalModule
            ],
            declarations: [
                home_component_1.HomeComponent,
                about_component_1.AboutComponent,
                app_not_found_component_1.AppNotFoundComponent,
                app_component_1.AppComponent,
                app_header_component_1.AppHeaderComponent,
                app_footer_component_1.AppFooterComponent
            ],
            providers: [
                app_config_1.AppConfig,
                {
                    provide: core_2.APP_INITIALIZER,
                    useFactory: initializeApp,
                    deps: [app_config_1.AppConfig], multi: true
                },
                { provide: http_1.HTTP_INTERCEPTORS, useClass: HttpConfigInterceptor_1.HttpConfigInterceptor, multi: true },
                {
                    provide: msal_angular_1.MSAL_INSTANCE,
                    useFactory: MSALInstanceFactory
                },
                msal_angular_1.MsalService
            ],
            bootstrap: [
                app_component_1.AppComponent
            ]
        })];
    var _classDescriptor;
    var _classExtraInitializers = [];
    var _classThis;
    var AppModule = _classThis = /** @class */ (function () {
        function AppModule_1() {
        }
        return AppModule_1;
    }());
    __setFunctionName(_classThis, "AppModule");
    (function () {
        var _metadata = typeof Symbol === "function" && Symbol.metadata ? Object.create(null) : void 0;
        __esDecorate(null, _classDescriptor = { value: _classThis }, _classDecorators, { kind: "class", name: _classThis.name, metadata: _metadata }, null, _classExtraInitializers);
        AppModule = _classThis = _classDescriptor.value;
        if (_metadata) Object.defineProperty(_classThis, Symbol.metadata, { enumerable: true, configurable: true, writable: true, value: _metadata });
        __runInitializers(_classThis, _classExtraInitializers);
    })();
    return AppModule = _classThis;
}();
exports.AppModule = AppModule;
//# sourceMappingURL=app.module.js.map