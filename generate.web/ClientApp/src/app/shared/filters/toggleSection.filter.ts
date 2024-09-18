import {Pipe, PipeTransform} from '@angular/core';

@Pipe({
    name: 'generateToggleSectionFilter'
})
export class ToggleSectionFilter implements PipeTransform {

    transform(sections, args?) {
        if (sections === null) return null;
        return sections.filter(section => { return section.emapsParentSurveySectionAbbrv === args; });
    }

}