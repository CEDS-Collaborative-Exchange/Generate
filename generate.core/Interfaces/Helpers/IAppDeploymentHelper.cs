namespace generate.core.Interfaces.Helpers
{
    /// <summary>
    /// Deploys this app's own package to Azure: uploads it to Blob Storage, then re-points
    /// WEBSITE_RUN_FROM_PACKAGE at the new blob via the ARM app-settings API. That write
    /// itself triggers Azure to restart the app and mount the new package.
    /// </summary>
    public interface IAppDeploymentHelper
    {
        void DeployPackage(string packageZipFilePath);
    }
}
