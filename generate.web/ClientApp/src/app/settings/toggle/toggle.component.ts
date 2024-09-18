import { Component, OnInit, AfterViewInit, AfterViewChecked } from '@angular/core';
import { UntypedFormGroup, UntypedFormBuilder, Validators, FormControl } from '@angular/forms';

import { Observable } from 'rxjs';
import { forkJoin } from 'rxjs'
import { Router } from '@angular/router';

import { ToggleQuestionService } from '../../services/app/toggleQuestion.service';
import { ToggleQuestion } from '../../models/app/toggleQuestion';
import { ToggleSectionService } from '../../services/app/toggleSection.service';
import { ToggleSection } from '../../models/app/toggleSection';
import { ToggleQuestionOptionService } from '../../services/app/toggleQuestionOption.service';
import { ToggleQuestionOption } from '../../models/app/toggleQuestionOption';
import { ToggleResponseService } from '../../services/app/toggleResponse.service';
import { ToggleResponse } from '../../models/app/toggleResponse';

import { UserService } from '../../services/app/user.service';

import { MatDialog } from '@angular/material/dialog';
import { YesNoDialogComponent } from 'src/app/shared/components/yes-no-dialog.component';

declare let componentHandler: any;
declare let moment: any;


@Component({
    selector: 'generate-app-settings-toggle',
    templateUrl: './toggle.component.html',
    styleUrls: ['./toggle.component.scss'],
    providers: [ToggleSectionService, ToggleQuestionService, ToggleQuestionOptionService, ToggleResponseService]
})
export class SettingsToggleComponent implements AfterViewInit, OnInit, AfterViewChecked {

    toggleQuestions: ToggleQuestion[];
    toggleQuestionOptions: ToggleQuestionOption[];
    toggleResponses: ToggleResponse[];
    toggleSections: ToggleSection[];

    toggleForm: UntypedFormGroup;

    errorMessage: string;
    resultMessage: string;
    responseValues: {
        [key: string]: string;
    };
    displayQuestions: {
        [key: string]: boolean;
    };
    responseDateValues: {
        [key: string]: Date;
    };
    isFormDirty: boolean;

    modifiedResponses: ToggleResponse[];
    newResponses: ToggleResponse[];
    modifiedResponse: ToggleResponse;
    questionResponses: ToggleResponse[];
    deleteResponses: ToggleResponse[];

    minCountDate: Date;
    maxCountDate: Date;

    skipConfirmation: boolean;

    constructor(
        private _router: Router,
        private _fb: UntypedFormBuilder,
        private _toggleQuestionService: ToggleQuestionService,
        private _toggleQuestionOptionService: ToggleQuestionOptionService,
        private _toggleSectionService: ToggleSectionService,
        private _toggleResponseService: ToggleResponseService,
        private _userService: UserService,
        private _dialog: MatDialog) {

        this.toggleForm = _fb.group({});

        let dateYear: number = new Date().getFullYear();
        this.minCountDate = new Date('10/1/' + dateYear);
        this.maxCountDate = new Date('12/1/' + dateYear);

        this.skipConfirmation = false;

    }

    ngOnInit() {
        this.getCedsConnections();
    }

    ngAfterViewInit() {
        componentHandler.upgradeAllRegistered();
    }

    ngAfterViewChecked() {
        componentHandler.upgradeAllRegistered();

    }

