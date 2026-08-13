export interface AssistantSession {
    assistantSessionId: number;
    title: string;
    status: string;
    createdDate: string;
    createdBy: string;
    modifiedDate: string;
    modifiedBy: string;
}

export interface AssistantMessage {
    assistantMessageId: number;
    assistantSessionId: number;
    role: string;        // user | assistant | system
    content: string;
    createdDate: string;
}
