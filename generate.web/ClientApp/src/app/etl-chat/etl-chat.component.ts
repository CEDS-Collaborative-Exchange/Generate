import { Component, OnInit, OnDestroy, ViewChild, ElementRef } from '@angular/core';
import { ActivatedRoute } from '@angular/router';

import { EtlChatService } from '../services/app/etlChat.service';
import { EtlSourceMappingService } from '../services/app/etlSourceMapping.service';
import {
  EtlChatMessage,
  EtlChatSession,
  EtlChatSessionCreate,
  EtlChatStatus
} from '../models/app/etlChat';

interface PhaseStep {
  key: string;
  label: string;
}

@Component({
  selector: 'generate-etl-chat',
  templateUrl: './etl-chat.component.html',
  styleUrls: ['./etl-chat.component.scss'],
  standalone: false
})
export class EtlChatComponent implements OnInit, OnDestroy {

  mapId: number = null;
  mapName = '';
  sessions: EtlChatSession[] = [];
  selectedSession: EtlChatSession = null;
  messages: EtlChatMessage[] = [];

  isRunning = false;
  stopping = false;
  statusMessage = '';
  statusKind: 'info' | 'success' | 'error' = 'info';
  userInput = '';
  copiedMessageId: number = null;

  // Scroll-to-bottom affordance: only auto-scroll when the user is already at the bottom.
  autoScroll = true;
  showScrollButton = false;

  // While an iteration is running the server commits progress messages (model streaming,
  // SQL produced, executing, test counts) incrementally; poll so they appear live.
  private pollHandle: any = null;
  private readonly pollIntervalMs = 1500;

  // New-session form
  showNewForm = false;
  showAdvanced = false;          // reveals the optional source-object override
  newName = '';
  newSourceConnection = '';
  newSourceObject = '';          // optional override; blank = derive the source from the ETL Mapping
  newMaxLoops = 10;
  newSchoolYear: number = null;

  // Ordered phases of the end-to-end run, used to render the progress stepper.
  private readonly phaseOrder = [
    'StagingLoad', 'StagingValidate', 'RdsMigrate', 'RdsValidate', 'ReportMigrate', 'ReportValidate', 'Done'
  ];
  readonly steps: PhaseStep[] = [
    { key: 'StagingLoad', label: 'Staging load' },
    { key: 'StagingValidate', label: 'Validate staging' },
    { key: 'RdsMigrate', label: 'Warehouse' },
    { key: 'RdsValidate', label: 'Validate warehouse' },
    { key: 'ReportMigrate', label: 'Reports' },
    { key: 'ReportValidate', label: 'Validate numbers' }
  ];

  @ViewChild('transcript') transcriptRef: ElementRef<HTMLElement>;

  constructor(
    private route: ActivatedRoute,
    private etlChatService: EtlChatService,
    private mappingService: EtlSourceMappingService
  ) { }

  ngOnInit() {
    this.mapId = +this.route.snapshot.paramMap.get('mapId');
    this.loadMapName();
    this.loadSessions();
  }

  ngOnDestroy() {
    this.stopPolling();
  }

  private loadMapName() {
    this.mappingService.getMaps().subscribe({
      next: maps => {
        const m = (maps || []).find(x => x.etlMapId === this.mapId);
        this.mapName = m ? m.mapName : `Map #${this.mapId}`;
      },
      error: () => this.mapName = `Map #${this.mapId}`
    });
  }

