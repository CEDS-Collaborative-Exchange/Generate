export interface IAppConfig {
    env: {
        name: string;
        version: string;
    };
    timeoutInSeconds: number;
    pageSize: number;
    callService: boolean;
    authType: string,
    clientId: string,
    authority: string,
    redirectUri: string,
    // Show the username/password form alongside Azure AD login (requires the server's AllowPasswordLoginWithOAuth setting)
    allowPasswordLogin?: boolean
}
