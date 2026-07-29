import { Component, OnInit, OnDestroy, ViewChild, ElementRef } from '@angular/core';
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
export class EtlChatComponent implements OnInit, OnDestroy {

  mapId: number = null;
  sessions: EtlChatSession[] = [];
  selectedSession: EtlChatSession = null;
  messages: EtlChatMessage[] = [];

  isRunning = false;
  statusMessage = '';
  userInput = '';

  // While an iteration is running the server commits progress messages (model streaming,
  // SQL produced, executing, test counts) incrementally; poll so they appear live.
  private pollHandle: any = null;
  private readonly pollIntervalMs = 1500;

  // New-session form
  showNewForm = false;
  newName = '';
  newSourceConnection = '';
  newSourceObject = '';
  newMaxLoops = 10;
  newSchoolYear: number = null;

  @ViewChild('transcript') transcriptRef: ElementRef<HTMLElement>;

  constructor(private route: ActivatedRoute, private etlChatService: EtlChatService) { }

  ngOnInit() {
    this.mapId = +this.route.snapshot.paramMap.get('mapId');
    this.loadSessions();
  }

  ngOnDestroy() {
    this.stopPolling();
  }

  private startPolling() {
    if (this.pollHandle) { return; }
    this.pollHandle = setInterval(() => this.refreshMessages(), this.pollIntervalMs);
  }

  private stopPolling() {
    if (this.pollHandle) {
      clearInterval(this.pollHandle);
      this.pollHandle = null;
    }
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
      next: m => {
        const grew = (m || []).length !== this.messages.length ||
          (m && m.length > 0 && this.messages.length > 0 &&
           m[m.length - 1].content !== this.messages[this.messages.length - 1].content);
        this.messages = m || [];
        if (grew) { this.scrollToLatest(); }
      },
      error: () => this.statusMessage = 'Unable to load messages.'
    });
  }

  private scrollToLatest() {
    setTimeout(() => {
      const el = this.transcriptRef && this.transcriptRef.nativeElement;
      if (el) { el.scrollTop = el.scrollHeight; }
    }, 0);
  }

  createSession() {
    const create: EtlChatSessionCreate = {
      etlMapId: this.mapId,
      sessionName: this.newName,
      sourceConnection: this.newSourceConnection,
      sourceObject: this.newSourceObject,
      maxLoops: this.newMaxLoops,
      schoolYear: this.newSchoolYear
    };
    this.etlChatService.createSession(create).subscribe({
      next: session => {
        this.showNewForm = false;
        this.newName = this.newSourceConnection = this.newSourceObject = '';
        this.newSchoolYear = null;
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
    this.startPolling();
    this.iterate();
  }

  private iterate() {
    this.etlChatService.runIteration(this.selectedSession.etlChatSessionId).subscribe({
      next: result => {
        this.refreshMessages();
        this.selectedSession.status = result.status;
        this.selectedSession.currentLoop = result.iterationNumber;
        if (result.phase) { this.selectedSession.currentPhase = result.phase; }
        this.statusMessage = this.describe(result.outcome, result);
        if (result.canContinue) {
          // keep auto-advancing through the phases (staging → validate → RDS → reports → test)
          setTimeout(() => this.iterate(), 400);
        } else {
          this.isRunning = false;
          this.stopPolling();
        }
      },
      error: () => {
        this.isRunning = false;
        this.stopPolling();
        this.statusMessage = 'The iteration failed.';
        this.refreshMessages();
      }
    });
  }

  private describe(outcome: string, r: any): string {
    switch (outcome) {
      case 'Passed': return `✅ The numbers validated end-to-end. ${r.summary || ''}`;
      case 'PhaseComplete': return `${this.phaseLabel(r.phase)} — ${r.summary || ''}`;
      case 'Failed': return r.summary || `Loop ${r.iterationNumber}/${r.maxLoops}`;
      case 'AwaitingInput': return 'The assistant needs your input — answer below and Run again.';
      case 'MaxLoopsReached': return `Stopped at max ${r.maxLoops} loops. ${r.summary || ''}`;
      case 'Error': return `Error: ${r.summary}`;
      default: return r.summary || '';
    }
  }

  phaseLabel(phase: string): string {
    switch (phase) {
      case 'StagingLoad': return 'Step 2 · Staging load';
      case 'StagingValidate': return 'Step 2 · Staging validation';
      case 'RdsMigrate': return 'Step 3 · CEDS Data Warehouse';
      case 'ReportMigrate': return 'Step 4 · Report tables';
      case 'ReportValidate': return 'Step 4 · Validate the numbers';
      case 'Done': return 'Done';
      default: return phase || '';
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
