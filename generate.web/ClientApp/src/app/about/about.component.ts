import {Component, AfterViewInit} from '@angular/core';
import { AppConfig } from '../app.config';
import { IAppConfig } from '../models/app-config.model';
import { AboutServ } from '../services/app/About.service';


declare let componentHandler: any;

@Component({
    selector: 'generate-app-about',
    templateUrl: './about.component.html',
    styleUrls: ['./about.component.scss'],
    providers: [AboutServ]
})
export class AboutComponent implements AfterViewInit {

    environmentName: string;
    buildVersion: string;
    _aboutServ: AboutServ;

    constructor(private appConfig: AppConfig, private _abtserv: AboutServ) {

        this._aboutServ = _abtserv;

        this._aboutServ.getDBvers()
            .subscribe(resp => {
                this.buildVersion = resp;
            });

        this.appConfig.getConfig().subscribe((res: IAppConfig) => {
            this.environmentName = res.env.name;
        });

    }


    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }
}
