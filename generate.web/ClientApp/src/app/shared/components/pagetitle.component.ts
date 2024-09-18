import {Component, Input, AfterViewInit} from '@angular/core';

declare var componentHandler: any;

@Component({
    selector: 'generate-app-pagetitle',
    templateUrl: './pagetitle.component.html',
    styleUrls: ['./pagetitle.component.scss']
})
export class PageTitleComponent implements AfterViewInit {

    @Input() pagetitle: string;
    @Input() pagesubtitle: string;

    constructor() {
    }

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }

    
}
