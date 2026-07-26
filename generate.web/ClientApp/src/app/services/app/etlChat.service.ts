import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';
import { BaseService } from '../base.service';
import { HttpClient } from '@angular/common/http';

import {
    EtlChatIterationResult,
    EtlChatMessage,
    EtlChatSession,
    EtlChatSessionCreate
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

    deleteSession(sessionId: number): Observable<any> {
        return this.http.delete(`${this._apiUrl}/sessions/${sessionId}`, { observe: 'response' })
            .pipe(tap(() => this.log('deleted etl chat session')), catchError(this.handleError));
    }
}
