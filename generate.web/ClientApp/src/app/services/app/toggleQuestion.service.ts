import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {ToggleQuestion} from '../../models/app/toggleQuestion';
import {Observable}     from 'rxjs';
import { catchError, map, tap } from 'rxjs';
import { BaseService } from '../base.service';

@Injectable()
export class ToggleQuestionService extends BaseService {

    constructor(private http: HttpClient) {
        super();
    }

    private _apiUrl = 'api/app/togglequestions';


    getAll(): Observable<ToggleQuestion[]> {

        return this.http.get<ToggleQuestion[]>(this._apiUrl, { observe: 'response' })
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
