import {Pipe, PipeTransform} from '@angular/core';

@Pipe({
    name: 'generateToggleQuestionResponseFilter',
    standalone: false
})
export class ToggleQuestionResponseFilter implements PipeTransform {

    transform(questionResponses, args?) {
        if (questionResponses === null) return null;
        return questionResponses.filter(questionResponse => { return questionResponse.toggleQuestionId === args; });
    }
}