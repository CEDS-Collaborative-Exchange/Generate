import { Component, Input, AfterViewInit, OnInit, OnChanges, SimpleChange, ViewChild, ViewChildren, QueryList, ElementRef, NgZone } from '@angular/core';
import { Router } from '@angular/router';

import { GenerateReportService } from '../../services/app/generateReport.service';
import { GenerateReport } from '../../models/app/generateReport';
import { GenerateReportDto } from '../../models/app/generateReportDto';
import { GenerateReportDataDto } from '../../models/app/generateReportDataDto';
import { OrganizationLevelDto } from '../../models/app/organizationLevelDto';
import { CategoryOptionDto } from '../../models/app/categoryOptionDto';
import { GenerateReportParametersDto } from '../../models/app/generateReportParametersDto';
import { CategorySetDto } from '../../models/app/categorySetDto';

import { FlextableComponent } from '../components/flextable/flextable.component';

declare let componentHandler: any;
declare let saveAs: any;
declare let alphanum: any;

@Component({
    selector: 'generate-app-c029',
    templateUrl: './c029.component.html',
    styleUrls: ['./c029.component.scss'],
    providers: [GenerateReportService]
})

export class c029Component implements AfterViewInit, OnChanges, OnInit {

    public errorMessage: string;

    @Input() reportParameters: GenerateReportParametersDto;
    @ViewChild(FlextableComponent) flextableComponent: FlextableComponent;

    public isLoading: boolean = false;
    public isPending: boolean = false;
    public hasRecords: boolean = false;
    public reportDataDto: GenerateReportDataDto;
    public generateFile: GenerateReport;
    public stateName: string = null;

    public formatToGenerate: string = '';
    public entity: any;

    constructor(
        private _router: Router,
        private _generateReportService: GenerateReportService,
        private _ngZone: NgZone
    ) {

    }


