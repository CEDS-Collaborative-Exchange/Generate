import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {GenerateReport} from '../../models/app/generateReport';
import { GenerateReportDto } from '../../models/app/generateReportDto';
import { GenerateReportDataDto } from '../../models/app/generateReportDataDto';
import { OrganizationLevelDto } from '../../models/app/organizationLevelDto';
import {Observable}     from 'rxjs';
import { catchError, map, tap } from 'rxjs';
import { CategorySetDto, Filter, CatToDisplay } from '../../models/app/categorySetDto';
import { BaseService } from '../base.service';


@Injectable()
export class GenerateReportService extends BaseService {

    constructor(private http: HttpClient) {
        super();
    }

    private _apiUrl = 'api/app/generatereports';
    private _fileSubmissionUrl = 'api/app/filesubmissions';


    getSubmissionYears(reportCode: string): Observable<string[]> {
        let url = this._apiUrl + '/submissionyears/' + reportCode;

        return this.http.get<string[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getSubmissionYears`);
                }),
                catchError(this.handleError)
            );


    }
    getSubmissionYearss(reportCode: string, reportType: string): Observable<string[]> {
        let url = this._apiUrl + '/submissionyears/' + reportCode + '/' + reportType;

        return this.http.get<string[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                        return resp.body;
                }),
                tap(resp => {
                    this.log(`getSubmissionYearss`);
                }),
                catchError(this.handleError)
            );

    }

    getReportLevels(): Observable<OrganizationLevelDto[]> {
        let url = this._apiUrl + '/organizationlevels';

        return this.http.get<OrganizationLevelDto[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getReportLevels`);
                }),
                catchError(this.handleError)
            );

    }

    getReportLevelsByCode(reportType: string, reportCode: string, reportYear: string, reportCategorySetCode: string): Observable<OrganizationLevelDto[]> {
        let url = this._apiUrl + '/organizationLevelsByReportCodeYear/' + reportType + '/' + reportCode + '/' + reportYear  + '/' + reportCategorySetCode;
        //let url = this._apiUrl + '/' + reportType + '/' + reportCode + '/' + reportYear + '/' + reportCategorySetCode;
     

        return this.http.get<OrganizationLevelDto[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getReportLevels`);
                }),
                catchError(this.handleError)
            );

    }


    getReportList(reportType: string): Observable<GenerateReportDto[]> {
        let url = this._apiUrl + '/' + reportType;

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

    getReports(reportType: string): Observable<GenerateReport[]> {
        let url = this._apiUrl + '/reports/' + reportType;

       

        return this.http.get<GenerateReport[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getReports`);
                }),
                catchError(this.handleError)
            );

    }

    getSubmissionReport(reportType: string, reportCode: string): Observable<GenerateReport> {
        let url = this._apiUrl + '/reports/' + reportType + '/' + reportCode;

        return this.http.get<GenerateReport>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getSubmissionReport`);
                }),
                catchError(this.handleError)
            );

    }

    getReportByCode(reportType: string, reportCode: string): Observable<GenerateReportDto> {
        let url = this._apiUrl + '/' + reportType + '/' + reportCode;

        return this.http.get<GenerateReportDto>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getReportByCode`);
                }),
                catchError(this.handleError)
            );

    }
    geFilterByCode(filterCode: string): Observable<Filter> {
        let url = this._apiUrl + '/getCatSet/' + filterCode;


        return this.http.get<Filter>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`geFilterByCode`);
                }),
                catchError(this.handleError)
            );

    }
    getReportByCodes(reportType: string, reportCode: string): Observable<GenerateReportDto> {
        let url = this._apiUrl + '/report/' + reportType + '/' + reportCode;

        return this.http.get<GenerateReportDto>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getReportByCodes`);
                }),
                catchError(this.handleError)
            );

    }

    getReport(reportType: string, reportCode: string, reportLevel: string, reportYear: string, reportCategorySetCode: string, reportSort: number, skip: number, take: number): Observable<any> {
        let url = this._apiUrl + '/' + reportType + '/' + reportCode + '/' + reportLevel + '/' + reportYear + '/' + reportCategorySetCode + '?sort=' + reportSort + '&skip=' + skip + '&take=' + take;


        return this.http.get<GenerateReportDto>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getReport`);
                }),
                catchError(this.handleError)
            );

    }

    getPagedReport(reportType: string, reportCode: string, reportLevel: string, reportYear: string, reportCategorySetCode: string, reportSort: number, skip: number, take: number, pageSize: number, page: number): Observable<any> {

        if (pageSize === undefined) {
            pageSize = 10;
        }

        let url = this._apiUrl + '/pages' + '/' + reportType + '/' + reportCode + '/' + reportLevel + '/' + reportYear + '/' + reportCategorySetCode + '?sort=' + reportSort + '&skip=' + skip + '&take=' + take + '&pageSize=' + pageSize + '&page=' + page;


        return this.http.get<GenerateReportDto>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getReport`);
                }),
                catchError(this.handleError)
            );

    }

    getStateReport(reportType: string, reportCode: string, reportLevel: string, reportYear: string, reportCategorySetCode: string, reportLea: string, reportSchool: string, reportFilter: string, reportSubFilter: string, organizationalIdList: string, reportGrade: string, reportSort: number, skip: number, take: number): Observable<GenerateReportDataDto> {
        let url = this._apiUrl + '/' + reportType + '/' + reportCode + '/' + reportLevel + '/' + reportYear + '/' + reportCategorySetCode + '/' + reportLea + '/' + reportSchool + '/' + reportFilter + '/' + reportSubFilter + '/' + reportGrade + '/' + organizationalIdList + '?sort=' + reportSort + '&skip=' + skip + '&take=' + take;


        return this.http.get<GenerateReportDataDto>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getStateReport`);
                }),
                catchError(this.handleError)
            );

    }
    getDataQualityReport(reportType: string, reportCode: string, reportLevel: string, reportYear: string, reportCategorySetCode: string, reportLea: string, reportSchool: string, reportFilter: string, reportSubFilter: string, organizationalIdList: string, reportGrade: string, reportSort: number, skip: number, take: number): Observable<GenerateReportDataDto> {
        //let url = this._apiUrl + '/' + reportType + '/' + reportCode + '/' + reportLevel + '/' + reportYear + '/' + reportCategorySetCode + '/' + reportLea + '/' + reportSchool + '/' + reportFilter + '/' + reportSubFilter + '/' + reportGrade + '/' + organizationalIdList + '?sort=' + reportSort + '&skip=' + skip + '&take=' + take;
        // Don't think we need the orgID list, so switching to other API call without it.  It's causing issues with IIS.
        let url = this._apiUrl + '/' + reportType + '/' + reportCode + '/' + reportLevel + '/' + reportYear + '/' + reportCategorySetCode + '?sort=' + reportSort + '&skip=' + skip + '&take=' + take;

        return this.http.get<GenerateReportDataDto>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getDataQualityReport`);
                }),
                catchError(this.handleError)
            );

    }
    getCats(reportYear: string, reportLevel: string, reportCode: string, reportCategorySetCode: string): Observable<string[]> {
        let url = this._apiUrl + '/option/' + reportYear + '/' + reportLevel + '/' + reportCode + '/' + reportCategorySetCode;


        return this.http.get<string[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getCats`);
                }),
                catchError(this.handleError)
            );

    }

    getFilterToDisplay(filterCode: string): Observable<CatToDisplay> {
        let url = this._apiUrl + '/getcat/' + filterCode;


        return this.http.get<CatToDisplay>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getFilterToDisplay`);
                }),
                catchError(this.handleError)
            );

    }


}
