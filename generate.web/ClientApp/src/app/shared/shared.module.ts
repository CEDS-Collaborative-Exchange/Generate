import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';


import { BreadcrumbsComponent } from './components/breadcrumbs.component';
import { PageTitleComponent } from './components/pagetitle.component';
import { LoginComponent } from './components/login.component';
import { OkDialogComponent } from './components/ok-dialog.component';
import { MatDialogModule } from '@angular/material/dialog';
import { NgIdleKeepaliveModule } from '@ng-idle/keepalive';
import { YesNoDialogComponent } from './components/yes-no-dialog.component';
import { ConfirmationDialogComponent } from './components/confirmationdialog.component';
import { PivottableComponent } from './components/pivottable/pivottable.component';

/* Pagination Module */
import { MatPaginatorModule } from '@angular/material/paginator';
import { DatepickerComponent } from './components/datepicker/datepicker.component';
import { ComboBoxComponent } from './components/combo-box/combo-box.component';
import { DialogComponent } from './components/dialog/dialog.component';
import { AutocompleteComponent } from './components/autocomplete/autocomplete.component';
import { FlextableComponent } from './components/flextable/flextable.component';
import { ReportLibraryTableComponent } from './components/report-library-table/report-library-table.component';

@NgModule({
    imports: [
        CommonModule,
        MatDialogModule,
        NgIdleKeepaliveModule.forRoot(),
        MatPaginatorModule,
        DatepickerComponent,
        ComboBoxComponent,
        DialogComponent,
        AutocompleteComponent,
        FlextableComponent,
        ReportLibraryTableComponent,

    ],
    declarations: [
        BreadcrumbsComponent,
        PageTitleComponent,
        LoginComponent,
        OkDialogComponent,
        YesNoDialogComponent,
        ConfirmationDialogComponent,
        PivottableComponent
    ],
    exports: [
        CommonModule,
        BreadcrumbsComponent,
        PageTitleComponent,
        LoginComponent,
        PivottableComponent,
        DatepickerComponent,
        ComboBoxComponent,
        DialogComponent,
        AutocompleteComponent,
        FlextableComponent,
        ReportLibraryTableComponent,

    ]
})
export class SharedModule { }