    gotoAssessments() {

        if (this.isFormDirty) {

            let dialogRef = this._dialog.open(YesNoDialogComponent, {

                data: {title: "Confirm", message: "Save changes and continue to Assessment Toggle?"}
            })

            dialogRef.afterClosed().subscribe(async (res) => {

                if (res === 'yes') {

                    this.skipConfirmation = true;

                    await this.saveResponse()

                    this._router.navigate(['/settings/toggle/assessment']);

                    return false;

                } else {

                    this.skipConfirmation = false;
                    //Do Nothing
                }
            })

        } else {
            this.skipConfirmation = false;

            this._router.navigate(['/settings/toggle/assessment']);

            return false;
        }
    }

    
    getCedsConnections() {

        this.toggleSections = [];
        this.toggleQuestions = [];
        this.toggleQuestionOptions = [];
        this.toggleResponses = [];
        this.modifiedResponses = [];
        this.newResponses = [];
        this.deleteResponses = [];
        this.responseValues = {};
        this.responseDateValues = {};
        this.displayQuestions = {};
        this.markDirty(false);
        this._userService.isLogoff = false;

        forkJoin(
            this._toggleSectionService.getAll(),
            this._toggleQuestionService.getAll(),
            this._toggleQuestionOptionService.getAll(),
            this._toggleResponseService.getAll()
        ).subscribe(data => {
            this.toggleSections = data[0];
            this.toggleQuestions = data[1];
            this.toggleQuestionOptions = data[2];
            this.toggleResponses = data[3];

            //Inject no response radio options
            for (let i = 0; i < this.toggleQuestions.length; i++) {

                //Check if we have a radio button group
                if (this.toggleQuestions[i].toggleQuestionType.toggleQuestionTypeCode === "radio") {
                    
                    //Push the response
                    this.toggleQuestionOptions.push({
                        optionText: "No Response",
                        toggleQuestionId: this.toggleQuestions[i].toggleQuestionId,
                        toggleQuestionOptionId: i + 999
                    })

                    //Check if the radio button group has an existing answer
                    let hasAnswer = false
                    for(let j = 0; j < this.toggleResponses.length; j++) {

                        if(this.toggleResponses[j].toggleQuestionId == this.toggleQuestions[i].toggleQuestionId) {
                            hasAnswer = true
                            break
                        }
                    }

                    //If there is not an existing answer, we need to highlight the no response option as a default
                    if(!hasAnswer) {
                        
                        this.toggleResponses.push({
                            toggleResponseId: null,
                            responseValue: null,
                            toggleQuestionId: this.toggleQuestions[i].toggleQuestionId,
                            toggleQuestionOptionId: i + 999
                        })
                    }
                }
            }

            this.toggleData();
        });
        
    }

    toggleData() {
        let group = {};
        this.toggleQuestions.forEach(question => {

            if (question.parentToggleQuestionId === null) {
                this.displayQuestions['ctrl_q_' + question.toggleQuestionId] = true;
            }
            //console.log('question is: ' + question.emapsQuestionAbbrv);

            switch (question.toggleQuestionType.toggleQuestionTypeCode) {

                case 'toggle':
                    let toggleKey = 'ctrl_q_' + question.toggleQuestionId;
                    let toggleValue = this.getResponseValue(question.toggleQuestionType.toggleQuestionTypeCode, question.toggleQuestionId);

                    let toggleText = 'No';
                    if (toggleValue) {
                        toggleText = 'Yes';
                    }
                    this.displayChildQuestions(toggleValue, question);
                    this.responseValues[toggleKey] = toggleText;
                    group[toggleKey] = [toggleValue || '', Validators.required];
                    break;
                case 'multitoggle':
                    this.toggleQuestionOptions.filter(multitogglequestion => { return multitogglequestion.toggleQuestionId === question.toggleQuestionId; })
                        .forEach(option => {
                            let optionKey = 'ctrl_q_' + question.toggleQuestionId + '_' + option.toggleQuestionOptionId;
                            let questionValue = false;

                            if (this.toggleResponses.filter(resp => { return ((resp.toggleQuestionId === question.toggleQuestionId) && (resp.toggleQuestionOptionId === option.toggleQuestionOptionId)); }).length > 0) {
                                questionValue = true;
                            }
                            group[optionKey] = [questionValue || '', Validators.required];
                        });
                    break;
                case 'radio':
                    this.toggleQuestionOptions.filter(radioquestion => {
                        return radioquestion.toggleQuestionId === question.toggleQuestionId;
                    }).forEach(option => {
                        let optionKey = 'ctrl_q_' + question.toggleQuestionId + '_' + option.toggleQuestionOptionId;
                        group[optionKey] = ['', Validators.required];

                        if (option.optionText === 'Other (specify)') {
                            let otherKey = 'ctrl_q_' + question.toggleQuestionId;
                            if (this.toggleResponses.filter(resp => { return resp.toggleQuestionOptionId === option.toggleQuestionOptionId; }).length > 0) {
                                let otherValue = this.getResponseValue(question.toggleQuestionType.toggleQuestionTypeCode, question.toggleQuestionId);
                                this.responseValues[otherKey] = otherValue;
                                this.responseValues['ctrl_q_o_' + question.toggleQuestionId] = option.toggleQuestionOptionId.toString();
                                group[otherKey] = [otherValue || '', Validators.required];
                            } else {
                                group[otherKey] = ['', Validators.required];
                                this.responseValues['ctrl_q_o_' + question.toggleQuestionId] = option.toggleQuestionOptionId.toString();
                            }

                        }

                    });
                    break;
                case 'date':

                    let d: string = new Date().toLocaleDateString();
                    // let dateYear: number = new Date().getFullYear();


                    let dateKey = 'ctrl_q_' + question.toggleQuestionId;
                    let dateValue = this.getResponseValue(question.toggleQuestionType.toggleQuestionTypeCode, question.toggleQuestionId);
                    //console.log('date value is: ' + question.emapsQuestionAbbrv + '  - ' + dateValue);
                    let dateVal: Date = new Date(d);

                    if (dateValue.length > 0) {
                       dateVal = new Date(dateValue);
                       this.responseDateValues[dateKey] = dateVal;
                       group[dateKey] = [dateVal || '', Validators.required];
                    } else {

                        if (question.emapsQuestionAbbrv === 'MEMBERDTE' || question.emapsQuestionAbbrv === 'ELDTE') {
                            dateVal = this.minCountDate;
                        }
                       //console.log('Date is: ' + dateVal);
                       this.responseDateValues[dateKey] = dateVal;
                       group[dateKey] = [dateVal, Validators.required];
                     }
                    break;
                default:
                    let questionKey = 'ctrl_q_' + question.toggleQuestionId;
                    let questionValue = this.getResponseValue(question.toggleQuestionType.toggleQuestionTypeCode, question.toggleQuestionId);
                    group[questionKey] = [questionValue || '', Validators.required];
                    break;
            }
        });

        this.toggleForm = this._fb.group(group);
    }


