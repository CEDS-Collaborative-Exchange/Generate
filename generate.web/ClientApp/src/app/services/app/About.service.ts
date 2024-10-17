import { Injectable } from '@angular/core';
import { catchError, map, tap, of } from 'rxjs';
import { BaseService } from '../base.service';
import { HttpClient } from '@angular/common/http';

@Injectable()
export class AboutServ extends BaseService {

    private _apiUrl = 'api/app/about';

    constructor(private http: HttpClient) {
        super();
    }

    getDBvers() {

        let url = this._apiUrl + '/getvers';
        console.log("calling method getvers" + url);

        //return this.http.get<DataMigrationTask[]>(url, { observe: 'response' })
        //return this.http.get(url, { observe: 'response' })

        return this.http.get(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    return resp.body['successMessage'];
                    }),
                    tap(resp => {
                        this.log(`getTaskLists`);
                    }),
                    catchError(this.handleError)
              );

        /*

                return this.http.get(url, { observe: 'response' })
            .pipe(
                map(resp => {
                    //console.log(" Inside map ");
                    //console.log(resp.statusText);
                    //console.log(resp.body["userid"]);
                    //console.log(resp.body["successMessage"]);
                    //console.log(resp);
                    //return resp.body;
                    //return resp.statusText;
                    return resp.body['successMessage'];
                }),
                tap(resp => {
                    console.log(" Inside tap ");
                    console.log("=======Start==========");
                    console.log(resp);
                    console.log("=======END==========");
                    this.log(`getTaskLists`);
                }),
            //catchError(this.handleError)
                catchError(err => {
                    //console.error(err.message);
                    //console.error("check123");
                    //console.log(err);
                    //console.log(err.error);
                    //console.log(err.message);
                    //console.log("check234");
                    return of(err.error);
                })  
            );

        */


    }


}
