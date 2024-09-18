import { Component, EventEmitter, Output } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { DialogComponent } from './dialog/dialog.component';
import { UploadService } from './upload.service';

@Component({
  selector: 'app-upload',
  templateUrl: './upload.component.html',
  styleUrls: ['./upload.component.css']
})
export class UploadComponent {


    @Output() messageEvent = new EventEmitter<string>();

    constructor(public dialog: MatDialog, public uploadService: UploadService) { }

  public openUploadDialog() {
      let dialogRef = this.dialog.open(DialogComponent, { width: '50%', height: '50%' });

      dialogRef.afterClosed().subscribe(() => {
          console.log("dialog closed");
          this.messageEvent.emit("closed");
      });
  }
}
