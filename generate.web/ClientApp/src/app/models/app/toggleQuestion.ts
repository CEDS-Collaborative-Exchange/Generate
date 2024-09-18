import {ToggleQuestionType} from './toggleQuestionType';

export interface ToggleQuestion {
    toggleQuestionId: number;
    toggleQuestionTypeId: number;
    toggleSectionId: number;
    emapsQuestionAbbrv: string;
    questionText: string;
    parentToggleQuestionId: number;
    toggleQuestionType: ToggleQuestionType;
}