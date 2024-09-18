import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
    selector: 'generate-app-yes-no-dialog',
    templateUrl: './yes-no-dialog.component.html',
    styleUrls: ['./yes-no-dialog.component.scss']
})
export class YesNoDialogComponent implements OnInit {

    title: string = ""
    message: string = ""

    constructor(public dialogRef: MatDialogRef<YesNoDialogComponent>, @Inject(MAT_DIALOG_DATA) public data: YesNoDialogData) {}

    ngOnInit() {

        this.title = this.data.title
        this.message = this.data.message
    }

    closeDialog(answer: string) {

        this.dialogRef.close(answer)
    }
}

export interface YesNoDialogData {

    title: string
    message: string
}
