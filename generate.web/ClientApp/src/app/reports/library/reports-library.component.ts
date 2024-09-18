import { Component, Input, AfterViewInit, OnInit, OnChanges, SimpleChange, ViewChild, ViewChildren, QueryList, ElementRef, NgZone } from '@angular/core';
import { Router, NavigationExtras } from '@angular/router';
import { Observable } from 'rxjs';
import { forkJoin } from 'rxjs'

import { GenerateReportTopic } from '../../models/app/generateReportTopic';
import { GenerateReportDto } from '../../models/app/generateReportDto';
import { GenerateReportTopicDto } from '../../models/app/generateReportTopicDto';
import { GenerateReportTopicService } from '../../services/app/generateReportTopic.service';
import { GenerateReportService } from '../../services/app/generateReport.service';
import { UserService } from '../../services/app/user.service';
import { OrganizationLevelDto } from '../../models/app/organizationLevelDto';


declare var componentHandler: any;

@Component({
    selector: 'generate-app-reports-library',
    templateUrl: './reports-library.component.html',
    styleUrls: ['./reports-library.component.scss'],
    providers: [GenerateReportTopicService, GenerateReportService, UserService]
})
    
export class ReportsLibraryComponent implements AfterViewInit,OnInit  {

    public errorMessage: string;
    public isLoading: boolean = false;
    private visibleTopicIds: number[];
    public reportTopics: GenerateReportTopicDto[];
    public reportLevels: OrganizationLevelDto[];
    private defaultTopic: GenerateReportTopicDto;
    private stateReports: GenerateReportDto[];
    public selectedTopic: GenerateReportTopicDto;
    public selectedReport: GenerateReportDto;
    public selectedReportIds: number[];
    public selectedTopicIds: number[];

    private userName: string;
    private _filter: string = '';
    private _reportLevelFilter: string = '';
    private _toFilter: any;
    public cvData: any;
    public isResultsView: boolean;
    public isTopicChanged: boolean;

    @ViewChild('reportGrid', { static: false }) reportGrid: any;
    @ViewChild('comboReportLevel', { static: false }) comboReportLevel: any;
    @ViewChild('txtTopicName', { static: true }) txtTopicName: ElementRef;

    constructor(
        private _router: Router,
        private _UserService: UserService,
        private _reportTopicService: GenerateReportTopicService,
        private _reportService: GenerateReportService,
        private _ngZone: NgZone
        ) {
        this.defaultTopic = <GenerateReportTopicDto>{};   
        this.visibleTopicIds = [];
        this.selectedReportIds = [];
        this.selectedTopicIds = [];
        this.selectedTopic = <GenerateReportTopicDto>{};
        this.reportLevels = [];
       
    }

