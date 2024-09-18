import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {ToggleSection} from '../../models/app/toggleSection';
import {Observable}     from 'rxjs';
import { catchError, map, tap } from 'rxjs';
import { BaseService } from '../base.service';

@Injectable()
export class ToggleSectionService extends BaseService {

    constructor(private http: HttpClient) {
        super();
    }

    private _apiUrl = 'api/app/togglesections';


    getAll(): Observable<ToggleSection[]> {

        return this.http.get<ToggleSection[]>(this._apiUrl, { observe: 'response' })
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

}
