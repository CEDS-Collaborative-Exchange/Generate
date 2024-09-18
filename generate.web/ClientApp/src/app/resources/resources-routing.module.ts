import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

// Container
import { ResourcesComponent } from './resources.component';

// Pages
import { ResourcesTutorialsComponent } from './tutorials/tutorials.component';

const featureRoutes: Routes = [

    {
        path: '',
        component: ResourcesComponent,
        children: [
            { path: '', redirectTo: 'tutorials', pathMatch: 'full' },
            { path: 'tutorials', component: ResourcesTutorialsComponent }
        ]
    }

];

@NgModule({
    imports: [
        RouterModule.forChild(featureRoutes)
    ],
    exports: [
        RouterModule
    ]
})
export class ResourcesRoutingModule { }
