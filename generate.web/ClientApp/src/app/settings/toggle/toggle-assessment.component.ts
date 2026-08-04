import { Component, Input, AfterViewInit, OnInit, OnChanges, SimpleChange, ViewChild, ViewChildren, QueryList, ElementRef, NgZone } from '@angular/core';
import { FormGroup, FormBuilder, Validators, FormControl } from '@angular/forms';

import { Observable } from 'rxjs';
import { forkJoin } from 'rxjs'

import { UserService } from '../../services/app/user.service';
import { ToggleAssessmentService } from '../../services/app/toggleAssessment.service';
import { AssessmentTypeService } from '../../services/ods/assessmentType.service';
import { ToggleAssessment } from '../../models/app/toggleAssessment';
import { AssessmentTypeDto } from '../../models/ods/assessmentTypeDto';
import { Router } from '@angular/router';
import { PageEvent } from '@angular/material/paginator';


declare let componentHandler: any;
declare let moment: any;



@Component({
    selector: 'generate-app-settings-toggleassessment',
    templateUrl: './toggle-assessment.component.html',
    styleUrls: ['./toggle-assessment.component.scss'],
    providers: [ToggleAssessmentService, AssessmentTypeService],
    standalone: false
})
export class SettingsToggleAssessmentComponent implements AfterViewInit, OnInit {
    private assessmentTypeDisplayOrder: string[] = [
        'High school regular assessment I, without accommodations',
        'High school regular assessment I, with accommodations',
        'Alternate assessment',
        'High school regular assessment II, without accommodations',
        'High school regular assessment II, with accommodations',
        'High school regular assessment III, without accommodations',
        'High school regular assessment III, with accommodations',
        'Advanced assessment without accommodations',
        'Advanced assessment with accommodations',
        'Innovative Assessment Demonstration Authority pilot assessment without accommodations',
        'Innovative Assessment Demonstration Authority pilot assessment with accommodations',
        'Locally-selected nationally recognized high school assessment without accommodations',
        'Locally-selected nationally recognized high school assessment with accommodations'
    ];


    public errorMessage: string;
    public isLoading: boolean = false;
    public toggleAssessments: ToggleAssessment[];
    public filteredToggleAssessments: ToggleAssessment[];
    public grades: string[];
    public subjects: string[];
    public performanceLevels: string[];
    public assessmentTypes: AssessmentTypeDto[];
    public eogTypes: string[];
    public selectedToggleAssessment: ToggleAssessment;
    selectedAssessmentTypeIndex: number;
    sortColumn: string = '';
    sortDirection: 'asc' | 'desc' = 'asc';
    public pageIndex: number = 0;
    public pageSize: number = 15;
    public pageSizeOptions: number[] = [15, 25, 50];
    public pagedToggleAssessments: ToggleAssessment[];
    public filterSubjects: string[];
    public filterGrades: string[];
    public filterAssessmentTypes: string[];
    public selectedFilterSubject: string;
    public selectedFilterGrade: string;
    public selectedFilterAssessmentType: string;

    @ViewChild('comboAssessmentType', { static: false }) comboAssessmentType: any;
    @ViewChild('comboFilterSubject', { static: false }) comboFilterSubject: any;
    @ViewChild('comboFilterGrade', { static: false }) comboFilterGrade: any;
    @ViewChild('comboFilterAssessmentType', { static: false }) comboFilterAssessmentType: any;
    @ViewChild('txtAssessmentName', { static: false }) txtAssessmentName: ElementRef;
    @ViewChild('comboperformanceLevel', { static: false }) comboperformanceLevel: any;
    @ViewChild('comboproficientLevel', { static: false }) comboproficientLevel: any;
    @ViewChild('comboGrade', { static: false }) comboGrade: any;
    @ViewChild('comboSubject', { static: false }) comboSubject: any;
    @ViewChild('comboEog', { static: false }) comboEog: any;

    constructor(
        private _userService: UserService,
        private _toggleAssessmentService: ToggleAssessmentService,
        private _assessmentTypeService: AssessmentTypeService,
        private _router: Router) {

    }

