import { Component, Input, AfterViewInit, AfterViewChecked, Output } from '@angular/core';
import { UserService } from '../../services/app/user.service';
import { Router } from '@angular/router';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Idle, DEFAULT_INTERRUPTSOURCES } from '@ng-idle/core';
import { Keepalive } from '@ng-idle/keepalive';
import { MatDialog } from '@angular/material/dialog';
import { OkDialogComponent } from './ok-dialog.component';
import { AppConfig } from 'src/app/app.config';
import { YesNoDialogComponent } from './yes-no-dialog.component';
import { IAppConfig } from '../../models/app-config.model';
import { AuthService } from '../../services/app/auth.service';
import { from } from 'rxjs';

declare let componentHandler: any;

@Component({
    selector: 'generate-app-login',
    templateUrl: './login.component.html',
    styleUrls: ['./login.component.scss']
})


export class LoginComponent implements AfterViewInit, AfterViewChecked {

    isAuthenticating: boolean;
    isOAuth: boolean = false;

    public userService: UserService;
    public authService: AuthService;
    timeLeftSeconds: number
    timeLeftMinutes: number
    interval: any

    constructor(private http: HttpClient, private _userService: UserService,
        private _authService: AuthService, private _router: Router,
        private idle: Idle, private matDialog: MatDialog, private appConfig: AppConfig, private keepAlive: Keepalive) {

        this.isAuthenticating = false;

        this.userService = _userService;
        this.authService = _authService;
        this.userService.canLogout = true;
        this.userService.isLogoff = false;

        this.appConfig.getConfig().subscribe((res: IAppConfig) => {

            if (res.authType.toUpperCase() === 'OAUTH') {
                this.isOAuth = true;
            }

            idle.setIdle(res.timeoutInSeconds - 300)
            idle.setTimeout(300)
            idle.setInterrupts(DEFAULT_INTERRUPTSOURCES)

            this.timeLeftSeconds = res.timeoutInSeconds

            idle.onIdleStart.subscribe(() => {

                this.matDialog.open(OkDialogComponent, {

                    data: { title: "You are Idle", message: "Your session will timeout in 5 minutes. To avoid being logged out of Generate, click the Ok button." }
                })
            })

            idle.onIdleEnd.subscribe(() => {

                this.idle.watch()
            })

            idle.onTimeout.subscribe(() => {

                this.matDialog.open(OkDialogComponent, {

                    data: { title: "You have been Logged Out", message: "You have been logged out due to inactivity." }
                })

                let e: Event = new Event('E')
                this.logout(e)
            })

            idle.onInterrupt.subscribe(() => {
                this.timeLeftSeconds = res.timeoutInSeconds
                this.timeLeftMinutes = Math.floor(this.timeLeftSeconds / 60)
            })

            if (this.userService.isLoggedIn()) {
                this.startTimeoutWatch()
            }

        })
    }

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }

    ngAfterViewChecked() {
        componentHandler.upgradeAllRegistered();
    }

    loginAzure() {
        this.isAuthenticating = true;
        from(this.authService.login()).subscribe((resp) => {
            this.isAuthenticating = false;
            this.startTimeoutWatch();

            if (window.localStorage.getItem('lastUrl')) {


                let lastUrl = window.localStorage.getItem('lastUrl');

                let dialogRef = this.matDialog.open(YesNoDialogComponent, {
                    data: { title: "Previous Session Found", message: "Would you like to navigate to your last session?" }

                })
                dialogRef.afterClosed().subscribe((res) => {
                    if (res === 'yes') {
                        this._router.navigateByUrl(lastUrl);
                    }
                })

            }
        })

    }

    login(event, username, password) {

        event.preventDefault();

        if ((username.length > 0) && (password.length > 0)) {

            let body = JSON.stringify({ username, password });

            let headers = new HttpHeaders();
            headers = headers.set('Content-Type', 'application/json');

            this.isAuthenticating = true;

            this.http.post('api/users/Login', body, { headers: headers })
                .subscribe(
                    response => {
                        this.isAuthenticating = false;
                        this.getUser(response);
                        this.startTimeoutWatch();

                        if(window.localStorage.getItem('lastUrl')) {

                            let lastUrl = window.localStorage.getItem('lastUrl')

                            let dialogRef = this.matDialog.open(YesNoDialogComponent, {

                                data: {title: "Previous Session Found", message: "Would you like to navigate to your last session?"}
                            })
                
                            dialogRef.afterClosed().subscribe((res) => {
                
                                if(res === 'yes') {
                
                                    this._router.navigateByUrl(lastUrl);
                
                                } else {
                
                                    //Do Nothing
                                }
                            })
                        }
                    },
                    error => {

                        let snackbarContainer = document.querySelector('#generate-app-shared-login__error');

                        if (error.error) {
                            snackbarContainer['MaterialSnackbar'].showSnackbar(error.error);
                        } else {
                            let data = { message: 'Error occurred - ' + error.message };
                            snackbarContainer['MaterialSnackbar'].showSnackbar(data);
                        }
                        this.isAuthenticating = false;
                    }
                );
        } else {

            let snackbarContainer = document.querySelector('#generate-app-shared-login__error');
            let data = { message: 'UserName and Password are required.' };
            snackbarContainer['MaterialSnackbar'].showSnackbar(data);

        }

    }

    getUser(data) {
        if (data) {
            this.userService.setUser(JSON.stringify(data));
        }
    }

    logoutAzure() {
        
        from(this.authService.logout()).subscribe((resp) => {
            this.userService.deleteUser();
            this.stopTimeoutWatch();
        });

    }

    logout(event) {
        if (!this.isOAuth) {
            event.preventDefault();

            this.http.post('api/users/logOff', null)
                .subscribe(
                    response => {
                        this.userService.deleteUser();
                        this._router.navigateByUrl('/');
                        this.stopTimeoutWatch()
                    },
                    error => {
                        let snackbarContainer = document.querySelector('#generate-app-shared-login__error');

                        if (error.error) {
                            snackbarContainer['MaterialSnackbar'].showSnackbar(error.error);
                        } else {
                            let data = { message: 'Error occurred - ' + error.message };
                            snackbarContainer['MaterialSnackbar'].showSnackbar(data);
                        }
                    });

        } else {
            this.logoutAzure();
        }
    }

    startTimeoutWatch() {

        this.idle.watch()
        this.interval = window.setInterval(() => {

            this.timeLeftSeconds -= 1
            this.timeLeftMinutes = Math.floor(this.timeLeftSeconds / 60)

        }, 1000)
    }

    stopTimeoutWatch() {

        this.idle.stop()

        if(this.interval) {

            window.clearInterval(this.interval)
            this.interval = null
        }
    }
}
