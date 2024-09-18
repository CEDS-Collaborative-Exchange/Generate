using generate.test.UserInterface.Helpers;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using SeleniumExtras.WaitHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.test.UserInterface.Fixtures
{
    public class StateBrowserFixture : IDisposable
    {
        public string TestServer { get; set; }
        public string ScreenSize { get; set; }


        public IWebDriver WebDriver;

        public StateBrowserFixture()
        {
            this.ScreenSize = "sm";
            this.TestServer = "https://generate-test.aem-tx.com";

            this.WebDriver = BrowserHelper.GetWebDriver();

            this.ScreenSize = BrowserHelper.Login(this.WebDriver, this.TestServer, "dgurich", "Password123");

            WebDriverWait waitFor60seconds = new WebDriverWait(this.WebDriver, TimeSpan.FromSeconds(60));
            waitFor60seconds.IgnoreExceptionTypes(typeof(StaleElementReferenceException)); // ignore stale exception issues

            var linkElement = waitFor60seconds.Until(ExpectedConditions.ElementToBeClickable(By.Id("link_ReportsLibrary")));
        }



        public void Dispose()
        {
            if (this.WebDriver != null)
            {
                BrowserHelper.Logoff(this.WebDriver, this.ScreenSize);
                this.WebDriver.Dispose();
            }
        }
    }
}
