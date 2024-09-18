import { NgModule }  from '@angular/core';
import { RouterModule } from '@angular/router';

import { LoginGuard } from './shared/guards/login.guard';
import { AdminGuard } from './shared/guards/admin.guard';
import { UserService } from './services/app/user.service';
import { ConfirmationGuard } from './shared/guards/confirmation.guard';

import { AppNotFoundComponent } from './shared/components/app-not-found.component';
import { HomeComponent } from './home/home.component';
import { AboutComponent } from './about/about.component';

@NgModule({
    imports: [
        RouterModule.forRoot([
            { path: '', component: HomeComponent },
            { path: 'login', component: HomeComponent },
            { path: 'about', component: AboutComponent },
            // Resources
            {
                path: 'resources',
                loadChildren: () => import('./resources/resources.module').then(m => m.ResourcesModule),
                data: { preload: true }
            },
            // Settings
            {
                path: 'settings',
                loadChildren: () => import('./settings/settings.module').then(m => m.SettingsModule),
                data: { preload: true },
                canActivate: [LoginGuard]
            },
            // Reports
            {
                path: 'reports',
                loadChildren: () => import('./reports/reports.module').then(m => m.ReportsModule),
                data: { preload: true },
                canActivate: [LoginGuard]
            },
            { path: '**', component: AppNotFoundComponent }

        ])
    ],
    exports: [
        RouterModule
    ],
    providers: [
        LoginGuard,
        AdminGuard,
        UserService,
        ConfirmationGuard
    ]
})

export class AppRoutingModule { }
