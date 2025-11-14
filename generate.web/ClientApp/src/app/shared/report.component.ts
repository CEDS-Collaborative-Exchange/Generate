import { Component, Input, OnInit, AfterViewInit, OnDestroy, ViewChild } from '@angular/core';
import { Router, ActivatedRoute, NavigationExtras } from '@angular/router';
import { Subscription } from 'rxjs';
import { Observable } from 'rxjs';
import { forkJoin } from 'rxjs'

import { GenerateReportService } from '../services/app/generateReport.service';
import { DataMigrationService } from '../services/app/dataMigration.service';
import { OrganizationService } from '../services/ods/organization.service';
import { GradeLevelService } from '../services/ods/gradelevel.service';
import { FSMetadataUpdate } from '../services/app/FSMetadataUpdate.service';

import { GenerateReport } from '../models/app/generateReport';
import { GenerateReportDto } from '../models/app/generateReportDto';
import { OrganizationLevelDto } from '../models/app/organizationLevelDto';
import { GenerateReportFilterDto } from '../models/app/generateReportFilterDto';
import { IGenerateReportParametersDto, GenerateReportParametersDto } from '../models/app/generateReportParametersDto';
import { CurrentMigrationStatus } from '../models/app/currentMigrationStatus';
import { MetadataStatus } from '../models/app/metadataStatus';
import { CategorySetDto } from '../models/app/categorySetDto';
import { OrganizationDto } from '../models/ods/organizationDto';
import { GradeLevelDto } from '../models/ods/gradeLevelDto';
import { GenerateReportFilterOptionDto } from '../models/app/generateReportFilterOptionDto';
import { TableType } from '../models/app/tableType';

import { FlextableComponent } from './components/flextable/flextable.component';


declare let componentHandler: any;

@Component({
    selector: 'generate-app-report',
    templateUrl: './report.component.html',
    styleUrls: ['./report.component.scss'],
    providers: [GenerateReportService, DataMigrationService, OrganizationService, GradeLevelService, FSMetadataUpdate]
})


export class ReportComponent implements AfterViewInit, OnInit {

    public errorMessage: string;
    private subscriptions: Subscription[] = [];
    metadataStatus: MetadataStatus[];
    private metadataStatusMessage: string;
    private metadataStatusCss: string;
    private backgroundUrl: string;

    @Input() reportType: string;
    @ViewChild(FlextableComponent) flextableComponent: FlextableComponent;

    public reportParameters: IGenerateReportParametersDto = new GenerateReportParametersDto();

    private submissionYears: string[];
    private categorySets: CategorySetDto[];
    private tableTypes: TableType[];
    private leas: OrganizationDto[];
    private schools: OrganizationDto[];
    private filteredSchools: OrganizationDto[];
    private latestYear: string;
    private isReportChanged: boolean;
    private flag: boolean;
    private flag1: boolean;
    public generateReports: GenerateReport[];
    public currentReport: GenerateReportDto;
    public reportFilters: Array<GenerateReportFilterDto>;
    private reportFilterOptions: Array<GenerateReportFilterOptionDto>;
    private reportSubFilterOptions: Array<GenerateReportFilterOptionDto>;
    private reportGrades: GradeLevelDto[];
    private organizationalIdList: string;
    private organizationLevels: OrganizationLevelDto[];
    private reportswithGradeFilter: string;
    public metadataUpdate: FSMetadataUpdate;

    public currentMigrationStatus: CurrentMigrationStatus;

    reportSearchTimer: any


    constructor(
        private _router: Router,
        private _generateReportService: GenerateReportService,
        private _dataMigrationService: DataMigrationService,
        private _organizationService: OrganizationService,
        private _gradelevelService: GradeLevelService,
        private activatedRoute: ActivatedRoute,
        private _metadataUpdate: FSMetadataUpdate
    ) {
        this.isReportChanged = false;
        this.flag = false;
        this.flag1 = false;
        

    }


