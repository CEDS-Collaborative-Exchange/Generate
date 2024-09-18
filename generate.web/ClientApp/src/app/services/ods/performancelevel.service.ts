import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { PerformanceLevelDto } from '../../models/ods/performanceLevelDto';
import { catchError, map, tap } from 'rxjs';
import { BaseService } from '../base.service';

@Injectable()
export class PerformanceLevelService extends BaseService {

    constructor(private http: HttpClient) {
        super();
    }

    private _apiUrl = 'api/ods/performancelevels';


    getAll(): Observable<PerformanceLevelDto[]> {

        return this.http.get<PerformanceLevelDto[]>(this._apiUrl, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getGradeLevelAssessments`);
                }),
                catchError(this.handleError)
            );

    }


}
