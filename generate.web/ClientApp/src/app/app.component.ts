import { Component, AfterViewInit, ViewEncapsulation, OnInit } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { Title } from '@angular/platform-browser';
import { UserService } from './services/app/user.service';
import { IAppConfig } from './models/app-config.model';
import { AppConfig } from './app.config';



declare var componentHandler: any;

@Component({
    selector: 'app',
    templateUrl: './app.component.html',
    styleUrls: [ './app.component.scss' ],
    providers: [Title],
    encapsulation: ViewEncapsulation.None
})



export class AppComponent implements AfterViewInit, OnInit {

    constructor(
        private _router: Router,
        private _titleService: Title,
        private userService: UserService,
        private appConfig: AppConfig) { }

    ngOnInit() {

        this._router.events.subscribe(event => {

            if(event instanceof NavigationEnd) {

                this.appConfig.getConfig().subscribe((res: IAppConfig) => {

                    if (res.authType.toUpperCase() === 'OAUTH') {

                        if (this.userService.isLoggedIn && event.urlAfterRedirects != '/' && event.urlAfterRedirects.indexOf('login') <= 0) {
                            window.localStorage.setItem('lastUrl', event.urlAfterRedirects)
                        }
                    } else {
                        if (this.userService.isLoggedIn && event.urlAfterRedirects != '/') {
                            window.localStorage.setItem('lastUrl', event.urlAfterRedirects)
                        }
                    }

                })
                
            }
        })
    }

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
       /* componentHandler.upgradeDom();*/

        //if (window['componentHandler']) {
        //    window['componentHandler'].upgradeDom();
        //}
    }
    
}
