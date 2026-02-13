import {Component, AfterViewInit} from '@angular/core';
import {Router} from '@angular/router';

import { UserService } from '../services/app/user.service';


declare var componentHandler: any;

@Component({
    selector: 'generate-app-home',
    templateUrl: './home.component.html',
    styleUrls: ['./home.component.scss'],
    providers: [UserService]
})

export class HomeComponent implements AfterViewInit {
    public title = 'Home';

    public userService: UserService;

    constructor(
        private _router: Router,
        private _UserService: UserService
    ) {

        this.userService = _UserService;
    }

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }

    onClickMenuItem() {
        return false;
    }

    gotoReportsEdFacts(event?: Event) {
        if (event) event.preventDefault();

        if (this._UserService.isLoggedIn()) {
            this._router.navigate(['/reports/edfacts']);
        }
        else {
            let snackbarContainer = document.querySelector('#generate-app__message');
            if (snackbarContainer) {
                let data = { message: 'You must be logged in to access this area of Generate.' };
                snackbarContainer['MaterialSnackbar'].showSnackbar(data);
            }
        }
        return false;
    }

    gotoReportsSppApr(event?: Event) {
        if (event) event.preventDefault();

        if (this._UserService.isLoggedIn()) {
            this._router.navigate(['/reports/sppapr']);
        }
        else {
            let snackbarContainer = document.querySelector('#generate-app__message');
            if (snackbarContainer) {
                let data = { message: 'You must be logged in to access this area of Generate.' };
                snackbarContainer['MaterialSnackbar'].showSnackbar(data);
            }
        }

        return false;
    }

    gotoReportsLibrary(event?: Event) {
        if (event) event.preventDefault();

        if (this._UserService.isLoggedIn()) {
            this._router.navigate(['/reports/library']);
        }
        else {
            let snackbarContainer = document.querySelector('#generate-app__message');
            if (snackbarContainer) {
                let data = { message: 'You must be logged in to access this area of Generate.' };
                snackbarContainer['MaterialSnackbar'].showSnackbar(data);
            }
        }

        return false;
    }

    gotoSummary(event?: Event) {
        if (event) event.preventDefault();

        if (this._UserService.isLoggedIn()) {
            this._router.navigateByUrl('/reports/summary');
        }
        else {
            let snackbarContainer = document.querySelector('#generate-app__message');
            if (snackbarContainer) {
                let data = { message: 'You must be logged in to access this area of Generate.' };
                snackbarContainer['MaterialSnackbar'].showSnackbar(data);
            }
        }
        return false;
    }

    gotoResourcesTutorials() {
        this._router.navigate(['/resources/tutorials']);
        return false;
    }

     gotoAboutPage(event?: Event) {
        if (event) event.preventDefault();
        this._router.navigate(['/about']);
        return false;
    }
}

