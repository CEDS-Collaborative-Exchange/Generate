namespace generate.core.Dtos.App
{
    /// <summary>
    /// Values written to the "AppUpdate" configuration rows and returned in <see cref="UpdateStatusDto"/>.
    /// The settings page branches on the status codes and on UpdateStatusDto flags, never on phase
    /// text, so phase text can be reworded here without touching the client.
    /// </summary>
    public static class UpdateStatusValues
    {
        // App names, as used in update package folders ("web", "background") and status row keys
        public const string WebApp = "web";
        public const string BackgroundApp = "background";

        // Status codes
        public const string Ok = "OK";
        public const string InProgress = "IN_PROGRESS";
        public const string FailedPrefix = "FAILED - ";

        // Phases
        public const string PhaseValidatingPackage = "Validating Update Package";
        public const string PhaseBackingUpSite = "Backing up Generate Website";
        public const string PhaseTakingSiteOffline = "Taking Generate Website Offline";
        public const string PhaseUpdatingFiles = "Updating Generate Files";
        public const string PhaseBringingSiteOnline = "Bringing Generate Website Online";
        public const string PhaseUpdatingDatabase = "Updating Generate Database";
        public const string PhasePackagingDeployment = "Packaging Generate Deployment";
        public const string PhaseUploadingToAzure = "Uploading Package to Azure";
        public const string PhaseComplete = "Update Complete";
        public const string PhaseWaitingForWebUpdate = "Waiting for Web Update to Finish";
        public const string PhaseWaitingForBackgroundStart = "Background Site is starting to apply the update. This may take a few minutes.";
        public const string PhaseBackgroundNotStarted = "Background Update Not Started";
    }
}
