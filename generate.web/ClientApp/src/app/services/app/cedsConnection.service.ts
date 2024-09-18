import {Injectable}     from '@angular/core';
import {CedsConnection} from '../../models/app/cedsConnection';
import {Observable}     from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';
import { BaseService } from '../base.service';
import { HttpClient } from '@angular/common/http';

@Injectable()
export class CedsConnectionService extends BaseService {

    private _apiUrl = 'api/app/cedsconnections';

    constructor(private http: HttpClient) {
        super();
    }

    getAll(): Observable<CedsConnection[]> {

        return this.http.get<CedsConnection[]>(this._apiUrl, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body;
                }),
                tap(resp => {
                    this.log(`fetched all`);
                }),
                catchError(this.handleError)
            );

    }


}
