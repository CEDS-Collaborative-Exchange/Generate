import { Injectable, Component } from '@angular/core';

import { Observable, Subject } from 'rxjs';
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { ConfirmationDialogComponent } from '../components/confirmationdialog.component';

export interface CanComponentDeactivate {
    canDecativate: () => Observable<boolean> | Promise<boolean> | boolean;
}

@Injectable()
export class ConfirmationGuard  {

    confirmDialog: MatDialogRef<ConfirmationDialogComponent>;

    constructor(
        private dialog: MatDialog
    ) { }


    canDeactivate(component: CanComponentDeactivate) {

        let ComponentCanDeactivate = component.canDecativate ? component.canDecativate() : true;
        const subject = new Subject<boolean>();

        if (ComponentCanDeactivate === true) {
            return true;
        } else {

            this.confirmDialog = this.dialog.open(ConfirmationDialogComponent,
                {
                    data: { title: "Confirm", message: "Changes have not been saved. To save your changes, click Cancel. To exit without saving, click OK." },
                    disableClose: true
                }
            );

            this.confirmDialog.componentInstance.subject = subject;
            return subject.asObservable();
            
        }
        
    }

}
