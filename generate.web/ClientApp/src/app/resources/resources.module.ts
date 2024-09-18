import { NgModule } from '@angular/core';

// Shared
import { SharedModule } from '../shared/shared.module';

// Routing
import { ResourcesRoutingModule } from './resources-routing.module';

// Containers
import { ResourcesComponent } from './resources.component';

// Pages
import { ResourcesTutorialsComponent } from './tutorials/tutorials.component';

@NgModule({
    imports: [
        SharedModule,
        ResourcesRoutingModule        
    ],
    declarations: [
        ResourcesComponent,
        ResourcesTutorialsComponent
    ]
})
export class ResourcesModule { }
