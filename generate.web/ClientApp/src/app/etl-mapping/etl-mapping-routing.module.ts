import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { EtlMappingComponent } from './etl-mapping.component';

const featureRoutes: Routes = [
  {
    path: '',
    component: EtlMappingComponent
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
export class EtlMappingRoutingModule { }
