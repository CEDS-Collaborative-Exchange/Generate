import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { catchError, map, tap } from 'rxjs';
import { AppConfig } from '../../app.config';
import { UpdatePackage } from '../../models/app/update-package';
import { UpdateStatus } from '../../models/app/update-status';
import { BaseService } from '../base.service';

@Injectable()
export class GenerateUpdateService extends BaseService {

    constructor(private http: HttpClient) {
        super();
    }

    private _apiUrl = 'api/app/appupdate';


    getStatus(): Observable<UpdateStatus> {

        let url = this._apiUrl + "/status";

        return this.http.get<UpdateStatus>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getStatus`);
                }),
                catchError(this.handleError)
            );

    }


    getPendingUpdates(): Observable<UpdatePackage[]> {

        let url = this._apiUrl + "/pending";


        return this.http.get<UpdatePackage[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getPendingUpdates`);
                }),
                catchError(this.handleError)
            );


    }

    downloadUpdates() {

        return this.http.post(this._apiUrl + '/download', null, { headers: this.headers }).pipe(
            tap((data) => {
                this.log(`downloadUpdates`)
            }),
            catchError(this.handleError)
        );

    }

    getDownloadedUpdates(): Observable<UpdatePackage[]> {
        let url = this._apiUrl;

        return this.http.get<UpdatePackage[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getDownloadedUpdates`);
                }),
                catchError(this.handleError)
            );


    }

    applyDownloadedUpdates() {

        return this.http.put(this._apiUrl + '/execute', null, { headers: this.headers }).pipe(
            tap((data) => {
                this.log(`applyDownloadedUpdates`)
            }),
            catchError(this.handleError)
        );
    }

    clearDownloadedUpdates() {

        return this.http.post(this._apiUrl + '/clear', null, { headers: this.headers }).pipe(
            tap((data) => {
                this.log(`clearDownloadedUpdates`)
            }),
            catchError(this.handleError)
        );

    }
       

}
