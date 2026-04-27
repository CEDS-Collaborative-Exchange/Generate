import { Component, AfterViewInit, ViewEncapsulation, OnInit, HostListener } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { Title } from '@angular/platform-browser';
import { UserService } from './services/app/user.service';
import { IAppConfig } from './models/app-config.model';
import { AppConfig } from './app.config';



declare var componentHandler: any;

@Component({
    selector: 'app',
    templateUrl: './app.component.html',
    styleUrls: ['./app.component.scss'],
    providers: [Title, UserService],
    encapsulation: ViewEncapsulation.None,
    standalone: false
})



export class AppComponent implements AfterViewInit, OnInit {

    isDrawerOpen = false;

    toggleDrawer() {
        this.isDrawerOpen = !this.isDrawerOpen;
    }

    closeDrawer() {
        this.isDrawerOpen = false;
    }

    // Auto-close the drawer when the viewport is wider than 1100px
    // (i.e. the user zooms back out below ~175% on a 1920px display)
    @HostListener('window:resize')
    onResize() {
        if (window.innerWidth > 1100) {
            this.isDrawerOpen = false;
        }
    }

    constructor(
        private _router: Router,
        private _titleService: Title,
        public userService: UserService,
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
        componentHandler.upgradeDom();
    }

    gotoSummary() {
        if (this.userService.isLoggedIn()) {
            this._router.navigateByUrl('/reports/summary');
        }
        else {
            let snackbarContainer = document.querySelector('#generate-app__message');
            let data = { message: 'You must be logged in to access this area of Generate.' };
            snackbarContainer['MaterialSnackbar'].showSnackbar(data);
        }
        return false;
    }

    gotoReportsEdFacts() {

        if (this.userService.isLoggedIn()) {
            this._router.navigate(['/reports/edfacts']);
        }
        else {
            let snackbarContainer = document.querySelector('#generate-app__message');
            let data = { message: 'You must be logged in to access this area of Generate.' };
            snackbarContainer['MaterialSnackbar'].showSnackbar(data);
        }
        return false;
    }

    gotoReportsSppApr() {
        if (this.userService.isLoggedIn()) {
            this._router.navigate(['/reports/sppapr']);
        }
        else {
            let snackbarContainer = document.querySelector('#generate-app__message');
            let data = { message: 'You must be logged in to access this area of Generate.' };
            snackbarContainer['MaterialSnackbar'].showSnackbar(data);
        }

        return false;
    }

    gotoReportsLibrary() {
        if (this.userService.isLoggedIn()) {
            this._router.navigate(['/reports/library']);
        }
        else {
            let snackbarContainer = document.querySelector('#generate-app__message');
            let data = { message: 'You must be logged in to access this area of Generate.' };
            snackbarContainer['MaterialSnackbar'].showSnackbar(data);
        }

        return false;
    }
    
}
