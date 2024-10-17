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


declare let componentHandler: any;
declare let moment: any;



@Component({
    selector: 'generate-app-settings-toggleassessment',
    templateUrl: './toggle-assessment.component.html',
    styleUrls: ['./toggle-assessment.component.scss'],
    providers: [ToggleAssessmentService, AssessmentTypeService]
})
export class SettingsToggleAssessmentComponent implements AfterViewInit, OnInit {

    public errorMessage: string;
    public isLoading: boolean = false;
    private toggleAssessments: ToggleAssessment[];
    private grades: string[];
    private subjects: string[];
    private performanceLevels: string[];
    private assessmentTypes: AssessmentTypeDto[];
    private eogTypes: string[];
    public selectedToggleAssessment: ToggleAssessment;

    selectedAssessmentTypeIndex: number;
    selectedPerformanceLevelIndex: number;
    selectedProficientLevelIndex: number;
    selectedGradeIndex: number;
    selectedSubjectIndex: number;
    selectedEogIndex: number;

    @ViewChild('comboAssessmentType', { static: false }) comboAssessmentType: any;
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

    getAssessmentTypes() {
        let subject = this.subjects[this.selectedSubjectIndex];
        let grade = this.grades[this.selectedGradeIndex];

        console.log("getting assessment types")

        if (subject !== undefined && grade !== undefined) {
            if (subject.length > 0 && grade.length > 0) {
                this._assessmentTypeService.getGradeLevelAssessments(subject, grade).subscribe(
                    data => {
                        this.assessmentTypes = data;
                        this.assessmentTypes.unshift({ refAssessmentTypeId: 0, code: 'Select', definition: 'Select', description: 'Select' } as AssessmentTypeDto);
                    });
            }
        }
    }


    getAssessments() {
        this.toggleAssessments = [];
        this.selectedToggleAssessment = <ToggleAssessment>{};
        this.grades = [];
        this.performanceLevels = [];
        this.assessmentTypes = [];
        this.eogTypes = [];
        this.subjects = [];

        this.populateEOG();
        this.populatePerformanceLevels();
        this.populateGrades();
        this.populateSubjects();

        this._toggleAssessmentService.getAll().subscribe(
            data => {              
                this.toggleAssessments = data;
                this.isLoading = false;
            });
             
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
        let gradesList = ['Select Grade', 'PK', 'KG', 'UG', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', 'HS'];
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

        console.log(this.selectedToggleAssessment);

        this.selectedEogIndex = this.eogTypes.findIndex(t => t === this.selectedToggleAssessment.eog);
        this.selectedGradeIndex = this.grades.findIndex(t => t === this.selectedToggleAssessment.grade);
        this.selectedPerformanceLevelIndex = this.performanceLevels.findIndex(t => t === this.selectedToggleAssessment.performanceLevels);
        this.selectedProficientLevelIndex = this.performanceLevels.findIndex(t => t === this.selectedToggleAssessment.proficientOrAboveLevel);
        this.selectedSubjectIndex = this.subjects.findIndex(t => t === this.selectedToggleAssessment.subject);
        this.txtAssessmentName.nativeElement.value = this.selectedToggleAssessment.assessmentName;
        this.getAssessmentTypes();


        setTimeout(() => {
            console.log(this.selectedToggleAssessment.assessmentTypeCode);
            this.comboAssessmentType.selectedValue = this.selectedToggleAssessment.assessmentTypeCode;
        }, 1000);
        
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

        //console.log(this.selectedPerformanceLevelIndex);
        //console.log(this.comboperformanceLevel.selectedValue);
        console.log(this.comboperformanceLevel);

        let selectedPerformanceLevel = this.performanceLevels[this.selectedPerformanceLevelIndex];
        let selectedProficientLevel = this.performanceLevels[this.selectedProficientLevelIndex];

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
                if (this.grades[this.selectedGradeIndex] === 'HS') {
                    tempAssessments.forEach(a => {
                        if (secondaryGradesList.includes(a.grade)) { iserror = true; }
                    });
                } else {
                    if (secondaryGradesList.includes(this.grades[this.selectedGradeIndex])) {
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
            this.selectedToggleAssessment.performanceLevels = this.comboperformanceLevel.selectedValue;
            this.selectedToggleAssessment.proficientOrAboveLevel = this.comboproficientLevel.selectedValue;
            this.selectedToggleAssessment.grade = this.comboGrade.selectedValue;
            this.selectedToggleAssessment.eog = this.comboEog.selectedValue;
            this.selectedToggleAssessment.assessmentType = this.assessmentTypes.filter(f => f.code === this.comboAssessmentType.selectedValue)[0].description;

            this.selectedToggleAssessment.assessmentName = this.txtAssessmentName.nativeElement.value;
            this.selectedToggleAssessment.subject = this.comboSubject.selectedValue;

            if (this.selectedToggleAssessment.toggleAssessmentId > 0) {
                this._toggleAssessmentService.updateAssessment(this.selectedToggleAssessment)
                    .subscribe(data => {
                        let idx = this.toggleAssessments.map(s => { return s.toggleAssessmentId }).indexOf(this.selectedToggleAssessment.toggleAssessmentId);
                        this.toggleAssessments[idx] = this.selectedToggleAssessment;
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
            });

        deleteDialog.hide();
    }

    gotoToggle() {

        this._router.navigate(['/settings/toggle']);

        return false;
    }

   
}
