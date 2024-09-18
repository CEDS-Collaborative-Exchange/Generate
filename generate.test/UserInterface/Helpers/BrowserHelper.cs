using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using SeleniumExtras.WaitHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace generate.test.UserInterface.Helpers
{
    public static class BrowserHelper
    {


        public static IWebDriver GetWebDriver()
        {
            var chromeOptions = new ChromeOptions();

            chromeOptions.AddAdditionalCapability("useAutomationExtension", false);

            chromeOptions.AddArgument("no-sandbox"); //https://stackoverflow.com/a/50725918/1689770
            //chromeOptions.AddArgument("headless");
            chromeOptions.AddArgument("allow-running-insecure-content");
            chromeOptions.AddArgument("log-level=3");
            chromeOptions.AddArgument("--window-size=1920,1080");

            chromeOptions.AddArgument("start-maximized"); // https://stackoverflow.com/a/26283818/1689770
            chromeOptions.AddArgument("enable-automation"); // https://stackoverflow.com/a/43840128/1689770
            chromeOptions.AddArgument("disable-infobars"); //https://stackoverflow.com/a/43840128/1689770
            chromeOptions.AddArgument("disable-dev-shm-usage"); //https://stackoverflow.com/a/50725918/1689770
            chromeOptions.AddArgument("disable-browser-side-navigation"); //https://stackoverflow.com/a/49123152/1689770
            chromeOptions.AddArgument("disable-gpu"); //https://stackoverflow.com/questions/51959986/how-to-solve-selenium-chromedriver-timed-out-receiving-message-from-renderer-exc
            chromeOptions.AddArgument("disable-extensions");
            chromeOptions.AddArgument("disable-features=VizDisplayCompositor");
            chromeOptions.AddArgument("dns-prefetch-disable");

            var rootDir = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().CodeBase).Replace("file:\\", "");
            chromeOptions.AddUserProfilePreference("download.default_directory", rootDir);

            ChromeDriverService chromeDriverService = ChromeDriverService.CreateDefaultService(AppDomain.CurrentDomain.BaseDirectory);
            chromeDriverService.SuppressInitialDiagnosticInformation = true;
            chromeDriverService.HideCommandPromptWindow = true;

            IWebDriver webDriver = new ChromeDriver(chromeDriverService, chromeOptions);

            return webDriver;
        }


        public static string Login(IWebDriver webDriver, string url, string login, string password)
        {
            var screenSize = "lg";

            System.Console.WriteLine("Navigating to " + url);

            DefaultWait<IWebDriver> fluentWait60seconds = new DefaultWait<IWebDriver>(webDriver);
            fluentWait60seconds.Timeout = TimeSpan.FromSeconds(60);
            fluentWait60seconds.PollingInterval = TimeSpan.FromMilliseconds(1500);
            fluentWait60seconds.IgnoreExceptionTypes(typeof(NoSuchElementException));

            DefaultWait<IWebDriver> fluentWait10seconds = new DefaultWait<IWebDriver>(webDriver);
            fluentWait10seconds.Timeout = TimeSpan.FromSeconds(10);
            fluentWait10seconds.PollingInterval = TimeSpan.FromMilliseconds(500);
            fluentWait10seconds.IgnoreExceptionTypes(typeof(NoSuchElementException));


            webDriver.Navigate().GoToUrl(url);
            fluentWait60seconds.Until(ExpectedConditions.ElementToBeClickable(By.Id("username")));


            System.Console.WriteLine("Login");

            System.Console.WriteLine("Looking for username-textbox");
            IWebElement loginUser = webDriver.FindElement(By.Id("username"));



            loginUser.SendKeys(login);

            System.Console.WriteLine("Looking for password-textbox");
            IWebElement loginPassword = webDriver.FindElement(By.Id("userpassword"));

            System.Console.WriteLine("Found password-textbox");

            loginPassword.Click(); 

            System.Console.WriteLine("Entering password");

            webDriver.FindElement(By.Id("userpassword")).SendKeys(password);

            try
            {
                System.Console.WriteLine("Looking for login button - lg");
                fluentWait10seconds.Until(ExpectedConditions.ElementToBeClickable(By.Id("loginButton-lg")));
                screenSize = "lg";
                System.Console.WriteLine("Found login button - " + screenSize);
                webDriver.FindElement(By.Id("loginButton-" + screenSize)).Click();
                System.Console.WriteLine("Clicked login button");
            }
            catch (Exception)
            {
                System.Console.WriteLine("Could not find login button - lg, so looking for login button - sm");

                fluentWait10seconds.Until(ExpectedConditions.ElementToBeClickable(By.Id("loginButton-sm")));

                screenSize = "sm";
                System.Console.WriteLine("Found login button - " + screenSize);
                webDriver.FindElement(By.Id("loginButton-" + screenSize)).Click();
                System.Console.WriteLine("Clicked login button - " + screenSize);
            }

            System.Console.WriteLine("Looking for logout button");
            fluentWait60seconds.Until(ExpectedConditions.ElementToBeClickable(By.Id("logoutButton-" + screenSize)));


            return screenSize;
        }

        public static void Logoff(IWebDriver webDriver, string screenSize)
        {

            if (webDriver != null)
            {
                System.Console.WriteLine("Log out - " + screenSize);
                IWebElement logout = webDriver.FindElement(By.Id("logoutButton-" + screenSize));
                webDriver.FindElement(By.Id("logoutButton-" + screenSize)).Click();
                System.Console.WriteLine("Close Browser");
                webDriver.Quit();
            }

        }
    }
}
