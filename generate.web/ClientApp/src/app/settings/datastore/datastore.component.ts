import { Component, Input, AfterViewInit, OnInit, OnChanges, SimpleChange, ViewChild, ViewChildren, QueryList, ElementRef, NgZone } from '@angular/core';
import { Router } from '@angular/router';

import { DataMigrationService } from '../../services/app/dataMigration.service';

@Component({
    selector: 'generate-app-settings-datastore',
    templateUrl: './datastore.component.html',
    styleUrls: ['./datastore.component.scss'],
    providers: [DataMigrationService]

})
export class SettingsDataStoreComponent  {

    @ViewChild('comboReportYear', { static: false }) comboReportYear: any;
    errorMessage: string;
    constructor(
        private _router: Router,
        private _dataMigrationService: DataMigrationService

    ) {

    }

    gotoMigration(migrationType: string) {

        this._router.navigate(['/settings/datastore/' + migrationType]);
    
        return false;
    }

}
