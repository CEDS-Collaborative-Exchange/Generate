import { Component, Input, Output, EventEmitter } from '@angular/core';
import { Router, NavigationEnd, RouterLink } from '@angular/router';
import { UserService } from '../../../services/app/user.service';

@Component({
  selector: 'app-app-drawer',
  standalone: true,
  imports: [],
  templateUrl: './app-drawer.component.html',
  styleUrl: './app-drawer.component.css'
})
export class AppDrawerComponent {

    @Input() isDrawerOpen = false;
    @Output() close = new EventEmitter<void>();

    submenus = {
        resources: false,
        reports: false,
        settings: false
    };

    // Toggle submenu open/close
    toggleSubmenu(menu: 'resources' | 'reports' | 'settings') {
        this.submenus[menu] = !this.submenus[menu];
    }

    constructor(
        private _router: Router,
        private userService: UserService) { }

    gotoHome() { this._router.navigateByUrl('/'); }

    gotoAbout() { this._router.navigateByUrl('/about'); }

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
