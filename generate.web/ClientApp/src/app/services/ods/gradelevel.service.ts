import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { GradeLevelDto } from '../../models/ods/gradeLevelDto';
import { catchError, map, tap } from 'rxjs';
import { BaseService } from '../base.service';

@Injectable()
export class GradeLevelService extends BaseService {

    constructor(private http: HttpClient) {
        super();
    }

    private _apiUrl = 'api/ods/gradelevels';


    getAll(): Observable<GradeLevelDto[]> {


        return this.http.get<GradeLevelDto[]>(this._apiUrl, { observe: 'response' })
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


    getGradeLevelsOffered(): Observable<GradeLevelDto[]> {
        let url = this._apiUrl + '/000100';

        return this.http.get<GradeLevelDto[]>(url, { observe: 'response' })
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
