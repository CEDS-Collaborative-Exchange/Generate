import {Pipe, PipeTransform} from '@angular/core';

@Pipe({
    name: 'generateToggleQuestionFilter',
    standalone: false
})
export class ToggleQuestionFilter implements PipeTransform {

    transform(questions, args?) {
        if (questions === null) return null;
        return questions.filter(question => { return question.toggleSectionId === args; });
    }

}