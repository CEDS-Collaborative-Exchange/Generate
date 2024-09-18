import { Component, Inject, ElementRef, ContentChild, ViewChild, TemplateRef, Input, Injector } from '@angular/core';

import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { MatButtonModule } from '@angular/material/button';
import { FormsModule } from '@angular/forms';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { DomSanitizer, SafeHtml } from '@angular/platform-browser';

@Component({
    selector: 'generate-app-dialog',
    templateUrl: 'dialog.component.html',
    standalone: true,
    imports: [MatFormFieldModule, MatInputModule, FormsModule, MatButtonModule],
})
export class DialogComponent {
    //Not being used. Just to mimic the behavior.
    @Input() hideTrigger: string;
    @Input() width: any;
    constructor(public dialog: MatDialog, private elementRef: ElementRef, private sanitizer: DomSanitizer, private _injector: Injector) {

    }

    @ViewChild('contentTemplate', { read: TemplateRef }) templatePlaceholder!: TemplateRef<any>;

    show(): void {
        console.log('MyDialog');

        const dialogConfig = new MatDialogConfig();
        if(this.width) {
            dialogConfig.width = this.width;
        }
  //      dialogConfig.width = '800px';

        const dialogRef = this.dialog.open(this.templatePlaceholder, dialogConfig);
    }

    hide(): void {
        this.dialog.closeAll();
    }
}