    ngOnInit() {

        this.isLoading = true;
        this.isResultsView = false;
        this.isTopicChanged = false;
        this.userName = this._UserService.getUserLoginName();

        this.defaultTopic.generateReportTopicName = "Generate Reports Library";
        this.defaultTopic.userName = this.userName;
        this.defaultTopic.isActive = true;

        this.populateReportsLibrary(this.defaultTopic.generateReportTopicName);
     }

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();

    }


    populateReportsLibrary(topicName: string) {

        //console.log('Populating Topics: ');
        this.reportTopics = null;
        forkJoin(
            this._reportTopicService.getTopics(this.userName),
            this._reportService.getReportList('statereport'),
            this._reportService.getReportLevels()
         ).subscribe(data => { 
             this.stateReports = data[1];
             if (data[0].length > 0) {
                 this.reportTopics = data[0];
                 this.populateReportLevels(data[2]);
                 this.expandFolder(topicName);
                 this.isLoading = false;
                 this.cvData = this.stateReports;
             //    this.cvData.filter = this._filterFunction.bind(this);
             } else {
                 this.defaultTopic.generateReports = this.stateReports;
                 this._reportTopicService.addTopic(this.defaultTopic)
                     .subscribe(data => {
                         this.populateReportsLibrary(this.defaultTopic.generateReportTopicName);
                     });
             }
             
        });
        
    }


    populateReportLevels(levels: OrganizationLevelDto[]) {
        this.reportLevels = [];
        this.reportLevels.push({ organizationLevelId: -1, levelCode: 'all', levelName: 'All' } as OrganizationLevelDto);
        levels.forEach(s => this.reportLevels.push(s));
    }


    expandFolder(topicName : string) {

        if (this.reportTopics.length > 0) {
            let topicId: number;
            for (let i = 0; i < this.reportTopics.length; i++) {
                if (this.reportTopics[i].generateReportTopicName !== undefined) {

                    topicId = this.reportTopics[i].generateReportTopicId;

                    let idx = this.visibleTopicIds.indexOf(topicId);
                    if (idx === -1) {
                        this.visibleTopicIds.push(topicId);
                    }
                    
                }
            }
        }
    }

    gotoReport(reportCode: string, reportLevel: string) {

        let navigationExtras: NavigationExtras = {
            queryParams: {
                'reportCode': reportCode,
                'reportLevel': reportLevel
            }
        };

        this._router.navigate(['/reports/library/report'], navigationExtras);
        return false;
    }

    toggleTopic(generateReportTopicId: number) {

      
        if (this.visibleTopicIds !== undefined) {
            let idx = this.visibleTopicIds.indexOf(generateReportTopicId);
            if (idx === -1) {
                this.visibleTopicIds.push(generateReportTopicId);
            }
            else {
                this.visibleTopicIds.splice(idx, 1);
            }
        }

    }

    isTopicVisible(generateReportTopicId: number) {
        if (this.visibleTopicIds == undefined) {
            return false;
        } else {
            return (this.visibleTopicIds.indexOf(generateReportTopicId) !== -1);
        }
    }

    showDialog(dlg: any, dialogId: number, dialogType: string) {

        if (dlg) {
            this.errorMessage = null;
            if (dialogType !== 'report') {
                this.selectedReportIds = [];
                if (dialogId > 0) {
                    this.selectedTopic = this.reportTopics.filter(t => { return (t.generateReportTopicId === dialogId); })[0];
                    if (dialogType === 'topic') {
                        this.selectedTopic.generateReports.forEach(report => { this.selectedReportIds.push(report.generateReportId); });
                        this.stateReports.forEach(report => {
                            if (this.selectedReportIds.indexOf(report.generateReportId) !== -1) { report.isActive = true;
                            } else { report.isActive = false; }
                        });
                    }
                } else {
                    this.selectedTopic = <GenerateReportTopicDto>{};
                    this.selectedTopic.generateReportTopicId = dialogId;
                    this.selectedTopic.generateReportTopicName = '';
                    this.stateReports.forEach(report => { report.isActive = false; });
                }
            } else {
                this.selectedTopicIds = [];
                this.isTopicChanged = false;
                if (dialogId > 0) {
                    this.selectedReport = this.stateReports.filter(r => { return (r.generateReportId === dialogId); })[0];
                    this.reportTopics.forEach(topic => {
                        if (topic.generateReports.length > 0) {
                            if (topic.generateReports.filter(report => { return report.generateReportId === this.selectedReport.generateReportId; }).length > 0) {
                                this.selectedTopicIds.push(topic.generateReportTopicId);
                                topic.isActive = true;
                            } else {
                                topic.isActive = false;
                            }
                        } else {
                            topic.isActive = false;
                        }

                    });
                }
            }

            dlg.modal = true;
            dlg.show();
        }
    }

    saveTopic(dlg: any) {
        let updatedTopicName: string = this.txtTopicName.nativeElement.value;

        if (updatedTopicName.length > 0) {

            let topicIdx = this.reportTopics.map(s => { return s.generateReportTopicName.toLowerCase() }).indexOf(updatedTopicName.toLowerCase());
            if (topicIdx > -1 && this.selectedTopic.generateReportTopicId === -1) {
                this.errorMessage = 'This report topic already exists.  Please change this report topic or edit the existing report topic.';
                return;
            }
            if (topicIdx > -1 && this.selectedTopic.generateReportTopicId > 0) {
                let topic = this.reportTopics[topicIdx];
                if (topic.generateReportTopicId !== this.selectedTopic.generateReportTopicId) {
                    this.errorMessage = 'This report topic already exists.  Please change this report topic or edit the existing report topic.';
                    return;
                }
            }
            if (this.selectedReportIds.length < 1) {
                this.errorMessage = 'Please select at least one report to be associated with the report topic.';
                return;
            }

            let selectedReports: GenerateReportDto[] = [];
            this.selectedReportIds.forEach(t => {
                let idx = this.stateReports.map(s => { return s.generateReportId }).indexOf(t);
                if (idx > -1) {
                    selectedReports.push(this.stateReports[idx]);
                }
            });
            this.selectedTopic.generateReports = selectedReports;

            if (this.selectedTopic.generateReportTopicId > 0) {
                this._reportTopicService.updateTopic(this.selectedTopic)
                    .subscribe(data => {
                        let idx = this.reportTopics.map(s => { return s.generateReportTopicId }).indexOf(this.selectedTopic.generateReportTopicId);
                        this.reportTopics[idx].generateReports = selectedReports;
                        this.reportTopics[idx].generateReportTopicName = updatedTopicName;
                    });
            } else {
                this.selectedTopic.userName = this.userName;
                this.selectedTopic.isActive = true;
                this.selectedTopic.generateReportTopicName = updatedTopicName;
                this._reportTopicService.addTopic(this.selectedTopic)
                    .subscribe(data => {
                        this.visibleTopicIds = [];
                        this.populateReportsLibrary(updatedTopicName);
                    });
            }
            this.filter = '';
            dlg.hide();

        } else {
            this.errorMessage = 'Topic name cannot be empty. Please enter a valid name.';
        }
         
    }

    discardTopic(dlg: any) {

        this.selectedTopic = <GenerateReportTopicDto>{};
        this.selectedReportIds = [];
        this.filter = '';
        dlg.hide();

    }

    get filter(): string {
        return this._filter;
    }
    set filter(value: string) {

        if (this._filter !== value) {
            this._filter = value;
            if (this._toFilter) {
                clearTimeout(this._toFilter);
            }
            let self = this;
            this._toFilter = setTimeout(function () {
                self.cvData.refresh();
            }, 500);


        }
    }

    private _filterFunction(item: any) {

        if (this._reportLevelFilter && this._reportLevelFilter !== 'all') {
            let isFiltered: boolean = false;
            switch (this._reportLevelFilter) {
                case "sea": {
                    if (this._filter) { if ((item.reportName.toLowerCase().indexOf(this._filter.toLowerCase()) > -1) && item.seaLevel) { isFiltered = true; } }
                    else { if (item.seaLevel) { isFiltered = true; } }
                    break;
                }
                case "lea": {
                    if (this._filter) { if ((item.reportName.toLowerCase().indexOf(this._filter.toLowerCase()) > -1) && item.leaLevel) { isFiltered = true; } }
                    else { if (item.leaLevel) { isFiltered = true; } }
                    break;
                }
                case "sch": {
                    if (this._filter) { if ((item.reportName.toLowerCase().indexOf(this._filter.toLowerCase()) > -1) && item.schLevel) { isFiltered = true; } }
                    else { if (item.schLevel) { isFiltered = true; } }
                    break;
                }
            }
            return isFiltered;
        } else if (this._filter) {
            return item.reportName.toLowerCase().indexOf(this._filter.toLowerCase()) > -1;
        }
        return true;

    }

    initializeStateGrid(s, e) {

        let self = this;
        s.columnHeaders.setCellData(0, 0, "");
        
        s.cellEditEnded.addHandler(function (s, e) {
            if (e.col == 0) {
                if (self.selectedReportIds !== undefined) { 
                    let item = s.rows[e.row].dataItem;
                    let reportId = parseInt(item.generateReportId);
                    //console.log('selected report is : ' + reportId);
                    let idx = self.selectedReportIds.indexOf(reportId);
                    if (item.isActive) {
                        if (idx === -1) { self.selectedReportIds.push(reportId);}
                     } else {
                        self.selectedReportIds.splice(idx, 1);
                    }
               }
            }
        });

    }

    deleteTopic(dlg: any) {

        if (this.reportTopics.length === 1) {
            if (this.errorMessage !== null) { dlg.hide();}
            this.errorMessage = 'You must have at least one report topic in the Reports Library. This report topic cannot be removed.';
            return;
        }

        this._reportTopicService.removeTopic(this.selectedTopic.generateReportTopicId)
             .subscribe(data => {
                 let idx = this.reportTopics.map(s => { return s.generateReportTopicId }).indexOf(this.selectedTopic.generateReportTopicId);
                 this.reportTopics.splice(idx, 1);
            });

        dlg.hide();

    }

    reportSearch() {
        console.log('reportSearchBreak');
        this.isResultsView = true;
        this._reportLevelFilter = this.comboReportLevel.selectedValue;
        this.cvData.refresh();
      
    }
        
    addTopicsToReport(dlg: any) {

        let selectedReports: GenerateReportDto[] = [];
        let modifiedTopicIds: number[] = [];
                
        this._reportTopicService.updateReportTopics(this.selectedReport.generateReportId, this.selectedTopicIds)
            .subscribe(data => {
                this.reportTopics.forEach(t => {
                    
                    selectedReports = [];
                    selectedReports = t.generateReports;
                
                    let topicIdx = this.selectedTopicIds.indexOf(t.generateReportTopicId);
                    let reportIdx = selectedReports.map(r => r.generateReportId).indexOf(this.selectedReport.generateReportId);

                    if (reportIdx > -1) {
                        if (topicIdx === -1) {
                            selectedReports.splice(reportIdx, 1);
                            t.generateReports = selectedReports;
                            this.toggleTopic(t.generateReportTopicId);
                            modifiedTopicIds.push(t.generateReportTopicId);
                        }
                    } else {
                        if (topicIdx > -1) {
                            selectedReports.push(this.selectedReport);
                            t.generateReports = selectedReports;
                            this.toggleTopic(t.generateReportTopicId);
                            modifiedTopicIds.push(t.generateReportTopicId);
                        }
                    }
                  

                });
                this.visibleTopicIds = [];
                modifiedTopicIds.forEach(topicId => { this.visibleTopicIds.push(topicId); });              
                this.discardReport(dlg);
            });

        this.isResultsView = !this.isResultsView;

    }

    topic_checkedchange(e, topic: GenerateReportTopicDto) {

        let idx = this.selectedTopicIds.indexOf(topic.generateReportTopicId);
        this.isTopicChanged = true;
        if (e.target.checked) {
            topic.isActive = true;
            if (idx === -1) { this.selectedTopicIds.push(topic.generateReportTopicId); }
        } else {
            topic.isActive = false;
            if (idx > -1) { this.selectedTopicIds.splice(idx, 1); }
        }
        
    }

    discardReport(dlg: any) {

        this.selectedReport = <GenerateReportDto>{};
        this.selectedTopicIds = [];
        this.filter = '';
        dlg.hide();

    }

    gotoTopicsView() {
        this.isResultsView = !this.isResultsView;
        this.selectedReport = <GenerateReportDto>{};
        this.selectedTopicIds = [];
        this.filter = '';
    }

}