    checkRadioButton(questionid: number, optionid: number) {
        let result;
        if (this.toggleResponses) {
            if (this.toggleResponses.filter(resp => { return ((resp.toggleQuestionId === questionid) && (resp.toggleQuestionOptionId === optionid)); }).length > 0) {
                result = true;
            }
            else {
                result = false;
            }
        } else { result = false; }
        return result;
    }

    checkCheckbox(questionid: number, optionid: number) {
        let result = false;
        if (this.toggleResponses) {
            if (this.toggleResponses.filter(resp => { return ((resp.toggleQuestionId === questionid) && (resp.toggleQuestionOptionId === optionid)); }).length > 0) {
                result = true;
            }
        } 
        
        return result;
    }

    displayChildQuestions(responseValue: boolean, question: ToggleQuestion) {

        let isVisible = false;
        let parentYesQuestions = 'DISCPREM,DEFEXMINAGEIF,DEFEXCERTIF';
        let parentNoQuestions = 'DEFEXREFPER';

        if (responseValue) {

            if (parentYesQuestions.split(',').indexOf(question.emapsQuestionAbbrv) > -1) {
                isVisible = true;
            }

        } else {

            if (parentNoQuestions.split(',').indexOf(question.emapsQuestionAbbrv) > -1) {
                isVisible = true;
            }
        }

        if (isVisible) {

            this.toggleQuestions.filter(q => { return q.parentToggleQuestionId === question.toggleQuestionId; })
                .forEach(childQuestion => { this.displayQuestions['ctrl_q_' + childQuestion.toggleQuestionId] = true; });
        } else {

            this.toggleQuestions.filter(q => { return q.parentToggleQuestionId === question.toggleQuestionId; })
                .forEach(childQuestion => { this.displayQuestions['ctrl_q_' + childQuestion.toggleQuestionId] = false; });

        }

    }

