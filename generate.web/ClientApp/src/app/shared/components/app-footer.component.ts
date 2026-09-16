import { Component, AfterViewInit } from '@angular/core';

declare var componentHandler: any;

@Component({
    selector: 'generate-app-footer',
    templateUrl: './app-footer.component.html',
    styleUrls: ['./app-footer.component.scss'],
    standalone: false
})
    
export class AppFooterComponent implements AfterViewInit {

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }
    
}