import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { AssistantComponent } from './assistant.component';

const featureRoutes: Routes = [
  { path: '', component: AssistantComponent }
];

@NgModule({
  imports: [RouterModule.forChild(featureRoutes)],
  exports: [RouterModule]
})
export class AssistantRoutingModule { }
