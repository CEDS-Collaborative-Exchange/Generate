import { Injectable } from '@angular/core';
import { PublicClientApplication, AuthError } from '@azure/msal-browser';
import { UserService } from '../../services/app/user.service';
import { Idle, DEFAULT_INTERRUPTSOURCES } from '@ng-idle/core';
import { IAppConfig } from '../../models/app-config.model';
import { AppConfig } from '../../../app/app.config';

const msalConfig = {
    auth: {
        clientId: '5ace7c36-6029-404f-aff2-8f67e119995f',
        authority: 'https://login.microsoftonline.com/7a41925e-f697-4f7c-bec3-0470887ac752',
        redirectUri: 'https://localhost:44312'
    },
};

@Injectable({
    providedIn: 'root',
})
export class AuthService {
    private app: PublicClientApplication;
    private isMsalInitialized: boolean = false;
    public userService: UserService;

    

    constructor(private _userService: UserService, private appConfig: AppConfig) {

        this.userService = _userService;

        this.appConfig.getConfig().subscribe((res: IAppConfig) => {

            const msalConfig = {
                auth: {
                    clientId: res.clientId,
                    authority: res.authority,
                    redirectUri: res.redirectUri
                },
            };

            this.app = new PublicClientApplication(msalConfig);
            this.initializeMsal();


        })

       
    }

    private async initializeMsal(): Promise<void> {
        try {
            await this.app.initialize();
            await this.app.handleRedirectPromise();
            this.isMsalInitialized = true;
        } catch (error) {
            console.error('MSAL initialization error:', error);
        }
    }

    async login(): Promise<void> {
        if (!this.isMsalInitialized) {
            await this.initializeMsal();
        }

        try {
            const loginResponse = await this.app.loginPopup({
                scopes: ['openid', 'profile', 'User.Read'],
            });

            if (loginResponse && loginResponse.account.idTokenClaims !== null) {
                var data = {
                    userName: loginResponse.account.idTokenClaims.preferred_username,
                    givenName: loginResponse.account.idTokenClaims.given_name,
                    lastName: loginResponse.account.idTokenClaims.family_name,
                    displayName: loginResponse.account.name,
                    roles: loginResponse.account.idTokenClaims.roles,
                    token: loginResponse.accessToken
                }
                this.userService.setUser(JSON.stringify(data));

            }
        } catch (error) {
            if (error instanceof AuthError) {
                console.error('Authentication error:', error.errorMessage);
            } else {
                console.error('Unexpected error during login:', error);
            }
        }
    }

    async logout(): Promise<void> {
        //this.userService.deleteUser();
        this.app.logoutRedirect();
    }

    
}
