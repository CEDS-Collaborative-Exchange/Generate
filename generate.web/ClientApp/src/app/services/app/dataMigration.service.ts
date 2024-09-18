import { Injectable } from '@angular/core';
import { DataMigration } from '../../models/app/dataMigration';
import { CurrentMigrationStatus } from '../../models/app/currentMigrationStatus';
import { DimDateDataMigrationType } from '../../models/app/dates';
import { DimDateDto } from '../../models/app/dates';
import { DimSchoolYearDto } from '../../models/app/schoolYear';
import { DimSchoolYearDataMigrationType } from '../../models/app/schoolYear';
import { DataMigrationTask, GenerateReportType } from '../../models/app/migrationtasks';
import { Observable } from 'rxjs';
import { catchError, map, tap } from 'rxjs';
import { GenerateReport } from '../../models/app/migrationtasks';
import { FactType } from '../../models/app/factType';
import { BaseService } from '../base.service';
import { HttpClient } from '@angular/common/http';

@Injectable()
export class DataMigrationService extends BaseService {

    private _apiUrl = 'api/app/datamigrations';

    constructor(private http: HttpClient) {
        super();
    }

    migrateODS(dimSchoolYear: DimSchoolYearDataMigrationType[], dataMigrationTasks: DataMigrationTask[]) {

        var postData = {
            dimSchoolYearDataMigrationTypes: dimSchoolYear,
            dataMigrationTasks: dataMigrationTasks
        };

        return this.http.put(this._apiUrl + '/migrateods', postData, { headers: this.headers }).pipe(
            tap((data) => {
                this.log(`migrateODS`)
            }),
            catchError(this.handleError)
        );
    }

    cancelMigration(dataMigrationTypeCode: string) {
        var postData = {
            migrationType: dataMigrationTypeCode
        }; 

        return this.http.put(this._apiUrl + '/CancelMigration', postData, { headers: this.headers }).pipe(
            tap((data) => {
                this.log(`CancelMigration`)
            }),
            catchError(this.handleError)
        );

    }

    migrateRDS(dimSchoolYear: DimSchoolYearDataMigrationType[], dataMigrationTasks: DataMigrationTask[]) {

        var postData = {
            dimSchoolYearDataMigrationTypes: dimSchoolYear,
            dataMigrationTasks: dataMigrationTasks
        };

        return this.http.put(this._apiUrl + '/migraterds', postData, { headers: this.headers }).pipe(
            tap((data) => {
                this.log(`migraterds`)
            }),
            catchError(this.handleError)
        );
    }
    migrateReport(dimSchoolYear: DimSchoolYearDataMigrationType[], generateReports: GenerateReport[], userName: string) {

        var postData = {
            dimSchoolYearDataMigrationTypes: dimSchoolYear,
            generateReportLists: generateReports,
            userName: userName
        };

        console.log(userName);
        
        return this.http.put(this._apiUrl + '/migratereport', postData, { headers: this.headers }).pipe(
            tap((data) => {
                this.log(`migratereport`)
            }),
            catchError(this.handleError)
        );

    }

    currentMigrationStatus(): Observable<CurrentMigrationStatus> {
        let url = this._apiUrl + '/currentmigrationstatus';

        return this.http.get<CurrentMigrationStatus>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`currentMigrationStatus`);
                }),
                catchError(this.handleError)
            );

    }

  getYears(reportType): Observable<DimSchoolYearDto[]> {
      let url = this._apiUrl + '/years/' + reportType;

      return this.http.get<DimSchoolYearDto[]>(url, { observe: 'response' })
          .pipe(
              map(resp => {
                  return resp.body;
              }),
              tap(resp => {
                  this.log(`getYears`);
              }),
              catchError(this.handleError)
          );


    }

  getTaskLists(reportType): Observable<DataMigrationTask[]> {
      let url = this._apiUrl + '/tasklist/' + reportType;

      return this.http.get<DataMigrationTask[]>(url, { observe: 'response' })
          .pipe(
              map(resp => {
                  return resp.body;
              }),
              tap(resp => {
                  this.log(`getTaskLists`);
              }),
              catchError(this.handleError)
          );

    }

    generateReportList(): Observable<GenerateReport[]> {
        let url = this._apiUrl + '/reportlists' ;

        return this.http.get<GenerateReport[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`generateReportList`);
                }),
                catchError(this.handleError)
            );

    }

    getFactTypes(): Observable<FactType[]> {
        let url = this._apiUrl + '/factTypes';

        return this.http.get<FactType[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getFactTypes`);
                }),
                catchError(this.handleError)
            );

    }

    getLastRunFactType(): Observable<FactType> {
        let url = this._apiUrl + '/lastRunFactType';

        return this.http.get<FactType>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getLastRunFactType`);
                }),
                catchError(this.handleError)
            );

    }

    generateReportType(): Observable<GenerateReportType[]> {
        let url = this._apiUrl + '/reportTypes';

        return this.http.get<GenerateReportType[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`generateReportType`);
                }),
                catchError(this.handleError)
            );

    }

    updateDimDates(dimdates: DimDateDto[]) {

        return this.http.put(this._apiUrl + '/ed', dimdates, { headers: this.headers }).pipe(
            tap((data) => {
                this.log(`updateDimDates`)
            }),
            catchError(this.handleError)
        );

    }
    

    saveMigrationConfiguration(dimdates: DimDateDataMigrationType[], dataMigrationTasks: DataMigrationTask[]) {

        var postData = {
            dimDateDataMigrationTypes: dimdates,
            dataMigrationTasks: dataMigrationTasks
        };

        return this.http.post<DimDateDataMigrationType[]>(this._apiUrl + '/saveconfiguration', postData, { headers: this.headers }).pipe(
            tap((data: DimDateDataMigrationType[]) => {
                this.log(`saveMigrationConfiguration`)
            }),
            catchError(this.handleError)
        );

    }

    checkIfDirectoryDataExists(schoolYearId: number) {
        let url = this._apiUrl + '/checkIfDirectoryDataExists/' + schoolYearId;

        return this.http.get<boolean>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`checkIfDirectoryDataExists`);
                }),
                catchError(this.handleError)
            );
    }

}
