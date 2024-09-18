import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {ToggleQuestionType} from '../../models/app/toggleQuestionType';
import {Observable}     from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';
import { BaseService } from '../base.service';

@Injectable()
export class ToggleQuestionTypeService extends BaseService {

    constructor(private http: HttpClient) {
        super();
    }

    private _apiUrl = 'api/app/togglequestiontypes';


    getAll() {


        return this.http.get<ToggleQuestionType[]>(this._apiUrl, { observe: 'response' })
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
