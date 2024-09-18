using generate.test.UserInterface.Fixtures;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using SeleniumExtras.WaitHelpers;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Xunit;
using Xunit.Sdk;

namespace generate.test.UserInterface.Reports
{
    [Collection("AcceptanceTestsCollection")]
    [Trait("Category", "UserInterface")]
    public class EdFactsReportTests : IClassFixture<EdFactsBrowserFixture>
    {

        private readonly EdFactsBrowserFixture _browserFixture;


        public EdFactsReportTests(EdFactsBrowserFixture browserFixture)
        {
            _browserFixture = browserFixture;

        }

        /// <summary>
        /// Test Report
        /// </summary>
        private void TestReport(string reportCode, List<string> reportLevels = null)
        {

            System.Console.WriteLine("EdFactsReports_" + reportCode);

            string currentSubmissionYear = "2021";
            string priorSubmissionYear = "2020";

            if (reportCode == "C035")
            {
                currentSubmissionYear = "2019";
                priorSubmissionYear = "2018";
            }

            List<string> activeFileSpecs = new List<string>();

            activeFileSpecs.Add("C002");
            activeFileSpecs.Add("C005");
            activeFileSpecs.Add("C006");
            activeFileSpecs.Add("C007");
            activeFileSpecs.Add("C009");
            activeFileSpecs.Add("C029");
            activeFileSpecs.Add("C033");
            activeFileSpecs.Add("C035");
            activeFileSpecs.Add("C039");
            activeFileSpecs.Add("C045");
            activeFileSpecs.Add("C050");
            activeFileSpecs.Add("C052");
            activeFileSpecs.Add("C054");
            activeFileSpecs.Add("C059");
            activeFileSpecs.Add("C067");
            activeFileSpecs.Add("C070");
            activeFileSpecs.Add("C086");
            activeFileSpecs.Add("C088");
            activeFileSpecs.Add("C089");
            activeFileSpecs.Add("C099");
            activeFileSpecs.Add("C103");
            activeFileSpecs.Add("C112");
            activeFileSpecs.Add("C116");
            activeFileSpecs.Add("C118");
            activeFileSpecs.Add("C121");
            activeFileSpecs.Add("C122");
            activeFileSpecs.Add("C126");
            activeFileSpecs.Add("C129");
            activeFileSpecs.Add("C130");
            activeFileSpecs.Add("C131");
            activeFileSpecs.Add("C137");
            activeFileSpecs.Add("C138");
            activeFileSpecs.Add("C139");
            activeFileSpecs.Add("C141");
            activeFileSpecs.Add("C143");
            activeFileSpecs.Add("C144");
            activeFileSpecs.Add("C145");
            activeFileSpecs.Add("C165");
            activeFileSpecs.Add("C170");
            activeFileSpecs.Add("C175");
            activeFileSpecs.Add("C178");
            activeFileSpecs.Add("C179");
            activeFileSpecs.Add("C185");
            activeFileSpecs.Add("C188");
            activeFileSpecs.Add("C189");
            activeFileSpecs.Add("C190");
            activeFileSpecs.Add("C194");
            activeFileSpecs.Add("C195");
            activeFileSpecs.Add("C196");
            activeFileSpecs.Add("C197");
            activeFileSpecs.Add("C198");
            activeFileSpecs.Add("C207");
            activeFileSpecs.Add("C212");


            var reportYear = currentSubmissionYear;

            if (!activeFileSpecs.Contains(reportCode))
            {
                reportYear = priorSubmissionYear;
            }




            try
            {

                // Set waits
                DefaultWait<IWebDriver> fluentWait60seconds = new DefaultWait<IWebDriver>(_browserFixture.WebDriver);
                fluentWait60seconds.Timeout = TimeSpan.FromSeconds(60);
                fluentWait60seconds.PollingInterval = TimeSpan.FromMilliseconds(2000);
                fluentWait60seconds.IgnoreExceptionTypes(typeof(NoSuchElementException));

                DefaultWait<IWebDriver> fluentWait45seconds = new DefaultWait<IWebDriver>(_browserFixture.WebDriver);
                fluentWait45seconds.Timeout = TimeSpan.FromSeconds(45);
                fluentWait45seconds.PollingInterval = TimeSpan.FromMilliseconds(1500);
                fluentWait45seconds.IgnoreExceptionTypes(typeof(NoSuchElementException));

                DefaultWait<IWebDriver> fluentWait30seconds = new DefaultWait<IWebDriver>(_browserFixture.WebDriver);
                fluentWait30seconds.Timeout = TimeSpan.FromSeconds(30);
                fluentWait30seconds.PollingInterval = TimeSpan.FromMilliseconds(1000);
                fluentWait30seconds.IgnoreExceptionTypes(typeof(NoSuchElementException));

                DefaultWait<IWebDriver> fluentWait10seconds = new DefaultWait<IWebDriver>(_browserFixture.WebDriver);
                fluentWait10seconds.Timeout = TimeSpan.FromSeconds(10);
                fluentWait10seconds.PollingInterval = TimeSpan.FromMilliseconds(250);
                fluentWait10seconds.IgnoreExceptionTypes(typeof(NoSuchElementException));

                DefaultWait<IWebDriver> fluentWait1seconds = new DefaultWait<IWebDriver>(_browserFixture.WebDriver);
                fluentWait1seconds.Timeout = TimeSpan.FromSeconds(1);
                fluentWait1seconds.PollingInterval = TimeSpan.FromMilliseconds(250);
                fluentWait1seconds.IgnoreExceptionTypes(typeof(NoSuchElementException));


                // Select Report Code
                // -------------------------------------------------
                IWebElement reportDropdown = fluentWait10seconds.Until(ExpectedConditions.ElementIsVisible(By.ClassName("generate-app-report-controls__submission")));
                IWebElement reportDropdownControl = reportDropdown.FindElement(By.XPath(".//span[@class='wj-input-group-btn']"));
                reportDropdownControl.Click();

                string reportDropdownOption = @"//div[contains(@class, 'wj-listbox-item') and text()='" + reportCode + "']";
                var reportOption = fluentWait10seconds.Until(d => d.FindElement(By.XPath(reportDropdownOption)));
                reportOption.Click();


                // Wait until selected report is visible   
                // -------------------------------------------------
                fluentWait10seconds.Until(ExpectedConditions.ElementIsVisible(By.ClassName("generate-app-report__title")));

                // Wait for Report Title
                // -------------------------------------------------
                fluentWait10seconds.Until(ExpectedConditions.TextToBePresentInElementLocated(By.ClassName("generate-app-report__title"), reportCode));


                // Select Report Year
                // -------------------------------------------------
                IWebElement reportYearDropdown = fluentWait10seconds.Until(ExpectedConditions.ElementIsVisible(By.ClassName("generate-app-report-controls__year")));
                IWebElement reportYearDropdownControl = reportYearDropdown.FindElement(By.XPath(".//span[@class='wj-input-group-btn']"));
                reportYearDropdownControl.Click();

                string yearDropdownOptionXpath = @"//div[contains(@class, 'wj-listbox-item') and text()='" + reportYear + "']";
                IWebElement reportYearOption = _browserFixture.WebDriver.FindElement(By.XPath(yearDropdownOptionXpath));
                reportYearOption.Click();


                // Wait until selected report is visible   
                // -------------------------------------------------
                fluentWait10seconds.Until(ExpectedConditions.ElementIsVisible(By.ClassName("generate-app-report__title")));


                // Wait for Report Title
                // -------------------------------------------------
                fluentWait10seconds.Until(ExpectedConditions.TextToBePresentInElementLocated(By.ClassName("generate-app-report__title"), reportCode));


                // Select Report Level
                // -------------------------------------------------
                if (reportLevels != null)
                {
                    foreach (var reportLevel in reportLevels)
                    {
                        // Check for report level
                        Assert.True(this._browserFixture.WebDriver.FindElement(By.ClassName("generate-app-report-controls__reportlevel-button-" + reportLevel.ToLower())).Displayed);
                    }

                }



                // Make sure records exist
                // -------------------------------------------------
                var recordsExist = true;

                try
                {
                    fluentWait1seconds.Until(ExpectedConditions.ElementIsVisible(By.Id("generate-app-grid__norecords")));
                    recordsExist = false;
                }
                catch
                {
                    recordsExist = true;
                }

                Assert.True(recordsExist, "Records do not exist");

            }
            catch (WebDriverTimeoutException ex)
            {

                if (ex.InnerException != null)
                {
                    System.Console.WriteLine("FAILED - " + ex.InnerException.GetType().ToString());
                    System.Console.WriteLine(ex.InnerException.Message);

                    if (ex.InnerException.Message.Contains("generate-app-report__title"))
                    {
                        System.Console.WriteLine("Redirecting back to first EDFacts page");
                        _browserFixture.WebDriver.Navigate().GoToUrl(this._browserFixture.TestServer + "/reports/edfacts");
                    }

                    Assert.True(false, ex.InnerException.Message);
                }
                else
                {
                    System.Console.WriteLine("FAILED - " + ex.GetType().ToString());
                    System.Console.WriteLine(ex.Message);
                    Assert.True(false, ex.Message);
                }


            }
            catch (Exception ex)
            {
                // Other unhandled exception occurred

                //System.Console.WriteLine("Redirecting back to first EDFacts page");
                //_browserFixture.WebDriver.Navigate().GoToUrl(this._browserFixture.TestServer + "/reports/edfacts");

                if (ex.InnerException != null)
                {
                    System.Console.WriteLine("FAILED - " + ex.InnerException.GetType().ToString());
                    System.Console.WriteLine(ex.InnerException.Message);
                    Assert.True(false, ex.InnerException.Message);
                }
                else
                {
                    System.Console.WriteLine("FAILED - " + ex.GetType().ToString());
                    System.Console.WriteLine(ex.Message);
                    Assert.True(false, ex.Message);
                }

            }

        }



