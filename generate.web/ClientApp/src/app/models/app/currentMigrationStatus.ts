export interface CurrentMigrationStatus {

    odsMigrationStatusCode: string;
    odsLastMigrationTriggerDate: Date;
    odsLastMigrationDurationInSeconds: number;
    odsLastMigrationHistoryDate: Date;
    odsLastMigrationHistoryMessage: string;

    rdsMigrationStatusCode: string;
    rdsLastMigrationTriggerDate: Date;
    rdsLastMigrationDurationInSeconds: number;
    rdsLastMigrationHistoryDate: Date;
    rdsLastMigrationHistoryMessage: string;

    reportMigrationStatusCode: string;
    reportLastMigrationTriggerDate: Date;
    reportLastMigrationDurationInSeconds: number;
    reportLastMigrationHistoryDate: Date;
    reportLastMigrationHistoryMessage: string;
    userName: string;
    
}

