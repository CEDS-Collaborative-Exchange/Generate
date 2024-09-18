import {Pipe, PipeTransform} from '@angular/core';

@Pipe({
    name: 'generateToggleQuestionOtherOptionFilter'
})
export class ToggleQuestionOtherOptionFilter implements PipeTransform {

    transform(questionOptions, args?) {
        if (questionOptions === null) return null;
        return questionOptions.filter(questionOption => { return ((questionOption.toggleQuestionId === args) && (questionOption.optionText === 'Other (specify)')); });
    }
}