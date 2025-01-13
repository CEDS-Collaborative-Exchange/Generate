import { NgModule } from '@angular/core';

import { ReactiveFormsModule } from '@angular/forms';


import { GuiGridModule } from '@generic-ui/ngx-grid';

// Shared
import { SharedModule } from '../shared/shared.module';

import { ToggleSectionFilter } from '../shared/filters/toggleSection.filter';
import { ToggleQuestionFilter } from '../shared/filters/toggleQuestion.filter';
import { ToggleQuestionTypeFilter } from '../shared/filters/toggleQuestionType.filter';
import { ToggleQuestionOptionFilter } from '../shared/filters/toggleQuestionOption.filter';
import { ToggleQuestionOtherOptionFilter } from '../shared/filters/toggleQuestionOtherOption.filter';
import { ToggleQuestionResponseFilter } from '../shared/filters/toggleQuestionResponse.filter';


import { UploadModule } from '../shared/components/upload/upload.module';

// Routing
import { SettingsRoutingModule } from './settings-routing.module';

// Containers
import { SettingsComponent } from './settings.component';

// Pages
import { SettingsToggleComponent } from './toggle/toggle.component';
import { SettingsToggleAssessmentComponent } from './toggle/toggle-assessment.component';

import { SettingsDataStoreComponent } from './datastore/datastore.component';
import { ODSMigationComponent } from './datastore/odsmigration.component';
import { RDSMigrationComponent } from './datastore/rdsmigration.component';
import { ReportMigationComponent } from './datastore/reportmigration.component';
import { UpdateComponent } from './update/update.component';
import { MetadataComponent } from './metadata/metadata.component';
import { MatDialogModule } from '@angular/material/dialog';
import { MatTabsModule } from '@angular/material/tabs';
import { MatIconModule } from '@angular/material/icon';
import { FormsModule } from '@angular/forms';

@NgModule({
    imports: [
        SharedModule,
        SettingsRoutingModule,
        ReactiveFormsModule,
        UploadModule,
        MatDialogModule,
        GuiGridModule,
        MatTabsModule,
        MatIconModule,
        FormsModule
    ],
    declarations: [
        SettingsComponent,
        SettingsToggleComponent,
        SettingsToggleAssessmentComponent,
        SettingsDataStoreComponent,
        ODSMigationComponent,
        RDSMigrationComponent,
        ReportMigationComponent,
        ToggleSectionFilter,
        ToggleQuestionFilter,
        ToggleQuestionTypeFilter,
        ToggleQuestionOptionFilter,
        ToggleQuestionOtherOptionFilter,
        ToggleQuestionResponseFilter,
        UpdateComponent,
        MetadataComponent
    ]
})
export class SettingsModule { }