    ngOnInit() {
        this.populateReport();
    }

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();

    }

    ngOnChanges(changes: { [propName: string]: SimpleChange }) {
        for (let prop in changes) {
            if (changes.hasOwnProperty(prop)) {
                this.populateReport();
            }
        }
    }


    populateReport() {

        console.log('populate c029');
        console.log('Report Level is: ' + this.reportParameters.reportLevel + ' ' + this.reportParameters.reportYear + ' ' + this.reportParameters.reportCode + ' ' + this.reportParameters.reportCategorySetCode);


        if (this.reportParameters.reportType !== undefined
            && this.reportParameters.reportCode !== undefined
            && this.reportParameters.reportLevel !== undefined
            && this.reportParameters.reportYear !== undefined) {


            this.isLoading = true;
            this.entity = null;

            // Retrieve all data
            let take = 0;
            let skip = 0;

            if (this.reportParameters.reportSort === undefined) {
                this.reportParameters.reportSort = 1;
            }

            let categorySetCode: string = 'null';
            if (this.reportParameters.reportCategorySetCode !== undefined) {
                categorySetCode = this.reportParameters.reportCategorySetCode
            }

            let reportLea: string = 'null';
            if (this.reportParameters.reportLea !== undefined) {
                reportLea = this.reportParameters.reportLea;
            }

            let reportSchool: string = 'null';
            if (this.reportParameters.reportSchool !== undefined) {
                reportSchool = this.reportParameters.reportSchool;
            }


            this._generateReportService.getReport(this.reportParameters.reportType, this.reportParameters.reportCode, this.reportParameters.reportLevel, this.reportParameters.reportYear, categorySetCode, this.reportParameters.reportSort, skip, take)
                .subscribe(
                    reportDataDto => {

                        this.reportDataDto = reportDataDto;

                        if (this.reportParameters.reportLevel !== 'sea') {
                            let organizationIdentifier: string = ''
                            if (this.reportParameters.reportLevel === 'lea') {
                                organizationIdentifier = reportLea;
                            } else if (this.reportParameters.reportLevel === 'sch') {
                                organizationIdentifier = reportSchool;
                            }

                            this.entity = this.reportDataDto.data.filter(s => { return s.organizationStateId === organizationIdentifier })[0];
                        } else if (this.reportDataDto !== undefined && this.reportDataDto !== null && this.reportDataDto.data !== null && this.reportDataDto.data !== undefined) {
                            this.entity = this.reportDataDto.data[0];
                        }

                        if (this.entity !== undefined) {
                            this.stateName = this.entity.stateName;
                        }

                        this.getAddresses(this.reportDataDto, 'physical');
                        this.getAddresses(this.reportDataDto, 'mailing');

                        if (this.reportDataDto === null || this.reportDataDto === undefined) {
                            this.errorMessage = 'Invalid Report';
                        } else {

                            if (this.reportDataDto.dataCount > 0) { this.hasRecords = true; }
                            else { this.hasRecords = false; }

                        }

                        this.isLoading = false;

                        this._generateReportService.getSubmissionReport(this.reportParameters.reportType, this.reportParameters.reportCode)
                            .subscribe(
                                data => {
                                    this.generateFile = data;
                                },
                                error => this.errorMessage = <any>error);

                    },
                    error => this.errorMessage = <any>error);


        }
    }

    getAddress(addressType: string) {
        let address: string = '';

        if (addressType === 'mailing') {
            if (this.entity.mailingAddressStreet !== null) {
                address = this.entity.mailingAddressStreet;
            }

            if (this.entity.mailingAddressApartmentRoomOrSuiteNumber !== null) {
                if (address.length > 0) { address = address + ', '; }
                address = address + this.entity.mailingAddressApartmentRoomOrSuiteNumber;
            }

            if (this.entity.mailingAddressCity !== null) {
                if (address.length > 0) { address = address + ', '; }
                address = address + this.entity.mailingAddressCity;
            }
            if (this.entity.mailingAddressState !== null) {
                if (address.length > 0) { address = address + ', '; }
                address = address + this.entity.mailingAddressState;
            }
            if (this.entity.mailingAddressPostalCode !== null) {

                if (address.length > 0) { address = address + ', '; }
                address = address + this.entity.mailingAddressPostalCode;
                if (this.entity.mailingAddressPostalCode2.trim().length > 0) {
                    address = address + '-' + this.entity.mailingAddressPostalCode2;
                }
            }

        } else {
            if (this.entity.physicalAddressStreet !== null) {
                address = this.entity.physicalAddressStreet;
            }
            if (this.entity.physicalAddressApartmentRoomOrSuiteNumber !== null) {
                if (address.length > 0) { address = address + ', '; }
                address = address + this.entity.physicalAddressApartmentRoomOrSuiteNumber;
            }
            if (this.entity.physicalAddressCity !== null) {
                if (address.length > 0) { address = address + ', '; }
                address = address + this.entity.physicalAddressCity;
            }
            if (this.entity.physicalAddressState !== null) {
                if (address.length > 0) { address = address + ', '; }
                address = address + this.entity.physicalAddressState;
            }
            if (this.entity.physicalAddressPostalCode !== null) {

                if (address.length > 0) { address = address + ', '; }
                address = address + this.entity.physicalAddressPostalCode;
                if (this.entity.physicalAddressPostalCode2.trim().length > 0) {
                    address = address + '-' + this.entity.physicalAddressPostalCode2;
                }
            }
        }

        return address;
    }

    getAddresses(reportDto: GenerateReportDataDto, addressType: string) {
        let address: string = '';
        reportDto.data.forEach(element => {
            if (addressType === 'mailing') {
                if (element.mailingAddressStreet !== null) {
                    address = element.mailingAddressStreet;
                }

                if (element.mailingAddressApartmentRoomOrSuiteNumber !== null) {
                    if (address.length > 0) { address = address + ', '; }
                    address = address + element.mailingAddressApartmentRoomOrSuiteNumber;
                }

                if (element.mailingAddressCity !== null) {
                    if (address.length > 0) { address = address + ', '; }
                    address = address + element.mailingAddressCity;
                }
                if (element.mailingAddressState !== null) {
                    if (address.length > 0) { address = address + ', '; }
                    address = address + element.mailingAddressState;
                }
                if (element.mailingAddressPostalCode !== null) {

                    if (address.length > 0) { address = address + ', '; }
                    address = address + element.mailingAddressPostalCode;
                    if (element.mailingAddressPostalCode2.trim().length > 0) {
                        address = address + '-' + element.mailingAddressPostalCode2;
                    }
                }

                element.physicaladdress = address;
            }
            else {
                if (element.physicalAddressStreet !== null) {
                    address = element.physicalAddressStreet;
                }
                if (element.physicalAddressApartmentRoomOrSuiteNumber !== null) {
                    if (address.length > 0) { address = address + ', '; }
                    address = address + element.physicalAddressApartmentRoomOrSuiteNumber;
                }
                if (element.physicalAddressCity !== null) {
                    if (address.length > 0) { address = address + ', '; }
                    address = address + element.physicalAddressCity;
                }
                if (element.physicalAddressState !== null) {
                    if (address.length > 0) { address = address + ', '; }
                    address = address + element.physicalAddressState;
                }
                if (element.physicalAddressPostalCode !== null) {

                    if (address.length > 0) { address = address + ', '; }
                    address = address + element.physicalAddressPostalCode;
                    if (element.physicalAddressPostalCode2.trim().length > 0) {
                        address = address + '-' + element.physicalAddressPostalCode2;
                    }
                }

                element.mailingaddress = address;
            }
        });


        //if (addressType === 'mailing') {
        //    if (this.entity.mailingAddressStreet !== null) {
        //        address = this.entity.mailingAddressStreet;
        //    }

        //    if (this.entity.mailingAddressApartmentRoomOrSuiteNumber !== null) {
        //        if (address.length > 0) { address = address + ', '; }
        //        address = address + this.entity.mailingAddressApartmentRoomOrSuiteNumber;
        //    }

        //    if (this.entity.mailingAddressCity !== null) {
        //        if (address.length > 0) { address = address + ', '; }
        //        address = address + this.entity.mailingAddressCity;
        //    }
        //    if (this.entity.mailingAddressState !== null) {
        //        if (address.length > 0) { address = address + ', '; }
        //        address = address + this.entity.mailingAddressState;
        //    }
        //    if (this.entity.mailingAddressPostalCode !== null) {

        //        if (address.length > 0) { address = address + ', '; }
        //        address = address + this.entity.mailingAddressPostalCode;
        //        if (this.entity.mailingAddressPostalCode2.trim().length > 0) {
        //            address = address + '-' + this.entity.mailingAddressPostalCode2;
        //        }
        //    }

        //} else {
        //    if (this.entity.physicalAddressStreet !== null) {
        //        address = this.entity.physicalAddressStreet;
        //    }
        //    if (this.entity.physicalAddressApartmentRoomOrSuiteNumber !== null) {
        //        if (address.length > 0) { address = address + ', '; }
        //        address = address + this.entity.physicalAddressApartmentRoomOrSuiteNumber;
        //    }
        //    if (this.entity.physicalAddressCity !== null) {
        //        if (address.length > 0) { address = address + ', '; }
        //        address = address + this.entity.physicalAddressCity;
        //    }
        //    if (this.entity.physicalAddressState !== null) {
        //        if (address.length > 0) { address = address + ', '; }
        //        address = address + this.entity.physicalAddressState;
        //    }
        //    if (this.entity.physicalAddressPostalCode !== null) {

        //        if (address.length > 0) { address = address + ', '; }
        //        address = address + this.entity.physicalAddressPostalCode;
        //        if (this.entity.physicalAddressPostalCode2.trim().length > 0) {
        //            address = address + '-' + this.entity.physicalAddressPostalCode2;
        //        }
        //    }
        //}

        return address;
    }
    getCSSO() {
        let cssoInfo: string = '';
        if (this.getReportYearAsInt() < 2023) {
            if (this.entity.cssoFirstName !== null) {
                cssoInfo = this.entity.cssoFirstName;
            }
            if (this.entity.cssoLastName !== null) {
                cssoInfo = cssoInfo + ' ' + this.entity.cssoLastName;
            }
            if (this.entity.cssoTitle !== null) {
                cssoInfo = cssoInfo + '<br/> ' + this.entity.cssoTitle;
            }
            if (this.entity.cssoTelephone !== null) {
                cssoInfo = cssoInfo + '<br/> ' + this.entity.cssoTelephone;
            }
            if (this.entity.cssoEmail !== null) {
                cssoInfo = cssoInfo + '<br/> ' + this.entity.cssoEmail;
            }
        }
        return cssoInfo;
    }

    getReportYearAsInt() {
        return parseInt(this.reportDataDto.reportYear);
    }

    getReportYear() {
        if (this.reportDataDto.reportYear === '2016-17' || this.reportDataDto.reportYear === '2015-16' || this.reportDataDto.reportYear === '2014-15' || this.reportDataDto.reportYear === '2013-14')
            return true
        else
            return false;
    }

    getDefaultCategorySet(categorySets: Array<CategorySetDto>) {

        if (categorySets === undefined || categorySets.length === 0) {
            return null;
        }

        function compare(a: CategorySetDto, b: CategorySetDto) {
            if (a.categorySetName < b.categorySetName)
                return -1;
            if (a.categorySetName > b.categorySetName)
                return 1;
            return 0;
        }

        categorySets.sort(compare);

        return categorySets[0];
    }

    dataCountCaption() {

        if (this.reportParameters.reportLevel === 'lea') {
            return 'Total LEAs: ';
        } else if (this.reportParameters.reportLevel === 'sch') {
            return 'Total Schools: ';
        } else {
            return 'Total: ';
        }
    }


    setReportPage(event, reportPage: number) {
        if (this.reportParameters.reportPage !== reportPage) {
            this.reportParameters.reportPage = reportPage;
            this.populateReport();
        }
        return false;
    }

    export() {

        let self = this;
        let cellColspan = 10;

        let sheetName = this.reportParameters.reportCode.toUpperCase();
        let fileName = this.reportParameters.reportCode.toUpperCase() + ' - ' + this.reportParameters.reportYear + ' - ' + this.reportParameters.reportLevel.toUpperCase();

        if (this.reportParameters.reportCategorySet !== undefined) {
            fileName += ' - ' + this.reportParameters.reportCategorySet.categorySetName.replace('?', '');
        }

        fileName += ".xlsx";

        let reportTitle = this.reportDataDto.reportTitle;
        let statetCaption = this.reportDataDto.data[0].stateName;
        let totalCaption = this.dataCountCaption() + " " + this.reportDataDto.dataCount;

        let reportCaptionCol = 2;
        let reportCols = [];
        if (this.reportParameters.reportLevel === 'sea') {
            reportCols.push({ wpx: 250 });
            reportCols.push({ wpx: 100 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 100 });
            reportCols.push({ wpx: 200 });
            reportCols.push({ wpx: 200 });
            reportCols.push({ wpx: 200 });
        } else if (this.reportParameters.reportLevel === 'lea') {
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 250 });
            reportCols.push({ wpx: 200 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 200 });
            reportCols.push({ wpx: 200 });
            reportCaptionCol = 4;
        } else if (this.reportParameters.reportLevel === 'sch') {
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 250 });
            reportCols.push({ wpx: 200 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 150 });
            reportCols.push({ wpx: 200 });
            reportCols.push({ wpx: 200 });
            reportCols.push({ wpx: 100 });
            reportCols.push({ wpx: 100 });
            reportCols.push({ wpx: 100 });
            reportCols.push({ wpx: 100 });
            reportCols.push({ wpx: 100 });
            reportCols.push({ wpx: 100 });
            reportCols.push({ wpx: 200 });
            reportCols.push({ wpx: 200 });
            reportCols.push({ wpx: 200 });
        }

        let reportRows = [
            { hpx: 25 }, // row 1 sets to the height of 12 in points
            { hpx: 23 }, // row 2 sets to the height of 16 in pixels
            { hpx: 20 }, // row 2 sets to the height of 16 in pixels
            { hpx: 20 }, // row 2 sets to the height of 16 in pixels
            { hpx: 45 }, // row 2 sets to the height of 16 in pixels
        ];
        this.flextableComponent.exportToExcel(fileName, reportTitle, statetCaption, totalCaption, reportCols, reportRows, reportCaptionCol);

        return;

    }


    activeReportPageCss(reportPage: number) {
        if (this.reportParameters.reportPage === reportPage) {
            return 'mdl-button--raised mdl-button--accent';
        } else {
            return '';
        }
    }


    createSubmissionFile(dlg: any, format: string) {

        this.formatToGenerate = format;

        if (dlg) {
            dlg.show();
        }

    }

    getDownloadFileType(format: string) {

        if (format === 'csv' || format === 'txt') {
            return 'text/csv';
        } else if (format === 'tab') {
            return 'application/vnd.ms-excel';
        } else if (format === 'xml') {
            return 'text/xml';
        }

    }

    leadingZero(value) {
        if (value < 10) {
            return '0' + value.toString();
        }
        return value.toString();
    }

    getFileSubmission(dlg: any) {


        if (dlg) {
            dlg.hide();
        }

        let format = this.formatToGenerate;

        this.isPending = true;
        let self = this;

        // Get State ANSI Code
        let stateCode: string = '';
        if (this.reportDataDto !== undefined && this.reportDataDto.data.length > 0) {
            let row: any = this.reportDataDto.data[0];
            if (row.stateAbbreviationCode !== undefined) {
                stateCode = row.stateAbbreviationCode;
            } else {
                stateCode = row.stateCode;
            }
        }

        let reportType = this.reportParameters.reportType;
        let reportCode = this.reportParameters.reportCode;
        let reportLevel = this.reportParameters.reportLevel;
        let reportYear = this.reportParameters.reportYear;
        let formatType = this.getDownloadFileType(format);
        let currentDate = new Date();
        let version = 'v' + this.leadingZero(currentDate.getDate()) + this.leadingZero(currentDate.getMinutes()) + this.leadingZero(currentDate.getSeconds());
        let fileName = stateCode + reportLevel.toUpperCase() + this.generateFile.reportTypeAbbreviation + version + '.' + format;

        let xhr = new XMLHttpRequest();
        let url = 'api/app/filesubmissions/' + reportType + '/' + reportCode + '/' + reportLevel + '/' + reportYear + '/' + format + '/' + fileName;

        xhr.open('GET', url, true);
        xhr.responseType = 'blob';

        xhr.onreadystatechange = function () {

            setTimeout(() => { }, 0);

            if (xhr.readyState === 4 && xhr.status === 200) {
                self.isPending = false;
                let blob = new Blob([this.response], { type: formatType });
                saveAs(blob, fileName);
            } else if (xhr.readyState === 4 && xhr.status !== 200) {
                self.isPending = false;
                console.log('File submission error');
                alert('An unknown error occurred while generating the file. Please contact your system administrator.');
            }
        };

        xhr.send();

        // Following code can be used in future once Blob gets implemented in angular 2

        //this._http.get(url)
        //    .subscribe(res => {
        //        //   let blob = new Blob([res._body], { type: 'text/csv' });
        //        console.log('Returned blob');
        //        let blob = new Blob([res._body], { type: 'text/csv' });
        //        let filename = 'test.csv';
        //        saveAs(blob, filename);

        //    },
        //    error => {
        //        console.log('Error downloading the file.');
        //    });
    }

}
