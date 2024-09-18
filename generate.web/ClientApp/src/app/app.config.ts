import { Injectable } from '@angular/core';
import { environment } from '../environments/environment';
import { IAppConfig } from './models/app-config.model';
import { map, catchError } from 'rxjs/operators';

import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { throwError } from 'rxjs';

@Injectable()
export class AppConfig {

    static settings: IAppConfig;
    jsonFile: string = `assets/config/config.${environment.type}.json`;

    constructor(private http: HttpClient) { }

    loadAndSetValues() {

        return this.http.get(this.jsonFile)
            .subscribe(response => {
                AppConfig.settings = <IAppConfig>response;
            });
    }

    getConfig() {
        return this.http.get(this.jsonFile)
    }
}
