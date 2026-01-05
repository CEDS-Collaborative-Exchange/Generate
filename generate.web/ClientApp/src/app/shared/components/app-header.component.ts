import { Component, AfterViewInit } from '@angular/core';
import { Router } from '@angular/router';
import { UserService } from '../../services/app/user.service';

declare var componentHandler: any;

@Component({
    selector: 'generate-app-header',
    templateUrl: './app-header.component.html',
    styleUrls: ['./app-header.component.scss'],
    providers: [
        UserService
    ]
})



export class AppHeaderComponent implements AfterViewInit {

    public userService: UserService;

    constructor(
        private _router: Router,
        private _UserService: UserService) {

        this.userService = _UserService;
    }

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();  
    }

    isDrawerOpen = false;

    openDrawer() {
        this.isDrawerOpen = true;
    }

    closeDrawer() {
        this.isDrawerOpen = false;
    }

    onClickMenuItem() {
        return false;
    }

    gotoSummary() {
        if (this._UserService.isLoggedIn()) {
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

        if (this._UserService.isLoggedIn()) {
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
        if (this._UserService.isLoggedIn()) {
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
        if (this._UserService.isLoggedIn()) {
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