    getResponseValue(controlType: string, questionid: number) {
        let result;
        this.questionResponses = [];
        this.questionResponses = this.toggleResponses.filter(resp => { return resp.toggleQuestionId === questionid; });
        if (this.questionResponses.length > 0) {
            if (controlType === 'singleselect') {
                result = this.questionResponses[0].toggleQuestionOptionId;
            } else if (controlType === 'multipleselect') {
                result = this.questionResponses[0].toggleQuestionOptionId;
            } else if (controlType === 'toggle') {
                if (this.questionResponses[0].responseValue === 'true') {
                    result = true;
                } else { result = false; }
            }
            else {
                result = this.questionResponses[0].responseValue;
            }
        } else {
            result = '';
        }
        return result;
    }

    clearResponses() {
        this.modifiedResponses = [];
        this.newResponses = [];
        this.modifiedResponse = null;
        this.deleteResponses = [];
    }

    markDirty(isDirty) {
        //console.log('Is form dirty: ' + isDirty);
        this.isFormDirty = isDirty;
        this._userService.canLogout = !this.isFormDirty;
    }

    setDateResponse(calendar: any, questionId) {
        //console.log('2a - ' + questionId + ' / ' + calendar.value);

        let dateYear: number = new Date(calendar.value).getFullYear();

        // if (calendar.value.getFullYear() !== dateYear) {
        //  calendar.value.setFullYear(dateYear);
        //}

        //console.log('2b - ' + questionId + ' / ' + calendar.value);


        let selectedDate = calendar.value;
        let isValidResponse = true;
        let errorMessage;
        let month = selectedDate.getMonth();
        let dayOfMonth = selectedDate.getDate();

        let toggleResponse = this.toggleResponses.filter(resp => { return resp.toggleQuestionId === questionId; });

        if (toggleResponse.length > 0) {
            let currentDate = this.toggleResponses.filter(resp => { return resp.toggleQuestionId === questionId; })[0].responseValue;

            //console.log('Selected date is: ' + selectedDate.toLocaleDateString());
            //console.log('Current date is: ' + new Date(currentDate).toLocaleDateString());

            if (selectedDate.toLocaleDateString() !== new Date(currentDate).toLocaleDateString()) {
                this.markDirty(true);
            }
        }
        else {
            this.markDirty(true);
        }
       
        if (this.toggleQuestions.filter(quest => { return ((quest.toggleQuestionId === parseInt(questionId)) && (quest.emapsQuestionAbbrv === 'CHDCTDTE')); }).length > 0) {

            if (month > 8) {
                if (month === 11 && dayOfMonth > 1) {
                    errorMessage = 'Child Count date must be between October 1 and December 1';
                    isValidResponse = false;
                }
            } else {
                errorMessage = 'Child Count date must be between October 1 and December 1';
                isValidResponse = false;
            }
        }

        if (isValidResponse) {
            let optionVal;
            let convertedDate = moment(selectedDate).format('MM/DD/YYYY');
            this.modifiedResponse = this.toggleResponses.filter(resp => { return resp.toggleQuestionId === parseInt(questionId); })[0];
            this.setSingleResponse(convertedDate, optionVal, parseInt(questionId));
            this.responseDateValues['ctrl_q_' + questionId] = new Date(convertedDate);
            //console.log('3 - ' + convertedDate + '/' + dateYear);
            //console.log('3 - ' + new Date(convertedDate + '/' + dateYear));
        } else {
            let snackbarContainer = document.querySelector('#generate-app-toggle__message');
            let data = { message: errorMessage };
            snackbarContainer['MaterialSnackbar'].showSnackbar(data);
            this.responseDateValues['ctrl_q_' + questionId] = new Date('11/01/' + dateYear);
            //console.log('4 - ' + new Date('11/01/' + dateYear));
            return;
        }

    }

