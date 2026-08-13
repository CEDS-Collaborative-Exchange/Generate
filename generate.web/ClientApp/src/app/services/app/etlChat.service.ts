import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';
import { BaseService } from '../base.service';
import { HttpClient } from '@angular/common/http';

import {
    EtlChatIterationResult,
    EtlChatMessage,
    EtlChatSession,
    EtlChatSessionCreate,
    EtlChatStatus,
    EtlMappingCoverage
} from '../../models/app/etlChat';

@Injectable()
export class EtlChatService extends BaseService {

    private _apiUrl = 'api/app/etlchat';

    constructor(private http: HttpClient) {
        super();
    }

    getSessions(mapId: number): Observable<EtlChatSession[]> {
        return this.http.get<EtlChatSession[]>(`${this._apiUrl}/maps/${mapId}/sessions`, { observe: 'response' })
            .pipe(map(r => r.body), tap(() => this.log('fetched etl chat sessions')), catchError(this.handleError));
    }

    createSession(create: EtlChatSessionCreate): Observable<EtlChatSession> {
        return this.http.post<EtlChatSession>(`${this._apiUrl}/sessions`, create, { observe: 'response' })
            .pipe(map(r => r.body), tap(() => this.log('created etl chat session')), catchError(this.handleError));
    }

    getMessages(sessionId: number): Observable<EtlChatMessage[]> {
        return this.http.get<EtlChatMessage[]>(`${this._apiUrl}/sessions/${sessionId}/messages`, { observe: 'response' })
            .pipe(map(r => r.body), tap(() => this.log('fetched etl chat messages')), catchError(this.handleError));
    }

    postMessage(sessionId: number, content: string): Observable<EtlChatSession> {
        return this.http.post<EtlChatSession>(`${this._apiUrl}/sessions/${sessionId}/messages`, { content }, { observe: 'response' })
            .pipe(map(r => r.body), tap(() => this.log('posted etl chat message')), catchError(this.handleError));
    }

    runIteration(sessionId: number): Observable<EtlChatIterationResult> {
        return this.http.post<EtlChatIterationResult>(`${this._apiUrl}/sessions/${sessionId}/iterate`, {}, { observe: 'response' })
            .pipe(map(r => r.body), tap(() => this.log('ran etl chat iteration')), catchError(this.handleError));
    }

    // Starts (or resumes) the server-side background run — keeps advancing even if the user leaves.
    startRun(sessionId: number): Observable<any> {
        return this.http.post<any>(`${this._apiUrl}/sessions/${sessionId}/run`, {}, { observe: 'response' })
            .pipe(map(r => r.body), tap(() => this.log('started etl chat run')), catchError(this.handleError));
    }

    // Requests the background run to stop after the current step finishes.
    stopRun(sessionId: number): Observable<any> {
        return this.http.post<any>(`${this._apiUrl}/sessions/${sessionId}/stop`, {}, { observe: 'response' })
            .pipe(map(r => r.body), tap(() => this.log('stopped etl chat run')), catchError(this.handleError));
    }

    // Session state + whether a background run is currently active (for reconnecting the UI).
    getStatus(sessionId: number): Observable<EtlChatStatus> {
        return this.http.get<EtlChatStatus>(`${this._apiUrl}/sessions/${sessionId}/status`, { observe: 'response' })
            .pipe(map(r => r.body), tap(() => this.log('fetched etl chat status')), catchError(this.handleError));
    }

    // Readiness check: does the map's mapping cover the Staging tables/columns the target file spec needs?
    getCoverage(mapId: number): Observable<EtlMappingCoverage> {
        return this.http.get<EtlMappingCoverage>(`${this._apiUrl}/maps/${mapId}/coverage`, { observe: 'response' })
            .pipe(map(r => r.body), tap(() => this.log('fetched mapping coverage')), catchError(this.handleError));
    }

    deleteSession(sessionId: number): Observable<any> {
        return this.http.delete(`${this._apiUrl}/sessions/${sessionId}`, { observe: 'response' })
            .pipe(tap(() => this.log('deleted etl chat session')), catchError(this.handleError));
    }
}
