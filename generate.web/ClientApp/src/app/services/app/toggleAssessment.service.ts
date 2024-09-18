import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ToggleAssessment } from '../../models/app/toggleAssessment';
import { Observable } from 'rxjs';
import { catchError, map, tap } from 'rxjs';
import { BaseService } from '../base.service';

@Injectable()
export class ToggleAssessmentService extends BaseService {

    constructor(private http: HttpClient) {
        super();
    }

    private _apiUrl = 'api/app/toggleassessments';


    getAll(): Observable<ToggleAssessment[]> {

        return this.http.get<ToggleAssessment[]>(this._apiUrl, { observe: 'response' })
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

    addAssessment(data: ToggleAssessment) {

        return this.http.post<ToggleAssessment>(this._apiUrl, data, { headers: this.headers }).pipe(
            tap((data: ToggleAssessment) => {
                this.log(`addAssessment`)
            }),
            catchError(this.handleError)
        );

    }

    updateAssessment(data: ToggleAssessment) {

        return this.http.put<ToggleAssessment>(this._apiUrl, data, { headers: this.headers }).pipe(
            tap((data: ToggleAssessment) => {
                this.log(`updateAssessment`)
            }),
            catchError(this.handleError)
        );

    }

    deleteAssessments(id: number) {
        let url = this._apiUrl + '/' + id;

        return this.http.delete(url).pipe(
            tap((data) => {
                this.log(`deleteAssessments`)
            }),
            catchError(this.handleError)
        );


    }


}
