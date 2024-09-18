import { Component, Input, Output, EventEmitter, ViewChild, AfterViewInit, OnInit, OnChanges, ElementRef, SimpleChange, ViewEncapsulation } from '@angular/core';
import { FormControl } from '@angular/forms';
import { MatSelect } from '@angular/material/select';


import { FormsModule } from '@angular/forms';
import { MatInputModule } from '@angular/material/input';
import { MatSelectModule } from '@angular/material/select';
import { MatFormFieldModule } from '@angular/material/form-field';

@Component({
    selector: 'generate-app-combo-box',
    standalone: true,
    templateUrl: './combo-box.component.html',
    styleUrl: './combo-box.component.scss',
    imports: [MatFormFieldModule, MatSelectModule, MatInputModule, FormsModule],
    encapsulation: ViewEncapsulation.None

})
export class ComboBoxComponent {
    @Input() itemsSource: any[];
    @Input() width: string;
    @Input() selectedIndex: any;
    @Input() selectedValue: any;

    displayMemberPath: string;
    selectedValuePath: string;

    @Output() selectedIndexChanged = new EventEmitter<string>();
    @Output() isDroppedDownChanged = new EventEmitter<boolean>();
 

    selectedItem: any;
    
    _focus: any;
    providers = new FormControl();
    items: any[];
    selectWidth: string = '200';
    constructor(private el: ElementRef) {
        this.displayMemberPath = this.el.nativeElement.getAttribute('displayMemberPath');
        this.selectedValuePath = this.el.nativeElement.getAttribute('selectedValuePath');

        this.items = [];
    }

    ngOnInit() {
         let source = this.itemsSource;
        if (source !== undefined) {
            if (this.displayMemberPath) {
                for (var i = 0; i < source.length; i++) {
                    this.items.push(source[i][this.displayMemberPath]);
                }
            }
            else {
                this.items = this.itemsSource;
            }
        }

        if (this.items !== undefined && this.items.length > 0) {
            var selectedIdx = this.selectedIndex !== undefined ? this.selectedIndex : 0;
            this.selectedItem = source[selectedIdx];
            if (this.selectedValue !== undefined) {
                this.selectedItem = this.itemsSource.find(f => f[this.selectedValuePath] === this.selectedValue);
            }
        }
    }

    ngOnChanges(changes: { [propName: string]: SimpleChange }) {
        for (let prop in changes) {
            if (changes.hasOwnProperty(prop)) {
                if (this.itemsSource !== undefined) {
                    var selectedIdx = this.selectedIndex !== undefined ? this.selectedIndex : 0;
                    this.selectedItem = this.itemsSource[selectedIdx];
                }
            }
        }
    }

    ngAfterViewInit() {

    }

    selectedChanged(event) {
        this.selectedIndexChanged.emit(this.selectedItem);
        this.isDroppedDownChanged.emit(this.selectedItem);

        if (this.selectedValuePath) {
            this.selectedValue = event.value[this.selectedValuePath];
        }
        else {
            this.selectedValue = event.value;
        }
        console.log(event.value);
    }

    onInputChange(event: any) {
        const searchInput = event.target.value.toLowerCase();
    }

    /**
     * Method to be executed when focus is triggered
     **/
    openAndSearch(field: MatSelect, input: HTMLSelectElement) {
        this._focus = true;

    }

}
