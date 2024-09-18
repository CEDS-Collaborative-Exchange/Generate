
import { Component, OnInit, Input, Output, EventEmitter, ViewEncapsulation, SimpleChange } from '@angular/core';
import { FormControl, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { Observable } from 'rxjs';
import { map, startWith, debounceTime } from 'rxjs/operators';
import { AsyncPipe } from '@angular/common';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';

/**
 * @title Highlight the first autocomplete option
 */
@Component({
    selector: 'generate-app-autocomplete',
    templateUrl: 'autocomplete.component.html',
    styleUrl: 'autocomplete.component.css',
    standalone: true,
    encapsulation: ViewEncapsulation.None,
    imports: [
        FormsModule,
        MatFormFieldModule,
        MatInputModule,
        MatAutocompleteModule,
        ReactiveFormsModule,
        AsyncPipe,
    ],
})
export class AutocompleteComponent implements OnInit {
    myControl = new FormControl('');
    options: string[] = ['One', 'Two', 'Three'];
    filteredOptions: Observable<string[]>;

    @Input() itemsSource: any[];
    @Input() displayMemberPath: string;

    @Output() selectedIndexChanged = new EventEmitter<string>();

    selectedItem: any;
    _focus: boolean = false;

    @Input() selectedIndex: any;
    @Input() placeholder: string;


    ngOnInit() {
        this.filteredOptions = this.myControl.valueChanges.pipe(
            debounceTime(300),
            startWith(''),
            map(value => this._filter(value || '')),
        );
    }

    private _filter(value: string): string[] {
        console.log('Filter');
        this.options = [];
        let source = this.itemsSource;
        if (this.displayMemberPath && this.itemsSource) {
            let length = this.itemsSource.length;
            for (var i = 0; i < length; i++) {
                this.options.push(source[i][this.displayMemberPath]);
            }
        }
        else {
            this.options = this.itemsSource;
        }
        const filterValue = value.toLowerCase();

        return this.options.filter(option => option.toLowerCase().includes(filterValue));
    }

    ngOnChanges(changes: { [propName: string]: SimpleChange }) {
        this.filteredOptions = this.myControl.valueChanges.pipe(
            startWith(''),
            map(value => this._filter(value || '')),
        );

        
    }

    selectedChanged(event) {
        this.selectedItem = this.itemsSource.find(x => x[this.displayMemberPath] === event.option.value);
        this._focus = true;

        this.selectedIndexChanged.emit();
       // this.selectedItem = event.option.value;

    }
}
