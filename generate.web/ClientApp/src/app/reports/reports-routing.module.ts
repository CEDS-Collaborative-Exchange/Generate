import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

// Container
import { ReportsComponent } from './reports.component';

// Pages
import { ReportsSummaryComponent } from './summary/reports-summary.component';
import { ReportsEdfactsComponent } from './edfacts/reports-edfacts.component';
import { ReportsSppaprComponent } from './sppapr/reports-sppapr.component';
import { ReportsLibraryComponent } from './library/reports-library.component';
import { ReportsLibraryReportComponent } from './library/reports-library-report.component';

const featureRoutes: Routes = [

    {
        path: '',
        component: ReportsComponent,
        children: [
            { path: 'summary', component: ReportsSummaryComponent },
            { path: 'edfacts', component: ReportsEdfactsComponent },
            { path: 'sppapr', component: ReportsSppaprComponent },
            { path: 'library', component: ReportsLibraryComponent },
            { path: 'library/report', component: ReportsLibraryReportComponent },
        ]
    }

];

@NgModule({
    imports: [
        RouterModule.forChild(featureRoutes)
    ],
    exports: [
        RouterModule
    ]
})
export class ReportsRoutingModule { }
