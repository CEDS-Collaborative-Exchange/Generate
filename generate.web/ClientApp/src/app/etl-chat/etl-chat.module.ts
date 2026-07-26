import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { SharedModule } from '../shared/shared.module';
import { EtlChatRoutingModule } from './etl-chat-routing.module';
import { EtlChatComponent } from './etl-chat.component';
import { EtlChatService } from '../services/app/etlChat.service';

@NgModule({
  imports: [SharedModule, EtlChatRoutingModule, FormsModule],
  declarations: [EtlChatComponent],
  providers: [EtlChatService]
})
export class EtlChatModule { }
