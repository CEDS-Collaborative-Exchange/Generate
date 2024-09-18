import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';

import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { MsalModule, MsalService, MSAL_INSTANCE } from '@azure/msal-angular';
import { IPublicClientApplication, PublicClientApplication } from '@azure/msal-browser';

import { APP_INITIALIZER } from '@angular/core';
import { AppConfig } from './app.config';

import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

/* Container */
import { AppComponent } from './app.component';

/* Components */
import { HomeComponent } from './home/home.component';
import { AboutComponent } from './about/about.component';
import { AppNotFoundComponent } from './shared/components/app-not-found.component';
import { AppHeaderComponent } from './shared/components/app-header.component';
import { AppFooterComponent } from './shared/components/app-footer.component';


/* Shared Modules */
import { AppRoutingModule  } from './app-routing.module';
import { SharedModule } from './shared/shared.module';


/* Pagination Module */
import { MatPaginatorModule } from '@angular/material/paginator';

import { IAppConfig } from './models/app-config.model';
import { HttpConfigInterceptor } from './shared/interceptors/HttpConfigInterceptor';

export function initializeApp(appConfig: AppConfig) {
    return () => {
        appConfig.loadAndSetValues();
    }
}


export function MSALInstanceFactory(): IPublicClientApplication {

    var clientApp = null;

    this.appConfig.getConfig().subscribe((res: IAppConfig) => {

        if (res.authType.toUpperCase() === 'OAUTH') {

            clientApp = new PublicClientApplication({
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

    })

    return clientApp;
}

@NgModule({
        imports: [
            BrowserModule,
            HttpClientModule,
            FormsModule,
            BrowserAnimationsModule,
            AppRoutingModule,
            SharedModule,
            MatPaginatorModule,
            MsalModule
        ],
        declarations: [
            HomeComponent,
            AboutComponent,
            AppNotFoundComponent,
            AppComponent,
            AppHeaderComponent,
            AppFooterComponent
        ],
        providers: [
            AppConfig,
            {
                provide: APP_INITIALIZER,
                useFactory: initializeApp,
                deps: [AppConfig], multi: true
            },
            { provide: HTTP_INTERCEPTORS, useClass: HttpConfigInterceptor, multi: true },
            {
                provide: MSAL_INSTANCE,
                useFactory: MSALInstanceFactory
            },
            MsalService
        ],
        bootstrap: [
            AppComponent
        ]
    })
export class AppModule { }

