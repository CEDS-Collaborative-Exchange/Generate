using generate.test.UserInterface.Fixtures;
using OpenQA.Selenium;
using OpenQA.Selenium.Support.UI;
using SeleniumExtras.WaitHelpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xunit;
using Xunit.Sdk;

namespace generate.test.UserInterface.Reports
{
    [Collection("AcceptanceTestsCollection")]
    [Trait("Category", "UserInterface")]
    public class StateReportTests : IClassFixture<StateBrowserFixture>
    {
        private readonly StateBrowserFixture _browserFixture;

        public StateReportTests(StateBrowserFixture browserFixture)
        {
            _browserFixture = browserFixture;
        }


        /// <summary>
        /// Test Report
        /// </summary>
        private void TestReport(string reportLevel, string reportCode)
        {

            System.Console.WriteLine("StateReports_" + reportCode);

            try
            {


                // Set waits
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


                // Navigate to reports library
                _browserFixture.WebDriver.Navigate().GoToUrl(this._browserFixture.TestServer + "/reports/library");

                // Wait until list of reports is available
                fluentWait45seconds.Until(ExpectedConditions.ElementToBeClickable(By.TagName("generate-app-reports-library")));


                IWebElement reportButton = fluentWait30seconds.Until(ExpectedConditions.ElementToBeClickable(By.Id("view_" + reportLevel + "_" + reportCode)));
                reportButton.Click();

                // Wait for report controls
                fluentWait30seconds.Until(ExpectedConditions.ElementIsVisible(By.ClassName("generate-app-report-controls")));

                Assert.True(this._browserFixture.WebDriver.FindElement(By.ClassName("generate-app-report-controls")).Displayed);

                // Make sure records exist
                // -------------------------------------------------
                var recordsExist = true;

                try
                {
                    fluentWait10seconds.Until(ExpectedConditions.ElementIsVisible(By.Id("generate-app-grid__norecords")));
                    recordsExist = false;
                }
                catch
                {
                    recordsExist = true;
                }

                Assert.True(recordsExist, "Records do not exist");


            }
            catch (TrueException ex)
            {

                System.Console.WriteLine("Redirecting back to first report page");
                _browserFixture.WebDriver.Navigate().GoToUrl(this._browserFixture.TestServer + "/reports/library");

                // Test failure explicitly called
                System.Console.WriteLine("FAILED - " + ex.GetType().ToString());
                System.Console.WriteLine(ex.Message);
                Assert.True(false, ex.Message);
            }
            catch (WebDriverTimeoutException ex)
            {

                System.Console.WriteLine("Redirecting back to first report page");
                _browserFixture.WebDriver.Navigate().GoToUrl(this._browserFixture.TestServer + "/reports/library");

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
            catch (Exception ex)
            {
                // Other unhandled exception occurred

                System.Console.WriteLine("Redirecting back to first report page");
                _browserFixture.WebDriver.Navigate().GoToUrl(this._browserFixture.TestServer + "/reports/library");

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


        ///////////////////
        // Disabled for now because Reports Library is too slow for automated UI tests
        ///////////////////

        #region Tests

        [Fact]
        public void StateReports_ExitSpecialEducation()
        {

            TestReport("sea", "exitspecialeducation");

        }


        [Fact]
        public void StateReports_CohortGraduationRate()
        {

            TestReport("sea", "cohortgraduationrate");

        }


        [Fact]
        public void StateReports_StudentFederalProgramsParticipation()
        {

            TestReport("sea", "studentfederalprogramsparticipation");

        }

        [Fact]
        public void StateReports_StudentMultipleFederalProgramsParticipation()
        {

            TestReport("sea", "studentmultifedprogsparticipation");

        }

        [Fact]
        public void StateReports_DisciplinaryRemovals()
        {

            TestReport("sea", "disciplinaryremovals");

        }

        [Fact]
        public void StateReports_StateAssessmentProficiency()
        {

            TestReport("sea", "stateassessmentsperformance");

        }

        [Fact]
        public void StateReports_PreschoolersEDEnvDiabilities()
        {

            TestReport("sea", "edenvironmentdisabilitiesage3-5");

        }

        [Fact]
        public void StateReports_SchoolAgeStudentsEDEnvDiabilities()
        {

            TestReport("sea", "edenvironmentdisabilitiesage6-21");

        }

        [Fact]
        public void DataQualityReports_YearToYearChildCountReport()
        {

            TestReport("sea", "yeartoyearchildcount");

        }

        [Fact]
        public void DataQualityReports_YearToYearEnvironmentCountReport()
        {

            TestReport("sea", "yeartoyearenvironmentcount");

        }

        [Fact]
        public void DataQualityReports_YearToYearExitCountReport()
        {

            TestReport("sea", "yeartoyearexitcount");

        }

        //[Fact]
        //public void DataQualityReports_LEAStudentsSummaryProfile()
        //{

        //    TestReport("lea", "studentssummary");

        //}

        //[Fact]
        //public void DataQualityReports_SEAYearToyearRemovalCountReport()
        //{

        //    TestReport("sea", "yeartoyearremovalcount");

        //}

        #endregion



    }
}
