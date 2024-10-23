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

    callFSMetaServc() {

        let url = this._apiUrl + '/fsservc';
        console.log("calling method callFSMetaServc" + url);

        //return this.http.get<DataMigrationTask[]>(url, { observe: 'response' })
        //return this.http.get(url, { observe: 'response' })

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


}