    ngOnInit() {
        this.reportParameters.reportType = this.reportType;
        this.subscriptions.push(this.activatedRoute.queryParams.subscribe(
            (params: any) => {
                this.reportParameters.reportCode = params['reportCode'];
                this.reportParameters.reportLevel = params['reportLevel'];
                this.reportParameters.reportYear = params['reportYear'];
                this.reportParameters.reportCategorySetCode = params['reportCategorySetCode'];
                if (this.reportParameters.reportCode === 'yeartoyearexitcount' && this.reportParameters.reportCategorySetCode !== 'exitOnly') {
                    this.reportParameters.reportFilter = 'select';
                }
                else if (this.reportParameters.reportCode === 'yeartoyearremovalcount' && this.reportParameters.reportCategorySetCode !== 'removaltype') {
                    this.reportParameters.reportFilter = 'select';
                }
                else {
                    this.reportParameters.reportFilter = params['reportFilter'];
                }

                this.reportParameters.reportSubFilter = params['reportSubFilter'];
                this.reportParameters.reportLea = params['reportLea'];
                this.reportParameters.reportSchool = params['reportSchool'];
                this.reportParameters.reportGrade = params['reportGrade'];
            }));
        if (this.reportType === 'statereport') {
            this.initializeStateReportsPage();
        }
        else {
            this.initializeReportsPage();
        }

    }

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }

    ngOnDestroy() {
        // prevent memory leak by unsubscribing
        this.subscriptions.forEach(subscription => subscription.unsubscribe());
    }


    updateSubmissionYear(reportCode: string) {
        if (reportCode === 'indicator4a' || reportCode === 'indicator4b') {
            if (this.submissionYears.indexOf(this.latestYear) > -1) { this.submissionYears.splice(0, 1); }
        } else {
            if (this.submissionYears.indexOf(this.latestYear) === -1) {
                this.submissionYears.unshift(this.latestYear);
            }
        }

    }

    populateLEAs(leas: OrganizationDto[]) {
        this.leas = [];
        this.leas.push({ organizationId: '-1', name: 'Select LEA', shortName: 'Select' } as OrganizationDto);
        if (this.reportParameters.reportType === 'statereport') {
            this.leas.push({ organizationId: '0', name: 'All LEAs', shortName: 'All', organizationStateIdentifier: 'all' } as OrganizationDto);
        }

        leas.forEach(s => this.leas.push({
            organizationId: s.organizationId,
            refOrganizationTypeId: s.refOrganizationTypeId,
            name: s.name + ' (' + s.organizationStateIdentifier + ')',
            parentOrganizationId: s.parentOrganizationId,
            organizationStateIdentifier: s.organizationStateIdentifier,
            shortName: s.shortName
        } as OrganizationDto));
    }

    populateSchools(schools: OrganizationDto[]) {
        this.schools = [];
        this.filteredSchools = [];
        this.filteredSchools.push({ organizationId: '-1', name: 'Select School', shortName: 'Select' } as OrganizationDto);
        if (this.reportParameters.reportType === 'statereport') {
            this.filteredSchools.push({ organizationId: '0', name: 'All Schools', shortName: 'All', organizationStateIdentifier: 'all' } as OrganizationDto);
        }

        schools.forEach(s => {
            this.schools.push(s);
            this.filteredSchools.push({
                organizationId: s.organizationId,
                refOrganizationTypeId: s.refOrganizationTypeId,
                name: s.name + ' (' + s.organizationStateIdentifier + ')',
                parentOrganizationId: s.parentOrganizationId,
                organizationStateIdentifier: s.organizationStateIdentifier,
                shortName: s.shortName
            } as OrganizationDto);
        });
    }

    populateFilterOptions(reportFilterOptions: GenerateReportFilterOptionDto[], grades: GradeLevelDto[]) {

        // console.log('Filter is :' + reportFilterOptions);
        if (this.reportType === 'statereport' && reportFilterOptions !== undefined && reportFilterOptions.length > 0) {
            this.reportFilterOptions = reportFilterOptions.filter(s => { return s.isSubFilter === false });
            this.reportSubFilterOptions = reportFilterOptions.filter(s => { return s.isSubFilter === true });
        }

        if (this.reportswithGradeFilter.indexOf(this.currentReport.reportCode) > -1  && grades !== undefined && grades.length > 0) {
            this.reportGrades = grades.filter(s => {
                if (s.code === 'HS') {
                    return s.code;
                }
                if (!isNaN(parseInt(s.code))) {
                    if (parseInt(s.code) > 2) {
                        return s.code;
                    }
                }
            });
        }

    }
    populateFilterOptionsSummary(reportFilterOptions: GenerateReportFilterOptionDto[], cat: string) {
        if (reportFilterOptions !== undefined && reportFilterOptions.length > 0 && cat !== 'Educational Environment 3-5' && cat !== 'Educational Environment 6-21') {
            this.reportFilterOptions = reportFilterOptions.filter(x => x.filterName !== cat).filter(s => { return s.isSubFilter === false });
            this.reportSubFilterOptions = reportFilterOptions.filter(x => x.filterName !== cat).filter(s => { return s.isSubFilter === true });
        }
        else if (reportFilterOptions !== undefined && reportFilterOptions.length > 0 && cat === 'Educational Environment 6-21') {
            this.reportFilterOptions = reportFilterOptions.filter(x => x.filterName !== cat).filter(x => x.filterName !== 'Educational Environment 3-5').filter(s => { return s.isSubFilter === false });
            this.reportSubFilterOptions = reportFilterOptions.filter(x => x.filterName !== cat).filter(x => x.filterName !== 'Educational Environment 3-5').filter(s => { return s.isSubFilter === true });
        }
        else if (reportFilterOptions !== undefined && reportFilterOptions.length > 0 && cat === 'Educational Environment 3-5') {
            this.reportFilterOptions = reportFilterOptions.filter(x => x.filterName !== cat).filter(x => x.filterName !== 'Educational Environment 6-21').filter(s => { return s.isSubFilter === false });
            this.reportSubFilterOptions = reportFilterOptions.filter(x => x.filterName !== cat).filter(x => x.filterName !== 'Educational Environment 6-21').filter(s => { return s.isSubFilter === true });
        }
    }


    filterSchools(lea: OrganizationDto) {
        this.filteredSchools = [];
        if (lea.organizationId !== '0') {
            this.filteredSchools.push({ organizationId: '-1', name: 'Select School', shortName: 'Select' } as OrganizationDto);
            if (this.reportParameters.reportType === 'statereport') {
                this.filteredSchools.push({ organizationId: '0', name: 'All Schools', shortName: 'All', organizationStateIdentifier: 'all' } as OrganizationDto);
            }

            if (this.schools !== undefined) {

                this.schools.filter(s => { return (s.parentOrganizationId === lea.organizationId); })
                    .forEach(t => {
                        this.filteredSchools.push({
                            organizationId: t.organizationId,
                            refOrganizationTypeId: t.refOrganizationTypeId,
                            name: t.name + ' (' + t.organizationStateIdentifier + ')',
                            parentOrganizationId: t.parentOrganizationId,
                            organizationStateIdentifier: t.organizationStateIdentifier,
                            shortName: t.shortName
                        } as OrganizationDto);
                    });
            }
        } else if (lea.organizationId === '0') {
            this.filteredSchools.push({ organizationId: '-1', name: 'Select School', shortName: 'Select' } as OrganizationDto);
            if (this.reportParameters.reportType === 'statereport') {
                this.filteredSchools.push({ organizationId: '0', name: 'All Schools', shortName: 'All', organizationStateIdentifier: 'all' } as OrganizationDto);
            }

            this.schools.forEach(s => {
                this.filteredSchools.push({
                    organizationId: s.organizationId,
                    refOrganizationTypeId: s.refOrganizationTypeId,
                    name: s.name + ' (' + s.organizationStateIdentifier + ')',
                    parentOrganizationId: s.parentOrganizationId,
                    organizationStateIdentifier: s.organizationStateIdentifier,
                    shortName: s.shortName
                } as OrganizationDto);
            });
        }

    }

    initializeReportsPage() {
        if (this.reportType !== undefined) {

            forkJoin(
                this._generateReportService.getReports(this.reportType),
                this._dataMigrationService.currentMigrationStatus(),
                this._metadataUpdate.getMetadataStatus()

            ).subscribe(data => {

                this.generateReports = data[0];
                this.currentMigrationStatus = data[1];
                this.metadataStatus = data[2];
                let status = '';

                if (this.metadataStatus !== undefined && this.metadataStatus.length > 0) {
                    this.metadataStatusMessage = this.metadataStatus.filter(t => t.generateConfigurationKey === 'MetaLastRunLog')[0].generateConfigurationValue;
                    status = this.metadataStatus.filter(t => t.generateConfigurationKey === 'metaStatus')[0].generateConfigurationValue;
                    this.metadataCss(status);
                }

                if (status.toUpperCase() === 'PROCESSING') {
                    this.errorMessage = 'Metadata is currently being processed. Allow the metadata process to finish before viewing reports.';
                }
                else if (status.toUpperCase() === 'FAILED') {
                    this.errorMessage = 'Metadata process failed. Please successfully migrate the metadata before viewing reports.';
                }
                else if (this.currentMigrationStatus.reportMigrationStatusCode === 'processing') {

                    this.errorMessage = 'A migration is in progress. Allow the current migration to finish before viewing reports.';
                }
                else if (this.currentMigrationStatus.reportMigrationStatusCode !== 'success') {

                    this.errorMessage = 'The migration must be run prior to viewing reports.';
                }
                else {

                    let newParameters: GenerateReportParametersDto = this.getNewReportParameters();


                    if (newParameters.reportPageSize === undefined) {
                        newParameters.reportPageSize = 25;
                    }

                    if (newParameters.reportPage === undefined) {
                        newParameters.reportPage = 1;
                    }

                    if (newParameters.reportLea === undefined) {
                        newParameters.reportLea = 'select';
                    }

                    if (newParameters.reportSchool === undefined) {
                        newParameters.reportSchool = 'select';
                    }

                    if (newParameters.reportYear === undefined) {
                        newParameters.reportYear = (new Date()).getFullYear().toString();
                    }

                    if (newParameters.reportTableTypeAbbrv === undefined && !this.isNullOrUndefined(this.tableTypes)) {
                        newParameters.reportTypeAbbreviation = this.tableTypes[0].tableTypeAbbrv;
                    }

                    this.reportswithGradeFilter = '';
                    this.errorMessage = null;


                }

            });



        }

    }

    initializeStateReportsPage() {
        if (this.reportType !== undefined) {

            this.subscriptions.push(this._dataMigrationService.currentMigrationStatus()
                .subscribe(data => {

                    this.currentMigrationStatus = data;

                    if (this.currentMigrationStatus.reportMigrationStatusCode === 'processing') {

                        this.errorMessage = 'A migration is in progress. Allow the current migration to finish before viewing reports.';
                    }
                    else if (this.currentMigrationStatus.reportMigrationStatusCode !== 'success') {

                        this.errorMessage = 'The migration must be run prior to viewing reports.';
                    }
                    else {

                        let newParameters: GenerateReportParametersDto = this.getNewReportParameters();

                        if (newParameters.reportPageSize === undefined) {
                            newParameters.reportPageSize = 25;
                        }

                        if (newParameters.reportPage === undefined) {
                            newParameters.reportPage = 1;
                        }

                        if (newParameters.reportLea === undefined) {
                            newParameters.reportLea = 'select';
                        }

                        if (newParameters.reportSchool === undefined) {
                            newParameters.reportSchool = 'select';
                        }

                        this.reportswithGradeFilter = 'stateassessmentsperformance,yeartoyearprogress,yeartoyearattendance';

                        this.errorMessage = null;

                        this.getStateReport(this.reportParameters);

                    }

                }));

        }

    }

    getReportYears(newParameters: GenerateReportParametersDto) {

        this._generateReportService.getSubmissionYearss(newParameters.reportCode, this.reportType)
            .subscribe(years => {
                this.submissionYears = years;
            })

    }

    getReport(newParameters: GenerateReportParametersDto) {

        forkJoin(
            this._generateReportService.getReportByCodeAndYear(this.reportType, newParameters.reportCode, newParameters.reportYear),
        ).subscribe(data => {

            this.currentReport = data[0];

            if (!this.isNullOrUndefined(this.currentReport)) {
                if (this.currentReport.organizationLevels.filter(t => t.levelCode === newParameters.reportLevel).length < 1) {
                    for (let i = 0; i < this.currentReport.organizationLevels.length; i++) {
                        let level: OrganizationLevelDto = this.currentReport.organizationLevels[i];
                        /*console.log('Level report is : ' + level.levelCode);*/

                        if (level.levelCode === 'sea') {
                            newParameters.reportLevel = 'sea';
                            break;
                        } else if (level.levelCode === 'lea') {
                            newParameters.reportLevel = 'lea';
                            break;
                        } else if (level.levelCode === 'sch') {
                            newParameters.reportLevel = 'sch';
                            break;
                        }
                        else if (level.levelCode === 'CAO') {
                            newParameters.reportLevel = 'CAO';
                            break;
                        }
                        else if (level.levelCode === 'CMO') {
                            newParameters.reportLevel = 'CMO';
                            break;
                        }
                    }
                }
                /*this.reportParameters.reportLevel = newParameters.reportLevel;*/
            }
            

            this.categorySets = this.getCategorySets(this.currentReport.categorySets, newParameters);
            this.tableTypes = this.categorySets[0].tableTypes;
            console.log(this.tableTypes);

            if (this.categorySets !== undefined && this.categorySets.length > 0) {
                newParameters.reportCategorySet = this.categorySets.filter(t => t.organizationLevelCode === newParameters.reportLevel && t.submissionYear === newParameters.reportYear)[0];
                newParameters.reportCategorySetCode = newParameters.reportCategorySet.categorySetCode;
            }

            if (!this.isNullOrUndefined(this.tableTypes) && this.tableTypes.length > 0) {
                if (!this.isNullOrUndefined(this.tableTypes[0])) {
                    newParameters.reportTableTypeAbbrv = this.tableTypes[0].tableTypeAbbrv;
                }
            }

            newParameters.connectionLink = this.currentReport.connectionLink;
            this.getOrganizationLevelByCode(newParameters);

            if (newParameters.reportCode === '029') {

                this._organizationService.getLEAs(newParameters.reportYear)
                    .subscribe(
                        data => {
                            this.populateLEAs(data);
                        },
                        error => this.errorMessage = <any>error);

                this._organizationService.getSchools(newParameters.reportYear)
                    .subscribe(
                        data => {
                            this.populateSchools(data);
                        },
                        error => this.errorMessage = <any>error);



                let lea: OrganizationDto = null;
                if (newParameters.reportLea !== undefined) {

                    if (this.reportParameters.reportLea === 'all') {
                        lea = { organizationId: '0', name: 'All Schools', shortName: 'All', organizationStateIdentifier: 'all' } as OrganizationDto;
                    } else if (this.reportParameters.reportLea === 'select') {
                        lea = { organizationId: '-1', name: 'Select School', shortName: 'Select' } as OrganizationDto;
                    } else {
                        let idx = this.leas.map(s => s.name).indexOf(this.reportParameters.reportLea);
                        if (idx > -1) {
                            lea = this.leas[idx];
                        }
                    }
                    if (lea !== null) {
                        this.filterSchools(lea);
                    }
                } else if (this.reportParameters.reportLevel === 'sch') {
                    lea = { organizationId: '-1', name: 'Select School', shortName: 'Select' } as OrganizationDto;
                    this.filterSchools(lea);
                }

            }

            this.reportParameters = newParameters;



        });


    }


    getStateReport(newParameters: GenerateReportParametersDto) {

        forkJoin(
            this._generateReportService.getReportByCodes(this.reportType, newParameters.reportCode),
            this._gradelevelService.getGradeLevelsOffered(),
            this._organizationService.getLEAs(newParameters.reportYear),
            this._organizationService.getSchools(newParameters.reportYear)

        ).subscribe(data => {

            this.currentReport = data[0];

            if (newParameters.reportLevel === undefined) {
                for (let i = 0; i < this.currentReport.organizationLevels.length; i++) {
                    let level: OrganizationLevelDto = this.currentReport.organizationLevels[i];

                    if (level.levelCode === 'sea') {
                        newParameters.reportLevel = 'sea';
                        break;
                    } else if (level.levelCode === 'lea') {
                        newParameters.reportLevel = 'lea';
                        break;
                    } else if (level.levelCode === 'sch') {
                        newParameters.reportLevel = 'sch';
                        break;
                    }
                    else if (level.levelCode === 'CAO') {
                        newParameters.reportLevel = 'CAO';
                        break;
                    }
                    else if (level.levelCode === 'CMO') {
                        newParameters.reportLevel = 'CMO';
                        break;
                    }
                }
            }

            this.categorySets = this.getCategorySets(this.currentReport.categorySets, newParameters);

            if (this.categorySets !== undefined && this.categorySets.length > 0) {
                newParameters.reportCategorySet = this.categorySets.filter(t => t.organizationLevelCode === newParameters.reportLevel && t.submissionYear === newParameters.reportYear)[0];
                newParameters.reportCategorySetCode = newParameters.reportCategorySet.categorySetCode;
            }

            newParameters.connectionLink = this.currentReport.connectionLink;
            this.getOrganizationLevelByCode(newParameters);
            this.reportFilters = this.currentReport.reportFilters;

            this.populateFilterOptions(this.currentReport.reportFilterOptions, data[1]);

            if (newParameters.reportFilter === undefined && this.reportFilterOptions !== undefined) {
                newParameters.reportFilter = this.reportFilterOptions[0].filterCode;
            }

            if (newParameters.reportSubFilter === undefined && this.reportSubFilterOptions !== undefined && this.reportSubFilterOptions.length > 0) {
                newParameters.reportSubFilter = this.reportSubFilterOptions[0].filterCode;
            }

            if (this.reportswithGradeFilter.indexOf(this.currentReport.reportCode) > -1 && newParameters.reportGrade === undefined && this.reportGrades !== undefined && this.reportGrades.length > 0) {
                newParameters.reportGrade = this.reportGrades[0].code;
            }


            this.populateLEAs(data[2]);
            this.populateSchools(data[3]);


            let lea: OrganizationDto = null;
            if (newParameters.reportLea !== undefined) {

                if (this.reportParameters.reportLea === 'all') {
                    lea = { organizationId: '0', name: 'All LEAs', shortName: 'All', organizationStateIdentifier: 'all' } as OrganizationDto;
                } else if (this.reportParameters.reportLea === 'select') {
                    lea = { organizationId: '-1', name: 'Select LEA', shortName: 'Select' } as OrganizationDto;
                } else {
                    let idx = this.leas.map(s => s.organizationStateIdentifier).indexOf(this.reportParameters.reportLea);
                    if (idx > -1) {
                        lea = this.leas[idx];
                    }
                }
                if (lea !== null) {
                    this.filterSchools(lea);
                }
            } else if (this.reportParameters.reportLevel === 'sch') {
                lea = { organizationId: '-1', name: 'Select School', shortName: 'Select', organizationStateIdentifier: 'all' } as OrganizationDto;
                if (lea !== null) {
                    this.filterSchools(lea);
                }
            }

            if (newParameters.reportCode === 'studentssummary') {
                if (!this.flag1) {
                    newParameters.reportFilter = 'select';
                    this.populateFilterOptionsSummary(this.currentReport.reportFilterOptions, newParameters.reportCategorySet.categorySetName);

                } else {
                    this.flag1 = false;
                }
            }
            //else if (newParameters.reportCode === 'studentssummary') {
            //    this.populateFilterOptionsSummary(this.currentReport.reportFilterOptions, newParameters.reportCategorySet.categorySetName);
            //}

            this.setQueryString(newParameters);

            this.reportParameters = newParameters;



        });


    }

    getSelectedEntity(reportLevel: string) {
        let idx = -1;
        if (reportLevel === 'lea') {
            if (this.reportParameters.reportLea !== undefined) {
                idx = this.leas.map(s => s.organizationStateIdentifier).indexOf(this.reportParameters.reportLea);
            }
        } else {
            if (this.reportParameters.reportSchool !== undefined) {
                idx = this.filteredSchools.map(s => s.organizationStateIdentifier).indexOf(this.reportParameters.reportSchool);
            }
        }

        return idx;
    }

    getCategorySets(categorySets: Array<CategorySetDto>, newParameters: GenerateReportParametersDto) {

        let returnSet: Array<CategorySetDto> = new Array();

        if (categorySets !== undefined && categorySets.length > 0) {
            for (let i = 0; i < categorySets.length; i++) {
                let categorySet: CategorySetDto = categorySets[i];

                if (categorySet.organizationLevelCode === newParameters.reportLevel && categorySet.submissionYear === newParameters.reportYear) {

                    if (categorySet.includeOnFilter !== null) {
                        if (newParameters.reportFilter === categorySet.includeOnFilter) {
                            returnSet.push(categorySet);
                        }
                    }
                    else if (categorySet.excludeOnFilter !== null) {
                        if (newParameters.reportFilter !== categorySet.excludeOnFilter) {
                            returnSet.push(categorySet);
                        }
                    }
                    else {
                        returnSet.push(categorySet);
                    }
                }
            }
        }

        function compare(a: CategorySetDto, b: CategorySetDto) {
            if (a.categorySetName < b.categorySetName)
                return -1;
            if (a.categorySetName > b.categorySetName)
                return 1;
            return 0;
        }

        returnSet.sort(compare);

        return returnSet;
    }

    getNewReportParameters() {
        let newParameters: GenerateReportParametersDto = new GenerateReportParametersDto();
        newParameters.reportType = this.reportParameters.reportType;
        newParameters.reportCode = this.reportParameters.reportCode;
        newParameters.reportLevel = this.reportParameters.reportLevel;
        newParameters.reportYear = this.reportParameters.reportYear;
        newParameters.reportCategorySet = this.reportParameters.reportCategorySet;
        newParameters.reportCategorySetCode = this.reportParameters.reportCategorySetCode;
        newParameters.reportSort = this.reportParameters.reportSort;
        newParameters.reportPage = this.reportParameters.reportPage;
        newParameters.reportPageSize = this.reportParameters.reportPageSize;
        newParameters.reportFilter = this.reportParameters.reportFilter;
        newParameters.reportFilterValue = this.reportParameters.reportFilterValue;
        newParameters.reportSubFilter = this.reportParameters.reportSubFilter;
        newParameters.reportGrade = this.reportParameters.reportGrade;
        newParameters.reportLea = this.reportParameters.reportLea;
        newParameters.reportSchool = this.reportParameters.reportSchool;
        newParameters.connectionLink = this.reportParameters.connectionLink;
        newParameters.organizationalIdList = this.reportParameters.organizationalIdList;
        newParameters.reportTableTypeAbbrv = this.reportParameters.reportTableTypeAbbrv;
        return newParameters;

    }

    getOrganizationLevelByCode(newParameters: GenerateReportParametersDto) {

        this._generateReportService.getReportLevelsByCode(this.reportType, newParameters.reportCode, newParameters.reportYear, newParameters.reportCategorySetCode)
            .subscribe(
                data => {
                    this.organizationLevels = data;
                },
                error => this.errorMessage = <any>error);



    }

    setReportLevel(event, reportLevel: string) {
        if (this.reportParameters.reportLevel !== reportLevel) {

            let newParameters: GenerateReportParametersDto = this.getNewReportParameters();

            newParameters.reportLevel = reportLevel;
            newParameters.reportPage = 1;
            newParameters.reportSort = 1;

            if (this.reportType === 'statereport') {
                this.setQueryString(newParameters);
            }

            this.reportParameters = newParameters;

        }
        return false;
    }

    setReportCategorySet(event, comboCategorySet) {

        let reportCategorySet: CategorySetDto;
        let newParameters: GenerateReportParametersDto = this.getNewReportParameters();
        if (newParameters.reportCode === 'studentssummary') {
            this.flag1 = false;
        }
        if (!comboCategorySet._focus) {
            comboCategorySet.selectedItem = newParameters.reportCategorySet;
        } else {

            if (comboCategorySet.selectedItem !== undefined) {

                reportCategorySet = comboCategorySet.selectedItem;

                if (newParameters.reportCategorySet.categorySetCode !== reportCategorySet.categorySetCode) {
                    newParameters.reportCategorySet = reportCategorySet;
                    newParameters.reportCategorySetCode = reportCategorySet.categorySetCode;

                    if (this.reportType === 'statereport') {
                        this.setQueryString(newParameters);
                    }

                    this.reportParameters = newParameters;
                }

            }
        }

        return false;
    }

    reportChanged($event) {
        this.isReportChanged = true;
    }
    reportChangedd($event) {
        this.flag = true;
    }

    setReportCode(event, comboReportCode, comboYear) {

        if (this.reportSearchTimer) {

            window.clearTimeout(this.reportSearchTimer)
            this.reportSearchTimer = null

        }

        this.reportSearchTimer = setTimeout(() => {

            let reportCode: string;

            if (comboReportCode.selectedItem !== undefined && this.isReportChanged) {
                reportCode = comboReportCode.selectedItem.reportCode;

                if (this.reportParameters.reportCode !== reportCode) {

                    let newParameters: GenerateReportParametersDto = this.getNewReportParameters();

                    newParameters.reportCode = reportCode;
                    newParameters.reportPage = 1;
                    newParameters.reportSort = 1;
                    newParameters.reportCategorySetCode = 'CSA';
                    newParameters.reportTableTypeAbbrv = undefined;
                    

                    if (this.submissionYears !== undefined && this.submissionYears.length > 0) {
                       this.getReport(newParameters);
                    } else {
                        this.getReportYears(newParameters);
                        this.reportParameters = newParameters;
                    }

                   

                }

            }
            //else if (comboReportCode.selectedItem !== undefined && this.currentReport !== undefined) {
            //    comboReportCode.selectedItem = this.currentReport;
            //}
            return false;

        }, 1000)
    }

    setReportYear(event, comboYear) {
        let newParameters: GenerateReportParametersDto = this.getNewReportParameters();

        if (!comboYear._focus) {
            comboYear.selectedItem = newParameters.reportYear;
        } else {
            if (comboYear.selectedItem !== undefined) {

                if (newParameters.reportYear !== comboYear.selectedItem) {

                    newParameters.reportYear = comboYear.selectedItem;
                    newParameters.reportPage = 1;

                    this.getReport(newParameters);

                    if (this.categorySets !== undefined && this.categorySets.length > 0) {
                        this.categorySets.splice(0, this.categorySets.length);
                    }
                    if (!this.isNullOrUndefined(this.currentReport)) {
                        this.categorySets = this.getCategorySets(this.currentReport.categorySets, newParameters);
                    }

                    if (this.categorySets !== undefined && this.categorySets.length > 0) {
                        newParameters.reportCategorySet = this.categorySets.filter(t => t.organizationLevelCode === newParameters.reportLevel
                            && t.submissionYear === newParameters.reportYear)[0];
                        newParameters.reportCategorySetCode = newParameters.reportCategorySet.categorySetCode;
                    }

                    if (this.reportType === 'statereport') {
                        this.setQueryString(newParameters);
                    }

                    this.reportParameters = newParameters;
                }

            }


        }

                      this._organizationService.getLEAs(newParameters.reportYear)
                    .subscribe(
                        data => {
                            this.populateLEAs(data);
                        },
                        error => this.errorMessage = <any>error);

                this._organizationService.getSchools(newParameters.reportYear)
                    .subscribe(
                        data => {
                            this.populateSchools(data);
                        },
                        error => this.errorMessage = <any>error);

        return false;
    }

    setTableType(event, comboTableType) {

        let reportTableType: TableType;
        let newParameters: GenerateReportParametersDto = this.getNewReportParameters();
        if (comboTableType.selectedItem !== undefined) {

            reportTableType = comboTableType.selectedItem;
            if (newParameters.reportTableTypeAbbrv !== reportTableType.tableTypeAbbrv) {

                newParameters.reportTableTypeAbbrv = reportTableType.tableTypeAbbrv;
                newParameters.reportPage = 1;
                this.reportParameters = newParameters;
            }
        }
    }


    setReportFilter(event, reportFilter: string, reportFilterValue: string) {

        let newParameters: GenerateReportParametersDto = this.getNewReportParameters();
        if (newParameters.reportCode === 'studentssummary') {
            this.flag1 = false;
        }
        newParameters.reportFilter = reportFilter;
        newParameters.reportFilterValue = reportFilterValue;
        newParameters.reportPage = 1;
        newParameters.reportSort = 1;
        let organizationIds: string;
        organizationIds = '';
        for (let i = 0; i < this.leas.length; i++) {
            organizationIds += this.leas[i].organizationId.toString();
            if (i !== this.leas.length - 1) { organizationIds += ','; }
        }
        newParameters.organizationalIdList = organizationIds;

        if (this.reportType === 'statereport') {
            this.setQueryString(newParameters);
        }


        this.reportParameters = newParameters;

        return false;
    }

    setReportFilterOption(event, comboReportFilter) {

        let newParameters: GenerateReportParametersDto = this.getNewReportParameters();

        if (comboReportFilter._focus) {
            if (comboReportFilter.selectedItem !== undefined) {

                let reportFilterOption: GenerateReportFilterOptionDto = comboReportFilter.selectedItem;
                newParameters.reportFilter = reportFilterOption.filterCode;
                newParameters.reportPage = 1;
                newParameters.reportSort = 1;

                if (this.reportType === 'statereport') {
                    this.setQueryString(newParameters);
                }
                this.reportParameters = newParameters;

            }
        }

        return false;

    }

    setReportSubFilterOption(event, comboReportSubFilter) {

        let newParameters: GenerateReportParametersDto = this.getNewReportParameters();

        if (comboReportSubFilter._focus) {
            if (comboReportSubFilter.selectedItem !== undefined) {
                let reportFilterOption: GenerateReportFilterOptionDto = comboReportSubFilter.selectedItem;
                newParameters.reportSubFilter = reportFilterOption.filterCode;
                newParameters.reportPage = 1;
                newParameters.reportSort = 1;

                if (this.reportType === 'statereport') {
                    this.setQueryString(newParameters);
                }
                this.reportParameters = newParameters;

            }
        }
        return false;

    }

    setReportGradeOption(event, comboReportGradeFilter) {

        let newParameters: GenerateReportParametersDto = this.getNewReportParameters();

        if (comboReportGradeFilter._focus) {
            if (comboReportGradeFilter.selectedItem !== undefined) {
                let reportFilterGrade: GradeLevelDto = comboReportGradeFilter.selectedItem;
                newParameters.reportGrade = reportFilterGrade.code;
                newParameters.reportPage = 1;
                newParameters.reportSort = 1;
                if (this.reportType === 'statereport') {
                    this.setQueryString(newParameters);
                }
                this.reportParameters = newParameters;
            }
        }
        return false;

    }

    setReportLea(event, comboReportLea) {
        /*console.log('MySetLea');*/
        let newParameters: GenerateReportParametersDto = this.getNewReportParameters();
        if (newParameters.reportCode === 'studentssummary') {
            this.flag1 = true;
        }
        //console.log('Is school display : ' + this.isDisplaySchool() + ' ' + this.schools + ' ' + comboReportLea.selectedItem);
        if (comboReportLea._focus) {

            if (comboReportLea.selectedItem !== null) {

                let selectedLea: OrganizationDto = comboReportLea.selectedItem;
                if (selectedLea !== null && selectedLea.organizationId !== '0' && selectedLea.organizationId !== '-1') {
                    newParameters.reportLea = selectedLea.organizationStateIdentifier;
                } else if (selectedLea !== null && selectedLea.organizationId === '0') {
                    newParameters.reportLea = 'all';
                    selectedLea = { organizationId: '0', name: 'All LEAs', shortName: 'All', organizationStateIdentifier: 'all' } as OrganizationDto;
                } else {
                    newParameters.reportLea = 'select';
                    selectedLea = { organizationId: '-1', name: 'Select LEA', shortName: 'Select' } as OrganizationDto;
                }

                newParameters.reportPage = 1;

                if (this.isDisplaySchool()) {
                    newParameters.reportSchool = 'select';
                    if (this.schools !== undefined) {
                        this.filterSchools(selectedLea);
                    }
                }

                this.reportParameters = newParameters;

                if (this.reportType === 'statereport') {
                    this.setQueryString(newParameters);
                }


            }
        }

        return false;
    }

    setReportSchool($event, comboReportSchool) {
        let newParameters: GenerateReportParametersDto = this.getNewReportParameters();

        if (comboReportSchool._focus) {
            if (comboReportSchool.selectedItem !== null) {

                let selectedSchool: OrganizationDto = comboReportSchool.selectedItem;
                if (selectedSchool !== null && selectedSchool.organizationId !== '0' && selectedSchool.organizationId !== '-1') {
                    newParameters.reportSchool = selectedSchool.organizationStateIdentifier;
                } else if (selectedSchool !== null && selectedSchool.organizationId === '0') {
                    newParameters.reportSchool = 'all';
                    selectedSchool = { organizationId: '0', name: 'All Schools', shortName: 'All', organizationStateIdentifier: 'all' } as OrganizationDto;
                } else {
                    newParameters.reportSchool = 'select';
                    selectedSchool = { organizationId: '-1', name: 'Select School', shortName: 'Select' } as OrganizationDto;
                }
                newParameters.reportPage = 1;

                this.reportParameters = newParameters;
                if (this.reportType === 'statereport') {
                    this.setQueryString(newParameters);
                }


            }
        }

        return false;
    }

    getCMOLevelLabel(reportCode: string) {
        let CMOlbl: string = 'CMOs';

        if (this.currentReport !== undefined) {
            if (this.reportParameters.reportCode === reportCode) {
                CMOlbl = 'Management Organization Type';
            }
        }
        return CMOlbl;
            
    }

    CMOLevelLabelCss(reportCode: string) {
        if (this.reportParameters.reportCode === reportCode) {
            return 'generate-app-report-controls__reportlevel-button-mgmt';
        } else {
            return '';
        }
    }



    activeReportCodeCss(reportCode: string) {
        if (this.reportParameters.reportCode === reportCode) {
            return 'mdl-button--raised mdl-button--accent';
        } else {
            return '';
        }
    }
    activeReportLevelCss(reportLevel: string) {

        if (this.reportParameters.reportLevel === reportLevel) {
            return 'mdl-button--accent';
        } else {
            return '';
        }

    }


    parameterColumnSpanCss() {

        if (this.currentReport !== undefined) {
            if (this.reportType === 'edfactsreport' || this.reportType === 'sppaprreport' || this.reportType === 'statereport' || this.currentReport.showCategorySetControl) {
                return 'mdl-cell--3-col';
            } else {
                return 'mdl-cell--4-col';
            }
        } else {
            if (this.reportType === 'edfactsreport' || this.reportType === 'sppaprreport' || this.reportType === 'statereport') {
                return 'mdl-cell--3-col';
            } else {
                return 'mdl-cell--4-col';
            }
        }
    }

    reportWidth() {
        if (this.reportType === 'edfactsreport' || this.reportType === 'sppaprreport') {
            return 'generate-app-report-controls__submission';
        } else {
            return 'generate-app-report-controls__datapopulation';
        }
    }

    showReportLevelButton(reportLevel: string) {
        let show: boolean = false;

        if (this.currentReport !== undefined) {

            if (this.organizationLevels !== undefined) {

                for (let i = 0; i < this.organizationLevels.length; i++) {
                    let level: OrganizationLevelDto = this.organizationLevels[i];
                    if (level.levelCode === reportLevel) {
                        show = true;
                    }
                }
            }
        }

        return show;
    }

    showReportData() {
        let show: boolean = false;
        if ((this.reportType === 'statereport') && this.reportParameters.reportLevel === 'lea') {
            if (this.reportParameters.reportLea !== undefined && this.reportParameters.reportLea !== 'select') {
                show = true;
            }
            else {
                show = false;
            }
        } else if ((this.reportType === 'statereport') && this.reportParameters.reportLevel === 'sch') {
            if (this.reportParameters.reportSchool !== undefined && this.reportParameters.reportSchool !== 'select') {
                show = true;
            }
            else {
                show = false;
            }
        }
        else {
            show = true;
        }
        return show;
    }

    setQueryString(newParameters: GenerateReportParametersDto) {

        let navigationExtras: NavigationExtras = {};
        let gradeExtras: NavigationExtras = {};
        let organizationIds: string;
        organizationIds = '';
        if (this.leas !== undefined) {
            for (let i = 0; i < this.leas.length; i++) {
                organizationIds += this.leas[i].organizationId.toString();
                if (i !== this.leas.length - 1) { organizationIds += ','; }
            }
            this.reportParameters.organizationalIdList = organizationIds;
            newParameters.organizationalIdList = organizationIds;
        }

        if (newParameters.reportLevel === 'sea') {

            navigationExtras = {
                queryParams:
                {
                    'reportCode': newParameters.reportCode,
                    'reportLevel': newParameters.reportLevel,
                    'reportYear': newParameters.reportYear,
                    'reportCategorySetCode': newParameters.reportCategorySetCode,
                    'reportFilter': newParameters.reportFilter,
                    'reportSubFilter': newParameters.reportSubFilter
                }
            };

            gradeExtras = {
                queryParams:
                {
                    'reportCode': newParameters.reportCode,
                    'reportLevel': newParameters.reportLevel,
                    'reportYear': newParameters.reportYear,
                    'reportCategorySetCode': newParameters.reportCategorySetCode,
                    'reportFilter': newParameters.reportFilter,
                    'reportSubFilter': newParameters.reportSubFilter,
                    'reportGrade': newParameters.reportGrade
                }
            };

        } else if (newParameters.reportLevel === 'lea') {

            navigationExtras = {
                queryParams: {
                    'reportCode': newParameters.reportCode,
                    'reportLevel': newParameters.reportLevel,
                    'reportYear': newParameters.reportYear,
                    'reportCategorySetCode': newParameters.reportCategorySetCode,
                    'reportFilter': newParameters.reportFilter,
                    'reportSubFilter': newParameters.reportSubFilter,
                    'reportLea': newParameters.reportLea,
                    'organizationalIdList': newParameters.organizationalIdList
                }
            };

            gradeExtras = {
                queryParams: {
                    'reportCode': newParameters.reportCode,
                    'reportLevel': newParameters.reportLevel,
                    'reportYear': newParameters.reportYear,
                    'reportCategorySetCode': newParameters.reportCategorySetCode,
                    'reportFilter': newParameters.reportFilter,
                    'reportSubFilter': newParameters.reportSubFilter,
                    'reportLea': newParameters.reportLea,
                    'reportGrade': newParameters.reportGrade,
                    'organizationalIdList': newParameters.organizationalIdList

                }
            };

        } else if (newParameters.reportLevel === 'sch') {

            navigationExtras = {
                queryParams: {
                    'reportCode': newParameters.reportCode,
                    'reportLevel': newParameters.reportLevel,
                    'reportYear': newParameters.reportYear,
                    'reportCategorySetCode': newParameters.reportCategorySetCode,
                    'reportFilter': newParameters.reportFilter,
                    'reportSubFilter': newParameters.reportSubFilter,
                    'reportLea': newParameters.reportLea,
                    'reportSchool': newParameters.reportSchool
                }
            };

            gradeExtras = {
                queryParams: {
                    'reportCode': newParameters.reportCode,
                    'reportLevel': newParameters.reportLevel,
                    'reportYear': newParameters.reportYear,
                    'reportCategorySetCode': newParameters.reportCategorySetCode,
                    'reportFilter': newParameters.reportFilter,
                    'reportSubFilter': newParameters.reportSubFilter,
                    'reportLea': newParameters.reportLea,
                    'reportGrade': newParameters.reportGrade,
                    'reportSchool': newParameters.reportSchool,
                    'organizationalIdList': newParameters.organizationalIdList

                }
            };

        }
        else if (newParameters.reportLevel === 'CAO') {

            navigationExtras = {
                queryParams: {
                    'reportCode': newParameters.reportCode,
                    'reportLevel': newParameters.reportLevel,
                    'reportYear': '2016-17',
                    'reportCategorySetCode': newParameters.reportCategorySetCode,
                    'reportFilter': newParameters.reportFilter,
                    'reportSubFilter': newParameters.reportSubFilter,
                    'reportLea': newParameters.reportLea,
                    'reportSchool': newParameters.reportSchool
                }
            };


        }

        else if (newParameters.reportLevel === 'CMO') {

            navigationExtras = {
                queryParams: {
                    'reportCode': newParameters.reportCode,
                    'reportLevel': newParameters.reportLevel,
                    'reportYear': newParameters.reportYear,
                    'reportCategorySetCode': newParameters.reportCategorySetCode,
                    'reportFilter': newParameters.reportFilter,
                    'reportSubFilter': newParameters.reportSubFilter,
                    'reportLea': newParameters.reportLea,
                    'reportSchool': newParameters.reportSchool
                }
            };


        }

       
        if (this.reportswithGradeFilter.indexOf(this.currentReport.reportCode) > -1) {
            this._router.navigate(['/reports/library/report'], gradeExtras);
        } else {
            this._router.navigate(['/reports/library/report'], navigationExtras);
        }

    }

    gotoReportsLibrary() {
        this._router.navigateByUrl('/reports/library');
        return false;
    }

    isDisplayLEA() {
        let isDisplayed: boolean = false;
        if ((this.reportType === 'statereport') && this.reportParameters.reportLevel !== 'sea') {
            isDisplayed = true;
        }
        return isDisplayed;
    }

    isDisplaySchool() {
        let isDisplayed: boolean = false;
        if ((this.reportType === 'statereport') && this.reportParameters.reportLevel === 'sch') {
            isDisplayed = true;
        }
        return isDisplayed;
    }

    //Remove Category Set from the School Level report title. Per file spec: "For the school level file, there are no required categories and totals.
    showCategorySet() {
        let isDisplayed: boolean = true;
        if ((this.reportParameters.reportCode === '059') && this.reportParameters.reportLevel == 'sch') {
            isDisplayed = false;
        }
        if (this.reportParameters.reportCode === '190' || this.reportParameters.reportCode === '196' || this.reportParameters.reportCode === '197' || this.reportParameters.reportCode === '198') {
            isDisplayed = false;
        }
        return isDisplayed;
    }

    showTableType() {
        let isDisplayed: boolean = false;
        const assessmentCodes = ['175', '178', '179', '185', '188', '189'];

        if (assessmentCodes.includes(this.reportParameters.reportCode)) {
            isDisplayed = true;
        }
        return isDisplayed;
    }

    metadataCss(status: string) {
        if (status === "FAILED") { this.metadataStatusCss = 'generate-app-report-metadata__error'; }
        else {
            this.metadataStatusCss = 'generate-app-report-controls__sectiontitle';
        }
    }

    isNullOrUndefined(value: any): boolean {
        return value === null || value === undefined;
    }
}