    setResponse($event) {

        this.modifiedResponse = null;
        let questionId = parseInt($event.target.id.slice(2));
        console.log("question",questionId);
        let controlType = $event.target.tagName;
        console.log("control",controlType);
        //console.log('Mark dirty in setResponse');
        this.markDirty(true);
        let optionText = '';
        let optionVal;
        //console.log($event.target);
        if ((controlType === 'TEXTAREA') || (controlType === 'INPUT')) {
            if ($event.target.type === 'textarea') {
                this.modifiedResponse = this.toggleResponses.filter(resp => { return resp.toggleQuestionId === questionId; })[0];
                console.log($event.target.value, optionVal, questionId);
                this.setSingleResponse($event.target.value, optionVal, questionId);                
            } else if ($event.target.type === 'checkbox') {
                if ($event.target.name) {
                    questionId = parseInt($event.target.name);
                    optionText = this.toggleQuestionOptions.filter(option => { return option.toggleQuestionOptionId === parseInt($event.target.value); })[0].optionText;
                    this.modifiedResponse = this.toggleResponses.filter(resp => { return (resp.toggleQuestionId === questionId) && (resp.toggleQuestionOptionId === parseInt($event.target.value)); })[0];
                    this.setMultipleResponses(optionText, $event.target.value, questionId);
                } else {
                    optionText = $event.target.checked;
                    let toggleText = 'No';
                    if ($event.target.checked) {
                        toggleText = 'Yes';
                    }
                    this.displayChildQuestions($event.target.checked, this.toggleQuestions.filter(q => { return q.toggleQuestionId === questionId; })[0]);
                    this.responseValues['ctrl_q_' + questionId] = toggleText;
                    this.modifiedResponse = this.toggleResponses.filter(resp => { return resp.toggleQuestionId === questionId; })[0];
                    this.setSingleResponse(optionText, optionVal, questionId);
                }
            }
            else if ($event.target.type === 'radio') {

                //console.log(optionText);
                //if (optionText !== 'Other (specify)') {
                questionId = parseInt($event.target.name);
               
                let optionId: number = parseInt($event.target.id.split('_').slice(2));
                let optionValue = this.toggleQuestionOptions.filter(option => { return option.toggleQuestionOptionId === optionId; })[0];
                    
                if (optionValue !== undefined) {
                   // console.log(optionValue.optionText);
                    optionText = optionValue.optionText;

                    this.modifiedResponse = this.toggleResponses.filter(resp => { return resp.toggleQuestionId === questionId; })[0];
                    this.setSingleResponse(optionText, optionId, questionId);
                    this.responseValues['ctrl_q_' + questionId] = '';
                    this.responseValues['ctrl_q_o_' + questionId] = optionId.toString();
                    this.checkRadioButton(questionId, optionId);
                }
                //}
            }
        } else if (controlType === 'SELECT') {
            if ($event.target.multiple === true) {
                for (let i = 0; i < $event.target.selectedOptions.length; i++) {
                    optionText = $event.target.selectedOptions[i].text;
                    optionVal = $event.target.selectedOptions[i].value;
                }
            } else {
                optionText = $event.target.selectedOptions[0].text;
                optionVal = $event.target.value;
                this.modifiedResponse = this.toggleResponses.filter(resp => { return resp.toggleQuestionId === questionId; })[0];
                //console.log(this.modifiedResponse);
                this.setSingleResponse(optionText, optionVal, questionId);
            }
        }
    }

    setOtherRadioResponse($event, optionid) {
        //console.log('Mark dirty in setOtherRadioResponse');
        this.markDirty(true);
        let questionId = parseInt($event.target.id.slice(2));
        if (this.responseValues['ctrl_q_o_' + questionId]) {
            let selectedOptionId = parseInt(this.responseValues['ctrl_q_o_' + questionId]);
            if (optionid === selectedOptionId) {
                this.modifiedResponse = this.toggleResponses.filter(resp => { return resp.toggleQuestionId === questionId; })[0];
                this.setSingleResponse($event.target.value, optionid, questionId);
            }
        }
    }

