import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { AssessmentTypeDto } from '../../models/ods/assessmentTypeDto';
import { catchError, map, tap } from 'rxjs';
import { BaseService } from '../base.service';

@Injectable()
export class AssessmentTypeService extends BaseService {

    constructor(private http: HttpClient) {
        super();
    }

    private _apiUrl = 'api/ods/assessmenttypes/';


    getGradeLevelAssessments(subject: string, grade: string): Observable<AssessmentTypeDto[]> {

        let url = this._apiUrl + subject + '/' + grade;

        return this.http.get<AssessmentTypeDto[]>(url, { observe: 'response' })
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
