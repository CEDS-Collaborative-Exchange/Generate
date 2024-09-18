import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
    selector: 'generate-app-ok-dialog',
    templateUrl: './ok-dialog.component.html',
    styleUrls: ['./ok-dialog.component.scss']
})
export class OkDialogComponent implements OnInit {

    title: string = ""
    message: string = ""

    constructor(public dialogRef: MatDialogRef<OkDialogComponent>, @Inject(MAT_DIALOG_DATA) public data: OkDialogData) {}

    ngOnInit() {

        this.title = this.data.title
        this.message = this.data.message
    }

    closeDialog(answer: string) {

        this.dialogRef.close(answer)
    }
}

export interface OkDialogData {

    title: string
    message: string
}
