import { Injectable } from '@angular/core';

@Injectable()
export class UserService {

    canLogout: boolean;
    isLogoff: boolean;
 
    constructor() {
        this.canLogout = true;
        this.isLogoff = false;
    }

    isAdmin() {
        let isAdmin;
        let user = JSON.parse(sessionStorage.getItem('user'));
        if (user) {
            let roles = user.roles;
            if (roles[0].toUpperCase() === 'ADMINISTRATOR') { isAdmin = true; }
            else { isAdmin = false; }
        }
        return isAdmin;
    }

    getRole() {
        let roleName;
        if (this.isAdmin() === true) {
            roleName = 'Admin';
        } else { roleName = 'Reviewer'; }
        return roleName;
    }

    getUser() {
        let user = JSON.parse(sessionStorage.getItem('user'));
        return user;
    }

    getUserDisplayName() {
        let user = JSON.parse(sessionStorage.getItem('user'));
        let userName;
        if (user) {
            userName = user.displayName;
        } else {
            userName = '';
        }
        return userName;
    }

    getUserLoginName() {
        let user = JSON.parse(sessionStorage.getItem('user'));
        let loginName;
        if (user) {
            loginName = user.userName;
        } else {
            loginName = '';
        }
        return loginName;
    }

    setUser(user: string) {
        sessionStorage.setItem('user', user);
    }
    
    deleteUser() {
        sessionStorage.removeItem('user');
    }

    isLoggedIn() {
        let isAuthenticated;
        let user = JSON.parse(sessionStorage.getItem('user'));
        if (user) {
            isAuthenticated = true;
        } else {
            isAuthenticated = false;
        }
        return isAuthenticated;
    }

    getToken() {
        let user = JSON.parse(sessionStorage.getItem('user'));
        let token = '';
        if (user) {
            token = user.token;
        }
        return token;
    }

}
