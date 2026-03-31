import { Component, Input, Output, EventEmitter, SimpleChange, ViewChild } from '@angular/core';
import { MatTableModule, MatTableDataSource, MatTable } from '@angular/material/table';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatPaginator, MatPaginatorModule } from '@angular/material/paginator';
import { MatSort, Sort, MatSortModule } from '@angular/material/sort';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { LiveAnnouncer } from '@angular/cdk/a11y';

import { GenerateReportDataDto } from '../../../models/app/generateReportDataDto';
import * as XLSX from '../../../../lib/xlsx-js-style/xlsx.js'
import * as $ from 'jquery';

@Component({
    selector: 'generate-app-table',
    styleUrl: 'flextable.component.css',
    templateUrl: 'flextable.component.html',
    standalone: true,
    imports: [MatFormFieldModule, MatInputModule, MatTableModule, MatPaginatorModule, MatSortModule, MatCheckboxModule],
})
export class FlextableComponent {
    @Input() itemsSource: any;
    @Input() headers: any[] = [];
    @Input() bindings: string[] = [];
    @Output() initialized = new EventEmitter<boolean>();

    displayedColumns: any[] = [];
    displayedHeaders: any[] = [];

    dataSource: any;
    @ViewChild(MatPaginator) paginator: MatPaginator;
    @ViewChild(MatSort) sort: MatSort;
    @ViewChild(MatTable) table: MatTable<any>;

    selectedIds: string[] = [];
    downloading: boolean;

    filterValue: string;
    private _toFilter: any;

    exportFile: string;
    reportTitle: string;
    reportCaption2: string;
    reportCaption3: string;
    reportCols: any[] = [];
    reportRows: any[] = [];
    reportCaptionCol: number
    constructor(private _liveAnnouncer: LiveAnnouncer) { }
    ngOnInit() {
        // Initialize Component
    }
    ngAfterViewInit() {
        if (this.dataSource !== null && this.dataSource !== undefined) {
            this.dataSource.paginator = this.paginator;
            this.dataSource.sort = this.sort;
        }
    }
    announceSortChange(sortState: Sort) {
        if (sortState.direction) {
            this._liveAnnouncer.announce(`Sorted ${sortState.direction}ending`);
        } else {
            this._liveAnnouncer.announce('Sorting cleared');
        }
    }
    ngOnChanges(changes: { [propName: string]: SimpleChange }) {
        for (let prop in changes) {
            if (changes.hasOwnProperty(prop)) {
               /* console.log('flextable');*/
                this.populateReport();
            }
        }
    }
    populateReport() {
        if (this.itemsSource == null)
            return;

        let reportData = null;
        if (!Array.isArray(this.itemsSource)) {
            reportData = this.itemsSource.data;
        }
        else {
            reportData = this.itemsSource;
        }

        this.displayedColumns = this.bindings
        let selectItem = this.displayedColumns.find(f => f.toLowerCase() == 'select');
        if (selectItem !== undefined) {
            reportData.forEach(f => {
                f.checked = false;
            });
        }
        this.dataSource = new MatTableDataSource(reportData);
        this.dataSource.paginator = this.paginator;
        this.dataSource.sort = this.sort;

        this.displayedHeaders = [];
        for (let i = 0; i < this.headers.length; i++) {
            this.displayedHeaders[this.bindings[i]] = this.headers[i];
        }
    }

    itemSelected(event) {
        let idx = this.selectedIds.findIndex(f => f == event.source.id);
        if (event.checked) {
            if (idx === -1)
                this.selectedIds.push(event.source.id);
        }
        else {
            if (idx !== -1)
                this.selectedIds.splice(idx, 1);
        }
        this.initialized.emit(true);
    }

