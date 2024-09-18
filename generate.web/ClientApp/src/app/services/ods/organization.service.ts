import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { OrganizationDto } from '../../models/ods/organizationDto';
import { Organization } from '../../models/ods/organization';
import { Observable } from 'rxjs';
import { catchError, map, tap } from 'rxjs';
import { BaseService } from '../base.service';

@Injectable()
export class OrganizationService extends BaseService {


    constructor(private http: HttpClient) {
        super();
    }

    private _apiUrl = 'api/ods/organizations';


    getAll() {


        return this.http.get<Organization>(this._apiUrl, { observe: 'response' })
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

    getLEAs(reportYear: string): Observable<OrganizationDto[]> {
        let url = this._apiUrl + '/001072/' + reportYear;


        return this.http.get<OrganizationDto[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getLEAs`);
                }),
                catchError(this.handleError)
            );

    }

    getSchools(reportYear: string): Observable<OrganizationDto[]> {
        let url = this._apiUrl + '/001073/' + reportYear;


        return this.http.get<OrganizationDto[]>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getSchools`);
                }),
                catchError(this.handleError)
            );

    }

}
