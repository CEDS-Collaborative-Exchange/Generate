import { Injectable } from '@angular/core';
import { HttpInterceptor, HttpRequest, HttpHandler, HttpEvent } from '@angular/common/http';
import { Observable } from 'rxjs';
import { UserService } from '../../services/app/user.service';

@Injectable()
export class HttpConfigInterceptor implements HttpInterceptor {

    constructor(public userService: UserService) { }

    intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {

        // This is my helper method to fetch the data from localStorage.
        const token: string = this.userService.getToken();
/*        if (request.url.includes(environment.apiURL)) {*/

        const params = request.params;
        let headers = request.headers;

        if (token) {
                // set the accessToken to your header
            headers = headers.set('accessToken', token);
        }

        request = request.clone({
                params,
                headers
            });
       // }

        return next.handle(request);
    }
}
