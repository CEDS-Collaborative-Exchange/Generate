import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { EtlChatComponent } from './etl-chat.component';

const featureRoutes: Routes = [
  { path: ':mapId', component: EtlChatComponent }
];

@NgModule({
  imports: [RouterModule.forChild(featureRoutes)],
  exports: [RouterModule]
})
export class EtlChatRoutingModule { }
