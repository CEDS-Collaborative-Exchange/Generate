import {Component, Input, AfterViewInit} from '@angular/core';
import { Title } from '@angular/platform-browser';

declare var componentHandler: any;

@Component({
    selector: 'generate-app-breadcrumbs',
    templateUrl: './breadcrumbs.component.html',
    styleUrls: ['./breadcrumbs.component.scss']
})
export class BreadcrumbsComponent implements AfterViewInit {

    @Input() breadcrumbs: string;

    constructor(private _titleService: Title) {
    }

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();

        let pageTitle = 'Generate';
               
        switch (this.breadcrumbs) {
            case 'ReportsEdFacts':
                pageTitle += ' - Standard Reports > EDFacts Submission Reports';
                break;
            default:
                pageTitle += ' - ' + this.breadcrumbs;
                break;
        }
        this._titleService.setTitle(pageTitle);
    }

    
}
