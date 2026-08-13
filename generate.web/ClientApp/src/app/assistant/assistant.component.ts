import { Component, OnInit, OnDestroy } from '@angular/core';
import { AssistantService } from '../services/app/assistant.service';
import { AssistantSession, AssistantMessage } from '../models/app/assistant';

@Component({
  selector: 'generate-assistant',
  templateUrl: './assistant.component.html',
  styleUrls: ['./assistant.component.scss'],
  standalone: false
})
export class AssistantComponent implements OnInit, OnDestroy {

  sessions: AssistantSession[] = [];
  selectedSession: AssistantSession = null;
  messages: AssistantMessage[] = [];
  draft = '';
  isThinking = false;
  statusMessage = '';

  private pollTimer: any = null;

  constructor(private assistant: AssistantService) { }

  ngOnInit() {
    this.loadSessions();
  }

  ngOnDestroy() {
    this.stopPolling();
  }

  loadSessions() {
    this.assistant.getSessions().subscribe({
      next: s => {
        this.sessions = s || [];
        if (!this.selectedSession && this.sessions.length > 0) {
          this.openSession(this.sessions[0]);
        }
      },
      error: () => this.statusMessage = 'Unable to load chats.'
    });
  }

  newSession() {
    this.assistant.createSession('New chat').subscribe({
      next: session => {
        this.sessions.unshift(session);
        this.openSession(session);
      },
      error: () => this.statusMessage = 'Unable to start a chat.'
    });
  }

  openSession(session: AssistantSession) {
    this.selectedSession = session;
    this.statusMessage = '';
    this.loadMessages();
  }

  loadMessages() {
    if (!this.selectedSession) { return; }
    this.assistant.getMessages(this.selectedSession.assistantSessionId).subscribe({
      next: m => this.messages = m || [],
      error: () => this.statusMessage = 'Unable to load messages.'
    });
  }

  deleteSession(session: AssistantSession, event: Event) {
    event.stopPropagation();
    if (!window.confirm('Delete this chat and its history?')) { return; }
    this.assistant.deleteSession(session.assistantSessionId).subscribe({
      next: () => {
        this.sessions = this.sessions.filter(s => s.assistantSessionId !== session.assistantSessionId);
        if (this.selectedSession && this.selectedSession.assistantSessionId === session.assistantSessionId) {
          this.selectedSession = null;
          this.messages = [];
          if (this.sessions.length > 0) { this.openSession(this.sessions[0]); }
        }
      },
      error: () => this.statusMessage = 'The chat could not be deleted.'
    });
  }

  send() {
    const text = (this.draft || '').trim();
    if (!text || this.isThinking) { return; }

    // Create a session on the fly if none is selected.
    if (!this.selectedSession) {
      this.assistant.createSession('New chat').subscribe({
        next: session => { this.sessions.unshift(session); this.selectedSession = session; this.dispatch(text); },
        error: () => this.statusMessage = 'Unable to start a chat.'
      });
      return;
    }
    this.dispatch(text);
  }

  private dispatch(text: string) {
    this.draft = '';
    this.assistant.postMessage(this.selectedSession.assistantSessionId, text).subscribe({
      next: () => {
        this.loadMessages();
        this.isThinking = true;
        this.startPolling();
        this.assistant.run(this.selectedSession.assistantSessionId).subscribe({
          next: () => { this.isThinking = false; this.stopPolling(); this.loadMessages(); this.bumpSessionToTop(); },
          error: () => { this.isThinking = false; this.stopPolling(); this.loadMessages(); }
        });
      },
      error: () => this.statusMessage = 'The message could not be sent.'
    });
  }

  // While the reply streams server-side, poll the transcript so the user watches it type.
  private startPolling() {
    this.stopPolling();
    this.pollTimer = setInterval(() => this.loadMessages(), 1200);
  }
  private stopPolling() {
    if (this.pollTimer) { clearInterval(this.pollTimer); this.pollTimer = null; }
  }

  private bumpSessionToTop() {
    if (!this.selectedSession) { return; }
    // Reflect the new title/order after the first message named the session.
    this.assistant.getSessions().subscribe({ next: s => this.sessions = s || [] });
  }

  onKeydown(event: KeyboardEvent) {
    // Enter sends; Shift+Enter inserts a newline.
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault();
      this.send();
    }
  }
}