    setMultipleResponses(text: string, optionVal: number, questionId: number) {
        if (this.modifiedResponse) {
            this.modifiedResponse.responseValue = text;
            this.modifiedResponse.toggleQuestionOptionId = optionVal;

            let deletedQuestion = this.deleteResponses.filter(resp => { return (resp.toggleQuestionId === questionId) && (resp.toggleQuestionOptionId === optionVal); })[0];

            if (deletedQuestion) {
                this.deleteResponses.splice(this.modifiedResponses.indexOf(deletedQuestion), 1);
            }
            this.deleteResponses.push(this.modifiedResponse);
            

        } else {
            this.modifiedResponse = {
                toggleResponseId: 0,
                responseValue: text,
                toggleQuestionId: questionId,
                toggleQuestionOptionId: optionVal
            };

            let answeredQuestion = this.newResponses.filter(resp => { return (resp.toggleQuestionId === questionId) && (resp.toggleQuestionOptionId === optionVal); })[0];

            if (answeredQuestion) {
                this.newResponses.splice(this.newResponses.indexOf(answeredQuestion), 1);
            }
            this.newResponses.push(this.modifiedResponse);
        }

    }

    setSingleResponse(text: string, optionVal: number, questionId: number) {

        if ((this.modifiedResponse) && (this.modifiedResponse.toggleResponseId)) {
            this.modifiedResponse.responseValue = text;
            this.modifiedResponse.toggleQuestionOptionId = optionVal;

            let answeredQuestion = this.modifiedResponses.filter(resp => { return resp.toggleQuestionId === questionId; })[0];
            if (answeredQuestion) {
                this.modifiedResponses.splice(this.modifiedResponses.indexOf(answeredQuestion), 1);
            }

            //If No Response is selected, we need to delete the existing response
            if(text !== "No Response") {
                this.modifiedResponses.push(this.modifiedResponse);
            } else {
                this.deleteResponses.push(this.modifiedResponse);
            }

        } else {
            this.modifiedResponse = {
                toggleResponseId: 0,
                responseValue: text,
                toggleQuestionId: questionId,
                toggleQuestionOptionId: optionVal
            };
            let answeredQuestion = this.newResponses.filter(resp => { return resp.toggleQuestionId === questionId; })[0];
            if (answeredQuestion) {
                this.newResponses.splice(this.newResponses.indexOf(answeredQuestion), 1);
            }
            
            this.newResponses.push(this.modifiedResponse);
        }
    }

       toggleQuestionValidations(startDateQuestionAbbrv: string, endDateQuestionAbbrv: string): [boolean, string] {

        let errorMessage = '';
        let isValid = true;
        let errorQuestionType = '';
        let isReferencePeriod = '';
             
           if (startDateQuestionAbbrv === 'DEFEXREFDTESTART') {
               errorQuestionType = 'reference period';
               let refPeriodQuestionId = this.toggleQuestions.filter(dateQuestion => { return dateQuestion.emapsQuestionAbbrv === 'DEFEXREFPER'; })[0].toggleQuestionId;
               isReferencePeriod = this.responseValues['ctrl_q_' + refPeriodQuestionId];
           }
           else if (startDateQuestionAbbrv === 'CTEPERKPROGYRSTART') { errorQuestionType = 'cte perkins program year' }
           else if (startDateQuestionAbbrv === 'IHETIMEPRDSTARTDTE') { errorQuestionType = 'IHE enrollment' }
           else if (startDateQuestionAbbrv === 'PYINCTIMEPRDSTARTDTE') { errorQuestionType = 'inclusion time period' }
           else if (startDateQuestionAbbrv === 'STATESYSTARTDTE') { errorQuestionType = 'state school year' }
           else if (startDateQuestionAbbrv === 'INSTSTARTDTE') { errorQuestionType = 'instructional period' }

            let startDateQuestionId = this.toggleQuestions.filter(dateQuestion => { return dateQuestion.emapsQuestionAbbrv === startDateQuestionAbbrv; })[0].toggleQuestionId;
            let endDateQuestionId = this.toggleQuestions.filter(dateQuestion => { return dateQuestion.emapsQuestionAbbrv === endDateQuestionAbbrv; })[0].toggleQuestionId;

           let startDate: string = this.responseDateValues['ctrl_q_' + startDateQuestionId].toLocaleDateString();
           let endDate: string = this.responseDateValues['ctrl_q_' + endDateQuestionId].toLocaleDateString();

           if (startDateQuestionAbbrv === 'DEFEXREFDTESTART' && isReferencePeriod === 'Yes') {
               return [isValid, ''];
           }

           if (startDate.length > 0 && endDate.length > 0) {
               if (new Date(startDate) >= new Date(endDate)) {
                   errorMessage = 'End Date of ' + errorQuestionType + ' cannot be on or before Start Date';
                   isValid = false;
               }
           } else if (startDate.length === 0 && endDate.length > 0) {
               errorMessage = 'Start Date of ' + errorQuestionType + ' is required';
               isValid = false;
           } else if (startDate.length > 0 && endDate.length === 0) {
               errorMessage = 'End Date of ' + errorQuestionType + ' is required';
               isValid = false;
           }

        return [isValid, errorMessage];
    }

