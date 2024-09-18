import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

// Container
import { SettingsComponent } from './settings.component';

// Pages
import { SettingsToggleComponent } from './toggle/toggle.component';
import { SettingsToggleAssessmentComponent } from './toggle/toggle-assessment.component';

import { SettingsDataStoreComponent } from './datastore/datastore.component';
import { ReportMigationComponent } from './datastore/reportmigration.component';
import { UpdateComponent } from './update/update.component';
import { ConfirmationGuard } from '../shared/guards/confirmation.guard';
import { MetadataComponent } from './metadata/metadata.component';

const featureRoutes: Routes = [

    {
        path: '', 
        component: SettingsComponent,
        children: [
            { path: 'toggle', component: SettingsToggleComponent, canDeactivate: [ConfirmationGuard] },
            { path: 'toggle/assessment', component: SettingsToggleAssessmentComponent },
            { path: 'metadata', component: MetadataComponent },
            { path: 'datamigration', component: ReportMigationComponent },
            { path: 'datamigration/reportmigration', component: ReportMigationComponent },
            { path: 'update', component: UpdateComponent }
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
export class SettingsRoutingModule { }
