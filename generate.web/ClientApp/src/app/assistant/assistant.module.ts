import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { SharedModule } from '../shared/shared.module';
import { AssistantRoutingModule } from './assistant-routing.module';
import { AssistantComponent } from './assistant.component';
import { AssistantService } from '../services/app/assistant.service';

@NgModule({
  imports: [SharedModule, AssistantRoutingModule, FormsModule],
  declarations: [AssistantComponent],
  providers: [AssistantService]
})
export class AssistantModule { }
