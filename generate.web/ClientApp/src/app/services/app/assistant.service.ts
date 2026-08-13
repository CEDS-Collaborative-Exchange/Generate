import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';
import { BaseService } from '../base.service';
import { HttpClient } from '@angular/common/http';

import { AssistantSession, AssistantMessage } from '../../models/app/assistant';

@Injectable()
export class AssistantService extends BaseService {

    private _apiUrl = 'api/app/assistant';

    constructor(private http: HttpClient) {
        super();
    }

    getSessions(): Observable<AssistantSession[]> {
        return this.http.get<AssistantSession[]>(`${this._apiUrl}/sessions`, { observe: 'response' })
            .pipe(map(r => r.body), tap(() => this.log('fetched assistant sessions')), catchError(this.handleError));
    }

    createSession(title: string): Observable<AssistantSession> {
        return this.http.post<AssistantSession>(`${this._apiUrl}/sessions`, { title }, { observe: 'response' })
            .pipe(map(r => r.body), tap(() => this.log('created assistant session')), catchError(this.handleError));
    }

    deleteSession(sessionId: number): Observable<any> {
        return this.http.delete(`${this._apiUrl}/sessions/${sessionId}`, { observe: 'response' })
            .pipe(tap(() => this.log('deleted assistant session')), catchError(this.handleError));
    }

    getMessages(sessionId: number): Observable<AssistantMessage[]> {
        return this.http.get<AssistantMessage[]>(`${this._apiUrl}/sessions/${sessionId}/messages`, { observe: 'response' })
            .pipe(map(r => r.body), tap(() => this.log('fetched assistant messages')), catchError(this.handleError));
    }

    postMessage(sessionId: number, content: string): Observable<AssistantSession> {
        return this.http.post<AssistantSession>(`${this._apiUrl}/sessions/${sessionId}/messages`, { content }, { observe: 'response' })
            .pipe(map(r => r.body), tap(() => this.log('posted assistant message')), catchError(this.handleError));
    }

    run(sessionId: number): Observable<AssistantMessage> {
        return this.http.post<AssistantMessage>(`${this._apiUrl}/sessions/${sessionId}/run`, {}, { observe: 'response' })
            .pipe(map(r => r.body), tap(() => this.log('ran assistant reply')), catchError(this.handleError));
    }
}