    ngOnInit() {
        this.isLoading = true;
        this.getAssessments();
    }

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }

    SubjectChanged($event) {
        this.getAssessmentTypes();
    }

    GradeChanged($event) {
        this.getAssessmentTypes();
    }

    filterSubjectChanged(selectedItem: string) {
        this.selectedFilterSubject = selectedItem;
        this.applyGridFilters();
    }

    filterGradeChanged(selectedItem: string) {
        this.selectedFilterGrade = selectedItem;
        this.applyGridFilters();
    }

    filterAssessmentTypeChanged(selectedItem: string) {
        this.selectedFilterAssessmentType = selectedItem;
        this.applyGridFilters();
    }

    clearFilters() {
        this.selectedFilterSubject = 'All Subjects';
        this.selectedFilterGrade = 'All Grades';
        this.selectedFilterAssessmentType = 'All Assessment Types';

        if (this.comboFilterSubject) {
            this.comboFilterSubject.selectedItem = this.selectedFilterSubject;
        }

        if (this.comboFilterGrade) {
            this.comboFilterGrade.selectedItem = this.selectedFilterGrade;
        }

        if (this.comboFilterAssessmentType) {
            this.comboFilterAssessmentType.selectedItem = this.selectedFilterAssessmentType;
        }

        this.applyGridFilters();
    }

    getAssessmentTypes() {
        let subject = this.comboSubject.selectedItem;
        let grade = this.comboGrade.selectedItem;

        if (subject !== undefined && grade !== undefined) {
            if (subject.length > 0 && grade.length > 0) {
                this._assessmentTypeService.getGradeLevelAssessments(subject, grade).subscribe(
                    data => {
                        this.assessmentTypes = data;
                        this.assessmentTypes.unshift({ refAssessmentTypeChildrenWithDisabilitiesId: 0, code: 'Select', definition: 'Select', description: 'Select' } as AssessmentTypeDto);
                        this.comboAssessmentType.selectedValue = this.selectedToggleAssessment.assessmentTypeCode;
                        this.selectedAssessmentTypeIndex = this.assessmentTypes.filter(t => t.code === this.selectedToggleAssessment.assessmentTypeCode)[0].refAssessmentTypeChildrenWithDisabilitiesId;
                    });
            }
        }
    }


    getAssessments() {
        this.toggleAssessments = [];
        this.filteredToggleAssessments = [];
        this.pagedToggleAssessments = [];
        this.selectedToggleAssessment = <ToggleAssessment>{};
        this.grades = [];
        this.performanceLevels = [];
        this.assessmentTypes = [];
        this.eogTypes = [];
        this.subjects = [];
        this.filterAssessmentTypes = [];
        this.filterSubjects = [];
        this.filterGrades = [];
        this.selectedFilterSubject = 'All Subjects';
        this.selectedFilterGrade = 'All Grades';
        this.selectedFilterAssessmentType = 'All Assessment Types';

        this.populateEOG();
        this.populatePerformanceLevels();
        this.populateGrades();
        this.populateSubjects();

        this._toggleAssessmentService.getAll().subscribe(
            data => {              
                this.toggleAssessments = data;
                this.refreshFilterOptions();
                this.applyGridFilters();
                this.isLoading = false;
            });
             
    }

    refreshFilterOptions() {
        this.filterSubjects = ['All Subjects'];
        this.filterGrades = ['All Grades'];
        this.filterAssessmentTypes = ['All Assessment Types'];

        const subjects = this.toggleAssessments
            .map(t => t.subject)
            .filter(t => t !== undefined && t !== null && t.length > 0);
        const grades = this.toggleAssessments
            .map(t => this.normalizeGradeForDisplay(t.grade))
            .filter(t => t !== undefined && t !== null && t.length > 0);
        const assessmentTypes = this.toggleAssessments
            .map(t => t.assessmentType)
            .filter(t => t !== undefined && t !== null && t.length > 0);

        this.filterSubjects.push(...Array.from(new Set(subjects)).sort((a, b) => a.localeCompare(b)));
        this.filterGrades.push(...this.sortGradesForCombo(Array.from(new Set(grades))));
        this.filterAssessmentTypes.push(...this.sortAssessmentTypesForCombo(Array.from(new Set(assessmentTypes))));

        if (!this.filterSubjects.includes(this.selectedFilterSubject)) {
            this.selectedFilterSubject = 'All Subjects';
        }

        if (!this.filterGrades.includes(this.selectedFilterGrade)) {
            this.selectedFilterGrade = 'All Grades';
        }

        if (!this.filterAssessmentTypes.includes(this.selectedFilterAssessmentType)) {
            this.selectedFilterAssessmentType = 'All Assessment Types';
        }
    }

    applyGridFilters() {
        if (this.toggleAssessments === undefined || this.toggleAssessments === null) {
            this.filteredToggleAssessments = [];
            this.pagedToggleAssessments = [];
            return;
        }

        this.filteredToggleAssessments = this.toggleAssessments.filter(a => {
            const matchSubject = this.selectedFilterSubject === 'All Subjects' || a.subject === this.selectedFilterSubject;
            const matchGrade = this.selectedFilterGrade === 'All Grades' || this.normalizeGradeForDisplay(a.grade) === this.selectedFilterGrade;
            const matchAssessmentType = this.selectedFilterAssessmentType === 'All Assessment Types' || a.assessmentType === this.selectedFilterAssessmentType;

            return matchSubject && matchGrade && matchAssessmentType;
        });

        if (this.sortColumn !== undefined && this.sortColumn.length > 0) {
            this.sortFilteredAssessments();
        } else {
            this.sortByDefaultOrder();
        }

        this.pageIndex = 0;
        this.updatePagedToggleAssessments();
    }

    private sortByDefaultOrder() {
        const gradeOrder = ['PK', 'KG', 'UG', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', 'HS'];
        const gradeRank = new Map<string, number>();

        gradeOrder.forEach((grade, index) => gradeRank.set(grade, index));

        this.filteredToggleAssessments.sort((a, b) => {
            const subjectCompare = this.safeStringCompare(a.subject, b.subject);
            if (subjectCompare !== 0) {
                return subjectCompare;
            }

            const aGradeRank = gradeRank.get(this.normalizeGradeForDisplay(a.grade)) ?? Number.MAX_SAFE_INTEGER;
            const bGradeRank = gradeRank.get(this.normalizeGradeForDisplay(b.grade)) ?? Number.MAX_SAFE_INTEGER;

            if (aGradeRank !== bGradeRank) {
                return aGradeRank - bGradeRank;
            }

            const assessmentTypeCompare = this.compareAssessmentTypeByCustomOrder(a.assessmentType, b.assessmentType);
            if (assessmentTypeCompare !== 0) {
                return assessmentTypeCompare;
            }

            return this.safeStringCompare(a.assessmentType, b.assessmentType);
        });
    }

    private safeStringCompare(aValue: string = '', bValue: string = ''): number {
        return aValue.localeCompare(bValue);
    }

    private normalizeGradeForDisplay(grade: string = ''): string {
        return grade === '13' ? 'HS' : grade;
    }

    private normalizeAssessmentTypeForLookup(assessmentType: string = ''): string {
        return assessmentType.trim().toLowerCase();
    }

    private getAssessmentTypeRank(assessmentType: string = ''): number {
        const normalizedAssessmentType = this.normalizeAssessmentTypeForLookup(assessmentType);
        const rank = this.assessmentTypeDisplayOrder.findIndex(
            assessment => this.normalizeAssessmentTypeForLookup(assessment) === normalizedAssessmentType
        );

        return rank === -1 ? Number.MAX_SAFE_INTEGER : rank;
    }

    private compareAssessmentTypeByCustomOrder(aAssessmentType: string = '', bAssessmentType: string = ''): number {
        const aRank = this.getAssessmentTypeRank(aAssessmentType);
        const bRank = this.getAssessmentTypeRank(bAssessmentType);

        if (aRank !== bRank) {
            return aRank - bRank;
        }

        return 0;
    }

    private sortGradesForCombo(grades: string[]): string[] {
        const gradeDisplayOrder = ['KG', 'PK', 'UG', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', 'HS'];
        const gradeRank = new Map<string, number>();

        gradeDisplayOrder.forEach((grade, index) => gradeRank.set(grade, index));

        return grades.slice().sort((a, b) => {
            const aRank = gradeRank.get(a);
            const bRank = gradeRank.get(b);

            if (aRank !== undefined && bRank !== undefined) {
                return aRank - bRank;
            }

            if (aRank !== undefined) {
                return -1;
            }

            if (bRank !== undefined) {
                return 1;
            }

            return a.localeCompare(b);
        });
    }

    private sortAssessmentTypesForCombo(assessmentTypes: string[]): string[] {
        return assessmentTypes.slice().sort((a, b) => {
            const rankCompare = this.compareAssessmentTypeByCustomOrder(a, b);
            if (rankCompare !== 0) {
                return rankCompare;
            }

            return a.localeCompare(b);
        });
    }

    updatePagedToggleAssessments() {
        const startIndex = this.pageIndex * this.pageSize;
        const endIndex = startIndex + this.pageSize;
        this.pagedToggleAssessments = this.filteredToggleAssessments.slice(startIndex, endIndex);
    }

    pageChanged(event: PageEvent) {
        this.pageIndex = event.pageIndex;
        this.pageSize = event.pageSize;
        this.updatePagedToggleAssessments();
    }

    sortFilteredAssessments() {
        this.filteredToggleAssessments.sort((a, b) => {
            if (this.sortColumn === 'assessmentType') {
                const rankCompare = this.compareAssessmentTypeByCustomOrder(a.assessmentType, b.assessmentType);

                if (rankCompare !== 0) {
                    return this.sortDirection === 'asc' ? rankCompare : -rankCompare;
                }

                const fallbackCompare = this.safeStringCompare(a.assessmentType, b.assessmentType);
                return this.sortDirection === 'asc' ? fallbackCompare : -fallbackCompare;
            }

            let aValue = a[this.sortColumn];
            let bValue = b[this.sortColumn];

            if (aValue == null && bValue == null) return 0;
            if (aValue == null) return this.sortDirection === 'asc' ? 1 : -1;
            if (bValue == null) return this.sortDirection === 'asc' ? -1 : 1;

            const aStr = String(aValue).toLowerCase();
            const bStr = String(bValue).toLowerCase();

            if (aStr < bStr) {
                return this.sortDirection === 'asc' ? -1 : 1;
            } else if (aStr > bStr) {
                return this.sortDirection === 'asc' ? 1 : -1;
            }
            return 0;
        });

        this.updatePagedToggleAssessments();
    }


    populateEOG() {
        this.eogTypes = [];
        this.eogTypes.push('Select');
        this.eogTypes.push('End of Grade');
        this.eogTypes.push('End of Course');
        this.eogTypes.push('Other');
    }

    populateSubjects() {
        this.subjects = [];
        this.subjects.push('Select');
        this.subjects.push('MATH');
        this.subjects.push('RLA');
        this.subjects.push('CTE');
        this.subjects.push('SCIENCE');
    }

    populatePerformanceLevels() {
        let performanceLevelList = ['Select', '2', '3', '4', '5', '6'];
        this.performanceLevels = [];

        for (let i in performanceLevelList) {
            this.performanceLevels.push(performanceLevelList[i]);
        }
    }

    populateGrades() {
        let gradesList = ['Select Grade', 'KG', 'PK', 'UG', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', 'HS'];
        this.grades = [];

        for (let i in gradesList) {
            this.grades.push(gradesList[i]);
        }
    }

    showDialog(dlg: any, dialogId: number) {

        this.errorMessage = null;
        dlg.modal = true;
        dlg.show();

        this.selectedToggleAssessment = null;

        if (dialogId > 0) {
            this.selectedToggleAssessment = this.toggleAssessments.filter(t => { return (t.toggleAssessmentId === dialogId); })[0];

        } else {
            this.selectedToggleAssessment = <ToggleAssessment>{ assessmentName: '', assessmentTypeCode: 'Select', eog: 'Select', grade: 'Select Grade', performanceLevels: 'Select', proficientOrAboveLevel: 'Select', subject: 'Select' };
        }

        this.comboEog.selectedItem = this.selectedToggleAssessment.eog;
        this.comboGrade.selectedItem = this.normalizeGradeForDisplay(this.selectedToggleAssessment.grade);
        this.comboperformanceLevel.selectedItem = this.selectedToggleAssessment.performanceLevels;
        this.comboproficientLevel.selectedItem = this.selectedToggleAssessment.proficientOrAboveLevel;
        this.comboSubject.selectedItem = this.selectedToggleAssessment.subject;

        this.txtAssessmentName.nativeElement.value = this.selectedToggleAssessment.assessmentName;
        this.getAssessmentTypes();

        
    }

    removeAssessmentDialog(dlg: any, dialogId: number) {
        dlg.modal = true;
        dlg.show();

        this.selectedToggleAssessment = this.toggleAssessments.filter(t => { return (t.toggleAssessmentId === dialogId); })[0];
        
    }

    discardDialog(dlg: any) {
        dlg.hide();
        this.selectedToggleAssessment = <ToggleAssessment>{ assessmentName: '', assessmentTypeCode: 'Select', assessmentType: '', eog: 'Select', grade: 'Select Grade', performanceLevels: 'Select', proficientOrAboveLevel: 'Select', subject: 'Select' };
    }

    saveAssessment(assessmentDialog: any) {

        let selectedPerformanceLevel = this.comboperformanceLevel.selectedItem;
        let selectedProficientLevel = this.comboproficientLevel.selectedItem;

        if (Number(selectedPerformanceLevel) < 3) {
            this.errorMessage = 'At least three performance levels must be selected.';
            return;
        }

        if (Number(selectedProficientLevel) > Number(selectedPerformanceLevel)) {
            this.errorMessage = 'Proficient Level is higher than the total number of performance levels.';
            return;
        }

        if (this.comboAssessmentType.selectedValue !== undefined || this.comboAssessmentType.selectedValue !== null) {

            let secondaryGradesList = ['09', '10', '11', '12'];
            let iserror: boolean = false;
            let tempAssessments = this.toggleAssessments.filter(f => f.assessmentTypeCode === this.comboAssessmentType.selectedValue && f.assessmentName !== this.txtAssessmentName.nativeElement.value);
            if (tempAssessments.length > 0) {
                if (this.comboGrade.selectedItem === 'HS') {
                    tempAssessments.forEach(a => {
                        if (secondaryGradesList.includes(a.grade)) { iserror = true; }
                    });
                } else {
                    if (secondaryGradesList.includes(this.comboGrade.selectedItem)) {
                        tempAssessments.forEach(a => {
                            if (a.grade === 'HS') { iserror = true; }
                        });
                    }
                }
            }

            if (iserror) {
                this.errorMessage = 'Cannot have grades 9-12 and HS selected for the same assessment type.'
                return;
            }



            this.selectedToggleAssessment.assessmentTypeCode = this.comboAssessmentType.selectedValue;
            this.selectedToggleAssessment.performanceLevels = this.comboperformanceLevel.selectedItem;
            this.selectedToggleAssessment.proficientOrAboveLevel = this.comboproficientLevel.selectedItem;
            this.selectedToggleAssessment.grade = this.comboGrade.selectedItem;
            this.selectedToggleAssessment.eog = this.comboEog.selectedItem;
            this.selectedToggleAssessment.assessmentType = this.assessmentTypes.filter(f => f.code === this.comboAssessmentType.selectedValue)[0].description;

            this.selectedToggleAssessment.assessmentName = this.txtAssessmentName.nativeElement.value;
            this.selectedToggleAssessment.subject = this.comboSubject.selectedItem;

            if (this.selectedToggleAssessment.toggleAssessmentId > 0) {
                this._toggleAssessmentService.updateAssessment(this.selectedToggleAssessment)
                    .subscribe(data => {
                        let idx = this.toggleAssessments.map(s => { return s.toggleAssessmentId }).indexOf(this.selectedToggleAssessment.toggleAssessmentId);
                        this.toggleAssessments[idx] = this.selectedToggleAssessment;
                        this.refreshFilterOptions();
                        this.applyGridFilters();
                    });
            } else {
                this._toggleAssessmentService.addAssessment(this.selectedToggleAssessment)
                    .subscribe(data => {
                        this.getAssessments();
                    });
            }
        }
        
        this.errorMessage = null
       assessmentDialog.hide();
    }

    deleteAssessment(deleteDialog: any) {
        this._toggleAssessmentService.deleteAssessments(this.selectedToggleAssessment.toggleAssessmentId)
            .subscribe(data => {
                let idx = this.toggleAssessments.map(s => { return s.toggleAssessmentId }).indexOf(this.selectedToggleAssessment.toggleAssessmentId);
                this.toggleAssessments.splice(idx, 1);
                this.refreshFilterOptions();
                this.applyGridFilters();
            });

        deleteDialog.hide();
    }

    gotoToggle() {

        this._router.navigate(['/settings/toggle']);

        return false;
    }

    sortBy(column: string) {
        if (this.sortColumn === column) {
            this.sortDirection = this.sortDirection === 'asc' ? 'desc' : 'asc';
        } else {
            this.sortColumn = column;
            this.sortDirection = 'asc';
        }

        this.sortFilteredAssessments();
    }

   
}
