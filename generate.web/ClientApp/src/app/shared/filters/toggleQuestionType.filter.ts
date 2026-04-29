import {Pipe, PipeTransform} from '@angular/core';

@Pipe({
    name: 'generateToggleQuestionTypeFilter',
    standalone: false
})
export class ToggleQuestionTypeFilter implements PipeTransform {

    transform(questionTypes, args?) {
        if (questionTypes === null) return null;
        return questionTypes.filter(questionType => { return questionType.toggleQuestionTypeId === args; });
    }
}