  // While a background run is active, poll both the transcript and the run status so the UI keeps
  // showing live progress and knows when the run finishes (even after the user navigated away and back).
  private startPolling() {
    if (this.pollHandle) { return; }
    this.pollHandle = setInterval(() => {
      this.refreshMessages();
      if (this.selectedSession) {
        this.etlChatService.getStatus(this.selectedSession.etlChatSessionId).subscribe({
          next: s => this.applyStatus(s),
          error: () => { /* transient; keep polling */ }
        });
      }
    }, this.pollIntervalMs);
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
      error: () => this.setStatus('Unable to load sessions.', 'error')
    });
  }

  openSession(session: EtlChatSession) {
    this.selectedSession = session;
    this.statusMessage = '';
    this.isRunning = false;
    this.refreshMessages();
    // Reconnect: if a background run is already active for this session, resume the live view.
    this.etlChatService.getStatus(session.etlChatSessionId).subscribe({
      next: s => this.applyStatus(s),
      error: () => { /* status is best-effort */ }
    });
  }

  backToSessions() {
    this.stopPolling();
    this.selectedSession = null;
    this.messages = [];
    this.isRunning = false;
    this.loadSessions();
  }

  // Applies a server status snapshot: syncs session state and (re)starts live polling if it's running.
  private applyStatus(s: EtlChatStatus) {
    if (!s || !this.selectedSession) { return; }
    if (s.session) {
      this.selectedSession.status = s.session.status;
      this.selectedSession.currentPhase = s.session.currentPhase;
      this.selectedSession.currentLoop = s.session.currentLoop;
    }
    if (s.isRunning) {
      this.isRunning = true;
      this.setStatus(this.selectedSession.currentPhase
        ? `Working — ${this.phaseLabel(this.selectedSession.currentPhase)}…`
        : 'Working…', 'info');
      this.startPolling();
    } else if (this.isRunning) {
      // The run just finished.
      this.isRunning = false;
      this.stopPolling();
      this.refreshMessages();
      this.setStatus(this.finishedMessage(), this.selectedSession.status === 'Completed' ? 'success' : 'info');
    }
  }

  private finishedMessage(): string {
    switch (this.selectedSession && this.selectedSession.status) {
      case 'Completed': return '✓ The numbers validated end-to-end.';
      case 'AwaitingInput': return 'Paused — send an instruction or Run to continue.';
      case 'Failed': return 'Stopped. See the transcript for details.';
      default: return 'Idle.';
    }
  }

  refreshMessages() {
    if (!this.selectedSession) { return; }
    this.etlChatService.getMessages(this.selectedSession.etlChatSessionId).subscribe({
      next: m => {
        const grew = (m || []).length !== this.messages.length ||
          (m && m.length > 0 && this.messages.length > 0 &&
           m[m.length - 1].content !== this.messages[this.messages.length - 1].content);
        this.messages = m || [];
        if (grew && this.autoScroll) { this.scrollToLatest(); }
      },
      error: () => this.setStatus('Unable to load messages.', 'error')
    });
  }

  private scrollToLatest() {
    setTimeout(() => {
      const el = this.transcriptRef && this.transcriptRef.nativeElement;
      if (el) { el.scrollTop = el.scrollHeight; }
    }, 0);
  }

  // Called from the transcript (scroll): track whether the user is at the bottom so we only auto-scroll
  // when appropriate and can show a "jump to latest" button otherwise.
  onTranscriptScroll() {
    const el = this.transcriptRef && this.transcriptRef.nativeElement;
    if (!el) { return; }
    const atBottom = el.scrollHeight - el.scrollTop - el.clientHeight < 48;
    this.autoScroll = atBottom;
    this.showScrollButton = !atBottom;
  }

  scrollToBottom() {
    const el = this.transcriptRef && this.transcriptRef.nativeElement;
    if (el) { el.scrollTop = el.scrollHeight; }
    this.autoScroll = true;
    this.showScrollButton = false;
  }

  createSession() {
    if (!this.newName || !this.newName.trim()) {
      this.setStatus('Give the session a name first.', 'error');
      return;
    }
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
        this.showAdvanced = false;
        this.newName = this.newSourceConnection = this.newSourceObject = '';
        this.newSchoolYear = null;
        this.sessions.unshift(session);
        this.openSession(session);
        // Start working immediately — no need to click Run for a fresh session.
        this.run();
      },
      error: () => this.setStatus('Unable to create the session.', 'error')
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
      error: () => this.setStatus('Unable to delete the session.', 'error')
    });
  }

  // Start (or resume) the run. The loop runs SERVER-SIDE in the background, so it keeps advancing
  // through staging → validate → RDS → reports → test even if the user leaves the page.
  run() {
    if (!this.selectedSession || this.isRunning) { return; }
    this.isRunning = true;
    this.stopping = false;
    this.setStatus('Working…', 'info');
    this.startPolling();
    this.etlChatService.startRun(this.selectedSession.etlChatSessionId).subscribe({
      next: () => { /* the background loop is running; polling reflects progress */ },
      error: () => {
        this.isRunning = false;
        this.stopPolling();
        this.setStatus('Could not start the run.', 'error');
      }
    });
  }

  // Ask the server to stop after the current step finishes.
  stop() {
    if (!this.selectedSession || !this.isRunning) { return; }
    this.stopping = true;
    this.setStatus('Stopping after the current step…', 'info');
    this.etlChatService.stopRun(this.selectedSession.etlChatSessionId).subscribe({
      next: () => { /* status polling will flip isRunning off when the loop ends */ },
      error: () => this.setStatus('Could not send the stop request.', 'error')
    });
  }

  private setStatus(text: string, kind: 'info' | 'success' | 'error') {
    this.statusMessage = text;
    this.statusKind = kind;
  }

  // Enter sends; Shift+Enter inserts a newline (chat convention).
  onComposerKeydown(e: KeyboardEvent) {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      this.send();
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
        // A user prompt should kick the assistant off automatically.
        this.run();
      },
      error: () => this.setStatus('Unable to send the message.', 'error')
    });
  }

  // ---- Presentation helpers ----

  phaseLabel(phase: string): string {
    switch (phase) {
      case 'StagingLoad': return 'Step 2 · Staging load';
      case 'StagingValidate': return 'Step 2 · Staging validation';
      case 'RdsMigrate': return 'Step 3 · CEDS Data Warehouse';
      case 'RdsValidate': return 'Step 3 · Warehouse validation';
      case 'ReportMigrate': return 'Step 4 · Report tables';
      case 'ReportValidate': return 'Step 4 · Validate the numbers';
      case 'Done': return 'Done';
      default: return phase || 'Not started';
    }
  }

  // Stepper state for a given step index relative to the session's current phase.
  stepState(index: number): 'done' | 'active' | 'todo' {
    if (!this.selectedSession) { return 'todo'; }
    if (this.selectedSession.status === 'Completed') { return 'done'; }
    const current = this.phaseOrder.indexOf(this.selectedSession.currentPhase || 'StagingLoad');
    if (index < current) { return 'done'; }
    if (index === current) { return 'active'; }
    return 'todo';
  }

  statusLabel(status: string): string {
    switch (status) {
      case 'Active': return 'Active';
      case 'AwaitingInput': return 'Needs input';
      case 'Completed': return 'Completed';
      case 'Failed': return 'Stopped';
      default: return status || '';
    }
  }

  roleLabel(m: EtlChatMessage): string {
    if (m.role === 'user') { return 'You'; }
    if (m.role === 'tool') { return 'System'; }
    return 'AI ETL Developer';
  }

  avatarText(m: EtlChatMessage): string {
    if (m.role === 'user') { return 'You'; }
    if (m.role === 'tool') { return 'Sys'; }
    return 'AI';
  }

  roleClass(m: EtlChatMessage): string {
    if (m.role === 'user') { return 'etl-chat__msg--user'; }
    if (m.role === 'tool') { return 'etl-chat__msg--tool'; }
    return 'etl-chat__msg--assistant';
  }

  isSql(m: EtlChatMessage): boolean { return m.messageType === 'sql'; }
  isError(m: EtlChatMessage): boolean { return m.messageType === 'error'; }
  isTestResult(m: EtlChatMessage): boolean { return m.messageType === 'testresult'; }
  isQuestion(m: EtlChatMessage): boolean { return m.messageType === 'question'; }
  isStatus(m: EtlChatMessage): boolean { return m.messageType === 'status'; }

  isMono(m: EtlChatMessage): boolean {
    return this.isSql(m) || this.isTestResult(m);
  }

  messageTypeLabel(m: EtlChatMessage): string {
    switch (m.messageType) {
      case 'sql': return 'SQL';
      case 'testresult': return 'Validation results';
      case 'error': return 'Error';
      case 'question': return 'Question';
      case 'status': return 'Progress';
      default: return '';
    }
  }

  formatTime(iso: string): string {
    if (!iso) { return ''; }
    const d = new Date(iso);
    if (isNaN(d.getTime())) { return ''; }
    return d.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  }

  // Regurgitate the stored comment timestamp verbatim — no timezone conversion, so the screen shows
  // exactly the date/time saved in the DB chat log.
  formatDateTime(iso: string): string {
    if (!iso) { return ''; }
    const m = /^(\d{4})-(\d{2})-(\d{2})[T ](\d{2}):(\d{2})/.exec(iso);
    if (!m) {
      const d = new Date(iso);
      return isNaN(d.getTime()) ? iso : d.toLocaleString();
    }
    const year = +m[1];
    const month = +m[2];
    const day = +m[3];
    let hour = +m[4];
    const minute = m[5];
    const ampm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour === 0) { hour = 12; }
    return `${month}/${day}/${year}, ${hour}:${minute} ${ampm}`;
  }

  trackByMessageId(_index: number, m: EtlChatMessage): number {
    return m.etlChatMessageId;
  }

  trackBySessionId(_index: number, s: EtlChatSession): number {
    return s.etlChatSessionId;
  }

  copyMessage(m: EtlChatMessage) {
    const text = m.content || '';
    const done = () => {
      this.copiedMessageId = m.etlChatMessageId;
      setTimeout(() => { if (this.copiedMessageId === m.etlChatMessageId) { this.copiedMessageId = null; } }, 1500);
    };
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(text).then(done).catch(() => { /* ignore */ });
    }
  }
}
