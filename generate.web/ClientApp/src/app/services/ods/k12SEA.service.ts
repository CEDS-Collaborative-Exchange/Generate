import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {K12Sea} from '../../models/ods/k12Sea';
import {RefState} from '../../models/ods/refState';
import {Observable}     from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';
import { BaseService } from '../base.service';

@Injectable()
export class K12SeaService extends BaseService {

    constructor(private http: HttpClient) {
        super();
    }

    private _apiUrl = 'api/ods/k12Sea';


    getAll() {

        return this.http.get<K12Sea>(this._apiUrl, { observe: 'response' })
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

    getState() {
        let url = this._apiUrl + '/state';


        return this.http.get<RefState>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getState`);
                }),
                catchError(this.handleError)
            );

    }

}
