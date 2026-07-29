import { Component, Input, AfterViewInit, OnChanges, SimpleChanges } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { Router } from '@angular/router';

declare let componentHandler: any;

@Component({
    selector: 'generate-app-breadcrumbs',
    templateUrl: './breadcrumbs.component.html',
    styleUrls: ['./breadcrumbs.component.scss'],
    standalone: false
})
export class BreadcrumbsComponent implements AfterViewInit, OnChanges {

    @Input() breadcrumbs!: string;

    breadcrumbItems: { label: string; route?: string; isCurrent: boolean }[] = [];

    private readonly routeMap: Record<string, string> = {
        'About': '/about',
        'Standard Reports > EDFacts Submission Reports': '/reports/edfacts',
        'Standard Reports > Reports Library': '/reports/library',
        'Data Population Summary': '/reports/summary',
        'Resources': '/resources/tutorials',
        'Resources > Tutorials': '/resources/tutorials',
        'Settings': '/settings/toggle',
        'Settings > Toggle': '/settings/toggle',
        'Settings > Toggle Assessments': '/settings/toggle/assessment',
        'Settings > Update': '/settings/update',
        'Settings > Data Migrations': '/settings/datamigration',
    };

    constructor(private readonly _titleService: Title, private readonly _router: Router) {
    }

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();

        this.updateBreadcrumbsAndTitle();
    }

    ngOnChanges(changes: SimpleChanges) {
        if (changes['breadcrumbs']) {
            this.updateBreadcrumbsAndTitle();
        }
    }

    private updateBreadcrumbsAndTitle() {
        const breadcrumbPath = this.getDisplayPath(this.breadcrumbs);
        const segments = breadcrumbPath
            .split('>')
            .map(s => s.trim())
            .filter(s => s.length > 0);

        this.breadcrumbItems = [
            {
                label: 'Home',
                route: segments.length > 0 ? '/' : undefined,
                isCurrent: segments.length === 0
            }
        ];

        for (let i = 0; i < segments.length; i++) {
            const currentPath = segments.slice(0, i + 1).join(' > ');
            const isCurrent = i === segments.length - 1;

            this.breadcrumbItems.push({
                label: segments[i],
                route: !isCurrent ? this.routeMap[currentPath] : undefined,
                isCurrent: isCurrent
            });
        }

        let pageTitle = 'Generate';

        if (breadcrumbPath.length > 0) {
            pageTitle += ' - ' + breadcrumbPath;
        }

        this._titleService.setTitle(pageTitle);
    }

    navigateTo(route: string) {
        if (!route) {
            return;
        }

        this._router.navigateByUrl(route);
    }

    private getDisplayPath(value: string) {
        if (!value) {
            return '';
        }

        if (value === 'ReportsEdFacts') {
            return 'Standard Reports > EDFacts Submission Reports';
        }

        return value;
    }
}
