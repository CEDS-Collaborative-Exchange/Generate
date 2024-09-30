import {Component, AfterViewInit} from '@angular/core';
import { AppConfig } from '../app.config';
import { IAppConfig } from '../models/app-config.model';
import { AboutServ } from '../services/app/About.service';


declare var componentHandler: any;

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
        console.log("calling method : getDBvers()");

        this._aboutServ.getDBvers()
            .subscribe(resp => {
                console.log("=====start About Component=====");
                console.log(resp);
                this.buildVersion = resp;
                console.log("=====About Component=====");
            });

        this.appConfig.getConfig().subscribe((res: IAppConfig) => {
            this.environmentName = res.env.name;
            //this.buildVersion = res.env.version;
        });

    }


    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }
}
