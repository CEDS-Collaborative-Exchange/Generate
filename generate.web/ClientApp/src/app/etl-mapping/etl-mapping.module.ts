import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';

// Shared
import { SharedModule } from '../shared/shared.module';

// Routing
import { EtlMappingRoutingModule } from './etl-mapping-routing.module';

// Pages
import { EtlMappingComponent } from './etl-mapping.component';

// Services
import { EtlSourceMappingService } from '../services/app/etlSourceMapping.service';

@NgModule({
  imports: [
    SharedModule,
    EtlMappingRoutingModule,
    FormsModule
  ],
  declarations: [
    EtlMappingComponent
  ],
  providers: [
    EtlSourceMappingService
  ]
})
export class EtlMappingModule { }
