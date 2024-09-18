import { HttpClient, HttpHeaders, HttpHandler, HttpErrorResponse } from '@angular/common/http';

import { Observable, of, throwError } from 'rxjs';

export abstract class BaseService {

    protected headers: HttpHeaders = new HttpHeaders();

    protected setHeaders() {
        this.headers = new HttpHeaders();
        this.headers = this.headers.set('Content-Type', 'application/json');
        this.headers = this.headers.set('Accept', 'application/json');

    }


    protected handleError(error: HttpErrorResponse) {
        if (error.error instanceof ErrorEvent) {
            // A client-side or network error occurred. Handle it accordingly.
            console.log('An error occurred:', error.error.message);
            console.error('An error occurred:', error.error.message);
        } else {
            // The backend returned an unsuccessful response code.
            // The response body may contain clues as to what went wrong,
            console.log(
                `Backend returned code ${error.status}, ` +
                `body was: ${error.error}`);
            console.error(
                `Backend returned code ${error.status}, ` +
                `body was: ${error.error}`);
        }
        // return an observable with a user-facing error message
        return throwError(
            'An unknown error has occurred in Generate. Close your browser and reopen it and try again.');
    };

    protected log(message: string) {
        //console.log(message);
    }
}
