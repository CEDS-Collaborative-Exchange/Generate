import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { HttpClient, HttpErrorResponse, HttpResponse } from '@angular/common/http';
import { catchError, map, tap, throwError } from 'rxjs';
import { AppConfig } from '../../app.config';
import { UpdatePackage } from '../../models/app/update-package';
import { UpdateStatus } from '../../models/app/update-status';
import { BaseService } from '../base.service';

/**
 * Error from one of the update page's polling calls. Displays as the usual user-facing message,
 * but keeps the HTTP status so the page can tell "web is still offline" (0/502/503/504) apart
 * from "web is back but rejected the request" (e.g. 401 after a restart dropped the session).
 */
export class UpdateRequestError {
    constructor(public readonly message: string, public readonly status: number) { }

    toString(): string {
        return this.message;
    }

    /**
     * A server that answers an expired session with a redirect to the login page (instead of a 401)
     * hands the browser that page's HTML, which then fails to parse as JSON with a 200 status.
     * Report it as the 401 it really is.
     */
    static statusOf(error: HttpErrorResponse): number {
        const redirectedToLogin = error.url?.toLowerCase().includes('/account/login') ?? false;
        const unparsableSuccess = error.status >= 200 && error.status < 300;
        return redirectedToLogin || unparsableSuccess ? 401 : error.status;
    }
}

@Injectable()
export class GenerateUpdateService extends BaseService {

    constructor(private http: HttpClient) {
        super();
    }

    private _apiUrl = 'api/app/appupdate';

    /**
     * A server that answers an expired session with a redirect (instead of a 401) lands the browser
     * on /Account/Login, which returns an empty 200. That parses as a null body rather than an error,
     * so without this check the page would treat it as a successful, empty answer. Turn it into the
     * 401 it really is.
     */
    private bodyUnlessLoginRedirect = <T>(resp: HttpResponse<T>): T => {
        if (resp.url?.toLowerCase().includes('/account/login')) {
            throw new HttpErrorResponse({ status: 401, statusText: 'Unauthorized', url: resp.url });
        }
        return resp.body;
    };

    private handleUpdateError = (error: HttpErrorResponse) =>
        this.handleError(error).pipe(
            catchError(message => throwError(() => new UpdateRequestError(message, UpdateRequestError.statusOf(error))))
        );


    getStatus(): Observable<UpdateStatus> {

        let url = this._apiUrl + "/status";

        return this.http.get<UpdateStatus>(url, { observe: 'response' })
            .pipe(
                map(this.bodyUnlessLoginRedirect),
                tap(resp => {
                    this.log(`getStatus`);
                }),
                catchError(this.handleUpdateError)
            );

    }


    getPendingUpdates(): Observable<UpdatePackage[]> {

        let url = this._apiUrl + "/pending";


        return this.http.get<UpdatePackage[]>(url, { observe: 'response' })
            .pipe(
                map(this.bodyUnlessLoginRedirect),
                tap(resp => {
                    this.log(`getPendingUpdates`);
                }),
                catchError(this.handleUpdateError)
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
                map(this.bodyUnlessLoginRedirect),
                tap(resp => {
                    this.log(`getDownloadedUpdates`);
                }),
                catchError(this.handleUpdateError)
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
