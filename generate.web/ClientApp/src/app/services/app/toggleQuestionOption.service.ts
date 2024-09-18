import {Injectable}     from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {ToggleQuestionOption} from '../../models/app/toggleQuestionOption';
import {Observable}     from 'rxjs';
import { catchError, map, tap } from 'rxjs';
import { BaseService } from '../base.service';

@Injectable()
export class ToggleQuestionOptionService extends BaseService {

    constructor(private http: HttpClient) {
        super();
    }
    private _apiUrl = 'api/app/togglequestionoptions';


    getAll(): Observable<ToggleQuestionOption[]> {

        return this.http.get<ToggleQuestionOption[]>(this._apiUrl, { observe: 'response' })
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
