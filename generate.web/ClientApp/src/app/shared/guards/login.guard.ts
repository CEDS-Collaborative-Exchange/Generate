import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { UserService } from '../../services/app/user.service';

@Injectable()
export class LoginGuard  {
    constructor(
        private _router: Router,
        private _UserService: UserService) { }

    canActivate() {
        if (this._UserService.isLoggedIn()) {
            return true;
        }

        this._router.navigateByUrl('/login');
        return false;
    }
}