export interface CedsConnection {
    cedsConnectionId: number;
    cedsUseCaseId: number;
    cedsConnectionName: string;
    cedsConnectionDescription: string;
    cedsConnectionSource: string;
    cedsConnection_CedsElements: Array<number>;
}