import {Pipe, PipeTransform} from '@angular/core';

@Pipe({
    name: 'generateToggleQuestionOptionFilter'
})
export class ToggleQuestionOptionFilter implements PipeTransform {

    transform(questionOptions, args?) {
        if (questionOptions === null) return null;
        return questionOptions.filter(questionOption => { return questionOption.toggleQuestionId === args; });
    }
}