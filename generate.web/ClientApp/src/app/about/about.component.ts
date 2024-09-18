import {Component, AfterViewInit} from '@angular/core';
import { AppConfig } from '../app.config';
import { IAppConfig } from '../models/app-config.model';

declare var componentHandler: any;

@Component({
    selector: 'generate-app-about',
    templateUrl: './about.component.html',
    styleUrls: ['./about.component.scss']
})
export class AboutComponent implements AfterViewInit {

    environmentName: string;
    buildVersion: string;

    constructor(private appConfig: AppConfig) {

        this.appConfig.getConfig().subscribe((res: IAppConfig) => {
            this.environmentName = res.env.name;
            this.buildVersion = res.env.version;
        });
    }


    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }
}
