import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { GenerateReportTopic } from '../../models/app/generateReportTopic';
import { GenerateReportTopicDto } from '../../models/app/generateReportTopicDto';
import { GenerateReportDto } from '../../models/app/generateReportDto';
import { Observable } from 'rxjs';
import { catchError, map, tap } from 'rxjs';
import { BaseService } from '../base.service';

@Injectable()
export class GenerateReportTopicService extends BaseService {

    constructor(private http: HttpClient) {
        super();
    }

    private _apiUrl = 'api/app/generatereporttopics';

    getTopics(userName: string): Observable<GenerateReportTopicDto[]> {
        let url = this._apiUrl + '/' + userName;

        return this.http.get<GenerateReportTopicDto[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getTopics`);
                }),
                catchError(this.handleError)
            );

    }

    getReportList(topicId: number): Observable<GenerateReportDto[]> {
        let url = this._apiUrl + '/getReports/' + topicId;

        return this.http.get<GenerateReportDto[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getReportList`);
                }),
                catchError(this.handleError)
            );


    }

    addTopic(data: GenerateReportTopicDto) {

        
        return this.http.post<GenerateReportTopicDto>(this._apiUrl + '/addtopic', data, { headers: this.headers }).pipe(
            tap((data: GenerateReportTopicDto) => {
                this.log(`addTopic`)
            }),
            catchError(this.handleError)
        );

    }

    updateTopic(data: GenerateReportTopicDto) {

        return this.http.put<GenerateReportTopicDto>(this._apiUrl + '/updatetopic', data, { headers: this.headers }).pipe(
            tap((data: GenerateReportTopicDto) => {
                this.log(`updateTopic`)
            }),
            catchError(this.handleError)
        );

    }

    updateReportTopics(reportId: number, topicIds: number[]) {

        return this.http.put<GenerateReportTopicDto>(this._apiUrl + '/updatereporttopics/' + reportId, topicIds, { headers: this.headers }).pipe(
            tap((data: GenerateReportTopicDto) => {
                this.log(`updateReportTopics`)
            }),
            catchError(this.handleError)
        );
    }


    removeTopic(id: number) {

        return this.http.delete(this._apiUrl + '/' + id).pipe(
            tap((data) => {
                this.log(`removeTopic`)
            }),
            catchError(this.handleError)
        );

    }



}
