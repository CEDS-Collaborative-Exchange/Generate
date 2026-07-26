import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

import { EtlChatService } from '../services/app/etlChat.service';
import {
  EtlChatMessage,
  EtlChatSession,
  EtlChatSessionCreate
} from '../models/app/etlChat';

@Component({
  selector: 'generate-etl-chat',
  templateUrl: './etl-chat.component.html',
  styleUrls: ['./etl-chat.component.scss'],
  standalone: false
})
export class EtlChatComponent implements OnInit {

  mapId: number = null;
  sessions: EtlChatSession[] = [];
  selectedSession: EtlChatSession = null;
  messages: EtlChatMessage[] = [];

  isRunning = false;
  statusMessage = '';
  userInput = '';

  // New-session form
  showNewForm = false;
  newName = '';
  newSourceConnection = '';
  newSourceObject = '';
  newMaxLoops = 10;

  constructor(private route: ActivatedRoute, private etlChatService: EtlChatService) { }

  ngOnInit() {
    this.mapId = +this.route.snapshot.paramMap.get('mapId');
    this.loadSessions();
  }

  loadSessions() {
    this.etlChatService.getSessions(this.mapId).subscribe({
      next: s => this.sessions = s || [],
      error: () => this.statusMessage = 'Unable to load sessions.'
    });
  }

  openSession(session: EtlChatSession) {
    this.selectedSession = session;
    this.statusMessage = '';
    this.refreshMessages();
  }

  backToSessions() {
    this.selectedSession = null;
    this.messages = [];
    this.loadSessions();
  }

  refreshMessages() {
    if (!this.selectedSession) { return; }
    this.etlChatService.getMessages(this.selectedSession.etlChatSessionId).subscribe({
      next: m => this.messages = m || [],
      error: () => this.statusMessage = 'Unable to load messages.'
    });
  }

  createSession() {
    const create: EtlChatSessionCreate = {
      etlMapId: this.mapId,
      sessionName: this.newName,
      sourceConnection: this.newSourceConnection,
      sourceObject: this.newSourceObject,
      maxLoops: this.newMaxLoops
    };
    this.etlChatService.createSession(create).subscribe({
      next: session => {
        this.showNewForm = false;
        this.newName = this.newSourceConnection = this.newSourceObject = '';
        this.sessions.unshift(session);
        this.openSession(session);
      },
      error: () => this.statusMessage = 'Unable to create the session.'
    });
  }

  deleteSession(session: EtlChatSession, event: Event) {
    event.stopPropagation();
    if (!window.confirm(`Delete session "${session.sessionName}" and its transcript?`)) { return; }
    this.etlChatService.deleteSession(session.etlChatSessionId).subscribe({
      next: () => {
        if (this.selectedSession && this.selectedSession.etlChatSessionId === session.etlChatSessionId) {
          this.backToSessions();
        } else {
          this.loadSessions();
        }
      },
      error: () => this.statusMessage = 'Unable to delete the session.'
    });
  }

  // Kick off / continue the development loop. Runs one iteration at a time and auto-advances
  // while the server says it can continue (tests failing but loops remain).
  run() {
    if (!this.selectedSession || this.isRunning) { return; }
    this.isRunning = true;
    this.statusMessage = 'Working…';
    this.iterate();
  }

  private iterate() {
    this.etlChatService.runIteration(this.selectedSession.etlChatSessionId).subscribe({
      next: result => {
        this.refreshMessages();
        this.selectedSession.status = result.status;
        this.selectedSession.currentLoop = result.iterationNumber;
        this.statusMessage = this.describe(result.outcome, result);
        if (result.canContinue) {
          // keep looping toward matching counts
          setTimeout(() => this.iterate(), 400);
        } else {
          this.isRunning = false;
        }
      },
      error: () => {
        this.isRunning = false;
        this.statusMessage = 'The iteration failed.';
        this.refreshMessages();
      }
    });
  }

  private describe(outcome: string, r: any): string {
    switch (outcome) {
      case 'Passed': return `✅ Counts match (source ${r.sourceCount} = staging ${r.stagingCount}). Done in ${r.iterationNumber} loop(s).`;
      case 'Failed': return `Loop ${r.iterationNumber}/${r.maxLoops}: ${r.summary}`;
      case 'AwaitingInput': return 'The assistant needs your input — answer below and Run again.';
      case 'MaxLoopsReached': return `Stopped at max ${r.maxLoops} loops. ${r.summary || ''}`;
      case 'Error': return `Error: ${r.summary}`;
      default: return r.summary || '';
    }
  }

  send() {
    const text = (this.userInput || '').trim();
    if (!text || !this.selectedSession) { return; }
    this.userInput = '';
    this.etlChatService.postMessage(this.selectedSession.etlChatSessionId, text).subscribe({
      next: session => {
        if (session) { this.selectedSession.status = session.status; }
        this.refreshMessages();
      },
      error: () => this.statusMessage = 'Unable to send the message.'
    });
  }

  roleClass(m: EtlChatMessage): string {
    if (m.role === 'user') { return 'etl-chat__msg--user'; }
    if (m.role === 'tool') { return 'etl-chat__msg--tool'; }
    return 'etl-chat__msg--assistant';
  }

  isSql(m: EtlChatMessage): boolean {
    return m.messageType === 'sql';
  }
}
