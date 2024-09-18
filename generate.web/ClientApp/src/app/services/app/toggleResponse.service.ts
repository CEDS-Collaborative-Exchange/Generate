import {Injectable}     from '@angular/core';
import {ToggleResponse} from '../../models/app/toggleResponse';
import {Observable}     from 'rxjs';
import { catchError, map, tap } from 'rxjs';
import { BaseService } from '../base.service';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';

@Injectable()
export class ToggleResponseService extends BaseService {

    private _apiUrl = 'api/app/toggleresponses';

    constructor(private http: HttpClient) {
        super();
    }


    getAll(): Observable<ToggleResponse[]> {

        return this.http.get<ToggleResponse[]>(this._apiUrl, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getAll`);
                }),
                catchError(this.handleError)
            );

    }

    saveResponses(data: ToggleResponse[]) {

        return this.http.post<ToggleResponse[]>(this._apiUrl + '/saveresponses', data, { headers: this.headers }).pipe(
            tap((data: ToggleResponse[]) => {
                this.log(`saveResponses`)
            }),
            catchError(this.handleError)
        );

    }

    updateResponses(data: ToggleResponse[]) {

        return this.http.put<ToggleResponse[]>(this._apiUrl + '/updateresponses', data, { headers: this.headers }).pipe(
            tap((data: ToggleResponse[]) => {
                this.log(`updateResponses`)
            }),
            catchError(this.handleError)
        );


    }

    deleteResponses(data: ToggleResponse[]) {

        return this.http.request<ToggleResponse[]>('delete', this._apiUrl + '/deleteresponses', { headers: new HttpHeaders({ 'Content-Type': 'application/json' }), body: data }).pipe(
            tap((data: ToggleResponse[]) => {
                this.log(`deleteResponses`)
            }),
            catchError(this.handleError)
        );

    }

}