        #region Tests

        [Fact]
        public void EdFactReports_C002()
        {
            TestReport("C002", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C005()
        {
            TestReport("C005", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C006()
        {
            TestReport("C006", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C007()
        {
            TestReport("C007", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C009()
        {
            TestReport("C009", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C029()
        {
            TestReport("C029", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C032()
        {
            TestReport("C032", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C033()
        {
            TestReport("C033", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C037()
        {
            TestReport("C037", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C039()
        {
            TestReport("C039", new List<string>() { "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C040()
        {
            TestReport("C040", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C045()
        {
            TestReport("C045", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C050()
        {
            TestReport("C050", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C052()
        {
            TestReport("C052", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C054()
        {
            TestReport("C054", new List<string>() { "SEA" });
        }


        [Fact]
        public void EdFactReports_C059()
        {
            TestReport("C059", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C067()
        {
            TestReport("C067", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C070()
        {
            TestReport("C070", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C082()
        {
            TestReport("C082", new List<string>() { "SEA" });
        }

        [Fact]
        public void EdFactReports_C083()
        {
            TestReport("C083", new List<string>() { "SEA" });
        }


        [Fact]
        public void EdFactReports_C088()
        {
            TestReport("C088", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C089()
        {
            TestReport("C089", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C099()
        {
            TestReport("C099", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C103()
        {
            TestReport("C103", new List<string>() { "SCHOOL" });
        }



        [Fact]
        public void EdFactReports_C112()
        {
            TestReport("C112", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C116()
        {
            TestReport("C116", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C118()
        {
            TestReport("C118", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C121()
        {
            TestReport("C121", new List<string>() { "SEA" });
        }

        [Fact]
        public void EdFactReports_C122()
        {
            TestReport("C122", new List<string>() { "SEA" });
        }


        [Fact]
        public void EdFactReports_C126()
        {
            TestReport("C126", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C129()
        {
            TestReport("C129", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C130()
        {
            TestReport("C130", new List<string>() { "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C132()
        {
            TestReport("C132", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C134()
        {
            TestReport("C134", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C137()
        {
            TestReport("C137", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C138()
        {
            TestReport("C138", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C139()
        {
            TestReport("C139", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C141()
        {
            TestReport("C141", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C142()
        {
            TestReport("C142", new List<string>() { "SEA" });
        }

        [Fact]
        public void EdFactReports_C143()
        {
            TestReport("C143", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C144()
        {
            TestReport("C144", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C145()
        {
            TestReport("C145", new List<string>() { "SEA" });
        }


        [Fact]
        public void EdFactReports_C154()
        {
            TestReport("C154", new List<string>() { "SEA" });
        }

        [Fact]
        public void EdFactReports_C155()
        {
            TestReport("C155", new List<string>() { "SEA" });
        }

        [Fact]
        public void EdFactReports_C156()
        {
            TestReport("C156", new List<string>() { "SEA" });
        }

        [Fact]
        public void EdFactReports_C157()
        {
            TestReport("C157", new List<string>() { "SEA" });
        }

        [Fact]
        public void EdFactReports_C158()
        {
            TestReport("C158", new List<string>() { "SEA" });
        }




        [Fact]
        public void EdFactReports_C165()
        {
            TestReport("C165", new List<string>() { "SCHOOL" });
        }



        [Fact]
        public void EdFactReports_C169()
        {
            TestReport("C169", new List<string>() { "SEA" });
        }

        [Fact]
        public void EdFactReports_C170()
        {
            TestReport("C170", new List<string>() { "LEA" });
        }

        [Fact]
        public void EdFactReports_C175()
        {
            TestReport("C175", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C178()
        {
            TestReport("C178", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C179()
        {
            TestReport("C179", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C185()
        {
            TestReport("C185", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C188()
        {
            TestReport("C188", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C189()
        {
            TestReport("C189", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C190()
        {
            TestReport("C190", new List<string>() { "CAO" });
        }


        [Fact]
        public void EdFactReports_C193()
        {
            TestReport("C193", new List<string>() { "LEA" });
        }

        [Fact]
        public void EdFactReports_C194()
        {
            TestReport("C194", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C195()
        {
            TestReport("C195", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C196()
        {
            TestReport("C196", new List<string>() { "CMO" });
        }

        [Fact]
        public void EdFactReports_C197()
        {
            TestReport("C197", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C198()
        {
            TestReport("C198", new List<string>() { "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C204()
        {
            TestReport("C204", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C205()
        {
            TestReport("C205", new List<string>() { "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C086()
        {
            TestReport("C086", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C131()
        {
            TestReport("C131", new List<string>() { "LEA" });
        }


        [Fact]
        public void EdFactReports_C150()
        {
            TestReport("C150", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C151()
        {
            TestReport("C151", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C160()
        {
            TestReport("C160", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C163()
        {
            TestReport("C163", new List<string>() { "LEA", "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C113()
        {
            TestReport("C113", new List<string>() { "SEA" });
        }


        [Fact]
        public void EdFactReports_C119()
        {
            TestReport("C119", new List<string>() { "SEA" });
        }


        [Fact]
        public void EdFactReports_C125()
        {
            TestReport("C125", new List<string>() { "LEA" });
        }


        [Fact]
        public void EdFactReports_C127()
        {
            TestReport("C127", new List<string>() { "LEA" });
        }


        [Fact]
        public void EdFactReports_C180()
        {
            TestReport("C180", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C181()
        {
            TestReport("C181", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C200()
        {
            TestReport("C200", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C201()
        {
            TestReport("C201", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C202()
        {
            TestReport("C202", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C203()
        {
            TestReport("C203", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C206()
        {
            TestReport("C206", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C207()
        {
            TestReport("C207", new List<string>() { "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C199()
        {
            TestReport("C199", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C035()
        {
            TestReport("C035", new List<string>() { "SEA", "LEA" });
        }

        #endregion



    }
}
