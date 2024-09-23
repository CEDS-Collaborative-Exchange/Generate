import { Component, Input, Output, EventEmitter, ViewEncapsulation } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatNativeDateModule } from '@angular/material/core';


@Component({
    selector: 'generate-app-datepicker',
    standalone: true,
    imports: [MatFormFieldModule, MatInputModule, MatDatepickerModule, MatNativeDateModule, MatIconModule],
    templateUrl: './datepicker.component.html',
    styleUrl: './datepicker.component.css',
    encapsulation: ViewEncapsulation.None
})
export class DatepickerComponent {
    @Input() value: Date;
    @Input() min: Date;
    @Input() max: Date;
    @Input() formControl: any;
    @Input() isChildCountFilter: boolean;

    @Output() valueChanged = new EventEmitter();

    startDate: Date;
    ngOnInit() {
        // Initialize Component
    }
    dateChange(event) {
        this.value = event.value;
        this.valueChanged.emit(event);
    }

    toggleDateFilter = (d: Date | null): boolean => {
        const month = (d || new Date()).getMonth() + 1;
        if (this.isChildCountFilter)
            // Only allow the month between Oct and Dec.
            return month >= 10 && month <= 12;
        else
            return true;
    };
}
