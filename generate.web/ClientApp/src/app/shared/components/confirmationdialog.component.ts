import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject } from 'rxjs';

@Component({
    selector: 'generate-app-confirmationdialog',
    templateUrl: './confirmationdialog.component.html',
    styleUrls: ['./confirmationdialog.component.scss']
})
export class ConfirmationDialogComponent implements OnInit {

    title: string = ""
    message: string = ""

    public subject: Subject<boolean>;

    constructor(public dialogRef: MatDialogRef<ConfirmationDialogComponent>, @Inject(MAT_DIALOG_DATA) public data: ConfirmationDialogData) {}

    ngOnInit() {

        this.title = this.data.title
        this.message = this.data.message
    }

    closeDialog(answer: boolean) {
        if (this.subject) {
            this.subject.next(answer);
            this.subject.complete();
        }
        this.dialogRef.close(answer)
    }
}

export interface ConfirmationDialogData {

    title: string
    message: string
}
