import { Injectable } from '@angular/core';
import { catchError, map, tap, of } from 'rxjs';
import { BaseService } from '../base.service';
import { HttpClient } from '@angular/common/http';
import { MetadataStatus } from '../../models/app/metadataStatus';

@Injectable()
export class FSMetadataUpdate extends BaseService {

    private _apiUrl = 'api/app/fsmetadata';

    constructor(private http: HttpClient) {
        super();
    }

    callFSMetaServc(SchYear) {

        console.log('SchYear -' + SchYear);

        let url = this._apiUrl + '/fsservc/' + SchYear;
  
        return this.http.get(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body['successMessage'];
                    }),
                    tap(resp => {
                        this.log(`callFSMetaServc`);
                    }),
                    catchError(err => {
                        this.handleError;
                        return of(err.error);
                    })  
              );

    }

    getMetadataStatus() {

        let url = this._apiUrl + '/getMetadataStatus';

        return this.http.get<MetadataStatus>(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getMetadataStatus`);
                }),
                catchError(err => {
                    this.handleError;
                    return of(err.error);
                })
            );

    }

    getlatestSYs() {
        console.log('##getLatestSYs##');
        let url = this._apiUrl + '/getlatestSYs';

        return this.http.get(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    console.log('--here a--');
                    console.log(resp);
                    console.log(resp.body);
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getlatestSYs`);
                }),
                catchError(err => {
                    console.log('--here12--');
                    this.handleError;
                    return of(err.error);
                })
            );

    }

    getFlag() {
        console.log('##getMetaUplFlag##');
        let url = this._apiUrl + '/getMetaUplFlag';

        return this.http.get(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    console.log('--here aa--');
                    console.log(resp);
                    console.log(resp.body);
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`getMetaUplFlag`);
                }),
                catchError(err => {
                    console.log('--here13--');
                    this.handleError;
                    return of(err.error);
                })
            );

    }


}
