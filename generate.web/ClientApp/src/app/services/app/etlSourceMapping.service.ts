import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';
import { BaseService } from '../base.service';
import { HttpClient } from '@angular/common/http';

import {
    CedsElementCatalog,
    CedsElementMatch,
    CedsOptionSetValue,
    EtlSourceElementMapping,
    EtlSourceElementMappingResult,
    EtlSourceElementMappingUpdate,
    EtlSourceMappingUpload,
    EtlSourceOptionSetMapping,
    EtlSourceOptionSetMappingUpdate
} from '../../models/app/etlSourceMapping';

@Injectable()
export class EtlSourceMappingService extends BaseService {

    private _apiUrl = 'api/app/etlsourcemappings';

    constructor(private http: HttpClient) {
        super();
    }

    getAll(): Observable<EtlSourceElementMapping[]> {
        return this.http.get<EtlSourceElementMapping[]>(this._apiUrl, { observe: 'response' })
            .pipe(
                map(resp => resp.body),
                tap(() => this.log('fetched all etl source mappings')),
                catchError(this.handleError)
            );
    }

    upload(upload: EtlSourceMappingUpload): Observable<EtlSourceElementMappingResult[]> {
        return this.http.post<EtlSourceElementMappingResult[]>(this._apiUrl + '/upload', upload, { observe: 'response' })
            .pipe(
                map(resp => resp.body),
                tap(() => this.log('uploaded data dictionary')),
                catchError(this.handleError)
            );
    }

    getCedsElements(): Observable<CedsElementCatalog[]> {
        return this.http.get<CedsElementCatalog[]>(this._apiUrl + '/cedselements', { observe: 'response' })
            .pipe(
                map(resp => resp.body),
                tap(() => this.log('fetched ceds element catalog')),
                catchError(this.handleError)
            );
    }

    getCedsOptionSets(globalId: string): Observable<CedsOptionSetValue[]> {
        return this.http.get<CedsOptionSetValue[]>(this._apiUrl + '/cedselements/' + encodeURIComponent(globalId) + '/optionsets', { observe: 'response' })
            .pipe(
                map(resp => resp.body),
                tap(() => this.log('fetched ceds option sets')),
                catchError(this.handleError)
            );
    }

    getCandidates(etlSourceElementMappingId: number): Observable<CedsElementMatch[]> {
        return this.http.get<CedsElementMatch[]>(this._apiUrl + '/' + etlSourceElementMappingId + '/candidates', { observe: 'response' })
            .pipe(
                map(resp => resp.body),
                tap(() => this.log('fetched element candidates')),
                catchError(this.handleError)
            );
    }

    updateElementMapping(etlSourceElementMappingId: number, update: EtlSourceElementMappingUpdate): Observable<EtlSourceElementMapping> {
        return this.http.put<EtlSourceElementMapping>(this._apiUrl + '/' + etlSourceElementMappingId, update, { observe: 'response' })
            .pipe(
                map(resp => resp.body),
                tap(() => this.log('updated element mapping')),
                catchError(this.handleError)
            );
    }

    updateOptionSetMapping(etlSourceOptionSetMappingId: number, update: EtlSourceOptionSetMappingUpdate): Observable<EtlSourceOptionSetMapping> {
        return this.http.put<EtlSourceOptionSetMapping>(this._apiUrl + '/optionsets/' + etlSourceOptionSetMappingId, update, { observe: 'response' })
            .pipe(
                map(resp => resp.body),
                tap(() => this.log('updated option set mapping')),
                catchError(this.handleError)
            );
    }

    deleteAll(): Observable<any> {
        return this.http.delete(this._apiUrl, { observe: 'response' })
            .pipe(
                tap(() => this.log('deleted all etl source mappings')),
                catchError(this.handleError)
            );
    }

    export(): Observable<Blob> {
        return this.http.get(this._apiUrl + '/export', { responseType: 'blob' })
            .pipe(
                tap(() => this.log('exported etl checklist')),
                catchError(this.handleError)
            );
    }
}
