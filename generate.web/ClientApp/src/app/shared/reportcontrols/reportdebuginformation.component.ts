import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-reportdebuginformation',
  templateUrl: './reportdebuginformation.component.html',
  styleUrl: './reportdebuginformation.component.css'
})
export class ReportDebugInformationComponent {
    constructor(
        public dialogRef: MatDialogRef<ReportDebugInformationComponent>,
        @Inject(MAT_DIALOG_DATA) public data: any
    ) { }

    closeDialog(): void {
        this.dialogRef.close();
    }
}
