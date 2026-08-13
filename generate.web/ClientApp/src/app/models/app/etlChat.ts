export interface EtlChatSession {
    etlChatSessionId: number;
    etlMapId: number;
    sessionName: string;
    sourceConnection: string;
    sourceObject: string;
    status: string;
    maxLoops: number;
    currentLoop: number;
    schoolYear?: number;
    currentPhase: string;   // StagingLoad | StagingValidate | RdsMigrate | ReportMigrate | ReportValidate | Done
    lastEtlSql: string;
    lastTestSql: string;
    createdDate: string;
    createdBy: string;
    modifiedDate: string;
    modifiedBy: string;
}

export interface EtlChatMessage {
    etlChatMessageId: number;
    etlChatSessionId: number;
    role: string;          // user | assistant | system | tool
    messageType: string;   // chat | question | sql | testresult | status | error
    iterationNumber: number;
    content: string;
    createdDate: string;
}

export interface EtlChatSessionCreate {
    etlMapId: number;
    sessionName: string;
    sourceConnection: string;
    sourceObject: string;
    maxLoops?: number;
    schoolYear?: number;
}

export interface EtlChatStatus {
    session: EtlChatSession;
    isRunning: boolean;
}

export interface EtlMappingCoverage {
    etlMapId: number;
    factTypeCode: string;
    reportCodes: string;
    resolved: boolean;          // false = no fact type / requirements to check against
    isReady: boolean;           // true = every required Staging table (+ NOT NULL business columns) is mapped
    requiredTableCount: number;
    mappedRequiredTableCount: number;
    requiredTables: string[];
    missingTables: string[];
    missingRequiredColumns: string[];
    coveredTables: string[];
    summary: string;
}

export interface EtlChatIterationResult {
    etlChatSessionId: number;
    outcome: string;       // AwaitingInput | Passed | Failed | PhaseComplete | MaxLoopsReached | Error
    status: string;
    phase: string;         // EtlChatPhase.* the session is now in
    iterationNumber: number;
    maxLoops: number;
    sourceCount?: number;
    stagingCount?: number;
    canContinue: boolean;
    summary: string;
    newMessages: EtlChatMessage[];
}
