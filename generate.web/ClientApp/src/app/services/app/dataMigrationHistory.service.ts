import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { catchError, map, tap } from 'rxjs';
import { BaseService } from '../base.service';
import { HttpClient } from '@angular/common/http';
import { DataMigrationHistory } from '../../models/app/dataMigrationHistory';
import { StagingValidationResult } from '../../models/app/stagingValidationResult';

@Injectable()
export class DataMigrationHistoryService extends BaseService {

    private _apiUrl = 'api/app/datamigrationhistory';

    constructor(private http: HttpClient) {
        super();
    }

    getMigrationHistory(dataMigrationTypeCode): Observable<DataMigrationHistory[]> {
        let url = this._apiUrl + '/' + dataMigrationTypeCode;

        return this.http.get<DataMigrationHistory[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getMigrationHistory`);
                }),
                catchError(this.handleError)
            );

    }

    getStagingValidationResults(): Observable<StagingValidationResult[]> {
        let url = this._apiUrl + '/validation';

        return this.http.get<StagingValidationResult[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getStagingValidationResults`);
                }),
                catchError(this.handleError)
            );

    }

}
