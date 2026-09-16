import { CommonModule } from '@angular/common';
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { Router, RouterLinkActive } from '@angular/router';
import { SharedModule } from '../../shared.module';
import { UserService } from '../../../services/app/user.service';

@Component({
    selector: 'app-app-drawer',
    imports: [CommonModule, RouterLinkActive, SharedModule],
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
        public userService: UserService) { }

    gotoHome() { 
        this._router.navigateByUrl('/');
        this.close.emit();
    }

    gotoAbout() { 
        this._router.navigateByUrl('/about');
        this.close.emit();
    }

    gotoSummary() {
        if (this.userService.isLoggedIn()) {
            this._router.navigateByUrl('/reports/summary');
            this.close.emit();
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
            this.close.emit();
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
            this.close.emit();
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
            this.close.emit();
        }
        else {
            let snackbarContainer = document.querySelector('#generate-app__message');
            let data = { message: 'You must be logged in to access this area of Generate.' };
            snackbarContainer['MaterialSnackbar'].showSnackbar(data);
        }

        return false;
    }

    gotoSettingsToggle() {
        this._router.navigate(['/settings/toggle']);
        this.close.emit();
        return false;
    }

    gotoSettingsDataMigration() {
        this._router.navigate(['/settings/datamigration']);
        this.close.emit();
        return false;
    }

    gotoSettingsUpdate() {
        this._router.navigate(['/settings/update']);
        this.close.emit();
        return false;
    }

    gotoSettingsMetadata() {
        this._router.navigate(['/settings/metadata']);
        this.close.emit();
        return false;
    }
}
