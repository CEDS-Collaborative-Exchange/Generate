export interface UpdatePackage {
    fileName: string;
    description: string;
    majorVersion: number;
    minorVersion: number;
    prerequisiteVersion: string;
    releaseDate: Date;
    databaseBackupSuggested: boolean;
    releaseNotesUrl: string;
}
