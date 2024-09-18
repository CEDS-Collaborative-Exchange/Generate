import { Component, Input, Output, EventEmitter, SimpleChange, ViewChild } from '@angular/core';
import { Router, NavigationExtras } from '@angular/router';
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
    selector: 'generate-app-report-library-table',
    standalone: true,
    templateUrl: './report-library-table.component.html',
    styleUrl: './report-library-table.component.css',
    imports: [MatFormFieldModule, MatInputModule, MatTableModule, MatPaginatorModule, MatSortModule, MatCheckboxModule],
})
export class ReportLibraryTableComponent {

    @Input() itemsSource: any;
    @Input() headers: any[] = [];
    @Input() bindings: string[] = [];
    @Output() initialized = new EventEmitter<boolean>();
    @Input() callbackFunction: (reportCode: string, reportLevel:string) => void;
    @Input() saveTopicFunction: (dlg: any) => void;
    @Input() showDialogFunction: (dlg: any, dialogId: number, dialogType: string) => void;
    @Input() reportDialog: any;
    @Input() reportDialogId: number;

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
    constructor(private _router: Router, private _liveAnnouncer: LiveAnnouncer) {

    }

    ngOnInit() {

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
        var selectItem = this.displayedColumns.find(f => f.toLowerCase() == 'select');
        if (selectItem !== undefined) {
            reportData.forEach(f => {
                f.checked = false;
            });
        }
        this.dataSource = new MatTableDataSource(reportData);
        this.dataSource.paginator = this.paginator;
        this.dataSource.sort = this.sort;

        this.displayedHeaders = [];
        for (var i = 0; i < this.headers.length; i++) {
            this.displayedHeaders[this.bindings[i]] = this.headers[i];
        }
    }

    itemSelected(event) {
        var idx = this.selectedIds.findIndex(f => f == event.source.id);
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

    gotoReport(reportCode: string, reportLevel: string) {
        console.log("Callback function called");
        let navigationExtras: NavigationExtras = {
            queryParams: {
                'reportCode': reportCode,
                'reportLevel': reportLevel
            }
        };

        this._router.navigate(['/reports/library/report'], navigationExtras);
        return false;
    }

    showDialog(dlg: any, dialogId: number, dialogType: string) {
        this.showDialogFunction(dlg, dialogId, dialogType);
    }
    //
    saveTopic(dlg: any) {
        console.log("saveTopic");
    }

    ngAfterViewChecked() {
        if (this.downloading == true) {
            this.downloading = false;
            const table = document.getElementsByClassName('mat-mdc-table');
            const wb = XLSX.utils.table_to_book(table[0], { sheet: 'Generate Report' });
            const ws = wb.Sheets['Generate Report'];
            var wscols = [
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
            var wsrows = [
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

            var new_headers = [];
            new_headers.push('');
            new_headers.push(this.reportTitle);

            let captionStartCol = this.reportCaptionCol;
            let captionEndCol = this.reportCaptionCol + 1;
            ws["!merges"].push({ s: { r: 0, c: 1 }, e: { r: 0, c: 2 } });

            //Add report captions
            XLSX.utils.sheet_add_aoa(ws, [new_headers],
                { origin: "A1" });
            ws['B1'].s = { font: { bold: true, sz: 14 }, alignment: { horizontal: 'center', vertical: 'center', wrapText: true } };

            new_headers = [];
            new_headers.push('');

            new_headers.push(this.reportCaption2);
            ws["!merges"].push({ s: { r: 1, c: 1 }, e: { r: 1, c: 2 } });
            XLSX.utils.sheet_add_aoa(ws, [new_headers],
                { origin: "A2" });

            ws['B2'].s = { font: { bold: false }, alignment: { horizontal: 'center', vertical: 'center' } };

            new_headers = [];
            new_headers.push('');

            new_headers.push(this.reportCaption3);
            ws["!merges"].push({ s: { r: 2, c: 1 }, e: { r: 2, c: 2 } });
            XLSX.utils.sheet_add_aoa(ws, [new_headers],
                { origin: "A3" });

            ws['B3'].s = { font: { bold: true }, alignment: { horizontal: 'center', vertical: 'center' } };

            let dataRowHeight = this.reportRows[5] !== undefined ? this.reportRows[5] : { hpx: 25 };

            var colTotal = this.reportCols.length;
            let headerRowTotal = 4;
            var rowTotal = reportData.length + headerRowTotal;
            for (var i = 4; i <= rowTotal; i++) {
                ws['!rows'].push(dataRowHeight);
                for (var j = 0; j <= colTotal; j++) {
                    let cellRef = this.columnToLetter(j + 1) + (i + 1).toString();
                    var cell = ws[cellRef];

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

            XLSX.writeFile(wb, this.exportFile);
            $('.captionrow').remove();
            this.downloading = false;
            this.dataSource.paginator = this.paginator;
            this.dataSource.sort = this.sort;
        }

    }
    columnToLetter(column) {
        var temp, letter = '';
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
    exportToExcel(fileName, reportTitle, caption2, caption3, reportCols, reportRows, reportCaptionCol) {
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