    onSubmit() {
        this.saveResponse();
    }

    async saveResponse() {

        let isValidForm: boolean;
        let formMessage: string;
        let errorMessage: string;


        [isValidForm, errorMessage] = this.toggleQuestionValidations('DEFEXREFDTESTART', 'DEFEXREFDTEEND');
        if (!isValidForm) {
            formMessage = errorMessage;
        } else {
            [isValidForm, errorMessage] = this.toggleQuestionValidations('CTEPERKPROGYRSTART', 'CTEPERKPROGYREND');
            if (!isValidForm) {
                formMessage = errorMessage;
            } else {
                [isValidForm, errorMessage] = this.toggleQuestionValidations('IHETIMEPRDSTARTDTE', 'IHETIMEPRDENDDTE');
                if (!isValidForm) {
                    formMessage = errorMessage;
                }
                else {
                    [isValidForm, errorMessage] = this.toggleQuestionValidations('PYINCTIMEPRDSTARTDTE', 'PYINCTIMEPRDENDDTE');
                    if (!isValidForm) {
                        formMessage = errorMessage;
                    }
                    else {
                        [isValidForm, errorMessage] = this.toggleQuestionValidations('STATESYSTARTDTE', 'STATESYENDDTE');
                        if (!isValidForm) {
                            formMessage = errorMessage;
                        }
                        else {
                            [isValidForm, errorMessage] = this.toggleQuestionValidations('INSTSTARTDTE', 'INSTENDDTE');
                            if (!isValidForm) {
                                formMessage = errorMessage;
                            }
                            else {
                                if (this.deleteResponses.length > 0) {

                                    this._toggleResponseService.deleteResponses(this.deleteResponses)
                                        .subscribe(
                                            result => {
                                                this.resultMessage = <any>result;
                                                this._toggleResponseService.getAll()
                                                    .subscribe(data => {
                                                        this.toggleResponses = data;

                                                    });
                                            },
                                            error => this.errorMessage = <any>error);
                                }
                                if (this.modifiedResponses.length > 0) {

                                    this._toggleResponseService.updateResponses(this.modifiedResponses)
                                        .subscribe(
                                            result => {
                                                this.modifiedResponse = null;
                                                this.resultMessage = <any>result;
                                                this._toggleResponseService.getAll()
                                                    .subscribe(data => {
                                                        this.toggleResponses = data;

                                                    });
                                            },
                                            error => this.errorMessage = <any>error);

                                }
                                if (this.newResponses.length > 0) {
                                    console.log("save new");
                                    console.table(this.newResponses);
                                    this._toggleResponseService.saveResponses(this.newResponses)
                                        .subscribe(
                                            result => {
                                                this.resultMessage = <any>result;
                                                this._toggleResponseService.getAll()
                                                    .subscribe(data => {
                                                        this.toggleResponses = data;

                                                    });
                                            },
                                            error => this.errorMessage = <any>error);

                                }
                                this.clearResponses();
                                this.markDirty(false);
                                formMessage = 'Changes to the meta data have been saved.';

                            }
                        }
                    }
                }
            }
        }

        let snackbarContainer = document.querySelector('#generate-app-toggle__message');
        let data = { message: formMessage };
        snackbarContainer['MaterialSnackbar'].showSnackbar(data);

    }

    canDecativate(): boolean {
        if (this.skipConfirmation === true) {
            this.skipConfirmation = false;
            return true;
        } else if (this.toggleForm.dirty === false) {
            return true;
        }
        else if (this.isFormDirty === false) {
            return true;
        }
        else {
            return false;
        }

    }
}
