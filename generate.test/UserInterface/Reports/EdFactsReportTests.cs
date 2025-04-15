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

            if (reportCode == "035")
            {
                currentSubmissionYear = "2019";
                priorSubmissionYear = "2018";
            }

            List<string> activeFileSpecs = new List<string>();

            activeFileSpecs.Add("002");
            activeFileSpecs.Add("005");
            activeFileSpecs.Add("006");
            activeFileSpecs.Add("007");
            activeFileSpecs.Add("009");
            activeFileSpecs.Add("029");
            activeFileSpecs.Add("033");
            activeFileSpecs.Add("035");
            activeFileSpecs.Add("039");
            activeFileSpecs.Add("045");
            activeFileSpecs.Add("050");
            activeFileSpecs.Add("052");
            activeFileSpecs.Add("054");
            activeFileSpecs.Add("059");
            activeFileSpecs.Add("067");
            activeFileSpecs.Add("070");
            activeFileSpecs.Add("086");
            activeFileSpecs.Add("088");
            activeFileSpecs.Add("089");
            activeFileSpecs.Add("099");
            activeFileSpecs.Add("103");
            activeFileSpecs.Add("112");
            activeFileSpecs.Add("116");
            activeFileSpecs.Add("118");
            activeFileSpecs.Add("121");
            activeFileSpecs.Add("122");
            activeFileSpecs.Add("126");
            activeFileSpecs.Add("129");
            activeFileSpecs.Add("130");
            activeFileSpecs.Add("131");
            activeFileSpecs.Add("137");
            activeFileSpecs.Add("138");
            activeFileSpecs.Add("139");
            activeFileSpecs.Add("141");
            activeFileSpecs.Add("143");
            activeFileSpecs.Add("144");
            activeFileSpecs.Add("145");
            activeFileSpecs.Add("165");
            activeFileSpecs.Add("170");
            activeFileSpecs.Add("175");
            activeFileSpecs.Add("178");
            activeFileSpecs.Add("179");
            activeFileSpecs.Add("185");
            activeFileSpecs.Add("188");
            activeFileSpecs.Add("189");
            activeFileSpecs.Add("190");
            activeFileSpecs.Add("194");
            activeFileSpecs.Add("195");
            activeFileSpecs.Add("196");
            activeFileSpecs.Add("197");
            activeFileSpecs.Add("198");
            activeFileSpecs.Add("207");
            activeFileSpecs.Add("212");


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
            TestReport("002", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C005()
        {
            TestReport("005", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C006()
        {
            TestReport("006", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C007()
        {
            TestReport("007", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C009()
        {
            TestReport("009", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C029()
        {
            TestReport("029", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C032()
        {
            TestReport("032", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C033()
        {
            TestReport("033", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C037()
        {
            TestReport("037", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C039()
        {
            TestReport("039", new List<string>() { "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C040()
        {
            TestReport("040", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C045()
        {
            TestReport("045", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C050()
        {
            TestReport("050", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C052()
        {
            TestReport("052", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C054()
        {
            TestReport("054", new List<string>() { "SEA" });
        }


        [Fact]
        public void EdFactReports_C059()
        {
            TestReport("059", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C067()
        {
            TestReport("067", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C070()
        {
            TestReport("070", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C082()
        {
            TestReport("082", new List<string>() { "SEA" });
        }

        [Fact]
        public void EdFactReports_C083()
        {
            TestReport("083", new List<string>() { "SEA" });
        }


        [Fact]
        public void EdFactReports_C088()
        {
            TestReport("088", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C089()
        {
            TestReport("089", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C099()
        {
            TestReport("099", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C103()
        {
            TestReport("103", new List<string>() { "SCHOOL" });
        }



        [Fact]
        public void EdFactReports_C112()
        {
            TestReport("112", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C116()
        {
            TestReport("116", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C118()
        {
            TestReport("118", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C121()
        {
            TestReport("121", new List<string>() { "SEA" });
        }

        [Fact]
        public void EdFactReports_C122()
        {
            TestReport("122", new List<string>() { "SEA" });
        }


        [Fact]
        public void EdFactReports_C126()
        {
            TestReport("126", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C129()
        {
            TestReport("129", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C130()
        {
            TestReport("130", new List<string>() { "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C132()
        {
            TestReport("132", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C134()
        {
            TestReport("134", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C137()
        {
            TestReport("137", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C138()
        {
            TestReport("138", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C139()
        {
            TestReport("139", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C141()
        {
            TestReport("141", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C142()
        {
            TestReport("142", new List<string>() { "SEA" });
        }

        [Fact]
        public void EdFactReports_C143()
        {
            TestReport("143", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C144()
        {
            TestReport("144", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C145()
        {
            TestReport("145", new List<string>() { "SEA" });
        }


        [Fact]
        public void EdFactReports_C154()
        {
            TestReport("154", new List<string>() { "SEA" });
        }

        [Fact]
        public void EdFactReports_C155()
        {
            TestReport("155", new List<string>() { "SEA" });
        }

        [Fact]
        public void EdFactReports_C156()
        {
            TestReport("156", new List<string>() { "SEA" });
        }

        [Fact]
        public void EdFactReports_C157()
        {
            TestReport("157", new List<string>() { "SEA" });
        }

        [Fact]
        public void EdFactReports_C158()
        {
            TestReport("158", new List<string>() { "SEA" });
        }




        [Fact]
        public void EdFactReports_C165()
        {
            TestReport("165", new List<string>() { "SCHOOL" });
        }



        [Fact]
        public void EdFactReports_C169()
        {
            TestReport("169", new List<string>() { "SEA" });
        }

        [Fact]
        public void EdFactReports_C170()
        {
            TestReport("170", new List<string>() { "LEA" });
        }

        [Fact]
        public void EdFactReports_C175()
        {
            TestReport("175", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C178()
        {
            TestReport("178", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C179()
        {
            TestReport("179", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C185()
        {
            TestReport("185", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C188()
        {
            TestReport("188", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C189()
        {
            TestReport("189", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C190()
        {
            TestReport("190", new List<string>() { "CAO" });
        }


        [Fact]
        public void EdFactReports_C193()
        {
            TestReport("193", new List<string>() { "LEA" });
        }

        [Fact]
        public void EdFactReports_C194()
        {
            TestReport("194", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C195()
        {
            TestReport("195", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C196()
        {
            TestReport("196", new List<string>() { "CMO" });
        }

        [Fact]
        public void EdFactReports_C197()
        {
            TestReport("197", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C198()
        {
            TestReport("198", new List<string>() { "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C204()
        {
            TestReport("204", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C205()
        {
            TestReport("205", new List<string>() { "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C086()
        {
            TestReport("086", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C131()
        {
            TestReport("131", new List<string>() { "LEA" });
        }


        [Fact]
        public void EdFactReports_C150()
        {
            TestReport("150", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C151()
        {
            TestReport("151", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C160()
        {
            TestReport("160", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C163()
        {
            TestReport("163", new List<string>() { "LEA", "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C113()
        {
            TestReport("113", new List<string>() { "SEA" });
        }


        [Fact]
        public void EdFactReports_C119()
        {
            TestReport("119", new List<string>() { "SEA" });
        }


        [Fact]
        public void EdFactReports_C125()
        {
            TestReport("125", new List<string>() { "LEA" });
        }


        [Fact]
        public void EdFactReports_C127()
        {
            TestReport("C127", new List<string>() { "LEA" });
        }


        [Fact]
        public void EdFactReports_C180()
        {
            TestReport("180", new List<string>() { "SEA", "LEA" });
        }

        [Fact]
        public void EdFactReports_C181()
        {
            TestReport("181", new List<string>() { "SEA", "LEA" });
        }


        [Fact]
        public void EdFactReports_C200()
        {
            TestReport("200", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C201()
        {
            TestReport("201", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C202()
        {
            TestReport("202", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C203()
        {
            TestReport("203", new List<string>() { "SEA", "LEA", "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C206()
        {
            TestReport("206", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C207()
        {
            TestReport("207", new List<string>() { "SCHOOL" });
        }


        [Fact]
        public void EdFactReports_C199()
        {
            TestReport("199", new List<string>() { "SCHOOL" });
        }

        [Fact]
        public void EdFactReports_C035()
        {
            TestReport("035", new List<string>() { "SEA", "LEA" });
        }

        #endregion



    }
}