    ngAfterViewChecked() {
        if (this.downloading == true) {
            this.downloading = false;
            const table = document.getElementsByClassName('mat-mdc-table');
            const wb = XLSX.utils.table_to_book(table[0], { sheet: 'Generate Report' });
            const ws = wb.Sheets['Generate Report'];
            let wscols = [
                { wpx: 250 },
                { wpx: 250 },
                { wpx: 400 },
                { wpx: 400 }
            ];
            if (this.reportCols !== undefined) {
                ws['!cols'] = this.reportCols;
            } else {
                ws['!cols'] = wscols;
            }


            let reportData = null;
            if (!Array.isArray(this.itemsSource)) {
                reportData = this.itemsSource.data;
            }
            else {
                reportData = this.itemsSource;
            }
            let wsrows = [
                { hpx: 25 }, // row 1 sets to the height of pixels
                { hpx: 23 },
                { hpx: 20 },
                { hpx: 20 },
                { hpx: 25 }
            ];
            reportData.forEach(f => {
                wsrows.push({ hpx: 23 });
            })

            if (this.reportRows !== undefined) {
                ws['!rows'] = this.reportRows;
            } else {
                ws['!rows'] = wsrows;
            }


            if (ws["!merges"] === undefined)
                ws["!merges"] = [];

            let new_headers = [];
            //new_headers.push('');
            new_headers.push(this.reportTitle);

            let captionStartCol = this.reportCaptionCol;
            let captionEndCol = this.reportCaptionCol + 1;
            const lastCellIdx:number = this.headers.length -1;
            ws["!merges"].push({ s: { r: 0, c: 0 }, e: { r: 0, c:lastCellIdx  } });

            //Add report captions
            XLSX.utils.sheet_add_aoa(ws, [new_headers],
                { origin: "A1" });
            ws['A1'].s = { font: { bold: true, sz: 14 }, alignment: { horizontal: 'center', vertical: 'center', wrapText: true } };
            //ws['!cols'][0] = { wch: (this.reportTitle.length + 10) };
            ws['!rows'] = ws['!rows'] || [];
            ws['!rows'][0] = { hpx: 25 }; // row height
            new_headers = [];
            //new_headers.push('');

            new_headers.push(this.reportCaption2);
            ws["!merges"].push({ s: { r: 1, c: 0 }, e: { r: 1, c: lastCellIdx } });
            XLSX.utils.sheet_add_aoa(ws, [new_headers],
                { origin: "A2" });

            ws['A2'].s = { font: { bold: false }, alignment: { horizontal: 'center', vertical: 'center' } };

            new_headers = [];
            //new_headers.push('');

            new_headers.push(this.reportCaption3);
            ws["!merges"].push({ s: { r: 2, c: 0 }, e: { r: 2, c: lastCellIdx } });
            XLSX.utils.sheet_add_aoa(ws, [new_headers],
                { origin: "A3" });

            ws['A3'].s = { font: { bold: true }, alignment: { horizontal: 'center', vertical: 'center' } };

            let dataRowHeight = this.reportRows[5] !== undefined ? this.reportRows[5] : { hpx: 25 };

            let colTotal = this.reportCols.length;
            let headerRowTotal = 4;
            let rowTotal = reportData.length + headerRowTotal;
            for (let i = 4; i <= rowTotal; i++) {
                ws['!rows'].push(dataRowHeight);
                for (let j = 0; j <= colTotal; j++) {
                    let cellRef = this.columnToLetter(j + 1) + (i + 1).toString();
                    let cell = ws[cellRef];

                    if (cell !== undefined) {
                        if (i == 4) {
                            cell.s = {
                                font: { bold: true, sz: 12 }
                                , fill: { fgColor: { rgb: 'd8dede' } }
                                , alignment: { horizontal: 'left', vertical: 'center', wrapText: true }
                                , border: {
                                    top: { style: 'thin', color: { rgb: 'd3d3d3' } }
                                    , bottom: { style: 'thin', color: { rgb: 'd3d3d3' } }
                                    , left: { style: 'thin', color: { rgb: 'd3d3d3' } }
                                    , right: { style: 'thin', color: { rgb: 'd3d3d3' } }
                                }
                            };
                        }
                        else {
                            if (cell.t === 'z') {
                                cell.t = 's';
                            }
                            if (i % 2 == 0) {
                                cell.s = {
                                    fill: { fgColor: { rgb: 'e6eeee' } }
                                    , alignment: { horizontal: 'left', vertical: 'center', wrapText: true }
                                    , border: {
                                        top: { style: 'thin', color: { rgb: 'd3d3d3' } }
                                        , bottom: { style: 'thin', color: { rgb: 'd3d3d3' } }
                                        , left: { style: 'thin', color: { rgb: 'd3d3d3' } }
                                        , right: { style: 'thin', color: { rgb: 'd3d3d3' } }
                                    }
                                };
                            } else {
                                cell.s = {
                                    alignment: { horizontal: 'left', vertical: 'center', wrapText: true }
                                    , border: {
                                        top: { style: 'thin', color: { rgb: 'd3d3d3' } }
                                        , bottom: { style: 'thin', color: { rgb: 'd3d3d3' } }
                                        , left: { style: 'thin', color: { rgb: 'd3d3d3' } }
                                        , right: { style: 'thin', color: { rgb: 'd3d3d3' } }
                                    }
                                };
                            }

                        }
                    }
                }
            }


            /**
             * Aligns the header
             * @param rowNum(number) generally header is on row 5, row index 4
             */
            const fixHeaderStyles = (rowNum:number) => {
                // header columns to be left aligned
                let colIncreased = false;
                // dictionary with header name as key and value as same
                const headerMap = {};
                let finalHeaderRowPixel = 0;
                let finalHeaderColSizeInChar = 0 ;
                this.headers.forEach(headerColVal => {
                    headerMap[headerColVal] = headerColVal;
                    // const rowPixel = (Math.ceil(row.length / 15) * 10);
                    //const rowPixel = row.length * 7;
                    // set the highest pixel for the row
                    // finalHeaderRowPixel = rowPixel> finalHeaderColSizeInChar ? rowPixel : finalHeaderRowPixel;

                });
                for ( let colCount = 0; colCount< this.headers.length; colCount++) {
                    let cellRef = this.columnToLetter(colCount + 1) + (rowNum+1).toString();
                    let cell = ws[cellRef];

                    if(cell && headerMap[cell.v]){
                        //cell.wch = 10;//cell.v?.length + 1;
                        const fontObj = {...cell.font || {}, bold : true};
                        cell.s = {...cell.s, font : fontObj, alignment: {...cell.s.alignment || {}, horizontal: 'left',vertical: 'top' } };

                    }

                }
            };
            //fix header row which is row index 4
            fixHeaderStyles(4);

            // This sets the column width based on title's length divided by  how many headers column are available
            if (this.headers && this.headers.length) {
                ws['!cols'] = this.headers.map(header => ({
                   // eg if title text length is 100 and total 4 headers ,each column length will be (110)/4
                    wch : (this.reportTitle.length + 10) / this.headers.length,
                }));
            }
            // all column data as left alignment
            for (let i = 5; i <= rowTotal; i++) {
                for (let j = 0; j <= this.headers.length; j++) {
                    let cellRef = this.columnToLetter(j + 1) + (i + 1).toString();
                    let cell = ws[cellRef];
                    if (cell !== undefined) {
                        cell.s = {
                            ...cell.s,
                            alignment: { ...cell.s?.alignment, horizontal: 'left', vertical: 'center', wrapText: true }
                        };
                    }
                }
            }

            XLSX.writeFile(wb, this.exportFile);
            $('.captionrow').remove();
            this.downloading = false;
            this.dataSource.paginator = this.paginator;
            this.dataSource.sort = this.sort;
        }

    }
    columnToLetter(column) {
        let temp, letter = '';
        while (column > 0) {
            temp = (column - 1) % 26;
            letter = String.fromCharCode(temp + 65) + letter;
            column = (column - temp - 1) / 26;
        }

        return letter;
    }
    applyFilter(event: Event) {
        const filterValue = (event.target as HTMLInputElement).value;
        if (this.filterValue !== filterValue) {
            this.filterValue = filterValue;
            if (this._toFilter) {
                clearTimeout(this._toFilter);
            }
            let self = this;
            this._toFilter = setTimeout(function () {
                self.dataSource.filter = filterValue.trim().toLowerCase();
            }, 200);


        }

    }
    exportToExcel(fileName, reportTitle, caption2, caption3, reportCols, reportRows, reportCaptionCol,categorySetName:string = '') {
        console.log('completed');
        if (this.itemsSource == null)
            return;

        this.exportFile = fileName;
        this.reportTitle = reportTitle;
        this.reportCaption2 = caption2;
        this.reportCaption3 = caption3;
        this.reportCols = reportCols;
        this.reportRows = reportRows;
        this.reportCaptionCol = reportCaptionCol;

        let reportData = null;
        if (!Array.isArray(this.itemsSource)) {
            reportData = this.itemsSource.data;
        }
        else {
            reportData = this.itemsSource;
        }

        $('.mat-mdc-table thead').prepend('<tr class="captionrow"><td></td></tr><tr class="captionrow"><td></td></tr><tr class="captionrow"><td></td></tr><tr class="captionrow"><td></td></tr>');

        this.downloading = true;
        this.dataSource = new MatTableDataSource(reportData);
        this.table.renderRows();
    }
}
